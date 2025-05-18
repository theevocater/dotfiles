#!/bin/bash

# Install fonttools for ttx
python3 -m venv venv
venv/bin/pip install fonttools

# Convert to ttx
venv/bin/ttx  ./*.otf

# set isFixedPitch to 1
sed -i '' -e 's/isFixedPitch value="0"/isFixedPitch value="1"/g' ./*.ttx

# Convert back to otf
mkdir fixed
venv/bin/ttx -d fixed/ ./*.ttx

# Copy files in right place for osx
mv fixed/*.otf ~/Library/Fonts/
# Refresh font cache
fc-cache ~/Library/Fonts
