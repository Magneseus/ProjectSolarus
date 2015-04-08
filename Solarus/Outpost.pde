

/*
 * Represents the outpost on the player's screen.
 * 
 * Upon reaching an outpost, the player is given the option to 
 * enter the UI for the market at that outpost, where they can buy
 * and sell goods.
*/
class Outpost
{
    private PVector pos;
    private float angle, angleRot;
    private float radiusOfInteraction;
    
    private String name;
    private PGraphics display;
    
    Outpost(PVector newPos, String newName, PGraphics newDisplay)
    {
        pos = newPos;
        name = newName;
        display = newDisplay;
        
        if (newDisplay == null)
        {
            display = createGraphics(200,200);
            display.beginDraw();
            display.ellipseMode(RADIUS);
            display.fill(random(255), random(255), random(255));
            display.stroke(random(255), random(255), random(255));
            display.ellipse(100,100,100,50);
            display.endDraw();
        }
        
        angle = 0f;
        angleRot = random(0.0001,0.005);
        radiusOfInteraction = dist(0,0,display.width,display.height);
    }
    
    public boolean update(PVector playerPos)
    {
        angle += angleRot;
        if (angle > TWO_PI)
            angle -= TWO_PI;
        
        if (dist(pos.x, pos.y, playerPos.x, playerPos.y) < radiusOfInteraction)
        {
            if (keys[22] && keysS[22])
            {
                keysS[22] = false;
                return true;
            }
        }
        
        return false;
    }
    
    public void render(PVector offset)
    {
        pushMatrix();
        
        translate(offset.x, offset.y);
        
        translate(pos.x, pos.y);
        rotate(angle);
        translate(-display.width/2, -display.height/2);
        
        image(display.get(), 0, 0);
        
        popMatrix();
    }
    
}
