
class AI
{
    private HashMap<String,Integer> states;
    private int STATE = 0;
    
    private PVector pos, vel, accel;
    private float maxVel, maxAccel, maxRot;
    
    AI(String state, PVector pos, PVector vel, PVector accel)
    {
        states.put("stop", 0);
        states.put("follow", 1);
        states.put("", 2);
        states.put("stop", 3);
        
        maxVel = 1;
        maxAccel = 1;
        maxRot = 1;
    }
    
    String update(PVector pos, PVector vel)
    {
        return "s";
    }
}

public Object getS(Object val, Object def)
{
    if (val != null)
        return val;
    
    return def;
}

public <T extends Object> T getS(HashMap map, Object keyName, Object D, Class<T> type)
{
    if (map.get(keyName) != null)
        return type.cast(map.get(keyName));
    
    return type.cast(D);
}
