import processing.video.*;

int WIDTH = 640;
int HEIGHT = 480;
int numPixels = WIDTH * HEIGHT;
int[] previousFrame;
Capture video;

int[] activityMap = new int[numPixels];
int THRESHOLD = 10;



void setup() {
  size(WIDTH, HEIGHT);
  
  previousFrame = new int[numPixels];
  
  video = new Capture(this, WIDTH, HEIGHT);
  video.start(); 
  
  String[] cams = Capture.list();
  println("Showing cameras:");
  println( cams );
  
  loadPixels();
}


void draw() {
  
  if (video.available()) {
    
    video.read();
    video.loadPixels();
    
    for (int i = 0; i < numPixels; i++) {
      color currColor = video.pixels[i];
      color prevColor = previousFrame[i];
      
      int currR = (currColor >> 16) & 0xFF; // Like red(), but faster
      int currG = (currColor >> 8) & 0xFF;
      int currB = currColor & 0xFF;
      
      int prevR = (prevColor >> 16) & 0xFF;
      int prevG = (prevColor >> 8) & 0xFF;
      int prevB = prevColor & 0xFF;
      
      int diffR = abs(currR - prevR);
      int diffG = abs(currG - prevG);
      int diffB = abs(currB - prevB);

      if (diffR > THRESHOLD && diffG > THRESHOLD && diffB > THRESHOLD) {
        activityMap[i] = activityMap[i] + 100; 
      }

      float paintColor = ((10000.0 - activityMap[i])/10000.0); 

      // This is how you manually change the current frame's pixels
      pixels[i] = color(currR*paintColor, currG*paintColor, currB*paintColor);

      // Save the current color into the 'previous' buffer
      previousFrame[i] = currColor;
    }

    updatePixels();
  }
}

