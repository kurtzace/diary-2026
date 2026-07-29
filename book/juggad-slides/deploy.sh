#!/bin/bash

# Jugaad Slides - Quick Deploy Commands

# Navigate to repository
cd /Users/karabhan/code/hackathon/public-diary-2026

# Stage the slides changes
git add book/juggad-slides/
git add .github/workflows/deploy-jugaad-slides.yml
git add DEPLOYMENT.md

# Commit changes
git commit -m "feat: Add Jugaad Innovation Reveal.js slides with GitHub Pages deployment

- Create comprehensive Reveal.js presentation (40+ slides)
- Add GitHub Actions workflow for automated deployment
- Configure for hosting at https://kurtzace.github.io/diary-2026/jugaad-slides/
- Include deployment guide and documentation"

# Push to remote repository (will trigger GitHub Actions)
git push origin main

# View deployment status (in GitHub web interface)
echo "✅ Deployment triggered!"
echo "📊 Monitor progress: https://github.com/kurtzace/diary-2026/actions"
echo "🌐 View slides: https://kurtzace.github.io/diary-2026/jugaad-slides/"
