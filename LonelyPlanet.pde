// libraries
import shapes3d.utils.*;
import shapes3d.animation.*;
import shapes3d.*;
import processing.opengl.*;
//import guru.ttslib.*;



// shapes
Terrain terrain;
Box skybox;
Cone[] droids;
Ellipsoid obelisk;
TerrainCam cam;


//TTS tts;

PVector[] droidDirs;
int nbrDroids;
int camHoversAt = 30;
float terrainSize = 4000;
float horizon =900;
long time;
float camSpeed;
int count;

boolean lightTexture=true;



// distorted earth
String[] distortion = new String[] {
  "texture1.jpg", "texture2.jpg", "texture3.jpg", "texture4.jpg", "test.jpg", "test2.jpg", "texture5.png", "testwhite.png", "testblack.png"};

// gradient earth
String[] faces = new String[] {
  "cone.jpg", "cone1.jpg", "cone2.jpg", "cone3.jpg", "cone4.jpg", "cone5.jpg"};

void setup() {

  background(252);
  noStroke();
  size(600, 450, P3D);
  noCursor();
  smooth(8);
  
  //terrain
  terrain = new Terrain(this, 60, terrainSize, horizon);
  terrain.usePerlinNoiseMap(57, random(150, 200), .5, 10);
  terrain.setTexture("terrain1.jpg", 3);
  terrain.tag = "testwhite.png";
  terrain.tagNo = -1;
  terrain.drawMode(S3D.TEXTURE);

  //sky
  skybox = new Box(this, 2000, 1000, 2000);
  skybox.setTexture("background.jpg", Box.FRONT);
  skybox.setTexture("background.jpg", Box.BACK);
  skybox.setTexture("background.jpg", Box.LEFT);
  skybox.setTexture("background.jpg", Box.RIGHT);
  skybox.setTexture("background.jpg", Box.TOP);
  skybox.visible(false, Box.BOTTOM);
  skybox.drawMode(S3D.TEXTURE);
  skybox.tag = "Skybox";
  skybox.tagNo = -1;

  //cones
  nbrDroids = 250;
  droids = new Cone[nbrDroids];
  droidDirs = new PVector[nbrDroids];
  for (int i = 0; i < nbrDroids; i++) {
    droids[i] = new Cone(this, 55);
    droids[i].setSize(35, 35, random(50, 150));
    droids[i].moveTo(getRandomPosOnTerrain(terrain, terrainSize, -10));
    droids[i].tagNo = 1;
    droids[i].fill(color(random(0, 80), random(0, 80), random(0, 80)));
    droids[i].drawMode(S3D.SOLID);
    droidDirs[i] = getRandomVelocity(0);
    droids[i].setTexture(faces[1]);
    droids[i].drawMode(S3D.TEXTURE);
    terrain.addShape(droids[i]);
    droids[i].visible(false); }


  //moon
  obelisk = new Ellipsoid(this, 38, 46);
  obelisk.setRadius(25, 25, 25);
  obelisk.moveTo(getRandomPosOnTerrain(terrain, terrainSize, 200));
  obelisk.tag = "texture4";
  obelisk.tagNo = 1; 
  obelisk.setTexture("cone2.jpg");
  obelisk.drawMode(S3D.TEXTURE);

  //camera
  camSpeed = 50;
  cam = new TerrainCam(this);
  cam.adjustToTerrain(terrain, Terrain.WRAP, camHoversAt);
  cam.camera();
  cam.speed(camSpeed);
  cam.forward.set(cam.lookDir());

  // Tell the terrain what camera to use
  terrain.cam = cam;
  time = millis();

}


