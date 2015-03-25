

class StateManager
{
    private final String[] states = {"MAIN_MENU", "GAME_SELECT", "GAME_INSTANCE", "GAME_MARKET"};
    private String state = states[0];
    
    StateManager()
    {
        
    }
    
    public boolean run()
    {
        boolean finalRun = false;
        UI_Group UIElements = new UI_Group(new PVector(0,0));
        
        // Main Menu
        if (state.equals(states[0]))
        {
            //Init state
            
            
            boolean running = true;
            while (running)
            {
                //Render
                
                // Update
                if (!pause)
                {
                    
                }
                else
                {
                    if (options)
                    {
                        
                    }
                    else
                    {
                        
                    }
                }
            }
        }
        // Select
        else if (state.equals(states[1]))
        {
            //Init state
            
            boolean running = true;
            while (running)
            {
                //Render
                
                // Update
                if (!pause)
                {
                    
                }
                else
                {
                    if (options)
                    {
                        
                    }
                    else
                    {
                        
                    }
                }
            }
        }
        // Instance
        else if (state.equals(states[2]))
        {
            //Init state
            
            boolean running = true;
            while (running)
            {
                //Render
                
                // Update
                if (!pause)
                {
                    
                }
                else
                {
                    if (options)
                    {
                        
                    }
                    else
                    {
                        
                    }
                }
            }
        }
        // Market
        else if (state.equals(states[3]))
        {
            //Init state
            
            boolean running = true;
            while (running)
            {
                //Render
                
                // Update
                if (!pause)
                {
                    
                }
                else
                {
                    if (options)
                    {
                        
                    }
                    else
                    {
                        
                    }
                }
            }
        }
        
        return finalRun;    
    }
    
    private class pause extends Command { public void execute(){pause=true;} }
    private class unpause extends Command { public void execute(){pause=false;} }
    
    private class options extends Command { public void execute(){options=true;} }
    private class unoptions extends Command { public void execute(){options=false;} }
}
