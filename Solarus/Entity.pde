
abstract class Entity
{
    protected Collision col;
    public PVector pos, vel, accel;
    public float maxVel, maxAccel, maxRot;
    protected float angle;
    protected PGraphics img;
    protected boolean showHitBox;
    
    public abstract boolean update(float delta);
    
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
    
    public void moveTo(PVector pos)
    {
        this.pos = pos;
        
        col.moveTo(pos);
    }
    
    public void rot(float x)
    {
        angle += x;
        if (angle > 2*PI)
            angle = angle - (2*PI);
        else if (angle < 0)
            angle = (2*PI) + angle;
        
        col.rot(x);
    }
    
    public void rotTo(float x)
    {
        angle = x;
        
        col.rotTo(x);
    }
    
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
    
    public boolean collide(Entity e)
    {
        return col.collide(e.col);
    }
    
    public void toggleHitBox()
    {
        showHitBox = !showHitBox;
    }
    
    public PGraphics getImage()
    {
        return img;
    }
    
    public float getAngle()
    {
        return angle;
    }
}
