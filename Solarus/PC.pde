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
    private IntBox health, shield, healthMax, shieldMax;
    private int shieldTimer = 0, shieldCool;
    private float shieldAccel, shieldVel, shieldMaxVel;
    private int projCount, projMax;
    private boolean inControl;
    private float percentF, percentB, percentS, slow, rotThresh;
    
    private String loadName;
    private int imageInd;

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
        shield = new IntBox(0);
        healthMax = new IntBox(0);
        shieldMax = new IntBox(0);
        
        shieldTimer = millis();
        shieldCool = 0;
        shieldAccel = 0;
        shieldVel = 0;
        shieldMaxVel = 0;
        
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
        
        //If we're dead, tell 'em
        if (health.store <= 0)
            return false;
        
        // If the shield cooldown is over, recharge shields
        if (millis() - shieldTimer > shieldCool)
        {
            shieldVel += shieldAccel * delta;
            shieldVel = shieldVel > shieldMaxVel ? shieldMaxVel : shieldVel;
            
            shield.store += shieldVel;
            shield.store = shield.store > shieldMax.store ? shieldMax.store : shield.store;
        }
        else
        {
            shieldVel = 0;
        }

        return true;
    }
    
    public boolean update(float delta, PC con)
    {
        if (!inControl)
            alf.update(con);
        
        return update(delta);
    }
    
    /**
     * Called when a projectile destroys itself, decrement the count
     */
    void removeProj()
    {
        projCount--;
    }
    
    // Called when a projectile hits
    void damage(int damage)
    {
        // Damage the shields first
        shield.store -= damage * 100;
        // Start the shield recover cooldown
        shieldTimer = millis();
        
        // If damage has extended past the shields
        if (shield.store < 0)
        {
            int damPen = (int)((float)shield.store / 100.f);
            shield.store = 0;
            
            health.store += damPen;
        }
    }
    
    // GETTERS AND SETTERS
    void setControl(boolean c)
    {
        inControl = c;
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

    public void setHealth(int h){ health = new IntBox(h); }
    public IntBox getHealth(){ return health; }
    public void setHealthMax(int h){ healthMax = new IntBox(h); }
    public IntBox getHealthMax(){ return healthMax; }
    
    public IntBox getShield(){ return shield; }
    public void setShield(IntBox shield){ this.shield = shield; }
    public IntBox getShieldMax(){ return shieldMax; }
    public void setShieldMax(IntBox shieldMax){ this.shieldMax = shieldMax; }
    
    public int getShieldCool(){ return shieldCool; }
    public void setShieldCool(int shieldCool){ this.shieldCool = shieldCool; }
    
    public float getShieldAccel(){ return shieldAccel; }
    public void setShieldAccel(float shieldAccel){ this.shieldAccel = shieldAccel; }
    
    public float getShieldMaxVel(){ return shieldMaxVel; }
    public void setShieldMaxVel(float shieldMaxVel){ this.shieldMaxVel = shieldMaxVel; }
    
    public void setLoadName(String loadName){ this.loadName = loadName; }
    public String getLoadName(){ return loadName; }
    public PVector getPos(){ return pos; }
    
    public int getImageInd(){ return imageInd; }
    public void setImageInd(int imageInd){ this.imageInd = imageInd; }
    
    void setProjMax(int h)
    {
        projMax = h;
    }
    
    int getProjMax() { return projMax; }

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

ArrayList<PC> loadFriendly(String fileName)
{
    ArrayList<PC> friend = new ArrayList<PC>();
    
    String[] lines = loadStrings(fileName);
    int ind = 0;
    
    while (lines[ind].charAt(0) != '#')
    {
        String[] data = split(lines[ind], ' ');
        
        PC p = parsePC(data[0]);
        
//        PGraphics im = createGraphics(40,40);
//        im.beginDraw();
//        im.stroke(0,255,0);
//        im.fill(0,255,0);
//        im.triangle(0, 40, 20, 0, 40, 40);
//        im.endDraw();
//        p.setImage(im);
        p.setImage(playerImages[int(data[8])]);
        p.setImageInd(int(data[8]));
        p.setLoadName(data[0]);
        
        p.moveTo( new PVector(float(data[1]), float(data[2])) );
        
        p.setHealth( int(data[3]) );
        p.setHealthMax( int(data[4]) );
        p.setShield( new IntBox(int(data[5])) );
        p.setShieldMax( new IntBox(int(data[6])) );
        
        p.setProjMax( int(data[7]) );
        
        boolean inCon = int(data[9]) == 1 ? true : false;
        p.setControl(inCon);
        
        friend.add(p);
        ind++;
    }
    
    return friend;
}

ArrayList<PC> loadEnemy(String fileName)
{
    ArrayList<PC> enemy = new ArrayList<PC>();
    
    String[] lines = loadStrings(fileName);
    int ind = 0;
    
    while (lines[ind].charAt(0) != '#')
    {
        ind++;
    }
    
    ind++;
    
    for (int i = ind; i < lines.length; i++)
    {
        String[] data = split(lines[i], ' ');
        
        if (data.length < 5)
            break;
        
        PC p = parsePC(data[0]);
        
//        PGraphics im = createGraphics(40,40);
//        im.beginDraw();
//        im.stroke(255,0,0);
//        im.fill(255,0,0);
//        im.triangle(0, 40, 20, 0, 40, 40);
//        im.endDraw();
//        p.setImage(im);
        p.setImage(playerImages[int(data[8])]);
        p.setImageInd(int(data[8]));
        p.setLoadName(data[0]);
        
        p.moveTo( new PVector(float(data[1]), float(data[2])) );
        
        p.setHealth( int(data[3]) );
        p.setHealthMax( int(data[4]) );
        p.setShield( new IntBox(int(data[5])) );
        p.setShieldMax( new IntBox(int(data[6])) );
        
        p.setProjMax( int(data[7]) );
        
        boolean inCon = int(data[9]) == 1 ? true : false;
        p.setControl(inCon);
        p.enemy = true;
        
        enemy.add(p);
    }
    
    return enemy;
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
    
    returnP.setLoadName(fileName);
    
    AIStop ai1 = new AIStop();
    AIWander ai2 = new AIWander();
    
    AIAggro ai3;
    float agDist = 0, agPref = 0, agClose = 0;
    
    AIAttack ai4;
    int chance = 0;
    
    AIFollow ai5;
    float foDist = 0, foClose = 0;

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
            else if (line.equals("healthMax"))
                returnP.setHealthMax( int(trim(data[0])) );
            else if (line.equals("shield"))
                returnP.setShield( new IntBox(int(trim(data[0]))) );
            else if (line.equals("shieldMax"))
                returnP.setShieldMax( new IntBox(int(trim(data[0]))) );
            else if (line.equals("shieldCool"))
                returnP.setShieldCool( int(trim(data[0])) );
            else if (line.equals("shieldAccel"))
                returnP.setShieldAccel( float(trim(data[0])) );
            else if (line.equals("shieldMaxVel"))
                returnP.setShieldMaxVel( float(trim(data[0])) );
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
            else if (line.equals("AI.aggroDist"))
                agDist = float(trim(data[0]));
            else if (line.equals("AI.aggroPref"))
                agPref = float(trim(data[0]));
            else if (line.equals("AI.aggroClose"))
                agClose = float(trim(data[0]));
            else if (line.equals("AI.followDist"))
                foDist = float(trim(data[0]));
            else if (line.equals("AI.followClose"))
                foClose = float(trim(data[0]));
            else if (line.equals("AI.attackChance"))
                chance = int(trim(data[0]));
        }
    }

    ai3 = new AIAggro(agDist, agClose, agPref);
    ai4 = new AIAttack(chance);
    ai5 = new AIFollow(foDist, foClose);
    
    ArrayList<AIState> st = new ArrayList<AIState>();
    st.add(ai1);
    st.add(ai2);
    st.add(ai3);
    st.add(ai4);
    st.add(ai5);
    
    returnP.setAI(new AI(returnP, st));

    return returnP;
}
