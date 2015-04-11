public class Resource {

  public int value;
  public int valueOld;
  public color col;
  public String name;
  private int volatility;
  private float shift;

  Resource(String nm, int val, int vol, float sf, color cl) {
    value = val;
    col = cl;
    name = nm;
    volatility = vol;
    shift = sf;
    valueOld = 0;
  }

  public void update() {
    valueOld = value;
    if (value<=150) {
      for (int i=0; i<3; i++) {
        value += volatility*(sin((radians(millis()/10))-shift))+(volatility/3);
      }
    } else if (value>=850) {
      for (int i=0; i<3; i++) {
        value += volatility*(sin((radians(millis()/10))-shift))-(volatility/3);
      }
    } else {
      for (int i=0; i<3; i++) {
        value += volatility*(sin((radians(millis()/10))-shift));
      }
    }
    if (value<=49) {
      value = 50;
    } else if (value>=1000) {
      value = 999;
    }
  }

  public void render(int y) {
    if (value>valueOld+10) {
      rectMode(CORNERS);
      noStroke();
      fill(col);
      rect(160, y-12, 160+(value/2), y+12);
      fill(lerpColor(col, color(0), .5));
      rect(160, y-12, 160+(valueOld/2), y+12);
    } else if (value<valueOld-10) {
      rectMode(CORNERS);
      noStroke();
      fill(lerpColor(col, color(0), .5 ));
      rect(160, y-12, 160+(valueOld/2), y+12);
      fill(col);
      rect(160, y-12, 160+(value/2), y+12);
    } else {
      rectMode(CORNERS);
      noStroke();
      fill(col);
      rect(160, y-12, 160+(value/2), y+12);
    }
  }
}

