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

void trendGraph()
{
  
}

void setup()
{
  //Setup
  size(500, 500);
  background(0);
  
  //Declare variables
  ArrayList<Data> spaceLaunches = new ArrayList<Data>();
  
  readData(spaceLaunches);
  
  for (Data d:spaceLaunches)
  {
    println(d.id + " " + d.launchVehicle + " " + d.payload + " " + d.country + " " + d.date);
  }
}

void draw()
{
  
}
