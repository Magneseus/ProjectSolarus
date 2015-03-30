

class StateManager
{
    public final String[] states = {"MAIN_MENU", "GAME_SELECT", "GAME_INSTANCE", "GAME_MARKET"};
    public String state = states[0];
    public State[] stateList;
    
    protected UIGroup optionsMenu;
    
    StateManager()
    {
        stateList = new State[4];
        stateList[0] = new MMState(this);
        stateList[0].init();
        
        //options = new UIGroup(new PVector(width/2, height/2), new PVector(0,0));
    }
    
    public boolean run()
    {
        boolean finalRun = true;   
        
        // Main Menu
        for (int i = 0; i < stateList.length; i++)
        {
            if (state.equals(states[i]))
            {
                finalRun = stateList[i].update();
                stateList[i].render();
            }
        }
        
        return finalRun;    
    }
}
