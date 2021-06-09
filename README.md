# DepthPrediction-CoreML Variant
### By: Neel Dhulipala, Mario Gergis, and Merwan Yeditha
### Adapted from tucan9389

An implementation of the FCRN CoreML library created by tucan9389 and modified for obstacle detection and dynamic feedback based on distance of objects. The purpose of this fork is to focus the project more on object detection while moving.

This app contains multiple presets for ways to process the image, each of which contain two views. One is a preview of the camera output, and the bottom image is the resultant matrix of distances after processing the top image through the FCRN neural network. Our additions to this application currently include:

- Haptic and audio feedback based on distances of objects
- Readout of distance value at top of screen
- Other usability features
