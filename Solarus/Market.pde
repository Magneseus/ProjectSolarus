public class Market extends State {

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
  }

  public boolean update() {
    for (int i=0; i<store.length; i++) {
      store[i].update();
    }
    return true;
  }

  public void render() {
    for (int i=0; i<store.length; i++) {
      store[i].render((i+1)*89);
    }
    stroke(255);
    noFill();
    rectMode(CORNERS);
    rect(50, 76, 550, 725);
    stroke(255, 0, 0);
    line(75, 77, 75, 724);
  }
}
