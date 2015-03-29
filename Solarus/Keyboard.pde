/*
0 - W
1 - A
2 - S
3 - D
4 - Q
5 - E
*/

char[] keyList = {'w', 'a', 's', 'd', 'q', 'e', 'f'};
boolean[] keys = new boolean[7];
boolean[] keysS = new boolean[7];

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
