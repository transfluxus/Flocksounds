String song = "Frances9b.mp3";
static final int FORMS = 0, GRADIANTS= 1;

int boidsMode = GRADIANTS;

boolean renderFlock = true;
boolean renderBoid = true;
boolean renderNbs = true;
// first update all, then render in order by rendertype
boolean renderOrder=true;
//String renderFcts[] = {renderNbs,renderBoid};


boolean recordSound=false;
boolean captureImages= false;
int autoEnd = -1;

int n=400;

int lineConnect = 8;
float maxConnectStrokeWeight = 3;
boolean nbCohesion = true;
boolean nbAlign = true;

boolean clearFrameScreen = true;

color bgClr = color(0, 100, 200);


