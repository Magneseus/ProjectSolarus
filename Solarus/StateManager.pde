

class StateManager
{
    public final String[] states = {"MAIN_MENU", "GAME_INSTANCE", "GAME_MARKET", "LOADING"};
    public String state = states[0];
    public State[] stateList;
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
    
    public void loadGame()
    {
        pause = false;
        options = false;
        
        selectFolder("Select a save folder to load: ", "loadFolderSelect", dataFile("\\saves"));
        int wait = 10000, start = millis();
        while (saveFile == null)
        {
            if (millis() - start > wait)
            {
                println("You're taking a while there.");
                start = millis();
            }
        }
        if (saveFile.equals(""))
        {
            saveFile = null;
            toast.pushToast("Load canceled.", 2000);
        }
        else
        {
            String[] folder = split(saveFile, '\\');
            String saveName = folder[folder.length-1];
            if (loadStrings(saveFile + "\\" + saveName + ".save") != null)
            {
                Outpost newOutpost = loadOutpostGraph(saveFile + "\\outpost.tgf");
                
                ArrayList<PC> f = loadFriendly(saveFile + "\\entities.save");
                ArrayList<PC> e = loadEnemy(saveFile + "\\entities.save");
                
                prevState = state;
                state = states[1];
                ((GIState)stateList[1]).init(newOutpost, f, e);
                
                toast.pushToast("Loaded.", 2000);
            }
            else
                toast.pushToast("Load failed.", 2000);
            
            saveFile = null;
        }
    }
    
    public void returnToPrev()
    {
        pause = false;
        options = false;
        state = prevState;
    }
}

public void loadFolderSelect(File selection)
{
    if (selection == null)
    {
        toast.pushToast("No folder selected.", 2000);
        saveFile = "";
    }
    else
    {
        saveFile = selection.getAbsolutePath();
    }
}

public void saveFolderSelect(File selection)
{
    if (selection == null)
    {
        toast.pushToast("No folder selected.", 2000);
        saveFile = "";
    }
    else
    {
        saveFile = selection.getAbsolutePath();
        String[] folder = split(saveFile, '\\');
        String[] list = {folder[folder.length-1]};
        saveStrings(saveFile + "\\" + list[0] + ".save", list);
    }
}
