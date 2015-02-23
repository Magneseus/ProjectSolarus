boolean debug_ = false;

PC p1, p2;
PC control;
Stars star;

ArrayList<Proj> playerProj;
ArrayList<PC> players;
int playerInd = 0;

ArrayList<Proj> enemyProj;
ArrayList<PC> enemies;

void setup()
{
    size(800,600);
    background(0);
    frameRate(60);
    
    ellipseMode(RADIUS);
    rectMode(CORNERS);
    
    for (int i = 0; i < keysS.length; i++)
        keysS[i] = true;
    
    enemies = new ArrayList<PC>();
    players = new ArrayList<PC>();
    loadEnemies();
    loadPlayers();
    
    star = new Stars();
    star.addMapLayer(new PVector(5,5), 5, 0.1);
    star.addTileLayer(new PVector(400,400), 5, 0.0001, color(255,255,255,40), 5);
    star.addMapLayer(new PVector(5,5), 5, -0.1);
    star.addTileLayer(new PVector(400,400), 3, 0.001, color(255,255,255,45), 5);
    //star.addMapLayer(new PVector(5,5), 5, -0.3);
    //star.addTileLayer(new PVector(400,400), 1, 0.005, color(255,255,255,60), 5);
}

void draw()
{
    background(0);
    
    for (PC p : players)
        p.update(30/frameRate);
    for (PC p : enemies)
        p.update(30/frameRate);
    
    p1.rot(PI/128);
    
    PVector controlCoords = new PVector(control.pos.x, control.pos.y);
    controlCoords.mult(-1);
    controlCoords.add(new PVector(width/2, height/2));
    
    star.render(controlCoords, control.pos, 2);
    
    for (PC p : players)
        p.render(controlCoords);
    for (PC p : enemies)
        p.render(controlCoords);
    
    p1.render(controlCoords);
    p2.render(controlCoords);
    
    playerSwitchCheck();
}

void playerSwitchCheck()
{
    //Q
    if (keysS[4] && keys[4])
    {
        playerInd--;
        if (playerInd < 0)
            playerInd = players.size() - 1;
        
        control.setControl(false);
        control = players.get(playerInd);
        control.setControl(true);
        
        keysS[4] = false;
    }
    //E
    else if (keysS[5] && keys[5])
    {
        playerInd++;
        if (playerInd >= players.size())
            playerInd = 0;
        
        control.setControl(false);
        control = players.get(playerInd);
        control.setControl(true);
        
        keysS[5] = false;
    }
}

void loadEnemies()
{
    PC p;
    p = parsePC("test_triangle.player");
    PGraphics im = createGraphics(40,40);
    im.beginDraw();
    im.stroke(255,0,0);
    im.fill(255,0,0);
    im.triangle(0, 40, 20, 0, 40, 40);
    im.endDraw();
    
    p.setImage(im);
    p.moveTo(new PVector(20,20));
    
    PC p1;
    p1 = parsePC("test_triangle.player");
    p1.setImage(im);
    p1.moveTo(new PVector(0,0));
    
    p.maxRot = 6;
    p1.maxRot = 6;
    
    p.setRotThresh(16);
    p1.setRotThresh(16);
    
    p.setAITargets(players);
    p1.setAITargets(players);
    
    enemies.add(p);
    enemies.add(p1);
}

//Temp function
void loadPlayers()
{
    PC p;
    p = parsePC("test_triangle.player");
    PGraphics im = createGraphics(40,40);
    im.beginDraw();
    im.stroke(0,255,0);
    im.fill(0,255,0);
    im.triangle(0, 40, 20, 0, 40, 40);
    im.endDraw();
    
    p.setImage(im);
    p.moveTo(new PVector(width/2, height/2));
    p.setControl(true);
    control = p;
    //p.toggleHitBox();
    
    PC p3;
    p3 = parsePC("test_triangle.player");
    im = createGraphics(40,40);
    im.beginDraw();
    im.stroke(0,255,0);
    im.fill(0,255,0);
    im.triangle(0, 40, 20, 0, 40, 40);
    im.endDraw();
    
    p3.setImage(im);
    p3.moveTo(new PVector(width, height));
    //p.toggleHitBox();
    
    players.add(p);
    players.add(p3);
    playerInd = 0;
    
    p1 = parsePC("test_pill.player");
    PGraphics im2 = createGraphics(10,10);
    im2.beginDraw();
    im2.fill(0,0,255);
    im2.rect(0,0, 10, 10);
    im2.endDraw();
    
    p1.setImage(im2);
    p1.moveTo(new PVector(width/2, height/2));
    p1.toggleHitBox();
    
    p2 = parsePC("test.player");
    PGraphics im4 = createGraphics(20,20);
    im4.beginDraw();
    im4.fill(0,255,255);
    im4.rect(0,0,20,20);
    im4.endDraw();
    
    p2.setImage(im4);
    p2.toggleHitBox();
    
}


