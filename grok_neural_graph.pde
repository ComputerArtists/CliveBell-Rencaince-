float angleX = 0;
float angleY = 0;
float zoom = 1.0;
int layerDepth = 2;  // Startwert – klein und stabil
boolean animRunning = true;
boolean nightMode = false;
float neonHue = random(360);

ArrayList<PVector> nodes = new ArrayList<PVector>();
ArrayList<Integer> connections = new ArrayList<Integer>();

void setup() {
  size(800, 800, P3D);
  smooth();
  generateNeuralGraph(0, 0, 0, 200, layerDepth);  // Initial
}

void draw() {
  background(nightMode ? color(10, 10, 30) : color(245, 235, 210));
  lights();
  directionalLight(255, 255, 255, 0, 0, -1);
  
  translate(width/2, height/2);
  scale(zoom);
  rotateX(angleY);
  rotateY(angleX);
  
  // Live-Tiefe mit MouseY – nur bei Änderung neu generieren
  int newDepth = int(map(mouseY, 0, height, 1, 4));  // Max 4 für Stabilität
  if (newDepth != layerDepth) {
    layerDepth = newDepth;
    nodes.clear();
    connections.clear();
    generateNeuralGraph(0, 0, 0, 200, layerDepth);  // Neu generieren
    println("Tiefe geändert zu: " + layerDepth);
  }
  
  drawNeuralGraph();
  
  fill(nightMode ? 200 : 0);
  textSize(14);
  text("Schichten: " + layerDepth + " | Zoom: " + nf(zoom, 1, 1) + " | + / - zum Zoomen", -width/2 + 10, -height/2 + 20);
}

// Rest des Codes (generateNeuralGraph, drawNeuralGraph, drawBinaryAlongLine, keyPressed) bleibt gleich

void generateNeuralGraph(float x, float y, float z, float size, int depth) {
  if (depth <= 0) return;
  
  // Aktueller Knoten
  int currentIndex = nodes.size();
  nodes.add(new PVector(x, y, z));
  
  int branches = 6 + depth;  // Weniger Branches für Kontrolle
  for (int i = 0; i < branches; i++) {
    float a = map(i, 0, branches, 0, TWO_PI) + frameCount * 0.01;
    float len = size * 0.8;
    float bx = x + cos(a) * len;
    float by = y + sin(a) * len;
    float bz = z + sin(a * 1.5) * len * 0.5;
    
    // Neuen Knoten hinzufügen
    int newIndex = nodes.size();
    nodes.add(new PVector(bx, by, bz));
    
    // Verbindung zum aktuellen Knoten
    connections.add(currentIndex);
    connections.add(newIndex);
    
    // Rekursion nur einmal pro Knoten
    if (depth > 1) {
      generateNeuralGraph(bx, by, bz, size / 1.618, depth - 1);
    }
  }
}

void drawNeuralGraph() {
  // Kern
  pushMatrix();
  translate(nodes.get(0).x, nodes.get(0).y, nodes.get(0).z);
  noStroke();
  fill(nightMode ? color(0, 200, 255, 100) : color(0, 100, 200, 100));
  sphere(50);
  popMatrix();
  
  // Verbindungen
  stroke(nightMode ? color(0, 255, 255, 180) : color(0, 150, 255, 180));
  strokeWeight(2);
  
  for (int i = 0; i < connections.size(); i += 2) {
    int idx1 = connections.get(i);
    int idx2 = connections.get(i + 1);
    PVector p1 = nodes.get(idx1);
    PVector p2 = nodes.get(idx2);
    
    line(p1.x, p1.y, p1.z, p2.x, p2.y, p2.z);
    
    // Binärcode entlang der Verbindung
    drawBinaryAlongLine(p1.x, p1.y, p1.z, p2.x, p2.y, p2.z);
  }
  
  // Knoten
  for (PVector node : nodes) {
    pushMatrix();
    translate(node.x, node.y, node.z);
    noStroke();
    fill(nightMode ? color(255, 255, 0, 200) : color(255, 200, 0, 200));
    sphere(8);
    popMatrix();
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
    saveFrame("grok_neural_graph-####.png");
    println("Bild gespeichert!");
  }
  if (key == 'r' || key == 'R') {
    angleX = 0;
    angleY = 0;
    zoom = 1.0;
    neonHue = random(360);
    generateNeuralGraph(0, 0, 0, 200, 1);  // Einmalig generieren
    println("Reset – neue Neon-Farbe");
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
