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

    private boolean visited;
    private ArrayList<Outpost> nodes;
    
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

        visited = false;
        nodes = new ArrayList<Outpost>();
    }
    
    public boolean update(PVector playerPos)
    {
        angle += angleRot;
        if (angle > TWO_PI)
            angle -= TWO_PI;
        
        if (dist(pos.x, pos.y, playerPos.x, playerPos.y) < radiusOfInteraction)
        {
            if (keys[6] && keysS[6])
            {
                keysS[6] = false;
                visit();
                return true;
            }
        }

        ArrayList<Outpost> ignore = new ArrayList<Outpost>();
        ignore.add(this);

        for (Outpost o : nodes)
        {
            println("test");
            if (!ignore.contains(o) && o.update(playerPos, ignore))
                return true;
        }

        return false;
    }

    private boolean update(PVector playerPos, ArrayList<Outpost> ignore)
    {
        angle += angleRot;
        if (angle > TWO_PI)
            angle -= TWO_PI;
        
        if (dist(pos.x, pos.y, playerPos.x, playerPos.y) < radiusOfInteraction)
        {
            if (keys[6] && keysS[6])
            {
                keysS[6] = false;
                visit();
                return true;
            }
        }

        ignore.add(this);
        
        for (Outpost o : nodes)
        {
            if (!ignore.contains(o) && o.update(playerPos, ignore))
                return true;
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

        ArrayList<Outpost> ignore = new ArrayList<Outpost>();
        ignore.add(this);

        for (Outpost o : nodes)
        {
            pushMatrix();
            
            translate(offset.x, offset.y);
            stroke(255,0,0);
            line(pos.x, pos.y, o.getPos().x, o.getPos().y);
            
            popMatrix();
            if (!ignore.contains(o))
                o.render(offset, ignore);
        }
    }

    public void render(PVector offset, ArrayList<Outpost> ignore)
    {
        pushMatrix();
        
        translate(offset.x, offset.y);
        
        translate(pos.x, pos.y);
        rotate(angle);
        translate(-display.width/2, -display.height/2);
        
        image(display.get(), 0, 0);
        
        popMatrix();

        ignore.add(this);

        for (Outpost o : nodes)
        {
            pushMatrix();
            
            translate(offset.x, offset.y);
            stroke(255,0,0);
            line(pos.x, pos.y, o.getPos().x, o.getPos().y);
            
            popMatrix();
            if (!ignore.contains(o))
               o.render(offset, ignore);
        }
    }


    public void generateGraph(String fileName)
    {

    }
    
    private void visit()
    {
        setVisited(true);

        PVector entrance = PVector.fromAngle(random(TWO_PI));
        if (nodes.size() > 0)
            entrance = PVector.sub(nodes.get(0).getPos(), getPos());
        
        PVector entrance2 = new PVector(entrance.x, entrance.y);

        entrance.rotate(PI/2);
        entrance.rotate(random(-PI/4, PI/4));
        entrance.setMag(random(50, 400));

        Outpost o1 = new Outpost(entrance, "t", display);
        o1.addNode(this);
        nodes.add(o1);

        entrance2.rotate(-PI/2);
        entrance2.rotate(random(-PI/4, PI/4));
        entrance2.setMag(random(50, 400));

        Outpost o2 = new Outpost(entrance2, "t1", display);
        o2.addNode(this);
        nodes.add(o2);
    }


    // GETTERS AND SETTERS
    public boolean getVisited() { return visited; }
    public void setVisited(boolean visited){ this.visited = visited; }

    public ArrayList<Outpost> getNodes() { return nodes; }
    public void setNodes(ArrayList<Outpost> nodes){ this.nodes = nodes; }
    public void addNode(Outpost node){ nodes.add(node); }

    public PVector getPos() { return pos; }
    public void setPos(PVector pos){ this.pos = pos; }
}

