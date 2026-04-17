own personal AWS S3 + CloudFront infrastructure for clipboard uploads:

## 🎯 **Personal AWS Setup for Clipboard Uploads**

### **Prerequisites**
- Personal AWS account  
- AWS CLI installed and configured (`aws configure`)
- `pngpaste` tool (already installed)

---

## **Step 1: Create S3 Bucket**

```bash
# 1.1 Create uniquely named bucket
BUCKET_NAME="screenshots-$(whoami)-$(date +%Y%m%d)"
AWS_REGION="us-west-2"  # Choose your region
aws s3 mb s3://$BUCKET_NAME --region $AWS_REGION

# 1.2 Enable public access
aws s3api put-public-access-block \
    --bucket $BUCKET_NAME \
    --public-access-block-configuration \
    BlockPublicAcls=false,IgnorePublicAcls=false,BlockPublicPolicy=false,RestrictPublicBuckets=false

# 1.3 Create public read policy
cat > /tmp/bucket-policy.json << EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::$BUCKET_NAME/*"
        }
    ]
}
EOF

aws s3api put-bucket-policy --bucket $BUCKET_NAME --policy file:///tmp/bucket-policy.json
```

---

## **Step 2: Create CloudFront Distribution**

```bash
# 2.1 Create CloudFront configuration
cat > /tmp/cloudfront-config.json << EOF
{
    "CallerReference": "$(date +%s)",
    "Comment": "CloudFront for $BUCKET_NAME screenshots",
    "DefaultCacheBehavior": {
        "TargetOriginId": "$BUCKET_NAME-origin",
        "ViewerProtocolPolicy": "redirect-to-https",
        "TrustedSigners": {
            "Enabled": false,
            "Quantity": 0
        },
        "ForwardedValues": {
            "QueryString": false,
            "Cookies": {"Forward": "none"}
        },
        "MinTTL": 0,
        "DefaultTTL": 86400,
        "MaxTTL": 31536000
    },
    "Origins": {
        "Quantity": 1,
        "Items": [{
            "Id": "$BUCKET_NAME-origin",
            "DomainName": "$BUCKET_NAME.s3.$AWS_REGION.amazonaws.com",
            "S3OriginConfig": {
                "OriginAccessIdentity": ""
            }
        }]
    },
    "Enabled": true,
    "PriceClass": "PriceClass_100"
}
EOF

# 2.2 Create distribution
DISTRIBUTION_ID=$(aws cloudfront create-distribution \
    --distribution-config file:///tmp/cloudfront-config.json \
    --query 'Distribution.Id' --output text)

CLOUDFRONT_DOMAIN=$(aws cloudfront get-distribution \
    --id $DISTRIBUTION_ID \
    --query 'Distribution.DomainName' --output text)

echo "✅ CloudFront Distribution ID: $DISTRIBUTION_ID"
echo "✅ CloudFront Domain: https://$CLOUDFRONT_DOMAIN"

# 2.3 Wait for deployment (5-15 minutes)
echo "⏳ Waiting for CloudFront deployment..."
aws cloudfront wait distribution-deployed --id $DISTRIBUTION_ID
echo "🎉 CloudFront distribution is ready!"
```

---

## **Step 3: Create Your Personal Upload Function**

```bash
# Add to ~/.zshrc
cat >> ~/.zshrc << EOF

# Personal AWS S3 Clipboard Upload Function
export PERSONAL_S3_BUCKET="$BUCKET_NAME"
export PERSONAL_CLOUDFRONT_DOMAIN="$CLOUDFRONT_DOMAIN"

function s3paste_personal() {
    local filename="screenshot-\$(date +%Y%m%d-%H%M%S).png"
    local username="\$(whoami)"
    if pngpaste - | aws s3 cp - s3://\$PERSONAL_S3_BUCKET/screenshots/\$username/\$filename --content-type "image/png"; then
        local url="https://\$PERSONAL_CLOUDFRONT_DOMAIN/screenshots/\$username/\$filename"
        echo "\$url" | pbcopy
        echo "✅ Uploaded! URL copied to clipboard:"
        echo "\$url"
    else
        echo "❌ Failed to upload clipboard image"
    fi
}
EOF

# Reload shell
source ~/.zshrc
```

