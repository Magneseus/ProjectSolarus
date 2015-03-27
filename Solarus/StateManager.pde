

class StateManager
{
    public final String[] states = {"MAIN_MENU", "GAME_SELECT", "GAME_INSTANCE", "GAME_MARKET"};
    public String state = states[0];
    public State[] stateList;
    
    StateManager()
    {
        stateList = new State[4];
        stateList[0] = new MMState(this);
        stateList[0].init();
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
    
    private class pause implements Command { public void execute(){pause=true;} }
    private class unpause implements Command { public void execute(){pause=false;} }
    
    public pause getPause() {return new pause();}
    public unpause getUnpause() {return new unpause();}
    
    private class options implements Command { public void execute(){options=true;} }
    private class unoptions implements Command { public void execute(){options=false;} }
    
    public options getOptions() {return new options();}
    public unoptions getUnoptions() {return new unoptions();}
}
