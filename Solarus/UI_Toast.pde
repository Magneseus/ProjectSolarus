

class UIToast extends UI
{
    // Members
    private String text;
    private long lifeStart, lifeTime;
    private color col, scol;

    private PFont font;
    private int fontSize;

    // Constructor
    UIToast(PVector pos, PVector size, String newText, long life)
    {
        super(pos, size);

        text = newText;
        lifeTime = life;

        col = color(255, 0, 0);
        scol = color(150, 20, 20);

        font = BUTTON_FONT;
        fontSize = BUTTON_FONT_SIZE;
    }

    UIToast(PVector pos, PVector size, String newText, long life, color newCol)
    {
        this(pos, size, newText, life);

        col = newCol;
        scol = col;
    }

    UIToast(PVector pos, PVector size, String newText, long life, color newCol, color newSCol)
    {
        this(pos, size, newText, life);

        col = newCol;
        scol = newSCol;
    }

    // Methods
    public void render(PVector off)
    {
        if (!enabled)
            return;

        super.render(off);

        fill(col);
        stroke(scol);

        rect((int)(pos.x + offset.x), (int)(pos.y + offset.y), 
        (int)pos.x + offset.x + size.x, (int)pos.y + offset.y + size.y);

        fill(0);
        textFont(font);
        textSize(fontSize);
        textAlign(CENTER, CENTER);
        text(text, (int)(pos.x + offset.x + size.x/2), (int)(pos.y + offset.y + size.y/2));
    }

    public boolean update()
    {
        if (!enabled)
            return false;
        
        if (millis() - lifeStart > lifeTime)
        {
            enabled = false;
        }
        
        return true;
    }



    // GETTERS AND SETTERS
}
