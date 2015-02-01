# ccvs
Camera Calibration for Video Surveillance Toolbox
A paper about this method is under review

# Introduction
Most cameras for video surveillance are installed in high positions with a slightly tilted angle. In such installation, it is possible to retain only three calibration parameters in the original camera model, namely the focal length (f), tilting angle (theta) and camera height (c). These parameters can be directly solved by a nonlinear curve fitting using the observed head and foot points of a walking human. This toolbox privdes several functions and sample data needed to demonstrate this method.

# List of scripts
Calibrating camera using head/foot points data
 - CalibrationDemo.m

Evaluating performance of calibration and height estimation
 - CrossValidationY.m - using Y only
 - CrossValidationYd.m - using Y only (distortion corrected)
 - CrossValidationXY.m - using X and Y
 - CrossValidationXYd.m - using X and Y (distortion corrected)

Demonstrating distortion correction
 - UndistortionDemo.m

# List of functions
For given foot points, compute head points
 - FootToHeadY.m - using Y only 
 - FootToHeadXY.m - using X and Y
 - FootToHeadXYd.m - using X and Y (distortion corrected)

For given foot and head points, compute human height
 - PointsToHeightY.m

Distort or undistort image
 - DistortImage.m
 - UndistortImage.m

Distort or undistort points
 - DistortPoints.m
 - UndistortPoints.m

# Sample data
Sample data is under /data folder. 
