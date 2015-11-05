void readData(ArrayList<Data> spLa)
{
  String[] records = loadStrings("SpaceLaunches.csv");
  
  for (String s:records)
  {
    String[] temp = s.split(",");
    Data record = new Data(temp[0], temp[1], temp[2], temp[3], temp[4]);
    
    spLa.add(record);
  }
}

int frequencyEachYear(ArrayList<Data> spLa, int year)
{
  int count = 0;
  
  for (int i = 1 ; i < spLa.size() ; i++)
  {
   // Get current year  
   int curYear = Integer.parseInt(spLa.get(i).id.substring(0, 4));
   
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

int maxFrequency(ArrayList<Data> spLa)
{
  int count = 0;
  int index = 1;
  int firstYear = Integer.parseInt(spLa.get(1).id.substring(0, 4));
  
  for(int i = 1 ; i < spLa.size() ; i++)
  {
    // Get the frequency of the current year
    int freq = frequencyEachYear(spLa, (i-1) + firstYear);
    
    // Check if it's bigger than the max frequency
    if(freq > count)
    {
      count = freq;
      index = i;
    }
  }
  
  return count;
}

void trendGraph(ArrayList <Data> spLa, int minVert, int maxVert, int difVert, int minHorz, int maxHorz, int difHorz, float bor)
{
  float x1 = 0, y1 = 0;
  float x2, y2;
  
  for (int i = 1 ; i < spLa.size() ; i++)
  {
    int curYear = Integer.parseInt(spLa.get(i).id.substring(0, 4));
    int count = frequencyEachYear(spLa, curYear);
    
    x2 = map(curYear, minHorz, maxHorz, bor, width - bor);
    y2 = map(count, minVert, maxVert, height - bor, bor);
    
    if ( ( i != 1 ) && (!spLa.get(i).id.substring(0, 4).equals(spLa.get(i - 1).id.substring(0, 4))) )
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

void setup()
{
  // Setup
  size(1200, 500);
  background(0);
  stroke(255);
  textAlign(CENTER, CENTER);
  
  // Declare variables
  ArrayList<Data> spaceLaunches = new ArrayList<Data>();
  float border = map(10, 0, 100, 0, height);
  
  // Read the data from the file
  readData(spaceLaunches);
  
  int minYear = Integer.parseInt(spaceLaunches.get(1).id.substring(0, 4));
  int maxYear = Integer.parseInt(spaceLaunches.get(spaceLaunches.size() - 1).id.substring(0, 4));
  int minFreq = 0;
  int maxFreq = maxFrequency(spaceLaunches);
  
  drawVertAxis(minFreq, maxFreq + 1, 10, border);
  drawHorzAxis(minYear, maxYear, 3, border);
  trendGraph(spaceLaunches, minFreq, maxFreq, 1, minYear, maxYear, 1, border); 
  
  /*
  for (Data d:spaceLaunches)
  {
    println(d.id + " " + d.launchVehicle + " " + d.payload + " " + d.country + " " + d.date);
  }
  */
}

void draw()
{
  
}
