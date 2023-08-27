# flutter_location_map_widgets_class_1
### Map setup 
Use package google_maps_flutter
Readme in google maps flutter package(documentation)

Set the minSdkVersion in android/app/build.gradle:

android {
    
    compileSdkVersion 33 //default is 16
    



    defaultConfig {
      
        minSdkVersion 20 //default is 16
        targetSdkVersion 33
        
    }

   
}

### Put API inside Manifest file

<manifest 
  <application 
    <meta-data android:name="com.google.android.geo.API_KEY"
               android:value="YOUR KEY HERE"/>

### OutPut

![map](https://github.com/hossain-eee/Ostad-Module-15-GoogleMap/assets/101991583/4e2d6532-107b-4e38-a94c-7087dae720c9)
