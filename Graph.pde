// Superclass of all the graph classes
class Graph
{
  int minYear, maxYear;
  boolean isVisible;
  
  Graph(int minYear, int maxYear)
  {
    this.minYear = minYear;
    this.maxYear = maxYear;
    isVisible = false;
  }
  Graph()
  {
    this.minYear = 1957;
    this.maxYear = 2014;
    isVisible = false;
  }
  
  public void drawGraph()
  {
    println("Draw Graph");
  }
  
  public void checkGraph()
  {
    println("Check Graph");
  }
}
