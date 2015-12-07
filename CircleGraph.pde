// Class that renders and checks for the input of the user for the circe graph (EACH DAY button)
class CircleGraph extends Graph
{
  float radius, smallRadius;
  float angle;
  PVector pos;
  int[] totalDay = new int[32];
  int maxFreq;
  
  CircleGraph(int minYear, int maxYear)
  {
    super(minYear, maxYear);
    angle = TWO_PI / 31;
    radius = ( height - border.get("Bottom") - border.get("Top") ) / 2;
    smallRadius = map(40, 0, 100, 0, radius);
    pos = new PVector(0.0f, 0.0f);
    for (int i = 1 ; i <= 31 ; i++)
    {
      totalDay[i] = totalDayYear(i);
    }
    maxFreq = maxPerDay();
  }
  CircleGraph()
  {
    this(1957, 2014);
  }
  
  private int totalDayYear(int day)
  {
    int count = 0;
    
    for (int i = 1 ; i < spaceLaunches.size() ; i++)
    {
      if (Integer.parseInt(spaceLaunches.get(i).date.substring(8,10)) == day)
        count++;
    }
    
    return count;
  }
  
  private int maxPerDay()
  {
    int maxLaunch = 0;
    for (int i = 1 ; i <= 31 ; i++)
    {
      int day = totalDay[i];
      if (day > maxLaunch)
      {
        maxLaunch = day;
      }
    }
    return maxLaunch;
  }
    
  public void drawGraph()
  {
    int dayFreq;
    float sizeFreq;
    
    // Reset the background
    background(bgColour);
    
    // Title
    textSize(20);
    text("Total Space Launches per Day", width / 2, border.get("Top") / 3);
    
    // Change the text size
    textSize(12);

    for (int i = 1 ; i <= 31 ; i++)
    {
      // Draw the outline
      stroke(0);
      fill(bgColour);
      beginShape();
      
      pos.x = width / 2 + sin(angle * (i - 1)) * radius;
      pos.y = height / 2 - cos(angle * (i - 1)) * radius;
      vertex(pos.x, pos.y);
      
      pos.x = width / 2 + sin(angle * i) * radius;
      pos.y = height / 2 - cos(angle * i) * radius;
      vertex(pos.x, pos.y);
      
      pos.x = width / 2 + sin(angle * i) * smallRadius;
      pos.y = height / 2 - cos(angle * i) * smallRadius;
      vertex(pos.x, pos.y);
      
      pos.x = width / 2 + sin(angle * (i - 1)) * smallRadius;
      pos.y = height / 2 - cos(angle * (i - 1)) * smallRadius;
      vertex(pos.x, pos.y);   
      
      endShape(CLOSE);
      
      
      // Calculate the total frequency on the current day
      dayFreq = totalDay[i];
      
      // Draw the filling for each part
      //fill(random(0, 255), random(0, 255), random(0, 255));
      fill(circleColour[i - 1]);
      noStroke();
      
      beginShape();
      
      pos.x = width / 2 + sin(angle * (i - 1)) * radius;
      pos.y = height / 2 - cos(angle * (i - 1)) * radius;
      vertex(pos.x, pos.y);
      
      pos.x = width / 2 + sin(angle * i) * radius;
      pos.y = height / 2 - cos(angle * i) * radius;
      vertex(pos.x, pos.y);
      
      sizeFreq = map(dayFreq, 0, maxFreq, radius, smallRadius);
      pos.x = width / 2 + sin(angle * i) * sizeFreq;
      pos.y = height / 2 - cos(angle * i) * sizeFreq;
      vertex(pos.x, pos.y);
      
      pos.x = width / 2 + sin(angle * (i - 1)) * sizeFreq;
      pos.y = height / 2 - cos(angle * (i - 1)) * sizeFreq;
      vertex(pos.x, pos.y);    
      
      endShape(CLOSE);
      
      
      // Print the day for each part
      pos.x = width / 2 + sin(angle * i - angle / 2) * (radius + 20);
      pos.y = height / 2 - cos(angle * i - angle / 2) * (radius + 20);
      fill(0);
      text(i, pos.x, pos.y);
    }
  }
  
  public void checkGraph()
  {
    float curAngle;
    int dayFreq;
    int day;
    
    // Reset the graph
    drawGraph();
    
    // Check if the mouse is in the circle
    if ( ( dist(mouseX, mouseY, width / 2, height / 2) < radius ) && ( dist(mouseX, mouseY, width / 2, height / 2) > smallRadius ) )
    {
      // Find the angle where the mouse is currently at
      curAngle = atan2(mouseY - height / 2, mouseX - width / 2);
      
      // Change the angle if it's negative otherwise it gives wrong values
      if (curAngle < 0)
      {
        curAngle = map(curAngle, -PI, 0, PI, TWO_PI);
      }
      
      // Increase the angle a quarter of a circle so it matches the segment where the mouse is
      curAngle += HALF_PI;
      
      // Increment the day by one for the correct segment
      day = (int) map(curAngle, 0, TWO_PI, 0, 31) + 1;
      
      // Keep the day between 1 and 31
      if (day > 31)
        day -= 31;
      
      // Draw only the lines arround the segment to look like it's selected
      noFill();
      strokeWeight(3);
      stroke(255, 0, 0);
      
      beginShape();
      
      pos.x = width / 2 + sin(angle * (day - 1)) * radius;
      pos.y = height / 2 - cos(angle * (day - 1)) * radius;
      vertex(pos.x, pos.y);
      
      pos.x = width / 2 + sin(angle * day) * radius;
      pos.y = height / 2 - cos(angle * day) * radius;
      vertex(pos.x, pos.y);
      
      pos.x = width / 2 + sin(angle * day) * smallRadius;
      pos.y = height / 2 - cos(angle * day) * smallRadius;
      vertex(pos.x, pos.y);
      
      pos.x = width / 2 + sin(angle * (day - 1)) * smallRadius;
      pos.y = height / 2 - cos(angle * (day - 1)) * smallRadius;
      vertex(pos.x, pos.y);   
      
      endShape(CLOSE);
      
      // Calculate the total frequency on the current day
      dayFreq = totalDay[day];
      text("Total Launches: " + dayFreq + "\nAverage Launches: " + nf(((float)dayFreq / (lastYear - firstYear + 1)), 1, 3), width / 2, height / 2);
    }
  }
}
