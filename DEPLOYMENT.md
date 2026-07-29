# GitHub Pages Deployment Guide

## Setup Instructions

### Prerequisites
- GitHub account with push access to `kurtzace/diary-2026` repository
- Git installed locally

### Configuration

The deployment is automated via GitHub Actions. The workflow file is located at:
```
.github/workflows/deploy-jugaad-slides.yml
```

**How it works:**
- The workflow creates a `_site` directory
- Copies jugaad-slides content to `_site/jugaad-slides/`
- Deploys the entire `_site` folder to GitHub Pages
- This ensures the slides are available at the `/jugaad-slides/` subdirectory path

**Trigger:** The workflow automatically deploys when:
- Changes are pushed to `main` or `master` branch
- Changes affect `book/juggad-slides/**` files
- Manual trigger via `workflow_dispatch`

### GitHub Pages Settings

1. Go to **repository Settings → Pages**
2. Verify **Build and deployment** is set to:
   - **Source:** `Deploy from a branch`
   - **Branch:** `gh-pages` (auto-created by workflow)
   - **Folder:** `/ (root)`

### Deployment Steps

#### 1. Push Changes to Repository
```bash
cd /Users/karabhan/code/hackathon/public-diary-2026
git add book/juggad-slides/
git commit -m "Update jugaad innovation slides"
git push origin main
```

#### 2. Monitor Deployment
- Go to repository **Actions** tab
- Watch for `Deploy slides to GitHub Pages` workflow
- Wait for status: ✅ Success

#### 3. Access Live Presentation
Once deployed:
- **URL:** https://kurtzace.github.io/diary-2026/jugaad-slides/
- **Speaker Notes:** Press 'S' while viewing
- **Presentation Mode:** Press 'F' for fullscreen

## Manual Deployment (Alternative)

If automated workflow fails, you can deploy manually:

```bash
# Clone if needed
git clone https://github.com/kurtzace/diary-2026.git
cd diary-2026

# Create orphan gh-pages branch (first time only)
git checkout --orphan gh-pages
git rm -rf .

# Copy slides content
cp -r book/juggad-slides/* .
git add .
git commit -m "Deploy jugaad slides to GitHub Pages"
git push origin gh-pages

# Return to main branch
git checkout main
```

## Troubleshooting

### Slides not loading (404 errors)
- Check that `book/juggad-slides/index.html` exists
- Verify `.nojekyll` file is present
- Wait 1-2 minutes for GitHub Pages to rebuild

### Styles not loading
- Slides use CDN for Reveal.js and CSS (no build needed)
- Check browser console for blocked resources
- Clear browser cache and reload

### Workflow not triggering
- Verify branch is `main` or `master`
- Check workflow file syntax: `.github/workflows/deploy-jugaad-slides.yml`
- Manually trigger via **Actions → Deploy Jugaad Slides → Run workflow**

## Project Structure
```
diary-2026/
├── .github/
│   └── workflows/
│       └── deploy-jugaad-slides.yml    ← Deployment automation
├── book/
│   └── juggad-slides/
│       ├── index.html                  ← Main presentation
│       ├── README.md                   ← This file
│       └── .nojekyll                   ← Disable Jekyll processing
└── [other content]
```

## Customization After Deployment

### Update Presentation Content
1. Edit `index.html` or add new slides
2. Commit and push to `main`
3. Workflow automatically deploys within 2-3 minutes

### Change Theme
Edit the theme link in `index.html`:
```html
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/reveal.js/4.5.0/theme/[theme].min.css">
```
Available themes: `black`, `white`, `league`, `sky`, `beige`, `simple`, `serif`, `blood`, `night`, `moon`, `solarized`

### Add Speaker Notes
Wrap notes in `<aside class="notes">` tags:
```html
<aside class="notes">
  Your speaker notes here. Press 'S' to view.
</aside>
```

## Useful Links
- [Reveal.js Documentation](https://revealjs.com/)
- [GitHub Pages Docs](https://docs.github.com/en/pages)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)

## Next Steps
1. Verify workflow is in `.github/workflows/deploy-jugaad-slides.yml`
2. Push slides to repository
3. Check GitHub Actions for successful deployment
4. Visit https://kurtzace.github.io/diary-2026/jugaad-slides/
