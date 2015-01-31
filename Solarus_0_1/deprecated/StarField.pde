/*
Starfield Background
- parallaxing, randomly generated background

January 26th
*/

class StarField
{
    //Vars
    ArrayList<PImage> renderList;
    ArrayList<PVector> renderPositions;
    
    boolean renderLargeStars;
    
    final PVector tileSize = new PVector (500, 500);
    
    //Tile Vars
    float[] layerMult = {1,2,4}; 
    float[] layerSpeedMult = {0.8,0.5,0.3};
    float[] layerPercent = {50,15,2};
    float[] layerColorR = {175,120,55};
    
    PGraphics tileMapData[][];
    
    PVector layerOrigin[];
    PVector playerPosT;
    
    int tileMap[];
    
    
    StarField()
    {
        renderLargeStars = true;
        
        renderList = new ArrayList<PImage>();
        renderPositions = new ArrayList<PVector>();
        
        PVector origin = new PVector(0,0);
        
        PVector[] layerOrigin = new PVector[3];
        layerOrigin[0] = origin;
        layerOrigin[1] = origin;
        layerOrigin[2] = origin;
        
        tileMapData = new PGraphics[3][];
        for (int i = 0; i < tileMapData.length; i++)
        {
            tileMapData[i] = new PGraphics[10];
        }
        
        tileMap = new int[30*30];
    }
    
    void newGen()
    {
        for (int i = 0; i < tileMap.length; i++)
        {
            tileMap[i] = (int) random(tileMapData[i].length);
            
            for (int j = 0; j < tileMapData[i].length; j++)
                tileMapData[i][j] = tileGen(layerPercent[i], layerMult[i], layerColorR[i]);
        }
    }
    
    
    //NEEDS WORK!!!!!??????
    PGraphics tileGen(float percent, float sizeMult, float colorReduc)
    {
        int tileSizeT = (int) (tileSize.x * tileSize.y);
        PGraphics t = createGraphics((int)tileSize.x, (int)tileSize.y, P2D);
        
        t.beginDraw();
        noStroke();
        fill(255,255,255,255-(int)colorReduc);
        
        int numStars = (int) (((int)percent / 10000 * tileSizeT) + random(-100,100));
        for (int j = 0; j < numStars; j++)
        {
            PVector coord = new PVector((int) random((int)tileSize.x), (int) random((int) tileSize.y));
            if (sizeMult == 1.f)
                point((int)coord.x, (int)coord.y);
            else
                rect((int)coord.x, (int)coord.y, (int)sizeMult, (int)sizeMult);
        }
        t.endDraw();
        
        return t;
    }
    
    void update(PVector offset, PVector offsetVel, float time)
    {
        
    }
    
    void render()
    {
        for (int i = 0; i < renderList.size(); i++)
        {
            PVector pos = renderPositions.get(i);
            
        }
    }
    
    void toggleLargeStars(boolean toggle)
    {
        
    }
}
