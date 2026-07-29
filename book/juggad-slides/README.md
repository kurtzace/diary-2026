# Jugaad Innovation Slides

A Reveal.js presentation on "Jugaad Innovation: Frugal, Flexible & Fast Innovation" based on the book by Navi Radjou, Jaydeep Prabhu & Sumona Ahuja.

## 🌐 Hosted Version

View online: **https://kurtzace.github.io/diary-2026/jugaad-slides/**

## Quick Start

### Option 1: Open Directly
Simply open `index.html` in your web browser.

### Option 2: Local Server (Recommended)
For best results with speaker notes and advanced features:

```bash
cd /Users/karabhan/code/hackathon/public-diary-2026/book/juggad-slides
python -m http.server 8000
# Then visit http://localhost:8000
```

Or with Node.js http-server:
```bash
npx http-server
```

## Navigation

- **Arrow Keys / Space**: Navigate through slides
- **ESC**: Open slide overview
- **S**: Open speaker notes
- **B**: Pause/Blackout screen
- **F**: Enter fullscreen
- **F1**: Help menu

## Slide Structure

1. **Title & Overview** - Introduction to Jugaad
2. **6 Core Principles** (Sections with subsections):
   - Seek Opportunity in Adversity
   - Do More with Less
   - Think & Act Flexibly
   - Keep It Simple
   - Include the Margin
   - Follow Your Heart
3. **Integration & Scale** - Making jugaad systemic
4. **Building Jugaad Nations** - Global adoption
5. **Challenge & Resources**

## Features

- **Blue highlights** - Key concepts
- **Green text** - Impact/outcomes
- **Example boxes** - Real-world case studies
- **Speaker notes** - Hidden detailed information (press S)
- **Responsive design** - Works on different screen sizes

## Customization

### Change Theme
Edit the theme link in `<head>`:
```html
<!-- Options: black, white, league, sky, beige, simple, serif, blood, night, moon, solarized -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/reveal.js/4.5.0/theme/white.min.css">
```

### Modify Colors
Edit the `<style>` section:
- `.highlight` - Key concept color (currently blue #42affa)
- `.impact` - Impact text color (currently green #a6e22e)
- `.example` - Example box styling

## Reveal.js Documentation

For advanced features, see: https://revealjs.com/

## Content Sources

- Main source: `../juggad-innovation.md`
- Stanford Design for Extreme Affordability program
- Real-world examples from Indian & global innovators

## Tips for Presentation

1. **Practice navigation** - Vertical scrolling within sections, horizontal for main topics
2. **Use speaker view** - Press 'S' on presenter screen for notes and timer
3. **Offline capable** - All Reveal.js and CSS loaded via CDN
4. **Share easily** - Can be hosted on any web server or GitHub Pages

Enjoy the presentation!
