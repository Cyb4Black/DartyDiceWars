part of DartyDiceWars;

class DartyDiceController{

  
  final view = new DartyDiceView();
  var game;
  
  DartyDiceController(){
    view.startButton.onClick.listen((_){
      game = new DartyDiceGame(32, 28,1);
      view.initializeViewField(game);
    });
    
  }
}