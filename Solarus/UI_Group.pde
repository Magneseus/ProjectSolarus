
class UIGroup extends UI
{
    // Members
    private ArrayList<UI> elements;
    
    
    UIGroup(PVector pos)
    {
        super(pos);
        elements = new ArrayList<UI>();
    }
    
    UIGroup(PVector pos, PVector size)
    {
        super(pos,size);
        elements = new ArrayList<UI>();
    }
    
    
    
    
    public void render(PVector off)
    {
        super.render(off);
        
        for (UI u : elements)
        {
            u.render(offset);
        }
    }
    
    public boolean update()
    {
        for (UI u : elements)
        {
            u.update();
        }
        
        return true;
    }
    
    public void addElement(UI newElement)
    {
        elements.add(newElement);
    }
    
    
    
    // GETTERS AND SETTERS
    
    public void setElements(ArrayList<UI> newElements) {elements=newElements;}
    public ArrayList<UI> getElements() {return elements;}
    
    
}
