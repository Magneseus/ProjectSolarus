public class Market extends State {
    
  private UIGroup GMMenu;
  private long startUp, waitUp = 100;

  public Resource[] store = new Resource[8];
  private color[] colours = {color(255, 0, 0), 
                             color(255, 128, 0), 
                             color(255, 255, 0), 
                             color(0, 255, 0), 
                             color(0, 255, 255), 
                             color(0, 0, 255), 
                             color(128, 0, 255), 
                             color(255, 0, 255)
  };

  public Market(StateManager sm) {
      super(sm);
    store[0] = new Resource("TEMP", 200, 65, 0, colours[0]);
    store[1] = new Resource("TEMP", 200, 70, QUARTER_PI, colours[1]);
    store[2] = new Resource("TEMP", 200, 75, HALF_PI, colours[2]);
    store[3] = new Resource("TEMP", 200, 80, PI-QUARTER_PI, colours[3]);
    store[4] = new Resource("TEMP", 200, 85, PI, colours[4]);
    store[5] = new Resource("TEMP", 200, 90, PI+QUARTER_PI, colours[5]);
    store[6] = new Resource("TEMP", 200, 95, TAU-HALF_PI, colours[6]);
    store[7] = new Resource("TEMP", 200, 100, TAU-QUARTER_PI, colours[7]);
    
    GMMenu = new UIGroup(new PVector(width/2, height/2), new PVector(0,0));
  }

  public void init() {
    store[0] = new Resource("TEMP", 200, 65, 0, colours[0]);
    store[1] = new Resource("TEMP", 200, 70, QUARTER_PI, colours[1]);
    store[2] = new Resource("TEMP", 200, 75, HALF_PI, colours[2]);
    store[3] = new Resource("TEMP", 200, 80, PI-QUARTER_PI, colours[3]);
    store[4] = new Resource("TEMP", 200, 85, PI, colours[4]);
    store[5] = new Resource("TEMP", 200, 90, PI+QUARTER_PI, colours[5]);
    store[6] = new Resource("TEMP", 200, 95, TAU-HALF_PI, colours[6]);
    store[7] = new Resource("TEMP", 200, 100, TAU-QUARTER_PI, colours[7]);
    
    PGraphics tmpBack = createGraphics(500,650);
        tmpBack.beginDraw();
        tmpBack.fill(50,50,50,150);
        tmpBack.stroke(50,50,50);
        tmpBack.rect(0,0,500,650);
        tmpBack.endDraw();
        GMMenu.add(new UIImage(
                new PVector(0,0),
                new PVector(500, 650),
                tmpBack ));
                
        PGraphics tmpBack2 = createGraphics(width,height);
        tmpBack2.beginDraw();
        tmpBack2.fill(0,0,0,100);
        tmpBack2.stroke(0,0,0,100);
        tmpBack2.rect(0,0,width,height);
        tmpBack2.endDraw();
        GMMenu.add(new UIImage(
                new PVector(0,0),
                new PVector(width, height),
                tmpBack2 ));
        
        GMMenu.add(new UIButton(
                new PVector(0, -225),
                new PVector(400,100),
                "Resume Game",
                new unpause() ));
        
        class tempSave implements Command { public void execute(){println("Saved Game.");} }
        GMMenu.add(new UIButton(
                new PVector(0, -75),
                new PVector(400,100),
                "Save Game",
                new tempSave() ));
        
        GMMenu.add(new UIButton(
                new PVector(0, 75),
                new PVector(400,100),
                "Options",
                new options() ));
        
        class ReturnToLevel implements Command { public void execute(){sm.returnToPrev();} }
        GMMenu.add(new UIButton(
                new PVector(0, 225),
                new PVector(400,100),
                "Return to Level",
                new ReturnToLevel() ));
        
        startUp = millis();
  }

  public boolean update() {
      if (!pause)
      {
          if (millis() - startUp > waitUp)
          {
              for (int i=0; i<store.length; i++)
              {
                  store[i].update();
              }
              startUp = millis();
          }
      }
        //If menu is up
        else
        {
            if (keys[9] && keysS[9])
              {
                  for (int i=0; i<store.length; i++)
                  {
                      store[i].update();
                  }
                  keysS[9] = false;
              }
          
            if (options)
            {
                sm.optionsMenu.update();
            }
            else
            {
                GMMenu.update();
            }
        }
        
    return true;
  }

  public void render() {
      background(0);
    for (int i=0; i<store.length; i++) {
      store[i].render((i+1)*89);
    }
    stroke(255);
    noFill();
    rectMode(CORNERS);
    rect(50, 76, 550, 725);
    stroke(255, 0, 0);
    line(75, 77, 75, 724);
    
    if (pause)
        {
            if (options)
            {
                sm.optionsMenu.render(new PVector(0,0));
            }
            else
            {
                GMMenu.render(new PVector(0,0));
            }
        }
  }
}
