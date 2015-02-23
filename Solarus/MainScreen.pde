/*
   PROJECT SOLARUS
   Main Screen
 */
 
 PImage MainFrame;
 
 Time time;
 
 int health = 100;
 int fuel = 100;
 
 void setup()
 {
   size(1200, 650);
   
   MainFrame = loadImage("MainFrame.png");
   MainFrame.resize(235, 320);
   
   time = new Time(30, 30, 20);
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
   
   // Current time
   fill(255);
   time.getTime();
   time.x = 35;
   time.y = 75;
   time.displayTime();
   
   // Health bar
   
   // Fuel bar
 }
