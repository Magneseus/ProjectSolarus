
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
        states.put("flee", 4);
        
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
            closest = null;
            int minDist = (int)self.distance(targets.get(0));
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
            if (minDist < check(close, minDist))
                STATE = states.get("flee");
        }
        
        //Check states
        
        if (STATE == states.get("follow"))
            chase(self, closest, false);
        
        if (STATE == states.get("attack"))
            println("attack");
        
        if (STATE == states.get("flee"))
            chase(self, closest, true);
        
    }
    
    void chase(PC self, PC other, boolean flee)
    {
        
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
