[![Build Status](https://www.bitrise.io/app/e1499563e5fd3274.svg?token=CM9pQl0-pkc7GPfEKd8LfA&branch=master)](https://www.bitrise.io/app/e1499563e5fd3274)
[![codecov](https://codecov.io/gh/regnerjr/AnotherFeedlyApp/branch/master/graph/badge.svg)](https://codecov.io/gh/regnerjr/AnotherFeedlyApp)
# Pretty much just a Feedly App

You can use this app (when it's finished) to browse and read Blogs and stuff.
The real value here is, the setup, the tools and the architectural patterns we are trying out here. I really felt that I need a full working app where I could really experment with things, and perhaps we'll get to the point where we can extract out some nice frameworks and things.

## Tools

### Code Gen
* [SwiftGen](https://github.com/AliSoftware/SwiftGen) - Compile time generation of Storyboard and Image Constants.
* [Cocoapods-Keys](https://github.com/orta/cocoapods-keys) - Manages Keys and app secrets, without commiting them to `git`.

### Continuous Integration
* [Bitrise](http://bitrise.io)
* Danger
* Swiftlint
* Hound

### Actual Code Things

Use a separate `UIApplicationDelegate` for testing.

Actually write some tests.

Use coordinators, to manage your view controllers.

Turn on all the warnings.


