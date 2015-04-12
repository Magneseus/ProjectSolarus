class AI
{
    // Vars
    private PC self;
    private ArrayList<AIState> states;

    public AI(PC self, ArrayList<AIState> states)
    {
        this.self = self;
        this.states = states;
    }
    
    public void update(PC control)
    {
        PC closest = null;
        
        // If the list isn't empty, find the closest enemy
        if (self.enemyList.size() > 0)
        {
            closest = self.enemyList.get(0);
            float d = dist(closest.pos.x, closest.pos.y, self.pos.x, self.pos.y);
            
            for (PC e : self.enemyList)
            {
                if (dist(e.pos.x, e.pos.y, self.pos.x, self.pos.y) < d)
                {
                    closest = e;
                    d = dist(e.pos.x, e.pos.y, self.pos.x, self.pos.y);
                }
            }
        }
        
        int indSelect = -1;
        
        // Find the highest priority active state
        for (int i = 0; i < states.size(); i++)
        {
            if (states.get(i).takeControl(self, closest, control))
                indSelect = i;
        }
        
        // Suppress all states
        for (AIState a : states)
            a.suppress();
        
        // Start the new state
        states.get(indSelect).takeAction(self, closest, control);
    }
}

/*
 * Interface for all AIStates to implement.
 */
interface AIState
{
    public boolean isSuppressed();
    public void suppress();
    public boolean takeControl(PC self, PC other, PC control);
    public void takeAction(PC self, PC other, PC control);
}

// STATES //

// STOP
class AIStop implements AIState
{
    private boolean suppress;
    
    public AIStop()
    {
        suppress = false;
    }
    
    public boolean takeControl(PC self, PC other, PC control)
    {
        return true;
    }
    
    public void takeAction(PC self, PC other, PC control)
    {
        suppress = false;
        
        self.accel = new PVector(self.vel.x, self.vel.y);
        self.accel.mult(-self.slow);
        if (self.vel.mag() < 0.1)
            self.vel = new PVector(0,0);
    }
    
    public void suppress() {suppress=true;}
    public boolean isSuppressed() {return suppress;}
}

// WANDER
class AIWander implements AIState
{
    private boolean suppress;
    private PVector target;
    private int start = millis() - 500, wait = 500;
    
    public AIWander()
    {
        suppress = false;
    }
    
    public boolean takeControl(PC self, PC other, PC control)
    {
        // IF the target and the follow is null, don't wander
        if (other == null && control == null)
            return false;
        
        // If the cooldown isn't done yet
        if (millis() - start < wait)
            return false;
        
        return true;
    }
    
    public void takeAction(PC self, PC other, PC control)
    {
        suppress = true;
        
        float d1 = Integer.MAX_VALUE;
        float d2 = Integer.MAX_VALUE;
        
        if (other != null)
            d1 = dist(self.pos.x, self.pos.y, other.pos.x, other.pos.y);
        
        if (control != null)
            d2 = dist(self.pos.x, self.pos.y, control.pos.x, control.pos.y);
        
        // IF enemy
        if (d1 < d2)
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
            
            PVector variance = PVector.fromAngle(self.getAngle());
            variance.rotate(PI/2);
            variance.setMag(random(-self.maxAccel, self.maxAccel));
            
            self.accel = variance;
        }
        // If friend
        else
        {
            // Generates a new target if one doesn't exist, or if it's too far 
            // from the following target
            if (target == null || 
                dist(target.x, target.y, control.pos.x, control.pos.y) > 400)
            {
                target = new PVector(control.pos.x + random(-350,350),
                                     control.pos.y + random(-350,350));
            }
            
            // Finds the vectors representing the distance from self to control
            // and the one representing the self PCs current bearing.
            PVector dis = PVector.sub(target, self.pos);
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
                self.rot(-self.maxRot / frameRate / 2);
            else if (tCCW)
                self.rot(self.maxRot / frameRate / 2);
            
            // Accelerate towards the target
            self.accel = new PVector(0,0);
            self.vel = PVector.fromAngle(self.getAngle());
            self.vel.rotate(-PI/2);
            self.vel.setMag(self.maxVel);
            
            // If we're close enough to the target, start the cooldown
            if (dis.mag() < 50)
            {
                start = millis();
                wait = (int) random(1000, 4000);
                
                target = new PVector(control.pos.x + random(-350,350),
                                     control.pos.y + random(-350,350));
            }
        }
    }
    
    public void suppress() {suppress=true;}
    public boolean isSuppressed() {return suppress;}
}

// AGGRO
class AIAggro implements AIState
{
    private boolean suppress;
    private float aggroDist, prefDist, closeDist;
    
    AIAggro(float aggroDist, float closeDist, float prefDist)
    {
        suppress = false;
        this.aggroDist = aggroDist;
        this.closeDist = closeDist;
        this.prefDist = prefDist;
    }
    
