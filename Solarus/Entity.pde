
abstract class Entity
{
    private Collision col;
    private PVector pos, vel, accel;
    private float angle;
    
    public abstract boolean update();
    public abstract void render();
    
}
