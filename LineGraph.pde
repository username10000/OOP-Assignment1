// Class that renders and checks for the input of the user for the line graph (BETWEEN 1957 - 2014 button)
class LineGraph extends Graph
{
  int minFreq, maxFreq;
  int dif, difFreq;
  
  LineGraph(int minYear, int maxYear, int minFreq, int maxFreq, int difFreq)
  {
    super(minYear, maxYear);
    this.minFreq = minFreq;
    this.maxFreq = maxFreq;
    this.difFreq = difFreq;
  }
  LineGraph()
  {
    this(1957, 2014, 0, 130, 10);
    dif = 3;
  }
  
  // Draw the vertical axis of the line graph
  private void drawVertAxis(int minVert, int maxVert, int dif)
  {  
    for (int i = minVert; i <= maxVert; i += dif)
    {
      // Find the position of the current frequency
      float y = map(i, minVert, maxVert, height - border.get("Bottom"), border.get("Top"));
  
      // Draw the gradations
      line(border.get("Left"), y, width - border.get("Right"), y); 
  
      // Write the frequency
      text(i, border.get("Left") - 20, y);
    }
  }
  
  // Draw the horizontal axis of the line graph
  private void drawHorzAxis(int minHorz, int maxHorz, int dif)
  {
    // Draw the main horizontal line
    line(border.get("Left"), height - border.get("Bottom"), width - border.get("Right"), height - border.get("Bottom"));
  
    for (int i = minHorz; i <= maxHorz; i += dif)
    {
      // Find the position of the current year
      float x = map(i, minHorz, maxHorz, border.get("Left"), width - border.get("Right"));
  
      // Draw the gradations
      line(x, height - border.get("Bottom"), x, height - border.get("Bottom") + 5);
  
      // Write the current year
      String ye = Integer.toString(i);
      ye = "'" + ye.substring(2, 4);
      text(ye, x, height - border.get("Bottom") + 20);
    }
  }
  
  // Draw the line graph
  private void trendGraph(int minVert, int maxVert, int difVert, int minHorz, int maxHorz, String name)
  {
    PVector pos = new PVector(0.0f, 0.0f);
  
    // Start the line graph shape and put a vertex at the origin point
    beginShape();
    vertex(border.get("Left"), height - border.get("Bottom"));
    
    for (int i = minHorz - firstYear; i <= maxHorz - firstYear; i++)
    {
      // Get the current year and the frequency
      int curYear = i + firstYear;
      int count = freqA.get(i);
      
      // Get the frequency of the current year for a specific country
      if (!name.equals("All"))
      {
        count = frequencyEachYear(spaceLaunches, curYear, name);
      }
  
      // Map the current year and frequency to the size of the screen
      pos.x = map(curYear, minHorz, maxHorz, border.get("Left"), width - border.get("Right"));
      pos.y = map(count, minVert, maxVert, height - border.get("Bottom"), border.get("Top"));
  
      // Create the vertex with the coordinates
      vertex(pos.x, pos.y);
    }
 
    // Put a vertex at the end of the graph and end the shape
    vertex(width - border.get("Right"), height - border.get("Bottom"));
    endShape(CLOSE);
  }
  
  // Draw the line graph and all the necessary parts needed
  public void drawGraph()
  {
    // Change the difference between the year gradations based on the number of years shown
    dif = round(map((maxYear - minYear + 1), 2014 - 1957 + 1, 1, 3, 1));
  
    // Reset the screen and the text and stroke colour
    background(bgColour);
    stroke(0);
    fill(0);
    
    // Title
    textSize(20);
    text("Space Launches " + minYear + " - " + maxYear, width / 2, border.get("Top") / 2);
  
    // Change the text size
    textSize(12);
  
    // Make the bottom border bigger to make space for the buttons
    border.put("Bottom", (int)map(20, 0, 100, 0, height));
  
    // Draw the axis
    drawVertAxis(minFreq, maxFreq + 1, 10);
    drawHorzAxis(minYear, maxYear, dif);
  
    // Remove the stroke and change the colour of the graph's fill
    noStroke();
    fill(44, 62, 80);
  
    // Draw the actual graph
    trendGraph(minFreq, maxFreq, 1, minYear, maxYear, "All");
    
    // Check if the toggle for Russia is on
    if (controlP5.getController("Russia").getValue() == 1.0)
    {
      fill(255, 0, 0);
      trendGraph(minFreq, maxFreq, 1, minYear, maxYear, "CIS");
    }
    
    // Check if the toggle for USA is on
    if (controlP5.getController("USA").getValue() == 1.0)
    {
      fill(0, 0, 255, 150);
      trendGraph(minFreq, maxFreq, 1, minYear, maxYear, "US");
    }
  }
}
