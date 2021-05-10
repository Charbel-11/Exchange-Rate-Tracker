# iOS Platform

## How to Run
- Xcode 12 or later to build the project
- Simulator or physical iPhone device running iOS 14.0 or later

## Technologies Used
- UIKit is used to build the GUI components
- [Charts](https://github.com/danielgindi/Charts) is used for the exchange rate multi-line graph
- Swift Package Manager (SPM) for the Charts dependency

The backend component also needs to be running locally since it currently isn't deployed, refer to the corresponding README for running instructions.

# Project Structure
![Project File Structure](https://github.com/OmarKhodr/exchange-rate/blob/main/ios/project-structure.png)

## Networking

### `Voyage.swift`
Custom generic class created to simplify making networking calls by specifying the types of the expected decoded JSON response as well as that of the body in case it is a POST request.

### `Graph.swift`
Class that creates `ChartDataEntry` values out of the raw dates returned by the API to be displayed by the graph.

## Views
Custom views that are written separately to facilitate reuse. It includes:
- `FilledButton.swift`
- `BoldBorderlessTextField.swift`
- `ListButton.swift`
- `GraphView.swift`

among others.

## View Controllers

### `ExchangeViewController.swift`
Initial view controller of the application created through `SceneDelegate.swift` whose `didFinishLaunchingWithOptions` function is called when the app loads. This view contains the exchange rates and graph and contains the navigation methods to the other views in the app.

### `AuthenticationViewController.swift`
View controller used for both login and signup functionality with parameters to be passed through the constructor determining which functionality to provide when shown.

### `DetailedStatisticsViewController.swift`
View controller that shows `StatisticsView.swift` as the header view for the transactions table view that displays past transactions.





