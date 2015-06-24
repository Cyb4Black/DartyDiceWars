part of DartyDiceWars;

class DiceController{

  
  final view = new DiceView();
  var game;
  
  
  DiceController(){
    
    view.startButton.onClick.listen((_){
      game = new DiceGame(60, 32,1);
      view.initializeViewField(game);
      view.testButton.style.display = "";
    });
    
    view.testButton.onClick.listen((_){
      view.updateFieldWithTerritorys(game);
    });
    
    Element loadLevelData(int levelnr) {
      HtmlElement level;
      
      
      return level;
    }
    
  }
  
}