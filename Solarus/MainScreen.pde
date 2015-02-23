/*
   PROJECT SOLARUS
   Main Screen
 */
 
 PImage MainFrame;
 PFont timeFont;
 
 Clock clock;
 
 int health = 100;
 int fuel = 100;
 
 void setup()
 {
   size(1200, 650);
   
   MainFrame = loadImage("Windows/MainFrame.png");
   MainFrame.resize(235, 320);
   
   clock = new Clock();
   
   timeFont = loadFont("Fonts/HoboStd-40.vlw");
   smooth();
 }
 
 void draw()
 {
   background(0);
   
   // Trim
   strokeWeight(3);
   stroke(0, 250, 230, 75);
   noFill();
   rect(5, 5, width/5, height - 10);
   
   // Main panel
   strokeWeight(1);
   stroke(0, 250, 230);
   fill(0, 230, 210, 50);
   rect(15, 15, width/5 - 20, height - 30);
   
   image(MainFrame, 5, 10);
   
   textFont(timeFont, 32);
   textAlign(CENTER, CENTER);
   
   // Current time
   fill(0, 250, 230);
   clock.getTime();
   clock.x = width/10;
   clock.y = height/8;
   clock.displayTime();
   
   // Health bar
   
   // Fuel bar
 }
