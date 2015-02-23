class Time 
{
  float x, y;
  int fontSize;
  int h, m, s;
  
  Time(float x, float y, int f) 
  {
    x = x;
    y = y;
    fontSize = f;
  }
   
  void getTime() 
  {
    h = hour();
    m = minute();
    s = second();
  }
  
  void displayTime() 
  {
    textSize(fontSize);
    text("Time: " + h + ":" + nf(m, 2) + ":" + nf(s, 2), x, y);
  }
}
 
