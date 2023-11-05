PImage img1, img2, img3, img4, img5, img6;

void rotate_x(float p[],float a){
  float q[]=new float[3];
  float c=cos(a);
  float s=sin(a);
  q[0]=p[0];
  q[1]=c*p[1]-s*p[2];
  q[2]=s*p[1]+c*p[2];
  for(int k=0;k<3;k++)
    {p[k]=q[k];
  }
}
void rotate_y(float p[],float a){
  float q[]=new float[3];
  float c=cos(a);
  float s=sin(a);
  q[1]=p[1];
  q[2]=c*p[2]-s*p[0];
  q[0]=s*p[2]+c*p[0];
  for(int k=0;k<3;k++){
    p[k]=q[k];
  }
}
void rotate_z(float p[],float a){
  float q[]=new float[3];
  float c=cos(a);
  float s=sin(a);
  q[2]=p[2];
  q[0]=c*p[0]-s*p[1];
  q[1]=s*p[0]+c*p[1];
  for(int k=0;k<3;k++){
    p[k]=q[k];
  }
}

//--------------------------------------------------------------
// Deformable Object Class
//--------------------------------------------------------------
float[] gravity={0,9.8f,0};

class DefObj{
  //constants
  int N;
  float M;
  float K;//f=K*(l-L)/L
  float C;//f=C*(v1-v0)
  float Le,Ls,Lv;
  //status
  float [][][][]p;
  float [][][][]v;
  float [][][][]f;
  //constructor
  DefObj(int n,float w,float m_in,float k_in,float c_in){
    N=n;
    M=m_in/(n*n*n);
    K=(k_in*w*w)/(N*N+2*N*(N-1)/2.0f+4*(N-1)*(N-1)/3.0f);
    C=K*c_in;
    float r = random(108);
    Le=w/(N-1);
    Ls=Le*sqrt(2);
    Lv=Le*sqrt(3);
    p=new float[N][N][N][3];
    v=new float[N][N][N][3];
    f=new float[N][N][N][3];
    for(int k=0;k<N;k++){
      for(int j=0;j<N;j++){
        for(int i=0;i<N;i++){
          float po[]=new float[3];
          po[0]=(float)i*Le-w*0.5f;
          po[1]=(float)j*Le-w*0.5f;
          po[2]=(float)k*Le-w*0.5f;
          rotate_z(po,0.3f*r);
          rotate_y(po,0.3f*r);
          rotate_x(po,0.3f*r);
          p[k][j][i][0]=po[0];
          p[k][j][i][1]=po[1]-0.2f;
          p[k][j][i][2]=po[2];
        }
      }
    }
    for(int k=0;k<N;k++){
      for(int j=0;j<N;j++){
        for(int i=0;i<N;i++){
          for(int l=0;l<3;l++){
            v[k][j][i][l]=0;
            f[k][j][i][l]=0;
          }
        }
      }
    }
  }
  //**** calc force
  void calc_a_force(int i0,int j0,int k0,int i1,int j1,int k1,int type){
    float p0[]=p[k0][j0][i0];
    float p1[]=p[k1][j1][i1];
    float L;
    switch(type){
      case 0:L=Le;break;
      case 1:L=Ls;break;
      case 2:L=Lv;break;
      default:L=0;break;
    }
    //length
    float[] r01=new float[3];
    for(int k=0;k<3;k++){
      r01[k]=p1[k]-p0[k];
    }
    float l=sqrt((r01[0]*r01[0])+(r01[1]*r01[1])+(r01[2]*r01[2]));
    float[] a={r01[0]/l,r01[1]/l,r01[2]/l}; 
    float fk=K*(l-L)/L;
    //relative velocity
    float v0[]=v[k0][j0][i0];
    float v1[]=v[k1][j1][i1];
    float[] v01=new float[3];
    for(int k=0;k<3;k++){
      v01[k]=v1[k]-v0[k];
    }
    float va=v01[0]*a[0]+v01[1]*a[1]+v01[2]*a[2];
    float fc=C*va;
    //calc components of force
    for(int k=0;k<3;k++){
      float f0=(fk+fc)*a[k];
      f[k0][j0][i0][k]+=f0;
      f[k1][j1][i1][k]+=-f0;
    }
  }
  void calc_force(){
    //clear force
    for(int k=0;k<N;k++){
      for(int j=0;j<N;j++){
        for(int i=0;i<N;i++){
          for(int l=0;l<3;l++){
            f[k][j][i][l]=M*gravity[l];
          }
        }
      }
    }
    // edge 
    for(int k=0;k<N;k++){
      for(int j=0;j<N;j++){
        for(int i=0;i<(N-1);i++){
           calc_a_force(i  ,j,k,i+1,j,k,0);
         }
       }
     }
    for(int k=0;k<N;k++){
      for(int j=0;j<(N-1);j++){
        for(int i=0;i<N;i++){
          calc_a_force(i,j  ,k,i,j+1,k,0);
        }
      }
    }
    for(int k=0;k<(N-1);k++){
      for(int j=0;j<N;j++){
        for(int i=0;i<N;i++){
          calc_a_force(i,j,k  ,i,j,k+1,0);
        }
      }
    }
    // surface diagonal
    for(int k=0;k<(N-1);k++){
      for(int j=0;j<(N-1);j++){
        for(int i=0;i<N;i++){
          calc_a_force(i,j  ,k  ,i,j+1,k+1,1);
          calc_a_force(i,j+1,k  ,i,j  ,k+1,1);
        }
      }
    }
    for(int k=0;k<(N-1);k++){
      for(int j=0;j<N;j++){
        for(int i=0;i<(N-1);i++){
          calc_a_force(i  ,j,k  ,i+1,j,k+1,1);
          calc_a_force(i+1,j,k  ,i  ,j,k+1,1);
        }
      }
    }
    for(int k=0;k<N;k++){
      for(int j=0;j<(N-1);j++){
        for(int i=0;i<(N-1);i++){
          calc_a_force(i  ,j  ,k,i+1,j+1,k,1);
          calc_a_force(i+1,j  ,k,i  ,j+1,k,1);
        }
      }
    }
    // volume diagonal
    for(int k=0;k<(N-1);k++){
      for(int j=0;j<(N-1);j++){
        for(int i=0;i<(N-1);i++){
          calc_a_force(i  ,j  ,k  ,i+1,j+1,k+1,2);
          calc_a_force(i+1,j  ,k  ,i  ,j+1,k+1,2);
          calc_a_force(i  ,j+1,k  ,i+1,j  ,k+1,2);
          calc_a_force(i  ,j  ,k+1,i+1,j+1,k  ,2);
        }
      }
    }
  }
  void move_node(float dt){
    for(int k=0;k<N;k++){
      for(int j=0;j<N;j++){
        for(int i=0;i<N;i++){
          for(int l=0;l<3;l++){
            float a=f[k][j][i][l]/M;
            p[k][j][i][l]+=v[k][j][i][l]*dt+0.5f*a*dt*dt;
            v[k][j][i][l]+=a*dt;
          }
        }
      }
    }
  }
  void collision(float y){
    for(int k=0;k<N;k++){
      for(int j=0;j<N;j++){
        for(int i=0;i<N;i++){
          if(p[k][j][i][1]>y){
            p[k][j][i][1]=y;
            v[k][j][i][1]=0;
          }
        }
      }
    }
  }
  //**** draw spring
  void vertex_v(float[] p){
    float s=1000;
    vertex(p[0]*s,p[1]*s,p[2]*s);
  }
  
  
  void draw_a_spring(int i0,int j0,int k0,int i1,int j1,int k1){
    float p0[]=p[k0][j0][i0];
    float p1[]=p[k1][j1][i1];
    vertex_v(p0);vertex_v(p1);
  }
  void draw_spring(){
    beginShape(LINES);
    // edge
    //stroke(255,255,0,255);
    for(int k=0;k<N;k++){
      for(int j=0;j<N;j++){
        for(int i=0;i<(N-1);i++){
           draw_a_spring(i  ,j,k,i+1,j,k);
        }
      }
    }
    for(int k=0;k<N;k++){
      for(int j=0;j<(N-1);j++){
        for(int i=0;i<N;i++){
          draw_a_spring(i,j  ,k,i,j+1,k);
        }
      }
    }
    for(int k=0;k<(N-1);k++){
      for(int j=0;j<N;j++){
        for(int i=0;i<N;i++){
          draw_a_spring(i,j,k  ,i,j,k+1);
        }
      }
    }
    // surface diagonal
    //stroke(0,  255,0,255);
    for(int k=0;k<(N-1);k++){
      for(int j=0;j<(N-1);j++){
        for(int i=0;i<N;i++){
          draw_a_spring(i,j  ,k  ,i,j+1,k+1);
          draw_a_spring(i,j+1,k  ,i,j  ,k+1);
        }
      }
    }
    for(int k=0;k<(N-1);k++){
      for(int j=0;j<N;j++){
        for(int i=0;i<(N-1);i++){
          draw_a_spring(i  ,j,k  ,i+1,j,k+1);
          draw_a_spring(i+1,j,k  ,i  ,j,k+1);
        }
      }
    }
    for(int k=0;k<N;k++){
      for(int j=0;j<(N-1);j++){
        for(int i=0;i<(N-1);i++){
          draw_a_spring(i  ,j  ,k,i+1,j+1,k);
          draw_a_spring(i+1,j  ,k,i  ,j+1,k);
        }
      }
    }
    // volume diagonal
    //stroke(255,0,  0,255);
    for(int k=0;k<(N-1);k++){
      for(int j=0;j<(N-1);j++){
        for(int i=0;i<(N-1);i++){
          draw_a_spring(i  ,j  ,k  ,i+1,j+1,k+1);
          draw_a_spring(i+1,j  ,k  ,i  ,j+1,k+1);
          draw_a_spring(i  ,j+1,k  ,i+1,j  ,k+1);
          draw_a_spring(i  ,j  ,k+1,i+1,j+1,k  );
        }
      }
    }
    endShape();
  }
  
  
  //**** draw surface
  void draw_a_rectangle(float[] v0,float[] v1,float[] v2,float[] v3){
    float o[]=new float[3];
    for(int l=0;l<3;l++){o[l]=(v0[l]+v1[l]+v2[l]+v3[l])*0.25f;}
    beginShape(TRIANGLE_FAN);
    vertex_v(o); vertex_v(v0);vertex_v(v1);
    vertex_v(v2);vertex_v(v3);vertex_v(v0);
    endShape();
  }
  
  
  void draw_surface(){
    for(int k=0;k<(N-1);k++){
      for(int j=0;j<(N-1);j++){
        int i=0;
        draw_a_rectangle( p[k][j][i], p[k+1][j][i], p[k+1][j+1][i], p[k][j+1][i] ); 
        i=N-1;
        draw_a_rectangle( p[k][j][i], p[k+1][j][i], p[k+1][j+1][i], p[k][j+1][i] );
      }
    }
    for(int j=0;j<(N-1);j++){
      for(int i=0;i<(N-1);i++){
        int k=0;
        draw_a_rectangle( p[k][j][i], p[k][j][i+1], p[k][j+1][i+1], p[k][j+1][i] );
        k=N-1;
        draw_a_rectangle( p[k][j][i], p[k][j][i+1], p[k][j+1][i+1], p[k][j+1][i] );
      }
    }
    for(int i=0;i<(N-1);i++){
      for(int k=0;k<(N-1);k++){
        int j=0;
        draw_a_rectangle( p[k][j][i], p[k][j][i+1], p[k+1][j][i+1], p[k+1][j][i] );
        j=N-1;
        draw_a_rectangle( p[k][j][i], p[k][j][i+1], p[k+1][j][i+1], p[k+1][j][i] );
      }
    }
    pushMatrix();
    scale(1000);
    drawpicture(1, p[0][0][0][0], p[0][0][0][1], p[0][0][0][2],
                   p[0][N-1][0][0],  p[0][N-1][0][1],  p[0][N-1][0][2],
                   p[N-1][N-1][0][0], p[N-1][N-1][0][1], p[N-1][N-1][0][2], 
                   p[N-1][0][0][0], p[N-1][0][0][1], p[N-1][0][0][2] );
    
    drawpicture(2, p[0][0][0][0], p[0][0][0][1], p[0][0][0][2],
                   p[0][N-1][0][0], p[0][N-1][0][1],  p[0][N-1][0][2],
                   p[0][N-1][N-1][0], p[0][N-1][N-1][1], p[0][N-1][N-1][2], 
                   p[0][0][N-1][0], p[0][0][N-1][1], p[0][0][N-1][2] );
    
    drawpicture(3, p[0][N-1][0][0],  p[0][N-1][0][1],  p[0][N-1][0][2],
                   p[N-1][N-1][0][0], p[N-1][N-1][0][1], p[N-1][N-1][0][2],
                   p[N-1][N-1][N-1][0], p[N-1][N-1][N-1][1], p[N-1][N-1][N-1][2], 
                   p[0][N-1][N-1][0], p[0][N-1][N-1][1], p[0][N-1][N-1][2] );
    
    drawpicture(4, p[0][0][N-1][0], p[0][0][N-1][1], p[0][0][N-1][2],
                   p[0][N-1][N-1][0], p[0][N-1][N-1][1], p[0][N-1][N-1][2],
                   p[N-1][N-1][N-1][0], p[N-1][N-1][N-1][1], p[N-1][N-1][N-1][2], 
                   p[N-1][0][N-1][0], p[N-1][0][N-1][1], p[N-1][0][N-1][2] );
                   
    drawpicture(5, p[N-1][0][0][0], p[N-1][0][0][1], p[N-1][0][0][2],
                   p[N-1][N-1][0][0], p[N-1][N-1][0][1], p[N-1][N-1][0][2],
                   p[N-1][N-1][N-1][0], p[N-1][N-1][N-1][1], p[N-1][N-1][N-1][2], 
                   p[N-1][0][N-1][0], p[N-1][0][N-1][1], p[N-1][0][N-1][2] );
                   
    drawpicture(6, p[0][0][0][0], p[0][0][0][1], p[0][0][0][2],
                   p[N-1][0][0][0], p[N-1][0][0][1], p[N-1][0][0][2],
                   p[N-1][0][N-1][0], p[N-1][0][N-1][1], p[N-1][0][N-1][2], 
                   p[0][0][N-1][0], p[0][0][N-1][1], p[0][0][N-1][2] ); 
        
    popMatrix();
  }

  
  void drawpicture(int i, float v1x, float v1y, float v1z, float v2x, float v2y, float v2z,
  float v3x, float v3y, float v3z, float v4x, float v4y, float v4z ) {
    float s = 1000;
    pushMatrix();
    noStroke();
    if(i == 1) {
      beginShape(QUADS);
        texture(img1);
        textureMode(NORMAL);
        vertex(v1x, v1y, v1z, 0, 0); vertex(v2x, v2y, v2z, 0, 1);
          vertex(v3x, v3y, v3z, 1, 1); vertex(v4x, v4y, v4z, 1, 0);
      endShape();
    }
    else if(i == 2) {
      beginShape(QUADS);
        texture(img2);
        textureMode(NORMAL);
        vertex(v1x, v1y, v1z, 0, 0); vertex(v2x, v2y, v2z, 0, 1);
          vertex(v3x, v3y, v3z, 1, 1); vertex(v4x, v4y, v4z, 1, 0);
      endShape();
    }
    else if(i == 3) {
      beginShape(QUADS);
        texture(img3);
        textureMode(NORMAL);
        vertex(v1x, v1y, v1z, 0, 0); vertex(v2x, v2y, v2z, 0, 1);
          vertex(v3x, v3y, v3z, 1, 1); vertex(v4x, v4y, v4z, 1, 0);
      endShape();
    }
    else if(i == 4) {
      beginShape(QUADS);
        texture(img4);
        textureMode(NORMAL);
        vertex(v1x, v1y, v1z, 0, 0); vertex(v2x, v2y, v2z, 0, 1);
          vertex(v3x, v3y, v3z, 1, 1); vertex(v4x, v4y, v4z, 1, 0);
      endShape();
    }
    else if(i == 5) {
      beginShape(QUADS);
        texture(img5);
        textureMode(NORMAL);
        vertex(v1x, v1y, v1z, 0, 0); vertex(v2x, v2y, v2z, 0, 1);
          vertex(v3x, v3y, v3z, 1, 1); vertex(v4x, v4y, v4z, 1, 0);
      endShape();
    }
    else if(i == 6) {
      beginShape(QUADS);
        texture(img6);
        textureMode(NORMAL);
        vertex(v1x, v1y, v1z, 0, 0); vertex(v2x, v2y, v2z, 0, 1);
          vertex(v3x, v3y, v3z, 1, 1); vertex(v4x, v4y, v4z, 1, 0);
      endShape();
    }
    popMatrix();
  } 
}

