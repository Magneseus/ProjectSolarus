boolean debug_ = false;

PC p, p1, p2;
PC control;

void setup()
{
    size(800,600);
    background(0);
    frameRate(60);
    
    ellipseMode(RADIUS);
    rectMode(CORNERS);
    
    for (int i = 0; i < keysS.length; i++)
        keysS[i] = true;
    
    loadPlayers();
}

void draw()
{
    background(0);
    
    p.update(0.5f);
    p1.rot(PI/128);
    
    PVector controlCoords = new PVector(control.pos.x, control.pos.y);
    controlCoords.mult(-1);
    controlCoords.add(new PVector(width/2, height/2));
    
    p.render(controlCoords);
    p1.render(controlCoords);
    p2.render(controlCoords);
    
    if (p.collide(p1) || p.collide(p2))
    {
        PGraphics im = p.getImage();
        im.beginDraw();
        im.stroke(255,0,0);
        im.fill(255,0,0);
        im.triangle(0, 40, 20, 0, 40, 40);
        im.endDraw();
    }
    else
    {
        PGraphics im = p.getImage();
        im.beginDraw();
        im.stroke(0,255,0);
        im.fill(0,255,0);
        im.triangle(0, 40, 20, 0, 40, 40);
        im.endDraw();
    }
}

//Temp function
void loadPlayers()
{
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
