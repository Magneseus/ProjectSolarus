
class Stars
{
    private ArrayList<ArrayList<PImage>> tileList;
    private ArrayList<int[][]> mapList;
    private FloatList offsetList;
    
    Stars()
    {
        tileList = new ArrayList<ArrayList<PImage>>();
        mapList = new ArrayList<int[][]>();
        offsetList = new FloatList();
    }
    
    void render(PVector trans, PVector playerCoord, int radius)
    {
        int c = 0;
        for (int i = 0; i < mapList.size(); i++)
        {
            PVector tilePos = PVector.mult(playerCoord, offsetList.get(i));
            PVector tilePosCor = PVector.sub(playerCoord, tilePos);
            
            int w = (int) tileList.get(i).get(0).width;//getDimensions().x;
            int h = (int) tileList.get(i).get(0).height;//getDimensions().y;
            
            int sx = mapList.get(i).length * w;
            int sy = mapList.get(i)[0].length * h;
            
            float ofx = 0, ofy = 0;
            if (tilePosCor.x < 0)
                ofx = -w;
            if (tilePosCor.y < 0)
                ofy = -h;
            
            int xpos = int( fixNum(tilePosCor.x, sx) / w );
            int ypos = int( fixNum(tilePosCor.y, sy) / h );
            int xpos2 = int( (tilePosCor.x + ofx) / w );
            int ypos2 = int( (tilePosCor.y + ofy) / h );
            
            sx /= w;
            sy /= h;
            
            for (int x = -radius; x <= radius; x++)
            {
                for (int y = -radius; y <= radius; y++)
                {
                    PVector pos = new PVector((xpos2+x)*w, (ypos2+y)*h);
                    pos.add(tilePos);
                    
                    int x2 = (int) fixNum(x+xpos, sx);
                    int y2 = (int) fixNum(y+ypos, sy);
                    
                    int ind = mapList.get(i)[x2][y2];
                    PImage tile = tileList.get(i).get(ind);
                    
                    //tile.render(PVector.add(pos,trans));
                    image(tile, trans.x+pos.x, trans.y+pos.y);
                }
            }
            
        }
    }
    
    void addMapLayer(PVector size, int numTiles, float offset)
    {
        int[][] tempMap = new int[(int)size.x][(int)size.y];
        for (int x = 0; x < size.x; x++)
        {
            for (int y = 0; y < size.y; y++)
            {
                tempMap[x][y] = (int)random(numTiles);
            }
        }
        mapList.add(tempMap);
        
        offsetList.append(offset);
    }
    
    void addTileLayer(PVector dimensions, float starSize, float percentFill, color starColor, int numTiles)
    {
        ArrayList<PImage> tempTiles = new ArrayList<PImage>();
        
        for (int i = 0; i < numTiles; i++)
        {
            tempTiles.add(genTile(dimensions, starSize, percentFill, starColor));
            //tempTiles.add(new StarTile(dimensions, starSize, percentFill, starColor));
        }
        
        tileList.add(tempTiles);
    }
    
    float fixNum(float num, float cap)
    {
        if (abs(num) >= cap)
            num = num % cap;
        
        if (num < 0)
                num += cap;
        
        return num;
    }
    
}

class StarTile
{
    private ArrayList<PVector> stars;
    private color col;
    private PVector dim;
    
    StarTile(PVector dimensions, float starSize, float percentFill, color starColor)
    {
        stars = new ArrayList<PVector>();
        
        int totalCount = int(percentFill * dimensions.x * dimensions.y);
        for (int i = 0; i < totalCount; i++)
        {
            int xpos = (int)random(0, dimensions.x - starSize);
            int ypos = (int)random(0, dimensions.y - starSize);
            
            for (int x = xpos; x < xpos + starSize; x++)
            {
                for (int y = ypos; y < ypos + starSize; y++)
                {
                    stars.add(new PVector(x, y));
                }
            }
        }
        
        col = starColor;
        dim = dimensions;
    }
    
    void render(PVector trans)
    {
        for (int i = 0; i < stars.size(); i++)
        {
            stroke(col);
            fill(col);
            
            PVector p = PVector.mult(stars.get(i), 1);
            p.add(trans);
            
            point(p.x, p.y);
        }
    }
    
    PVector getDimensions()
    {
        return dim;
    }
}

PImage genTile(PVector dimensions, float starSize, float percentFill, color starColor)
{
    PImage starTile = createImage((int)dimensions.x, (int)dimensions.y, ARGB);
    
    starTile.loadPixels();
    
    int totalCount = int(percentFill * dimensions.x * dimensions.y);
    for (int i = 0; i < totalCount; i++)
    {
        int xpos = (int)random(0, dimensions.x - starSize);
        int ypos = (int)random(0, dimensions.y - starSize);
        
        for (int x = xpos; x < xpos + starSize; x++)
        {
            for (int y = ypos; y < ypos + starSize; y++)
            {
                int ind = int( (dimensions.x * y) + x);
                starTile.pixels[ind] = starColor;
                
            }
        }
    }
    /*
    for (int x = 0; x < dimensions.x; x++)
    {
        starTile.pixels[x] = color(255,0,0,50);
        starTile.pixels[int(x + (dimensions.y * (dimensions.x-1)))] = color(255,0,0,50);
    }
    for (int y = 0; y < dimensions.y; y++)
    {
        starTile.pixels[y] = color(255,0,0,50);
        starTile.pixels[int((y*dimensions.x) + dimensions.x-1)] = color(255,0,0,50);
    }
    */
    
    starTile.updatePixels();
    
    return starTile;
}