class AI
{
    private HashMap<String,Integer> states;
    private int STATE = 0;
    
    private ArrayList<PC> targets;
    
    private int aggro, attack, close;
    
    AI(ArrayList<PC> targets_)
    {
        states = new HashMap<String,Integer>();
        states.put("stop", 0);
        states.put("follow", 1);
        states.put("attack", 2);
        states.put("roam", 3);
        states.put("back", 4);
        states.put("flee", 5);
        
        targets = targets_;
        
        aggro = -1;
        attack = -1;
        close = -1;
    }
    
    void update(PC self)
    {
        PC closest = null;
        
        if (targets != null && targets.size() > 0)
        {
            int minDist = (int)self.distance(targets.get(0));
            closest = targets.get(0);
            
            for (PC e : targets)
            {
                float dist = self.distance(e);
                if (dist < minDist)
                {
                    minDist = (int)dist;
                    closest = e;
                }
            }
            
            STATE = states.get("stop");
            
            if (minDist < check(aggro, minDist))
                STATE = states.get("follow");
            if (minDist < check(attack, minDist))
                STATE = states.get("attack");
            if (minDist < check(close + 100, minDist))
                STATE = states.get("stop");
            if (minDist < check(close, minDist))
                STATE = states.get("back");
        }
        
        //Check states
        
        if (STATE == states.get("follow"))
            chase(self, closest);
        
        if (STATE == states.get("attack"))
            chase(self, closest);
        
        if (STATE == states.get("back"))
            chase(self, closest);
        
        if (STATE == states.get("stop"))
        {
            chase(self, closest);
            
            self.accel = new PVector(self.vel.x, self.vel.y);
            self.accel.mult(-self.slow);
            
            if (self.vel.mag() < 0.1)
                self.vel = new PVector(0,0);
        }
        
    }
    
    void chase(PC self, PC other)
    {
        if (self != null && other != null)
        {
            PVector dis = PVector.sub(other.pos, self.pos);
            PVector ang = PVector.fromAngle(self.getAngle());
            ang.rotate(-PI/2);
            
            boolean tCW = false;
            boolean tCCW = false;
            
            if (PVector.angleBetween(dis, ang) > PI/self.getRotThresh())
            {
                float dot = (ang.x * -dis.y) + (ang.y * dis.x);
                
                if (dot >= 0)
                    tCW = true;
                else
                    tCCW = true;
            }
            
            if (tCW)
                self.rot(-self.maxRot / frameRate);
            else if (tCCW)
                self.rot(self.maxRot / frameRate);
            
            
            self.accel = PVector.fromAngle(self.getAngle());
            self.accel.rotate(-PI/2);
            self.accel.setMag(self.maxAccel);
            
            if (STATE == states.get("back"))
                self.accel.mult(-1);
        }
    }
    
    void setTargets(ArrayList<PC> targ)
    {
        targets = targ;
    }
    
    void setInfo(HashMap<String,Integer> info)
    {
        if (info.get("aggro") != null)
            aggro = info.get("aggro");
        if (info.get("attack") != null)
            attack = info.get("attack");
        if (info.get("close") != null)
            close = info.get("close");
         
    }
}

int check(int val, int def)
{
    if (val != -1)
        return val;
    
    return def;
}


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
                    //PImage tile = tileList.get(i).get(ind);
                    
                    //tile.render(PVector.add(pos,trans));
                    image(tileList.get(i).get(ind), trans.x+pos.x, trans.y+pos.y);
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


class Collision
{
    ArrayList<Shape> hitBox;
    PVector center;
    boolean collideable;
    private float angle;
    
    //The center being based off of the local coordinates
    Collision(ArrayList<Shape> hbox, PVector center)
    {
        hitBox = hbox;
        this.center = center;
        for (int i = 0; i < hitBox.size(); i++)
        {
            hitBox.get(i).move(center);
        }
        
        collideable = true;
        angle = PI/2;
    }
    
