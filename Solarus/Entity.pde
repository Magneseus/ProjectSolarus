
/**
 * Abstract Entity class that will parent any and all objects within the game
 * that have a physical body.
 * <p>
 * Contains:
 * - collision box
 * - AI module
 * - position, velocity and acceleration vectors
 * - maximum velocity, acceleration and rotational velocity caps
 * - angle
 * - PGraphics to store images
 * - toggle hitbox with showHitBox boolean
 * 
 * @author Matt
 *
 */
abstract class Entity
{
    protected Collision col;
    public PVector pos, vel, accel;
    public float maxVel, maxAccel, maxRot;
    protected float angle;
    protected PGraphics img;
    protected boolean showHitBox;
    
    public abstract boolean update(float delta);
    
    /**
     * Updates the kinetic parts of the entity (pos, vel, accel, rot)
     * 
     * @param delta The timescale to multiply by
     */
    protected void updateKin(float delta)
    {
        vel.add(PVector.mult(accel, delta));
        
        if (vel.mag() > maxVel)
            vel.setMag(maxVel);
        else if (vel.mag() < 0.2)
            vel.setMag(0);
        
        pos.add(PVector.mult(vel, delta));
        
        col.move(pos);
    }
    
    /**
     * Initializes a blank Entity to add to.
     */
    protected void initBase()
    {
        col = null;
        img = null;
        
        pos = new PVector(0,0);
        vel = new PVector(0,0);
        accel = new PVector(0,0);
        
        maxVel = 0;
        maxAccel = 0;
        maxRot = 0;
        
        angle = 0;
        showHitBox = false;
    }
    
    /**
     * Calculates the distance to another Entity.
     * 
     * @param other The Entity to check
     * @return The float distance to that Entity
     */
    public float distance(Entity other)
    {
        return dist(pos.x, pos.y, other.pos.x, other.pos.y);
    }
    
    /**
     * Moves the entity (and it's collision box) to the specified pos
     * 
     * @param pos The position vector to move to
     */
    public void moveTo(PVector pos)
    {
        this.pos = pos;
        
        col.moveTo(pos);
    }
    
    /**
     * Rotates the entity (and it's collision box) by the specified angle
     * @param x The angle (in radians) to rotate by
     */
    public void rot(float x)
    {
        angle += x;
        if (angle > 2*PI)
            angle = angle - (2*PI);
        else if (angle < 0)
            angle = (2*PI) + angle;
        
        col.rot(x);
    }
    
    /**
     * Rotates the entity (and it's collision box) to the specified angle
     * @param x The angle (in radians) to rotate to
     */
    public void rotTo(float x)
    {
        angle = x;
        
        col.rotTo(x);
    }
    
    /**
     * Renders the image in the center of the Entity
     * @param trans The offset to render it at.
     */
    public void render(PVector trans)
    {
        pushMatrix();
        
        translate(trans.x, trans.y);
        if (showHitBox)
            col.render();
        
        translate(pos.x, pos.y);
        rotate(angle);
        translate(-img.width/2, -img.height/2);
        
        image(img, 0, 0);
        
        popMatrix();
    }
    
    /**
     * Collide this entity with another entity.
     * @param e Entity to check collision with.
     * @return True if colliding
     */
    public boolean collide(Entity e)
    {
        return col.collide(e.col);
    }
    
    /**
     * Toggles the visibility of the hitbox
     */
    public void toggleHitBox()
    {
        showHitBox = !showHitBox;
    }
    
    /**
     * @return The reference to the PGraphics image.
     */
    public PGraphics getImage()
    {
        return img;
    }
    
    /**
     * @return The current angle (in radians)
     */
    public float getAngle()
    {
        return angle;
    }
}
