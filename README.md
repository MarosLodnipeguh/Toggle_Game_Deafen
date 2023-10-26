# toggle game deafen
Autohotkey script to reduce the current application volume, on toggle, to have better comms / not get earraped by the game.
Second bind press will bring back the original volume.
This will ONLY deafen the application that is in focus, leaving all background applications still audible.

It works great with Rainbow Six Siege, during prep phase.

Autohotkey v1.1 required!
download it here: https://www.autohotkey.com/download/ahk-install.exe

Than just run the "Game Deafen Toggle.ahk" script and toggle the deafen in your game by pressing F1.
VA.ahk should be located in the same folder as the script.

F1 is no good for you? 
[Keybinding can be changed here](toggle_game_deafen.ahk#L11) 

On default, the script reduces the volume to 13% of the original volume.
[Reduction procentage can be changed here](toggle_game_deafen.ahk#L9)



Syntax tips:

Alt = '!'

Control = '^'

Shift = '+'

+F1   then becomes Shift+F1 on keyboard.

^m    then becomes Control+M on keyboard.

^+m 	then becomes control + shift + m on keyboard


It is possible to stack multiple keybinds on top of each other to all perform the same action.
