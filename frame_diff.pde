import processing.video.*;
Capture video;
PImage result;
PImage prev;
boolean fFlag=true;
long prevsum=0;
int prevgi=0;
int prevgii=0;
int pointi[]=new int[0];
int pointii[]=new int[0];
int bg=0;
int bugi=0;
int bugii=0;
boolean clear=false;
void setup() {
  size(640, 480);
  colorMode(RGB);
  video = new Capture(this, width, height, 30);
  result = createImage(video.width, video.height, RGB);
  prev = createImage(video.width, video.height, RGB);
  video.start();
}

void draw() {
  int gi=0;
  int gii=0;
  int cou=0;
  long sum=0; 
  int hidecou=0;
  if (clear) {
    bg=255;
  }
  if (video.available()) {
    video.read();
    if (fFlag) {
      prev=video.get();
      fFlag=false;
    }
  }
  if (!clear) {
    bugi+=int(random(-50, 50));
    bugii+=int(random(-50, 50));
  }
  if (bugi<0)bugi*=-1;
  if (bugii<0)bugii*=-1;
  if (bugi>video.width)bugi-=(bugi-video.width);
  if (bugii>video.height)bugii-=(bugii-video.height);
  for (int i=0; i<video.width; i++) {
    for (int ii=0; ii<video.height; ii++) {
      int tmp=video.get(i, ii);
      if (abs(blue(tmp)-blue(prev.get(i, ii)))+abs(red(tmp)-red(prev.get(i, ii)))+abs(green(tmp)-green(prev.get(i, ii)))<200) {
        //result.set(i, ii, 0);
      } else {
        gi+=i;
        gii+=ii;
        sum+=i*i;
        cou++;
        //result.set(i, ii, color(255));
      }
      for (int iii=0; iii<=pointi.length; iii++) {
        if (iii==pointi.length) {
          result.set(i, ii, color(bg));
          hidecou+=1;
          break;
        }
        if (sqrt(abs(pointi[iii]-i)*abs(pointi[iii]-i)+abs(pointii[iii]-ii)*abs(pointii[iii]-ii))<100) {
          result.set(i, ii, tmp);
          break;
        }
      }
    }
  }
  for (int i=0; i<(clear?50:10); i++) {
    for (int ii=0; ii<(clear?50:10); ii++) {
      if (clear) {
        result.set(bugi+i-5, bugii+ii-5, color(random(200,255), random(0,255), random(0,255)));
      } else {
        result.set(bugi+i-5, bugii+ii-5, color(0, 0, 0));
      }
    }
  }

  bg=(230-230*hidecou/(video.width*video.height))+25;
  if (cou>0) {
    gi/=cou;
    gii/=cou;
    if (gi*gi>0) {
      sum/=cou;
      sum-=gi*gi;
      sum=int(sqrt(parseFloat(int(sum))));
    }
  } else {
    gi=0;
    gii=0;
  }

  if (cou>180 && sum<80) {
    for (int i=0; i<10; i++) {
      for (int ii=0; ii<10; ii++) {
        result.set(gi+i-5, gii+ii-5, color(255, 0, 0));
      }
    }
  } else {
    gi=0;
    gii=0;
  }
  if (prevsum>sum && prevsum>0  && gi==0 && gii==0 && prevgi!=0 && prevgii!=0) {
    if ((prevgi-bugi)*(prevgi-bugi)+(prevgii-bugii)*(prevgii-bugii)<10000)clear=true;
    println((prevgi-bugi)*(prevgi-bugi)+(prevgii-bugii)*(prevgii-bugii));
    prevsum=0;
    pointi=(int[])append(pointi, prevgi);
    pointii=(int[])append(pointii, prevgii);
    //println("↓↓");
    //println(pointi.length);
  }
  prevsum=sum;
  prevgi=gi;
  prevgii=gii;
  image(result, 0, 0);
  prev=video.get();
}