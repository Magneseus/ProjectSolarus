/*
0 - W
1 - A
2 - S
3 - D
4 - Q
5 - E
6 - F
7 - 1 temp
8 - 2 temp
*/

char[] keyList = {'w', 'a', 's', 'd', 'q', 'e', 'f', '1', '2'};
boolean[] keys = new boolean[9];
boolean[] keysS = new boolean[9];

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
  
    for (int i = 0; i < keyList.length; i++)
    {
        if (key == keyList[i])
        {
            keys[i] = false;
            keysS[i] = true;
        }
    }
    
    if (key == '`' || key == '~')
        pause = !pause;
}
