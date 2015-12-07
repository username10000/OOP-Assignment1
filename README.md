# DT228 Object Oriented Programming Assignment 1

## Dataset
This submission uses a dataset that contains all the spacecraft launches from 1957 to 2014. It contains the names of the launch vehicles, payloads, country of origin, and date where available. The country is written in an abreviated form with the full name available in a second file.

## Plan
* In this project I plan to have at least a line graph, a bar graph, a scatter plots graph and a pictograph. Moreover, each graph will have multiple options in which to display the data such as to only show the launches between certain years or to only show the launches made by a certain nation
* The graphs will be easily accessible from a menu that starts at the beginning of the program and can be returned to at any time
* The loading and initialisation of the data will be done at the beginning of the program so there shouldn't be any delay in opening any of the graphs at any time
* I will use classes
* The library ControlP5 will be used to draw the buttons, toggles, text boxes and other objects
* It will also contain animations at certain times

## Writeup
This assignment involved using a dataset to visualise some data using Processing. I chose a dataset of all the space launches by every country from 1957 to 2014. The dataset has for each launch an International Designator, Launch Vehicle, Payload, Country and the Launch Date. The country is in an abbreviated form to reduce space. There is another file that has the full name of every country or company. For this assignment I used Processing 2.
###### Loading Page
![Loading](/Screenshots/Loading.JPG)
When the program is opened for the first time there is a loading screen. Here all the data is read, the graphs are initiated and other data necessary are extracted from the dataset.
###### Menu Page
![Menu](/Screenshots/Menu.JPG)
This is the menu page where the user can select which graph to open. There is also an exit button to exit the program. Each graph page has an exit button on the top right from where the user can return to the menu page. Unlike the other pages this one has a background image.
###### First Graph (Line Graph)
![M1](/Screenshots/M1.JPG)
This is a line graph that shows the trend of space launches from 1957 to 2014. On the vertical axis represents the frequency of launches and the horizontal axis represents the years. Under the graph there are two sliders and to toggles. The sliders are used to only show the line graph between certain years. The toggles are used to show on top of the line graph two other line graphs for all the launches by NASA and all the launches by Roscosmos.
###### Second Graph(Bar Graph)
![M2](/Screenshots/M2.JPG)
This is a bar graph showing the total ammount of launches for each month from 1957 to 2014. The vertical axis represents the frequency of launches and the horizontal line represents the months of the launches. When the mouse hovers the bars they change colour to represent that they are selected and the total frequency of that month is displayed on top of it.
###### Third Graph(Circle Graph)
![M3](/Screenshots/M3.JPG)
This graph is showing the frequency of launches each day. It is represented using a donut shape where each day has an equal sized segment. This segment is filled with colour according to the frequencies that day. When the user hovers a segment it becomes highlighted and the total ammount of launches and the average ammount of launches are displayed in the middle.
###### Forth Graph(PictoGraph)
![M4](/Screenshots/M4.JPG)
This graph shows the total ammount of launches each year from 1957 to 2014. This is done by making a page for each year and in it there is a rocket model drawn using processing for each launch. When a rocket is selected on it it is displayed the number of the launch in that year and the launch vehicle, payload and date of the launch at the bottom of the screen. There are two buttons to navigate through the year in the bottom left and bottom right corners. There is also a button in the top left corner called "Auto" that the user can select to automatically cycle through the years like a slideshow.
###### Fifth Graph(Pie Graph)
![M5](/Screenshots/M5.JPG)
This graph shows the number of launches in 2014 by country using a pie graph. When the mouse hovers a segment it increases the radius of the segment to represent that it is selected. When a segment is selected at the bottom of the screen appears some text that shows the country and number of launches of that country in 2014.
