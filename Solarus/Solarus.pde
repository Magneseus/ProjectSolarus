import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;

boolean debug_ = false;

Minim minim;
AudioPlayer MenuMusic;

void setup()
{
    size(1200, 800);
    background(0);
    frameRate(60);
    
    ellipseMode(RADIUS);
    rectMode(CORNERS);
    
    mainScreenSetup();
    
    //set up the music
    minim = new Minim(this);
    MenuMusic = minim.loadFile("Music/Savant - Invasion - 15 Problematimaticalulatorture.mp3");
    
    //Music
    MenuMusic.loop();
    MenuMusic.setLoopPoints(0,155000);
}

void draw()
{
    background(0);
    
    renderMainScreen();
}

void stop() {

    MenuMusic.close();
    minim.stop();
    super.stop();
}
