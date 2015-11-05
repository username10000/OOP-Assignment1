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
    y2 = map(count, minVert, maxVert, bor, height - bor);
    
    if ( i != 1 )
    {
      line(x1, y1, x2, y2);
    }
    
    x1 = x2;
    y1 = y2;
    
    println(x1 + " " + y1 + " " + x2 + " " + y2);
  }
}

void setup()
{
  // Setup
  size(500, 500);
  background(0);
  stroke(255);
  
  //Declare variables
  ArrayList<Data> spaceLaunches = new ArrayList<Data>();
  float border = 10;//map(5, 0, 100, 0, height);
  
  // Read the data from the file
  readData(spaceLaunches);
 
  int minYear = Integer.parseInt(spaceLaunches.get(1).id.substring(0, 4));
  int maxYear = Integer.parseInt(spaceLaunches.get(spaceLaunches.size() - 1).id.substring(0, 4));
  int minFreq = 0;
  int maxFreq = maxFrequency(spaceLaunches);
 
  trendGraph(spaceLaunches, minFreq, maxFreq, 1, minYear, maxYear, 1, border); 
  /*
  for (Data d:spaceLaunches)
  {
    println(d.id + " " + d.launchVehicle + " " + d.payload + " " + d.country + " " + d.date);
  }
  */
  
  //Wrong trend graph?
}

void draw()
{
  
}
