import controlP5.*;


//boolean sketchFullScreen() { return true; }
ControlP5 controlP5;
boolean loading = false;
boolean menu = true;
color bgColor = color(255);
ArrayList<Data> spaceLaunches = new ArrayList<Data>();
ArrayList<PVector> freqA = new ArrayList<PVector>();
float border;
int minYear, maxYear, minFreq, maxFreq;

void readData(ArrayList<Data> spaceLaunches)
{
  String[] records = loadStrings("SpaceLaunches.csv");
  
  for (String s:records)
  {
    String[] temp = s.split(",");
    Data record = new Data(temp[0], temp[1], temp[2], temp[3], temp[4]);
    
    spaceLaunches.add(record);
  }
}

int frequencyEachYear(ArrayList<Data> spaceLaunches, int year)
{
  int count = 0;
  
  for (int i = 1 ; i < spaceLaunches.size() ; i++)
  {
   // Get current year  
   int curYear = Integer.parseInt(spaceLaunches.get(i).id.substring(0, 4));
   
   // Check if it's the wanted year
   if ( curYear == year )
   {
     count ++;
   }
   
   // If the current year is bigger than the wanted year then break
   if ( curYear > year )
   {
     break;
   }
  }
  
  return count;
}

void frequencyArray(ArrayList<Data> spaceLaunches, ArrayList<PVector> freqA)
{
  PVector f;
  
  for (int  i = minYear ; i <= maxYear ; i++)
  {
    f = new PVector(i, frequencyEachYear(spaceLaunches, i));
    freqA.add(f);
  }
}

int maxFrequency(ArrayList<Data> spaceLaunches)
{
  int count = 0;
  int index = 1;
  int firstYear = Integer.parseInt(spaceLaunches.get(1).id.substring(0, 4));
  
  for(int i = 1 ; i < spaceLaunches.size() ; i++)
  {
    // Get the frequency of the current year
    int freq = frequencyEachYear(spaceLaunches, (i-1) + firstYear);
    
    // Check if it's bigger than the max frequency
    if(freq > count)
    {
      count = freq;
      index = i;
    }
  }
  
  return count;
}

void trendGraph(ArrayList <Data> spaceLaunches, int minVert, int maxVert, int difVert, int minHorz, int maxHorz, int difHorz, float bor)
{
  float x2, y2;
  
  beginShape();
  vertex(bor, height - bor);
  
  for (int i = 1 ; i < spaceLaunches.size() ; i++)
  {
    int curYear = Integer.parseInt(spaceLaunches.get(i).id.substring(0, 4));
    int count = (int)freqA.get(curYear - minYear).y;
    
    x2 = map(curYear, minHorz, maxHorz, bor, width - bor);
    y2 = map(count, minVert, maxVert, height - bor, bor);
    
    vertex(x2, y2);
  }
  vertex(width - bor, height - bor);
  endShape(CLOSE);
}

void drawVertAxis(int minVert, int maxVert, int dif, float bor)
{
  textAlign(CENTER, CENTER);
  
  // Draw main vertical axis line
  //line(bor, bor, bor, height - bor);
  
  // Write the meaning of the vertical line
  text("Launches", bor, bor - 30);
  
  for (int i = minVert ; i <= maxVert ; i += dif)
  {
    // Find the position of the current frequency
    float y = map(i, minVert, maxVert, height - bor, bor);
    
    // Draw the gradations
    //line(bor, y, bor - 5, y);
    line(bor, y, width - bor, y); 
    
    // Write the frequency
    text(i, bor - 20, y);
  }
}

void drawHorzAxis(int minHorz, int maxHorz, int dif, float bor)
{
  // Draw the main horizontal line
  line(bor, height - bor, width - bor, height - bor);
  
  // Write the meaning of the horizontal line
  text("Year", width - bor + 30, height - bor);
  
  for (int i = minHorz ; i <= maxHorz ; i += dif)
  {
    // Fint the position of the current year
    float x = map(i, minHorz, maxHorz, bor, width - bor);
    
    // Draw the gradations
    line(x, height - bor, x, height - bor + 5);
    
    // Write the current year
    String ye = Integer.toString(i);
    ye = "'" + ye.substring(2, 4);
    text(ye, x, height - bor + 20);
  }
}

