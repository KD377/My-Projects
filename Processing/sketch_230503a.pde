PShape halo;
PImage texture;
PImage texture2;
PShape spaceShip;

void setup()
{
  size(1330, 900, P3D);
  noStroke();
  halo = loadShape("halo.obj");
  texture = loadImage("texture.jpg");
  texture2 = loadImage("texture2.jpg");
  spaceShip = loadShape("ship.obj");
  halo.setTexture(texture);
  spaceShip.setTexture(texture2);
  noStroke();
}

float shipX = 0.0f;
float shipY = -200.0f;
float shipZ = 100.0f;
float rotationAngle;
float planetRotation1 = 0.0f;
float factor =1;
float shipSpeed = 20.0f;
boolean moveRight = false;
boolean moveLeft = false;
boolean moveForward = false;
boolean moveBackward = false;
boolean moveUp = false;
boolean moveDown = false;
float planetSpeed1 = 2.5f;
boolean reverseDirection = false;
void keyPressed() {
  if (key == 'D' || key == 'd') {
    moveRight = true;
  } else if (key == 'A' || key =='a') {
    moveLeft = true;
  } else if (key == 'W' || key=='w') {
    moveUp = true;
  } else if (key == 'S'|| key=='s') {
    moveDown = true;
  } else if (key == 'Q' || key=='q') {
    moveForward = true;
  } else if (key == 'E'|| key=='e') {
    moveBackward = true;
  }else if (key == 'r' || key == 'R'){
    planetSpeed1 += 0.1f;
  }else if (key =='t' || key =='T'){
    planetSpeed1 -=0.1f;
  }else if (key=='i' || key=='I'){
    reverseDirection = !reverseDirection;
  }
}

void keyReleased() {
  if (key == 'D' || key == 'd') {
    moveRight = false;
  } else if (key == 'A' || key =='a') {
    moveLeft = false;
  } else if (key == 'W' || key=='w') {
    moveUp = false;
  } else if (key == 'S'|| key=='s') {
    moveDown = false;
  } else if (key == 'Q' || key=='q') {
    moveForward = false;
  } else if (key == 'E'|| key=='e') {
    moveBackward = false;
  }
}


void draw()
{  
  
  lights();
  rotationAngle = frameCount *0.01f+planetSpeed1;
  planetRotation1 +=0.01f*planetSpeed1;
  rotationAngle = planetRotation1;
  background(#00112C);          
  translate(width/2, height/2, -400.0f);
  rotateX(-0.45f);
  
  shininess(10.0f);
  
  pushMatrix();
      translate(shipX, shipY, shipZ);
      scale(0.5);
      scale(1,-1,1);
      shape(spaceShip, 0, 0);
  popMatrix();
  
   if (moveRight) {
    shipX += shipSpeed;
  }
  if (moveLeft) {
    shipX -= shipSpeed;
  }
  if (moveForward) {
    shipY -= shipSpeed;
  }
  if (moveBackward) {
    shipY += shipSpeed;
  }
  if (moveUp) {
    shipZ += shipSpeed;
  }
  if (moveDown) {
    shipZ -= shipSpeed;
  }
  
  //GWIAZDA
  pushMatrix();
      
      fill(255, 175, 5);
      specular(255, 252, 0);
      lightSpecular(255, 252, 205);
      emissive(255,244, 100);
      pointLight(255,255,0,0,0,0);
      sphere(70);
      rotateY(frameCount * 0.01f);
  
  popMatrix();
  
  emissive(0,0,0);
  specular(0,0,0);
  
  pushMatrix();
      rotateX(0.2);
      float planetSpeed = 2.5f;
      fill(122, 30, 5);
      specular(212, 51, 8);
      rotateY(frameCount * 0.01f * planetSpeed);
      translate(100, 0, 0);
      rotateX(frameCount * 0.01f * planetSpeed);
      rotateZ(-frameCount * 0.01f * planetSpeed);
      scale(20);
      shape(halo);

  popMatrix();
  
      
  pushMatrix();
      rotateX(-0.7);
      fill(#1DFF12);
      specular(191, 214, 94);
      if(reverseDirection){
        rotateY(rotationAngle);
      }else{
        rotateY(-rotationAngle);
      }
      
      translate(200, 0, 0);
      sphere(25);
      
      pushMatrix();
          
          float moonSpeed = 3.5f;
          fill(183, 189, 164);
          specular(210, 217, 188);
          rotateY(frameCount * 0.01f * moonSpeed);
          translate(32,0,0);
          sphere(4);
      
      popMatrix();
  popMatrix();
  
  pushMatrix();
      planetSpeed = 1.04f;
      fill(20, 20, 20);
      specular(255, 255, 255);
      rotateY(frameCount * 0.01f * planetSpeed);
      translate(350, 0, 0);
      texture(texture);
      sphere(35);
      
      pushMatrix();
          
          moonSpeed = 3.0f;
          fill(182, 255, 242);
          specular(115, 255, 242);
          rotateY(frameCount * 0.01f * moonSpeed);
          translate(45,0,0);
          sphere(5);
      
      popMatrix();
      
      pushMatrix();
          
          moonSpeed = 2.5f;
          fill(116, 255, 171);
          specular(200, 255, 171);
          rotateZ(frameCount * 0.01f * moonSpeed);
          translate(58,0,0);
          sphere(6);
      
      popMatrix();
      
      pushMatrix();
          
          moonSpeed = 1.5f;
          fill(#DB2518);
          specular(0, 247, 219);
          rotateY(frameCount * 0.01f * moonSpeed);
          translate(72,0,0);
          rotateX(frameCount * 0.01f * moonSpeed);
          box(3, 4, 9);
      
      popMatrix();      
  popMatrix();
  
  pushMatrix();
      rotateZ(0.5);
      planetSpeed = 0.6f;
      fill(#0AC8FA);
      specular(255, 30, 0);
      rotateY(frameCount * 0.01f * planetSpeed);
      translate(500, 0, 0);
      sphere(45);
      translate(0, 45, 0);
      spotLight(255, 255, 255, 0, 0, 0, 0, 0, 1, 0.5, 2);
      translate(0, -45, 0);
      
      pushMatrix();
          
          moonSpeed = 3.0f;
          fill(183, 189, 164);
          specular(210, 217, 188);
          rotateY(frameCount * 0.01f * moonSpeed);
          translate(100,0,0);
          sphere(4);
      pushMatrix();
         moonSpeed = 3.0f;
          fill(#0AC8FA);
          specular(210, 217, 188);
          rotateY(frameCount * 0.01f * moonSpeed);
          translate(20,0,0);
          sphere(6);
      
      popMatrix();
      popMatrix();
     
        
      
      pushMatrix();
          
          moonSpeed = 2.5f;
          fill(198, 255, 152);
          specular(210, 255, 152);
          rotateY(frameCount * 0.01f * moonSpeed);
          translate(70,0,0);
          rotateZ(frameCount * 0.01f * moonSpeed);
          sphere(6);
         pushMatrix();
         moonSpeed = 3.0f;
          fill(#0AC8FA);
          specular(210, 217, 188);
          rotateY(frameCount * 0.01f * moonSpeed);
          translate(10,0,0);
          sphere(4);
      
      popMatrix();
      
      popMatrix();
      
      pushMatrix();
          
          moonSpeed = 1.5f;
          fill(248, 255, 208);
          specular(248, 255, 208);
          rotateY(frameCount * 0.01f * moonSpeed);
          translate(100,0,0);
          rotateX(frameCount * 0.01f * moonSpeed);
          box(7, 7, 7);
      
      popMatrix();
  popMatrix();
}