    boolean collide(Collision c)
    {
        boolean isColliding = false;
        
        if (!collideable || !c.collideable)
            return false;
        
        for (int i = 0; i < hitBox.size(); i++)
        {
            for (int j = 0; j < c.hitBox.size(); j++)
            {
                if (hitBox.get(i).collide(c.hitBox.get(j)))
                {
                    isColliding = true;
                    break;
                }
            }
        }
        
        return isColliding;
    }
    
    void move(PVector p)
    {
        for (int i = 0; i < hitBox.size(); i++)
        {
            hitBox.get(i).setPos(p);
        }
        center = p;
    }
    
    void moveTo(PVector p)
    {
        PVector d = PVector.sub(p, center);
        
        for (int i = 0; i < hitBox.size(); i++)
        {
            hitBox.get(i).move(d);
        }
        center = p;
    }
    
    void render()
    {
        for (int i = 0; i < hitBox.size(); i++)
        {
            hitBox.get(i).render();
        }
    }
    
    void rot(float x)
    {
        for (int i = 0; i < hitBox.size(); i++)
        {
            if (hitBox.get(i).type() == Shape.SRECT)
            {
                Rect r = (Rect)hitBox.get(i);
                r.rot(x);
            }
            
            //Get center of each shape
            PVector tpos = hitBox.get(i).getPos();
            
            //Translate by center
            tpos.sub(center);
            //Rotate
            tpos.rotate(x);
            //Translate back
            tpos.add(center);
            
            //Re-set the position
            hitBox.get(i).setPos(tpos);
        }
        
        angle += x;
        if (angle > 2*PI)
            angle = angle - (2*PI);
        else if (angle < 0)
            angle = (2*PI) + angle;
    }
    
    void rotTo(float x)
    {
        for (int i = 0; i < hitBox.size(); i++)
        {
            if (hitBox.get(i).type() == Shape.SRECT)
            {
                Rect r = (Rect)hitBox.get(i);
                r.rot(-angle);
                r.rot(x);
            }
            
            //Get center of each shape
            PVector tpos = hitBox.get(i).getPos();
            
            //Translate by center
            tpos.sub(center);
            //Rotate
            tpos.rotate(-angle);
            tpos.rotate(x);
            //Translate back
            tpos.add(center);
            
            //Re-set the position
            hitBox.get(i).setPos(tpos);
        }
        
        angle = x;
    }
    
}

//Abstract interface to represent Shapes
interface Shape
{
    boolean collide(Shape s);
    int type();
    void move(PVector p);
    void render();
    PVector getPos();
    void setPos(PVector p);
    
    static final int SRECT = 0;
    static final int SCIRC = 1;
}

//Some small classes for convienience

class Rect implements Shape
{
    PVector tl, tr, bl, br, ct;
    float radius, angle;
    final int type = Shape.SRECT;
    
    //Assumes tl is the top left coord,
    //br is the bottom right (NOT SIZE)
    Rect(PVector tl, PVector br)
    {
        this.tl = tl;
        this.br = br;
        
        this.tr = new PVector(br.x, tl.y);
        this.bl = new PVector(tl.x, br.y);
        
        //Angle in radians
        angle = 0;
        
        PVector d = PVector.sub(br, tl);
        radius = d.mag();
        
        d.div(2);
        ct = PVector.add(tl, d);
    }
    
    Rect(PVector tl, PVector tr, PVector br, PVector bl)
    {
        this.tl = tl;
        this.tr = tr;
        this.br = br;
        this.bl = bl;
        
        //Angle in radians
        angle = 0;
        
        PVector d = PVector.sub(br, tl);
        radius = d.mag()/2;
        
        d.div(2);
        ct = PVector.add(tl, d);
    }
    
    //Collisions
    boolean collide(Shape s)
    {
        boolean isColliding = false;
        
        //If rect-rect collision
        if (s.type() == Shape.SRECT)
        {
            Rect r = (Rect)s;
            
            if (dist(getPos().x, getPos().y, r.getPos().x, r.getPos().y) <
                getRad() + r.getRad())
            {
                //Check if any point lies inside the other rect
                if (pointInRect(r.tl) || pointInRect(r.tr) ||
                    pointInRect(r.br) || pointInRect(r.bl))
                        isColliding = true;
                
                if (r.pointInRect(tl) || r.pointInRect(tr) ||
                    r.pointInRect(br) || r.pointInRect(bl))
                        isColliding = true;
            }
        }
        //If rect-circ collision
        else if (s.type() == Shape.SCIRC)
        {
            isColliding = collideRC(this, (Circ) s);
        }
        
        return isColliding;
    }
    
