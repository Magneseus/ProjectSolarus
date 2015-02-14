boolean debug_ = false;

Collision c, cc;
PC p, p1;

void setup()
{
    size(800,600);
    background(0);
    frameRate(60);
    
    ellipseMode(RADIUS);
    rectMode(CORNERS);
    
    ArrayList<Shape> a = new ArrayList<Shape>();
    ArrayList<Shape> a1 = new ArrayList<Shape>();
    
    Circ c1 = new Circ(new PVector(0, -80), 40);
    Circ c2 = new Circ(new PVector(0, 80), 40);
    Rect r1 = new Rect(new PVector(-40, -80), new PVector(40, 80));
    a.add(c1);
    a.add(c2);
    a.add(r1);
    
    Rect r = new Rect(new PVector(-1, -20), new PVector(1,-20),
                      new PVector(20, 20), new PVector(-20, 20));
    r.ct = new PVector(0,0);
    Rect r2 = new Rect(new PVector(-20,-20), new PVector(20,20));
    a1.add(r);
    
    c = new Collision(a, new PVector(width/2, height/2));
    cc = new Collision(a1, new PVector(width/2,height/2));
    
    PGraphics im = createGraphics(40,40);
    im.beginDraw();
    im.fill(0,255,0);
    im.triangle(0, 40, 20, 0, 40, 40);
    im.endDraw();
    
    p = new PC(new PVector(width/2,height/2), im, cc);
    p.toggleHitBox();
    
    PGraphics im2 = createGraphics(10,10);
    im2.beginDraw();
    im2.fill(0,0,255);
    im2.rect(0,0, 10, 10);
    im2.endDraw();
    
    p1 = new PC(new PVector(width/2, height/2), im2, c);
    p1.toggleHitBox();
}

void draw()
{
    background(0);
    
    PVector pCoords = p.pos;
    
    p.update(0.5f);
    p.render(PVector.add(PVector.mult(p.pos, -1), new PVector(width/2,height/2)));
    
    p1.rot(PI/128);
    p1.render(PVector.add(PVector.mult(p.pos, -1), new PVector(width/2,height/2)));
    
    if (p.collide(p1))
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
