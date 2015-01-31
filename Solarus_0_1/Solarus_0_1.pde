/*
Project Solarus: Intro

Matthew Mayer   : 100969802
Connor Clysdale : 100976216
Alif Islam      : 100967488

January 26th
*/

//Imports
import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;

//Minim
Minim minim;
AudioPlayer player;

//Vars
ArrayList<SimpleStar> stars;
ArrayList<Ship> ships;

ArrayList<PImage> shipImages;
ArrayList<PVector> shipSizes;

int boundX = 1000;
int boundY = 1000;

PImage title;
int imageW = 400;
int imageH = 250;
int imageX, imageY;

PVector titlePos, titleVel, titleAccel;
float titleVelMin = 1.f;

triangles test = new triangles(75,75,50,#880000,#FFFF00);


//Credits
boolean intro = true;
boolean introReady = false;

String[] creditText;
PFont font;
float textY = 505;

void setup()
{
    size(500,500);
    background(0);
    frameRate(60);
    
    minim = new Minim(this);
    player = minim.loadFile("sound/soundtrack.mp3");
    player.loop();
    
    title = loadImage("pics/Solarus_title.png");
    imageX = (int) ((width/2) - (imageW/2));
    imageY = (int) ((height/2) - (imageH/2) - (width/4));
    
    titlePos = new PVector(imageX, height + 100);
    titleVel = new PVector(0, -7);
    titleAccel = new PVector(0,0.04);
    
    stars = new ArrayList<SimpleStar>();
    ships = new ArrayList<Ship>();
    
    shipImages = new ArrayList<PImage>();
    shipSizes = new ArrayList<PVector>();
        
    shipImages.add(loadImage("pics/Rocket.png"));
    shipSizes.add(new PVector(20,58));
    
    shipImages.add(test.display());
    shipSizes.add(new PVector(50,50));
    
    //Credits
    font = createFont("zekton.ttf", 32);
    textFont(font);
    creditText = loadStrings("Solarus_Credits.txt");
}

void draw()
{
    background(0);
    
    if (intro)
    {
        //50% chance of spawning a star
        if (random(100) < 50)
        {
            SimpleStar s = new SimpleStar(new PVector(random(width), -10.f),
                                          new PVector(0, random(2,8)),
                                          (int)random(1,4),
                                          (int)random(100),
                                          height);
            stars.add(s);
        }
        
        //Updating Stars
        for (int i = 0; i < stars.size(); i++)
        {
            SimpleStar s = stars.get(i);
            
            if (s.update(0.5))
            {
                s.render();
                stars.set(i,s);
            }
            else
            {
                stars.remove(i);
                i--;
            }
        }
        
        //2% Chance of spawning a ship
        if (random(400) <= 2)
        {
            int angle = (int)random(2 * PI);
            PVector vel = PVector.fromAngle(angle);
            vel.setMag(random(4,12));
            
            int spawnDist = (int) sqrt((pow(width/2,2) + pow(height/2,2))); spawnDist += 50;
            PVector pos = new PVector(width/2, height/2);
            PVector posAdd = vel.get();
            
            posAdd.setMag(spawnDist);
            pos.add(posAdd);
            
            vel.rotate( PI + random(-QUARTER_PI, QUARTER_PI) );
            
            Ship s = new Ship(pos.get(), vel.get(), boundX, boundY);
            
            int tmpInd = (int) random(shipImages.size());
            PImage tmp = shipImages.get(tmpInd);
            PVector tmpSize = shipSizes.get(tmpInd);
            
            tmp.resize((int)tmpSize.x, (int)tmpSize.y);
            s.setSprite(tmp);
            
            ships.add(s);
        }
        
        //Updating Ships
        for (int i = 0; i < ships.size(); i++)
        {
            Ship s = ships.get(i);
            
            if (s.update(0.5))
            {
                s.render();
                ships.set(i,s);
            }
            else
            {
                ships.remove(i);
                i--;
            }
        }
        
        //Update Image
        titleVel.add(PVector.mult(titleAccel, 0.5));
        if (titleVel.mag() < titleVelMin)
            titleVel.setMag(titleVelMin);
        
        titlePos.add(PVector.mult(titleVel, 0.5));
        
        if (dist(titlePos.x, titlePos.y, imageX, imageY) < 2)
        {
            titleAccel = new PVector(0,0);
            titleVel = new PVector(0,0);
            titleVelMin = 0;
            
            introReady = true;
        }
            
        //Display Image
        image(title, titlePos.x, titlePos.y, imageW, imageH);
        
        if (introReady)
        {
            if (mousePressed)
            {
                intro = false;
                stars.clear();
            }
            
            textAlign(CENTER, CENTER);
            fill(255,120,10);
            text("Click the mouse to continue.", width/2, height/2 + height/4);
        }
    }
    else
    {
        background(0);
        noStroke();
        
        //10% chance of spawning a star
        if (random(100) < 10)
        {
            SimpleStar s = new SimpleStar(new PVector(random(width), -10.f),
                                          new PVector(0, random(0.25,1.5)),
                                          (int)random(1,4),
                                          (int)random(75,250),
                                          height);
            stars.add(s);
        }
        
        //Updating Stars
        for (int i = 0; i < stars.size(); i++)
        {
            SimpleStar s = stars.get(i);
            
            if (s.update(0.5))
            {
                s.render();
                stars.set(i,s);
            }
            else
            {
                stars.remove(i);
                i--;
            }
        }
        
        Credits();
    }
}

void Credits()
{
    textFont(font, 36);
    textAlign(CENTER, CENTER);
    fill(250, 120, 10); // Orange
    
    for(int i = 0; i < creditText.length; i++)
    {
        text(creditText[i], width/2, textY + 45 * i);
    }
    
    textY -= 1;
}
