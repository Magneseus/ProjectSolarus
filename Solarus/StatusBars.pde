class StatusBar
{
  float x, y;
  int barWidth;
  
  StatusBar(float _x, float _y, int _barWidth)
  {
    x = _x;
    y = _y;
    barWidth = _barWidth;
  }
  
  void update()
  {
    rect(x, y, barWidth, 10);
  }
}
