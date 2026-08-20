# LuaPaint
Basic 2d paint program based on Lua Löve, created largely to figure out if it was possible.

# Controls
Paint with left or right mouse button, zoom by scrolling, pan by holding middle mouse button.
To use a button on the left press it, double click for keyboard input on sliders.
All text input can be cancelled with the escape button.

All files LuaPaint deals with are in the folder used for the [Lua Love Filesystem](https://love2d.org/wiki/love.filesystem)
To export an image press the "save" button, type in your desired name and hit enter. 
To import an image press "import" button, use the up and down arrow to select the desired image file name and hit enter to select the image.

note a quirk of the system is that while the add and subtract brushes try to treat channels independently, the way that the image buffers are set up means that some nonzero alpha is required for this to work.

# Dependencies
Scaling of the buttons is from the Lua library [Push](https://github.com/Ulydev/push/blob/master/push.lua). The super tight text font was kindly provided by forum user [nkorth](https://love2d.org/forums/viewtopic.php?p=186984&hilit=outlinefont#p186984)

# Status
This is an upload of an old project, it's not perfect and if you want to use it for anything I'm willing to add to it but for my purposes it's done.
