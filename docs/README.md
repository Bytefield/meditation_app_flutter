# Rago Meditation App Documentation

This directory contains the source files for the Rago Meditation App documentation, which is built using [MkDocs](https://www.mkdocs.org/) and hosted on GitHub Pages.

## Viewing the Documentation

The documentation is automatically published to GitHub Pages at:
https://bytefield.github.io/rago_enterprises/

## Local Development

To preview the documentation locally before pushing changes:

1. Install the required dependencies:
   ```bash
   pip install mkdocs mkdocs-material mkdocs-redirects
   ```

2. Serve the documentation locally:
   ```bash
   mkdocs serve
   ```

3. Open http://127.0.0.1:8000 in your browser to view the documentation.

## Documentation Structure

- `.github/wiki/` - Source Markdown files for the documentation
- `mkdocs.yml` - Configuration file for MkDocs
- `.github/workflows/gh-pages.yml` - GitHub Actions workflow for building and deploying the documentation

## Adding New Content

1. Add your Markdown files to the appropriate directory in `.github/wiki/`
2. Update the navigation in `mkdocs.yml` if you've added new sections
3. Commit and push your changes to the `main` branch
4. The documentation will be automatically built and deployed by GitHub Actions

## Documentation Guidelines

- Use Markdown for all content
- Follow the existing style and structure
- Include code examples where applicable
- Keep documentation up-to-date with code changes
- Use relative links for internal documentation references

## Troubleshooting

If the documentation fails to build:

1. Check the GitHub Actions workflow run for errors
2. Verify that all Markdown files are properly formatted
3. Ensure all links in `mkdocs.yml` point to existing files
4. Run `mkdocs build --strict` locally to catch any errors before pushing
