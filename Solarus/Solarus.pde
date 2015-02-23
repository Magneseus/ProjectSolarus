boolean debug_ = false;

PC p1, p2;
PC control;
Stars star;

ArrayList<Proj> playerProj;
ArrayList<PC> players;
int playerInd = 0;

ArrayList<Proj> enemyProj;
ArrayList<PC> enemies;

void setup()
{
    size(800,600);
    background(0);
    frameRate(60);
    
    ellipseMode(RADIUS);
    rectMode(CORNERS);
    
    for (int i = 0; i < keysS.length; i++)
        keysS[i] = true;
    
    enemies = new ArrayList<PC>();
    players = new ArrayList<PC>();
    loadEnemies();
    loadPlayers();
    
    star = new Stars();
    star.addMapLayer(new PVector(5,5), 5, 0.1);
    star.addTileLayer(new PVector(400,400), 5, 0.0001, color(255,255,255,40), 5);
    star.addMapLayer(new PVector(5,5), 5, -0.1);
    star.addTileLayer(new PVector(400,400), 3, 0.001, color(255,255,255,45), 5);
    //star.addMapLayer(new PVector(5,5), 5, -0.3);
    //star.addTileLayer(new PVector(400,400), 1, 0.005, color(255,255,255,60), 5);
}

void draw()
{
    background(0);
    
    for (PC p : players)
        p.update(30/frameRate);
    for (PC p : enemies)
        p.update(30/frameRate);
    
    p1.rot(PI/128);
    
    PVector controlCoords = new PVector(control.pos.x, control.pos.y);
    controlCoords.mult(-1);
    controlCoords.add(new PVector(width/2, height/2));
    
    star.render(controlCoords, control.pos, 2);
    
    for (PC p : players)
        p.render(controlCoords);
    for (PC p : enemies)
        p.render(controlCoords);
    
    p1.render(controlCoords);
    p2.render(controlCoords);
    
    playerSwitchCheck();
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
