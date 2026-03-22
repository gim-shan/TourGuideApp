# Tour Guide App

A Flutter mobile application for travelling across Sri Lanka while focusing on local guides.

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes.

## Prerequisites

What things you need to install the software and how to install them:

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (latest stable version)
- [Dart SDK](https://dart.dev/get-dart) (comes with Flutter)
- [Android Studio](https://developer.android.com/studio) or [VS Code](https://code.visualstudio.com/) with Flutter/Dart plugins
- [Git](https://git-scm.com/downloads)
- [Node.js](https://nodejs.org/) (for running the local server)

## Installation

1. Clone the repository:

   ```bash
   git clone https://github.com/yourusername/TourGuideApp.git
   cd TourGuideApp
   ```

2. Install Flutter dependencies:

   ```bash
   flutter pub get
   ```

3. Get your local IP address:

   ```bash
   ipconfig
   ```

   Note the IPv4 Address (e.g., `192.168.x.x`) - you'll need it for running the local server.

4. Install server dependencies:

   ```bash
   cd functions
   npm install
   ```

5. Configure environment variables (if applicable):
   - Create a `.env` file in the root directory
   - Add your API keys and other environment variables

## Running the Application

### Running the Server (Local)

To run the server locally (required for the app to function properly):

```bash
cd functions
npm install
npm start
```

The server will start on port 3000 (or as configured).

### Running the Flutter App

To run the Flutter application in development mode:

```bash
flutter run
```

### Specific Device

To run on a specific device:

```bash
flutter devices  # List available devices
flutter run -d <device-id>
```

### Building for Production

#### Android

```bash
flutter build apk --release
```

The release APK will be located at `build/app/outputs/flutter-apk/app-release.apk`

For a universal APK:

```bash
flutter build apk --split-per-abi
```

#### iOS

```bash
flutter build ios --release
```

## Common Issues and Solutions

### 1. Dependencies Error

If you encounter dependency issues, run:

```bash
flutter clean
flutter pub get
```

### 2. Gradle Sync Issues (Android)

- Make sure you have the latest Android SDK and build tools
- Check that `ANDROID_HOME` environment variable is set correctly
- In Android Studio, try File > Invalidate Caches and Restart

### 3. iOS Build Issues

- Run `pod install` in the `ios/` directory
- Ensure Xcode command line tools are up to date: `sudo xcode-select --install`
- Check iOS deployment target in Xcode

## Additional Configuration

### Assets

The app uses various assets located in the `assets/` folder. Make sure all required assets are present:

- `assets/images/` - Contains images used in the app
- `assets/icons/` - Contains app icons

### Platform-specific Settings

- Android: Check `android/app/build.gradle` for minSdkVersion and targetSdkVersion
- iOS: Check `ios/Runner.xcodeproj/project.pbxproj` for deployment target

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## Versioning

We use [SemVer](http://semver.org/) for versioning. For the versions available, see the [tags on this repository](https://github.com/yourusername/TourGuideApp/tags).

## Authors

- **Developer** - _Initial work_

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details.

## Acknowledgments

- Hat tip to anyone whose code was used
- Inspiration
- etc
