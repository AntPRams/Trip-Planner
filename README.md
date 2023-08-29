# Trip planner

App made with the requirements provided,  those are listed below with comments regarding my thoughts and details about the implementation of each.
This app was developed using MVVM architeture.


## App requirements

>1. _Download and parse information_: 

* The `APICaller` is the object that have a generic method used to fetch a model, then the `ConnectionsService` use the caller to fetch and map the data accordingly. The `Service` is a protocol that can be extended or used for similar purposes.
 
>2. _The user should be able to select any departure city and any destination city available (even if a direct connection between the two cities is not available)_:

* I've mapped all the cities, origin and destination, into an array to have them available in both `SearchField`s. The user will be able to pick one city from a list that will popup if the text matches any city name from the ones provided.
 
>3. _The purpose of this app is to find the cheapest route between the two cities that the user select and to show the total price in a label in the same page_:

* This was the trickiest part. I already knew about the Dijktra's algorithm but I never had to implement it. I've tried some solutions made from scratch, but where some did work perfectly in other paths failed miserably. Then I stumble upon an Apple framework, `GameplayKit`. So, with the help of [`GKGraph`](https://developer.apple.com/documentation/gameplaykit/gkgraph) i've managed to create a path calculator that was able to provide all the paths available between two given [nodes](https://developer.apple.com/documentation/gameplaykit/gkgraphnode). Then i only had to check which was the cheapest.
 
>4. _Use coordinates available in the JSON to show the cheapest selected route on a map_:

* I've started the project with XCode 15, but we all know how well behaved are those betas, I drop out and move to XCode 14, since I didn't had the access to the new SwiftUI map API's, I had to create a `UIViewRepresentable` to be able to add polylines to a map and add it to a SwiftUI view 
 
>5. _BONUS: To select the cities use a text field with autocomplete (from the list of the available cities you get from the JSON)_:

* This was done with the help of `folding` using the query and the city while filtering. The suggestions are presented in a view below the `SearchField` that's being edited.

## UI Details

<p align="center">
<img src="https://github.com/AntPRams/Trip-Planner/assets/36003116/da0eb761-960d-4f27-a6fe-45e91a03246d" width="20%%">    <img src="https://github.com/AntPRams/Trip-Planner/assets/36003116/d340ba11-a549-474a-8677-d8741bb1514d" width="20%%">    <img src="https://github.com/AntPRams/Trip-Planner/assets/36003116/9da32408-4397-4265-9329-2c1c5dfa6476" width="20%%">    <img src="https://github.com/AntPRams/Trip-Planner/assets/36003116/bef6901a-5fa8-465a-9c07-b95e271be308" width="20%%">
</p>

The header has three buttons:

* `Search`: calculate a path between the two given inputs
* `Clear`: clears the inputs in both `SearchField`s and removes the path detail views if displayed
* `Refresh`: download and parse information from the given url

Both `SearchField`s will display a dropdown list if the input matches any city available. If the user tap any city row it will automatically fill the focused `SearchField` with the name of the choosen city.
Everytime the user search for a path, the app will validate if all the fields are filled correctly, if not an alert will be displayed with the designated error for each case.
When a patch is found the map and the trip overview will be displayed.

## Tests

<p align="center">
<img src="https://github.com/AntPRams/Trip-Planner/assets/36003116/6996d9b9-a218-45de-8041-bbd37cbda20a" width="80%%">
</p>

Unit tests covers 63,8% of the app, with a large portion of the remainder being covered by UI tests

## Developed with:

* macOS Ventura 13.5.1

* XCode 14.3.1