void loadData()
{
  loading = true;
  border = map(10, 0, 100, 0, height);
  
  // Read the data from the file
  readData(spaceLaunches);
  
  minYear = Integer.parseInt(spaceLaunches.get(1).id.substring(0, 4));
  maxYear = Integer.parseInt(spaceLaunches.get(spaceLaunches.size() - 1).id.substring(0, 4));
  minFreq = 0;
  maxFreq = maxFrequency(spaceLaunches); 
  
  frequencyArray(spaceLaunches, freqA);
  
  loading = false;
  println("Done");
  /*
  for (Data d:spaceLaunches)
  {
    println(d.id + " " + d.launchVehicle + " " + d.payload + " " + d.country + " " + d.date);
  }
  */
}

void drawLoading()
{
  background(bgColor);
  textSize(20);
  fill(0);
  text("Loading...", width / 2, height / 2);
  textSize(12);
}

void drawMenu()
{
  background(bgColor);

  // Map the positions of the buttons
  
  int w = 200;
  int halfW = w / 2;
  int h = 50;
  int noButtons = 4;
  int button = 1;
  float upperLimit = 2 * border;
  float lowerLimit = height - 2 * border;
  float y = map(button, 1, noButtons, upperLimit, lowerLimit);
  
  textSize(30);
  textAlign(CENTER);
  text("Space launches from 1957 - 2014", width / 2, border);
  textSize(12);
  
  controlP5 = new ControlP5(this);
  controlP5.addGroup("menu");
  
  controlP5.addButton("Line Graph", 1, width / 2 - halfW, (int)y, w, h).setGroup("menu"); 
  button++;
  y = map(button, 1, noButtons, upperLimit, lowerLimit);
  controlP5.addButton("Bar Graph (NOT IMPLEMENTED)", 2, width / 2 - halfW, (int)y, w, h).setGroup("menu"); 
  button++;
  y = map(button, 1, noButtons, upperLimit, lowerLimit);
  controlP5.addButton("Scatter Point Graph (NOT IMPLEMENTED)", 2, width / 2 - halfW, (int)y, w, h).setGroup("menu"); 
  button++;
  y = map(button, 1, noButtons, upperLimit, lowerLimit);
  controlP5.addButton("Pictograph (NOT IMPLEMENTED)", 2, width / 2 - halfW, (int)y, w, h).setGroup("menu"); 
}

void drawLineGraph()
{
    background(bgColor);
    fill(0);
    //fill(231, 76, 60);
    stroke(0);
    drawVertAxis(minFreq, maxFreq + 1, 10, border);
    drawHorzAxis(minYear, maxYear, 3, border);
    noStroke();
    fill(44, 62, 80);
    trendGraph(spaceLaunches, minFreq, maxFreq, 1, minYear, maxYear, 1, border);
}

void setup()
{
  // Setup
  size(displayWidth / 2, displayHeight / 2);
  background(bgColor);
  stroke(0);
  fill(0);
  textAlign(CENTER, CENTER); 
  rectMode(CENTER);
  smooth();

  thread("loadData");
  

}

void draw()
{
  if(loading)
  {
    drawLoading();
  }
  else
  {
    if(menu)
    {
      drawMenu();
      menu = false;
    }
  }
}

void controlEvent(ControlEvent theEvent)
{
  if (theEvent.isController())
  {
    if (theEvent.name().equals("Line Graph"))
    {
      //controlP5.getController("Graph1").hide();
      // Hide all menu buttons
      controlP5.getGroup("menu").hide();
      
      // Draw the line graph
      drawLineGraph();
    }
  }
}