    public boolean takeControl(PC self, PC other, PC control)
    {
        if (other == null)
            return false;
        
        float d = dist(self.pos.x, self.pos.y, other.pos.x, other.pos.y);
        return (d < aggroDist && d > prefDist) || (d < closeDist);
    }
    
    public void takeAction(PC self, PC other, PC control)
    {
        suppress = false;
        
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
            if (dis.mag() < closeDist)
                self.accel.mult(-1);
        }
    }
        
    public void suppress() {suppress=true;}
    public boolean isSuppressed() {return suppress;}
}

// ATTACK
class AIAttack implements AIState
{
    private boolean suppress;
    private int chance;
    
    public AIAttack(int chance)
    {
        suppress = false;
        this.chance = chance;
    }
    
    public boolean takeControl(PC self, PC other, PC control)
    {
        if (other == null)
            return false;
        // Calculate the angle between the AI and the target
        PVector dis = PVector.sub(other.pos, self.pos);
        PVector ang = PVector.fromAngle(self.getAngle());
        ang.rotate(-PI/2);
        
        float angle = PVector.angleBetween(dis, ang);
        
        return angle < PI/4 && self.projCount < self.projMax && 1 > random(chance);
    }
    
    public void takeAction(PC self, PC other, PC control)
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
        
        suppress = true;
    }
    
    public void suppress() {suppress=true;}
    public boolean isSuppressed() {return suppress;}
}

// FOLLOW
class AIFollow implements AIState
{
    private boolean suppress;
    private float followDist, closeDist;
    
    AIFollow(float followDist, float closeDist)
    {
        suppress = false;
        this.followDist = followDist;
        this.closeDist = closeDist;
    }
    
    public boolean takeControl(PC self, PC other, PC control)
    {
        if (control == null)
            return false;
        
        float d = dist(self.pos.x, self.pos.y, control.pos.x, control.pos.y);
        return d > followDist || d < closeDist;
    }
    
