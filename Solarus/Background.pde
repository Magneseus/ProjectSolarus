class Stars
{
    // Members
    private ArrayList<ArrayList<PImage>> tileList;
    private ArrayList<int[][]> mapList;
    private FloatList offsetList;
    
    /**
     * Creates a new Star class, just initializes the lists.
     */
    Stars()
    {
        tileList = new ArrayList<ArrayList<PImage>>();
        mapList = new ArrayList<int[][]>();
        offsetList = new FloatList();
    }
    
    /**
     * Renders the background to the screen.
     * 
     * @param trans The offset we want to move the background by
     * @param playerCoord The player coordinates to find which tiles to render
     * @param radius The number of tiles around the player to render (4x4, etc)
     */
    void render(PVector trans, PVector playerCoord, int radius)
    {
        // Iterate through all the tiles we have selected to render
        for (int i = 0; i < mapList.size(); i++)
        {
            // Calculate the position of the tiles on the screen as well
            // as which tiles to display
            PVector tilePos = PVector.mult(playerCoord, offsetList.get(i));
            PVector tilePosCor = PVector.sub(playerCoord, tilePos);
            
            // Get the dimensions
            int w = (int) tileList.get(i).get(0).width;//getDimensions().x;
            int h = (int) tileList.get(i).get(0).height;//getDimensions().y;
            
            // Get the positions
            int sx = mapList.get(i).length * w;
            int sy = mapList.get(i)[0].length * h;
            
            // Do some crazy calculations that I should've documented when
            // I wrote this in the first place
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
            
            // Render all the tiles in the radius
            for (int x = -radius; x <= radius; x++)
            {
                for (int y = -radius; y <= radius; y++)
                {
                    PVector pos = new PVector((xpos2+x)*w, (ypos2+y)*h);
                    pos.add(tilePos);
                    
                    int x2 = (int) fixNum(x+xpos, sx);
                    int y2 = (int) fixNum(y+ypos, sy);
                    
                    int ind = mapList.get(i)[x2][y2];
                    //PImage tile = tileList.get(i).get(ind);
                    
                    //tile.render(PVector.add(pos,trans));
                    image(tileList.get(i).get(ind), (int)(trans.x+pos.x), (int)(trans.y+pos.y));
                }
            }
            
        }
    }
    
    /**
     * Adds another layer to the Map list.
     * <p>
     * The map list is the 2D array of integers that dictate which tile to
     * render in which position.
     * 
     * @param size How many tiles to map (X*Y tile list)
     * @param numTiles The number of unique tiles there will be (1-n)
     * @param offset Don't remember what this is for :/
     */
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
    
    /**
     * Adds another layer to the Tile List.
     * <p>
     * The tile list is the 1D array of unique tile images that the map list
     * can select from.
     * 
     * @param dimensions The size of the image tiles (X*Y)
     * @param starSize The size of each star, stars are squares
     * @param percentFill The percentage of the tile to fill with stars
     * @param starColor The color of the stars
     * @param numTiles The number of unique tiles to create (should be same as map)
     */
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
    
    /**
     *  This is for use when rendering tiles, caps the number off at a certain
     *  value, with some more slightly complicated implications to deal with
     *  negative values and other shit.
     *  
     * @param num Given number to check
     * @param cap The cap, pretty self-explanatory
     * @return The fixed number
     */
    float fixNum(float num, float cap)
    {
        if (abs(num) >= cap)
            num = num % cap;
        
        if (num < 0)
                num += cap;
        
        return num;
    }
    
}

// The class that contains a singular tile
// This is not in use anymore, as storing each star as a PVector is clearly
// not efficient in any way, but was originally considered when there 
// were weird rendering effects with the PImages
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

/**
 * Generates a new image tile.
 * 
 * @param dimensions The size of the tile (X*Y)
 * @param starSize The size of each star (stars are squares)
 * @param percentFill The percentage of the tile to fill with stars
 * @param starColor The color of the stars
 * @return The newly generated image tile
 */
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
