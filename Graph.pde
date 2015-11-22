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
}
