/**
 * Main class used for both the player and the AI ships.
 * <p>
 * Contains:
 * - IntBox for health storage
 * - projectile count and maximum
 * - inControl variable, if True the PC will take keyboard and mouse input
 * - percentF/S/B: percentage amounts for the speed in each direction of movement
 * - slow: the percentage to slow velocity when no movement keys are pressed
 * - rotThresh: the furthest angle the PC can be facing it's target and not rotate any more
 * 
 * - alf: Alf, your personal AI assistant
 * 
 * - projList, enemyList: projectile and enemy lists
 * @author Matt
 *
 */
class PC extends Entity
{
    private IntBox health;
    private int projCount, projMax;
    private boolean inControl;
    private float percentF, percentB, percentS, slow, rotThresh;

    private AI alf;
    //CHANGE
    public boolean enemy = false;

    public ArrayList<Proj> projList;
    public ArrayList<PC> enemyList;

    /**
     * Creates a brand new PC.
     * @param pos Center position to start at
     * @param img The PGraphic to display
     * @param c The collision box of the Entity
     */
    PC (PVector pos, PGraphics img, Collision c)
    {
        initBase();
        enemy = false;

        this.pos = pos;
        this.img = img;
        this.col = c;

        health = new IntBox(0);
        projCount = 0;
        inControl = false;

        percentF = 1;
        percentS = 1;
        percentB = 1;

        rotThresh = 32;

        alf = new AI(null, null);
    }

    /**
     * Updates the kinetic parts, and if in control the user input.
     * If not in control, but the AI is active, the AI will act as the user input.
     * 
     * @param delta The timescale to multiply kinetic actions by.
     * @return False, if the PC is out of health
     */
    boolean update(float delta)
    {
        //Update kinetic stuff
        updateKin(delta);

        //Check key and mouse presses
        if (inControl)
        {
            //Find angle to match due to mouse position
            PVector mouseCoords = new PVector(mouseX, mouseY);
            PVector dis = PVector.sub(mouseCoords, new PVector(width/2, height/2));
            PVector ang = PVector.fromAngle(angle);
            ang.rotate(-PI/2);

            boolean tCW = false;
            boolean tCCW = false;

            if (PVector.angleBetween(dis, ang) > PI/rotThresh)
            {
                float dot = (ang.x * -dis.y) + (ang.y * dis.x);

                if (dot >= 0)
                    tCW = true;
                else
                    tCCW = true;
            }

            if (tCW)
                rot(-maxRot / frameRate);
            else if (tCCW)
                rot(maxRot / frameRate);

            PVector one = new PVector(0, 0);
            PVector two = new PVector(0, 0);

            // W
            if (keys[0])
            {
                one = PVector.fromAngle(angle - PI/2);
                one.mult(10 * percentF);
            } else if (keys[2])
            {
                one = PVector.fromAngle(angle + PI/2);
                one.mult(10 * percentB);
            }
            // A
            if (keys[1])
            {
                two = PVector.fromAngle(angle + PI);
                two.mult(10 * percentS);
            } else if (keys[3])
            {
                two = PVector.fromAngle(angle);
                two.mult(10 * percentS);
            }
            
            //If not moving, slow the entity down
            if (!keys[0] && !keys[1] && !keys[2] && !keys[3])
            {
                accel = new PVector(vel.x, vel.y);
                accel.mult(-slow);
            } else
            {
                PVector a = PVector.add(one, two);
                a.setMag(maxAccel);
                accel = new PVector(a.x, a.y);
            }

            //Projectiles
            if (mousePressed && mouseS)
            {
                //If we can make more projectiles, do so
                if (projCount < projMax)
                {
                    Proj ptmp = parseProj("test.bullet");
                    ptmp.originator = this;
                    ptmp.targetList = enemyList;

                    ptmp.pos = new PVector(pos.x, pos.y);
                    ptmp.vel = PVector.fromAngle(angle-PI/2);
                    ptmp.vel.setMag(ptmp.maxVel);
                    
                    if (PVector.angleBetween(ptmp.vel, vel) < PI/2)
                        ptmp.vel.add(vel);

                    PGraphics im = createGraphics(30, 30);
                    im.beginDraw();
                    im.image(friendP1, 0, 0, 30, 30);
                    im.endDraw();

                    ptmp.setImage(im);

                    projList.add(ptmp);

                    projCount++;
                }
                mouseS = false;
            }
        }
        //Update the AI
        else
        {
            alf.update(this);
        }
        
        //If we're dead, tell 'em
        if (health.store <= 0)
            return false;

        return true;
    }
    
