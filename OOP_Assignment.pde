//boolean sketchFullScreen() { return true; }
boolean loading = false;
ArrayList<Data> spaceLaunches = new ArrayList<Data>();
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
  float x1 = 0, y1 = 0;
  float x2, y2;
  
  for (int i = 1 ; i < spaceLaunches.size() ; i++)
  {
    int curYear = Integer.parseInt(spaceLaunches.get(i).id.substring(0, 4));
    int count = frequencyEachYear(spaceLaunches, curYear);
    
    x2 = map(curYear, minHorz, maxHorz, bor, width - bor);
    y2 = map(count, minVert, maxVert, height - bor, bor);
    
    if ( ( i != 1 ) && (!spaceLaunches.get(i).id.substring(0, 4).equals(spaceLaunches.get(i - 1).id.substring(0, 4))) )
    {
      line(x1, y1, x2, y2);
    }
    
    x1 = x2;
    y1 = y2;
  }
}

void drawVertAxis(int minVert, int maxVert, int dif, float bor)
{
  // Draw main vertical axis line
  line(bor, bor, bor, height - bor);
  
  // Write the meaning of the vertical line
  text("Launches", bor, bor - 30);
  
  for (int i = minVert ; i <= maxVert ; i += dif)
  {
    // Find the position of the current frequency
    float y = map(i, minVert, maxVert, height - bor, bor);
    
    // Draw the gradations
    line(bor, y, bor - 5, y);
    
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
  
  loading = false;
  println("Done");
  /*
  for (Data d:spaceLaunches)
  {
    println(d.id + " " + d.launchVehicle + " " + d.payload + " " + d.country + " " + d.date);
  }
  */
}

void setup()
{
  // Setup
  size(displayWidth / 2, displayHeight / 2);
  background(0);
  stroke(255);
  textAlign(CENTER, CENTER); 
  
  thread("loadData");
}

void draw()
{
  if(loading)
  {
    background(0);
    text("Loading...", width / 2, height / 2);
  }
  else
  {
    background(0);
    drawVertAxis(minFreq, maxFreq + 1, 10, border);
    drawHorzAxis(minYear, maxYear, 3, border);
    trendGraph(spaceLaunches, minFreq, maxFreq, 1, minYear, maxYear, 1, border);
  }
}
