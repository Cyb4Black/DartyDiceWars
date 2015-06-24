part of DartyDiceWars;

class DiceController{

  
  final view = new DiceView();
  var game;
  XmlNode level;
  
  DiceController() {
    
    view.startButton.onClick.listen((_) {
      
      startGame(1);
    
    });
    
    view.testButton.onClick.listen((_){
      view.updateFieldWithTerritorys(game);
    });
    
    
  }

  startGame(int levelnr) async {
        await loadLevelData(levelnr);
       game = new DiceGame(60, 32, level);
       view.initializeViewField(game);
       view.testButton.style.display = "";
       
       view.arena.onMouseEnter.listen((ev) {
                 querySelectorAll('.hex').onClick.listen((_) {
                   print(_.currentTarget.id.toString());
                   _.currentTarget.style.background = "rgb(255, 0, 0)";
                   //game.selectTerritory(_.currentTarget.id);
                   //if (TerritorySelected) 
                 });
                 querySelectorAll('.corner-1').onClick.listen((_) {
                         print(_.currentTarget.parentNode.id.toString());
                         _.currentTarget.parentNode.style.background = "rgb(255, 0, 0)";
                         //game.getTerritory(_.currentTarget.id);
                       });
                 
                 querySelectorAll('.corner-2').onClick.listen((_) {
                         print(_.currentTarget.parentNode.id.toString());
                         _.currentTarget.parentNode.style.background = "rgb(255, 0, 0)";
                         //game.getTerritory(_.currentTarget.id);
                       });
               });
  }
  
  
  onTurn() {
    
  }
  
  
  
  
  
  
  
  
  
  
  
  Future<XmlNode> loadLevelData(int levelnr) async{
      Future<XmlNode> ret;
      try {
       dynamic file = await HttpRequest.getString('levels.xml');
        var levels = parse(file);
        print(file);
        for (XmlNode x in levels.firstChild.children) {
           if (x.attributes[0].value == levelnr.toString()) {
             level = x;
           }
        }
      } catch (e) {
        print("NIGGA"+e.toString());
      }
      return ret;
  }
  
}