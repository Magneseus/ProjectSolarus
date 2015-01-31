
class Ship
{
    PImage sprite;
    PVector pos, vel;
    
    int w,h;
    
    Ship(PVector pos_, PVector vel_, int w_, int h_)
    {
        pos = pos_;
        vel = vel_;
        
        w = w_;
        h = h_;
    }
    
    boolean update(float delta)
    {
        boolean returnVal = true;
        pos.add(PVector.mult(vel,delta));
        
        if (pos.x < -(w-width) || pos.x > w || pos.x < -(h-height) || pos.y > h)
            returnVal = false;
        
        return returnVal;
    }
    
    void render()
    {
        int x = (int)(pos.x - (sprite.width/2));
        int y = (int)(pos.y - (sprite.height/2));
        
        pushMatrix();
        translate(pos.x, pos.y);
        rotate(vel.heading() + HALF_PI);
        image(sprite, -sprite.width/2, -sprite.height/2);
        popMatrix();
    }
    
    PImage getSprite()
    {
        return sprite;
    }
    
    void setSprite(PGraphics newSprite)
    {
        sprite = newSprite.get();
    }
    
    void setSprite(PImage newSprite)
    {
        sprite = newSprite.get();
    }
    
}

