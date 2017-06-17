#!/bin/sh

version="2.030R-ro/1.050R-it.zip"

rm /tmp/source_code_pro.zip || true
rm -rf /tmp/source-code-pro* || true

echo "\n* Downloading https://github.com/adobe-fonts/source-code-pro/archive/${version}"
wget https://github.com/adobe-fonts/source-code-pro/archive/$version -O /tmp/source_code_pro.zip

echo "\n* Unziping package"
unzip /tmp/source_code_pro.zip
mkdir -p ~/.fonts

echo "\n* Copying fonts to ~/fonts"
cp /tmp/source-code-pro*/OTF/*.otf ~/.fonts/

echo "\n* Updating font cache"
sudo fc-cache -f -v

echo "\n* Looking for 'Source Code Pro' in installed fonts"
fc-list | grep "Source Code Pro"

echo "\n* Now, you can use the 'Source Code Pro' fonts"

