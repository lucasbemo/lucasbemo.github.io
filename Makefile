.PHONY: serve new build update clean

# Live preview including drafts at http://localhost:1313
serve:
	hugo server -D

# Create a new draft post: make new title="my-post-slug"
new:
	hugo new posts/$(title).md

# Production build into ./public
build:
	hugo --gc --minify

# Update the DoIt theme to the latest release
update:
	hugo mod get -u github.com/HEIGE-PCloud/DoIt
	hugo mod tidy

# Remove build artifacts
clean:
	rm -rf public resources .hugo_build.lock
