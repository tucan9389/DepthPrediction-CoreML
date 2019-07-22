# DepthPrediction-CoreML

![platform-ios](https://img.shields.io/badge/platform-ios-lightgrey.svg)
![swift-version](https://img.shields.io/badge/swift-5.0-red.svg)
![lisence](https://img.shields.io/badge/license-MIT-black.svg)

This project is Depth Prediction on iOS with Core ML.<br>If you are interested in iOS + Machine Learning, visit [here](https://github.com/motlabs/iOS-Proejcts-with-ML-Models) you can see various DEMOs.<br>

| GIF demo 1 | Screenshot 1 | Screenshot 2 | Screenshot 3 | Screenshot 4 |
| ------------ | ------------ | ------------ | ------------ | ------------ |
| ![](resource/IMG_0129.gif) | ![](resource/IMG_3623.PNG) | ![](resource/IMG_3626.PNG) | ![](resource/IMG_3627.PNG) | ![](resource/IMG_3629.PNG) |

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

| Device        | Inference Time | Total Time |
| ------------- | :-----: | :-----: |
| iPhone XS Max | **146 ms** | 155 ms |
| iPhone XS     | **146 ms** | **151 ms** |
| iPhone XR     | 148 ms  | 154 ms  |
| iPhone X      | 624 ms  | 640 ms  |
| iPhone 8+     | 621 ms  | 634 ms  |
| iPhone 8      | 626 ms  | 639 ms  |
| iPhone 7+     | 595 ms  | 609 ms  |
| iPhone 7      | 612 ms  | 624 ms  |
| iPhone 6S+    | 1038 ms | 1051 ms |
| iPhone 6+     | 3290 ms | 3326 ms |


## See also

- [motlabs/iOS-Proejcts-with-ML-Models](https://github.com/motlabs/iOS-Proejcts-with-ML-Models)<br>
  : The challenge using machine learning model created from tensorflow on iOS
- [iro-cp/FCRN-DepthPrediction](https://github.com/iro-cp/FCRN-DepthPrediction)<br>
  : The repository prividing FCRN-DepthPrediction model
