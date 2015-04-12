/*
 * Represents the outpost on the player's screen.
 * 
 * Upon reaching an outpost, the player is given the option to 
 * enter the UI for the market at that outpost, where they can buy
 * and sell goods.
*/

int outpostInd = 0;
String saveFile = null;
Outpost recentOutpost = null;

class Outpost
{
    private PVector pos;
    private float angle, angleRot;
    private float radiusOfInteraction;
    
    private PImage display;
    
    private boolean visited;
    private int ind;
    private ArrayList<Outpost> nodes;
    
    Outpost(PVector newPos, PImage newDisplay)
    {
        pos = newPos;
        display = newDisplay;
        
        angle = 0f;
        angleRot = random(0.0001,0.005);
        radiusOfInteraction = dist(0,0,display.width,display.height);

        visited = false;
        ind = outpostInd;
        outpostInd++;
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
            if (!ignore.contains(o) && o.update(playerPos, ignore))
                return true;
        }

        return false;
    }
    
    // Update helper function
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
        
        translate((int)offset.x, (int)offset.y);
        
        translate((int)pos.x, (int)pos.y);
        rotate(angle);
        translate(int(-display.width/2), int(-display.height/2));
        
        image(display, 0, 0);
        
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
    
    // Render helper function
    private void render(PVector offset, ArrayList<Outpost> ignore)
    {
        pushMatrix();
        
        translate((int)offset.x, (int)offset.y);
        
        translate((int)pos.x, (int)pos.y);
        rotate(angle);
        translate(int(-display.width/2), int(-display.height/2));
        
        image(display, 0, 0);
        
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
        String[] list = {""};
        saveStrings(fileName, list);
        PrintWriter output = createWriter(fileName);
        
        ArrayList<Outpost> ignore = new ArrayList<Outpost>();
        ArrayList<String> nodeList = new ArrayList<String>();
        ArrayList<String> edgeList = new ArrayList<String>();
        
        int x = (int)getPos().x;
        int y = (int)getPos().y;
        int visit = visited ? 1 : 0;
        int picNum = 0;
        for (int i = 0; i < outpostImage.length; i++)
        {
            if (outpostImage[i] == display)
            {
                picNum = i;
                break;
            }
        }
        
        nodeList.add(getInd() + " "
                     + x + " "
                     + y + " "
                     + visit + " "
                     + picNum);
        
        for (Outpost o : nodes)
            edgeList.add(getInd() + " " + o.getInd());
        
        ignore.add(this);
        
        for (Outpost o : nodes)
        {
            if (!ignore.contains(o))
                o.generateGraph(ignore, nodeList, edgeList);
        }
        
        for (String s : nodeList)
            output.println(s);
        
        output.println("#");
        
        for (String s : edgeList)
            output.println(s);
        
        output.flush();
        output.close();
    }
    
    // Graph generator helper function
    private void generateGraph(ArrayList<Outpost> ignore,
                               ArrayList<String> nodeList,
                               ArrayList<String> edgeList)
    {
        int x = (int)getPos().x;
        int y = (int)getPos().y;
        int visit = visited ? 1 : 0;
        int picNum = 0;
        for (int i = 0; i < outpostImage.length; i++)
        {
            if (outpostImage[i] == display)
            {
                picNum = i;
                break;
            }
        }
        
        nodeList.add(getInd() + " "
                     + x + " "
                     + y + " "
                     + visit + " "
                     + picNum);
        
        for (Outpost o : nodes)
            edgeList.add(getInd() + " " + o.getInd());
        
        ignore.add(this);
        
        for (Outpost o : nodes)
        {
            if (!ignore.contains(o))
                o.generateGraph(ignore, nodeList, edgeList);
        }
    }
    
    private void visit()
    {
        recentOutpost = this;
        
        if (!visited)
        {
            setVisited(true);
    
            PVector entrance = PVector.fromAngle(random(TWO_PI));
            if (nodes.size() > 0)
                entrance = PVector.sub(nodes.get(0).getPos(), getPos());
            
            PVector entrance2 = new PVector(entrance.x, entrance.y);
    
            entrance.rotate(PI/2);
            entrance.rotate(random(-PI/4, PI/4));
            entrance.setMag(random(5000, 10000));
            entrance.add(getPos());
    
            Outpost o1 = new Outpost(entrance, 
                    outpostImage[int(random(outpostImage.length))]);
            o1.addNode(this);
            nodes.add(o1);
    
            entrance2.rotate(-PI/2);
            entrance2.rotate(random(-PI/4, PI/4));
            entrance2.setMag(random(5000, 10000));
            entrance2.add(getPos());
    
            Outpost o2 = new Outpost(entrance2, 
                    outpostImage[int(random(outpostImage.length))]);
            o2.addNode(this);
            nodes.add(o2);
        }
    }


    // GETTERS AND SETTERS
    public boolean getVisited() { return visited; }
    public void setVisited(boolean visited){ this.visited = visited; }

    public ArrayList<Outpost> getNodes() { return nodes; }
    public void setNodes(ArrayList<Outpost> nodes){ this.nodes = nodes; }
    public void addNode(Outpost node){ nodes.add(node); }

    public PVector getPos() { return pos; }
    public void setPos(PVector pos){ this.pos = pos; }
    
    public int getInd(){ return ind; }
    public void setInd(int ind){ this.ind = ind; }
}


// Function to load an outpost graph from a .tgf file
public Outpost loadOutpostGraph(String filename)
{
    ArrayList<Outpost> nodes = new ArrayList<Outpost>();
    
    String[] lines = loadStrings(filename);
    int edgeInd = 0;
    
    for (int i = 0; i < lines.length; i++)
    {
        String line = lines[i];
        if (line.charAt(0) == '#')
        {
            outpostInd = i;
            edgeInd = i+1;
            break;
        }
        String[] data = split(line, ' ');
        
        int ind = int(data[0]);
        PVector pos = new PVector(float(data[1]), float(data[2]));
        boolean visit = int(data[3]) == 1 ? true : false;
        int picNum = int(data[4]);
        
        Outpost o = new Outpost(pos, outpostImage[picNum]);
        o.setInd(ind);
        o.setVisited(visit);
        nodes.add(o);
    }
    
    for (int i = edgeInd; i < lines.length; i++)
    {
        String line = lines[i];
        if (line.length() == 0)
            break;
        String[] data = split(line, ' ');
        
        int ind1 = int(data[0]);
        int ind2 = int(data[1]);
        
        Outpost o1 = null;
        Outpost o2 = null;
        
        for (Outpost o : nodes)
        {
            if (o.getInd() == ind1)
                o1 = o;
            if (o.getInd() == ind2)
                o2 = o;
        }
        if (o1 != null && o2 != null)
            o1.addNode(o2);
    }
    
    Outpost ret = null;
    
    for (Outpost o : nodes)
    {
        if (o.getInd() == 0)
        {
            ret = o;
            break;
        }
    }
    
    return ret;
}

