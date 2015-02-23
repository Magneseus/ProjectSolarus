class Clock 
{
  float x, y;
  int h, m, s;
  
  Clock() 
  {
  }
   
  void getTime() 
  {
    h = hour();
    m = minute();
    s = second();
  }
  
  void displayTime() 
  {
    text(h + ":" + nf(m, 2) + ":" + nf(s, 2), x, y);
  }
}
