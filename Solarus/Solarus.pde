boolean debug_ = false;

Collision c, cc;

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
    
    Rect r = new Rect(new PVector(-20, -20), new PVector(20,20));
    a1.add(r);
    
    c = new Collision(a, new PVector(width/2, height/2));
    cc = new Collision(a1, new PVector(0,0));
}

void draw()
{
    background(0);
    
    stroke(255,0,0);
    strokeWeight(3);
    
    c.render();
    c.rot(PI/128);
    
    cc.render();
    cc.moveTo(new PVector(mouseX, mouseY));
    
    println(c.collide(cc));
}
