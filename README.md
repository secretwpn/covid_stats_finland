# COVID-19 Stats Finland

The app has 2 main screens: confirmed and hospitalized:
 - Confirmed screen shows stats of confirmed COVID-19 cases in Finland
 - Hospitalized screen shows distribution of people in ward (on date) / intensive care (on date) / dead (to date, total)

<img src="./assets/img/screen_confirmed_cumulative_selection.png" width="320" />
<img src="./assets/img/screen_confirmed_daily_selection.png" width="320" />
<img src="./assets/img/screen_hospitalized_selection.png" width="320" />
<img src="./assets/img/screen_hospitalized_selection_dark.png" width="320" />
<img src="./assets/img/screen_info_dark.png" width="320" />

## Data

The app is using open data obtained from [HS-Datadesk](https://github.com/HS-Datadesk/koronavirus-avoindata), which is publishing processed data from [THL (Terveyden ja hyvinvoinnin laitos)](https://thl.fi/)

# Platform support

The app is tested to run on Android, iOS and macOS, but should also work on Windows and Linux after necessary adjustments.

# App distribution

Small scale COVID-19 related apps are not allowed to be distributed through Google Play, and this app is no exception.

Self signed release build is available here: [app-release.apk](https://github.com/secretwpn/covid_stats_finland/raw/master/apk/app-release.apk)

# Development

This is a [Flutter](https://flutter.dev/) app.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Dev cheatsheet

### iOS
- set up your Apple developer account in Xcode (create one if you don't have it yet)
- follow these [steps](https://flutter.dev/docs/deployment/ios)
- should security errors arise upon running the app on your iPhone - go to your iPhone `Settings -> General -> Device management` and trust the developer (your Apple developer account) of the app you're trying to run

### macOS

- follow these [steps](https://flutter.dev/desktop) until `flutter run -d macOS` command
- add following lines to both files
  - `macos/Runner/Release.entitlements`
  - `macos/Runner/DebugProfile.entitlements`
  - ```
    <key>com.apple.security.network.server</key>
    <true/>
    <key>com.apple.security.network.client</key>
    <true/>
    ```
- run the app `flutter run -d macOS`