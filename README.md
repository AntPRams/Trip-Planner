# TuiCC

App made with the requirements provided,  those are listed below with comments regarding my thoughts and details about the implementation of each.
This app was developed using MVVM architeture.


## App requirements

1. _Download and parse information_: The APICaller is the object that have a generic method used to fetch a model, then the `ConnectionsService` use the caller to fetch and map the data accordingly. The `Service` is a protocol tthat can be extended or used for similar purposes.
 
2. The user should be able to select any departure city and any destination city available (even if a direct connection between the two cities is not available)
 
3. The purpose of this app is to find the cheapest route between the two cities that the user select and to show the total price in a label in the same page
 
4. Use coordinates available in the JSON to show the cheapest selected route on a map
 
5. BONUS: To select the cities use a text field with autocomplete (from the list of the available cities you get from the JSON) 
## UI Details
