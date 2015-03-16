// Collision class that all Entities contain
class Collision
{
    // Members
    ArrayList<Shape> hitBox;
    PVector center;
    boolean collideable;
    private float angle;

    /**
     * Creates a new collision box.
     * 
     * @param hbox The list of shapes that create the hitbox.
     * @param center The center position of the hitbox.
     */
    Collision(ArrayList<Shape> hbox, PVector center)
    {
        hitBox = hbox;
        this.center = center;

        // Moves all shapes according to the center to align properly
        for (int i = 0; i < hitBox.size (); i++)
        {
            hitBox.get(i).move(center);
        }

        //Defaults to collideable
        collideable = true;

        // Default angle is upwards, so 1/2PI for processing
        angle = PI/2;
    }

    /**
     * Checks for a collision with another Collision class.
     * <p>
     * This first checks both Collision boxes for a simple radius intersection,
     * and if they are within each others radii, it will do a more complex
     * collision calculation.
     * 
     * @param c The other collision box to check
     * @return True if colliding
     */
    //TODO: fix the colliding break efficiency
    boolean collide(Collision c)
    {
        boolean isColliding = false;

        // If either one is marked as non-collideable
        if (!collideable || !c.collideable)
            return false;

        // Checks every shape with every other shape in both Collisions hitboxes
        for (int i = 0; i < hitBox.size (); i++)
        {
            for (int j = 0; j < c.hitBox.size (); j++)
            {
                if (hitBox.get(i).collide(c.hitBox.get(j)))
                {
                    isColliding = true;
                    break;
                }
            }
        }

        return isColliding;
    }

    /**
     * Moves the collision box by a given displacement p
     * @param p The given displacement
     */
    void move(PVector p)
    {
        for (int i = 0; i < hitBox.size (); i++)
        {
            hitBox.get(i).setPos(p);
        }
        center = p;
    }

    /**
     * Moves the collision box to a given position p
     * @param p The given position
     */
    void moveTo(PVector p)
    {
        //Finds the vector from the current center to the new position
        PVector d = PVector.sub(p, center);

        for (int i = 0; i < hitBox.size (); i++)
        {
            hitBox.get(i).move(d);
        }
        center = p;
    }

    // Renders the kind of "wireframe" collision box
    void render()
    {
        for (int i = 0; i < hitBox.size (); i++)
        {
            hitBox.get(i).render();
        }
    }

    /**
     * Rotates the collision box about it's center
     * @param x The angle (in radians) to rotate
     */
    void rot(float x)
    {
        for (int i = 0; i < hitBox.size (); i++)
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

        angle += x;
        if (angle > 2*PI)
            angle = angle - (2*PI);
        else if (angle < 0)
            angle = (2*PI) + angle;
    }

    /**
     * Same as rotate, but rotates to the given angle
     * @param x The angle (in radians) to rotate to
     */
    void rotTo(float x)
    {
        for (int i = 0; i < hitBox.size (); i++)
        {
            if (hitBox.get(i).type() == Shape.SRECT)
            {
                Rect r = (Rect)hitBox.get(i);
                r.rot(-angle);
                r.rot(x);
            }

            //Get center of each shape
            PVector tpos = hitBox.get(i).getPos();

            //Translate by center
            tpos.sub(center);
            //Rotate
            tpos.rotate(-angle);
            tpos.rotate(x);
            //Translate back
            tpos.add(center);

            //Re-set the position
            hitBox.get(i).setPos(tpos);
        }

        angle = x;
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

/**
 * Rectangle shape.
 * <p>
 * Has four vectors to represent each corner. Acts more like a polygon than
 * anything, as collisions will work regardless of it's rectangular-ness.
 * 
 * @author Matt
 *
 */
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
            isColliding = collideRC(this, (Circ) s);
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
        stroke(255, 0, 0);
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

        if (debug_)
        {
            pushMatrix();

            PVector controlCoords = new PVector(control.pos.x, control.pos.y);
            controlCoords.mult(-1);
            controlCoords.add(new PVector(width/2, height/2));
            translate(controlCoords.x, controlCoords.y);

            line(p1.x, p1.y, p2.x, p2.y);
            line(p2.x, p2.y, p3.x, p3.y);
            line(p3.x, p3.y, p1.x, p1.y);

            popMatrix();
        }

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
        PVector dif = PVector.sub(newPos, ct);

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


/**
 * Circle shape.
 * <p>
 * Very simple, contains a center position and a radius.
 * Can rotate around a point other than it's own center, however, which makes
 * creating capsules quite easy.
 * 
 * @author Matt
 *
 */
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

            isColliding = collideRC(r, this);
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
        stroke(255, 0, 0);
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

boolean collideRC(Rect r, Circ c)
{
    // if (r.pointInRect(c.getPos()))
    //   return true;

    if (lineIntCirc(r.tl, r.tr, c))
        return true;
    if (lineIntCirc(r.tr, r.br, c))
        return true;
    if (lineIntCirc(r.br, r.bl, c))
        return true;
    if (lineIntCirc(r.bl, r.tl, c))
        return true;

    return false;
}

boolean lineIntCirc(PVector p1, PVector p2, Circ c)
{
    boolean isInt = false;

    //Line seg.
    PVector x1 = PVector.sub(p2, p1);

    //c - p1
    PVector x2 = PVector.sub(c.getPos(), p1);
    //c - p2
    PVector x3 = PVector.sub(c.getPos(), p2);

    float theta1 = PVector.angleBetween(x1, x2);

    PVector x4 = PVector.mult(x1, -1);
    float theta2 = PVector.angleBetween(x4, x3);

    if (theta1 > PI/2)
    {
        float d = x2.mag();
        if (d < c.radius)
            isInt = true;
    } else if (theta2 > PI/2)
    {
        float d = x3.mag();
        if (d < c.radius)
            isInt = true;
    } else
    {
        float d = sin(theta1) * x2.mag();
        if (d < c.radius)
            isInt = true;
    }

    return isInt;
}
