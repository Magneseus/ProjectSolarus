
/**
 * Image class, for simplicity.
 * @author Matt
 *
 */
class UIImage extends UI
{
    // Members
    private PGraphics image;
    
    UIImage(PVector pos, PGraphics newImage)
    {
        super(pos);
        image = newImage;
    }
    
    UIImage(PVector pos, PVector size, PGraphics newImage)
    {
        super(pos, size);
        image = newImage;
    }
    
    public void render(PVector off)
    {
        if (!enabled)
            return;
        
        super.render(off);
        
        image(image.get(), (int)(pos.x + offset.x), (int)(pos.y + offset.y),
                (int)size.x, (int)size.y);
    }
    
    public boolean update()
    {
        if (!enabled)
            return false;
        
        return true;
    }
    
    
    // GETTERS AND SETTERS
    public void setImage(PGraphics newImage) {image=newImage;}
    public PGraphics getImage() {return image;}
    
}
