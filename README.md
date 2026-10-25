# DriveNow Car Rental App (Flutter)

## Included in this ZIP
- `app-debug.apk` — prebuilt Android debug APK for installation/testing
- `lib/main.dart` — Flutter app source
- `pubspec.yaml` — Flutter package configuration
- `.gitignore`

## App features
- Demo login using name and email
- Six sample cars with photos, seats, fuel, type, rating, hourly and daily rates
- Instant Booking and Pre-Booking options
- Booking dates/times, payment method selection and confirmation dialog
- Booking history, mark drive completed, add/edit rating and feedback
- Profile/address, Settings, notification toggle, dark-mode toggle and logout

## Important demo notes
- Payment is simulated; the app does not charge money.
- Data is stored in memory and is cleared when the app restarts.
- Car photos need an internet connection.
- Sample rates and car information are illustrative.

## Run the source on Windows
1. Install Flutter and Android Studio, and make sure `flutter doctor` works.
2. Extract this ZIP and open PowerShell in the `DriveNow_Car_Rental_App` folder.
3. Run:

```powershell
flutter create --platforms=android .
flutter pub get
flutter run
```

To rebuild the debug APK:

```powershell
flutter build apk --debug
```

APK output: `build\app\outputs\flutter-apk\app-debug.apk`

Note: This source ZIP includes the Dart code and package configuration, but not the generated Android/Gradle platform folders. Run `flutter create --platforms=android .` as shown above to generate them.
