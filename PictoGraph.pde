class PictoGraph extends Graph
{
  PVector pos;
  int yearPos;
  int h;
  int halfH ;
  int w;;
  int halfW;
  int posCol;
  int selectedRocket = -1;
  
  PictoGraph(int minYear, int maxYear)
  {
    super(minYear, maxYear);
    this.pos = new PVector(width / 2, height / 2);
    yearPos = 0;
    h = 120;
    halfH = h / 2;
    w = h / 10;
    halfW = w / 2;
    posCol = 0;
  }
  PictoGraph()
  {
    this(1957, 2014);
  }
  
  private int getYearIndex(int year)
  {
    for (int i = 1 ; i < spaceLaunches.size() ; i++)
    {
      if (Integer.parseInt(spaceLaunches.get(i).id.substring(0, 4)) == year)
        return i;
    }
    return 0;
  }
  
  public void drawGraph()
  {
    background(bgColour);

    
    // Title
    textSize(20);
    text("Launches in " + (yearPos + firstYear), width / 2, border.get("Top") / 2);
    
    for (int i = 0 ; i < freqA.get(yearPos) ; i++)
    {
      // Get the line position of the shape
      int posLine = i % 44;
      
      // Change the colour of the stroke and fill
      stroke(254);
      if (i == selectedRocket)
      {
        // Display info about the current rocket
        int index = getYearIndex(yearPos + firstYear) + i;
        String lv = spaceLaunches.get(index).launchVehicle;
        String pl = spaceLaunches.get(index).payload;
        
        if (lv.length() > 25)
          lv = lv.substring(0, 20);
        if (pl.length() > 25)
          pl = pl.substring(0, 20);
        
        textSize(15);
        fill(0);
        text("Launch Vehicle: " + lv + ", Payload: " + pl + ", Date: " + spaceLaunches.get(index).date, width / 2, height - border.get("Bottom") / 2);
        fill(231, 76, 60);
      }
      else
      {
        fill(0);
      }
      
      // Get the column position of the shape
      if ((i != 0) && (posLine == 0))
      {
        posCol ++;
      }
      
      // Calculate the coordinates for the shape
      pos.x = map(posLine, 0, 43, border.get("Left"), width - border.get("Right"));
      pos.y = map((int)(i / 44), 0, 3, height - border.get("Bottom") - halfH, border.get("Top") - halfH);
      
      // Draw the shape
      beginShape();
         vertex(pos.x + halfW, pos.y + halfH);
         vertex(pos.x - halfW, pos.y + halfH);
         vertex(pos.x - halfW, pos.y + halfH);
         vertex(pos.x - halfW, pos.y - halfH + halfH / 2 + halfH / 4);
         vertex(pos.x - halfW + halfW / 2, pos.y - halfH + halfH / 2 + halfH / 4 - halfH / 10);
         vertex(pos.x - halfW + halfW / 2, pos.y - halfH + halfH / 5);
         vertex(pos.x - halfW / 10, pos.y - halfH + halfH / 10);
         vertex(pos.x - halfW / 10, pos.y - halfH);
        
         vertex(pos.x + halfW / 10, pos.y - halfH);
         vertex(pos.x + halfW / 10, pos.y - halfH + halfH / 10);
         vertex(pos.x + halfW - halfW / 2, pos.y - halfH + halfH / 5);
         vertex(pos.x + halfW - halfW / 2, pos.y - halfH + halfH / 2 + halfH / 4 - halfH / 10);
         vertex(pos.x + halfW, pos.y - halfH + halfH / 2 + halfH / 4);
         vertex(pos.x + halfW, pos.y + halfH);
         vertex(pos.x + halfW, pos.y + halfH);
        
         vertex(pos.x + halfW - halfW / 10, pos.y + halfH);
         vertex(pos.x + halfW, pos.y + halfH + halfH / 10);
         vertex(pos.x, pos.y + halfH + halfH / 10);
         vertex(pos.x + halfW / 10, pos.y + halfH);
        
         vertex(pos.x - halfW + halfW / 10, pos.y + halfH);
         vertex(pos.x - halfW, pos.y + halfH + halfH / 10);
         vertex(pos.x, pos.y + halfH + halfH / 10);
         vertex(pos.x - halfW / 10, pos.y + halfH);
      endShape(CLOSE);
    }
  }
  
  public void checkGraph()
  {
    if ((mouseY < height - border.get("Bottom")) && (mouseY > border.get("Top")) && (mouseX > border.get("Left") - halfW) && (mouseX < width - border.get("Right") + halfW) && get(mouseX, mouseY) != color(255))
    {
      // Set the selected rocket if the curson is one a rocket
      float wIndex = map(border.get("Left") + halfW, border.get("Left") - halfW, width - border.get("Right") - halfW, 0, 43);
      float hIndex = map(height - border.get("Bottom") + h, height - border.get("Bottom"), border.get("Top"), 0, 3);
      pos.x = map(mouseX, border.get("Left") - halfW, width - border.get("Right") - halfW, 0, 43) + 0.1f;
      pos.y = map(mouseY, height - border.get("Bottom"), border.get("Top"), 0, 3) + 0.1f;
      
      // Redraw the graph with the selected rocket
      if (selectedRocket != ((int)pos.y * 44) + (int)pos.x)
      {
        selectedRocket = ((int)pos.y * 44) + (int)pos.x;
        drawGraph();
      }
    }
    else
    {
      // Unset the selected rocket if the cursor is not on a rocket
      if (selectedRocket != -1)
      {
        selectedRocket = -1;
        drawGraph();
      }
    }
  }
}
