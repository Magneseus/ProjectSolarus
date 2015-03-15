class StatusBar
{
    float x, y;
    int barWidth, barHeight;

    StatusBar(float _x, float _y, int _barWidth, int _barHeight)
    {
        x = _x;
        y = _y;
        barWidth = _barWidth*2;
        barHeight = _barHeight;
    }

    void drawBar()
    {
        rect(x, y, barWidth, barHeight);
    }
}

