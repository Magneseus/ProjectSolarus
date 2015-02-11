boolean debug_ = false;

Collision c, cc;

void setup()
{
    size(800,600);
    background(0);
    frameRate(60);
    
    ellipseMode(RADIUS);
    rectMode(CORNERS);
    
    Rect r = new Rect(new PVector(-40,-80), new PVector(40,-80),
                      new PVector(40,80), new PVector(-40,80));
    Circ c1 = new Circ(new PVector(0, -80), 40);
    Circ c2 = new Circ(new PVector(0, 80), 40);
    
    ArrayList<Shape> a = new ArrayList<Shape>();
    a.add(r);
    a.add(c1);
    a.add(c2);
    
    Circ c3 = new Circ(new PVector(0, 0), 40);
    Rect r1 = new Rect(new PVector(-40,-40), new PVector(40,40));
    ArrayList<Shape> a1 = new ArrayList<Shape>();
    a1.add(c3);
    
    c = new Collision(a, new PVector(width/2, height/2));
    cc = new Collision(a1, new PVector(0,0));
}

void draw()
{
    background(0);
    strokeWeight(5);
    
    c.render();
    c.rot(PI/128);
    
    cc.moveTo(new PVector(mouseX, mouseY));
    cc.render();
    
    println(c.collide(cc));
}
