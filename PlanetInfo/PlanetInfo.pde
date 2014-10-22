int NUM_PLANETS = 8;
int NUM_FIELDS = 13;

String[] rawData;
String[][] planetInfo = new String[NUM_PLANETS][NUM_FIELDS];

void setup()
{
  
  rawData = loadStrings("planetinfo.txt");
  
  
  for (int i = 0; i < NUM_PLANETS; i++)
  {
    // fill in the first element of each sub-array with the planet it corresponds to
    planetInfo[i][0] = str(i);
    println(planetInfo[i][0]);
    for (int j = 1; j < NUM_FIELDS; j++)
   {
     // to access the right data from loadedData, multiply which row you're on by 13 and add the col
      planetInfo[i][j] = rawData[i*13 + j - 1];
      println(planetInfo[i][j]);
   }
   
  }
  
}
