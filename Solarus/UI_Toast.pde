
import java.util.LinkedList;

class UIToast extends UI
{
    // Members
    private LinkedList<String> text;
    private LinkedList<Integer> lifeTime;
    private long lifeStart;
    private color col, scol;

    private PFont font;
    private int fontSize;
    
    private PVector startPos, curPos;
    private int stage, speed;

    // Constructor
    UIToast(PVector pos, PVector size)
    {
        super(pos, size);

        text = new LinkedList<String>();
        lifeTime = new LinkedList<Integer>();

        col = color(255, 0, 0);
        scol = color(150, 20, 20);
        
        startPos = new PVector(pos.x, -size.y/2 - 1);
        curPos = new PVector(startPos.x, startPos.y);
        stage = 0;
        speed = 4;

        font = BUTTON_FONT;
        fontSize = 20;
    }

    UIToast(PVector pos, PVector size, color newCol)
    {
        this(pos, size);

        col = newCol;
        scol = col;
    }

    UIToast(PVector pos, PVector size, color newCol, color newSCol)
    {
        this(pos, size);
        
        col = newCol;
        scol = newSCol;
    }

    // Methods
    public void render(PVector off)
    {
        if (!enabled)
            return;

        super.render(off);
        
        if (text.size() > 0)
        {
            fill(col);
            stroke(scol);
            
            rect((int)(curPos.x + offset.x), (int)(curPos.y + offset.y), 
            (int)curPos.x + offset.x + size.x, (int)curPos.y + offset.y + size.y);
            
            fill(0);
            textFont(font);
            textSize(fontSize);
            textAlign(CENTER, CENTER);
            
            text(text.get(0), (int)(curPos.x + offset.x + size.x/2), (int)(curPos.y + offset.y + size.y/2 - 1));
        }
    }

    public boolean update()
    {
        if (!enabled)
            return false;
        
        if (lifeTime.size() > 0)
        {
            if (stage == 0)
            {
                curPos.y += speed;
                
                if (curPos.y >= pos.y)
                {
                    curPos.y = pos.y;
                    stage = 1;
                    lifeStart = millis();
                }
            }
            else if (stage == 1)
            {
                if (millis() - lifeStart > lifeTime.get(0))
                {
                    stage = 2;
                }
            }
            else if (stage == 2)
            {
                curPos.y -= speed;
                
                if (curPos.y <= startPos.y)
                {
                    curPos.y = startPos.y;
                    stage = 3;
                    lifeStart = millis();
                    lifeTime.removeFirst();
                    text.removeFirst();
                }
            }
            else if (stage == 3)
            {
                if (millis() - lifeStart > 200)
                {
                    stage = 0;
                }
            }
        }
        
        return true;
    }
    
    public void pushToast(String message, int lifeTime)
    {
        text.add(message);
        this.lifeTime.add(new Integer(lifeTime));
        
        if (this.lifeTime.size() == 1)
            lifeStart = millis();
    }



    // GETTERS AND SETTERS
}
