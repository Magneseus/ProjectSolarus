

class SimpleStar
{
    PVector pos, vel;
    int size, colorReduc, wHeight;
        
    SimpleStar(PVector pos_, PVector vel_, int size_, int colorReduc_, int wHeight_)
    {
        pos = pos_;
        vel = vel_;
        
        size = size_;
        colorReduc = colorReduc_;
        wHeight = wHeight_;
    }
    
    boolean update(float delta)
    {
        boolean returnVal = true;
        
        pos.add(PVector.mult(vel, delta));
        
        if ((int)pos.y > wHeight + 20)
            returnVal = false;
        
        return returnVal;
    }
    
    void render()
    {
        fill(255,255,255,colorReduc);
        rect((int)pos.x, (int)pos.y, size, size);
    }
}
