class AI
{
    // Members
    private HashMap<String,Integer> states, info;
    private int STATE = 0;
    
    private ArrayList<PC> targets, friendly;
    
    /**
     * Creates a new AI with the given PC lists.
     * 
     * @param targets_ The list of enemy targets.
     * @param friendly_ The list of friendlies to avoid colliding with.
    */
    AI(ArrayList<PC> targets_, ArrayList<PC> friendly_)
    {
        // Puts all the possible states into a HashMap
        states = new HashMap<String,Integer>();
        states.put("stop", 0);
        states.put("aggro", 1);
        states.put("attack", 1);
        states.put("",2);
        
        targets = targets_;
        friendly = friendly_;
        
        info = new HashMap<String,Integer>();
    }
    
    /**
     * Updates the velocities and states of the AI as well as the given PC.
     * @param self Reference to the parent PC class that owns the AI.
     */
    void update(PC self)
    {
        PC closest = null;
        
        // Default state is to stop
        STATE = states.get("stop");
        
        // If there are targets available
        if (targets != null && targets.size() > 0)
        {
            // Loop through all enemies and find the closest target
            // This target will be receiving the aggro of this AI.
            int minDist = (int)self.distance(targets.get(0));
            closest = targets.get(0);
            
            for (PC e : targets)
            {
                float dist = self.distance(e);
                if (dist < minDist)
                {
                    minDist = (int)dist;
                    closest = e;
                }
            }
        }
        
        //TODO: fix all of this behaviour
        attack(self, closest);
        chase(self, closest);
        
        if (STATE == states.get("stop"))
        {
            chase(self, closest);
            
            self.accel = new PVector(self.vel.x, self.vel.y);
            self.accel.mult(-self.slow);
            if (self.vel.mag() < 0.1)
                self.vel = new PVector(0,0);
        }
        
        
        // Checks for all friendly units, and pushes away from them if
        // they are too close.
        if (friendly != null)
        {
            for (PC f : friendly)
            {
                //Push apart
                float d = dist(f.pos.x, f.pos.y, self.pos.x, self.pos.y);
                if (d < 50)
                {
                    PVector vel1 = PVector.sub(self.pos, f.pos);
                    vel1.setMag(map(d, 0, 50, 0.1, 0.0001));
                    self.vel.add(vel1);
                    
                    vel1.mult(-1);
                    f.vel.add(vel1);
                }
            }
        }
    }
    
    /**
     * Random chance to fire at an enemy unit
     * 
     * @param self Reference to the parent PC
     * @param other Reference to the targeted PC.
     */
    void attack(PC self, PC other)
    {
        // Checks for the max projectile count and random chance of 0.05%
        if (other != null && self.projCount < self.projMax && 1 > random(200))
        {
            // Create a projectile and add our velocity to it
            Proj ptmp = parseProj("test.bullet");
            ptmp.originator = self;
            ptmp.targetList = self.enemyList;

            ptmp.pos = new PVector(self.pos.x, self.pos.y);
            ptmp.vel = PVector.fromAngle(self.getAngle()-PI/2);
            ptmp.vel.setMag(ptmp.maxVel);
            
            if (PVector.angleBetween(ptmp.vel, self.vel) < PI/2)
                ptmp.vel.add(self.vel);
            
            // Draw the bullet
            PGraphics im = createGraphics(30, 30);
            im.beginDraw();
            im.fill(0, 0, 255);
            im.ellipse(15, 15, 15, 15);
            im.endDraw();

            ptmp.setImage(im);
            
            // Add the bullet to the PCs list, increase the count
            self.projList.add(ptmp);

            self.projCount++;
        }
    }
    
