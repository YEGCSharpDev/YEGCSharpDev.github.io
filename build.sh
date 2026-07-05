#!/usr/bin/env bash

echo "Starting build process..."

# 1. Create a clean output directory
rm -rf public
mkdir -p public

# 2. Copy the stylesheet into the output folder
cp style.css public/

# 3. Loop through and convert markdown files
for file in content/*.md; do
    filename=$(basename -- "$file")
    name_only="${filename%.*}"
    
    # Notice the output path is now inside the public folder
    output="public/${name_only}.html"

    echo "Converting ${filename} -> ${output}..."

    pandoc "$file" \
        --template=template.html \
        -o "$output"
done

echo "Build complete! 🚀"
