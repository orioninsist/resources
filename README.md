# Resources

Personal Markdown notes and references.

- [Browse the index](resources-index.md)

## Tracking rules

This repo is allowlist-based:

- Root files tracked by Git: `.gitignore`, `README.md`, `resources-index.md`, `resources-index.sh`
- Markdown files are tracked only inside the source folders listed in `.gitignore`
- Everything else is ignored, including Markdown files inside backup, data, archive, export, or temporary folders

When adding a new Markdown source folder, add three lines to `.gitignore`:

```gitignore
!/folder-name/
!/folder-name/**/
!/folder-name/**/*.md
```

`resources-index.sh` reads this allowlist from `.gitignore` automatically.

The index keeps large folders readable. By default, it lists up to 100 Markdown
files per folder and summarizes the rest. Override the limit when needed:

```sh
RESOURCES_INDEX_MAX_FILES_PER_DIR=200 ./resources-index.sh
```