    //Use this to move the rectangle
    void move(PVector deltaD)
    {
        ct.add(deltaD);
        tl.add(deltaD);
        tr.add(deltaD);
        br.add(deltaD);
        bl.add(deltaD);
    }
    
    void rot(float angle)
    {
        this.angle += angle;
        
        //Record old center
        PVector ctr = new PVector(ct.x, ct.y);
        
        //Translate so center is at origin
        move(PVector.mult(ctr, -1));
        
        //Rotate all vectors
        tl.rotate(angle);
        tr.rotate(angle);
        br.rotate(angle);
        bl.rotate(angle);
        
        //Translate back
        move(ctr);
    }
    
    void rotTo(float newAngle)
    {
        angle = newAngle;
        
        //Record old center
        PVector ctr = new PVector(ct.x, ct.y);
        
        //Translate so center is at origin
        move(PVector.mult(ctr, -1));
        
        //Rotate all vectors
        tl.rotate(angle);
        tr.rotate(angle);
        br.rotate(angle);
        bl.rotate(angle);
        
        //Translate back
        move(ctr);
    }
    
    void render()
    {
        stroke(255,0,0);
        noFill();
        
        line(tl.x, tl.y, tr.x, tr.y);
        line(tr.x, tr.y, br.x, br.y);
        line(br.x, br.y, bl.x, bl.y);
        line(bl.x, bl.y, tl.x, tl.y);
    }
    
    boolean pointInRect(PVector p)
    {
        boolean colliding = true;
        
        float rSum = dist(tl.x, tl.y, tr.x, tr.y) *
                     dist(tl.x, tl.y, bl.x, bl.y);
        
        float a1 = areaOf(tl, p, bl);
        float a2 = areaOf(bl, p, br);
        float a3 = areaOf(br, p, tr);
        float a4 = areaOf(p, tr, tl);
        
        float pSum = a1 + a2 + a3 + a4;
        
        if (pSum - rSum > 2)
            colliding = false;
        
        return colliding;
    }
    
    private float areaOf(PVector p1, PVector p2, PVector p3)
    {
        float a = abs(p1.x * (p2.y - p3.y) + 
                      p2.x * (p3.y - p1.y) +
                      p3.x * (p1.y - p2.y));
        a /= 2;
        
        if (debug_)
        {
            pushMatrix();
            
            PVector controlCoords = new PVector(control.pos.x, control.pos.y);
            controlCoords.mult(-1);
            controlCoords.add(new PVector(width/2, height/2));
            translate(controlCoords.x, controlCoords.y);
            
            line(p1.x,p1.y,p2.x,p2.y);
            line(p2.x,p2.y,p3.x,p3.y);
            line(p3.x,p3.y,p1.x,p1.y);
            
            popMatrix();
        }
        
        return a;
    }
    
    
    
    //     GETTERS & SETTERS     //
    
    //Return the position (center)
    PVector getPos()
    {
        PVector pos = new PVector(ct.x, ct.y);
        return pos;
    }
    
    //Use this to set the position
    void setPos(PVector newPos)
    {
        PVector dif = PVector.sub(newPos, ct);
        
        ct = new PVector(newPos.x, newPos.y);
        tl.add(dif);
        tr.add(dif);
        br.add(dif);
        bl.add(dif);
    }
    
    //Calculate the new "radius"
    private void calcRad()
    {
        PVector d1 = PVector.sub(br, tl);
        PVector d2 = PVector.sub(tr, bl);
        radius = max(d2.mag()/2, d1.mag()/2);
    }
    
    //Returns the "radius", the distance between
    //the top left and the bottom right points
    float getRad()
    {
        calcRad();
        return radius;
    }
    
    int type()
    {
        return type;
    }
}

class Circ implements Shape
{
    PVector pos;
    float radius;
    final int type = Shape.SCIRC;
    
    //Assumes pos is the center of the circle
    //radius is obviously the radius
    Circ(PVector pos, float radius)
    {
        this.pos = pos;
        this.radius = radius;
    }
    
