class PieChart extends Graph
{
  PVector pos;
  float radius;
  PieChart(int minYear, int maxYear)
  {
    super(minYear, maxYear);
    this.pos = new PVector(width / 2, height / 2);
    radius = 200;
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
    float lx, ly;
    int totalFreq = maxFrequencyBetweenYears(2014, 2014);

    background(bgColour);
    for (int i = 0; i < countries.size(); i++)
    {
      int freqCountry = frequencyBetweenYears(2014, 2014, countries.get(i).code);
      
      if (freqCountry > 0)
      {
        angle2 += (TWO_PI * freqCountry) / totalFreq;
    
        fill(random(0, 255), random(0, 255), random(0, 255));
        arc(pos.x, pos.y, radius * 2, radius * 2, angle1, angle2, PIE);
        
        fill(255);
        lx = pos.x + sin( angle1 + ((angle2 - angle1) / 2) + PI / 2) * (radius + 20);
        ly = pos.y - cos( angle1 + ((angle2 - angle1) / 2) + PI / 2) * (radius + 20);
        
        angle1 = angle2;
      }
    }
  }
}
