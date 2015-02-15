/*
OpenCV based height marker.

	1. Run 
	HeightMarker.exe cam01.avi cam01.txt

	2. Keys
	Space: play/pause
	A: go backward by 1 frame
	D: go foreward by 1 frame
	Q: go backward by 30 frame
	E: go backward by 30 frame
	V: show marking result
	S: save current mark
	V+F: save marks to file

 (C) 2015 Shengzhe Li <lishengzhe@gmail.com>

This code is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License version 2 as
published by the Free Software Foundation.
*/

#include "stdafx.h"

#include <iostream>
#include <fstream>
#include <stdlib.h>

#include "VinUtils.h"

#include "opencv2/core/core.hpp"
#include "opencv2/imgproc/imgproc.hpp"
#include "opencv2/video/video.hpp"
#include "opencv2/highgui/highgui.hpp"


using namespace cv;
using namespace std;

string videoFileName, heightFileName;

Mat rawFrame, overlayFrame;

int step = 30;
int prevFrame, currentFrame, totalFrames;
char inputKey, currentAction;
VideoCapture inputVideo;

int x, y, w, h, cols, rows;

Point pt1, pt2;
float subjectHeight=-1;

struct HeightMarker 
{
	int frameNo;
	Point pt1, pt2;//head, feet points
	float subjectHight;//in centi-meter.
};

vector<HeightMarker> heightMakerList;

void DrawFileSave(Mat* overlay)
{
		putText(*overlay, "File saved!" ,Point(40,65),  FONT_HERSHEY_SIMPLEX, 0.7, Scalar(0,255,0),1.5);
}

void SaveMarkerLog(string heightFileName, vector<HeightMarker> heightList)
{
	ofstream heightFile;
	heightFile.open (heightFileName, fstream::in | fstream::out | ofstream::app );
	
	
			heightFile << "Frame"  << "\t";
			heightFile << "Head.X" << "\t" << "Head.Y" << "\t";
			heightFile << "Feet.X" << "\t" << "Feet.Y" << "\t";			
			heightFile << "Height" << "\n";

	HeightMarker hMarker;
	for (int i=0;i<heightList.size();i++)
		{
			hMarker = heightList.at(i);

			heightFile  << hMarker.frameNo << "\t";
			heightFile  << hMarker.pt1.x << "\t" << hMarker.pt1.y << "\t";
			heightFile  << hMarker.pt2.x << "\t" << hMarker.pt2.y << "\t";			
			heightFile  << hMarker.subjectHight << "\n";
		}

	heightFile <<"\n";	
	heightFile.close();

	DrawFileSave(&overlayFrame);

}

void LoadMarkerLog(string heightFileName, vector<HeightMarker>* heightMakerList)
{

	ifstream heightFile;

	char temp[100];
	heightFile.open (heightFileName, fstream::in);
	
	heightFile.getline(temp,100);
	
	while (heightFile.good())
		{
			HeightMarker hMarker;

			heightFile >> hMarker.frameNo;
			heightFile >> hMarker.pt1.x >> hMarker.pt1.y ;
			heightFile >> hMarker.pt2.x >> hMarker.pt2.y ;
			heightFile >> hMarker.subjectHight;

			(*heightMakerList).push_back(hMarker);
		}

	heightFile.close();
}

void onTrackbar(int trackPos, void*)
{
	if (trackPos!=prevFrame+1)
	{
		inputVideo.set(CV_CAP_PROP_POS_FRAMES,currentFrame);		
	}
	prevFrame = currentFrame;
}

void DrawMarker(Mat* overlay, Point pt1, Point pt2)
{		
		circle(*overlay,pt1,5,Scalar(0,255,0),1,CV_AA);
		circle(*overlay,pt2,5,Scalar(0,255,0),1,CV_AA);
		line(*overlay,pt1,pt2,Scalar(0,255,0),1,CV_AA);
		//rectangle(*overlay,pt1,pt2,Scalar(0,255,0));
}

void DrawSubjectHeight(Mat* overlay, int actionlabel)
{
		char txtBuffer[50];

		sprintf (txtBuffer, "Subject Height(cm) is %d.",actionlabel);

		putText(*overlay, txtBuffer ,Point(40,40),  FONT_HERSHEY_SIMPLEX, 0.7, Scalar(0,255,0),1.5);
}

void DrawMarkerSave(Mat* overlay)
{
		putText(*overlay, "Marker saved!" ,Point(40,65),  FONT_HERSHEY_SIMPLEX, 0.7, Scalar(0,255,0),1.5);
}

float GetCurrentSubjectHeight()
{
	while (subjectHeight<0)
	{
		cout<<"Enter subject height(cm): "<<endl;
		cin>>subjectHeight;
	}
	return subjectHeight;
}

bool IsLastFrame()
{
	if(currentFrame>totalFrames-1)
	{
		currentFrame = totalFrames-1;
		setTrackbarPos("Frame",videoFileName, currentFrame);
		currentAction = (inputKey=waitKey( 0 ))==' '?'0':inputKey;
		return true;
	}
	return false;
}

void ShowCurrentFrame()
{
	setTrackbarPos("Frame",videoFileName, currentFrame);
	inputVideo >> rawFrame ;
	if (rawFrame.empty()) return;
	printf("Current Frame: %d \n", currentFrame);
	imshow(videoFileName,rawFrame);
}

