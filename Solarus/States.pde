

public abstract class State
{
    protected StateManager sm;
    
    public State(StateManager newSM)
    {
        sm = newSM;
    }
    
    public abstract void init();
    public abstract void render();
    public abstract boolean update();
}

public class MMState extends State
{
    // class Members
    boolean finalRun = true;
    UIGroup UIElements;
    
    public MMState(StateManager sm)
    {
        super(sm);
        UIElements = new UIGroup(new PVector(width/2,height/2));
    }
    
    public void init()
    {
        class StartGame implements Command { public void execute(){println("New Game Hit");} }
        UIElements.add(new UIButton(
                new PVector(0, -225),
                new PVector(400,100),
                "New Game",
                new StartGame() ));
        
        class LoadGame implements Command { public void execute(){println("Load Game Hit");} }
        UIElements.add(new UIButton(
                new PVector(0, -75),
                new PVector(400,100),
                "Load Game",
                new LoadGame() ));
        
        UIElements.add(new UIButton(
                new PVector(0, 75),
                new PVector(400,100),
                "Options",
                sm.getOptions() ));
        
        class ExitGame implements Command { public void execute(){finalRun=false;} }
        UIElements.add(new UIButton(
                new PVector(0, 225),
                new PVector(400,100),
                "Exit Game",
                new ExitGame() ));
    }
    
    public void render()
    {
        background(0);
        star.render(new PVector(0,0), new PVector(0,0), 6);
        
        UIElements.render(new PVector(0,0));
    }
    
    public boolean update()
    {
        UIElements.update();
        
        return finalRun;
    }
}


