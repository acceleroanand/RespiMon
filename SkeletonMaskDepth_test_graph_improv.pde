/*
Anand Antony
 */

import java.util.ArrayList;
import KinectPV2.KJoint;
import KinectPV2.*;
import org.openkinect.processing.*;
import grafica.*;
import controlP5.*;

public GPlot plot;
public float avg_value;
public float depth_l_shoulder;
public float depth_r_shoulder;
Slider abc;
ControlP5 cp5;
public float frmpersec;


KinectPV2 kinect;
Kinect2 kinect2;


void setup() {
  size(1020, 780, P3D);
  
  
  

  kinect = new KinectPV2(this);

  //Enables depth and Body tracking (mask image)
  kinect.enableDepthImg(true);
  kinect.enableSkeletonDepthMap(true);
  kinect.enablePointCloud(true);

  kinect.init();
  
    plot = new GPlot(this);
  plot.setPos(0,424);
  plot.setDim(1000,250);
  plot.setYLim(0, 3500);
  plot.setTitleText("Breathing Rate Monitoring");
  plot.getXAxis().setAxisLabelText("time in ms");
  plot.getYAxis().setAxisLabelText("average distance from Chest in mm"); 
  plot.activateZooming();
  plot.activatePanning();
  
  
  noStroke();
  cp5 = new ControlP5(this);
  
    cp5.addSlider("slider")
     .setPosition(550,350)
     .setSize(200,20)
     .setRange(0,60)
     .setValue(30);
    cp5.getController("slider").getValueLabel().align(ControlP5.LEFT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
    cp5.getController("slider").getCaptionLabel().align(ControlP5.RIGHT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);

    

  
}


void draw() {
  background(0);
  frameRate(frmpersec);
  
  
  
  

  image(kinect.getPointCloudDepthImage(), 0, 0);

  //get the skeletons as an Arraylist of KSkeletons
  ArrayList<KSkeleton> skeletonArray =  kinect.getSkeletonDepthMap();

  //individual joints
  for (int i = 0; i < skeletonArray.size(); i++) {
    KSkeleton skeleton = (KSkeleton) skeletonArray.get(i);
    //if the skeleton is being tracked compute the skleton joints
    if (skeleton.isTracked()) {
      KJoint[] joints = skeleton.getJoints();

     color col  = skeleton.getIndexColor();
      fill(col);
      stroke(col);

      drawBody(joints);
        
    }
  }

  //fill(255, 0, 0);
  textSize(32);
  text("framerate "+frameRate+" fps", 550, 50);
  
  int nPoints =1000;
  GPointsArray points = new GPointsArray(nPoints);
  int i =millis();
  
  //plot.addPoint(i,frameRate);
  //points.add(i,frameRate);
  //i++;
  
  GPoint lastPoint = plot.getPointsRef().getLastPoint();

  if (lastPoint == null) {
    plot.addPoint(i, avg_value, "(" + str(millis()) + " , " + str(avg_value) + ")");
  } 
  else if (!lastPoint.isValid() || sq(lastPoint.getX() - i) + sq(lastPoint.getY() + avg_value) > 25000) {
    plot.addPoint(i,avg_value, "(" + i + " , " + str(avg_value) + ")");
  }

  // Reset the points if the user pressed the space bar
  if (keyPressed && key == ' ') {
    plot.setPoints(new GPointsArray());
  }
  
  
  
  //plot.moveHorizontalAxesLim(18);
  plot.beginDraw();
  plot.drawBackground();
  plot.drawBox();
  plot.drawXAxis();
  plot.drawYAxis();
  plot.drawTitle();
  plot.drawGridLines(GPlot.BOTH);
  plot.drawLines();
  plot.drawPoints();
  //plot.setPoints(points);
  plot.endDraw(); 
  
}





//draw the body
void drawBody(KJoint[] joints) {
  //drawBone(joints, KinectPV2.JointType_Head, KinectPV2.JointType_Neck);
  //drawBone(joints, KinectPV2.JointType_Neck, KinectPV2.JointType_SpineShoulder);
  //drawBone(joints, KinectPV2.JointType_SpineShoulder, KinectPV2.JointType_SpineMid);
  //drawBone(joints, KinectPV2.JointType_SpineMid, KinectPV2.JointType_SpineBase);
  drawBone(joints, KinectPV2.JointType_SpineShoulder, KinectPV2.JointType_ShoulderRight);
  drawBone(joints, KinectPV2.JointType_SpineShoulder, KinectPV2.JointType_ShoulderLeft);
  drawBone(joints, KinectPV2.JointType_SpineBase, KinectPV2.JointType_HipRight);
  drawBone(joints, KinectPV2.JointType_SpineBase, KinectPV2.JointType_HipLeft);

  // Right Arm
  //drawBone(joints, KinectPV2.JointType_ShoulderRight, KinectPV2.JointType_ElbowRight);
 // drawBone(joints, KinectPV2.JointType_ElbowRight, KinectPV2.JointType_WristRight);
  //drawBone(joints, KinectPV2.JointType_WristRight, KinectPV2.JointType_HandRight);
  //drawBone(joints, KinectPV2.JointType_HandRight, KinectPV2.JointType_HandTipRight);
  //drawBone(joints, KinectPV2.JointType_WristRight, KinectPV2.JointType_ThumbRight);

  // Left Arm
  //drawBone(joints, KinectPV2.JointType_ShoulderLeft, KinectPV2.JointType_ElbowLeft);
  //drawBone(joints, KinectPV2.JointType_ElbowLeft, KinectPV2.JointType_WristLeft);
  //drawBone(joints, KinectPV2.JointType_WristLeft, KinectPV2.JointType_HandLeft);
  //drawBone(joints, KinectPV2.JointType_HandLeft, KinectPV2.JointType_HandTipLeft);
  //drawBone(joints, KinectPV2.JointType_WristLeft, KinectPV2.JointType_ThumbLeft);

  // Right Leg
  //drawBone(joints, KinectPV2.JointType_HipRight, KinectPV2.JointType_KneeRight);
  //drawBone(joints, KinectPV2.JointType_KneeRight, KinectPV2.JointType_AnkleRight);
  //drawBone(joints, KinectPV2.JointType_AnkleRight, KinectPV2.JointType_FootRight);

  // Left Leg
  //drawBone(joints, KinectPV2.JointType_HipLeft, KinectPV2.JointType_KneeLeft);
  //drawBone(joints, KinectPV2.JointType_KneeLeft, KinectPV2.JointType_AnkleLeft);
  //drawBone(joints, KinectPV2.JointType_AnkleLeft, KinectPV2.JointType_FootLeft);

  //Single joints
  //drawJoint(joints, KinectPV2.JointType_HandTipLeft);
  //drawJoint(joints, KinectPV2.JointType_HandTipRight);
  //drawJoint(joints, KinectPV2.JointType_FootLeft);
  //drawJoint(joints, KinectPV2.JointType_FootRight);

  //drawJoint(joints, KinectPV2.JointType_ThumbLeft);
  //drawJoint(joints, KinectPV2.JointType_ThumbRight);

  //drawJoint(joints, KinectPV2.JointType_Head);
  
  drawRect(joints,KinectPV2.JointType_ShoulderLeft, KinectPV2.JointType_ShoulderRight,KinectPV2.JointType_SpineBase );
  avg_value = AvgDepth(joints,KinectPV2.JointType_ShoulderLeft, KinectPV2.JointType_ShoulderRight,KinectPV2.JointType_SpineBase );
  textSize(32);
  text("Average Depth:"+ avg_value+"mm", 550, 100);
  
  depth_l_shoulder = Jointdepth(joints,KinectPV2.JointType_ShoulderLeft);
  depth_r_shoulder = Jointdepth(joints,KinectPV2.JointType_ShoulderRight);
  
   text("shoulder_left:"+ depth_l_shoulder, 550, 200);
   text("shoulder_right:"+ depth_r_shoulder, 550, 250);
  
  
  
}

//draw a single joint
void drawJoint(KJoint[] joints, int jointType) {
  pushMatrix();
  translate(joints[jointType].getX(), joints[jointType].getY(), joints[jointType].getZ());
  ellipse(0, 0, 25, 25);
  popMatrix();
}

//draw a bone from two joints
void drawBone(KJoint[] joints, int jointType1, int jointType2) {
  pushMatrix();
  translate(joints[jointType1].getX(), joints[jointType1].getY(), joints[jointType1].getZ());
  ellipse(0, 0, 25, 25);
  popMatrix();
  line(joints[jointType1].getX(), joints[jointType1].getY(), joints[jointType1].getZ(), joints[jointType2].getX(), joints[jointType2].getY(), joints[jointType2].getZ());
}

// draw rectangle from two joints and torso
void drawRect(KJoint[] joints, int jointType1, int jointType2, int jointType3){
  
  rect(joints[jointType1].getX(),joints[jointType1].getY(),joints[jointType2].getX()-joints[jointType1].getX(), joints[jointType3].getY()-joints[jointType1].getY());
}

// Compute Average Depth

// Compute Average Depth

float AvgDepth(KJoint[] joints, int jointType1, int jointType2, int jointType3){
    int [] rawData = kinect.getRawDepthData(); 
    //println((joints[jointType1].getY()+joints[jointType2].getY())/2);
    //println(joints[jointType3].getY());
    
    float update_value = 0;
    int average_count =0;
    for( float i = joints[jointType1].getX(); i <= joints[jointType2].getX(); i++){
      for( float j = (joints[jointType1].getY()+joints[jointType2].getY())/2; j <= joints[jointType3].getY(); j++){
        float c = i +j*(512);
//println(c);
        int d = int(c);
       if (d<217088){
        update_value = rawData[d] + update_value ;
        average_count++;
       }
      }
    }
    if(average_count == 0){
      update_value = update_value;
    }
    else{
   update_value = update_value/float(average_count) ;
    }
   return update_value;
}




float Jointdepth(KJoint[] joints, int jointType1){
  int [] rawData = kinect.getRawDepthData();
  float index = 0;
  float indey =0;
  int avg =0;
  for (int i =0; i<1000; i++){
  index = joints[jointType1].getX();
  indey = joints[jointType1].getY();

  int [] data = new int[1000];
  data[i] = int(index +indey*512);
  if (data[i]<217088){
  avg = avg+ rawData[data[i]];}
  
  }
  avg = avg/6;
  
  return avg;
}
  
  


void slider(float frmps) {
   frmpersec = frmps;
  
}
