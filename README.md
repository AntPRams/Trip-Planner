# TuiCC

App made with the requirements provided,  those are listed below with comments regarding my thoughts and details about the implementation of each.
This app was developed using MVVM architeture.


## App requirements

1. _Download and parse information_: 

* The APICaller is the object that have a generic method used to fetch a model, then the `ConnectionsService` use the caller to fetch and map the data accordingly. The `Service` is a protocol tthat can be extended or used for similar purposes.
 
2. _The user should be able to select any departure city and any destination city available (even if a direct connection between the two cities is not available)_:

* I've mapped all the cities, origin and destination, into an array to have them available in both `SearchField`s. The user will be able to pick one city from a list that will popup if the text matches any city name from the ones provided.
 
3. _The purpose of this app is to find the cheapest route between the two cities that the user select and to show the total price in a label in the same page_:


 
4. Use coordinates available in the JSON to show the cheapest selected route on a map
 
5. BONUS: To select the cities use a text field with autocomplete (from the list of the available cities you get from the JSON) 
## UI Details
