class BarGraph extends Graph
{
  int minFreq, maxFreq;
  int gap, dif;
  int selectedBar;
  PVector pos;
  float w, h;
   
  BarGraph(int minYear, int maxYear, int gap, int dif)
  {
    super(minYear, maxYear);
    this.gap = gap;
    this.dif = dif;
    pos = new PVector(0.0f, 0.0f);
    selectedBar = -1;
  }
  BarGraph()
  {
    this(1957, 2014, 50, 100);
  }
  
  // Calculate the total space launches in a month
  private int totalPerMonth(int month)
  {
    int count = 0;
    
    for (int i = 1 ; i < spaceLaunches.size() ; i++)
    {
      if (Integer.parseInt(spaceLaunches.get(i).date.substring(5,7)) == month)
        count++;
    }
    
    return count;
  }
  
  // Find the maximum space launches in a month
  private int maxPerMonth()
  {
    int maxLaunch = 0;
    for (int i = 1 ; i <= 12 ; i++)
    {
      int month = totalPerMonth(i);
      if (month > maxLaunch)
      {
        maxLaunch = month;
      }
    }
    return maxLaunch;
  }

  // Draw the lines to indicate the frequency
  private void drawBarChartLines()
  {
    // Change the colour of the lines
    stroke(254);
    
    // Change the colour of the text
    fill(0);
    
    // Draw the lines and print the text
    for(int i = 0 ; i < maxFreq ; i+= dif)
    {
      // Get the coordinates for the line
      pos.y = map(i, minFreq, maxFreq, height - border.get("Bottom"), border.get("Top"));
      
      // Draw the line
      line(border.get("Left"), pos.y, width - border.get("Right"), pos.y);
      
      // Write the frequency for each line
      text(i, border.get("Left") - 30, pos.y);
    }
  }

  public void drawGraph()
  {
    String[] month = {"January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"};
    PVector tempPos = new PVector(0.0f, 0.0f);
    int tempI = 0;
    minFreq = 0;
    maxFreq = maxPerMonth();
    
    // Reset the screen
    background(bgColour);

    // Title
    textSize(20);
    text("Total Space Launches per Month", width / 2, border.get("Top") / 2);
    
    // Set the text size
    textSize(12);
  
    for (int i = 0 ; i < month.length ; i++)
    {
      // Get the coordinates for the bar
      w = ( (float)width / (float)month.length ) - gap;
      pos.x = map(i + 1, 1, month.length, border.get("Left"), width - border.get("Right") - w);
      pos.y = map(totalPerMonth(i + 1), minFreq, maxFreq, height - border.get("Bottom"), border.get("Top"));
      h = height - border.get("Bottom") - pos.y;
      
      // Change the fill of the bars
      if (selectedBar == i)
      {
        fill(231, 76, 60);
        tempPos.x = pos.x;
        tempPos.y = pos.y;
        tempI = i;
      }
      else
      {
        fill(44, 62, 80);
      }
      
      // Draw the bar
      rect(pos.x, pos.y, w, h);
      
      // Write the month representing each bar
      fill(0);
      text(month[i], pos.x + (w / 2), height - border.get("Bottom") + 20);
    }  
    
    // Draw the lines to indicate the frequency
    drawBarChartLines();
    
    // If there is a selected bar display the total value of the launches in that month
    if (selectedBar != -1)
    {
      text(totalPerMonth(tempI + 1), tempPos.x + w / 2, tempPos.y - 20);
    }
  }
  
  public void checkGraph()
  {
    if ((mouseY < height - border.get("Bottom")) && (mouseY > border.get("Top")) && (mouseX > border.get("Left")) && (mouseX < width - border.get("Right")))
    {
      if (get(mouseX, mouseY) != color(bgColour))
        selectedBar = (int)(map(mouseX, border.get("Left"), width - border.get("Right") - w, 1, 12) + 0.1f) - 1;
      else
        selectedBar = -1;
    }
    else
    {
      selectedBar = -1;
    }
    drawGraph();
  }
}
