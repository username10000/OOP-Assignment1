class PieChart extends Graph
{
  PVector pos;
  float radius;
  int selectedSegment;
  color[] colour = new color[countries.size()];
  int[] freqC = new int[countries.size()];
  int totalFreq;
  
  PieChart(int minYear, int maxYear)
  {
    super(minYear, maxYear);
    this.pos = new PVector(width / 2, height / 2);
    radius = 200;
    selectedSegment = -1;
    for (int i = 0 ; i < countries.size() ; i++)
    {
      colour[i] = color(random(0, 255), random(0, 255), random(0, 255));
      freqC[i] = frequencyBetweenYears(2014, 2014, countries.get(i).code);
      totalFreq = maxFrequencyBetweenYears(2014, 2014);
    }
  }
  PieChart()
  {
    this(1957, 2014);
  }
  
  private int frequencyByCountry(String name)
  {
    int count = 0;

    for (int i = 1 ; i < spaceLaunches.size() ; i++)
    { 
      // Check if it's the wanted year
      if (spaceLaunches.get(i).country.equals(name))
      {
        count ++;
      }
    }
    return count;
  }
  
  private int frequencyBetweenYears(int first, int last, String name)
  {
    int count = 0;

    for (int i = 1; i < spaceLaunches.size (); i++)
    {
      // Get current year  
      int curYear = Integer.parseInt(spaceLaunches.get(i).id.substring(0, 4));
  
      // Check if it's the wanted year
      if ( (curYear >= first) && (curYear <= last) && (spaceLaunches.get(i).country.equals(name)) )
      {
        count ++;
      }
    }
    return count;
  }
  
  private int maxFrequencyBetweenYears(int first, int last)
  {
    int maxFreq = 0;
    for (int i = 0 ; i < countries.size() ; i++)
    {
      maxFreq += frequencyBetweenYears(first, last, countries.get(i).code);
    }
    return maxFreq;
  }
  
  public void drawGraph()
  {
    float angle1 = 3 * PI / 2;
    float angle2 = 3 * PI / 2;

    background(bgColour);
    
    // Title
    textSize(20);
    text("Launches in 2014 by Country", width / 2, border.get("Top") / 2);
    
    for (int i = 0; i < countries.size(); i++)
    {
      int freqCountry = freqC[i];
      
      if (freqCountry > 0)
      {
        angle2 += (TWO_PI * freqCountry) / totalFreq;

        fill(colour[i]);
        
        if (selectedSegment != i)
        {
          arc(pos.x, pos.y, radius * 2, radius * 2, angle1, angle2, PIE);
        }
        else
        {
          arc(pos.x, pos.y, radius * 2 + 50, radius * 2 + 50, angle1, angle2, PIE);
          
          textSize(12);
          fill(0);
          text(countries.get(i).name + " - " + freqC[i] + " launch(es)", width / 2, height - border.get("Bottom") / 2);
        }

        angle1 = angle2;
      }
    }
  }
  
  public void checkGraph()
  {
    float curAngle;
    float angle1 = 3 * PI / 2;
    int i;
    
    // Reset the graph
    drawGraph();
    
    // Check if the mouse is in the circle
    if (dist(mouseX, mouseY, width / 2, height / 2) < radius)
    {
      
      // Find the angle where the mouse is currently at
      curAngle = atan2(mouseY - height / 2, mouseX - width / 2);
      
      // Change the angle if it's negative otherwise it gives wrong values
      if (curAngle < 0)
      {
        curAngle = map(curAngle, -PI, 0, PI, TWO_PI);
      }
      
      // Increase the angle a quarter of a circle so it matches the segment where the mouse is
      curAngle += 4 * PI / 2;
      
      for (i = 0; i < countries.size(); i++)
      {
        int freqCountry = freqC[i];
        
        if (freqCountry > 0)
        {
          angle1 += (TWO_PI * freqCountry) / totalFreq;
 
          if (curAngle < angle1)
          {
            selectedSegment = i;
            break;
          }
        }
      }
      if (i == countries.size())
      {
        selectedSegment = 0;
      }
    }
    else
    {
      selectedSegment = -1;
    }
  }
}
