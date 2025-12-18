float angle = 0;
int layerDepth = 8;
boolean animRunning = true;
boolean nightMode = false;
float zoom = 1.0;

void setup() {
  size(800, 800);
  smooth();
}

void draw() {
  background(nightMode ? color(10, 10, 30) : color(245, 235, 210));
  translate(width/2, height/2);
  scale(zoom);
  rotate(map(mouseX, 0, width, -PI/4, PI/4));
  
  layerDepth = int(map(mouseY, 0, height, 4, 16));
  
  drawGrokAnatomy(0, 0, 200, layerDepth);
  
  fill(nightMode ? 200 : 0);
  textSize(14);
  text("Schichten: " + layerDepth + " | Zoom: " + nf(zoom, 1, 1) + " | Anim: " + (animRunning ? "an" : "aus"), -width/2 + 10, -height/2 + 20);
}

void drawGrokAnatomy(float x, float y, float size, int depth) {
  if (depth == 0) return;
  
  float pulse = sin(frameCount * 0.05) * 5 * (animRunning ? 1 : 0);
  
  // Zentraler Kern (KI-Gehirn)
  noStroke();
  fill(nightMode ? color(0, 200, 255, 200) : color(0, 100, 200, 180));
  ellipse(x, y, size + pulse, size + pulse);
  
  // Neuronale Verbindungen (Muskeln)
  stroke(nightMode ? color(0, 255, 255, 180) : color(0, 150, 255, 180));
  strokeWeight(2);
  
  int branches = 8 + depth;
  for (int i = 0; i < branches; i++) {
    float a = map(i, 0, branches, 0, TWO_PI) + frameCount * 0.01;
    float len = size * 0.8;
    float bx = x + cos(a) * len;
    float by = y + sin(a) * len;
    line(x, y, bx, by);
    
    // Kleine Knoten (Synapsen)
    noStroke();
    fill(nightMode ? color(255, 255, 0, 200) : color(255, 200, 0, 200));
    ellipse(bx, by, 8, 8);
  }
  
  // Rekursive Schichten (tiefer ins Netz)
  float newSize = size / 1.618;  // Goldener Schnitt für Harmonie
  if (depth > 1) {
    drawGrokAnatomy(x + cos(frameCount * 0.02) * 20, y + sin(frameCount * 0.03) * 20, newSize, depth - 1);
  }
}

void mouseWheel(MouseEvent event) {
  zoom += event.getCount() * -0.1;
  zoom = constrain(zoom, 0.5, 3.0);
}

void keyPressed() {
  if (key == 's' || key == 'S') {
    saveFrame("grok_anatomy-####.png");
    println("Bild gespeichert!");
  }
  if (key == 'r' || key == 'R') {
    angle = 0;
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
}
