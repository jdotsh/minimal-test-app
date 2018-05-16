# minimal_test_app
-----------------------------------------------------------------------
#### *A playground for jdotsh to get ready 2018 GSoC*

##### Description

**Note:** *I used Qt Creator 4.6.0 with Qt 5.10.1 libraries to code this app*

This very small app has been developed starting from the *minimal_map* example included in **Qt Creator.**.
The purpose was to allow me to become familiar with **Qtlocation APIs**, in order to achieve the best results in my 2018 *Google Summer of Code* project.

The original example has been modified in 3 steps, following the directions and with the help of my Qt Mentor.
1. First of all we added the possibility to extract the geographical coordinates from the map.
2. In the second step we have stored this data on a *ListModel* and with *MapItemView* we added markers above the sampled positions.
3. In the final steps we have added a geometric element, a polygon that has the previous markers as vertices.

##### How to use
*Press and hold* : add a marker to the map. when you have 3 or more markers, a polyogn appears.
*Double click  on a marker* : remove the marker
