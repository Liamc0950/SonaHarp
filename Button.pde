//Sonar Theremin
//Liam Corley
//12-17-19



//Button class
//Currently all buttons are Toggles


class Button{
  int x;
  int y;
  int w;
  int h;
  
  color c = color(255,255,255);
  color oldC = c;
  
  String label;
  String id;
  
  boolean pressed = false;
  
  //Button Constructor
  Button(int xArg, int yArg, int wArg, int hArg, String lArg, String idArg, color col){
     x = xArg;
     y = yArg;
     w = wArg;
     h = hArg;
     label = lArg;
     id = idArg;
          
     c = col;
     oldC = c;
  }
  
  //toggles color and pressed value of button
  void toggle(){
    if(pressed == false){
      pressed = true;
      c = color(255);
      return;
    }
    if(pressed == true){
      pressed = false;
      c = oldC;
      return;
    }
  }
  
  //Draw button, flexibly positions label in button
  void drawButton(){
    fill(c);
    rect(x, y, w, h);
    fill(0);
    textSize(12);
    text(label, (x + w/8), (y + h/2));
  }
  
  
  //getters
  int getX(){return x;}
  int getY(){return y;}
  int getW(){return w;}
  int getH(){return h;}
  String getId(){return id;}
  boolean getPressed(){return pressed;}
  
  //setters
  void setX(int n){x = n;}
  void setY(int n){y = n;}
  void setW(int n){w = n;}
  void setH(int n){h = n;}
  
}
