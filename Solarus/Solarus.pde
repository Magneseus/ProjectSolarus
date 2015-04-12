import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;

boolean debug_ = false;
boolean pause = false, options = false;

Minim minim;
Stars star;

StateManager game;
UIToast toast;

//CHANGE
PImage enemyP1, friendP1, friendP2;
PImage[] outpostImage;
PGraphics[] playerImages;

void setup()
{
    // Initialize Screen and shape prefs
    size(1600, 1000);
    background(0);
    frameRate(60);
    
    ellipseMode(RADIUS);
    rectMode(CORNERS);
    
    /*PImage curs = loadImage("Images/reticle.png");
    curs.resize(60,60);
    cursor(curs);
    */
    // Setup key vars
    for (int i = 0; i < keysS.length; i++)
        keysS[i] = true;
    
    // Generate the star background
    star = new Stars();
    star.addMapLayer(new PVector(5,5), 5, -0.3);
    star.addTileLayer(new PVector(400,400), 5, 0.0001, color(255,255,255,40), 5);
    star.addMapLayer(new PVector(5,5), 5, -0.1);
    star.addTileLayer(new PVector(400,400), 3, 0.001, color(255,255,255,45), 5);
    star.addMapLayer(new PVector(5,5), 5, 0.1);
    star.addTileLayer(new PVector(400,400), 1, 0.005, color(255,255,255,60), 5);
    
    // Start Minim
    minim = new Minim(this);
    
    // Start the State Manager
    game = new StateManager();
    
    // init the toast group
    toast = new UIToast(new PVector(width/2,25), 
                        new PVector(400,50),
                        color(#C1B0B0),
                        color(#6C6363));
    
    //CHANGE
    enemyP1 = loadImage("Images/proj_enemy1.png");
    friendP1 = loadImage("Images/proj_friend1.png");
    friendP2 = loadImage("Images/proj_friend2.png");
    
    PImage[] outposts2 = {loadImage("Images/outpost_1.png"),
                          loadImage("Images/outpost_2.png"),
                          loadImage("Images/outpost_3.png")};
    PImage[] ships = {loadImage("Images/ship_1.png"),
                      loadImage("Images/ship_2.png"),
                      loadImage("Images/ship_3.png"),
                      loadImage("Images/ship_4.png")};
    playerImages = new PGraphics[ships.length];
                      
    outpostImage = outposts2;
    for (PImage p : outpostImage)
        p.resize(200,200);
    
    for (int i = 0; i < ships.length; i++)
    {
        boolean xBound = ships[i].width > ships[i].height ? true : false;
        float x = xBound ? 50.f : ships[i].width / (ships[i].height/50.f);
        float y = xBound ? ships[i].height / (ships[i].width/50.f) : 50.f;
        playerImages[i] = createGraphics((int)x,(int)y);
        playerImages[i].beginDraw();
        playerImages[i].image(ships[i], 0, 0, (int)x, (int)y);
        playerImages[i].endDraw();
    }
    
    toast.pushToast("Welcome to Solarus.", 3000);
}



void draw()
{
    if (game.run())
    {
        toast.update();
        toast.render(new PVector(0,0));
    }
    else
    {
        exit();
    }
  
}
