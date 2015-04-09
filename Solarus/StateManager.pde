

class StateManager
{
    public final String[] states = {"MAIN_MENU", "GAME_INSTANCE", "GAME_MARKET", "LOADING"};
    public String state = states[0];
    public State[] stateList;
    public State curState;
    public String prevState;
    
    protected UIGroup optionsMenu;
    
    StateManager()
    {
        stateList = new State[4];
        stateList[0] = new MMState(this);
        stateList[0].init();
        stateList[1] = new GIState(this);
        stateList[2] = new Market(this);
        
        optionsMenu = new UIGroup(new PVector(width/2, height/2), new PVector(0,0));
        
        class unoptions implements Command { public void execute(){options=false;} }
        optionsMenu.add(new UIButton(
                new PVector(0, -75),
                new PVector(400,100),
                "Return to Prev Menu",
                new unoptions() ));
        
        class temp implements Command { public void execute(){println("TBD");} }
        optionsMenu.add(new UIButton(
                new PVector(0, 75),
                new PVector(400,100),
                "Options to be added",
                new temp() ));
    }
    
    public boolean run()
    {
        boolean finalRun = true;   
        
        // Main Menu
        for (int i = 0; i < stateList.length; i++)
        {
            if (state.equals(states[i]))
            {
                //finalRun = stateList[i].update();
                stateList[i].render();
                finalRun = stateList[i].update();
            }
        }
        
        return finalRun;    
    }
    
    public void changeState(String newState)
    {
        int ind = -1;
        
        for (int i = 0; i < states.length; i++)
        {
            if (newState.equals(states[i]))
            {
                ind = i;
                break;
            }
        }
        
        prevState = state;
        state = states[ind];
        stateList[ind].init();
    }
    
    public void returnToPrev()
    {
        pause = false;
        options = false;
        state = prevState;
    }
}
