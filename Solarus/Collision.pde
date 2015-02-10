
class Collision
{
    ArrayList<Shape> hitBox;
    PVector center;
    
    //The center being based off of the local coordinates
    Collision(ArrayList<Shape> hbox, PVector center)
    {
        hitBox = hbox;
        this.center = center;
        for (int i = 0; i < hitBox.size(); i++)
        {
            hitBox.get(i).move(center);
        }
    }
    
    boolean collide(Collision c)
    {
        boolean isColliding = false;
        
        for (int i = 0; i < hitBox.size(); i++)
        {
            for (int j = 0; j < c.hitBox.size(); j++)
            {
                if (hitBox.get(i).collide(c.hitBox.get(i)))
                {
                    isColliding = true;
                    break;
                }
            }
        }
        
        return isColliding;
    }
    
    void render()
    {
        for (int i = 0; i < hitBox.size(); i++)
        {
            hitBox.get(i).render();
        }
    }
    
    void rot(float x)
    {
        for (int i = 0; i < hitBox.size(); i++)
        {
            if (hitBox.get(i).type() == Shape.SRECT)
            {
                Rect r = (Rect)hitBox.get(i);
                r.rot(x);
            }
            
            //Get center of each shape
            PVector tpos = hitBox.get(i).getPos();
            
            //Translate by center
            tpos.sub(center);
            //Rotate
            tpos.rotate(x);
            //Translate back
            tpos.add(center);
            
            //Re-set the position
            hitBox.get(i).setPos(tpos);
        }
    }
    
}

//Abstract interface to represent Shapes
interface Shape
{
    boolean collide(Shape s);
    int type();
    void move(PVector p);
    void render();
    PVector getPos();
    void setPos(PVector p);
    
    static final int SRECT = 0;
    static final int SCIRC = 1;
}

//Some small classes for convienience

class Rect implements Shape
{
    PVector tl, tr, bl, br, ct;
    float radius, angle;
    final int type = Shape.SRECT;
    
    //Assumes tl is the top left coord,
    //br is the bottom right (NOT SIZE)
    Rect(PVector tl, PVector br)
    {
        this.tl = tl;
        this.br = br;
        
        this.tr = new PVector(br.x, tl.y);
        this.bl = new PVector(tl.x, br.y);
        
        //Angle in radians
        angle = 0;
        
        PVector d = PVector.sub(br, tl);
        radius = d.mag();
        
        d.div(2);
        ct = PVector.add(tl, d);
    }
    
    Rect(PVector tl, PVector tr, PVector br, PVector bl)
    {
        this.tl = tl;
        this.tr = tr;
        this.br = br;
        this.bl = bl;
        
        //Angle in radians
        angle = 0;
        
        PVector d = PVector.sub(br, tl);
        radius = d.mag()/2;
        
        d.div(2);
        ct = PVector.add(tl, d);
    }
    
    //Collisions
    boolean collide(Shape s)
    {
        boolean isColliding = false;
        
        //If rect-rect collision
        if (s.type() == Shape.SRECT)
        {
            Rect r = (Rect)s;
            
            if (dist(getPos().x, getPos().y, r.getPos().x, r.getPos().y) <
                getRad() + r.getRad())
            {
                //Check if any point lies inside the other rect
                if (pointInRect(r.tl) || pointInRect(r.tr) ||
                    pointInRect(r.br) || pointInRect(r.bl))
                        isColliding = true;
                
                if (r.pointInRect(tl) || r.pointInRect(tr) ||
                    r.pointInRect(br) || r.pointInRect(bl))
                        isColliding = true;
            }
        }
        //If rect-circ collision
        else if (s.type() == Shape.SCIRC)
        {
            
        }
        
        return isColliding;
    }
    
    //Use this to move the rectangle
    void move(PVector deltaD)
    {
        ct.add(deltaD);
        tl.add(deltaD);
        tr.add(deltaD);
        br.add(deltaD);
        bl.add(deltaD);
    }
    
    void rot(float angle)
    {
        this.angle += angle;
        
        //Record old center
        PVector ctr = new PVector(ct.x, ct.y);
        
        //Translate so center is at origin
        move(PVector.mult(ctr, -1));
        
        //Rotate all vectors
        tl.rotate(angle);
        tr.rotate(angle);
        br.rotate(angle);
        bl.rotate(angle);
        
        //Translate back
        move(ctr);
    }
    
