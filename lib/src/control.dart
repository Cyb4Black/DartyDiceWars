part of DartyDiceWars;

class DiceController{

  
  final view = new DiceView();
  var game;
  XmlNode level;
  
  DiceController() {
    String lastselected ="";
    view.startButton.onClick.listen((_) {
      
      startGame(1);
    
    });
    
    view.testButton.onClick.listen((_){
      view.updateFieldWithTerritorys(game);
    });
    
    view.arena.onMouseEnter.listen((ev) {
              querySelectorAll('.hex').onClick.listen((_) {
                if (lastselected !=_.currentTarget.id.toString() && game.currentPlayer.id == "human") {
                  lastselected = _.currentTarget.id.toString();
                  //GET THE FITTING TERRITORY
                  //in game, if none selected mark that territory as selected
                  //in game, if one selected do selectedTerritory.attackTerritory(2nd Territory)
                  
               // print(_.currentTarget.id.toString());
                _.currentTarget.style.background = "rgb(255, 0, 0)";
                //game.selectTerritory(_.currentTarget.id);
                //if (TerritorySelected) 
                return;
                }
              });
              querySelectorAll('.corner-1').onClick.listen((_) {
                if (lastselected != _.currentTarget.parentNode.id.toString() && game.currentPlayer.id == "human") {
                  lastselected = _.currentTarget.parentNode.id.toString();
                      //print(_.currentTarget.parentNode.id.toString());
                      _.currentTarget.parentNode.style.background = "rgb(255, 0, 0)";
                      //game.getTerritory(_.currentTarget.id);
                      return;}
                    });
              
              querySelectorAll('.corner-2').onClick.listen((_) {
                if (lastselected != _.currentTarget.parentNode.id.toString() && game.currentPlayer.id == "human") {
                  lastselected = _.currentTarget.parentNode.id.toString();
                    //  print(_.currentTarget.parentNode.id.toString());
                      _.currentTarget.parentNode.style.background = "rgb(255, 0, 0)";
                      //game.getTerritory(_.currentTarget.id);
                      return;}
                    });
            });
  }

  startGame(int levelnr) async {
        await loadLevelData(levelnr);
       game = new DiceGame(60, 32, level);
       view.initializeViewField(game);
       view.testButton.style.display = "";
       
       
       
       onTurn();

  }
  
  
  onTurn() {
    while(game.players.length > 2) {
     bool endTurn = false;
    if (game.currentPlayer.id == "human") {
      while (!endTurn) {
        while (game.selectedTerritory == null) {
      }   
      }
      
    } else {
      while (!endTurn) {
        if (game.currentPlayer.id == "whitefield") {
          endTurn = true;
        } else {
          List<Territory> attack = game.currentPlayer.turn();
          if (attack == null) {
          endTurn = true;
          } else {
            
            attack[0].attackTerritory(attack[1]);
          }          
        }        
      }
    }
      
    }
    
    //start new games
    
    
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