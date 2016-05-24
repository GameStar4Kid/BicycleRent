1. Install & Configure

- XCode 7.3
- Swift 2.2
- iOS 8 or above
- CocoaPods
- Node.js
- Configuration
	+ Open Terminal and move to source folder
	+ run "pod install"
2. Prepare source

- Open push-demo.xcworkspace
- Build with device or simulator
- Start server with node.js

3. Limitation and Missing Requirement

- ***IMPORTANT*** There are a open source bug with CardIO in <Card Number Text Field> in Payment Scene, when open Payment screen sometimes it can not load Payment screen, we need delete <Card Number Text Field> and build again, then restore <Card Number Text Field> and build, it will work correct, this should be fixed in next version.

- Not add unit test
- Not add UI automation test
- Not add open source license in app yet (Example: CardIO (BSD license))
- Credit card information is validated
- UI is not very good 
- Not fix warning
- Not move configuration text to file (Example: server url, Google Map Key...)
- bundle: <tutorial.feedme.com> is mapping with Google Map key: <AIzaSyDwl6JCN5s6Jpu8N-wWQAnQZgjD1oF_z4o>
- Not add icon app and launch screen
- Not check network problem
- Not document all features in source

4. Feedback
- Jitensha-RestfulApi.pdf is not correct with API rent
it should be POST, not GET

5. Open source

'MBProgressHUD', '~> 0.9.2'
'Alamofire', '~> 3.4'
'SwiftyJSON', :git => 'https://github.com/SwiftyJSON/SwiftyJSON.git'
'AlamofireObjectMapper', '~> 3.0'
'GoogleMaps', '~> 1.10.4'
'CardIO'
'Caishen'

6. Problems and Solutions
	- Can not detect action when touch button Rent in MapViewController
		-> Solution: we can catch user touch into whole window info -> it should be improved
	- PaymentContrller storyboard is error with <Card Number Text Field>(open source bug)
		-> Solution: delete <Card Number Text Field> and build, then restore that item and build.
		Can not understand why this happen, but I think we should try an other solution, do not need use CardIO, because requirement don't include validate credit card information.

7. Demo


[![Demo](https://j.gifs.com/wpll5m.gif)](https://www.youtube.com/watch?v=89MeaELIlG8)
