
class PC extends Entity
{
    private int health;
    private boolean inControl;
    
    PC (PVector pos, PGraphics img, Collision c)
    {
        initBase();
        
        this.pos = pos;
        this.img = img;
        this.col = c;
        
        inControl = false;
    }
    
    boolean update(float delta)
    {
        updateKin(delta);
        
        //Check key and mouse presses
        if (inControl)
        {
            
        }
        
        if (health < 0)
            return false;
        
        return true;
    }
    
    void setControl(boolean c)
    {
        inControl = c;
    }
    
    void setCollision(Collision c)
    {
        this.col = c;
    }
}

PC parsePC(String fileName)
{
    String[] lines = loadStrings(fileName);
    PC returnP = new PC(null, null, null);
    returnP.initBase();
    
    for (int i = 0; i < lines.length; i++)
    {
        //Check if not comment or blank
        if (lines[i].length() != 0 && lines[i].charAt(0) != '#')
        {
            String ln[] = split(lines[i], "=");
            String line = ln[0];
            String data[] = split(ln[1], ",");
            
            
        }
    }
    
    return returnP;
}
