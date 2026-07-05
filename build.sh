#!/usr/bin/env bash

echo "Starting build process..."

# 1. Clean output directory
rm -rf public
mkdir -p public

# 2. Copy the stylesheet
cp style.css public/

# 3. Copy the images directory (if it exists)
if [ -d "content/images" ]; then
    echo "Copying images directory..."
    cp -r content/images public/
fi

# 4. Loop through and convert markdown files recursively
# Using 'find' handles nested folders and spaces in folder names
find content -name "*.md" -type f -print0 | while IFS= read -r -d $'\0' file; do
    
    # Strip the 'content/' prefix to get the relative path (e.g., 'Tech/Arch.md')
    rel_path="${file#content/}"
    
    # Swap the .md extension for .html
    output_rel_path="${rel_path%.*}.html"
    output_file="public/${output_rel_path}"

    # Get the directory name (e.g., 'public/Tech') and ensure it exists
    out_dir=$(dirname "$output_file")
    mkdir -p "$out_dir"

    echo "Converting ${file} -> ${output_file}..."

    pandoc "$file" \
        --template=template.html \
        -o "$output_file"
done

echo "Build complete! 🚀"
