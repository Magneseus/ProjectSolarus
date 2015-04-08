public class Market extends State {

  public Resource[] market = new Resource[8];
  private color[] colours = {color(255, 0, 0), 
                             color(255, 128, 0), 
                             color(255, 255, 0), 
                             color(0, 255, 0), 
                             color(0, 255, 255), 
                             color(0, 0, 255), 
                             color(128, 0, 255), 
                             color(255, 0, 255)
                             
  market[0] = new Resource("TEMP", 200, 65, 0, colours[0]);
  market[1] = new Resource("TEMP", 200, 70, QUARTER_PI, colours[1]);
  market[2] = new Resource("TEMP", 200, 75, HALF_PI, colours[2]);
  market[3] = new Resource("TEMP", 200, 80, PI-QUARTER_PI, colours[3]);
  market[4] = new Resource("TEMP", 200, 85, PI, colours[4]);
  market[5] = new Resource("TEMP", 200, 90, PI+QUARTER_PI, colours[5]);
  market[6] = new Resource("TEMP", 200, 95, TAU-HALF_PI, colours[6]);
  market[7] = new Resource("TEMP", 200, 100, TAU-QUARTER_PI, colours[7]);
  
  
  };

  public void init() {
    for (int i=0; i<market.length; i++) {
      market[i].update();
    }
  }

  public boolean update() {
    return true;
  }

  public void render() {
    for (int i=0; i<market.length; i++) {
      market[i].render((i+1)*89);
    }
    stroke(255);
    noFill();
    rectMode(CORNERS);
    rect(50, 76, 550, 725);
    stroke(255, 0, 0);
    line(75, 77, 75, 724);
  }
}

