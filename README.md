# Harish Krishna — Blog

Personal blog built with [Hugo](https://gohugo.io/) + [PaperMod](https://github.com/adityatelange/hugo-PaperMod).

## Quick start

```bash
# Install Hugo (extended) — https://gohugo.io/installation/
# Then:
hugo server -D  # dev server with drafts at http://localhost:1313
```

## 📝 Writing posts

```bash
hugo new content posts/my-new-post.md
# → creates content/posts/my-new-post.md with frontmatter
```

## 📦 Build & deploy

```bash
hugo --minify    # outputs to public/
```

Deployment: **GitHub Actions** (`.github/workflows/deploy.yml`).  
Push to `main` → auto-builds → deploys to GitHub Pages → `harishkrishna.me`.

## 🪴 Publishing from Obsidian

### Option A: Content inside your vault (recommended)

1. Clone the repo on your machine:
   ```bash
   git clone git@github.com:themeteoragent-coder/harishkrishna-blog.git
   ```
2. In Obsidian, open the `content/` folder as part of your **existing vault** — or create a dedicated vault at the repo root and add `content/` as a [linked vault](https://help.obsidian.md/Files+and+folders/Manage+vaults#Link+vaults).
3. Create posts in `content/posts/` as plain Markdown.

**Rules for Obsidian compatibility:**
- ❌ Turn **off** `[[Wikilinks]]` in Obsidian settings for this vault (or use `Settings → Files & Links → Use [[Wikilinks]]` → off)
- ✅ Use standard Markdown links: `[link text](url)`
- ✅ Use standard Markdown images: `![alt](image.png)`
- ✅ Frontmatter (the `---` block) works identically in both
- ✅ Tags in frontmatter → Hugo taxonomy pages (`/tags/`)

### Option B: Dedicated Obsidian vault

1. Open the **entire repo folder** as an Obsidian vault
2. Create a `Templates/` folder and add a post template:
   ```md
   ---
   title: "{{title}}"
   description: ""
   date: {{date}}
   draft: true
   tags: []
   ---
   ```
3. Use `Ctrl/Cmd+P` → `Templates: Insert template` for new posts

### Option C: Obsidian to Hugo sync script

For advanced users who want to keep `[[wikilinks]]` on:
- Use the [Obsidian to Hugo](https://github.com/danzid/obsidian-to-hugo) community plugin
- Or a pre-commit hook that converts `[[links]]` to Markdown links

### Workflow

```
Write in Obsidian → Git commit → Git push → GitHub Action builds → Site live
```

1. Write a post in Obsidian in `content/posts/`
2. When ready to publish, set `draft: false` in frontmatter
3. `git add -A && git commit -m "New post: [title]" && git push`
4. Site auto-deploys in ~30 seconds

## 🚀 Deploy from a new machine

```bash
git clone git@github.com:themeteoragent-coder/harishkrishna-blog.git
cd harishkrishna-blog
hugo server -D
```

## 🔧 DNS setup

For `harishkrishna.me` pointing to GitHub Pages:

| Type  | Name              | Value                          |
|-------|-------------------|--------------------------------|
| A     | `@`               | `185.199.108.153`              |
| A     | `@`               | `185.199.109.153`              |
| A     | `@`               | `185.199.110.153`              |
| A     | `@`               | `185.199.111.153`              |
| CNAME | `www`             | `themeteoragent-coder.github.io.` |

Then enable **Enforce HTTPS** in GitHub Pages settings.

## Tech

- **Generator:** [Hugo](https://gohugo.io/) (extended v0.164+)
- **Theme:** [PaperMod](https://github.com/adityatelange/hugo-PaperMod)
- **Hosting:** GitHub Pages
- **CI/CD:** GitHub Actions
- **Writing:** Obsidian (Markdown)
