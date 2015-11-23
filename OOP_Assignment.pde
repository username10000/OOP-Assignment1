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
color bgColour = color(255);

// ArrayLists for the space launches and for the frequency
ArrayList<Data> spaceLaunches = new ArrayList<Data>();
ArrayList<Integer> freqA = new ArrayList<Integer>();

// Create variables for the value of the sliders
int sliderFirstYear, sliderLastYear;

// Create a colour array for the circle graph
color[] circleColour = new color[31];

// Other variables needed
Map<String, Integer> border = new HashMap<String, Integer>();
int minYear, maxYear, minFreq, maxFreq, firstYear, lastYear;

LineGraph lineGraph;
BarGraph barGraph;
CircleGraph circleGraph;
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
  
  // Create the colour for the circle graph
  for (int i = 0 ; i < 30 ; i++)
  {
    circleColour[i] = color(random(0, 255), random(0, 255), random(0, 255));
  }
  
  lineGraph = new LineGraph(minYear, maxYear, minFreq, maxFreq, 10);
  barGraph = new BarGraph(minYear, maxYear, 50, 100);
  circleGraph = new CircleGraph(minYear, maxYear);

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
    "Line Graph", "Bar Graph", "Circle Graph", "Pictograph", "Exit"
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
  background(bgColour);

  // Change the text colour and size
  textSize(20);
  fill(0);

  // Display the loading text
  text("Loading...", width / 2, height / 2);
}

// Draw the menu screen
void drawMenu()
{
  background(bgColour);

  // Change the bottom border back to the default value
  border.put("Bottom", (int)map(10, 0, 100, 0, height));
  
  // Change text size, alignment and display it
  textSize(30);
  textAlign(CENTER);
  fill(0);
  text("Space launches from 1957 - 2014", width / 2, border.get("Top"));

  controlP5.getGroup("menu").show();
}

void resetSettings()
{
  fill(0);
  stroke(0);
  strokeWeight(1);
  textSize(12);
  textAlign(CENTER, CENTER);
  
  // Reset the borders
  border.put("Top", (int)map(10, 0, 100, 0, height));
  border.put("Bottom", (int)map(10, 0, 100, 0, height));
  border.put("Left", (int)map(10, 0, 100, 0, height));
  border.put("Right", (int)map(10, 0, 100, 0, height));
}

void setup()
{
  // Setup
  size(displayWidth / 2, displayHeight / 2);
  background(bgColour);
  stroke(0);
  fill(0);
  textAlign(CENTER, CENTER); 
  smooth();

  // Load the data in a separate thread
  thread("loadData");
}

void draw()
{
  resetSettings();
  if (loading)
  {
    // Draw loading screen
    drawLoading();
  } 
  else 
  {
    if (first)
    {
      // Create the ControlP5 objects
      createControlP5();
      first = false;
    }
    if (menu)
    {
      // Draw menu screen
      drawMenu();
      menu = false;
      circleGraph.isVisible = false;
    }
    if (circleGraph.isVisible)
    {
      circleGraph.checkGraph();
    }
  }
}

void controlEvent(ControlEvent theEvent)
{
  if (theEvent.isController())
  {
    // Events for menu buttons
    
    // Line Graph
    if (theEvent.name().equals("Line Graph"))
    {
      // Hide all menu buttons
      controlP5.getGroup("menu").hide();

      // Draw the line graph
      lineGraph.drawGraph();
      controlP5.getGroup("lineGraph").show();
      controlP5.getController("X").show();
    }
    
    // Bar Graph
    if (theEvent.name().equals("Bar Graph"))
    {
      // Hide all menu buttons
      controlP5.getGroup("menu").hide();
      
      // Draw the Bar Graph
      barGraph.drawGraph();
      //drawGraph();
      controlP5.getController("X").show();
    }
    
    // Scatter Plot Graph
    if (theEvent.name().equals("Circle Graph"))
    {
      // Hide all menu buttons
      controlP5.getGroup("menu").hide();
      
      // Draw the Bar Graph
      circleGraph.drawGraph();
      controlP5.getController("X").show();
      
      circleGraph.isVisible = true;
    }
    
    // Exit
    if (theEvent.name().equals("Exit"))
    {
      exit();
    }
    
    
    // Events for buttons, sliders and toggles
    if (theEvent.name().equals("sliderFirstYear"))
    {
      // Change the minimum year and the range of the second slider based on the first
      lineGraph.minYear = (int)theEvent.value();
      if (lineGraph.minYear == 2013)
        controlP5.getController("sliderLastYear").setMin(2013);
      else
        controlP5.getController("sliderLastYear").setMin(lineGraph.minYear + 1);
      lineGraph.drawGraph();
    }
    if (theEvent.name().equals("sliderLastYear"))
    {
      // Change the maximum year and the range of the first slider based on the second
      lineGraph.maxYear = (int)theEvent.value();
      if (lineGraph.maxYear == 1958)
        controlP5.getController("sliderFirstYear").setMax(1958);
      else
        controlP5.getController("sliderFirstYear").setMax(lineGraph.maxYear - 1);
      lineGraph.drawGraph();
    }
    if (theEvent.name().equals("USA"))
    {
      // Draw the graph if the toggle state is changed
      lineGraph.drawGraph();
    }
    if (theEvent.name().equals("Russia"))
    {
      // Draw the graph if the toggle state is changed
      lineGraph.drawGraph();
    }
    if (theEvent.name().equals("X"))
    {
      // Hide the line graph buttons and show the menu
      boolean broadcast;
      menu = true;
      controlP5.getGroup("lineGraph").hide();
      controlP5.getController("X").hide();
  
      // Reset the min and max Years
      lineGraph.minYear = firstYear;
      lineGraph.maxYear = lastYear;
  
      // Reset the max range
      broadcast = controlP5.getController("sliderFirstYear").isBroadcast();
      controlP5.getController("sliderFirstYear").setBroadcast(false);
      controlP5.getController("sliderFirstYear").setMax(lastYear - 1);
      controlP5.getController("sliderFirstYear").setValue(firstYear);
      controlP5.getController("sliderFirstYear").setBroadcast(broadcast);
  
      // Reset the min range
      broadcast = controlP5.getController("sliderLastYear").isBroadcast();
      controlP5.getController("sliderLastYear").setBroadcast(false);
      controlP5.getController("sliderLastYear").setMin(firstYear + 1);
      controlP5.getController("sliderLastYear").setValue(lastYear);
      controlP5.getController("sliderLastYear").setBroadcast(broadcast);
    }
  }
}
