# Minesweeper
## Command Line 
- Run the code by typing 

    swift Minesweeper.swift

Help will display

### What has been implemented. 

- Dual board design one keeps the solved version, and the display board. This allows reverting a move and an easy way to check game wins. 
- A floodFill utilizing a queue and visited. 
- Flood fill returns a list of coodinates to copy over from the solved board to the display board
- Cheat mode for testing
- Solve command to display full solved game. 
- Displays using emoji. I did have some formatting issues on terminal, depending on which terminal program being used due to double wide characters. 

## Full iOS and Cataylst App
- I was having fun with this project, and decided to make a full app. Quick one
- UI only tested on iPhone 11 Max - I believe it has formatting problems on different size devices
- Use `tap` to reveal
- Use `Long Press` to mark with pin. 
- It is a little bit difficult to tap the small boxes on a real device but with a little practice it works pretty well. 
- Catalyst version, the window can be sized so the boxes are presented properly. but works pretty well. 
- Error handling does not display the best errors. 

## Supports AppClips
- Small app supports App Clips
    
### What was implemented
- iOS app that runs best on iPhone 11 Max
- Catalyst app which runs on the Mac
- Basic UI for adding running game.
- It uses same engine as the Command line version. Just removed the comamand line part. 
- Only runs on latest OS or simulator.