---

## **Step 4: Test Your Setup**

```bash
# Test the function
echo "1. Take screenshot: Cmd+Shift+Ctrl+4"
echo "2. Run: s3paste_personal"
echo "3. URL will be copied to clipboard automatically!"

# Manual test
echo "Testing bucket access..."
echo "test-$(date)" | aws s3 cp - s3://$BUCKET_NAME/test.txt
curl -s "https://$CLOUDFRONT_DOMAIN/test.txt" && echo " ✅ CDN working!"
```

---

## **Step 5: Security Enhancement (Recommended)**

```bash
# Create limited IAM user for uploads only
cat > /tmp/s3-upload-policy.json << EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": ["s3:PutObject", "s3:PutObjectAcl"],
            "Resource": "arn:aws:s3:::$BUCKET_NAME/screenshots/*"
        }
    ]
}
EOF

# Create IAM user
aws iam create-user --user-name screenshot-uploader
POLICY_ARN=$(aws iam create-policy \
    --policy-name ScreenshotUploadPolicy \
    --policy-document file:///tmp/s3-upload-policy.json \
    --query 'Policy.Arn' --output text)
aws iam attach-user-policy --user-name screenshot-uploader --policy-arn $POLICY_ARN

# Create access keys
aws iam create-access-key --user-name screenshot-uploader

# Configure AWS profile
aws configure --profile screenshots
# Enter the access key and secret from above

# Update function to use specific profile
function s3paste_personal() {
    local filename="screenshot-$(date +%Y%m%d-%H%M%S).png"
    local username="$(whoami)"
    if pngpaste - | aws s3 cp - s3://$PERSONAL_S3_BUCKET/screenshots/$username/$filename --content-type "image/png" --profile screenshots; then
        local url="https://$PERSONAL_CLOUDFRONT_DOMAIN/screenshots/$username/$filename"
        echo "$url" | pbcopy
        echo "✅ Uploaded! URL copied to clipboard:"
        echo "$url"
    else
        echo "❌ Failed to upload clipboard image"
    fi
}
```

---

## **Step 6: Optional Enhancements**

### **Auto-cleanup (90 days)**
```bash
cat > /tmp/lifecycle-policy.json << EOF
{
    "Rules": [{
        "ID": "DeleteOldScreenshots",
        "Status": "Enabled",
        "Filter": {"Prefix": "screenshots/"},
        "Expiration": {"Days": 90}
    }]
}
EOF

aws s3api put-bucket-lifecycle-configuration \
    --bucket $BUCKET_NAME \
    --lifecycle-configuration file:///tmp/lifecycle-policy.json
```

### **Save configuration**
```bash
cat > ~/my-screenshot-setup.txt << EOF
Personal Screenshot Setup:
Bucket: $BUCKET_NAME
CloudFront: https://$CLOUDFRONT_DOMAIN
Distribution ID: $DISTRIBUTION_ID
Region: $AWS_REGION
Created: $(date)
EOF

echo "✅ Configuration saved to ~/my-screenshot-setup.txt"
```

---

## **💰 Cost Estimation**

**Typical monthly cost for personal use** (~100 screenshots, 500KB each):
- **S3 Storage**: ~$0.01 (50MB × $0.023/GB)
- **S3 PUT requests**: ~$0.00004 (100 × $0.0004/1000)  
- **CloudFront**: ~$0.002 (50MB × $0.085/GB)
- **Total**: **~$0.50/month**

---

## **🎉 You're Done!**

**Usage:**
1. Take screenshot: `Cmd+Shift+Ctrl+4`
2. Run: `s3paste_personal` 
3. Shareable URL automatically copied to clipboard!

**Your URLs will look like:**  
`https://d1abc2def3ghi4.cloudfront.net/screenshots/yourname/screenshot-20260417-061234.png`

This gives you the same GitHub-issue-like experience but with your own infrastructure that works anywhere! 🚀

Similar code found with 2 license types
