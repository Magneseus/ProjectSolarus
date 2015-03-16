
abstract class UI
{
    // Members
    protected PVector pos, size, offset;
    protected boolean center = true;
    
    
    UI(PVector pos)
    {
        this.pos = pos;
        size = new PVector(0,0);
    }
    
    UI(PVector pos, PVector size)
    {
        this.pos = pos;
        this.size = size;
    }
    
    public void render(PVector off)
    {
        offset = new PVector(0,0);
        if (center)
            offset = new PVector(-size.x/2, -size.y/2);
        
        offset.add(off);
    }
    
    public abstract boolean update();
    
    
    // GETTERS AND SETTERS
    
    public void setPos(PVector newPos) {pos=newPos;}
    public PVector getPos() {return pos;}
    
    public void setSize(PVector newSize) {size=newSize;}
    public PVector getSize() {return size;}
    
    public void setCenter(boolean newCenter) {center=newCenter;}
    public boolean getCenter() {return center;}
}
