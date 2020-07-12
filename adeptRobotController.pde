import processing.serial.*;
import processing.video.*;

// Creates  GUI in Processing, user draw with mouse / touch pad and the output is a stream of serial communication

// ****************************************
// IMPORTANT INFO ON CHANGING SCREEN SIZE
// these int change the scaling size, but do NOT change the gui size
// you should ALWAYS change the "size(x,y)"to maych the int
// ****************************************

int screenSizeX = 2500;
int screenSizeY=1300;


  //setup serial communcation (assuming is first port)
  Serial roboPort = new Serial(this, Serial.list()[0], 9600);



PGraphics topLayer;
double xpos;
double ypos;
double robx;
double roby;

boolean isDrawing =false;


void setup() {



  // ****************************************
  // screen GUI size changed here
  // ****************************************
  size (2500, 1300); // must maych screenSizeX and screenSizeY to work correctly
  topLayer = createGraphics(width, height);
}



void draw() {

  // some basic stuff for processing
  noFill();
  //rect(0, 0, 1920, 1080);
  image(topLayer, 0, 0);

  //if the mouse (or tablet) is pressed and is not a right click
  if (mousePressed &&( mouseButton == LEFT)) {

    topLayer.beginDraw();
    topLayer.line(pmouseX, pmouseY, mouseX, mouseY);
    topLayer.endDraw();



    xpos = mouseX;
    ypos = mouseY;

    // check if the the mouse if out of bounds, should never happen
    if (xpos > screenSizeX) {
      xpos = screenSizeX;
    } else if (xpos<0) {
      xpos = 0;
    }

    if (ypos > screenSizeY) {
      ypos = screenSizeY;
    } else if (ypos<0) {
      ypos = 0;
    }


    // set middle of screen to be zero
    xpos = xpos - screenSizeX / 2;
    ypos = ypos - screenSizeY / 2;


    // scales the position to -1 to 1 (might need to multiply to keep precision
    robx = xpos*2 / screenSizeX;
    roby =ypos*2 / screenSizeY;


    // send in the serial data to robot
    roboPort.write(robx +" ," + -roby + " ,\n");

    // commented out, only used for testing 
    //println( "  xpos=" + xpos/2 + " ypos = " + ypos/2);
    //println("sending" + -robx +" ," + roby + " ,");
    //println("mouse is at" +xpos  +" , "+ ypos);


    // every 40 ms add a new line if the mouse is pressed
    isDrawing = true;
    delay(40);
  }

  if (!mousePressed && isDrawing) {
    isDrawing = false;

    // if the mouse is nore pressed and the robot was just drawing
    roboPort.write("10101 , 10102 , \n");
    println("sending :10101 , 01010 ,||");

    delay(40);
  }
}
