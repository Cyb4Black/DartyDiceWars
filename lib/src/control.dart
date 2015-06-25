part of DartyDiceWars;

class DiceController {
  final view = new DiceView();
  var game;
  XmlNode level;
  String parent = "";
  DiceController() {
    String lastselected = "";
    view.startButton.onClick.listen((_) {
      startGame(1);
    });
    view.arena.onMouseEnter.listen((ev) {
      querySelectorAll('.hex').onClick.listen((_) {
        if (game.currentPlayer.id == "#human" && parent != _.currentTarget.getAttribute("parent")) {
          parent != _.currentTarget.getAttribute("parent");
          String owner = _.currentTarget.getAttribute("owner");
          //INSERT STUFF YOU DO WITH SELECTED 1st and 2nd HERE

          //TO BE COPYPASTED INTO ALL THREE CASES

          if (game.firstTerritory == null &&
              owner != "#human" &&
              game._arena.territories[parent].dies > 1) {
            //selectTerritory as first one
            game.firstTerritory = game._arena.territories[parent];
            view.markTerritory(parent, true);
          } else if (game.firstTerritory != null &&
              parent == game.firstTerritory.id) {
            //if there is a territory selected and the new one is the same
            game.firstTerritory = null;
            view.markTerritory(parent, false);
          } else if (game.firstTerritory != null &&
              game.secondTerritory == null &&
              game.firstTerritory.neighbours.keys.contains(parent) &&
              owner != "#human") {
            game.secondTerritory = game._arena.territories[parent];
            view.markTerritory(parent, true);
          }
          if (game.firstTerritory != null && game.secondTerritory != null) {
            List<List<int>> attack =
                game.firstTerritory.attackTerritory(game.secondTerritory);
            view.showAttack(attack);
            view.markTerritory(game.firstTerritory.id, false);
            view.markTerritory(game.secondTerritory.id, false);
            List<String> toupdate = new List();
            toupdate.add(game._arena.territories[
                game.firstTerritory.id]); //grab the two actual elements out of the arena
            toupdate.add(game._arena.territories[game.secondTerritory.id.id]);
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
      querySelectorAll('.corner-1').onClick.listen((_) {
        if (game.currentPlayer.id == "#human" && parent != _.currentTarget.parentNode.getAttribute("parent")) {
          parent = _.currentTarget.parentNode.getAttribute("parent");
          String owner = _.currentTarget.parentNode.getAttribute("owner");
          //SAME TO HERE
          //TO BE COPYPASTED INTO ALL THREE CASES

          if (game.firstTerritory == null &&
              owner != "#human" &&
              game._arena.territories[parent].dies > 1) {
            //selectTerritory as first one
            game.firstTerritory = game._arena.territories[parent];
            view.markTerritory(parent, true);
          } else if (game.firstTerritory != null &&
              parent == game.firstTerritory.id) {
            //if there is a territory selected and the new one is the same
            game.firstTerritory = null;
            view.markTerritory(parent, false);
          } else if (game.firstTerritory != null &&
              game.secondTerritory == null &&
              game.firstTerritory.neighbours.keys.contains(parent) &&
              owner != "#human") {
            game.secondTerritory = game._arena.territories[parent];
            view.markTerritory(parent, true);
          }
          if (game.firstTerritory != null && game.secondTerritory != null) {
            List<List<int>> attack =
                game.firstTerritory.attackTerritory(game.secondTerritory);
            view.showAttack(attack);
            view.markTerritory(game.firstTerritory.id, false);
            view.markTerritory(game.secondTerritory.id, false);
            List<String> toupdate = new List();
            toupdate.add(game._arena.territories[
                game.firstTerritory.id]); //grab the two actual elements out of the _arena
            toupdate.add(game._arena.territories[game.secondTerritory.id.id]);
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
      querySelectorAll('.corner-2').onClick.listen((_) {
        if (game.currentPlayer.id == "#human" && parent != _.currentTarget.parentNode.getAttribute("parent")) {
          parent = _.currentTarget.parentNode.getAttribute("parent");
          String owner = _.currentTarget.parentNode.getAttribute("owner");
          //SAME TO HERE:
          //TO BE COPYPASTED INTO ALL THREE CASES

          if (game.firstTerritory == null &&
              owner != "#human" &&
              game._arena.territories[parent].dies > 1) {
            //selectTerritory as first one
            game.firstTerritory = game._arena.territories[parent];
            view.markTerritory(parent, true);
          } else if (game.firstTerritory != null &&
              parent == game.firstTerritory.id) {
            //if there is a territory selected and the new one is the same
            game.firstTerritory = null;
            view.markTerritory(parent, false);
          } else if (game.firstTerritory != null &&
              game.secondTerritory == null &&
              game.firstTerritory.neighbours.keys.contains(parent) &&
              owner != "#human") {
            game.secondTerritory = game._arena.territories[parent];
            view.markTerritory(parent, true);
          }
          if (game.firstTerritory != null && game.secondTerritory != null) {
            List<List<int>> attack =
                game.firstTerritory.attackTerritory(game.secondTerritory);
            view.showAttack(attack);
            view.markTerritory(game.firstTerritory.id, false);
            view.markTerritory(game.secondTerritory.id, false);

            List<String> toupdate = new List();
            toupdate.add(game._arena.territories[
                game.firstTerritory.id]); //grab the two actual elements out of the arena
            toupdate.add(game._arena.territories[game.secondTerritory.id.id]);
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
      game.firstTerritory = null;
      game.secondTerritory = null;
      parent = "";
      this.nextTurn();
    });

  }

  startGame(int levelnr) async {
    await this.loadLevelData(levelnr);
    game = new DiceGame(60, 32, level);
    view.initializeViewField(game);

    
    if (game.currentPlayer.id != "#human") {
      this.onTurn();
    }
  }

  //gets the next player and 
  nextTurn() {
    //resupply n stuff, ALSO ASSIGN NEW CURRENT PLAYER
    if (game.currentplayer != "#human") {
      onTurn();
    }
  }
  
  onTurn() {
    bool turn = true;
    while (turn) {
      if (game.currentPlayer.id == "#whitefield") {
        turn = false;
      } else if (game.currentPlayer.id != "#human") {
        List<Territory> actors = game.currentPlayer.turn();
        if (actors.length == 0) {
          turn = false;
        } else {
          view.markTerritory(actors[0], true);
          view.markTerritory(actors[1], true);

          List<List<int>> attack = actors[0].attackTerritory(actors[1]);
          view.showAttack(attack);

          view.markTerritory(actors[0], false);
          view.markTerritory(actors[1], false);

          List<String> toupdate = new List();
          toupdate.add(game._arena.territories[actors[
              0].id]); //grab the two actual elements out of the arena
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

  Future<XmlNode> loadLevelData(int levelnr) async {
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
      print(
          "Damn biatch, how did you even get here?! oh also: " + e.toString());
    }
    return ret;
  }
}
