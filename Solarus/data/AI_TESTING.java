class AI
{
    // Vars
    private PC self;
    private ArrayList<AIState> states;

    public AI(PC self,
                float aggro,
                float aggroClose,
                float aggroPref,
                )
    {
        
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

    private attack(PC self)
    {
        if (self.projCount < self.projMax && 1 > random(200))
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
            if (self.enemy)
                im.image(enemyP1, 0,0, 30,30);
            else
                im.image(friendP2, 0,0, 30,30);
            im.endDraw();

            ptmp.setImage(im);
            
            // Add the bullet to the PCs list, increase the count
            self.projList.add(ptmp);

            self.projCount++;
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