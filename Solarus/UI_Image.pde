
class UIImage extends UI
{
    // Members
    private PGraphics image;
    
    UIImage(PGraphics newImage, PVector pos)
    {
        super(pos);
        image = newImage;
    }
    
    UIImage(PGraphics newImage, PVector pos, PVector size)
    {
        super(pos, size);
        image = newImage;
    }
    
    public void render(PVector off)
    {
        super.render(off);
        
        image(image.get(), (int)(pos.x + offset.x), (int)(pos.y + offset.y),
                (int)size.x, (int)size.y);
    }
    
    public boolean update()
    {
        return false;
    }
    
    
    // GETTERS AND SETTERS
    public void setImage(PGraphics newImage) {image=newImage;}
    public PGraphics getImage() {return image;}
    
}
