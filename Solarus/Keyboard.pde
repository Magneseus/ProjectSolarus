/*
0 - W
1 - A
2 - S
3 - D
*/

char[] keyList = {'w', 'a', 's', 'd'};
boolean[] keys = new boolean[4];
boolean[] keysS = new boolean[4];

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
}
