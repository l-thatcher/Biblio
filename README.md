Version 1.0.1

How to build/run
Android
- set up flutter on your pc
- open an android emulator
- clone the project and run "flutter run" in the folder from terminal
- the application will open in the connected emulator

IOS
- set up flutter on your Mac
- clone the project and run "flutter create ." in the folder from terminal
- open the runner.xcodeworkspace file from within the IOS folder
- right click on runner and click add file, add the googleservices.plist from the google-services_InfoPlist_podfile folder
- in the Runner folder replace the info.plist with the one from the google-services_InfoPlist_podfile folder
- replace the podfile that is in IOS with the one from the google-services_InfoPlist_podfile folder
- open an IOS simulator
- run "flutter run" in the folder from terminal
- the application will open in the connected simulator

Chrome
- set up flutter on your pc
- clone the project and run "flutter run" in the folder from terminal
- the application will open in your preferred browser

No assumptions have been made

Frameworks
- flutter - https://flutter.dev/ - chose to use flutter as it is intuitive to use, works natively with any device and is bassed on java.
Languages
- dart and java - https://dart.dev/guides, https://docs.oracle.com/en/java/
Libraries
- firebase_auth - https://pub.dev/packages/firebase_auth
- firebase_storage - https://pub.dev/packages/firebase_storage
- cloud_firestore - https://pub.dev/packages/cloud_firestore
these libraries are used for firebase connection  

- firestore_search - https://pub.dev/packages/firestore_search
- flutter_keyboard_visibility - https://pub.dev/packages/flutter_keyboard_visibility
- flutter_masked_text2 - https://pub.dev/packages/flutter_masked_text2
- dropdown_plus - https://pub.dev/packages/dropdown_plus
these libraries are used to help with the user interface, they helped to solve common problems efficiently saving time with coding and providing a tested solution
  
- google_sign_in - https://pub.dev/packages/google_sign_in
- flutter_facebook_auth - https://pub.dev/packages/flutter_facebook_auth
- twitter_login - https://pub.dev/packages/twitter_login
These libraries are sued for the third party sign in features

- dcdg - https://pub.dev/packages/dcdg - I used dcdg to develop a puml diagram of my application