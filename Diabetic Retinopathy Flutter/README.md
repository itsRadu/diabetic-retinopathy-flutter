
# Diabetic Retinopathy Flutter Application

This repository contains a cross-platform Flutter application that detects diabetic retinopathy using deep learning models integrated with TensorFlow Lite. The project is structured to support Android, iOS, web, and desktop platforms.

## Table of Contents

- [Introduction](#introduction)
- [Project Structure](#project-structure)
- [Setup and Installation](#setup-and-installation)
- [Model Integration](#model-integration)
- [Running the Application](#running-the-application)
- [Contributing](#contributing)
- [License](#license)

## Introduction

Diabetic retinopathy is a severe eye condition caused by diabetes. This application leverages a machine learning model to predict the severity of diabetic retinopathy from retina images. The Flutter application provides a user-friendly interface for uploading retina images and receiving predictions.

## Project Structure

The repository structure is as follows:

```
diabetic-retinopathy-flutter/
├── android/               # Android-specific code
├── assets/                # Images and other assets
├── ios/                   # iOS-specific code
├── lib/                   # Main Flutter application code (Dart files)
│   └── main.dart          # Entry point of the Flutter application
├── linux/                 # Linux-specific code
├── macos/                 # macOS-specific code
├── test/                  # Unit and widget tests
├── web/                   # Web-specific code
├── windows/               # Windows-specific code
├── .gitignore             # Git ignore file
├── README.md              # Project README file
├── analysis_options.yaml  # Linting rules
├── pubspec.lock           # Flutter dependencies lock file
├── pubspec.yaml           # Project dependencies and settings
└── .metadata              # Project metadata
```

## Setup and Installation

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/yourusername/diabetic-retinopathy-flutter.git
   cd diabetic-retinopathy-flutter
   ```

2. **Install Dependencies**:
   Run the following command to install all the necessary dependencies:
   ```bash
   flutter pub get
   ```

3. **Set Up Your Environment**:
   Ensure you have Flutter and the required SDKs installed. You can verify this by running:
   ```bash
   flutter doctor
   ```

## Model Integration

The project uses TensorFlow Lite for model inference. The pre-trained model files (`.h5` and `.tflite`) are stored in the root directory and are used to classify retina images.

- The model files:
  - `dr_model.h5` - Original Keras model.
  - `dr_model.tflite` - TensorFlow Lite model for mobile and embedded deployment.

The integration code is located in the `lib/` directory, where Flutter handles loading the model and processing image inputs.

## Running the Application

1. **Run on a connected device or emulator**:
   ```bash
   flutter run
   ```

2. **Build for a specific platform**:
   - **Android**: `flutter build apk`
   - **iOS**: `flutter build ios`
   - **Web**: `flutter build web`
   - **Windows**: `flutter build windows`

3. **Web Deployment**:
   You can host the web build on any static server like GitHub Pages or Firebase Hosting.

## Contributing

Contributions are welcome! Please fork the repository, create a feature branch, and submit a pull request. For major changes, please open an issue to discuss the proposed changes beforehand.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for more details.
