# TetrisIOSApp

WELCOME!

This is an IOS app created with Swift 5, on xCode 11. It contains a simplistic version of Tetris that allows you to play, adjust level, and view highscores.

The more traditional way of re-creating tetris would be to create a backend "game" array that is used during the game. Then, using this array you would update the actual display in real time.

I used a very similar approach, but instead of referencing a backend "game" array, I just referenced the display itself. The game board I created is made up of 160 ImageViews, with each row being in it's own respective Horizontal Stack View. Then, in the View Controller for the game code, I created an array with all of these Stackviews, effectively creating a 2-D array that is directly connected to the display and can be accessed directly in the code.

I figured this would be more straightforward than supposedly creating an array like this twice, once in the backend for reference, and once in the frontend for display. When needing to compare values on the board, I just compared the actual images themselves, checking if they were equal or unequal to eachother.

Perhaps there is a more efficient way of doing this with more modern animation techniques, but I created this project as a way to practice the coding fundamentals that are used in a variety of different kinds of applications, and I learned a lot!

This project took me about a month and a half.

Thank you for taking the time to look at my work. Have a good day :)
