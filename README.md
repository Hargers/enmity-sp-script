## Enmity sitelen pona script

This Bash script downloads the latest release of [Enmity](https://github.com/enmity-mod/tweak) and [nasin nanpa](https://github.com/ETBCOR/nasin-nanpa) from their Github pages and merges their font set. This allows you to see sitelen pona UCSUR in the iOS Discord app.

A sitelen pona `.ipa` app file for both the Enmity Discord client and the vanilla Discord client is available on the [releases page](https://github.com/Hargers/enmity-sp-script/releases/latest).

For instructions on installing this app to your device, refer to the "Sideloading apps" section on [this page](https://ios.cfw.guide/sideloading-apps/#sideloading-apps). *(I recommend Altstore (linked in the above guide) or [SideStore](https://sidestore.io/), for ease of resigning the app, as, otherwise, the app expires after a week.)*  

> [!NOTE]  
> If sideloading on a non-jailbroken device, you won't be able receive notifications or screenshare through Discord due to missing entitlements.

If you'd like to use a different font, tweak the script to download that font/refer to a local font and update differing lookup tables. If using a ttf font, remove the first lookup table script and replace all occurences of `otf` with `ttf`. I don't include these in my script, as mine is more of a doohickey than a tool.

<sub>If you need help with anything, feel free to message me on Discord [@harger](https://discord.com/users/215591646140563456) or ping me in any toki pona server I'm in.</sub>
