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
  size(WIDTH, HEIGHT);
  
  kinect = new Kinect(this);
  kinect.start();
  kinect.enableRGB(true);
  
  img = new PImage(WIDTH, HEIGHT);
  img = kinect.getVideoImage();
  
  previousFrame = new int[numPixels];
}







void draw() {
  img = kinect.getVideoImage();
  heatMap = createImage(WIDTH, HEIGHT, RGB);
   
  int maxActivity = 10000;  
   
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
    if (totalDiff > THRESHOLD) {
        activityMap[i] = activityMap[i] + totalDiff;
    }
    
    //if (activityMap[i] > maxActivity) {
    //  maxActivity = activityMap[i]; 
   // }

    previousFrame[i] = currColor;
  }
  
  
  // Go through and update the heatmap with normalized values
  for (int i = 0; i < numPixels; i++) {
    float colorRatio = (float(maxActivity) - float(activityMap[i]))/float(maxActivity);
    float red = red(img.pixels[i]);
    float green = green(img.pixels[i]);
    float blue = blue(img.pixels[i]);
    
    float additionalRed = 256 - red;
    float additionalBlue = 256 - blue;
    float redRatio = 0.0;
    float blueRatio = 0.0;
    
    if (i == 1000) {
      println(maxActivity); 
    }
    
    if (colorRatio < 0.5) {
      redRatio = 1 - (2 * colorRatio);
      blueRatio = 2 * colorRatio;
    } else {
      redRatio = 0;
      blueRatio = 1 - (2 * (colorRatio - 0.5));
    }
    
    heatMap.pixels[i] = color(colorRatio*red + redRatio * additionalRed, colorRatio*green, colorRatio*blue + blueRatio * additionalBlue);
    //heatMap.pixels[i] = color(red, colorRatio*green, colorRatio*blue + blueRatio * additionalBlue);
  }
  
  image(heatMap,0,0);
  
  if ((frameCount % 1000) == 0) {
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
