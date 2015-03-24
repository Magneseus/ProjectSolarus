
/**
 * Button calls a function in the global scope,
 * that function will respond according to the 
 * message of that Button.
 * @author Matt
 *
 */

// Global Constants since we can't have static
// variables in inner classes
PFont BUTTON_FONT = createFont("Times New Roman", 15);
int BUTTON_FONT_SIZE = 15;

class UI_Button extends UI
{
    // Members
    private String text;
    private Command func;
    private color col, scol;

    private PFont font;
    private int fontSize;

    // Constructor
    UI_Button(PVector pos, PVector size, String newText, Command newFunc)
    {
        super(pos, size);

        text = newText;
        func = newFunc;

        col = color(255, 0, 0);
        scol = col;

        font = BUTTON_FONT;
        fontSize = BUTTON_FONT_SIZE;
    }

    UI_Button(PVector pos, PVector size, String newText, Command newFunc, color newCol)
    {
        this(pos, size, newText, newFunc);

        col = newCol;
        scol = col;
    }

    UI_Button(PVector pos, PVector size, String newText, Command newFunc, color newCol, color newSCol)
    {
        this(pos, size, newText, newFunc);

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
        (int)size.x, (int)size.y, 7);

        fill(0);
        textFont(font);
        textSize(fontSize);
        text(text, (int)(pos.x + offset.x + size.x/2), (int)(pos.y + offset.y + size.y/2));
    }

    public boolean update()
    {
        if (!enabled)
            return false;

        // If the user has clicked in the button, call the function
        if (mousePressed && mouseS)
        {
            if (mouseX > pos.x && mouseX < pos.x + size.x &&
                mouseY > pos.y && mouseY < pos.y + size.y)
            {
                func.execute();
                mouseS = false;
            }
        }

        return true;
    }



    // GETTERS AND SETTERS
}

/* Interface for all methods that can be called
 * by the UI_Button, all methods must implement
 */
interface Command
{
    public void execute();
}
