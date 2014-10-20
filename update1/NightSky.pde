/**
 * Night Sky 
 * JavaScript version
 */
final static int R = 100;
PMatrix3D cam;
float[][] stars;
float inc = 100;

boolean started = false;

PVector eye = new PVector(0,0,0);

void mousePressed() {
	started = true;
}

int WINDOW_WIDTH = 640;
int WINDOW_HEIGHT = 480;

void setup() {
	size(WINDOW_WIDTH, WINDOW_HEIGHT, P3D);
	frameRate(30);
	sphereDetail(30);
	stars = new float[1500][3];
	for (int i = 0; i < stars.length; i++) {
		float p = random(-PI, PI);
		float t = asin(random(-1, 1));
		stars[i] = new float[] {
		  R * cos(t) * cos(p),
		  R * cos(t) * sin(p),
		  R * sin(t)
		};
	}
	cam = new PMatrix3D();

	textAlign(CENTER, CENTER);
	background(0);
	fill(255);
	text("Click to start 'Night Sky'. Use WASD to look around. Try to find the red star.", width / 2, height / 2);
}

void draw() {
	if (started) {
		// all keyboard controls
		processInput();
		
		PVector x = cam.mult(new PVector(1, 0, 0), new PVector(0, 0, 0));
		PVector y = cam.mult(new PVector(0, 1, 0), new PVector(0, 0, 0));
		PVector d = x.cross(y); 
		d.normalize(); 
		d.mult(R);
		
		
		background(0);
		noStroke();
		camera(eye.x, eye.y, eye.z, d.x, d.y, d.z, y.x, y.y, y.z);
		
		directionalLight(222, 244, 255, 0, 0, -1);
		lightSpecular(0, 0, 0);
		
		for(int i = 0; i < stars.length - 1; i++) {
			pushMatrix();
			translate(stars[i][0], stars[i][1], stars[i][2]);
			fill(255);
			sphere(5);
			popMatrix();
		}
		
		pushMatrix();
		translate(stars[1499][0], stars[1499][1], stars[1499][2]);
		fill(255, 0, 0);
		sphere(10);
		popMatrix();

		camera();
		stroke(255);
		line(width / 2 - 9, height / 2 - 0, width / 2 + 8, height / 2 + 0);
		line(width / 2 - 0, height / 2 - 9, width / 2 + 0, height / 2 + 8);
	}
}

// keep track of multiple key presses
boolean[] keys = new boolean[526];
void keyPressed() { keys[keyCode] = true; }
void keyReleased() { keys[keyCode] = false; }
boolean pressed(int k) {
	return keys[(int)k];
}

// define all keyboard controls here
void processInput() {
	if (pressed('A'))
		cam.rotateY(-(inc - height / 2.0) / height / 20);
	if (pressed('D'))
		cam.rotateY((inc - height / 2.0) / height / 20);
	if (pressed('W'))
		cam.rotateX(-(inc - height / 2.0) / height / 20);
	if (pressed('S'))
		cam.rotateX((inc - height / 2.0) / height / 20); 
	if (pressed(LEFT))
		eye.x ++;
	if (pressed(RIGHT))
		eye.y ++;
	if (pressed(DOWN))
		eye.z ++;
}
