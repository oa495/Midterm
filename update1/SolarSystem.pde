WINDOW_SIZE = 640;

PImage sun;
PFont font;
Planet[] planets = new Planet[9];
boolean started = false;

void mousePressed() {
	started = true;
}

void setup() {
	size(WINDOW_SIZE, WINDOW_SIZE, P3D);
	stroke(0);
	
	for (int i = 0; i< planets.length; i++ ) {
		float x = random(1,WINDOW_SIZE);
		float y = random(1,WINDOW_SIZE);
		float z = random(1,WINDOW_SIZE);
		int xy = int (x);
		int yx = int (y);
		int zz = int (z - (WINDOW_SIZE / 2));
		int co = int(random(1,255));
		int col = int(random(1,255));
		int colo = int(random(1,255));
		float diameter = random(10,45);
		float velx1 = random(0,2.1);
		float vely1 = random(0,2.1);
		float velz1 = random(0,2.1);
		
		if (i == planets.length-1){
			xy = width/2;
			yx = height/2;
			zz = 0;
			velz1 = 0;
			diameter = 100;
			velx1 = 0;
			vely1 = 0;
		}

		planets[i] = new Planet(diameter,xy,yx,zz,co,col,colo,i,velx1,vely1,velz1);
	}

	textAlign(CENTER, CENTER);
	background(0);
	fill(255);
	text("Click to start 'Solar System'. Move the mouse along the main diagonal to zoom in and out.", width / 2, height / 2);
}


void draw() {
	if (started) {
		float cameraZ = ((height/2.0) / tan(PI*60.0/360.0));
		
		camera(width/2.0, height/2.0, (height/2) / tan(PI*60.0 / 360.0), width/2.0, height/2.0, WINDOW_SIZE / 2, 0, 1, 0);
		perspective(mouseX/float(width)*PI/2, 1, cameraZ/10, cameraZ*10);
		
		float dirY = (mouseY / float(height) - 0.5) * 2;
		float dirX = (mouseX / float(width) - 0.5) * 2;
		
		directionalLight(222, 244, 255, -dirX, -dirY, -1);
		lightSpecular(0, 0, 0); 
		
		for (int i = 0; i < planets.length; i++ ) {
			planets[i].display(i);
			planets[i].update();
		}
	}
}

class Planet {
	int t;
	float xcc = 0;
	float ycc = 0;
	float zcc = 0;
	float xpos;
	float ypos;
	float zpos;
	float diameter;
	int sunypos = WINDOW_SIZE / 2;
	int sunxpos = WINDOW_SIZE / 2;
	float gravmax = .1;
	int col1;
	int col2;
	int col3;
	int curplanet;
	int num;
	int i = 1;

	Planet(float diameter_,float xpos_,float ypos_,float zpos_,int co1,int co2,int co3,int planet,float velx,float vely,float velz) {
		diameter =  diameter_;
		xpos = (xpos_);
		ypos = (ypos_);
		zpos = (zpos_);
		col1 = co1;
		col2 = co2;
		col3 = co3;
		curplanet = planet;
		xcc = velx;
		ycc = vely;
		zcc = velz;
	}

	void update() {
		for (int i = 0;i < planets.length; i++) {
			if (i == curplanet) continue;
			if (planets.length-1 ==curplanet) continue;
			
			float area1 = ((((planets[i].diameter/2))*(planets[i].diameter/2)*(planets[i].diameter/2))*Math.PI);
			float disty = (planets[i].ypos - ypos);
			float distx = (planets[i].xpos - xpos);
			float distz = (planets[i].zpos - zpos);
			float distfull = sqrt((distz*distz)+(distx*distx+disty*disty));
			
			if (distfull < (planets[i].diameter / 2)) continue;
			float acc = (.01) * (area1 / (distfull * distfull));
			zcc += (acc * distz / distfull);
			xcc += (acc * distx / distfull); 
			ycc += (acc * disty / distfull);
		}
		
		zpos += zcc;
		xpos += xcc;
		ypos += ycc;
	}

	void display(int ti) {
    	t = ti+1;
    	
    	stroke(0);
		if (curplanet == i) {
			fill(0,0,0,10);
			background(0);
		}

		if(curplanet != 0) fill(col1,col2,col3);
    	else fill(255,255,255);
    	if(curplanet == planets.length -1) fill(255,255,0,233);

		noStroke();
		pushMatrix();
		translate(xpos, ypos, zpos);
		sphere(diameter);
		popMatrix();
	}
}