    //Simple collisions and then more complex
    boolean collide(Shape s)
    {
        boolean isColliding = false;
        
        //If rect-circ collision
        if (s.type() == Shape.SRECT)
        {
            Rect r = (Rect)s;
            
            isColliding = collideRC(r, this);
        }
        //If circ-circ collision
        else if (s.type() == Shape.SCIRC)
        {
            Circ c = (Circ)s;
            
            //If the distance is less than the sum of the radii, colliding
            if (dist(pos.x, pos.y, c.pos.x, c.pos.y) < (radius + c.radius))
                isColliding = true;
        }
        
        return isColliding;
    }
    
    void render()
    {
        stroke(255,0,0);
        noFill();
        
        ellipse(pos.x, pos.y, radius, radius);
    }
    
    void move(PVector deltaD)
    {
        pos.add(deltaD);
    }
    
    
    
    
    //     GETTERS & SETTERS     //
    
    
    PVector getPos()
    {
        return new PVector(pos.x, pos.y);
    }
    
    void setPos(PVector newPos)
    {
        pos = new PVector(newPos.x, newPos.y);
    }
    
    int type()
    {
        return type;
    }
}

 boolean collideRC(Rect r, Circ c)
{
   // if (r.pointInRect(c.getPos()))
     //   return true;
    
    if (lineIntCirc(r.tl, r.tr, c))
        return true;
    if (lineIntCirc(r.tr, r.br, c))
        return true;
    if (lineIntCirc(r.br, r.bl, c))
        return true;
    if (lineIntCirc(r.bl, r.tl, c))
        return true;
    
    return false;
}

 boolean lineIntCirc(PVector p1, PVector p2, Circ c)
{
    boolean isInt = false;
    
    //Line seg.
    PVector x1 = PVector.sub(p2, p1);
    
    //c - p1
    PVector x2 = PVector.sub(c.getPos(), p1);
    //c - p2
    PVector x3 = PVector.sub(c.getPos(), p2);
    
    float theta1 = PVector.angleBetween(x1, x2);
    
    PVector x4 = PVector.mult(x1, -1);
    float theta2 = PVector.angleBetween(x4, x3);
    
    if (theta1 > PI/2)
    {
        float d = x2.mag();
        if (d < c.radius)
            isInt = true;
    }
    else if (theta2 > PI/2)
    {
        float d = x3.mag();
        if (d < c.radius)
            isInt = true;
    }
    else
    {
        float d = sin(theta1) * x2.mag();
        if (d < c.radius)
            isInt = true;
    }
    
    return isInt;
}


abstract class Entity
{
    protected Collision col;
    public PVector pos, vel, accel;
    public float maxVel, maxAccel, maxRot;
    protected float angle;
    protected PGraphics img;
    protected boolean showHitBox;
    
    public abstract boolean update(float delta);
    
    protected void updateKin(float delta)
    {
        vel.add(PVector.mult(accel, delta));
        
        if (vel.mag() > maxVel)
            vel.setMag(maxVel);
        else if (vel.mag() < 0.2)
            vel.setMag(0);
        
        pos.add(PVector.mult(vel, delta));
        
        col.move(pos);
    }
    
    protected void initBase()
    {
        col = null;
        img = null;
        
        pos = new PVector(0,0);
        vel = new PVector(0,0);
        accel = new PVector(0,0);
        
        maxVel = 0;
        maxAccel = 0;
        maxRot = 0;
        
        angle = 0;
        showHitBox = false;
    }
    
    public float distance(Entity other)
    {
        return dist(pos.x, pos.y, other.pos.x, other.pos.y);
    }
    
    public void moveTo(PVector pos)
    {
        this.pos = pos;
        
        col.moveTo(pos);
    }
    
    public void rot(float x)
    {
        angle += x;
        if (angle > 2*PI)
            angle = angle - (2*PI);
        else if (angle < 0)
            angle = (2*PI) + angle;
        
        col.rot(x);
    }
    
    public void rotTo(float x)
    {
        angle = x;
        
        col.rotTo(x);
    }
    
    public void render(PVector trans)
    {
        pushMatrix();
        
        translate(trans.x, trans.y);
        if (showHitBox)
            col.render();
        
        translate(pos.x, pos.y);
        rotate(angle);
        translate(-img.width/2, -img.height/2);
        
        image(img, 0, 0);
        
        popMatrix();
    }
    
