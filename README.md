### CCVS: Camera Calibration for Video Surveillance Toolbox

A matlab toolbox for easy camera calibration in video surveillance. (a paper about this method can be found at http://jivp.eurasipjournals.springeropen.com/articles/10.1186/s13640-015-0086-1, the slides can be found at  http://www.slideshare.net/EdisonLee1/li2014-calibration )

![Concept of CCVS toolbox](https://github.com/lishengzhe/ccvs/blob/master/wiki-images/ccvs-concept.png)

#### Introduction
Most cameras for video surveillance are installed in high positions with a slightly tilted angle. In such installation, it is possible to retain only three calibration parameters in the original camera model, namely the focal length (f), tilting angle (theta) and camera height (c). These parameters can be directly solved by a nonlinear curve fitting using the observed head and foot points of a walking human. This toolbox privdes several functions and sample data needed to demonstrate this method.

#### List of scripts (demo)
Calibrating camera using head/foot points data
 - CalibrationDemo.m

Evaluating performance of calibration and height estimation
 - CrossValidationY.m - using Y only
 - CrossValidationYd.m - using Y only (distortion corrected)
 - CrossValidationXY.m - using X and Y
 - CrossValidationXYd.m - using X and Y (distortion corrected)

Demonstrating distortion correction
 - UndistortionDemo.m

#### List of functions
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

#### Sample data
Sample data is under /data folder. 

#### Homepage
http://vision.inha.ac.kr


#### License
This code is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License version 2 as
published by the Free Software Foundation.

(C) 2015 Shengzhe Li <lishengzhe@gmail.com>



[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/lishengzhe/ccvs/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