    void rotTo(float newAngle)
    {
        angle = newAngle;
        
        //Record old center
        PVector ctr = new PVector(ct.x, ct.y);
        
        //Translate so center is at origin
        move(PVector.mult(ctr, -1));
        
        //Rotate all vectors
        tl.rotate(angle);
        tr.rotate(angle);
        br.rotate(angle);
        bl.rotate(angle);
        
        //Translate back
        move(ctr);
    }
    
    void render()
    {
        stroke(255,0,0);
        noFill();
        
        line(tl.x, tl.y, tr.x, tr.y);
        line(tr.x, tr.y, br.x, br.y);
        line(br.x, br.y, bl.x, bl.y);
        line(bl.x, bl.y, tl.x, tl.y);
    }
    
    boolean pointInRect(PVector p)
    {
        boolean colliding = true;
        
        float rSum = dist(tl.x, tl.y, tr.x, tr.y) *
                     dist(tl.x, tl.y, bl.x, bl.y);
        
        float a1 = areaOf(tl, p, bl);
        float a2 = areaOf(bl, p, br);
        float a3 = areaOf(br, p, tr);
        float a4 = areaOf(p, tr, tl);
        
        float pSum = a1 + a2 + a3 + a4;
        
        if (pSum - rSum > 2)
            colliding = false;
        
        return colliding;
    }
    
    private float areaOf(PVector p1, PVector p2, PVector p3)
    {
        float a = abs(p1.x * (p2.y - p3.y) + 
                      p2.x * (p3.y - p1.y) +
                      p3.x * (p1.y - p2.y));
        a /= 2;
        
        /*
        line(p1.x,p1.y,p2.x,p2.y);
        line(p2.x,p2.y,p3.x,p3.y);
        line(p3.x,p3.y,p1.x,p1.y);
        */
        
        return a;
    }
    
    
    
    //     GETTERS & SETTERS     //
    
    //Return the position (center)
    PVector getPos()
    {
        PVector pos = new PVector(ct.x, ct.y);
        return pos;
    }
    
    //Use this to set the position
    void setPos(PVector newPos)
    {
        PVector dif = PVector.sub(ct, newPos);
        
        ct = new PVector(newPos.x, newPos.y);
        tl.add(dif);
        tr.add(dif);
        br.add(dif);
        bl.add(dif);
    }
    
    //Calculate the new "radius"
    private void calcRad()
    {
        PVector d1 = PVector.sub(br, tl);
        PVector d2 = PVector.sub(tr, bl);
        radius = max(d2.mag()/2, d1.mag()/2);
    }
    
    //Returns the "radius", the distance between
    //the top left and the bottom right points
    float getRad()
    {
        calcRad();
        return radius;
    }
    
    int type()
    {
        return type;
    }
}

class Circ implements Shape
{
    PVector pos;
    float radius;
    final int type = Shape.SCIRC;
    
    //Assumes pos is the center of the circle
    //radius is obviously the radius
    Circ(PVector pos, float radius)
    {
        this.pos = pos;
        this.radius = radius;
    }
    
    //Simple collisions and then more complex
    boolean collide(Shape s)
    {
        boolean isColliding = false;
        
        //If rect-circ collision
        if (s.type() == Shape.SRECT)
        {
            Rect r = (Rect)s;
            
            
        }
        //If circ-circ collision
        else if (s.type() == Shape.SCIRC)
        {
            Circ c = (Circ)s;
            
            //If the distance is less than the sum of the radii, colliding
            if (dist(pos.x, pos.y, c.pos.x, c.pos.y) < (radius + c.radius))
                isColliding = true;
        }
        
        return isColliding;
    }
    
    void render()
    {
        stroke(255,0,0);
        noFill();
        
        ellipse(pos.x, pos.y, radius, radius);
    }
    
    void move(PVector deltaD)
    {
        pos.add(deltaD);
    }
    
    
    
    
    //     GETTERS & SETTERS     //
    
    
    PVector getPos()
    {
        return new PVector(pos.x, pos.y);
    }
    
    void setPos(PVector newPos)
    {
        pos = new PVector(newPos.x, newPos.y);
    }
    
    int type()
    {
        return type;
    }
}
