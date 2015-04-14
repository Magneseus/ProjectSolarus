/**
 * Small storage container for an integer, such that two classes can both
 * access the same value.
 * @author Matt
 *
 */
class IntBox
{
    int store;
    
    IntBox(int newStore)
    {
        store = newStore;
    }
    
    public void add(int x)
    {
        store += x;
    }
    
    public void sub(int x)
    {
        store -= x;
    }
}