    public void takeAction(PC self, PC other, PC control)
    {
        suppress = false;
        
        // Check for nullity
        if (self != null && control != null)
        {
            // Finds the vectors representing the distance from self to control
            // and the one representing the self PCs current bearing.
            PVector dis = PVector.sub(control.pos, self.pos);
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
            if (dis.mag() < closeDist)
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

//class AI
//{
//    // Members
//    private HashMap<String,Integer> states, info;
//    private int STATE = 0;
//    
//    private ArrayList<PC> targets, friendly;
//    
//    private int aggro, attack, close;
//    
//    /**
//     * Creates a new AI with the given PC lists.
//     * 
//     * @param targets_ The list of enemy targets.
//     * @param friendly_ The list of friendlies to avoid colliding with.
//    */
//    AI(ArrayList<PC> targets_, ArrayList<PC> friendly_)
//    {
//        // Puts all the possible states into a HashMap
//        states = new HashMap<String,Integer>();
//        states.put("stop", 0);
//        states.put("follow", 1);
//        states.put("attack", 2);
//        states.put("roam", 3);
//        states.put("back", 4);
//        states.put("flee", 5);
//        
//        targets = targets_;
//        friendly = friendly_;
//        
//        info = new HashMap<String,Integer>();
//    }
//    
//    /**
//     * Updates the velocities and states of the AI as well as the given PC.
//     * @param self Reference to the parent PC class that owns the AI.
//     */
//    // Test commit
//    // This is a test change
//    void update(PC self)
//    {
//        PC closest = null;
//        
//        // Default state is to stop
//        STATE = states.get("stop");
//        
//        // If there are targets available
//        if (targets != null && targets.size() > 0)
//        {
//            // Loop through all enemies and find the closest target
//            // This target will be receiving the aggro of this AI.
//            int minDist = (int)self.distance(targets.get(0));
//            closest = targets.get(0);
//            
//            for (PC e : targets)
//            {
//                float dist = self.distance(e);
//                if (dist < minDist)
//                {
//                    minDist = (int)dist;
//                    closest = e;
//                }
//            }
//            
//            // Checks for the various states, overriding the previous
//            if (minDist < check(aggro, minDist))
//                STATE = states.get("follow");
//            if (minDist < check(attack, minDist))
//                STATE = states.get("attack");
//            if (minDist < check(close + 100, minDist))
//                STATE = states.get("stop");
//            if (minDist < check(close, minDist))
//                STATE = states.get("back");
//        }
//        
//        //Check states
//        // TODO: Add more state-dependent behaviours
//        if (STATE == states.get("follow"))
//        {
//            
//        }
//        
//        if (STATE == states.get("attack"))
//        {
//            
//        }
//        
//        if (STATE == states.get("back"))
//        {
//            
//        }
//        
//        //TODO: fix all of this behaviour
//        attack(self, closest);
//        chase(self, closest);
//        
//        if (STATE == states.get("stop"))
//        {
//            chase(self, closest);
//            
//            self.accel = new PVector(self.vel.x, self.vel.y);
//            self.accel.mult(-self.slow);
//            if (self.vel.mag() < 0.1)
//                self.vel = new PVector(0,0);
//        }
//        
//        
//        // Checks for all friendly units, and pushes away from them if
//        // they are too close.
//        if (friendly != null)
//        {
//            for (PC f : friendly)
//            {
//                //Push apart
//                float d = dist(f.pos.x, f.pos.y, self.pos.x, self.pos.y);
//                if (d < 50)
//                {
//                    PVector vel1 = PVector.sub(self.pos, f.pos);
//                    vel1.setMag(map(d, 0, 50, 0.1, 0.0001));
//                    self.vel.add(vel1);
//                    
//                    vel1.mult(-1);
//                    f.vel.add(vel1);
//                }
//            }
//        }
//    }
//    
//    /**
//     * Random chance to fire at an enemy unit
//     * 
//     * @param self Reference to the parent PC
//     * @param other Reference to the targeted PC.
//     */
//    void attack(PC self, PC other)
//    {
//        // Checks for the max projectile count and random chance of 0.05%
//        if (other != null && self.projCount < self.projMax && 1 > random(200))
//        {
//            // Create a projectile and add our velocity to it
//            Proj ptmp = parseProj("test.bullet");
//            ptmp.originator = self;
//            ptmp.targetList = self.enemyList;
//
//            ptmp.pos = new PVector(self.pos.x, self.pos.y);
//            ptmp.vel = PVector.fromAngle(self.getAngle()-PI/2);
//            ptmp.vel.setMag(ptmp.maxVel);
//            
//            if (PVector.angleBetween(ptmp.vel, self.vel) < PI/2)
//                ptmp.vel.add(self.vel);
//            
//            // Draw the bullet
//            PGraphics im = createGraphics(30, 30);
//            im.beginDraw();
//            if (self.enemy)
//                im.image(enemyP1, 0,0, 30,30);
//            else
//                im.image(friendP2, 0,0, 30,30);
//            im.endDraw();
//
//            ptmp.setImage(im);
//            
//            // Add the bullet to the PCs list, increase the count
//            self.projList.add(ptmp);
//
//            self.projCount++;
//        }
//    }
//    
//    /**
//     * Chases the given target directly.
//     * 
//     * @param self Reference to the parent PC.
//     * @param other Reference to the targeted PC.
//     */
//    void chase(PC self, PC other)
//    {
//        // Check for nullity
//        if (self != null && other != null)
//        {
//            // Finds the vectors representing the distance from self to other
//            // and the one representing the self PCs current bearing.
//            PVector dis = PVector.sub(other.pos, self.pos);
//            PVector ang = PVector.fromAngle(self.getAngle());
//            ang.rotate(-PI/2);
//            
//            boolean tCW = false;
//            boolean tCCW = false;
//            
//            // Check for which direction to turn
//            if (PVector.angleBetween(dis, ang) > PI/self.getRotThresh())
//            {
//                float dot = (ang.x * -dis.y) + (ang.y * dis.x);
//                
//                if (dot >= 0)
//                    tCW = true;
//                else
//                    tCCW = true;
//            }
//            
//            // Start turning in that direction
//            if (tCW)
//                self.rot(-self.maxRot / frameRate);
//            else if (tCCW)
//                self.rot(self.maxRot / frameRate);
//            
//            // Accelerate towards the target
//            self.accel = PVector.fromAngle(self.getAngle());
//            self.accel.rotate(-PI/2);
//            self.accel.setMag(self.maxAccel);
//            
//            // If we want to retreat, accelerate backwards
//            if (STATE == states.get("back"))
//                self.accel.mult(-1);
//        }
//    }
//    
//    // GETTERS AND SETTERS
//    
//    void setTargets(ArrayList<PC> targ)
//    {
//        targets = targ;
//    }
//    
//    void setFriend(ArrayList<PC> friend)
//    {
//        friendly = friend;
//    }
//    
//    void setInfo(HashMap<String,Integer> info)
//    {
//        if (info.get("aggro") != null)
//            aggro = info.get("aggro");
//        if (info.get("attack") != null)
//            attack = info.get("attack");
//        if (info.get("close") != null)
//            close = info.get("close");
//         
//    }
//}
//
///**
// * @param val The value to check.
// * @param def The default value to return.
// * @return If the value is not -1, return val, otherwise return def.
// */
//int check(int val, int def)
//{
//    if (val != -1)
//        return val;
//    
//    return def;
//}

