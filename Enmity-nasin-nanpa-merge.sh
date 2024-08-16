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

enmityLink="https://github.com/enmity-mod/tweak/releases/latest/download/Enmity.ipa"
#enmityLink="https://github.com/Hargers/tweak/releases/latest/download/Enmity.ipa" #I might build a newer release than the official repo if it's fallen behind a good bit. Uncomment this if you'd like to use it.

wget -O nasin-nanpa.otf $(wget -q -O - https://api.github.com/repos/ETBCOR/nasin-nanpa/releases/latest | awk '/browser_download_url/ && $0 !~ /Helvetica/ && $0 !~ /UCSUR/ {print $2}' | sed 's/\"//g') -q --show-progress || { echo >&2 "Failed to download font nasin-nanpa"; exit 1; }
wget $enmityLink -q --show-progress || { echo >&2 "Failed to download Enmity"; exit 1; }

if [ -f ligatures.psv ] && rows=$(awk 'END { print NR }' ligatures.psv) && [ $rows -gt 0 ]; then
	echo "Saving ligatures"
	ligatureScript+="AddLookup(\"'liga' Standard Ligatures in Latin lookup 15\",\"GSUB_ligature\",0,[[\"liga\",[[\"dflt\",[\"dflt\",\"latn\"]],[\"latn\",[\"dflt\"]]]]],\"'rand' Randomize in Latin lookup 2\");"
	ligatureScript+="AddLookupSubtable(\"'liga' Standard Ligatures in Latin lookup 15\",\"'liga' Standard Ligatures in Latin lookup 15 subtable\");"
	for ((row=1; row<=rows; row++)); do
		fromLookup=$(awk -v row="$row" -v column="1" -F '|' 'NR==row {print $column}' ligatures.psv)
		if [[ $fromLookup == \#* ]]; then continue; fi
		glyph=$(awk -v row="$row" -v column="2" -F '|' 'NR==row {print $column}' ligatures.psv)
		sourceGlyphs=$(awk -v row="$row" -v column="3" -F '|' 'NR==row {print $column}' ligatures.psv)
		ligatureScript+="Select(\"$glyph\");"
		ligatureScript+="RemovePosSub(\"$fromLookup\");"
		ligatureScript+="AddPosSub(\"'liga' Standard Ligatures in Latin lookup 15 subtable\", \"$sourceGlyphs\");"
	done
else echo "No saved ligatures"; fi

fontforge -lang=ff -c "Open(\"nasin-nanpa.otf\"); $ligatureScript RemoveLookup(\"'liga' Standard Ligatures in Latin lookup 0\"); RemoveLookup(\"'liga' Standard Ligatures in Latin lookup 1\"); RemoveLookup(\"'liga' Standard Ligatures in Latin lookup 3\"); Generate(\"nasin-nanpa.otf\")"

unzip Enmity.ipa

for font in Payload/Discord.app/*.ttf; do
	echo "$font -> ${font%???}otf"
	fontforge -lang=ff -c "Open(\"$font\");
	MergeFonts(\"nasin-nanpa.otf\");
	Generate(\"${font%???}otf\")"
	rm $font
done

sed -i -e 's/ttf/otf/g' Payload/Discord.app/Info.plist

zip -r Enmity-SP.ipa Payload/
echo "File output to Enmity-SP.ipa"
echo "Cleaning up..."
rm -r Payload Enmity.ipa nasin-nanpa.otf
echo "Done."
