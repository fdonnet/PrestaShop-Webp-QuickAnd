#!/bin/bash

cd /prestawebsitefolder/img
find . -name '*.jpg' -exec cp --parents \{\} /prestawebsitefolder/imgwebp \;
cd /prestawebsitefolder/imgwebp
bmp_files=$(find . -iname "*.jpg")

total=$(echo "$bmp_files" | wc -l)
num=0

echo "There are $total files to be converted."

for f in $bmp_files
do
    ((num++))
    
    echo "$f"
    if [ ! -f "${f%.jpg}.webp" ]; then
     cwebp -q 80 "$f" -o "${f%.jpg}.webp"
    fi
     rm "$f"
done
chown -R www-data:www-data /prestawebsitefolder/imgwebp
