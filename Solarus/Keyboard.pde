/*
0 - W
1 - A
2 - S
3 - D
4 - Q
5 - E
*/

char[] keyList = {'w', 'a', 's', 'd', 'q', 'e'};
boolean[] keys = new boolean[6];
boolean[] keysS = new boolean[6];

void keyPressed()
{
    for (int i = 0; i < keyList.length; i++)
    {
        if (key == keyList[i])
            keys[i] = true;
    }
}

void keyReleased()
{
  
  if (key == ' ') {
      store.update();
    }
  
    for (int i = 0; i < keyList.length; i++)
    {
        if (key == keyList[i])
        {
            keys[i] = false;
            keysS[i] = true;
        }
    }
}
