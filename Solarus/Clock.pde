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
    String meridian;
    
    if (h >= 12)
    {
      meridian = "PM";
    }
    else
    {
      meridian = "AM";
    }
    
    text(h + ":" + nf(m, 2) + ":" + nf(s, 2) + " " + meridian, x, y);
  }
}
