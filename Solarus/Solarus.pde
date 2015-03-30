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
 
void setup()
{
    // Initialize Screen and shape prefs
    size(1200, 800);
    background(0);
    frameRate(60);
    
    ellipseMode(RADIUS);
    rectMode(CORNERS);
    
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
                        new PVector(300,50),
                        color(#C1B0B0),
                        color(#6C6363));
    toast.pushToast("Test", 2000);
    toast.pushToast("Test1", 1000);
    toast.pushToast("Test2", 500);
    toast.pushToast("Test3", 5000);
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
