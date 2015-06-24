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