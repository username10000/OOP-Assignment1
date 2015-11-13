import controlP5.*;
import java.util.Hashtable;
import java.util.Map;

//boolean sketchFullScreen() { return true; }

//******************************Variables******************************//
// Create a ControlP5 object
ControlP5 controlP5;

// Create a font
PFont pfont = createFont("Calibri", 15, true);
ControlFont font = new ControlFont(pfont, 15);

// Flags
boolean first = true;
boolean loading = true;
boolean menu = true;

// Background colour
color bgColor = color(255);

// ArrayLists for the space launches and for the frequency
ArrayList<Data> spaceLaunches = new ArrayList<Data>();
ArrayList<Integer> freqA = new ArrayList<Integer>();

// Create variables for the value of the sliders
int sliderFirstYear, sliderLastYear;

// Other variables needed
Map<String, Integer> border = new HashMap<String, Integer>();
int minYear, maxYear, minFreq, maxFreq, firstYear, lastYear;
//------------------------------Variables------------------------------//

//******************************LoadData*******************************//
// Read the data from the file
void readData(ArrayList<Data> spaceLaunches) 
{
  String[] records = loadStrings("SpaceLaunches.csv");

  for (String s : records)
  {    
    // Create a new instance and assign data to it
    Data record = new Data(s);

    // Add the object to the main arraylist
    spaceLaunches.add(record);
  }
}

