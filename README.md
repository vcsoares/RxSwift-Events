# RxSwift-Events ![](https://img.shields.io/badge/iOS-13.0-brightgreen)
- [Description](#description)
- [Installation](#installation)
- [Dependencies](#dependencies)

## Description
Simple event tracker app, coded as an RxSwift programming exercise. 
Fetching and posting data is done almost entirely through a custom-made networking client powered by RxSwift, except for remote images downloaded through Kingfisher. 
The app's internal structure follows an MVVM approach, with view components being bound to values passed from their ViewModels and aware of the view's current state.

<p float="left">
<img width="230" alt="Event list" src="https://user-images.githubusercontent.com/13265148/100386238-93f0d080-3003-11eb-8a60-d0c404a5df63.png">
<img width="230" alt="Event details" src="https://user-images.githubusercontent.com/13265148/100386223-8dfaef80-3003-11eb-83f5-dd6f96ba6019.png">
<img width="230" alt="Event details (continued)" src="https://user-images.githubusercontent.com/13265148/100386233-92bfa380-3003-11eb-82f8-61b41b1d4c58.png">
<img width="230" alt="Checkin confirmation" src="https://user-images.githubusercontent.com/13265148/100386235-93f0d080-3003-11eb-885f-2e03750515cf.png">
</p> 

## Installation
This project uses CocoaPods for dependency management.
Before opening it, run the following command on the project's directory to install all necessary dependencies:
```
$ pod install
```
When it finishes running, open the project's **.xcworkspace** file.

## Dependencies
- **Quick**
- **Nimble**
- **RxSwift**
- **Kingfisher**
