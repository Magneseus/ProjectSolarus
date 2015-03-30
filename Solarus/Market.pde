public class Market{
  
  public Resource[] store = new Resource[8];
  private color[] colours = {color(255,0,0),color(255,128,0),color(255,255,0),color(0,255,0),color(0,255,255),color(0,0,255),color(128,0,255),color(255,0,255)};
  
  public Market(){
   
   for(int i=0; i<store.length; i++){
   store[i] = new Resource((i+1)*50,colours[i],"TEMP");
   }
  }
  
  public void update(){
   
   for(int i=0; i<store.length; i++){
     store[i].update(); 
    }
    
  }
  
  public void render(){
    
    for(int i=0; i<store.length; i++){
     store[i].render((i+1)*89); 
    }
    stroke(255);
    noFill();
    rectMode(CORNERS);
    rect(50,76,550,725);
    stroke(255,0,0);
    line(100,77,100,724);
    
  }
  
}
