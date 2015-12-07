// Class that stores the code and the description of a country
class Country
{
  String code;
  String name;
  
  Country(String row)
  {
    String[] temp = row.split(",");
    this.code = temp[0];
    this.name = temp[1];
  }
}
