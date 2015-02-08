
//Abstract class to represent hit boxes
interface Shape
{
    boolean collide();
    int type();
    
    static final int SRECT = 0;
    static final int SCIRC = 1;
}

//Some small classes for convienience
class Rect implements Shape
{
    PVector tl, br;
    float radius;
    final int type = Shape.SRECT;
    
    //Assumes tl is the top left coord,
    //br is the bottom right (NOT SIZE)
    Rect(PVector tl, PVector br)
    {
        this.tl = tl;
        this.br = br;
        
        PVector d = PVector.sub(br, tl);
        radius = d.mag();
    }
    
    boolean collide(Shape s)
    {
        boolean isColliding = false;
        
        return isColliding;
    }
    
    //Use this to move the rectangle
    void setPos(PVector newPos)
    {
        PVector d = PVector.sub(tl, newPos);
        tl = new PVector(newPos.x, newPos.y);
        
        br.add(d);
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
    
    void calcRad()
    {
        PVector d = PVector.sub(br, tl);
        radius = d.mag();
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
    
    boolean collide(Shape s)
    {
        boolean isColliding = false;
        
        //If rect-circ collision
        if (s.type() == Shape.SRECT)
        {
            
        }
        //If circ-circ collision
        else if (s.type() == Shape.SCIRC)
        {
            Circ c = s;
            
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