void draw() {
  saveFrame("/Users/CeCe/Documents/Processing/sketches/kjs_Test/images/######.jpg");
 

  
  background(0);
noCursor();
  //change light textures
  if (lightTexture) {
    pushMatrix();
    
    //pointLight(102, 38, 15, 35, 1732, 68);
    //pointLight(14, 7, 82, 35, -62, -22);
   // pointLight(49, 49, 49, 35, -2514, 36);
    //pointLight(31, 30, 30, 35, 1106, 36);
    ambientLight(255, 253, 253);
    //lights();
    popMatrix();
  } 
  else {
    pushMatrix();
     ambientLight(255, 253, 253);
       
    popMatrix();
    for (int i = 0; i < nbrDroids; i++) {
      droids[i].setTexture(distortion[1]);
      droids[i].tagNo = (droids[i].tagNo + 1) % distortion.length;
      droids[i].setTexture(distortion[droids[i].tagNo]);
      terrain.setTexture("test.jpg", 4);
      obelisk.setTexture(distortion[1]);
    }
  }
  
  

  
long t = millis() - time;
time = millis();

// Update shapes on terrain
update(t/1004.0);

  // Update camera speed and direction
  if (keyPressed) {
    if (key == 'W' || key =='w' || key == 'P' || key == 'p') {
      camSpeed += (t/10.0f);
      cam.speed(camSpeed);
    }
    else if (key == 'S' || key =='s' || key == 'L' || key == 'l') {
      camSpeed -= (t/10.0f);
      cam.speed(camSpeed);
    }
    else if (key == ' ') {
      camSpeed = 0;
      cam.speed(camSpeed);
    }

    if (keyCode == UP) {
      camHoversAt += (t/10f);
      println(camHoversAt);
    }
    if (keyCode == DOWN) {
      camHoversAt -= (t/10f);
      println(camHoversAt);
    }
    
    if (key =='c'){
      cam.turnBy(t/15f);
      cam.rotateViewBy(t/15f);
    }
    
     if (keyCode == RIGHT){
       cam.turnBy(t/1000f);
      cam.rotateViewBy(t/1000f);
    }
    
     if (keyCode == LEFT){
      cam.rotateViewBy(t/-1000f);
      cam.turnBy(t/-1000f);
    }
    
    if (camHoversAt < 4){
     camHoversAt += (t/10f);
  }
  if (camHoversAt > 212){
     camHoversAt -= (t/10f);
  }

    if (key == 'u') {
      terrain.usePerlinNoiseMap(20, 50*t/8, .5, 1);
    }

    if (key == 'd') {
      terrain.usePerlinNoiseMap(20, 50/t, .5, 1);
    }

    if (key == 'x') {
      terrain.usePerlinNoiseMap(20, 50, .5, 2*t/8);
    }

    if (key == 'z') {
      terrain.usePerlinNoiseMap(20, 50, .5, 2/t);
    }

    if (key == 'q') {
      for (int i = 0; i < nbrDroids; i++) {
        //droids[i].setTexture(textures[1+1]
        droids[i].tagNo = (droids[i].tagNo + 1) % faces.length;
        droids[i].setTexture(faces[droids[i].tagNo]);
        terrain.setTexture("terrain1.jpg", 3);
        obelisk.setTexture("kawaii1.jpg");
      }
      terrain.usePerlinNoiseMap(57, 120, 3*t/2, 10);
    }

    if (key == 'e') {
      terrain.usePerlinNoiseMap(20, 50, 2/t, 1);
    }
    if (key == 'm') {
      for (int i = 0; i < nbrDroids; i++) {
        //droids[i].setTexture(textures[1+1]
        droids[i].tagNo = (droids[i].tagNo + 1) % faces.length;
        droids[i].setTexture(faces[droids[i].tagNo]);
        terrain.setTexture("terrain1.jpg", 3);
        obelisk.setTexture("kawaii1.jpg");
      }
    }

    if (key == 'f') {
      for (int i = 0; i < nbrDroids; i++) {
        droidDirs[i] = getRandomVelocity(random(5, 15));
      }
    }
 if (key == 'g') {
      for (int i = 0; i < nbrDroids; i++) {
        droidDirs[i] = getRandomVelocity(random(0, 1));
      }
    }

    if (key == 'v') {
      for (int i = 0; i < nbrDroids; i++) {
        droids[i].visible(true);
      }
    }
    
    if (key == 'b') {
      for (int i = 0; i < nbrDroids; i++) {
        droids[i].visible(false);
      }
    }
    if (key == 'n') {
      for (int i = 0; i < nbrDroids; i++) {
     droids[i].setSize(35, 35, random(50, 150));
  }
    }
    
    if (key == 'k') {
      cam.speed(800);
    }
    
    if (key == 'j') {
      cam.speed(-800);
    }
    
    if (key == 'r') {
      cam.speed(80.0);
    }
  }


  // Calculate amount of movement based on velocity and time
  cam.move(t/1000.0f);
  // Adjust the cameras position so we are over the terrain
  // at the given height.
  cam.adjustToTerrain(terrain, Terrain.WRAP, camHoversAt);
  // Set the camera view before drawing
  cam.camera();

  obelisk.draw();
  terrain.draw();
  



  // Get rid of directional lights so skybox is evenly lit.
  skybox.moveTo(cam.eye().x, 0, cam.eye().z);

  skybox.draw();
}

//btube.draw();

void keyPressed() {
  if (key == 'h' || key == 'H') {
    lightTexture = !lightTexture;
    
  }
}


/**
 * Update artefacts and seekers
 */
public void update(float time) {
  PVector np;
  obelisk.rotateBy(0, time*radians(6.3), 0);
  for (int i = 0; i < nbrDroids; i++) {
    np = PVector.add(droids[i].getPosVec(), PVector.mult(droidDirs[i], time));
    droids[i].moveTo(np);
    droids[i].adjustToTerrain(terrain, Terrain.WRAP, -15);
  }
}




public PVector getRandomPosOnTerrain(Terrain t, float tsize, float height) {
  PVector p = new PVector(random(-tsize/2.1f, tsize/2.1f), 0, random(-tsize/2.1f, tsize/2.1f));
  p.y = t.getHeight(p.x, p.z) - height;
  return p;
}

/**
 * Get random direction for seekers.
 * @param speed
 */
public PVector getRandomVelocity(float speed) {
  PVector v = new PVector(random(-10000, 10000), 0, random(-10000, 10000));
  v.normalize();
  v.mult(speed);
  return v;
}




