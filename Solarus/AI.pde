
class AI
{
    private HashMap<String,Integer> states;
    private int STATE = 0;
    
    private ArrayList<PC> targets;
    
    AI(ArrayList<PC> targets_, HashMap<String,Integer> info)
    {
        states = new HashMap<String,Integer>();
        states.put("stop", 0);
        states.put("follow", 1);
        states.put("attack", 2);
        states.put("roam", 3);
        
        targets = targets_;
    }
    
    String update(Entity self)
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
