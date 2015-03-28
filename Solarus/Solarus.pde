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

Entity control;
StateManager game;

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
}



void draw()
{
    if (game.run())
    {
        
    }
    else
    {
        exit();
    }
}
