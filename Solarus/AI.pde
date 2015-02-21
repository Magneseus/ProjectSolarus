
class AI
{
    private HashMap<String,Integer> states;
    private int STATE = 0;
    
    AI(String state)
    {
        states.put("stop", 0);
        states.put("follow", 1);
        states.put("", 2);
        states.put("stop", 3);
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
