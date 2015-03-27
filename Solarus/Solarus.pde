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
    //background(0);
    
    if (game.run())
    {
        
    }
    else
    {
        exit();
    }
}

/*
import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;

boolean debug_ = false;

Minim minim;
AudioPlayer MenuMusic;

PC p1, p2;
PC control;
Stars star;

ArrayList<Proj> playerProj;
ArrayList<PC> players;
int playerInd = 0;

ArrayList<Proj> enemyProj;
ArrayList<PC> enemies;

UIStatusBar healthBar;

public class TestC implements Command { public void execute() {println("Test");} }
UI_Button b;

void setup()
{
    size(1200, 800);
    background(0);
    frameRate(60);
    
    ellipseMode(RADIUS);
    rectMode(CORNERS);
    
    for (int i = 0; i < keysS.length; i++)
        keysS[i] = true;
    
    enemies = new ArrayList<PC>();
    enemyProj = new ArrayList<Proj>();
    players = new ArrayList<PC>();
    playerProj = new ArrayList<Proj>();
    loadEnemies();
    loadPlayers();
    
    for (PC p : players)
        p.enemyList = enemies;
    
    for (PC p : enemies)
        p.enemyList = players;
    
    healthBar = new UIStatusBar(new PVector(0,0),
                                new PVector(100,20),
                                players.get(0).getHealth(),
                                new IntBox(10),
                                color(255,0,0));
    healthBar.setCenter(false);
    
    star = new Stars();
    star.addMapLayer(new PVector(5,5), 5, -0.3);
    star.addTileLayer(new PVector(400,400), 5, 0.0001, color(255,255,255,40), 5);
    star.addMapLayer(new PVector(5,5), 5, -0.1);
    star.addTileLayer(new PVector(400,400), 3, 0.001, color(255,255,255,45), 5);
    star.addMapLayer(new PVector(5,5), 5, 0.1);
    star.addTileLayer(new PVector(400,400), 1, 0.005, color(255,255,255,60), 5);
    
    mainScreenSetup();
    
    //set up the music
    minim = new Minim(this);
    MenuMusic = minim.loadFile("Music/Savant - Invasion - 15 Problematimaticalulatorture.mp3");
    
    //Music
    //MenuMusic.loop();
    MenuMusic.setLoopPoints(0,155000);
    
    b = new UI_Button(new PVector(100,100),
                                new PVector(200,100),
                                "Test Button",
                                new TestC());
                                
}

void draw()
{
    background(0);
    b.update();
    
    update();
    
    p1.rot(PI/128);
    
    render();
    renderMainScreen();
    
    playerSwitchCheck();
    
    healthBar.render(new PVector(0,0));
    
    for (PC p : players)
    {
        if (p.collide(p1) || p.collide(p2))
        {
            PGraphics im = createGraphics(40,40);
            im.beginDraw();
            im.stroke(255,255,0);
            im.fill(255,255,0);
            im.triangle(0, 40, 20, 0, 40, 40);
            im.endDraw();
            
            p.setImage(im);
        }
        else
        {
            PGraphics im = createGraphics(40,40);
            im.beginDraw();
            im.stroke(0,255,0);
            im.fill(0,255,0);
            im.triangle(0, 40, 20, 0, 40, 40);
            im.endDraw();
            
            p.setImage(im);
        }
    }
    
    b.render(new PVector(0,0));
}

void update()
{
    float delta = 30 / frameRate;
    
    for (int i = 0; i < players.size(); i++)
    {
        if (!players.get(i).update(delta))
        {
            players.remove(i);
            i--;
        }
    }
    
    for (int i = 0; i < enemies.size(); i++)
    {
        if (!enemies.get(i).update(delta))
        {
            enemies.remove(i);
            i--;
        }
    }
    
    for (int i = 0; i < enemyProj.size(); i++)
    {
        if (!enemyProj.get(i).update(delta))
        {
            enemyProj.remove(i);
            i--;
        }
    }
    
    for (int i = 0; i < playerProj.size(); i++)
    {
        if (!playerProj.get(i).update(delta))
        {
            playerProj.remove(i);
            i--;
        }
    }
}

void render()
{
    PVector controlCoords = new PVector(control.pos.x, control.pos.y);
    controlCoords.mult(-1);
    controlCoords.add(new PVector(width/2, height/2));
    
    star.render(controlCoords, control.pos, 2);
    
    for (PC p : players)
        p.render(controlCoords);
    for (PC p : enemies)
        p.render(controlCoords);
        
    for (Proj p : playerProj)
        p.render(controlCoords);
    for (Proj p : enemyProj)
        p.render(controlCoords);
    
    p1.render(controlCoords);
    p2.render(controlCoords);
}

void playerSwitchCheck()
{
    //Q
    if (keysS[4] && keys[4])
    {
        playerInd--;
        if (playerInd < 0)
            playerInd = players.size() - 1;
        
        control.setControl(false);
        control = players.get(playerInd);
        control.setControl(true);
        
        keysS[4] = false;
    }
    //E
    else if (keysS[5] && keys[5])
    {
        playerInd++;
        if (playerInd >= players.size())
            playerInd = 0;
        
        control.setControl(false);
        control = players.get(playerInd);
        control.setControl(true);
        
        keysS[5] = false;
    }
}

void loadEnemies()
{
    PC p;
    p = parsePC("test_triangle.player");
    PGraphics im = createGraphics(40,40);
    im.beginDraw();
    im.stroke(255,0,0);
    im.fill(255,0,0);
    im.triangle(0, 40, 20, 0, 40, 40);
    im.endDraw();
    
    p.setImage(im);
    p.moveTo(new PVector(20,20));
    
    PC p1;
    p1 = parsePC("test_triangle.player");
    p1.setImage(im);
    p1.moveTo(new PVector(0,0));
    
    p.maxRot = 6;
    p1.maxRot = 6;
    
    p.setRotThresh(16);
    p1.setRotThresh(16);
    
    p.setAITargets(players);
    p1.setAITargets(players);
    p.setAIFriend(enemies);
    p1.setAIFriend(enemies);
    
    p.projList = enemyProj;
    p1.projList = enemyProj;
    
    enemies.add(p);
    enemies.add(p1);
}

//Temp function
void loadPlayers()
{
    PC p;
    p = parsePC("test_triangle.player");
    PGraphics im = createGraphics(40,40);
    im.beginDraw();
    im.stroke(0,255,0);
    im.fill(0,255,0);
    im.triangle(0, 40, 20, 0, 40, 40);
    im.endDraw();
    
    p.setImage(im);
    p.moveTo(new PVector(width/2, height/2));
    p.setControl(true);
    control = p;
    //p.toggleHitBox();
    
    PC p3;
    p3 = parsePC("test_triangle.player");
    im = createGraphics(40,40);
    im.beginDraw();
    im.stroke(0,255,0);
    im.fill(0,255,0);
    im.triangle(0, 40, 20, 0, 40, 40);
    im.endDraw();
    
    p3.setImage(im);
    p3.moveTo(new PVector(width, height));
    //p.toggleHitBox();
    
    p.projList = playerProj;
    p3.projList = playerProj;
    
    players.add(p);
    players.add(p3);
    playerInd = 0;
    
    p1 = parsePC("test_pill.player");
    PGraphics im2 = createGraphics(10,10);
    im2.beginDraw();
    im2.fill(0,0,255);
    im2.rect(0,0, 10, 10);
    im2.endDraw();
    
    p1.setImage(im2);
    p1.moveTo(new PVector(width/2, height/2));
    p1.toggleHitBox();
    
    p2 = parsePC("test.player");
    PGraphics im4 = createGraphics(20,20);
    im4.beginDraw();
    im4.fill(0,255,255);
    im4.rect(0,0,20,20);
    im4.endDraw();
    
    p2.setImage(im4);
    p2.toggleHitBox();
}

void stop() {

    MenuMusic.close();
    minim.stop();
    super.stop();
}
*/
