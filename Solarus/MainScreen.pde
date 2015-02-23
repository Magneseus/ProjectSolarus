/*
   PROJECT SOLARUS
   Main Screen
*/
 
 PImage MainFrame;
 PImage StatusBarFrame;
 PFont timeFont;
 
 Clock clock;
 
 int health = 100;
 int damage = 0;
 int fuel = 100;
 
 void mainScreenSetup()
 {
   MainFrame = loadImage("Windows/MainFrameMenu.png");
   MainFrame.resize(250, 300);
   
   StatusBarFrame = loadImage("Windows/StatusBarFrame.png");
   StatusBarFrame.resize(700, 200);
   
   clock = new Clock();
   
   timeFont = loadFont("Fonts/HoboStd-40.vlw");
   smooth();
 }
 
 void renderMainScreen()
 {
   /*
   // Trim
   strokeWeight(3);
   stroke(0, 250, 230, 75);
   noFill();
   rect(5, 5, width/5, height - 10);
   
   // Main panel
   strokeWeight(1);
   stroke(0, 250, 230);
   fill(0, 230, 210, 50);
   rect(15, 15, width/5 - 10, height - 20);
   */
   
   image(MainFrame, 5, 10);
   image(StatusBarFrame, width/2 - 350, height - 195);
   
   fill(255, 200);
   textFont(timeFont, 16);
   text("Menu", 60, 40);
      
   textSize(24);
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
