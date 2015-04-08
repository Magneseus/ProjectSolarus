/*
0 - W
1 - A
2 - S
3 - D
4 - Q
5 - E
6 - 1
7 - 2
8 - 3
9 - 4
10 - 5
11 - 6
12 - 7
13 - 8
14 - !
15 - @
16 - #
17 - $
18 - %
19 - ^
20 - &
21 - *
22 - F
*/

char[] keyList = {'w', 'a', 's', 'd', 'q', 'e','1','2','3','4','5','6','7','8','!','@','#','$','%','^','&','*', 'f'};
boolean[] keys = new boolean[23];
boolean[] keysS = new boolean[23];

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