//--------------------------------------------------------------
// Processing Callback
//--------------------------------------------------------------// setup
DefObj obj;

void setup(){
  size(800,600,P3D);
  
  img1 = loadImage("1.jpg");
  img2 = loadImage("2.jpg");
  img3 = loadImage("3.jpg");
  img4 = loadImage("4.jpg");
  img5 = loadImage("5.jpg");
  img6 = loadImage("6.jpg");
  //********************************
  //create object
  obj=new DefObj(/*n*/7,/*w*/0.1f,/*m*/0.01f,/*k*/1000.0f,/*c*/0.1f);
  //********************************
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
  background(128);
  
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

  //begin World Coordinate
  pushMatrix(); 
  //********************************
  //lower the floor
  translate(0,150,0);  
  //********************************


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

  //********************************
  //Draw Object
  pushMatrix();

  //wireframe
/**/
  noFill();
  noStroke();
  strokeWeight(2);
  obj.draw_spring();

/*
  //Lighting
  ambientLight(64,64,96);     //dark blue
  lightSpecular(192,192,192); //white
  directionalLight(192,192,192,-1,2,-1);
  //Material Property
  noStroke();
  fill(255,255,255,255);
  ambient(255,255,255);
  specular(16,16,16);
  shininess(1.0);
  emissive(0,0,0);
*/
 
  obj.draw_surface();
  
  //object
  //obj.draw_surface();


  popMatrix();
  //********************************
  
  //end World Coordinate
  popMatrix();
  
  //********************************
  //move object
  for(int i=0;i<160;i++){
    obj.calc_force();
    obj.move_node(0.0001f);
    obj.collision(0);
  }
  //********************************
}
