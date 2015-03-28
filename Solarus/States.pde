

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
    
    protected class options implements Command { public void execute(){options=true;} }
    protected class pause implements Command { public void execute(){pause=true;} }
    protected class unpause implements Command { public void execute(){pause=false;} }
}

public class MMState extends State
{
    // class Members
    boolean finalRun = true;
    UIGroup UIElements;
    
    PC camera;
    ArrayList<PC> targ;
    
    public MMState(StateManager sm)
    {
        super(sm);
        UIElements = new UIGroup(new PVector(width/2,height/2));
        
        camera = parsePC("data/test_triangle.player");
        targ = new ArrayList<PC>();
    }
    
    public void init()
    {
        class StartGame implements Command { public void execute(){sm.changeState("GAME_INSTANCE");} }
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
                new options() ));
        
        class ExitGame implements Command { public void execute(){finalRun=false;} }
        UIElements.add(new UIButton(
                new PVector(0, 225),
                new PVector(400,100),
                "Exit Game",
                new ExitGame() ));
        
        targ.add(parsePC("data/test_triangle.player"));
        targ.get(0).pos = new PVector(random(-1000,1000), random(-1000,1000));
        
        camera.setAITargets(targ);
    }
    
    public void render()
    {
        background(0);
        PVector controlCoords = new PVector(camera.pos.x, camera.pos.y);
        controlCoords.mult(-1);
        controlCoords.add(new PVector(width/2, height/2));
        
        star.render(controlCoords, camera.pos, 3);
        
        if (!options)
            UIElements.render(new PVector(0,0));
        else
            sm.optionsMenu.render(new PVector(0,0));
    }
    
    public boolean update()
    {
        if (!options)
            UIElements.update();
        else
            sm.optionsMenu.update();
        
        camera.update(30.f/frameRate);
        
        if (random(10) <= 1)
            targ.get(0).pos = new PVector(camera.pos.x + random(-1000,1000), 
                                          camera.pos.y + random(-1000,1000));
        
        return finalRun;
    }
}


