#!/bin/bash
#A script thrown together to download the Discord tweak Enmity and merge the sitelen pona font nasin nanpa into its font set.

requirements=("wget" "fontforge" "zip" "unzip")
for i in ${requirements[@]}; do
        if ! hash "$i" &>/dev/null; then missing+=($i); fi
done
if [[ -v missing ]]; then
        for i in ${missing[@]}-1; do echo -e "This script requires '${missing[i]}'. '${missing[i]}' was not found in PATH."; done
        echo "Aborting."; exit 1;
fi

wget -O nasin-nanpa.otf $(wget -q -O - https://api.github.com/repos/ETBCOR/nasin-nanpa/releases/latest | awk '/UCSUR/ && /url/ {print $2}' | sed 's/\"//g') -q --show-progress || { echo >&2 "Failed to download font nasin-nanpa"; exit 1; }
wget https://github.com/enmity-mod/tweak/releases/latest/download/Enmity.ipa -q --show-progress || { echo >&2 "Failed to download Enmity"; exit 1; }

fontforge -lang=ff -c "Open(\"nasin-nanpa.otf\"); Generate(\"nasin-nanpa.ttf\")"

unzip Enmity.ipa

for font in Payload/Discord.app/*.ttf; do
	echo "$font"
	fontforge -lang=ff -c "Open(\"$font\");
	MergeFonts(\"nasin-nanpa.ttf\");
	Generate(\"$font\")"
done

zip -r Enmity-SP.ipa Payload/
echo "File output to Enmity-SP.ipa"
echo "Cleaning up..."
rm -r Payload Enmity.ipa nasin-nanpa.otf nasin-nanpa.ttf
echo "Done."
