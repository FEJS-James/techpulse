#!/bin/bash
# Auto-publish script for TechPulse Daily
# Run via cron: 0 9,17 * * * /path/to/auto-publish.sh
# Publishes 1 article at 9 AM and 1 at 5 PM

set -e

BLOG_DIR="/Users/james/.openclaw/workspace/blogs/techpulse"
CONTENT_DIR="$BLOG_DIR/src/content/blog"
NETLIFY_AUTH_TOKEN="${NETLIFY_AUTH_TOKEN:-nfp_1cVn5CMBz4PDWEbSvwwd1JLowr5PTzhj43c6}"
NETLIFY_SITE_ID="${NETLIFY_SITE_ID}"  # Will be set after first deploy
GH_TOKEN="${GH_TOKEN:-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}"

cd "$BLOG_DIR"

# Check if there are pending articles to publish
PENDING_DIR="$BLOG_DIR/scripts/pending"
mkdir -p "$PENDING_DIR"

if [ -z "$(ls -A $PENDING_DIR 2>/dev/null)" ]; then
    echo "No pending articles. Run generate-articles.sh first."
    exit 0
fi

# Move the oldest pending article to content
NEXT_ARTICLE=$(ls -t "$PENDING_DIR"/*.md 2>/dev/null | tail -1)
if [ -n "$NEXT_ARTICLE" ]; then
    FILENAME=$(basename "$NEXT_ARTICLE")
    mv "$NEXT_ARTICLE" "$CONTENT_DIR/$FILENAME"
    echo "Published: $FILENAME"
    
    # Build
    npm run build
    
    # Deploy to Netlify
    if [ -n "$NETLIFY_SITE_ID" ]; then
        NETLIFY_AUTH_TOKEN="$NETLIFY_AUTH_TOKEN" netlify deploy --prod --dir=dist --site "$NETLIFY_SITE_ID"
    fi
    
    # Push to GitHub
    git add -A
    git commit -m "Auto-publish: $FILENAME"
    git push
    
    echo "Done! Article published and deployed."
else
    echo "No pending articles found."
fi
