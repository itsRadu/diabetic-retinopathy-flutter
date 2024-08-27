# Diabetic Retinopathy Flutter

This project is a Flutter application designed to detect diabetic retinopathy using deep learning models. The model leverages TensorFlow for image classification, specifically trained to identify different stages of diabetic retinopathy.

## Table of Contents

- [Introduction](#introduction)
- [Features](#features)
- [Dataset](#dataset)
- [Installation](#installation)
- [Model Training](#model-training)
- [Usage](#usage)
- [Contributing](#contributing)
- [License](#license)

## Introduction

Diabetic retinopathy is a serious eye condition caused by diabetes that can lead to blindness if untreated. Early detection and classification are key to preventing vision loss. This application uses a convolutional neural network (CNN) model to detect diabetic retinopathy from retina images and is integrated with a Flutter interface.

## Features

- Image classification for diabetic retinopathy detection.
- Model integration with TensorFlow Lite for efficient inference.
- Flutter-based UI for cross-platform accessibility (Android, iOS).
- Pretrained model included (.h5 and .tflite).

## Dataset

The dataset used for this project is from [Kaggle](https://www.kaggle.com/datasets/sovitrath/diabetic-retinopathy-224x224-2019-data) and contains retina images categorized by the severity of diabetic retinopathy. The images are resized to 224x224 pixels for training and testing.

- **Number of Images**: 3662
- **Categories**: No DR, Mild, Moderate, Severe, Proliferative DR

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/diabetic-retinopathy-flutter.git
   cd diabetic-retinopathy-flutter
2. Install the necessary Flutter dependencies:
   ```bash
   flutter pub get
3. Ensure you have Flutter and Dart SDK installed. You can check by running:
   ```bash
   flutter doctor
4. Download the dataset from Kaggle and place it in the project directory.
   
## Model Training

The model is trained using a Jupyter notebook (DRD.ipynb) available in this repository. The training process involves:

- Data preprocessing (resizing, normalization).
- Building a CNN model using TensorFlow/Keras.
- Training and validation on the provided dataset.
- Saving the model as .h5 and converting it to .tflite for integration into the Flutter app.

To train the model:

1. Open the DRD.ipynb notebook.
2. Follow the steps for data loading, model building, and training.
3. Once trained, the model is saved as dr_model.h5 and dr_model.tflite.
   
Or use [Google Colab](https://colab.research.google.com/drive/1rSKSbm6Qe4A5JmH6I27pZ1FHTglkYplK?usp=sharing)
## Usage
To run the Flutter application:
1. Connect your device or start an emulator.
2. Use the following command:
   ```bash
   flutter run
The app allows users to upload retina images and get a prediction regarding the severity of diabetic retinopathy.
## Contributing
Contributions are welcome! Please fork the repository and submit a pull request with your changes. You can also open an issue if you encounter any bugs or have feature suggestions.
## License
This project is licensed under the MIT License. See the LICENSE file for details.

