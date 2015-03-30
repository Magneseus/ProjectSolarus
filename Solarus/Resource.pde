public class Resource{
  
  public int value;
  private color col;
  public String name;
  
  Resource(int start, color colin, String id){
    value = start;
    col = colin;
    name = id;    
  }
  
  public void update(){
    value += random(-10,11);
    if(value<=49){
      value = 50;
    }else if(value>=500){
      value = 499;
    }
  }
  
  public void render(int y){
    
    rectMode(CORNERS);
    noStroke();
    fill(col);
    rect(50,y-12,50+value,y+12);
    
    
  }
  
}
