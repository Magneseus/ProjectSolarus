
/**
 * Status bar, given an IntBox for val and max Val, will render
 * a status bar that will fill itself to the correct percentage.
 * @author Matt
 *
 */
class UIStatusBar extends UI
{
    // Members
    private IntBox val, maxVal;
    private color col;
    
    
    /**
     * @param pos Position Vector
     * @param size Size Vector
     * @param val Reference to the value to store
     * @param maxVal Reference to the maximum value
     * @param col Color to display
     */
    UIStatusBar(PVector pos, PVector size, IntBox val, IntBox maxVal, color col)
    {
        super(pos,size);
        
        this.val = val;
        this.maxVal = maxVal;
        
        this.col = col;
    }
    
    
    public void render(PVector off)
    {
        super.render(off);
        
        stroke(col);
        fill(col);
        
        float fillSize = ((float)val.store / (float)maxVal.store) * size.x;
        
        rect(pos.x + offset.x, pos.y + offset.y, fillSize, size.y);
        
        fill(0,0,0);
        rect(pos.x + offset.x + fillSize, pos.y + offset.y, size.x - fillSize, size.y);
    }
    
    public boolean update()
    {
        return true;
    }
    
    
    // GETTERS AND SETTERS
    public void setVal(IntBox newVal) {val=newVal;}
    public IntBox getVal() {return val;}
    
    public void setMaxVal(IntBox newMaxVal) {maxVal=newMaxVal;}
    public IntBox getMaxVal() {return maxVal;}
    
    public void setCol(color newCol) {col=newCol;}
    public color getCol() {return col;}
}
