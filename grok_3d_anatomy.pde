float angleX = 0;
float angleY = 0;
float zoom = 1.0;
int layerDepth = 8;
boolean animRunning = true;
boolean nightMode = false;
ArrayList<PVector> nodes = new ArrayList<PVector>();

void setup() {
  size(800, 800, P3D);
  smooth();
}

void draw() {
  background(nightMode ? color(10, 10, 30) : color(245, 235, 210));
  lights();
  directionalLight(255, 255, 255, 0, 0, -1);
  
  translate(width/2, height/2);
  scale(zoom);
  rotateX(angleY);
  rotateY(angleX);
  
  layerDepth = int(map(mouseY, 0, height, 4, 16));
  
  drawGrok3DAnatomy(0, 0, 0, 200, layerDepth);
  
  // Interaktive Knoten (Klick macht sie rot/leuchtend)
  if (mousePressed) {
    for (PVector node : nodes) {
      float d = dist(node.x, node.y, node.z, mouseX - width/2, mouseY - height/2, 0);
      if (d < 20) {
        pushMatrix();
        translate(node.x, node.y, node.z);
        fill(255, 0, 0, 255);
        sphere(12);
        popMatrix();
      }
    }
  }
  
  fill(nightMode ? 200 : 0);
  textSize(14);
  text("Schichten: " + layerDepth + " | Zoom: " + nf(zoom, 1, 1) + " | + / - zum Zoomen", -width/2 + 10, -height/2 + 20);
}

void drawGrok3DAnatomy(float x, float y, float z, float size, int depth) {
  if (depth == 0) return;
  
  float pulse = sin(frameCount * 0.05) * 5 * (animRunning ? 1 : 0);
  
  // Zentraler Kern (transparent, hinten)
  pushMatrix();
  translate(x, y, z);
  noStroke();
  fill(nightMode ? color(0, 200, 255, 100) : color(0, 100, 200, 100));
  sphere(size + pulse);
  popMatrix();
  
  // Neuronale Verbindungen
  stroke(nightMode ? color(0, 255, 255, 180) : color(0, 150, 255, 180));
  strokeWeight(2);
  
  int branches = 12 + depth;
  for (int i = 0; i < branches; i++) {
    float a = map(i, 0, branches, 0, TWO_PI) + frameCount * 0.01;
    float len = size * 0.8;
    float bx = x + cos(a) * len;
    float by = y + sin(a) * len;
    float bz = z + sin(a * 1.5) * len * 0.5;
    
    line(x, y, z, bx, by, bz);
    
    // Knoten
    pushMatrix();
    translate(bx, by, bz);
    noStroke();
    fill(nightMode ? color(255, 255, 0, 200) : color(255, 200, 0, 200));
    sphere(8);
    popMatrix();
    
    // Binärcode entlang der Verbindung
    drawBinaryAlongLine(x, y, z, bx, by, bz);
  }
  
  // Rekursion – Goldener Schnitt, Extrusion NACH VORNE (kleine Schichten vorne)
  float phi = (1 + sqrt(5)) / 2;
  float layerOffset = size * phi * 0.6;
  float newSize = size / phi;
  if (depth > 1) {
    drawGrok3DAnatomy(x, y, z + layerOffset, newSize, depth - 1);  // Kleine Schichten vorne!
  }
}

void drawBinaryAlongLine(float x1, float y1, float z1, float x2, float y2, float z2) {
  String bin = "010101011001010101110101010101";
  int len = bin.length();
  
  float dx = x2 - x1;
  float dy = y2 - y1;
  float dz = z2 - z1;
  
  pushMatrix();
  for (int i = 0; i < len; i++) {
    float t = i / (float)len;
    float px = x1 + t * dx;
    float py = y1 + t * dy;
    float pz = z1 + t * dz;
    
    pushMatrix();
    translate(px, py, pz);
    rotateY(frameCount * 0.05);
    fill(nightMode ? color(0, 255, 0, 200) : color(0, 255, 0, 200));
    textSize(10);
    text(bin.charAt(i), 0, 0);
    popMatrix();
  }
  popMatrix();
}

void keyPressed() {
  if (key == 's' || key == 'S') {
    saveFrame("grok_3d_anatomy-####.png");
    println("Bild gespeichert!");
  }
  if (key == 'r' || key == 'R') {
    angleX = 0;
    angleY = 0;
    zoom = 1.0;
    println("Reset");
  }
  if (key == 'a' || key == 'A') {
    animRunning = !animRunning;
    println("Animation " + (animRunning ? "an" : "aus"));
  }
  if (key == 'n' || key == 'N') {
    nightMode = !nightMode;
    println("Nachtmodus " + (nightMode ? "an" : "aus"));
  }
  if (key == '+') {
    zoom += 0.2;
    zoom = constrain(zoom, 0.5, 5.0);
    println("Zoom: " + zoom);
  }
  if (key == '-') {
    zoom -= 0.2;
    zoom = constrain(zoom, 0.5, 5.0);
    println("Zoom: " + zoom);
  }
}
