
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

        health = 0;
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

    void setImage(PGraphics i)
    {
        img = i;
    }

    void setHealth(int h)
    {
        health = h;
    }
}

PC parsePC(String fileName)
{
    String[] lines = loadStrings(fileName);
    PC returnP = new PC(null, null, null);
    returnP.initBase();

    for (int i = 0; i < lines.length; i++)
    {
        //Check if a collection
        if (lines[i].length() > 0 && lines[i].charAt(0) == ':')
        {
            if (lines[i].equals(":collision:"))
            {
                int j = i+1;
                Collision tempCol;
                ArrayList<Shape> tempShapes = new ArrayList<Shape>();
                PVector tempCenter = new PVector(0, 0);

                while (lines[j].charAt (0) != ':')
                {
                    String ln[] = split(lines[j], "=");
                    String line = trim(ln[0]);
                    String data[] = split(ln[1], ",");
                    for (String s : data)
                        s = trim(s);

                    if (line.equals("Rect1"))
                    {
                        Rect r = new Rect(
                            new PVector(
                                float(trim(data[0])), 
                                float(trim(data[1])) ), 
                            new PVector(
                                float(trim(data[2])), 
                                float(trim(data[3])) ), 
                            new PVector(
                                float(trim(data[4])), 
                                float(trim(data[5])) ), 
                            new PVector(
                                float(trim(data[6])), 
                                float(trim(data[7])) ));

                        tempShapes.add(r);
                    }
                    else if (line.equals("Rect2"))
                    {
                        Rect r = new Rect(
                            new PVector(
                                float(trim(data[0])), 
                                float(trim(data[1])) ), 
                            new PVector(
                                float(trim(data[2])), 
                                float(trim(data[3])) ));

                        tempShapes.add(r);
                    }
                    else if (line.equals("Circ"))
                    {
                        Circ c = new Circ(
                            new PVector(
                                float(trim(data[0])), 
                                float(trim(data[1])) ), 
                                float(trim(data[2])) );
                        tempShapes.add(c);
                    }
                    else if (line.equals("Center"))
                    {
                        tempCenter.x = float(trim(data[0]));
                        tempCenter.y = float(trim(data[1]));
                    }
                    else if (line.equals("ct"))
                    {
                        Rect r = (Rect)tempShapes.get(tempShapes.size()-1);
                        r.ct = new PVector(
                            float(trim(data[0])), 
                            float(trim(data[1])) );
                    }
                    
                    j++;
                }

                tempCol = new Collision(tempShapes, tempCenter);
                returnP.setCollision(tempCol);

                i = j+1;
            }
        }
        //Check if not comment or blank
        else if (lines[i].length() != 0 && lines[i].charAt(0) != '#')
        {
            String ln[] = split(lines[i], "=");
            String line = trim(ln[0]);
            String data[] = split(ln[1], ",");
            for (String s : data)
                s = trim(s);

            if (line.equals("pos"))
                returnP.pos = new PVector(
                float(trim(data[0])), 
                float(trim(data[1])));
            else if (line.equals("vel"))
                returnP.vel = new PVector(
                float(trim(data[0])), 
                float(trim(data[1])));
            else if (line.equals("accel"))
                returnP.accel = new PVector(
                float(trim(data[0])), 
                float(trim(data[1])));
            else if (line.equals("maxVel"))
                returnP.maxVel = float(trim(data[0]));
            else if (line.equals("maxAccel"))
                returnP.maxAccel = float(trim(data[0]));
            else if (line.equals("maxRot"))
                returnP.maxRot = float(trim(data[0]));
            else if (line.equals("health"))
                returnP.setHealth( int(trim(data[0])) );
        }
    }

    return returnP;
}

