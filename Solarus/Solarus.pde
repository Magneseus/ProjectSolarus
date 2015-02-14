boolean debug_ = false;

Collision c, cc;
PC p, p1, p2;

void setup()
{
    size(800,600);
    background(0);
    frameRate(60);
    
    ellipseMode(RADIUS);
    rectMode(CORNERS);
    
    p = parsePC("test_triangle.player");
    PGraphics im = createGraphics(40,40);
    im.beginDraw();
    im.fill(0,255,0);
    im.triangle(0, 40, 20, 0, 40, 40);
    im.endDraw();
    
    p.setImage(im);
    p.moveTo(new PVector(width/2, height/2));
    p.toggleHitBox();
    
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

void draw()
{
    background(0);
    
    PVector pCoords = p.pos;
    
    p.update(0.5f);
    p.render(PVector.add(PVector.mult(p.pos, -1), new PVector(width/2,height/2)));
    
    p1.rot(PI/128);
    p1.render(PVector.add(PVector.mult(p.pos, -1), new PVector(width/2,height/2)));
    
    p2.render(PVector.add(PVector.mult(p.pos, -1), new PVector(width/2,height/2)));
    
    
    if (p.collide(p1) || p.collide(p2))
    {
        PGraphics im = p.getImage();
        im.beginDraw();
        im.fill(255,0,0);
        im.triangle(0, 40, 20, 0, 40, 40);
        im.endDraw();
    }
    else
    {
        PGraphics im = p.getImage();
        im.beginDraw();
        im.fill(0,255,0);
        im.triangle(0, 40, 20, 0, 40, 40);
        im.endDraw();
    }
    
    if (keyPressed && key == 'a')
        p.rot(-PI/64);
    else if (keyPressed && key == 'd')
        p.rot(PI/64);
    
    if (keyPressed)
    {
        
        if (key == 'w')
        {
            PVector v = PVector.fromAngle(p.getAngle() + PI/2);
            v.setMag(10);
            v.mult(-1);
            p.vel = v;
        }
        else if (key == 's')
        {
            PVector v = PVector.fromAngle(p.getAngle() + PI/2);
            v.setMag(10);
            
            p.vel = v;
        }
        else
        {
            PVector v = p.vel;
            v.mult(0.2);
            if (v.mag() < 1)
                p.vel = new PVector(0,0);
        }
    }
    else
    {
        PVector v = p.vel;
            v.mult(0.2);
            if (v.mag() < 1)
                p.vel = new PVector(0,0);
    }
}
