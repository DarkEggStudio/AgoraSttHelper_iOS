# AgoraSttHelper

[![CI Status](https://img.shields.io/travis/darkzero/AgoraSttHelper.svg?style=flat)](https://travis-ci.org/darkzero/AgoraSttHelper)
[![Version](https://img.shields.io/cocoapods/v/AgoraSttHelper.svg?style=flat)](https://cocoapods.org/pods/AgoraSttHelper)
[![License](https://img.shields.io/cocoapods/l/AgoraSttHelper.svg?style=flat)](https://cocoapods.org/pods/AgoraSttHelper)
[![Platform](https://img.shields.io/cocoapods/p/AgoraSttHelper.svg?style=flat)](https://cocoapods.org/pods/AgoraSttHelper)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

AgoraSttHelper is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'AgoraSttHelper'
```

## Functional interface

### At first

**Modify the AgoraConfig.plist**  
Rename the AgoraConfig.plist.sample to AgoraConfig.plist  
Fill your Agora App Id in ```agoraAppId```  
Because the STT should call agora RESTful API, you must fill the in ```agoraApiAuth.authKey``` and ```agoraApiAuth.authSecret```  

### Get singlton instance

### Load config

## Author

darkzero, darkzero_mk2@hotmail.com

## License

AgoraSttHelper is available under the MIT license. See the LICENSE file for more info.
