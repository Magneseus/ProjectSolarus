
/**
 * Group created to store other UI elements.
 * <p>
 * Allows for all UI elements in the group to be moved and positioned as one entity.
 * <p>
 * Contains:
 * - List of UI elements within the group
 * @author Matt
 *
 */
class UIGroup extends UI
{
    // Members
    private ArrayList<UI> elements;
    
    /**
     * @param pos Position Vector
     */
    UIGroup(PVector pos)
    {
        super(pos);
        elements = new ArrayList<UI>();
    }
    
    /**
     * @param pos Position Vector
     * @param size Size Vector
     */
    UIGroup(PVector pos, PVector size)
    {
        super(pos,size);
        elements = new ArrayList<UI>();
    }
    
    
    
    /**
     * Renders all elements within the group.
     * @param off The offset to be given
     */
    public void render(PVector off)
    {
        if (!enabled)
            return;
        
        super.render(off);
        
        for (UI u : elements)
        {
            u.render(PVector.add(pos, offset));
        }
    }
    
    /**
     * Updates all elements within the group
     * @return True
     */
    public boolean update()
    {
        if (!enabled)
            return false;
        
        for (UI u : elements)
        {
            u.update();
        }
        
        return true;
    }
    
    public void add(UI newElement)
    {
        elements.add(newElement);
    }
    
    public void clear()
    {
        elements.clear();
    }
    
    
    
    // GETTERS AND SETTERS
    
    public void setElements(ArrayList<UI> newElements) {elements=newElements;}
    public ArrayList<UI> getElements() {return elements;}
    
    
}