    public boolean collide(Entity e)
    {
        return col.collide(e.col);
    }
    
    public void toggleHitBox()
    {
        showHitBox = !showHitBox;
    }
    
    public PGraphics getImage()
    {
        return img;
    }
    
    public float getAngle()
    {
        return angle;
    }
}

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
    for (int i = 0; i < keyList.length; i++)
    {
        if (key == keyList[i])
        {
            keys[i] = false;
            keysS[i] = true;
        }
    }
}

boolean mouseS = true;

void mousePressed()
{
    
}

void mouseReleased()
{
    mouseS = true;
}


class PC extends Entity
{
    private int health, projCount, projMax;
    private boolean inControl;
    private float percentF, percentB, percentS, slow, rotThresh;
    
    private AI alf;

    PC (PVector pos, PGraphics img, Collision c)
    {
        initBase();

        this.pos = pos;
        this.img = img;
        this.col = c;

        health = 0;
        projCount = 0;
        inControl = false;
        
        percentF = 1;
        percentS = 1;
        percentB = 1;
        
        rotThresh = 32;
        
        alf = new AI(null);
    }

    boolean update(float delta)
    {
        updateKin(delta);

        //Check key and mouse presses
        if (inControl)
        {
            PVector mouseCoords = new PVector(mouseX, mouseY);
            PVector dis = PVector.sub(mouseCoords, new PVector(width/2, height/2));
            PVector ang = PVector.fromAngle(angle);
            ang.rotate(-PI/2);
            
            boolean tCW = false;
            boolean tCCW = false;
            
            if (PVector.angleBetween(dis, ang) > PI/rotThresh)
            {
                float dot = (ang.x * -dis.y) + (ang.y * dis.x);
                
                if (dot >= 0)
                    tCW = true;
                else
                    tCCW = true;
            }
            
            if (tCW)
                rot(-maxRot / frameRate);
            else if (tCCW)
                rot(maxRot / frameRate);
            
            PVector one = new PVector(0,0);
            PVector two = new PVector(0,0);
            
            // W
            if (keys[0])
            {
                one = PVector.fromAngle(angle - PI/2);
                one.mult(10 * percentF);
            }
            else if (keys[2])
            {
                one = PVector.fromAngle(angle + PI/2);
                one.mult(10 * percentB);
            }
            // A
            if (keys[1])
            {
                two = PVector.fromAngle(angle + PI);
                two.mult(10 * percentS);
            }
            else if (keys[3])
            {
                two = PVector.fromAngle(angle);
                two.mult(10 * percentS);
            }
            
            if (!keys[0] && !keys[1] && !keys[2] && !keys[3])
            {
                accel = new PVector(vel.x, vel.y);
                accel.mult(-slow);
            }
            else
            {
                PVector a = PVector.add(one, two);
                a.setMag(maxAccel);
                accel = new PVector(a.x, a.y);
            }
            
        }
        else
        {
            alf.update(this);
        }

        if (health < 0)
            return false;

        return true;
    }

    void setControl(boolean c)
    {
        inControl = c;
    }
    
    void setAITargets(ArrayList<PC> targ)
    {
        alf.setTargets(targ);
    }
    
    void setAIInfo(HashMap<String,Integer> info)
    {
        alf.setInfo(info);
    }
    
    void setAI(AI a)
    {
        alf = a;
    }

    void setCollision(Collision c)
    {
        this.col = c;
    }

    void setImage(PGraphics i)
    {
        img = i;
    }

    void setHealth(int h)
    {
        health = h;
    }
    
    void setProjMax(int h)
    {
        projMax = h;
    }
    
    void setRotThresh(float f)
    {
        rotThresh = f;
    }
    
    float getRotThresh()
    {
        return rotThresh;
    }
    
    void setPercentF(float f)
    {
        percentF = f;
    }
    
    void setPercentB(float f)
    {
        percentB = f;
    }
    
    void setPercentS(float f)
    {
        percentS = f;
    }
    
    void setSlow(float f)
    {
        slow = f;
    }
    
}

