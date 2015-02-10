Collision c;

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
    
    c = new Collision(a, new PVector(width/2, height/2));
}

void draw()
{
    background(0);
    
    c.render();
    c.rot(PI/128);
}