// Calculate the frequency of space launches in a specified year
int frequencyEachYear(ArrayList<Data> spaceLaunches, int year, String name) 
{
  int count = 0;

  for (int i = 1; i < spaceLaunches.size (); i++)
  {
    // Get current year  
    int curYear = Integer.parseInt(spaceLaunches.get(i).id.substring(0, 4));

    // Check if it's the wanted year
    if ( ( ( curYear == year ) && (name.equals("All")) ) || ( ( curYear == year ) && (spaceLaunches.get(i).country.equals(name)) ) )
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
void frequencyArray(ArrayList<Data> spaceLaunches, ArrayList<Integer> freqA)
{
  for (int  i = minYear; i <= maxYear; i++)
  {
    freqA.add(frequencyEachYear(spaceLaunches, i, "All"));
  }
}

// Calculate the maximum frequency of space launches in a year
int maxFrequency(ArrayList<Data> spaceLaunches)
{
  int count = 0;
  int index = 1;

  for (int i = 1; i < spaceLaunches.size (); i++)
  {
    // Get the frequency of the current year
    int freq = frequencyEachYear(spaceLaunches, (i-1) + firstYear, "All");

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
  // Assign the border values for each part of the screen
  border.put("Top", (int)map(10, 0, 100, 0, height));
  border.put("Bottom", (int)map(10, 0, 100, 0, height));
  border.put("Left", (int)map(10, 0, 100, 0, height));
  border.put("Right", (int)map(10, 0, 100, 0, height));

  // Read the data from the file
  readData(spaceLaunches);

  // Initialise the values of the year and frequence
  minYear = Integer.parseInt(spaceLaunches.get(1).id.substring(0, 4));
  maxYear = Integer.parseInt(spaceLaunches.get(spaceLaunches.size() - 1).id.substring(0, 4));
  firstYear = minYear;
  lastYear = maxYear;
  minFreq = 0;
  maxFreq = maxFrequency(spaceLaunches); 

  // Create the frequency array
  frequencyArray(spaceLaunches, freqA);

  // Change the loading flag to false to stop the loading page
  loading = false;
}
//------------------------------LoadData-------------------------------//

void createControlP5()
{
  int w = 200;
  int halfW = w / 2;
  int h = 50;
  int noButtons = 5;
  int button = 1;
  int space = 0;
  int gap = 20;
  int buttonWidth = (int)map(10, 0, 100, 0, width - border.get("Left") - border.get("Right")); //100;
  int buttonHeight = (int)map(40, 0, 100, 0, border.get("Bottom")); //30;
  float upperLimit = 2 * border.get("Top");
  float lowerLimit = height - 2 * border.get("Bottom");
  float y;
  String[] buttonName = {
    "Line Graph", "Bar Graph", "Scatter Point Graph", "Pictograph", "Exit"
  };

  // Create a new instance of ControlP5
  controlP5 = new ControlP5(this);

  // Change the font of all object created with ControlP5
  controlP5.setFont(font);
  //***Menu***//
  // Create a new group
  controlP5.addGroup("menu");

  // Draw the menu buttons
  for (int i = 0; i < buttonName.length; i++)
  {
    y = map(button, 1, noButtons, upperLimit, lowerLimit);
    controlP5.addButton(buttonName[i], i + 1, width / 2 - halfW, (int)y, w, h).setGroup("menu"); 
    button++;
  }

  // Hide the menu buttons
  controlP5.getGroup("menu").hide();
  //---Menu---//


  //***Sliders***//
  controlP5.addGroup("lineGraph");
  controlP5.addSlider("sliderFirstYear", firstYear, lastYear - 1, firstYear, border.get("Left") + space, height - border.get("Bottom"), buttonWidth, buttonHeight).setGroup("lineGraph");
  space += buttonWidth + gap;
  controlP5.addSlider("sliderLastYear", firstYear + 1, lastYear, lastYear, border.get("Left") + space, height - border.get("Bottom"), buttonWidth, buttonHeight).setGroup("lineGraph");
  space += buttonWidth + gap;

  // Set colours for the first slider
  controlP5.getController("sliderFirstYear").setColorBackground(color(231, 76, 60));
  controlP5.getController("sliderFirstYear").setColorForeground(color(52, 152, 219));
  controlP5.getController("sliderFirstYear").setColorActive(color(52, 152, 219));

  // Set colours for the second slider (the background colour is the colour of the foreground colour of the first slider)
  controlP5.getController("sliderLastYear").setColorBackground(color(52, 152, 219));
  controlP5.getController("sliderLastYear").setColorForeground(color(231, 76, 60));
  controlP5.getController("sliderLastYear").setColorActive(color(231, 76, 60));

  // Hide the line graph buttons
  controlP5.getGroup("lineGraph").hide();
  //---Sliders---//


  //***Toggles***//
  controlP5.addToggle("USA", false, border.get("Left") + space, height - border.get("Bottom"), buttonHeight, buttonHeight).setGroup("lineGraph");
  controlP5.getController("USA").setColorLabel(color(0));
  space += buttonHeight + gap;
  controlP5.addToggle("Russia", false, border.get("Left") + space, height - border.get("Bottom"), buttonHeight, buttonHeight).setGroup("lineGraph");
  controlP5.getController("Russia").setColorLabel(color(0));
  space += buttonHeight + gap;
  //---Toggles---//


  //***Return***//
  controlP5.addButton("X", 0, width - 25, 0, 25, 25);
  controlP5.getController("X").setColorBackground(color(255, 0, 0));
  controlP5.getController("X").setColorForeground(color(200, 0, 0));
  controlP5.getController("X").hide();
  //---Return---//
}

// Draw the loading screen
void drawLoading()
{
  // Reset the background colour
  background(bgColor);

  // Change the text colour and size
  textSize(20);
  fill(0);

  // Display the loading text
  text("Loading...", width / 2, height / 2);
}

// Draw the menu screen
void drawMenu()
{
  background(bgColor);

  // Change the bottom border back to the default value
  border.put("Bottom", (int)map(10, 0, 100, 0, height));
  
  // Change text size, alignment and display it
  textSize(30);
  textAlign(CENTER);
  fill(0);
  text("Space launches from 1957 - 2014", width / 2, border.get("Top"));

  controlP5.getGroup("menu").show();
}

// Draw the vertical axis of the line graph
void drawVertAxis(int minVert, int maxVert, int dif, Map<String, Integer> bor)
{
  // Align the text
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
void trendGraph(ArrayList <Data> spaceLaunches, int minVert, int maxVert, int difVert, int minHorz, int maxHorz, Map<String, Integer> bor, String name)
{
  PVector pos = new PVector(0.0f, 0.0f);

  // Start the line graph shape and put a vertex at the origin point
  beginShape();
  vertex(bor.get("Left"), height - bor.get("Bottom"));

  
  for (int i = minHorz - firstYear; i <= maxHorz - firstYear; i++)
  {
    // Get the current year and the frequency
    int curYear = i + firstYear;
    int count = freqA.get(i);
    
    if (name.equals("USA"))
    {
      count = frequencyEachYear(spaceLaunches, curYear, "US");
      println(count);
    }
      

    // Map the current year and frequency to the size of the screen
    pos.x = map(curYear, minHorz, maxHorz, bor.get("Left"), width - bor.get("Right"));
    pos.y = map(count, minVert, maxVert, height - bor.get("Bottom"), bor.get("Top"));

    // Create the vertex with the coordinates
    vertex(pos.x, pos.y);
  }
  
  

  // Put a vertex at the end of the graph and end the shape
  vertex(width - bor.get("Right"), height - bor.get("Bottom"));
  endShape(CLOSE);
}

// Draw the line graph and all the necessary parts needed
void drawLineGraph()
{
  // Change the difference between the year gradations based on the number of years shown
  int dif = round(map((maxYear - minYear + 1), 2014 - 1957 + 1, 1, 3, 1));

  // Reset the screen
  background(bgColor);

  // Change the stroke and fill colour to black
  fill(0);
  stroke(0);

  // Change the text size
  textSize(12);

  // Make the bottom border bigger to make space for the buttons
  border.put("Bottom", (int)map(20, 0, 100, 0, height));

  // Draw the axis
  drawVertAxis(minFreq, maxFreq + 1, 10, border);
  drawHorzAxis(minYear, maxYear, dif, border);

  // Remove the stroke and change the colour of the graph's fill
  noStroke();
  fill(44, 62, 80);

  // Draw the actual graph
  trendGraph(spaceLaunches, minFreq, maxFreq, 1, minYear, maxYear, border, "All");
}


void setup()
{
  // Setup
  size(displayWidth / 2, displayHeight / 2);
  background(bgColor);
  stroke(0);
  fill(0);
  textAlign(CENTER, CENTER); 
  smooth();

  // Load the data in a separate thread
  thread("loadData");
}

void draw()
{
  if (loading)
  {
    drawLoading();
  } else {
    if (first)
    {
      // Create the ControlP5 objects
      createControlP5();
      first = false;
    }
    if (menu)
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
      // Hide all menu buttons
      controlP5.getGroup("menu").hide();

      // Draw the line graph
      drawLineGraph();
      controlP5.getGroup("lineGraph").show();
      controlP5.getController("X").show();
    }
    if (theEvent.name().equals("Exit"))
    {
      exit();
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
  if (theEvent.name().equals("USA"))
  {
    if (theEvent.value() == 1.0)
    {
      fill(0, 0, 255);
      trendGraph(spaceLaunches, minFreq, maxFreq, 1, minYear, maxYear, border, "USA");
    }
    else
    {
      drawLineGraph();
    }
  }
  if (theEvent.name().equals("X"))
  {
    boolean broadcast;
    menu = true;
    controlP5.getGroup("lineGraph").hide();
    controlP5.getController("X").hide();

    minYear = firstYear;
    maxYear = lastYear;

    broadcast = controlP5.getController("sliderFirstYear").isBroadcast();
    controlP5.getController("sliderFirstYear").setBroadcast(false);
    controlP5.getController("sliderFirstYear").setMax(lastYear - 1);
    controlP5.getController("sliderFirstYear").setValue(firstYear);
    controlP5.getController("sliderFirstYear").setBroadcast(broadcast);

    broadcast = controlP5.getController("sliderLastYear").isBroadcast();
    controlP5.getController("sliderLastYear").setBroadcast(false);
    controlP5.getController("sliderLastYear").setMin(firstYear + 1);
    controlP5.getController("sliderLastYear").setValue(lastYear);
    controlP5.getController("sliderLastYear").setBroadcast(broadcast);
  }
}

