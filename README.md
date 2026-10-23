My first attempt at making a horror game. It was really fun!

You play by moving around to get a key to unlock a door. But be careful. There's a phantom roaming around.

I used blender to design the map. Taking inspiration from the backrooms. i also used free models from cgtrader for the phantom and furniture. to play this game, head over to [itch page](https://abubazar.itch.io/unawake)

And Yes, there's Lore!

https://github.com/Abubazar/Unawake/blob/main/README.md
The main logic of the game is quite simple; basic characterbody controller with look controls ocnnected to the camera.
![godot image](https://github.com/Abubazar/Unawake/blob/main/Screenshot%20(186).png?raw=true)
I designed the map in blender and imported it to godot, created a collision mesh for it. The phantom actually follows a pre-defined path. and instead of a field of view, i just attached 5 raycasts to the body. not conventional but idk how to properly create a fov. and this was faster.
<img width="1240" height="586" alt="Screenshot (187)" src="https://github.com/user-attachments/assets/0010801e-5cf4-4d21-a47d-f46082c5b3d4" />

getting the game to detect when the player is in total darkness was also a challenge. I only really found 1 youtube video that properly helped. using the a sub-viewport and blurring the entire view of the player view to 1 pixel. then using luminance() to get the brighness of what the player is seeing.

FUN FACT: all the sound effects were made by me :3, it was fun making each sound effect myself but also really hard

I had to remove a really cool effect cause i wanted the game to have a web build. which is ambient occlusion. It lags a lot when playing on web with ambient occlusion. I also had to add mobile support cause i want my friends to play too. which was so challenging. Idk why. i used a generic addon for the joystick, created 2 svg for the other buttons and added them in. The hard part was that the touch rotate was interfering with the movement controls.
hope you enjoy.
