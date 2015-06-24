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
    /*
    view.arena.onMouseEnter.listen((ev) {
              querySelectorAll('.hex').onClick.listen((_) {
                if (lastselected !=_.currentTarget.id.toString() && game.currentPlayer.id == "human") {
                  lastselected = _.currentTarget.id.toString();
               
                  //GET THE FITTING TERRITORY
                  Territory foundTerritory = game.arena.territories[game.arena[lastselected].parentTer];
                  if (game.firstTerritory == null && foundTerritory.owner == "human") {
                    game.firstTerritory = foundTerritory;
                  }
                  if (game.firstTerritory != null && foundTerritory.owner != "human" && game.firstTerritory.neighbour) {
                    game.secondTerritory = foundTerritory;
                  }
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
            });*/
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
          String parent ="";
        
          view.arena.onMouseEnter.listen((ev) {
            querySelectorAll('.hex').onClick.listen((_) {
              if (parent != _.currentTarget.getAttribute("parent")) {
                parent != _.currentTarget.getAttribute("parent");
                //INSERT STUFF YOU DO WITH SELECTED 1st and 2nd HERE
                }
              });
            querySelectorAll('.corner-1').onClick.listen((_) {
             if (parent != _.currentTarget.parentNode.getAttribute("parent")) {
               parent = _.currentTarget.parentNode.getAttribute("parent");
              //SAME TO HERE
             } 
           });
           querySelectorAll('.corner-2').onClick.listen((_) {
             if (parent != _.currentTarget.parentNode.getAttribute("parent")) {
               parent = _.currentTarget.parentNode.getAttribute("parent");
               //SAME TO HERE:
             }
           });
             
          });
          /*
          //TO BE COPYPASTED INTO ALL THREE CASES:
          String owner = _.currentTarget.getAttribute("owner");
          parent = _.currentTarget.getAttribute("parent");
          if (game.firstTerritory == null) {
            game.firstTerritory = game.arena.territories[parent];
          }
          if (game.firstTerritory != null && parent == game.firstTerritory.id) {
            game.firstTerritory  = null;
          }
          if (game.firstTerritory != null && game.secondTerritory == null && game.firstTerritory.neighbours.keys.contains(parent) && game.firstTerritory.owner != owner) {
            game.secondTerritory = game.arena.territories[parent];
          }
         //game.arena.territories[game.firstTerritory.id].contains("parents");
          if (game.firstTerritory != null && game.secondTerritory != null) { //IF BOTH AREAS ARE SET
            if (game.firstTerritory.id == game.secondTerritory.id) {
                      game.firstTerritory = null;
                      game.secondTerritory = null;
                      lastselected = "";
                    }
                    if (game.firstTerritory.owner == game.secondTerritory.owner) {
                      //DO NOTHIN
                    }
                    //IF NOT NEIGHBOROURTERRITORIES DO NOTHIN
                    
                    
                    //ELSE
                    if ((game.firstTerritory.owner != game.secondTerritory.owner)) {
                      game.firstTerritory.attackTerritory(game.secondTerritory);
                             if (!(game.players.length > 2)) {
                               endTurn = true;
                               break;
                             }
                    }
           
          }*/
        
       
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
            if (!(game.players.length > 2)) {
              endTurn = true;
              break;
            }
          }          
        }        
      }
    }
      
    }
    
    //start new games
    game = null;
    startGame((int.parse(level.attributes[0].value))+1);
    
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