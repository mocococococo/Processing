Slot slot;

class Slot {
  float Size_Slot;
  float Size_Lever;
  float rotateLever = 0;
  
  boolean T_LEVER;
  boolean T_LEFT;
  boolean T_CENTER;
  boolean T_RIGHT;
  boolean RRR;
  boolean T_START;
  boolean T_CHECK;
  boolean ALL_START;
  
  int L_POS = -30;
  int C_POS = 0;
  int R_POS = 30;
  int Xpos = 0;
  
  int il;
  int ic;
  int ir;
  int jl;
  int jc;
  int jr;
  
  char leftstring[] = {'1', '2', '3', '4', '5', '6', '7', '8', '9', '0'};
  char centralstring[] = {'1', '2', '6', '4', '3', '1', '8', '6', '9', '9', '1', '2', '5', '3', '7', '9'};
  char rightstring[] = {'6', '3', '4', '2', '5', '9', '1', '7', '2', '4', '8', '6', '5', '1', '8', '7'};
  
  Slot(float ss, float sr) {
    Size_Slot = ss;
    Size_Lever = sr;
    T_LEVER = false;
    T_LEFT = false;
    T_CENTER = false;
    T_RIGHT = false;
    RRR = false;
    T_START = false;
    ALL_START = false;
    il = 0;
    ic = 0;
    ir = 0;
    jl = 0;
    jc = 0;
    jr = 0;
  }
  
  void drawSlot() {
    if(T_LEVER == true) {
      if(rotateLever > -90 && RRR == false) {
        rotateLever--;
      }
      if(rotateLever == -90) {
        RRR = true;
      }
      if(RRR == true && rotateLever < 0) {
        rotateLever++;
      }
      if(RRR == true && rotateLever == 0) {
        RRR = false;
        T_LEVER = false;
      }
    }
    
    noStroke();
    pushMatrix();
    
    makeSlot();
    translate(55, 0, 0);
    rotateX(radians(rotateLever));
    makeLever();
    
    popMatrix();
    
    pushMatrix();
    translate(0, -20, 0);
    drawNumber(L_POS);
    drawNumber(C_POS);
    drawNumber(R_POS);
    popMatrix();
    
    pushMatrix();
      translate(-30, 40, 51);
      texts();
    popMatrix();
    
  }
  
  void makeSlot() {
    noStroke();
    pushMatrix();
    scale(Size_Slot);
    int x = 1, y = 2, z = 1;
    fill(20);
    beginShape(QUADS);
      vertex(x, y, z); vertex(-x, y, z); vertex(-x, -y, z); vertex(x, -y, z);
      vertex(x, y, z); vertex(x, y, -z); vertex(x, -y, -z); vertex(x, -y, z);
      vertex(-x, y, z); vertex(-x, y, -z); vertex(-x, -y, -z); vertex(-x, -y, z);
      vertex(x, y, -z); vertex(-x, y, -z); vertex(-x, -y, -z); vertex(x, -y, -z);
      vertex(x, -y, z); vertex(x, -y, -z); vertex(-x, -y, -z); vertex(-x, -y, z);
      vertex(x, y, z); vertex(x, y, -z); vertex(-x, y, -z); vertex(-x, y, z);
    endShape();
    fill(20);
    beginShape(QUADS);
      vertex(x, y, z); vertex(-x, y, z); vertex(-x, -y, z); vertex(x, -y, z);
      vertex(x, y, z); vertex(x, y, -z); vertex(x, -y, -z); vertex(x, -y, z);
      vertex(-x, y, z); vertex(-x, y, -z); vertex(-x, -y, -z); vertex(-x, -y, z);
      vertex(x, y, -z); vertex(-x, y, -z); vertex(-x, -y, -z); vertex(x, -y, -z);
      vertex(x, -y, z); vertex(x, -y, -z); vertex(-x, -y, -z); vertex(-x, -y, z);
      vertex(x, y, z); vertex(x, y, -z); vertex(-x, y, -z); vertex(-x, y, z);
    endShape();
    popMatrix();
  }
  