    /**
     * Called when a projectile destroys itself, decrement the count
     */
    void removeProj()
    {
        projCount--;
    }
    
    // GETTERS AND SETTERS
    void setControl(boolean c)
    {
        inControl = c;
    }

    void setAITargets(ArrayList<PC> targ)
    {
        alf.setTargets(targ);
        enemyList = targ;
    }
    
    void setAIFriend(ArrayList<PC> friend)
    {
        alf.setFriend(friend);
    }

    void setAIInfo(HashMap<String, Integer> info)
    {
        alf.setInfo(info);
    }

    void setAI(AI a)
    {
        alf = a;
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
        health = new IntBox(h);
    }
    
    IntBox getHealth()
    {
        return health;
    }

    void setProjMax(int h)
    {
        projMax = h;
    }

    void setRotThresh(float f)
    {
        rotThresh = f;
    }

    float getRotThresh()
    {
        return rotThresh;
    }

    void setPercentF(float f)
    {
        percentF = f;
    }

    void setPercentB(float f)
    {
        percentB = f;
    }

    void setPercentS(float f)
    {
        percentS = f;
    }

    void setSlow(float f)
    {
        slow = f;
    }
}

/**
 * The worst function I've ever made in my life.
 * <p>
 * Parses a text file for information on the PC. Not even gonna bother describing this one.
 * <p>
 * TODO: Describe how to use the file properly to create PCs.
 * @param fileName File to load from.
 * @return The created PC.
 */
PC parsePC(String fileName)
{
    String[] lines = loadStrings(fileName);
    PC returnP = new PC(null, null, null);
    returnP.initBase();

    HashMap<String, Integer> aiInfo = new HashMap<String, Integer>();

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
                    } else if (line.equals("Rect2"))
                    {
                        Rect r = new Rect(
                        new PVector(
                        float(trim(data[0])), 
                        float(trim(data[1])) ), 
                        new PVector(
                        float(trim(data[2])), 
                        float(trim(data[3])) ));

                        tempShapes.add(r);
                    } else if (line.equals("Circ"))
                    {
                        Circ c = new Circ(
                        new PVector(
                        float(trim(data[0])), 
                        float(trim(data[1])) ), 
                        float(trim(data[2])) );
                        tempShapes.add(c);
                    } else if (line.equals("Center"))
                    {
                        tempCenter.x = float(trim(data[0]));
                        tempCenter.y = float(trim(data[1]));
                    } else if (line.equals("ct"))
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
            else if (line.equals("projMax"))
                returnP.setProjMax( int(trim(data[0])) );
            else if (line.equals("percentF"))
                returnP.setPercentF(float(trim(data[0])) );
            else if (line.equals("percentB"))
                returnP.setPercentB(float(trim(data[0])) );
            else if (line.equals("percentS"))
                returnP.setPercentS(float(trim(data[0])) );
            else if (line.equals("slow"))
                returnP.setSlow(float(trim(data[0])) );
            else if (line.equals("rotThresh"))
                returnP.setRotThresh(float(trim(data[0])) );
            else if (line.equals("AI.aggro"))
                aiInfo.put( "aggro", int(trim(data[0])) );
            else if (line.equals("AI.attack"))
                aiInfo.put( "attack", int(trim(data[0])) );
            else if (line.equals("AI.close"))
                aiInfo.put( "close", int(trim(data[0])) );
        }
    }

    returnP.setAIInfo(aiInfo);

    return returnP;
}
