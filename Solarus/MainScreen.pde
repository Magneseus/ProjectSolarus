/*
   PROJECT SOLARUS
 <<<<<<< HEAD
 Main Screen
 */

PImage MainFrame;
PImage StatusBarFrame;
PFont timeFont;

StatusBar healthBar;
StatusBar damageBar;
StatusBar fuelBar;

int health = 100;
int damage = 0;
int fuel = 100;


void mainScreenSetup()
{
    MainFrame = loadImage("Windows/MainFrameMenu.png");
    MainFrame.resize(250, 300);

    StatusBarFrame = loadImage("Windows/StatusBarFrame.png");
    StatusBarFrame.resize(700, 200);

    healthBar = new StatusBar(width/2 - 50, height - 105, health, 10);
    damageBar = new StatusBar(width/2 - 50, height - 85, damage, 10);
    fuelBar = new StatusBar(width/2 - 50, height - 65, fuel, 10);

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

    rectMode(CORNER);
    noFill();
    stroke(255);
    strokeWeight(1);
    rect(width/2 - 50, height - 105, 200, 10);
    rect(width/2 - 50, height - 85, 200, 10);
    rect(width/2 - 50, height - 65, 200, 10);

    if (health > 50 || fuel > 50)
    {
        fill(0, 255, 0);
    }
    else 
    {
        fill(255, 0, 0);
    }

    healthBar.drawBar();
    damageBar.drawBar();
    fuelBar.drawBar();

    fill(255, 200);
    textFont(timeFont, 16);
    text("Menu", 60, 40);

    textSize(24);
    textAlign(CENTER, CENTER);

    // Current time
    fill(0, 250, 230);

    // Health bar

    // Fuel bar
}

