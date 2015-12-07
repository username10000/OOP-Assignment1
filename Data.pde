// Class that stores the data extracted from the space launches dataset
class Data
{
  String id;
  String launchVehicle;
  String payload;
  String country;
  String date;

  Data(String s) 
  {
    String[] temp = s.split(",");

    this.id = temp[0];
    this.launchVehicle = temp[1];
    this.payload = temp[2];
    this.country = temp[3];
    this.date = temp[4];
  }
}

