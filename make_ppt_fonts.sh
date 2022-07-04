#!/usr/bin/env bash
if (( $EUID != 0 )); then
    echo "${0}: please run as root"
    exit
fi

cd /Applications/Microsoft\ PowerPoint.app/Contents/Resources/Office\ Themes/Theme\ Fonts
cp Arial.xml SourceSerif.xml
# Force sed to be macOS builtin /usr/bin/sed
/usr/bin/sed -i '' 's/Arial/Source Serif 4/g' SourceSerif.xml
cp Arial.xml SourceSans.xml
/usr/bin/sed -i '' 's/Arial/Source Sans 3/g' SourceSans.xml
cp Arial.xml FiraSans.xml
/usr/bin/sed -i '' 's/Arial/Fira Sans/g' FiraSans.xml
cp Arial.xml IBMPlexSans.xml
/usr/bin/sed -i '' 's/Arial/IBM Plex Sans/g' IBMPlexSans.xml
cp Arial.xml NotoSans.xml
/usr/bin/sed -i '' 's/Arial/Noto Sans/g' NotoSans.xml