  void makeLever() {
    noStroke();
    pushMatrix();
    scale(Size_Lever);
    
    translate(2, 0, 0);
    
    int x = 3, y = 1, z = 1;
    fill(255, 140, 0, 255);
    beginShape(QUADS);
      vertex(x, y, z); vertex(-x, y, z); vertex(-x, -y, z); vertex(x, -y, z);
      vertex(x, y, z); vertex(x, y, -z); vertex(x, -y, -z); vertex(x, -y, z);
      vertex(-x, y, z); vertex(-x, y, -z); vertex(-x, -y, -z); vertex(-x, -y, z);
      vertex(x, y, -z); vertex(-x, y, -z); vertex(-x, -y, -z); vertex(x, -y, -z);
      vertex(x, -y, z); vertex(x, -y, -z); vertex(-x, -y, -z); vertex(-x, -y, z);
      vertex(x, y, z); vertex(x, y, -z); vertex(-x, y, -z); vertex(-x, y, z);
    endShape();
    
    translate(2, -4, 0);
    x = 1;
    y = 3;
    fill(255, 140, 0, 255);
    beginShape(QUADS);
      vertex(x, y, z); vertex(-x, y, z); vertex(-x, -y, z); vertex(x, -y, z);
      vertex(x, y, z); vertex(x, y, -z); vertex(x, -y, -z); vertex(x, -y, z);
      vertex(-x, y, z); vertex(-x, y, -z); vertex(-x, -y, -z); vertex(-x, -y, z);
      vertex(x, y, -z); vertex(-x, y, -z); vertex(-x, -y, -z); vertex(x, -y, -z);
      vertex(x, -y, z); vertex(x, -y, -z); vertex(-x, -y, -z); vertex(-x, -y, z);
      vertex(x, y, z); vertex(x, y, -z); vertex(-x, y, -z); vertex(-x, y, z);
    endShape();
    
    fill(255, 255, 0, 255);
    translate(0, -3, 0);
    sphere(2);

    popMatrix();
  }
  
  void drawNumber(int pos) {
    int r = 50;
    int d = 36;
    char c[] = {'0', '1', '2', '3', '4', '5', '6', '7', '8', '9'};
    if(pos == L_POS) {
      fill(255, 255, 255, 100);
      beginShape(QUADS);
        vertex(pos-10, 30, 51); vertex(pos+10, 30, 51); vertex(pos+10, -40, 51); vertex(pos-10, -40, 51);
      endShape();
      if(T_LEFT == true) {
        for(int j = 0; j < 10; j++) {
          pushMatrix();
          float x = pos;
          float y = r*sin(radians(il-j*d));
          float z = r*cos(radians(il-j*d))+20;
          translate(x, y, z);
          fill(255,255,0);
          text(c[j], 0, 0);
          popMatrix();
        }
      }
      else {
        for(int j = 0; j < 10; j++) {
          pushMatrix();
          float x = pos;
          float y = r*sin(radians(il-j*d));
          float z = r*cos(radians(il-j*d))+5;
          translate(x, y, z);
          fill(255,255,0);
          text(c[j], 0, 0);
          popMatrix();
        }
      }
    }
    
    if(pos == C_POS) {
      fill(255, 255, 255, 100);
      beginShape(QUADS);
        vertex(pos-10, 30, 51); vertex(pos+10, 30, 51); vertex(pos+10, -40, 51); vertex(pos-10, -40, 51);
      endShape();
      if(T_CENTER == true) {
        for(int j = 0; j < 10; j++) {
          pushMatrix();
          float x = pos;
          float y = r*sin(radians(ic-j*d));
          float z = r*cos(radians(ic-j*d))+20;
          translate(x, y, z);
          fill(255,255,0);
          text(c[j], 0, 0);
          popMatrix();
        }
      }
      else {
        for(int j = 0; j < 10; j++) {
          pushMatrix();
          float x = pos;
          float y = r*sin(radians(ic-j*d));
          float z = r*cos(radians(ic-j*d))+5;
          translate(x, y, z);
          fill(255,255,0);
          text(c[j], 0, 0);
          popMatrix();
        }
      }
    }
    
    if(pos == R_POS) {
      fill(255, 255, 255, 100);
      beginShape(QUADS);
        vertex(pos-10, 30, 51); vertex(pos+10, 30, 51); vertex(pos+10, -40, 51); vertex(pos-10, -40, 51);
      endShape();
      if(T_RIGHT == true) {
        for(int j = 0; j < 10; j++) {
          pushMatrix();
          float x = pos;
          float y = r*sin(radians(ir-j*d));
          float z = r*cos(radians(ir-j*d))+20;
          translate(x, y, z);
          fill(255,255,0);
          text(c[j], 0, 0);
          popMatrix();
        }
      }
      else {
        for(int j = 0; j < 10; j++) {
          pushMatrix();
          float x = pos;
          float y = r*sin(radians(ir-j*d));
          float z = r*cos(radians(ir-j*d))+5;
          translate(x, y, z);
          fill(255,255,0);
          text(c[j], 0, 0);
          popMatrix();
        }
      }
    }
    
  }
  
