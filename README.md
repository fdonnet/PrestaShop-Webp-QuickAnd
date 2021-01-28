# Prestashop - webp integration - Quick & ...

Test it, not in production... 
sudo in the commands below => needed if you don't have the permission on your presta website folder (owned by www-data).


## 1) Linux (Ubuntu)

Install webp converter 

    sudo apt install webp


## 2) Webp images folder
Create a new folder for webp images in your actual prestashop root folder

    cd /prestawebsitefolder
    sudo mkdir imgwebp 

Copy your .htaccess from your standard images folder

    sudo cp img/.htaccess imgwebp/

Add webp support in the new .htaccess in your imgweb folder (modify this line for Apache 2.2 and 2.4)

    <Files ~ "(?i)^.*\.(jpg|jpeg|gif|png|bmp|tiff|svg|pdf|mov|mpeg|mp4|avi|mpg|wma|flv|webm|ico|webp)$">


## 3) Modify and use the bash script   
Modify the config (path etc) in the script prestawebp.sh depending on your system. Change webp quality param if needed and run it 

    ./prestawebp.sh
   It will generate all your webp images in the new imgwebp folder.

Edit : with the new version 2021-01-28 => the script copies only the needed files. ~~For the moment, the script will copy all our original images (no matter what) and run the convert tool only if the webp file doesn't exist... not very efficient... you can do better.~~ At the end, it will rm the old files and keep only the webp in your imgwebp folder.

You can define a cron job to run the script every night (maybe a root cron job).


## 4) Override the "generateHtaccess" method in class Tools.php
Pls find an example file in override/classes folder, but pls adapt to your shop. 

The goal is to locate the lines with .jpg rules and duplicate for .webp ones (drive the rewrite rules to your new webp folder imgwebp)

Example :

    fwrite($write_fd, $media_domains);
    fwrite($write_fd, $domain_rewrite_cond);
    fwrite($write_fd, 'RewriteRule ^([a-z0-9]+)\-([a-z0-9]+)(\-[_a-zA-Z0-9-]*)(-[0-9]+)?/.+\.jpg$ %{ENV:REWRITEBASE}img/p/$1-$2$3$4.jpg [L]' . PHP_EOL);
    fwrite($write_fd, $media_domains);
    fwrite($write_fd, $domain_rewrite_cond);
    fwrite($write_fd, 'RewriteRule ^([a-z0-9]+)\-([a-z0-9]+)(\-[_a-zA-Z0-9-]*)(-[0-9]+)?/.+\.webp$ %{ENV:REWRITEBASE}imgwebp/p/$1-$2$3$4.webp [L]' . PHP_EOL);

To turn on the new rules => Go in your shop admin UI and desactivate and reactivate friendly url. It will re-create your new .htaccess file with the .webp rules.


## 5) Fallback for 404 on webp
If you add new products and your webp image version in not ready yet. Put in place a protection to show the .jpg version. Script in js folder. See where you want to put this script (in your theme or better, integreated in your theme.js).

    function onErrorImgWebp() {
    this.onerror = null;
    this.parentNode.children[0].srcset = this.parentNode.children[1].srcset = this.src;
    }

With html picture tag you have a fallback if the visitor browser is not able to use webp but no fallback if the .webp doesn't exist yet... This script helps a little...


## 6) Change you templates (.tpl) to use webp if available
Very easy... Go in your templates folder in your theme (ex: catalog/_partials/miniatures/product.tpl) and allow webp with picture tag and add a call to the 404 fallback in case of error.

|replace:'.jpg':'.webp' => with only that instruction in the webp srcset it will works : your new .htaccess rules (see point 4) will take care of the rest.

Just an example :

    <picture>
	    <source srcset="{$product.cover.bySize.home_default.url|replace:'.jpg':'.webp'}" type="image/webp">
		<source srcset="{$product.cover.bySize.home_default.url}" type="image/jpeg">
        <img
            src = "{$product.cover.bySize.home_default.url}"
            alt = "{if !empty($product.cover.legend)}{$product.cover.legend}{else}{$product.name|truncate:30:'...'}{/if}"
            loading="lazy"
            data-full-size-image-url = "{$product.cover.large.url}"
            onerror="onErrorImgWebp.call(this)" />
	</picture>


