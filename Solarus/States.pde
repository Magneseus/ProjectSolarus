

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


// GAME INSTANCE STATE
public class GIState extends State
{
    // class members
    UIGroup HUD, GIMenu;
    
    ArrayList<PC> players;
    ArrayList<Proj> playerProj;
    ArrayList<PC> enemies;
    ArrayList<Proj> enemyProj;
    PC control;
    int playerInd;
    
    public GIState(StateManager sm)
    {
        super(sm);
    }
    
    public void init()
    {
        pause = false;
        options = false;
        
        HUD = new UIGroup(new PVector(0,0));
        GIMenu = new UIGroup(new PVector(width/2, height/2));
        
        players = new ArrayList<PC>();
        playerProj = new ArrayList<Proj>();
        enemies = new ArrayList<PC>();
        enemyProj = new ArrayList<Proj>();
        
        players.clear();
        playerProj.clear();
        enemies.clear();
        enemyProj.clear();
        
        //Load a temp player
        PC p;
        p = parsePC("enemy_basic.player");
        PGraphics im = createGraphics(40,40);
        im.beginDraw();
        im.stroke(0,255,0);
        im.fill(0,255,0);
        im.triangle(0, 40, 20, 0, 40, 40);
        im.endDraw();
        p.setImage(im);
        p.moveTo(new PVector(width/2, height/2));
        p.setControl(true);
        control = p;
        p.projList = playerProj;
        players.add(p);
        playerInd = 0;
        
        
        
        GIMenu.add(new UIButton(
                new PVector(0, -225),
                new PVector(400,100),
                "Resume Game",
                new unpause() ));
        
        class tempSave implements Command { public void execute(){println("Saved Game.");} }
        GIMenu.add(new UIButton(
                new PVector(0, -75),
                new PVector(400,100),
                "Save Game",
                new tempSave() ));
        
        GIMenu.add(new UIButton(
                new PVector(0, 75),
                new PVector(400,100),
                "Options",
                new options() ));
        
        class ReturnToMenu implements Command { public void execute(){sm.changeState("MAIN_MENU");} }
        GIMenu.add(new UIButton(
                new PVector(0, 225),
                new PVector(400,100),
                "Return to Main Menu",
                new ReturnToMenu() ));
    }
    
    public boolean update()
    {
        float delta = 30 / frameRate;
        
        //If game is running
        if (!pause)
        {
            for (int i = 0; i < players.size(); i++)
            {
                if (!players.get(i).update(delta))
                {
                    players.remove(i);
                    i--;
                }
            }
            
            for (int i = 0; i < enemies.size(); i++)
            {
                if (!enemies.get(i).update(delta))
                {
                    enemies.remove(i);
                    i--;
                }
            }
            
            for (int i = 0; i < enemyProj.size(); i++)
            {
                if (!enemyProj.get(i).update(delta))
                {
                    enemyProj.remove(i);
                    i--;
                }
            }
            
            for (int i = 0; i < playerProj.size(); i++)
            {
                if (!playerProj.get(i).update(delta))
                {
                    playerProj.remove(i);
                    i--;
                }
            }
            
            HUD.update();
        }
        //If menu is up
        else
        {
            HUD.update();
            
            if (options)
            {
                sm.optionsMenu.update();
            }
            else
            {
                GIMenu.update();
            }
        }
        
        return true;
    }
    
    public void render()
    {
        background(0);
        
        PVector controlCoords = new PVector(control.pos.x, control.pos.y);
        controlCoords.mult(-1);
        controlCoords.add(new PVector(width/2, height/2));
        
        star.render(controlCoords, control.pos, 2);
        
        for (PC p : players)
            p.render(controlCoords);
        for (PC p : enemies)
            p.render(controlCoords);
            
        for (Proj p : playerProj)
            p.render(controlCoords);
        for (Proj p : enemyProj)
            p.render(controlCoords);
        
        HUD.render(new PVector(0,0));
        
        if (pause)
        {
            if (options)
            {
                sm.optionsMenu.render(new PVector(0,0));
            }
            else
            {
                GIMenu.render(new PVector(0,0));
            }
        }
    }
    
    // Functions
    void playerSwitchCheck()
    {
        //Q
        if (keysS[4] && keys[4])
        {
            playerInd--;
            if (playerInd < 0)
                playerInd = players.size() - 1;
            
            control.setControl(false);
            control = players.get(playerInd);
            control.setControl(true);
            
            keysS[4] = false;
        }
        //E
        else if (keysS[5] && keys[5])
        {
            playerInd++;
            if (playerInd >= players.size())
                playerInd = 0;
            
            control.setControl(false);
            control = players.get(playerInd);
            control.setControl(true);
            
            keysS[5] = false;
        }
    }
}


// MAIN MENU STATE
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
    }
    
    public void init()
    {
        UIElements = new UIGroup(new PVector(width/2,height/2));
        
        camera = parsePC("data/menuChase.player");
        targ = new ArrayList<PC>();
        
        pause = false;
        options = false;
        
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
        
        targ.add(parsePC("data/menuChase.player"));
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