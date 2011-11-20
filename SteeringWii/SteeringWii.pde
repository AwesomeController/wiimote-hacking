#include <SPI.h>
#include "WiiRemote.h"

#define STEERING_ANGLE_MAX    165
#define STEERING_ANGLE_MIN    15
#define STEERING_ANGLE_CENTER 90
#define STEERING_ANGLE_STEP   5

WiiRemote wiiremote;

void setup()
{
  SPI.begin();
  Serial.begin(9600);
  Serial.println("before wii init");
  wiiremote.init();
  Serial.println("after wii init");
  
  unsigned char wiiremote_bdaddr[6] = {0x00, 0x1b, 0x7a, 0x00, 0x6c, 0xc5};
  wiiremote.setBDAddress(wiiremote_bdaddr, 6);
  wiiremote.setBDAddressMode(BD_ADDR_FIXED);
  
}

void loop()
{
  wiiremote.task(&myapp);
  if (!(wiiremote.getStatus() & WIIREMOTE_STATE_RUNNING)) {
    //Serial.println((int)wiiremote.getStatus());
  }
}


void myapp(void) {
  //Serial.println("callback called");
  if (wiiremote.buttonClicked(WIIREMOTE_TWO)) {
    Serial.println("button two clicked");
    int steering_angle = getSteeringAngle();
    Serial.println("Steering angle determined");
  }
  if (wiiremote.buttonClicked(WIIREMOTE_B)) {
    Serial.println("B clicked"); 
    if (wiiremote.Report.Button.B) {
      Serial.println("B pressed?"); 
    }
  }
}

int getSteeringAngle(void) {
  double rad;
  double deg;

  rad = acos((double) wiiremote.Report.Accel.Y);
  deg = rad * 180.0 / PI;

  /* clipping */
  if (deg > STEERING_ANGLE_MAX) { deg = STEERING_ANGLE_MAX; }
  if (deg < STEERING_ANGLE_MIN) { deg = STEERING_ANGLE_MIN; }

  Serial.print("\r\nSteering angle = ");
  Serial.print((int) deg);

  return (int) deg;
}


// vim: sts=2 sw=2 ts=2 et cin
