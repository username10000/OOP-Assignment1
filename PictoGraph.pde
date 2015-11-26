class PictoGraph extends Graph
{
  PVector pos;
  int yearPos;
  
  PictoGraph(int minYear, int maxYear)
  {
    super(minYear, maxYear);
    this.pos = new PVector(width / 2, height / 2);
    yearPos = 0;
  }
  PictoGraph()
  {
    this(1957, 2014);
  }
  
  public void drawGraph()
  {
    background(bgColour);
    int h = 120;
    int halfH = h / 2;
    int w = h / 10;
    int halfW = w / 2;
    int posCol = 0;
    
    // Title
    textSize(20);
    text("Launches in " + (yearPos + firstYear), width / 2, border.get("Top") / 2);

    // Change the colour of the stroke and fill
    stroke(255);
    fill(0);
    
    // *** Hover the rocket (and change colour) to print the launch vehicle and payload of the rocket
    // *** Maybe a slideshow with the years - almost!
    for (int i = 0 ; i < freqA.get(yearPos) ; i++)
    {
      // Get the line position of the shape
      int posLine = i % 44;
      
      // Get the column position of the shape
      if ((i != 0) && (posLine == 0))
      {
        posCol ++;
      }
      
      // Calculate the coordinates for the shape
      pos.x = map(posLine, 0, 43, border.get("Left"), width - border.get("Right"));
      pos.y = map((int)(i / 44), 0, 3, height - border.get("Bottom") - halfH, border.get("Top"));
      //pos.y = height - border.get("Bottom") - halfH - h * posCol - 20 * posCol;
      
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
    
  }
}
