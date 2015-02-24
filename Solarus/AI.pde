
class AI
{
    private HashMap<String,Integer> states;
    private int STATE = 0;
    
    private ArrayList<PC> targets;
    
    private int aggro, attack, close;
    
    AI(ArrayList<PC> targets_)
    {
        states = new HashMap<String,Integer>();
        states.put("stop", 0);
        states.put("follow", 1);
        states.put("attack", 2);
        states.put("roam", 3);
        states.put("back", 4);
        states.put("flee", 5);
        
        targets = targets_;
        
        aggro = -1;
        attack = -1;
        close = -1;
    }
    
    void update(PC self)
    {
        PC closest = null;
        
        if (targets != null && targets.size() > 0)
        {
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
            
            STATE = states.get("stop");
            
            if (minDist < check(aggro, minDist))
                STATE = states.get("follow");
            if (minDist < check(attack, minDist))
                STATE = states.get("attack");
            if (minDist < check(close + 100, minDist))
                STATE = states.get("stop");
            if (minDist < check(close, minDist))
                STATE = states.get("back");
        }
        
        //Check states
        
        if (STATE == states.get("follow"))
        {
            
        }
        
        if (STATE == states.get("attack"))
        {
            
        }
        
        if (STATE == states.get("back"))
        {
            
        }
        
        if (STATE == states.get("stop"))
        {
            chase(self, closest);
            
            self.accel = new PVector(self.vel.x, self.vel.y);
            self.accel.mult(-self.slow);
            if (self.vel.mag() < 0.1)
                self.vel = new PVector(0,0);
        }
        
        attack(self, closest);
        chase(self, closest);
        
    }
    
    void attack(PC self, PC other)
    {
        if (self.projCount < self.projMax && 1 > random(300))
        {
            Proj ptmp = parseProj("test.bullet");
            ptmp.originator = self;
            ptmp.targetList = self.enemyList;

            ptmp.pos = new PVector(self.pos.x, self.pos.y);
            ptmp.vel = PVector.fromAngle(self.getAngle()-PI/2);
            ptmp.vel.setMag(ptmp.maxVel);
            
            if (PVector.angleBetween(ptmp.vel, self.vel) < PI/2)
                ptmp.vel.add(self.vel);

            PGraphics im = createGraphics(30, 30);
            im.beginDraw();
            im.fill(0, 0, 255);
            im.ellipse(15, 15, 15, 15);
            im.endDraw();

            ptmp.setImage(im);

            self.projList.add(ptmp);

            self.projCount++;
        }
    }
    
    void chase(PC self, PC other)
    {
        if (self != null && other != null)
        {
            PVector dis = PVector.sub(other.pos, self.pos);
            PVector ang = PVector.fromAngle(self.getAngle());
            ang.rotate(-PI/2);
            
            boolean tCW = false;
            boolean tCCW = false;
            
            if (PVector.angleBetween(dis, ang) > PI/self.getRotThresh())
            {
                float dot = (ang.x * -dis.y) + (ang.y * dis.x);
                
                if (dot >= 0)
                    tCW = true;
                else
                    tCCW = true;
            }
            
            if (tCW)
                self.rot(-self.maxRot / frameRate);
            else if (tCCW)
                self.rot(self.maxRot / frameRate);
            
            
            self.accel = PVector.fromAngle(self.getAngle());
            self.accel.rotate(-PI/2);
            self.accel.setMag(self.maxAccel);
            
            if (STATE == states.get("back"))
                self.accel.mult(-1);
        }
    }
    
    void setTargets(ArrayList<PC> targ)
    {
        targets = targ;
    }
    
    void setInfo(HashMap<String,Integer> info)
    {
        if (info.get("aggro") != null)
            aggro = info.get("aggro");
        if (info.get("attack") != null)
            attack = info.get("attack");
        if (info.get("close") != null)
            close = info.get("close");
         
    }
}

int check(int val, int def)
{
    if (val != -1)
        return val;
    
    return def;
}
