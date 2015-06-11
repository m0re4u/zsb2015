// as found on http://stackoverflow.com/questions/10290649/tree-of-nodet-explaination

public class Node<String> 
{
    private Node<String > root; // a T type variable to store the root of the list
    private Node<String> parent; // a T type variable to store the parent of the list
    private String child;
    private List<Node<String>> children = new ArrayList<Node<String>>(); // a T type list to store the children of the list

    // default constructor
    public Node(T child)
    {
        setParent(null);
        setRoot(null);
        setItem(child);
    }

    // constructor overloading to set the parent
    public Node(Node<T> parent)
    {
        this.setParent(parent);
        //this.addChild(parent);
    }

    // constructor overloading to set the parent of the list  
    public Node(Node<T> parent, Node<T> child)
    {
        this(parent);
        this.children.add(child);
    }

    /**
    * This method doesn't return anything and takes a parameter of 
    * the object type you are trying to store in the node 
    * 
    * @param  Obj  an object
    * @param 
    **/
    public void addChild(Node<T> child)
    {
        child.root = null;
        child.setParent((Node<T>)this);
        this.children.add(child); // add this child to the list
    }

    public void removeChild(Node<T> child)
    {
        this.children.remove(child); // remove this child from the list
    }

    public Node<T> getRoot() {
        return root;
    }

    public boolean isRoot()
    {
        // check to see if the root is null if yes then return true else return false
        return this.root != null;     
    }

    public void setRoot(Node<T> root) {
        this.root = root;
    }

    public Node<T> getParent() {
        return parent;
    }

    public void setParent(Node<T> parent) {
        this.parent = parent;
    }

    public T getItem() {
        return child;
    }

    public void setItem(T child) {
        this.child = child;
    }

    public boolean hasChildren()
    {
        return this.children.size()>0;
    }

    @SuppressWarnings("unchecked")
    public Node<T>[] children()
    {
        return (Node<T>[]) children.toArray(new Node[children.size()]);
    }

    @SuppressWarnings({ "unchecked"})
    public Node<T>[] getSiblings()
    {
        if(this.isRoot()!=false && parent==null)
        {
            System.out.println("this is root or there are no siblings");
            return null;
        }
        else{
            List<Node<T>> siblings = new ArrayList<Node<T>>((Collection<? extends Node<T>>) Arrays.asList(new Node[this.parent.children.size()]));  
            Collections.copy(siblings, this.parent.children);  
            siblings.remove(this);
            return siblings.toArray(new Node[siblings.size()]);
        }
    }
}
