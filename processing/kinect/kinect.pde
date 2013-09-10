import org.openkinect.*;
import org.openkinect.processing.*;

Kinect kinect;
int WIDTH = 640;
int HEIGHT = 480;
int numPixels = WIDTH * HEIGHT;
int[] previousFrame;

int[] activityMap = new int[numPixels];
int THRESHOLD = 30;

int value = 0;
PImage img;
PImage heatMap;
float MAX_ACTIVITY = 10000.0;

boolean saveImage = false;


void setup() {
  size(WIDTH*2, HEIGHT);
  
  kinect = new Kinect(this);
  kinect.start();
  kinect.enableRGB(true);
  
  delay(1000);
  
  heatMap = new PImage(WIDTH, HEIGHT);
  img = new PImage(WIDTH, HEIGHT);
  
  img = kinect.getVideoImage();
  
  for (int i = 0; i < numPixels; i++) {
    heatMap.pixels[i] = img.pixels[i];
  }
  
  previousFrame = new int[numPixels];
}







void draw() {
  img = kinect.getVideoImage();
  
    
  for (int i = 0; i < numPixels; i++) {
    color prevColor = previousFrame[i];
    color currColor = img.pixels[i];
      
    int currR = (currColor >> 16) & 0xFF; // Like red(), but faster
    int currG = (currColor >> 8) & 0xFF;
    int currB = currColor & 0xFF;

    int prevR = (prevColor >> 16) & 0xFF;
    int prevG = (prevColor >> 8) & 0xFF;
    int prevB = prevColor & 0xFF;

    int diffR = abs(currR - prevR);
    int diffG = abs(currG - prevG);
    int diffB = abs(currB - prevB);

    int totalDiff = (diffR + diffG + diffB)/3;
    if ((diffR + diffG + diffB)/3 > THRESHOLD) {
      if (activityMap[i] < MAX_ACTIVITY) {
        activityMap[i] = activityMap[i] + totalDiff;
      } 
    }

    float paintColor = ((MAX_ACTIVITY - activityMap[i])/MAX_ACTIVITY); 

    if (i == 40) {
      println("TotalDiff: " + totalDiff);
      println("activityMap[i]: " + activityMap[i]);
      println("currRed: " + currR);
      println("red: " + float(currR)*paintColor);
      println("--------------------------");
    }

    // This is how you manually change the current frame's pixels
    heatMap.pixels[i] = color(float(currR)*paintColor, float(currG)*paintColor, float(currB)*paintColor);

    previousFrame[i] = currColor;
  }
  
  image(img,0,0);
  image(heatMap,WIDTH,0);
  
  if (saveImage == true) {
    heatMap.save("footprints"+millis()+".jpg");
    saveImage = false;
  }
}



void keyPressed() {
  if (keyCode == 10) {
    saveImage = true;
  } else if(keyCode == 38) {
    THRESHOLD += 1;
    println("Threshold: " + THRESHOLD);
  } else if (keyCode == 40) {
    THRESHOLD -= 1;
    println("Threshold: " + THRESHOLD);
  } else {
    println(keyCode); 
  }
  

}
