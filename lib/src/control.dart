part of DartyDiceWars;

class DiceController {
  final view = new DiceView();
  DiceGame game;
  XmlNode level;
  String parent = "";
  DiceController() {
    view.startButton.onClick.listen((_) {
      if (level == null) {
        
       view.startButton.style.display = "none";
       startGame(1);
      }
    });
    
    view.arena.onMouseLeave.listen((ev) {
      view.showHover("");
    }); 
    
    view.arena.onMouseEnter.listen((ev) {
      if (game.currentPlayer.id == "human") {
        querySelectorAll('.hex').onMouseOver.listen((_) {
              if (_.currentTarget.classes.contains("selected")) {
                view.showHover("");
              } else {
                view.showHover(_.currentTarget.getAttribute("parent"));
              }
              
            });
      }
    });
    
    view.arena.onMouseEnter.listen((ev) {
      
      querySelectorAll('.hex').onClick.listen((_) {
        if (game != null && game.currentPlayer.id == "human" ) {//&&
          parent = _.currentTarget.getAttribute("parent");
          String owner = _.currentTarget.getAttribute("owner");
          //INSERT STUFF YOU DO WITH SELECTED 1st and 2nd HERE

          //TO BE COPYPASTED INTO ALL THREE CASES
        print(game._arena.territories[parent].dies);
          if (game.firstTerritory == null &&
              owner == "human" &&
              game._arena.territories[parent].dies > 1) {
              
            //selectTerritory as first one
            game.firstTerritory = game._arena.territories[parent];
            view.markTerritory(parent);
          } else if (game.firstTerritory != null &&
              parent == game.firstTerritory.id) {
            //if there is a territory selected and the new one is the same
            game.firstTerritory = null;
            view.markTerritory(parent);
          } else if (game.firstTerritory != null &&
              game.secondTerritory == null &&
              game.firstTerritory.neighbours.keys.contains(parent) &&
              owner != "human" && owner != "whitefield") {
            game.secondTerritory = game._arena.territories[parent];
            view.markTerritory(parent);
          }
          if (game.firstTerritory != null && game.secondTerritory != null) {
            List<List<int>> attack =
                game.firstTerritory.attackTerritory(game.secondTerritory);
            view.showAttack(attack);
            List<Territory> toupdate = new List();
            toupdate.add(game._arena.territories[
                game.firstTerritory.id]); //grab the two actual elements out of the arena
            toupdate.add(game._arena.territories[game.secondTerritory.id]);
            view.updateSelectedTerritories(toupdate);
            game.firstTerritory = null;
            game.secondTerritory = null;
            parent = "";

            if (!(game.players.length > 2)) {
              this.nextTurn();
            }
          }
        }
        //COPYPASTE ALL OF THE ABOVE
      });
    
    });

    view.endTurn.onClick.listen((_) {
      if (game != null) {
        if (game.firstTerritory != null) {
          view.markTerritory(game.firstTerritory.id);
        }
        game.firstTerritory = null;
             game.secondTerritory = null;
             parent = "";
             this.nextTurn();
      }
     
    });
  }

  startGame(int levelnr) async{
    await this.loadLevelData(levelnr);
    game = new DiceGame(60, 32, level);
    
    view.initializeViewField(game);
    view.updateFieldWithTerritories(game);
    print("First Player: " + game.currentPlayer.id.toString());
    if (game.currentPlayer.id != "human") {
      this.onTurn();
    }
  }

  //gets the next player and
  nextTurn() {
    if (!(game.players.length > 2)) {
      int nextLevel = (int.parse(game.level.attributes[0].value))+1;
      game = null;
      startGame(nextLevel);
      return;
    }
    game.nextPlayer();
    //resupply n stuff, ALSO ASSIGN NEW CURRENT PLAYER
    print("Next Player: "+game.currentPlayer.id.toString());
    if (game.currentPlayer.id != "human") {
      this.onTurn();
    }
  }

  onTurn() {
    bool turn = true;
    while (turn) {
      if (game.currentPlayer.id == "whitefield") {
        turn = false;
      } else if (game.currentPlayer.id != "human") {
        List<Territory> actors = game.currentPlayer.turn();
        if (actors.length == 0) {
          turn = false;
        } else {
          List<List<int>> attack = actors[0].attackTerritory(actors[1]);
          view.markAIAttack(actors[0],actors[1],attack);

          List<Territory> toupdate = new List();
          toupdate.add(game._arena.territories[actors[0].id]); //grab the two actual elements out of the arena
          toupdate.add(game._arena.territories[actors[1].id]);
          view.updateSelectedTerritories(toupdate);

          if (!(game.players.length > 2)) {
            turn = false;
            break;
          }
        }
      }
    }
    this.nextTurn();
  }

  loadLevelData(int levelnr) async {
    Future<XmlNode> ret = null;
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
      print(
          "How did you even get here?! oh also: " + e.toString());
    }
  }
}
