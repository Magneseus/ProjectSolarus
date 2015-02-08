
class Collision
{
    ArrayList<Shape> hitBox;
    
    Collision(ArrayList<Shape> hbox)
    {
        hitBox = hbox;
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
    
}

//Abstract interface to represent Shapes
interface Shape
{
    boolean collide(Shape s);
    int type();
    
    static final int SRECT = 0;
    static final int SCIRC = 1;
}

//Some small classes for convienience

class Rect implements Shape //BROKEN FOR NOW
{
    PVector tl, tr, bl, br;
    float radius;
    final int type = Shape.SRECT;
    
    //Assumes tl is the top left coord,
    //br is the bottom right (NOT SIZE)
    Rect(PVector tl, PVector br)
    {
        this.tl = tl;
        this.br = br;
        
        this.tr = new PVector(br.x, tl.y);
        this.bl = new PVector(tl.x, br.y);
        
        PVector d = PVector.sub(br, tl);
        radius = d.mag();
    }
    
    Rect(PVector tl, PVector tr, PVector br, PVector bl)
    {
        this.tl = tl;
        this.tr = tr;
        this.br = br;
        this.bl = bl;
        
        PVector d = PVector.sub(br, tl);
        radius = d.mag()/2;
    }
    
    //Collisions
    boolean collide(Shape s)
    {
        boolean isColliding = false;
        
        return isColliding;
    }
    
    
    
    
    
    //     GETTERS & SETTERS     //
    
    //Return the position (center)
    PVector getPos()
    {
        PVector pos = new PVector(br.x, br.y);
        return pos;
    }
    
    //Use this to move the rectangle
    void setPos(PVector newPos)
    {
        PVector tPos = PVector.div(newPos, 2);
        PVector d = PVector.sub(tl, tPos);
        tl = new PVector(tPos.x, tPos.y);
        
        br.add(d);
    }
    
    //Use this to move the rectangle (top left)
    void setPos(PVector newPos, boolean oc)
    {
        if (oc)
        {
            PVector d = PVector.sub(tl, newPos);
            tl = new PVector(newPos.x, newPos.y);
        
            br.add(d);
        }
        else
            setPos(newPos);
    }
    
    //Use this to change vector, to account
    //for the radius change
    void setTL(PVector newTL)
    {
        tl = new PVector(newTL.x, newTL.y);
        calcRad();
    }
    
    //Use this to change vector, to account
    //for the radius change
    void setBR(PVector newBR)
    {
        br = new PVector(newBR.x, newBR.y);
        calcRad();
    }
    
    //Calculate the new "radius"
    private void calcRad()
    {
        PVector d = PVector.sub(br, tl);
        radius = d.mag() / 2;
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
    
    int type()
    {
        return type;
    }
}
