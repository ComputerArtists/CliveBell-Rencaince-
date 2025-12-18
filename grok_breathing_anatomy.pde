float phi = (1 + sqrt(5)) / 2;
float angleX = 0;
float angleY = 0;
float zoom = 1.0;
int layerDepth = 8;
boolean animRunning = true;
boolean nightMode = false;
float breathSpeed = 0.02;
color neon;

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
  breathSpeed = map(mouseY, 0, height, 0.005, 0.05);  // Maus-Y steuert Atemgeschwindigkeit
  
  drawGrokBreathingAnatomy(0, 0, 0, 200, layerDepth);
  
  fill(nightMode ? 200 : 0);
  textSize(14);
  text("Schichten: " + layerDepth + " | Atem-Speed: " + nf(breathSpeed, 1, 3) + " | + / - zum Zoomen", -width/2 + 10, -height/2 + 20);
}

void drawGrokBreathingAnatomy(float x, float y, float z, float size, int depth) {
  if (depth == 0) return;
  
  float pulse = sin(frameCount * breathSpeed) * 5 * (animRunning ? 1 : 0);
  
  // Zentraler Kern (transparent)
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
    float len = size * 0.8 * (1 + pulse * 0.01);
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
  }
  
  // Goldener Schnitt-Spirale als "Atem" – pulsiert mit Phi
  noFill();
  // Zufällige Neon-Farbe (jede Schleife neu)
  stroke(neon);
  strokeWeight(3);
  beginShape();
  float breathScale = 1 + sin(frameCount * breathSpeed) * 0.3;  // Atmen
  for (float t = 0; t < TWO_PI * depth; t += 0.1) {
    float r = size * breathScale * pow(phi, t / TWO_PI);  // Log-Spirale mit Phi
    float cx = x;
    float cy = y;
    float px = cx + r * cos(t + frameCount * breathSpeed);
    float py = cy + r * sin(t + frameCount * breathSpeed);
    float pz = z + sin(t) * r * 0.2;
    vertex(px, py, pz);
  }
  endShape();
  
  // Rekursion – Extrusion nach vorne
  float layerOffset = size * phi * 0.6;
  float newSize = size / phi;
  if (depth > 1) {
    drawGrokBreathingAnatomy(x, y, z + layerOffset, newSize, depth - 1);
  }
}

void keyPressed() {
  if (key == 's' || key == 'S') {
    saveFrame("grok_breathing_anatomy-####.png");
    println("Bild gespeichert!");
  }
  if (key == 'r' || key == 'R') {
    angleX = 0;
    angleY = 0;
    zoom = 1.0;
    float hue = random(360);
    neon = color(hue, 255, 255, 200 + sin(frameCount * breathSpeed * 2) * 55);  // Pulsierender Glow
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
  }
  if (key == '-') {
    zoom -= 0.2;
    zoom = constrain(zoom, 0.5, 5.0);
  }
}
