<p align="center">
  <a href="https://github.com/fabulouiOS-monk/UberClone-iOS" title="NETFLIX CLONE APP"></a>
</p>
<h1 align="center"> Netflix clone </h1>
<p align="center"> <b>Netflix:</b> <i>An app to watch movies and TV shows.</i> Used UIKIT, MVVM architecture design and TMDB movie API, CoreData for core functionality of the app.</p>
   

## 🚀 Features
- User can see latest movies and TV shows in the app.
- Can only watch trailer when clicked on any movie.
- Download the movie on long tap.


## 👷 Built with
- Swift and UIKIT for functionality and UI
- XCode: IDE for app development in iOS
- Github : For Repo Storage and source code management
- Git: For version control system

## 📂 Directory Structure
- UberClone:
  * **Resources:** *Any extra functionality which we need in existing entities.*
  * **Managers:** *Classes to handle API call to TMDB and core data.*
  * **Controllers:** *UI related code for all the views.*
    - **Core**: *Main tabbar viewControllers - Home, Upcoming, Search, Downloads.*
    - **General**: *Views used in many places.*
  * **Models:** *Holding models used for decoding JSON data from TMDB to swift struct*
  * **ViewModels:** *Holding code to store viewModels with specified types required by respective viewControllers.*


## Technology and APIs used.
- UiKit: For UI of the App.
- CoreData: To store downloaded data.
- SDWebImages (3rd party): Package used for setting images to the cell view.
- TMDB API: API used for fetching movies/TV shows for topRated, upcoming, trending etc.
- Youtube Data API: Used for showing trailer for the searched movie on click of any movie/tv show cell.
- WebKit: Used for launching a web view to show youtube trailer.

## Things I learned through this project.
- This project was a great learning for me as I get to learn programmatic UI using UiKit.
- I also learned about how to fetch and store data from REST API and how to parse the data as required.
- Learned alot about delegate pattern, as we used it extensively for updating cells with the fetched data.
- Learned how to listen to any viewController which is not connected in any way by making use of NotificationCentre.


## Things need to improve (maybe in next project).
- Proper storage of API keys. For now I have just removed those. Cannot store in .plist file as that can also be accessed if someone has .ipa file of my app.
- Play of full movie/TV show, this is a huge task and I need more knowlegde in it to stream video.
- Fetching data using async instead of completion handlers.


## 🧑🏻 Author

**Kailash Bora**

- 🌌 [Profile](https://github.com/fabulouiOS-monk "Kailash Bora")

- 🏮 [Email](mailto:kailashbora007@gmail.com?subject=Hi%20from%20<repo-email> "Hi!")




**NOTE:** *This project is only for self learning purpose. It is not suitable for commercial use.*
<p align="center">💙 If you like this project, Give it a ⭐ and Share it with friends!</p>