  void texts() {
    pushMatrix();
      text("Push ENTER!", 0, 0);
    popMatrix();
  }
  
  void Result() {
    if(ALL_START == true && T_START == true && T_CHECK == true) {
      success();
      if(Xpos < 150) Xpos++;
    }
    if(ALL_START == true && T_START == true && T_CHECK == false) {
      fail();
      if(Xpos < 150) Xpos++;
    }
  }
  
  void success() {
    pushMatrix();
    translate(0, -Xpos, 0);
    makeStar();
    popMatrix();
    pushMatrix();
    translate(-25, -70, 51);
    text("Successed!!", 0, 0);
    popMatrix();
  }
  
  void makeStar() {
    noStroke();
    scale(Size_Slot/2);
    pushMatrix();
    
    float r = 1, z = 1;
    float R = sqrt(5);
    fill(255, 255, 140, 255);
    beginShape();
      for(int i = 0; i < 5; i++) {
        vertex(r*cos(radians(18+72*i)), r*sin(radians(18+72*i)), z);
      }
    endShape();
    beginShape();
      for(int i = 0; i < 5; i++) {
        vertex(r*cos(radians(18+72*i)), r*sin(radians(18+72*i)), -z);
      }
    endShape();
    beginShape(QUADS);
      for(int i = 0; i < 5; i++) {
        vertex(r*cos(radians(18+72*i)), r*sin(radians(18+72*i)), z);
        vertex(r*cos(radians(18+72*i)), r*sin(radians(18+72*i)), -z);
        vertex(r*cos(radians(18+72*(i+1))), r*sin(radians(18+72*(i+1))), -z);
        vertex(r*cos(radians(18+72*(i+1))), r*sin(radians(18+72*(i+1))), z);
      }
    endShape();
    fill(255, 255, 62, 255);
    beginShape(TRIANGLES);
      for(int i = 0; i < 5; i++) {
        vertex(r*cos(radians(18+72*i)), r*sin(radians(18+72*i)), z);
        vertex(r*cos(radians(18+72*i)), r*sin(radians(18+72*i)), -z);
        vertex(R*cos(radians(72*i-18)), R*sin(radians(72*i-18)), 0);
        
        vertex(r*cos(radians(18+72*i)), r*sin(radians(18+72*i)), z);
        vertex(r*cos(radians(18+72*i)), r*sin(radians(18+72*i)), -z);
        vertex(R*cos(radians(72*(i+1)-18)), R*sin(radians(72*(i+1)-18)), 0);
        
        vertex(r*cos(radians(18+72*i)), r*sin(radians(18+72*i)), z);
        vertex(r*cos(radians(18+72*(i+1))), r*sin(radians(18+72*(i+1))), z);
        vertex(R*cos(radians(72*(i+1)-18)), R*sin(radians(72*(i+1)-18)), 0);
        
        vertex(r*cos(radians(18+72*i)), r*sin(radians(18+72*i)), -z);
        vertex(r*cos(radians(18+72*(i+1))), r*sin(radians(18+72*(i+1))), -z);
        vertex(R*cos(radians(72*(i+1)-18)), R*sin(radians(72*(i+1)-18)), 0);
      }
    endShape();
    
    popMatrix();
  }
  
  void fail() {
    pushMatrix();
    translate(0, -Xpos, 0);
    makeX();
    popMatrix();
    pushMatrix();
    translate(-20, -70, 51);
    text("failed!!", 0, 0);
    popMatrix();
  }
  
