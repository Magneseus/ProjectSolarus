public class Resource{
  
  public int value;
  private color col;
  public String name;
  
  Resource(int start, color colin, String id){
    value = start;
    col = colin;
    name = id;
  }
  
  public update(){
    value += random(-2,2);
  }
  
  public render(int y){
    
    int w = value/20;
    
    
    
  }
  
}
