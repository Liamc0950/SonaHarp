//Sonar Theremin
//Liam Corley
//12-17-19


class GUI{
  
  ArrayList<Button> buttons; //ArrayList of all buttons
  HashMap<String,Boolean> idMap; //Hashmap of button ids to boolean (pressed/not pressed)

  GUI(){
    buttons = new ArrayList<Button>();
    idMap = new HashMap<String,Boolean>();
  }
  
  //Add button to sketch
  //Adds button to ArrayList, adds id and pressed value to HashMap
  void addButton(Button b){
    buttons.add(b);
    idMap.put(b.getId(), false);
    b.drawButton();
  }
  
  //Update should be called in MousePressed()
  //If mouse is in button zone, change pressed value
  //Re-draws button
  void update(){
    for(int i = 0; i < buttons.size(); i++){
      Button b = buttons.get(i); 
      if(mouseX >= b.getX() && mouseX <= (b.getX() + b.getW()) &&
         mouseY >= b.getY() && mouseY <= (b.getY() + b.getH())){
           b.toggle();
           idMap.replace(b.getId(), b.getPressed());
      }
      b.drawButton();
    }
  }
  //Draws all buttons
  //Should be called in Draw()
  void drawButtons(){
    for(int i = 0; i < buttons.size(); i++){
      Button b = buttons.get(i); 
      b.drawButton();
    }
  }
  
  //Get boolean value of a given button based on its ID
  boolean getPressed(String id){
    return idMap.get(id);
  }
}