  void makeX() {
    noStroke();
    pushMatrix();
    scale(Size_Slot/4);
    int x = 3, y = 3, z = 1;
    fill(235, 40, 60, 255);
    beginShape(QUADS);
      vertex(x, y, z); vertex(x-1, y, z); vertex(x-1, y, -z); vertex(x, y, -z);
      vertex(x, -y, z); vertex(x-1, -y, z); vertex(x-1, -y, -z); vertex(x, -y, -z);
      vertex(-x, y, z); vertex(-x+1, y, z); vertex(-x+1, y, -z); vertex(-x, y, -z);
      vertex(-x, -y, z); vertex(-x+1, -y, z); vertex(-x+1, -y, -z); vertex(-x, -y, -z);
      
      vertex(x, y, z); vertex(x-1, y, z); vertex(-x, -y, z); vertex(-x+1, -y, z);
      vertex(x, y, z); vertex(x, y, -z); vertex(-x, -y, -z); vertex(-x, -y, z);
      vertex(x, y, -z); vertex(x-1, y, -z); vertex(-x, -y, -z); vertex(-x+1, -y, -z);
      vertex(x-1, y, z); vertex(x-1, y, -z); vertex(-x, -y, -z); vertex(-x, -y, z);

      vertex(-x, y, z); vertex(-x+1, y, z); vertex(x, -y, z); vertex(x-1, -y, z);
      vertex(-x+1, y, z); vertex(-x+1, y, -z); vertex(x, -y, -z); vertex(x, -y, z);
      vertex(-x, y, -z); vertex(-x+1, y, -z); vertex(x, -y, -z); vertex(x-1, -y, -z);
      vertex(-x, y, z); vertex(-x, y, -z); vertex(x-1, -y, -z); vertex(x-1, -y, z);
    endShape();
    popMatrix();
  }
  
  void checkTF() {
    if(T_START == false && T_LEFT == false && T_CENTER == false && T_RIGHT == false) {
      T_START = true;
    }
    if(il == ic && ic == ir) {
      T_CHECK = true;
    } else {
      T_CHECK = false;
    }
    
  }
  
}

void setup(){
  size(800,600,P3D);
  slot = new Slot(50, 10);
  frameRate(100);
}

// camera control
float cam_az; // camera azimus
float cam_el; // camera elevation
void mouseDragged(){
  cam_az=((float)mouseX/(float)width-0.5f)*(180.0f);
  cam_el=((float)mouseY/(float)height-0.5f)*(-90.0f);
}

void draw() { 
  // clear color
  background(255);
  
  //Camera Matrix
  beginCamera();
  resetMatrix();
  //projection
  frustum(-20,20, -15,15, 50, 2000);
  //camera position and orientation
  translate(0,0,-800);
  rotateX(2*PI*cam_el/360.0f);
  rotateY(2*PI*cam_az/360.0f);
  endCamera();
  
  

  //lighting
  ambientLight(64,64,96);     //dark blue
  lightSpecular(192,192,192); //white
  directionalLight(155,155,155,-1,1,-1);
  shininess(10);
  
  /*
  
   //begin World Coordinate
  pushMatrix(); 

  
  //axis
  strokeWeight(2);
  stroke(255,0,0); line(0,0,0,200,0,0);
  stroke(0,255,0); line(0,0,0,0,200,0);
  stroke(0,0,255); line(0,0,0,0,0,200);
  strokeWeight(1);

  
  //floor x-z
  stroke(192);
  for(int i=0;i<=10;i++){
    float delta=0.1f;
    float x=-200+i*40;
    line(x,delta,-200f,x,delta,200f);
    line(-200f,delta,x,200f,delta,x);
  }
  
  popMatrix();

  */
  
  slot.drawSlot();
  
  if(slot.T_LEFT == true) {
    slot.il -= 36;
    if(slot.il <= -360) slot.il = 0;
  }
  if(slot.T_CENTER == true) {
    slot.ic -= 36;
    if(slot.ic <= -360) slot.ic = 0;
  }
  if(slot.T_RIGHT == true) {
    slot.ir -= 36;
    if(slot.ir <= -360) slot.ir = 0;
  }
  
  slot.checkTF();
  slot.Result();
  
}

void keyPressed() {
  if(keyCode == ENTER) {
    slot.ALL_START = true;
    slot.T_LEVER = true;
    slot.T_START = false;
    slot.T_LEFT = true;
    slot.T_CENTER = true;
    slot.T_RIGHT = true;
    slot.Xpos = 0;
  }
  if(keyCode == LEFT) {
    if(slot.T_LEFT == true) {
      slot.T_LEFT = false;
    }
  }
  if(keyCode == DOWN) {
    if(slot.T_CENTER == true) {
      slot.T_CENTER = false;
    }
  }
  if(keyCode == RIGHT) {
    if(slot.T_RIGHT == true) {
      slot.T_RIGHT = false;
    }
  }
}