PC parsePC(String fileName)
{
    String[] lines = loadStrings(fileName);
    PC returnP = new PC(null, null, null);
    returnP.initBase();
    
    HashMap<String,Integer> aiInfo = new HashMap<String,Integer>();

    for (int i = 0; i < lines.length; i++)
    {
        //Check if a collection
        if (lines[i].length() > 0 && lines[i].charAt(0) == ':')
        {
            if (lines[i].equals(":collision:"))
            {
                int j = i+1;
                Collision tempCol;
                ArrayList<Shape> tempShapes = new ArrayList<Shape>();
                PVector tempCenter = new PVector(0, 0);

                while (lines[j].charAt (0) != ':')
                {
                    String ln[] = split(lines[j], "=");
                    String line = trim(ln[0]);
                    String data[] = split(ln[1], ",");
                    for (String s : data)
                        s = trim(s);

                    if (line.equals("Rect1"))
                    {
                        Rect r = new Rect(
                            new PVector(
                                float(trim(data[0])), 
                                float(trim(data[1])) ), 
                            new PVector(
                                float(trim(data[2])), 
                                float(trim(data[3])) ), 
                            new PVector(
                                float(trim(data[4])), 
                                float(trim(data[5])) ), 
                            new PVector(
                                float(trim(data[6])), 
                                float(trim(data[7])) ));

                        tempShapes.add(r);
                    }
                    else if (line.equals("Rect2"))
                    {
                        Rect r = new Rect(
                            new PVector(
                                float(trim(data[0])), 
                                float(trim(data[1])) ), 
                            new PVector(
                                float(trim(data[2])), 
                                float(trim(data[3])) ));

                        tempShapes.add(r);
                    }
                    else if (line.equals("Circ"))
                    {
                        Circ c = new Circ(
                            new PVector(
                                float(trim(data[0])), 
                                float(trim(data[1])) ), 
                                float(trim(data[2])) );
                        tempShapes.add(c);
                    }
                    else if (line.equals("Center"))
                    {
                        tempCenter.x = float(trim(data[0]));
                        tempCenter.y = float(trim(data[1]));
                    }
                    else if (line.equals("ct"))
                    {
                        Rect r = (Rect)tempShapes.get(tempShapes.size()-1);
                        r.ct = new PVector(
                            float(trim(data[0])), 
                            float(trim(data[1])) );
                    }
                    
                    j++;
                }

                tempCol = new Collision(tempShapes, tempCenter);
                returnP.setCollision(tempCol);

                i = j+1;
            }
        }
        //Check if not comment or blank
        else if (lines[i].length() != 0 && lines[i].charAt(0) != '#')
        {
            String ln[] = split(lines[i], "=");
            String line = trim(ln[0]);
            String data[] = split(ln[1], ",");
            for (String s : data)
                s = trim(s);

            if (line.equals("pos"))
                returnP.pos = new PVector(
                float(trim(data[0])), 
                float(trim(data[1])));
            else if (line.equals("vel"))
                returnP.vel = new PVector(
                float(trim(data[0])), 
                float(trim(data[1])));
            else if (line.equals("accel"))
                returnP.accel = new PVector(
                float(trim(data[0])), 
                float(trim(data[1])));
            else if (line.equals("maxVel"))
                returnP.maxVel = float(trim(data[0]));
            else if (line.equals("maxAccel"))
                returnP.maxAccel = float(trim(data[0]));
            else if (line.equals("maxRot"))
                returnP.maxRot = float(trim(data[0]));
            else if (line.equals("health"))
                returnP.setHealth( int(trim(data[0])) );
            else if (line.equals("projMax"))
                returnP.setProjMax( int(trim(data[0])) );
            else if (line.equals("percentF"))
                returnP.setPercentF(float(trim(data[0])) );
            else if (line.equals("percentB"))
                returnP.setPercentB(float(trim(data[0])) );
            else if (line.equals("percentS"))
                returnP.setPercentS(float(trim(data[0])) );
            else if (line.equals("slow"))
                returnP.setSlow(float(trim(data[0])) );
            else if (line.equals("rotThresh"))
                returnP.setRotThresh(float(trim(data[0])) );
            else if (line.equals("AI.aggro"))
                aiInfo.put( "aggro", int(trim(data[0])) );
            else if (line.equals("AI.attack"))
                aiInfo.put( "attack", int(trim(data[0])) );
            else if (line.equals("AI.close"))
                aiInfo.put( "close", int(trim(data[0])) );
            
        }
    }
    
    returnP.setAIInfo(aiInfo);

    return returnP;
}



class Proj extends Entity
{
    //Vars
    public PC originator;
    public ArrayList<PC> targetList;
    
