class PieChart extends Graph
{
  PVector pos;
  float radius;
  int selectedSegment;
  color[] colour = new color[countries.size()];
  int[] freqC = new int[countries.size()];
  int totalFreq;
  int animate = 0;
  
  PieChart(int minYear, int maxYear)
  {
    super(minYear, maxYear);
    this.pos = new PVector(width / 2, height / 2);
    radius = 200;
    selectedSegment = -1;
    
    // Put the frequency from 2014 for each country in an array
    for (int i = 0 ; i < countries.size() ; i++)
    {
      colour[i] = color(random(0, 255), random(0, 255), random(0, 255));
      freqC[i] = frequencyBetweenYears(2014, 2014, countries.get(i).code);
    }
    
    // Get the total number of launches in 2014
    totalFreq = maxFrequencyBetweenYears(2014, 2014);
  }
  PieChart()
  {
    this(1957, 2014);
  }
  
  private int frequencyBetweenYears(int first, int last, String name)
  {
    // Find the frequency of a country between some years
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
    // Find the total frequency between some years
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

        // Change the filling colour of the current segment
        fill(colour[i]);
        
        if (selectedSegment != i)
        {
          // Display the segment
          arc(pos.x, pos.y, radius * 2, radius * 2, angle1, angle2, PIE);
        }
        else
        {
          // If the segment is selected increase the radius of the arc and animate the text
          arc(pos.x, pos.y, radius * 2 + 50, radius * 2 + 50, angle1, angle2, PIE);
          
          // Change the text size and colour
          textSize(15);
          fill(0);
          
          // Animate the text
          if (animate > 0)
          {
            animate ++;
            text(countries.get(i).name + " - " + freqC[i] + " launch(es)", width / 2, height - map(animate, 0, 20, 0, border.get("Bottom") / 2));
            if (animate == 20)
            {
              animate = -1;
            }
          }
          else
          {
            text(countries.get(i).name + " - " + freqC[i] + " launch(es)", width / 2, height - border.get("Bottom") / 2);
          }
        }

        // Store the previous angle
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
      // Start the animation
      if (animate == 0)
        animate = 1;
        
      // Find the angle where the mouse is currently at
      curAngle = atan2(mouseY - height / 2, mouseX - width / 2);
      
      // Change the angle if it's negative otherwise it gives wrong values
      if (curAngle < 0)
      {
        curAngle = map(curAngle, -PI, 0, PI, TWO_PI);
      }
      
      // Increase the angle of the circle so it matches the segment where the mouse is
      curAngle += 4 * PI / 2;
      
      for (i = 0; i < countries.size(); i++)
      {
        int freqCountry = freqC[i];
        
        if (freqCountry > 0)
        {
          angle1 += (TWO_PI * freqCountry) / totalFreq;
 
          if (curAngle < angle1)
          {
            // Start the animation if the last selected segment is different the the current selected segment
            if (i != selectedSegment)
              animate = 1;
            selectedSegment = i;
            break;
          }
        }
      }
      if (i == countries.size())
      {
        // Start the animation if the last selected segment is different the the current selected segment
        if (selectedSegment != 0)
            animate = 1;
        selectedSegment = 0;
      }
    }
    else
    {
      // If the mouse is not pie chart then reset the selected segment and the animate variables
      selectedSegment = -1;
      animate = 0;
    }
  }
}
