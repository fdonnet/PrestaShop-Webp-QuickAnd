# Prestashop - webp integration - Quick & ...

Test it not in production... sudo in the commands below if you don't have permission on your presta website folder (owned by www-data).

## 1) Linux (Ubuntu)

Install webp converter 

    sudo apt install webp



## 2) Webp images folder
Create a new folder for webp images in your actual prestashop

   `sudo mkdir /yourprestawebsitefolder/imgwebp` 

Copy your .htaccess from your standard images folder

    sudo cp /yourprestawebsitefolder/img/.htaccess /yourprestawebsitefolder/imgwebp


## 2) Modify and use the bash script   
Modify the config (path etc) in the script depending of your system => change webp quality param if needed and run it 

    ./prestawebp.sh
   It will generate all your webp images in the new imgwebp folder.

> Dirty bash script but it does the job...

