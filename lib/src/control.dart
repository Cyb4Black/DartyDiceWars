part of DartyDiceWars;

class DartyDiceController{

  
  final view = new DartyDiceView();
  var game;
  
  DartyDiceController(){
    view.startButton.onClick.listen((_){
      game = new DiceGame(60, 32,1);
      view.initializeViewField(game);
      view.testButton.style.display = "";
    });
    
    view.testButton.onClick.listen((_){
      view.updateFieldWithTerritorys(game);
    });
    
  }
}