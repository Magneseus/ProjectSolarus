public class Resource{
  
  public int value;
  public int valueOld;
  private color col;
  public String name;
  private int volatility;
  private float shift;
  
  Resource(String nm, int val, int vol, float sf, color cl){
    value = val;
    col = cl;
    name = nm;
    volatility = vol;
    shift = sf;
    valueOld = 0;
  }
  
  public void update(float x){
    valueOld = value;
    value += (volatility*(sin(x-shift)));
    if(value<=49){
      value = 50;
    }else if(value>=1000){
      value = 999;
    }
  }
  
  public void render(int y){
    if(value>valueOld){
      rectMode(CORNERS);
      noStroke();
      fill(col);
      rect(50,y-12,50+(value/2),y+12);
      fill(lerpColor(col,color(0),.33));
      rect(50,y-12,50+(valueOld/2),y+12);
    }else if(value<valueOld){
      rectMode(CORNERS);
      noStroke();
      fill(lerpColor(col,color(0),.33));
      rect(50,y-12,50+(valueOld/2),y+12);
      fill(col);
      rect(50,y-12,50+(value/2),y+12);
    }else{
      rectMode(CORNERS);
      noStroke();
      fill(col);
      rect(50,y-12,50+(value/2),y+12);
    }
  }
  
}
