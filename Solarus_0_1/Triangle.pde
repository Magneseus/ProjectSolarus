class triangles {
 float x, y;
 float size;
 color base, acc;
 
 triangles(float xin, float yin, float sizein, color basein, color accin){
   x=xin;
   y=yin;
   size=sizein; 
   base=basein;
   acc=accin;
 }
  
  PImage display(){
    float x1 = x-((sqrt(3)/2)*size); 
    float x2 = x+((sqrt(3)/2)*size);
    float x3 = x;
    float y1 = y+(size/2);
    float y2 = y+(size/2);
    float y3 = y-size;
    
    PGraphics c = createGraphics((int)size*3, (int)size*3);
    c.beginDraw();
    c.fill(base);
    c.triangle(x1,y1,x2,y2,x3,y3);
    c.fill(acc);
    c.triangle(x1-((sqrt(3)/2)*(size/2)),y1+(size/4),x1+((sqrt(3)/2)*(size/2)),y1+(size/4),x1,y1-(size/2));
    c.triangle(x2-((sqrt(3)/2)*(size/2)),y2+(size/4),x2+((sqrt(3)/2)*(size/2)),y2+(size/4),x2,y2-(size/2));
    c.triangle(x3-((sqrt(3)/2)*(size/2)),y3+(size/4),x3+((sqrt(3)/2)*(size/2)),y3+(size/4),x3,y3-(size/2));
    c.endDraw();
    
    PImage returnVal = c.get();
    return returnVal;
  }
 
}
