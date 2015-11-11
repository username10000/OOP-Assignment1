import controlP5.*;
import java.util.Hashtable;
import java.util.Map;

//boolean sketchFullScreen() { return true; }

// Create a ControlP5 object
ControlP5 controlP5;

// Create a font
PFont pfont = createFont("Calibri", 15, true);
ControlFont font = new ControlFont(pfont, 15);

// Flags
boolean loading = false;
boolean menu = true;

// Background colour
color bgColor = color(255);

// ArrayLists for the space launches and for the frequency
ArrayList<Data> spaceLaunches = new ArrayList<Data>();
ArrayList<PVector> freqA = new ArrayList<PVector>();

// Other variables needed
Map<String, Integer> border = new HashMap<String, Integer>();
int minYear, maxYear, minFreq, maxFreq;
int sliderFirstYear, sliderLastYear;

// Read the data from the file
void readData(ArrayList<Data> spaceLaunches) 
{
  String[] records = loadStrings("SpaceLaunches.csv");

  for (String s : records)
  {    
    Data record = new Data(s);
    spaceLaunches.add(record);
  }
}

// Calculate the frequency of space launches in a specified year
int frequencyEachYear(ArrayList<Data> spaceLaunches, int year) 
{
  int count = 0;

  for (int i = 1; i < spaceLaunches.size (); i++)
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

// Calculate the frequency of space launches each year and add them to the freA arraylist
void frequencyArray(ArrayList<Data> spaceLaunches, ArrayList<PVector> freqA)
{
  PVector f;

  for (int  i = minYear; i <= maxYear; i++)
  {
    f = new PVector(i, frequencyEachYear(spaceLaunches, i));
    freqA.add(f);
  }
}

// Calculate the maximum frequency of space launches in a year
int maxFrequency(ArrayList<Data> spaceLaunches)
{
  int count = 0;
  int index = 1;
  int firstYear = Integer.parseInt(spaceLaunches.get(1).id.substring(0, 4));

  for (int i = 1; i < spaceLaunches.size (); i++)
  {
    // Get the frequency of the current year
    int freq = frequencyEachYear(spaceLaunches, (i-1) + firstYear);

    // Check if it's bigger than the max frequency
    if (freq > count)
    {
      count = freq;
      index = i;
    }
  }

  return count;
}

// Load all the data needed for the graphs
void loadData()
{
  loading = true;
  //border = map(10, 0, 100, 0, height);
  border.put("Top", (int)map(10, 0, 100, 0, height));
  border.put("Bottom", (int)map(10, 0, 100, 0, height));
  border.put("Left", (int)map(10, 0, 100, 0, height));
  border.put("Right", (int)map(10, 0, 100, 0, height));

  // Read the data from the file
  readData(spaceLaunches);

  minYear = Integer.parseInt(spaceLaunches.get(1).id.substring(0, 4));
  maxYear = Integer.parseInt(spaceLaunches.get(spaceLaunches.size() - 1).id.substring(0, 4));
  minFreq = 0;
  maxFreq = maxFrequency(spaceLaunches); 

  frequencyArray(spaceLaunches, freqA);

  loading = false;
}


// Draw the loading screen
void drawLoading()
{
  background(bgColor);
  textSize(20);
  fill(0);
  text("Loading...", width / 2, height / 2);
  textSize(12);
}

// Draw the menu screen
void drawMenu()
{
  background(bgColor);

  // Map the positions of the buttons

  int w = 200;
  int halfW = w / 2;
  int h = 50;
  int noButtons = 4;
  int button = 1;
  float upperLimit = 2 * border.get("Top");
  float lowerLimit = height - 2 * border.get("Bottom");
  float y = map(button, 1, noButtons, upperLimit, lowerLimit);

  textSize(30);
  textAlign(CENTER);
  text("Space launches from 1957 - 2014", width / 2, border.get("Top"));
  textSize(12);

  controlP5 = new ControlP5(this);
  controlP5.addGroup("menu");
  controlP5.setFont(font);

  controlP5.addButton("Line Graph", 1, width / 2 - halfW, (int)y, w, h).setGroup("menu"); 
  button++;
  y = map(button, 1, noButtons, upperLimit, lowerLimit);
  controlP5.addButton("Bar Graph", 2, width / 2 - halfW, (int)y, w, h).setGroup("menu"); 
  button++;
  y = map(button, 1, noButtons, upperLimit, lowerLimit);
  controlP5.addButton("Scatter Point Graph", 2, width / 2 - halfW, (int)y, w, h).setGroup("menu"); 
  button++;
  y = map(button, 1, noButtons, upperLimit, lowerLimit);
  controlP5.addButton("Pictograph", 2, width / 2 - halfW, (int)y, w, h).setGroup("menu");
}

// Draw the vertical axis of the line graph
void drawVertAxis(int minVert, int maxVert, int dif, Map<String, Integer> bor)
{
  textAlign(CENTER, CENTER);

  // Write the meaning of the vertical line
  text("Launches", bor.get("Left"), bor.get("Top") - 30);

  for (int i = minVert; i <= maxVert; i += dif)
  {
    // Find the position of the current frequency
    float y = map(i, minVert, maxVert, height - bor.get("Bottom"), bor.get("Top"));

    // Draw the gradations
    //line(bor, y, bor - 5, y);
    line(bor.get("Left"), y, width - bor.get("Right"), y); 

    // Write the frequency
    text(i, bor.get("Left") - 20, y);
  }
}

// Draw the horizontal axis of the line graph
void drawHorzAxis(int minHorz, int maxHorz, int dif, Map<String, Integer> bor)
{
  // Draw the main horizontal line
  line(bor.get("Left"), height - bor.get("Bottom"), width - bor.get("Right"), height - bor.get("Bottom"));

  // Write the meaning of the horizontal line
  text("Year", width - bor.get("Right") + 30, height - bor.get("Bottom"));

  for (int i = minHorz; i <= maxHorz; i += dif)
  {
    // Fint the position of the current year
    float x = map(i, minHorz, maxHorz, bor.get("Left"), width - bor.get("Right"));

    // Draw the gradations
    line(x, height - bor.get("Bottom"), x, height - bor.get("Bottom") + 5);

    // Write the current year
    String ye = Integer.toString(i);
    ye = "'" + ye.substring(2, 4);
    text(ye, x, height - bor.get("Bottom") + 20);
  }
}

// Draw the line graph
void trendGraph(ArrayList <Data> spaceLaunches, int minVert, int maxVert, int difVert, int minHorz, int maxHorz, int difHorz, Map<String, Integer> bor)
{
  float x2, y2;
  int firstYear = Integer.parseInt(spaceLaunches.get(1).id.substring(0, 4));

  beginShape();
  vertex(bor.get("Left"), height - bor.get("Bottom"));

  for (int i = minHorz - firstYear; i <= maxHorz - firstYear; i++)
  {
    int curYear = i + firstYear; //Integer.parseInt(spaceLaunches.get(i).id.substring(0, 4)); 
    int count = (int)freqA.get(i).y; //curYear - minYear

    x2 = map(curYear, minHorz, maxHorz, bor.get("Left"), width - bor.get("Right"));
    y2 = map(count, minVert, maxVert, height - bor.get("Bottom"), bor.get("Top"));

    vertex(x2, y2);
  }
  vertex(width - bor.get("Right"), height - bor.get("Bottom"));
  endShape(CLOSE);
}

// Draw the line graph and all the necessary parts needed
void drawLineGraph()
{
  background(bgColor);
  fill(0);
  //fill(231, 76, 60);
  stroke(0);
  border.put("Bottom", (int)map(20, 0, 100, 0, height));
  drawVertAxis(minFreq, maxFreq + 1, 10, border);
  drawHorzAxis(minYear, maxYear, 3, border);
  noStroke();
  fill(44, 62, 80);
  trendGraph(spaceLaunches, minFreq, maxFreq, 1, minYear, maxYear, 1, border);
  border.put("Bottom", (int)map(10, 0, 100, 0, height));
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

  if (loading)
  {
    drawLoading();
  } else {
    if (menu)
    {
      drawMenu();
      menu = false;
      controlP5.addGroup("lineGraph");
      controlP5.addSlider("sliderFirstYear", 1957, 2013, 1957, border.get("Left"), height - border.get("Bottom"), 100, 30).setGroup("lineGraph");
      controlP5.addSlider("sliderLastYear", 1958, 2014, 2014, border.get("Left") + 120, height - border.get("Bottom"), 100, 30).setGroup("lineGraph");
      controlP5.getGroup("lineGraph").hide();
    }
  }
}
boolean graph = false;
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
      controlP5.getGroup("lineGraph").show();
    }
  }
  if (theEvent.name().equals("sliderFirstYear"))
  {
    minYear = (int)theEvent.value();
    if (minYear == 2013)
      controlP5.getController("sliderLastYear").setMin(2013);
    else
      controlP5.getController("sliderLastYear").setMin(minYear + 1);
    drawLineGraph();
  }
  if (theEvent.name().equals("sliderLastYear"))
  {
    maxYear = (int)theEvent.value();
    if (maxYear == 1958)
      controlP5.getController("sliderFirstYear").setMax(1958);
    else
      controlP5.getController("sliderFirstYear").setMax(maxYear - 1);
    drawLineGraph();
  }
}

