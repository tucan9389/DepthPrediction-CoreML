# DepthPrediction-CoreML

![platform-ios](https://img.shields.io/badge/platform-ios-lightgrey.svg)
![swift-version](https://img.shields.io/badge/swift-5.0-red.svg)
![lisence](https://img.shields.io/badge/license-MIT-black.svg)

This project is Depth Prediction on iOS with Core ML.<br>If you are interested in iOS + Machine Learning, visit [here](https://github.com/motlabs/iOS-Proejcts-with-ML-Models) you can see various DEMOs.<br>

| Screenshot 1 | Screenshot 2 | Screenshot 3 | Screenshot 4 |
| ------------ | ------------ | ------------ | ------------ |
| ![](resource/IMG_3611.PNG) | ![](resource/IMG_3612.PNG) | ![](resource/IMG_3613.PNG) | ![](resource/IMG_3614.PNG) |

## How it works

> (Preparing...)

## Requirements

- Xcode 10.2+
- iOS 11.0+
- Swift 5

## Model

### Download

Download model from [apple's model page](https://developer.apple.com/machine-learning/models/).

### Matadata

|            | input node    | output node    |   size   |
| :--------: | :-----------: | :------------: | :----: |
| FCRN     | `[1, 304, 228, 3]`<br>name: `image` | `[1, 128, 160]`<br>name: `depthmap` | 254.7 MB |
| FCRNFP16 | `[1, 304, 228, 3]`<br>name: `image` | `[1, 128, 160]`<br>name: `depthmap` | 127.3 MB |

### Inference Time

> (Preparing...)


## See also

- [motlabs/iOS-Proejcts-with-ML-Models](https://github.com/motlabs/iOS-Proejcts-with-ML-Models)<br>
  : The challenge using machine learning model created from tensorflow on iOS
- [iro-cp/FCRN-DepthPrediction](https://github.com/iro-cp/FCRN-DepthPrediction)<br>
  : The repository prividing FCRN-DepthPrediction model
