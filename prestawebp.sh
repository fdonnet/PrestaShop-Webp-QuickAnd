#!/bin/bash

# Get all jpeg files
cd /prestawebsitefolder/img
jpg_files=$(find . -iname "*.jpg")

#Loop on old jpeg files
for jpg_file in $jpg_files
do
    #Check if the webp already exists before copy
    #echo "Old file path: $jpg_file"

    webp_target_file="/prestawebsitefolder/imgwebp/${jpg_file%.jpg}.webp"
    #echo "Target file path: $webp_target_file"
    if [ ! -f "$webp_target_file" ]; then
        #echo "File doesn't exist, proceed with the copy : $webp_target_file"
        cp --parents $jpg_file /prestawebsitefolder/imgwebp
    fi
done

#Go in wepp directory
cd /prestawebsitefolder/imgwebp
copied_jpg_files=$(find . -iname "*.jpg")

#Loop on copied jpg files in webp directory to convert
for new_jpg in $copied_jpg_files
do
    cwebp -q 100 "$new_jpg" -o "${new_jpg%.jpg}.webp" -quiet
    echo "File ${new_jpg%.jpg}.webp created !"
    rm "$new_jpg"
    #echo "Odl file $new_jpg removed !"
done

#Change the owner of the new created files
chown -R www-data:www-data /prestawebsitefolder/imgwebp
