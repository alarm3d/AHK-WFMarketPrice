# AHK-WFMarketPrice rus
Author https://github.com/CookiePawpad
Original eng client here: https://github.com/CookiePawpad/DucatKiosk
**Requirements**  
Requires AHK https://autohotkey.com/  
The script and its files  
Internet  
Warframe rus
  
**Controls**  
Search: Shift+Z  
Close result box: Left Click 
Options: Left or Right click tray icon  
  
**Usage**  
Run marketprice.ahk  
Open inventory or go to a ducat kiosk in-game
Ducat kiosks are found at relays  
Mouse over item you want to check  
Press Shift+Z  
Result box stays open for 12 seconds and will close if you left click or start another search  

**Options**  
Options is accessed by tray icon  
Checkmarked equals enabled while no checkmark equals disabled  
**Item Name:** The name of the identified item  
**Vaulted:** Is the item vaulted?  
**Previous Hour:** Shows data influenced by the previous hour  
**Previous Day:** Shows data influenced by the previous day  
**Ducats Per Plat:** Ducats per platinum  
**Ducats Per Plat WA:** Ducats per platinum effected by weighted average  
**Average Plat:** Average platinum value  
**Average Plat WA:** Average platinum effected by weighted average  
**Ducat Value:** Shows ducat value of the item, does not show if previous hour *and* day is disabled  
**Task Time:** Time taken in milliseconds to display data  
**Reload:** Reloads the script  
**Exit:** Exits the script  
  
**Errors occur if**  
The API cannot be reached, usually results in an error number code  
A file is missing or cannot be accessed, one or more files cannot be read/written or do not exist  
You thought saving your kavats/kubrows shed fur in config.ini would be a good idea  
The script will usually exit if an error occurs