    private int damage;
    private boolean dead;
    
    Proj (PVector pos, PGraphics img, Collision c, PC originator)
    {
        initBase();
        
        this.pos = pos;
        this.img = img;
        this.col = c;
        this.originator = originator;
        
        damage = 1;
        dead = false;
    }
    
    boolean update(float delta)
    {
        updateKin(delta);
        
        if (targetList != null)
        {
            for (PC p : targetList)
            {
                if (p.collide(this))
                {
                    p.health -= damage;
                    originator.projCount--;
                    
                    dead = true;
                    return !dead;
                }
            }
        }
        
        return !dead;
    }
    
    void setDamage(int d)
    {
        damage = d;
    }
    
    void setCollision(Collision c)
    {
        this.col = c;
    }

    void setImage(PGraphics i)
    {
        img = i;
    }
    
}


Proj parseProj(String fileName)
{
    String[] lines = loadStrings(fileName);
    Proj returnP = new Proj(null, null, null, null);
    returnP.initBase();

    for (int i = 0; i < lines.length; i++)
    {
        //Check if a collection
        if (lines[i].length() > 0 && lines[i].charAt(0) == ':')
        {
            if (lines[i].equals(":collision:"))
            {
                int j = i+1;
                Collision tempCol;
                ArrayList<Shape> tempShapes = new ArrayList<Shape>();
                PVector tempCenter = new PVector(0, 0);

                while (lines[j].charAt (0) != ':')
                {
                    String ln[] = split(lines[j], "=");
                    String line = trim(ln[0]);
                    String data[] = split(ln[1], ",");
                    for (String s : data)
                        s = trim(s);

                    if (line.equals("Rect1"))
                    {
                        Rect r = new Rect(
                            new PVector(
                                float(trim(data[0])), 
                                float(trim(data[1])) ), 
                            new PVector(
                                float(trim(data[2])), 
                                float(trim(data[3])) ), 
                            new PVector(
                                float(trim(data[4])), 
                                float(trim(data[5])) ), 
                            new PVector(
                                float(trim(data[6])), 
                                float(trim(data[7])) ));

                        tempShapes.add(r);
                    }
                    else if (line.equals("Rect2"))
                    {
                        Rect r = new Rect(
                            new PVector(
                                float(trim(data[0])), 
                                float(trim(data[1])) ), 
                            new PVector(
                                float(trim(data[2])), 
                                float(trim(data[3])) ));

                        tempShapes.add(r);
                    }
                    else if (line.equals("Circ"))
                    {
                        Circ c = new Circ(
                            new PVector(
                                float(trim(data[0])), 
                                float(trim(data[1])) ), 
                                float(trim(data[2])) );
                        tempShapes.add(c);
                    }
                    else if (line.equals("Center"))
                    {
                        tempCenter.x = float(trim(data[0]));
                        tempCenter.y = float(trim(data[1]));
                    }
                    else if (line.equals("ct"))
                    {
                        Rect r = (Rect)tempShapes.get(tempShapes.size()-1);
                        r.ct = new PVector(
                            float(trim(data[0])), 
                            float(trim(data[1])) );
                    }
                    
                    j++;
                }

                tempCol = new Collision(tempShapes, tempCenter);
                returnP.setCollision(tempCol);

                i = j+1;
            }
        }
        //Check if not comment or blank
        else if (lines[i].length() != 0 && lines[i].charAt(0) != '#')
        {
            String ln[] = split(lines[i], "=");
            String line = trim(ln[0]);
            String data[] = split(ln[1], ",");
            for (String s : data)
                s = trim(s);

            if (line.equals("pos"))
                returnP.pos = new PVector(
                float(trim(data[0])), 
                float(trim(data[1])));
            else if (line.equals("vel"))
                returnP.vel = new PVector(
                float(trim(data[0])), 
                float(trim(data[1])));
            else if (line.equals("accel"))
                returnP.accel = new PVector(
                float(trim(data[0])), 
                float(trim(data[1])));
            else if (line.equals("maxVel"))
                returnP.maxVel = float(trim(data[0]));
            else if (line.equals("maxAccel"))
                returnP.maxAccel = float(trim(data[0]));
            else if (line.equals("maxRot"))
                returnP.maxRot = float(trim(data[0]));
            else if (line.equals("damage"))
                returnP.setDamage(int(trim(data[0])) );
            
        }
    }

    return returnP;
}