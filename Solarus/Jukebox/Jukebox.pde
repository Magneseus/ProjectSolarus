/*
   Alif Islam
   COMP 1405: Introduction to Computer Science
   Wednesday, September 24, 2014
   Jukebox program.
*/

// Import the minim library in order to access the tool that plays sounds
// Retrieve thise code by clicking Sketch > Import Library > minim
import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;

// Declare the variable for background image
PImage backgroundImage;

// Declare the number of songs
final int numSongs = 3;

// ??? Not quite sure what this is for...
Minim minim;

// Declare the songplayers for buttons 1, 2 and 3
AudioPlayer song1Player;
AudioPlayer song2Player;
AudioPlayer song3Player;

// Declare the buttons' widths and heights
final int buttonWidth = 30;
final int buttonHeight = 40;

// Declare the buttons' y-coordinate
final int buttonY = 100;

// Declare the buttons' x-coordinates
int middleButtonX;
int leftButtonX;
int rightButtonX;

// Declare the variable for text 
PFont buttonFont;

int songPlaying;

// Declare the number of frames since the button started flashing
int buttonCounter;

// Declare the number of frames before the buttons start flashing
final int framesBetweenFlash = 60;

void setup()
{
  // Load the image
  backgroundImage = loadImage("Jukebox.png");
  
  // Assign the output window's width and height based on the image's dimensions
  size(backgroundImage.width, backgroundImage.height);
  
  // Assign the buttons' x-coordinates
  middleButtonX = width/2;
  leftButtonX = middleButtonX - buttonWidth - 30;
  rightButtonX = middleButtonX + buttonWidth + 30;
  
  // Set up the music player and load the songs
  // Song Player 1: Trojans by Atlas Genius
  // Song Player 2: Cardiac Arrest by Bad Suns
  // Song Player 3: Four Letter Words by I, the Mighty
  minim = new Minim(this);
  song1Player = minim.loadFile("Trojans.mp3");
  song2Player = minim.loadFile("Cardiac Arrest.mp3");
  song3Player = minim.loadFile("Four Letter Words.mp3");
  
  // Create the font for the button labels
  buttonFont = createFont("Figa font", 16, true);
  textFont(buttonFont, 26);
  
  // Align the text in the center both horizontally and vertically
  textAlign(CENTER, CENTER);
  
  // Enable center mode
  rectMode(CENTER);
}

void draw()
{
  // Display the jukebox as the background
  image(backgroundImage, 0, 0);
  
  // White
  fill(255);
  
  // Increment the buttonCounter
  buttonCounter++;
  
  // If the buttonCounter is greater than twice the number of frames between flashes
  // Then reset the buttonCounter to 0
  if (buttonCounter > framesBetweenFlash * 2)
  {
    // Reset buttonCounter to 0
    buttonCounter = 0;
  }
  
  // Create the buttons
  drawButton(leftButtonX, buttonY, 1);
  drawButton(middleButtonX, buttonY, 2);
  drawButton(rightButtonX, buttonY, 3);  
}

void drawButton(int x, int y, int buttonNumber)
{
  if(buttonNumber != songPlaying ||
     buttonCounter < framesBetweenFlash)
  {
    fill(0);
    rect(x, y, buttonWidth, buttonHeight);
    
    fill(255);
    text(buttonNumber, x, y);
  }
}

void mouseClicked()
{  
  
  // If the mouse's y-coordinate is in the buttons' y-coordinate range
  // Then proceed to the next if statement
  if (mouseY >= buttonY - (buttonHeight/2) &&
      mouseY <= buttonY + (buttonHeight/2))
  {
    // If the mouse's x-coordinate is within the left button's x-coordinate range
    // Then play the song from Song Player 1
    // If the mouse's x-coordinate is within the middle button's x-coordiante range
    // Then play the song from Song Player 2
    // If the mouse's x-coordiante is within the right button's x-coordinate range
    // Then play the song from Song Player 3
    if (mouseX >= leftButtonX - (buttonWidth/2) &&
        mouseX <= leftButtonX + (buttonWidth/2))
    {
      // Left button clicked
      toggleSong(song1Player, 1);
    }
    else if (mouseX >= middleButtonX - (buttonWidth/2) &&
             mouseX <= middleButtonX + (buttonWidth/2))
    {
      // Middle button clicked
      toggleSong(song2Player, 2);
    }
    else if (mouseX >= rightButtonX - (buttonWidth/2) &&
             mouseX <= rightButtonX + (buttonWidth/2))
    {
      // Right button clicked
      toggleSong(song3Player, 3);
    }
  }
}

void toggleSong(AudioPlayer songPlayer, int buttonNumber)
{
      // Save whether the song was playing so we can
      // start playing it if it wasn't
      boolean wasPlaying = songPlayer.isPlaying();
      
      // Stop all the songs
      songPlaying = -1;
      song1Player.pause();  
      song2Player.pause();
      song3Player.pause();
      
      // Start playing this song (whatever it happens
      // to be) if it was previously not playing
      if (!wasPlaying)
      {
          songPlayer.play();
          songPlaying = buttonNumber;
          buttonCounter = 0;
      }
}



  
  
  
  
  
  
  
  