    /**
     * Chases the given target directly.
     * 
     * @param self Reference to the parent PC.
     * @param other Reference to the targeted PC.
     */
    void chase(PC self, PC other)
    {
        // Check for nullity
        if (self != null && other != null)
        {
            // Finds the vectors representing the distance from self to other
            // and the one representing the self PCs current bearing.
            PVector dis = PVector.sub(other.pos, self.pos);
            PVector ang = PVector.fromAngle(self.getAngle());
            ang.rotate(-PI/2);
            
            boolean tCW = false;
            boolean tCCW = false;
            
            // Check for which direction to turn
            if (PVector.angleBetween(dis, ang) > PI/self.getRotThresh())
            {
                float dot = (ang.x * -dis.y) + (ang.y * dis.x);
                
                if (dot >= 0)
                    tCW = true;
                else
                    tCCW = true;
            }
            
            // Start turning in that direction
            if (tCW)
                self.rot(-self.maxRot / frameRate);
            else if (tCCW)
                self.rot(self.maxRot / frameRate);
            
            // Accelerate towards the target
            self.accel = PVector.fromAngle(self.getAngle());
            self.accel.rotate(-PI/2);
            self.accel.setMag(self.maxAccel);
            
            // If we want to retreat, accelerate backwards
            if (STATE == states.get("back"))
                self.accel.mult(-1);
        }
    }
    
    // GETTERS AND SETTERS
    
    void setTargets(ArrayList<PC> targ)
    {
        targets = targ;
    }
    
    void setFriend(ArrayList<PC> friend)
    {
        friendly = friend;
    }
    
    void setInfo(HashMap<String,Integer> info)
    {
        this.info = info;
    }
}

/*
 * Interface for all AIStates to implement.
 */
interface AIState
{
    public boolean isSuppressed();
    public void suppress();
    public boolean takeControl(PC self, PC other);
    public void takeAction(PC self, PC other);
}

// STATES //

class AIStop implements AIState
{
    private boolean suppress;
    AIStop()
    {
        suppress = false;
    }
    
    public boolean takeControl(PC self, PC other)
    {
        return true;
    }
    
    public void takeAction(PC self, PC other)
    {
        self.accel = new PVector(self.vel.x, self.vel.y);
        self.accel.mult(-self.slow);
        if (self.vel.mag() < 0.1)
            self.vel = new PVector(0,0);
    }
    
    public void suppress() {suppress=true;}
    public boolean isSuppressed() {return suppress;}
}

class AIAggro implements AIState
{
    private boolean suppress;
    private float aggroDist, prefDist, closeDist;
    AIAggro(float aggroDist, float closeDist)
    {
        suppress = false;
        this.aggroDist = aggroDist;
        this.closeDist = closeDist;
        this.prefDist = closeDist + 100;
    }
    
    public boolean takeControl(PC self, PC other)
    {
        float d = dist(self.pos.x, self.pos.y, other.pos.x, other.pos.y);
        return (d < aggroDist && d > prefDist) || (d < closeDist);
    }
    
    public void takeAction(PC self, PC other)
    {
        // Check for nullity
        if (self != null && other != null)
        {
            // Finds the vectors representing the distance from self to other
            // and the one representing the self PCs current bearing.
            PVector dis = PVector.sub(other.pos, self.pos);
            PVector ang = PVector.fromAngle(self.getAngle());
            ang.rotate(-PI/2);
            
            boolean tCW = false;
            boolean tCCW = false;
            
            // Check for which direction to turn
            if (PVector.angleBetween(dis, ang) > PI/self.getRotThresh())
            {
                float dot = (ang.x * -dis.y) + (ang.y * dis.x);
                
                if (dot >= 0)
                    tCW = true;
                else
                    tCCW = true;
            }
            
            // Start turning in that direction
            if (tCW)
                self.rot(-self.maxRot / frameRate);
            else if (tCCW)
                self.rot(self.maxRot / frameRate);
            
            // Accelerate towards the target
            self.accel = PVector.fromAngle(self.getAngle());
            self.accel.rotate(-PI/2);
            self.accel.setMag(self.maxAccel);
            
            // If we want to retreat, accelerate backwards
            if (STATE == states.get("back"))
                self.accel.mult(-1);
        }
    }
    
    public void suppress() {suppress=true;}
    public boolean isSuppressed() {return suppress;}
}



/**
 * @param val The value to check.
 * @param def The default value to return.
 * @return If the value is not -1, return val, otherwise return def.
 */
int check(int val, int def)
{
    if (val != -1)
        return val;
    
    return def;
}