void onMouse( int event, int x, int y, int flags, void*)
{
	if( event == CV_EVENT_LBUTTONUP && !(flags & 	CV_EVENT_FLAG_LBUTTON) )
	{
		if (x>cols-1)
			x=cols-1;
		if (y>rows-1)
			y=rows-1;
		pt2 = cvPoint(x,y);


		HeightMarker hMarker;
		hMarker.frameNo=currentFrame;
		hMarker.pt1=pt1;
		hMarker.pt2=pt2;
		hMarker.subjectHight=GetCurrentSubjectHeight();

		rawFrame.copyTo(overlayFrame);
		DrawMarker(&overlayFrame, pt1, pt2);
		DrawSubjectHeight(&overlayFrame, subjectHeight);
		imshow(videoFileName,overlayFrame);

		char inputKey = waitKey( 0 );
		if ( inputKey == 's' ) //save marker
		{
			heightMakerList.push_back(hMarker);
			rawFrame.copyTo(overlayFrame);
			DrawMarker(&overlayFrame, pt1, pt2);
			DrawSubjectHeight(&overlayFrame, subjectHeight);
			DrawMarkerSave(&overlayFrame);
			imshow(videoFileName,overlayFrame);
		}

	}
	else if( event == CV_EVENT_LBUTTONDOWN )
	{
		pt1 = cvPoint(x,y);
		pt2 = cvPoint(x,y);
	}
	else if( event == CV_EVENT_MOUSEMOVE && (flags & CV_EVENT_FLAG_LBUTTON) )
	{
		if (x>cols-1)
			x=cols-1;
		if (y>rows-1)
			y=rows-1;
		pt2 = cvPoint(x,y);

		rawFrame.copyTo(overlayFrame);
		DrawMarker(&overlayFrame, pt1, pt2);
		imshow(videoFileName,overlayFrame);

	}else if( event == CV_EVENT_RBUTTONUP && !(flags & CV_EVENT_FLAG_RBUTTON) )
	{
		pt1 = cvPoint(0,0);
		pt2 = cvPoint(0,0);

		imshow(videoFileName,rawFrame);
	}
}

void onKeyboard()
{
	switch(currentAction)
		{
		case '0':
			//play
			currentFrame+=1;
			if(IsLastFrame())
				break;
			ShowCurrentFrame();
			break;

		case ' ':
			//pause
			currentAction = (inputKey=waitKey( 0 ))==' '?'0':inputKey;
			break;

		case 'q':
			//back 30 frames
			currentFrame-=step;
			ShowCurrentFrame();
			currentAction = (inputKey=waitKey( 0 ))==' '?'0':inputKey;
			break;

		case 'e':
			//foreward 30 frames
			currentFrame+=step;
			if(IsLastFrame())
				break;
			ShowCurrentFrame();
			currentAction = (inputKey=waitKey( 0 ))==' '?'0':inputKey;
			break;
			
		case 'a':
			//back 1 frames
			currentFrame-=1;
			ShowCurrentFrame();
			currentAction = (inputKey=waitKey( 0 ))==' '?'0':inputKey;
			break;

		case 'd':
			//foreward 1 frames
			currentFrame+=1;
			if(IsLastFrame())
				break;
			ShowCurrentFrame();
			currentAction = (inputKey=waitKey( 0 ))==' '?'0':inputKey;
			break;

		case 'v':
			//show marks
			rawFrame.copyTo(overlayFrame);
			for (int i=0;i<heightMakerList.size();i++)
				DrawMarker(&overlayFrame, heightMakerList.at(i).pt1, heightMakerList.at(i).pt2);

			imshow(videoFileName,overlayFrame);			
			if ((inputKey=waitKey( 0 ))=='f')
			{	
				//save as file
				SaveMarkerLog( heightFileName, heightMakerList);
				imshow(videoFileName,overlayFrame);
			}
			currentAction = (inputKey=waitKey( 0 ))==' '?'0':inputKey;
			break;

		default:
			currentAction='0';
		}
}

int main( int argc, char** argv )
{
	if (argc != 3)
	{
		cout << "Not enough parameters" << endl;
		return -1;
	}

	videoFileName = argv[1];           // the videoFileName file name
	heightFileName = argv[2];

	inputVideo.open(videoFileName);
	if (!inputVideo.isOpened())
	{
		cout  << "Could not open the input video: " << videoFileName << endl;
		return -1;
	}

	heightMakerList = vector<HeightMarker>();
	LoadMarkerLog(heightFileName, &heightMakerList);
	if (heightMakerList.size()>0)
		subjectHeight = heightMakerList.at(0).subjectHight;

	rows=(int)inputVideo.get(CV_CAP_PROP_FRAME_HEIGHT);
	cols=(int)inputVideo.get(CV_CAP_PROP_FRAME_WIDTH);
	
	currentFrame = 0;
	totalFrames = inputVideo.get(CV_CAP_PROP_FRAME_COUNT);

	namedWindow(videoFileName, CV_WINDOW_NORMAL);
	createTrackbar("Frame", videoFileName, &currentFrame, totalFrames, onTrackbar);
	setMouseCallback(videoFileName,onMouse);


	inputKey='0';
	currentAction='0';
	
	for(;;)
	{	

		onKeyboard();

		inputKey=waitKey( 1 );			
		if (inputKey!=-1) //have a keyboard input
			currentAction=inputKey;
		if ( currentAction == 27 ) //esc
			break;		
	}	
	return 0;
}

