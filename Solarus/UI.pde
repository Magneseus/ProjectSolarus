/**
 * Abstract parent class that all UI elements will be based off.
 * <P>
 * Contains:
 * - Position, Size and Offset vectors
 * - Center boolean, to store whether the position is the center or the TL coords
 * 
 * @author Matt
 *
 */
abstract class UI
{
    // Members
    protected PVector pos, size, offset;
    protected boolean center = true;
    protected boolean enabled = true;
    
    
    /**
     * @param pos Position vector
     */
    UI(PVector pos)
    {
        this.pos = pos;
        size = new PVector(0,0);
    }
    
    /**
     * @param pos Position Vector
     * @param size Size Vector
     */
    UI(PVector pos, PVector size)
    {
        this.pos = pos;
        this.size = size;
    }
    
    /**
     * Renders the UI element with the given offset
     * @param off Offset Vector
     */
    public void render(PVector off)
    {
        if (!enabled)
            return;
        
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
    
    public void setEnabled(boolean newEnable) {enabled=newEnable;}
    public boolean getEnabled() {return enabled;}
}
