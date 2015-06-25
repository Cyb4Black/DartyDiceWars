part of DartyDiceWars;

class DiceController {
  final view = new DiceView();
  var game;
  XmlNode level;

  DiceController() {
    String lastselected = "";
    view.startButton.onClick.listen((_) {
      startGame(1);
    });

    view.testButton.onClick.listen((_) {
      view.updateFieldWithTerritories(game);
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
    while (game.players.length > 2) {
      bool endTurn = false;
      if (game.currentPlayer.id == "human") {
        while (!endTurn) {
          String parent = "";

          view.arena.onMouseEnter.listen((ev) {
            querySelectorAll('.hex').onClick.listen((_) {
              if (parent != _.currentTarget.getAttribute("parent")) {
                parent != _.currentTarget.getAttribute("parent");
                String owner = _.currentTarget.getAttribute("owner");
                //INSERT STUFF YOU DO WITH SELECTED 1st and 2nd HERE

                //TO BE COPYPASTED INTO ALL THREE CASES

                if (game.firstTerritory == null &&
                    owner != "human" &&
                    game.arena.territories[parent].dies > 1) {
                  //selectTerritory as first one
                  game.firstTerritory = game.arena.territories[parent];
                  view.markTerritory(parent, true);
                } else if (game.firstTerritory != null &&
                    parent == game.firstTerritory.id) {
                  //if there is a territory selected and the new one is the same
                  game.firstTerritory = null;
                  view.markTerritory(parent, false);
                } else if (game.firstTerritory != null &&
                    game.secondTerritory == null &&
                    game.firstTerritory.neighbours.keys.contains(parent) &&
                    owner != "human") {
                  game.secondTerritory = game.arena.territories[parent];
                  view.markTerritory(parent, true);
                }
                if (game.firstTerritory != null &&
                    game.secondTerritory != null) {
                  List<List<int>> attack =
                      game.firstTerritory.attackTerritory(game.secondTerritory);
                  view.showAttack(attack);
                  view.markTerritory(game.firstTerritory.id, false);
                  view.markTerritory(game.secondTerritory.id, false);
                  List<String> toupdate = new List();
                  toupdate.add(game.arena.territories[
                      game.firstTerritory.id]); //grab the two actual elements out of the arena
                  toupdate
                      .add(game.arena.territories[game.secondTerritory.id.id]);
                  view.updateSelectedTerritories(toupdate);
                  game.firstTerritory = null;
                  game.secondTerritory = null;
                  parent = "";

                  if (!(game.players.length > 2)) {
                    endTurn = true;
                  }
                }
              }
              //COPYPASTE ALL OF THE ABOVE
            });
            querySelectorAll('.corner-1').onClick.listen((_) {
              if (parent != _.currentTarget.parentNode.getAttribute("parent")) {
                parent = _.currentTarget.parentNode.getAttribute("parent");
                String owner = _.currentTarget.parentNode.getAttribute("owner");
                //SAME TO HERE
                //TO BE COPYPASTED INTO ALL THREE CASES

                if (game.firstTerritory == null &&
                    owner != "human" &&
                    game.arena.territories[parent].dies > 1) {
                  //selectTerritory as first one
                  game.firstTerritory = game.arena.territories[parent];
                  view.markTerritory(parent, true);
                } else if (game.firstTerritory != null &&
                    parent == game.firstTerritory.id) {
                  //if there is a territory selected and the new one is the same
                  game.firstTerritory = null;
                  view.markTerritory(parent, false);
                } else if (game.firstTerritory != null &&
                    game.secondTerritory == null &&
                    game.firstTerritory.neighbours.keys.contains(parent) &&
                    owner != "human") {
                  game.secondTerritory = game.arena.territories[parent];
                  view.markTerritory(parent, true);
                }
                if (game.firstTerritory != null &&
                    game.secondTerritory != null) {
                  List<List<int>> attack =
                      game.firstTerritory.attackTerritory(game.secondTerritory);
                  view.showAttack(attack);
                  view.markTerritory(game.firstTerritory.id, false);
                  view.markTerritory(game.secondTerritory.id, false);
                  List<String> toupdate = new List();
                  toupdate.add(game.arena.territories[
                      game.firstTerritory.id]); //grab the two actual elements out of the arena
                  toupdate
                      .add(game.arena.territories[game.secondTerritory.id.id]);
                  view.updateSelectedTerritories(toupdate);
                  game.firstTerritory = null;
                  game.secondTerritory = null;
                  parent = "";

                  if (!(game.players.length > 2)) {
                    endTurn = true;
                  }
                }
              }
              //COPYPASTE ALL OF THE ABOVE

            });
            querySelectorAll('.corner-2').onClick.listen((_) {
              if (parent != _.currentTarget.parentNode.getAttribute("parent")) {
                parent = _.currentTarget.parentNode.getAttribute("parent");
                String owner = _.currentTarget.parentNode.getAttribute("owner");
                //SAME TO HERE:
                //TO BE COPYPASTED INTO ALL THREE CASES

                if (game.firstTerritory == null &&
                    owner != "human" &&
                    game.arena.territories[parent].dies > 1) {
                  //selectTerritory as first one
                  game.firstTerritory = game.arena.territories[parent];
                  view.markTerritory(parent, true);
                } else if (game.firstTerritory != null &&
                    parent == game.firstTerritory.id) {
                  //if there is a territory selected and the new one is the same
                  game.firstTerritory = null;
                  view.markTerritory(parent, false);
                } else if (game.firstTerritory != null &&
                    game.secondTerritory == null &&
                    game.firstTerritory.neighbours.keys.contains(parent) &&
                    owner != "human") {
                  game.secondTerritory = game.arena.territories[parent];
                  view.markTerritory(parent, true);
                }
                if (game.firstTerritory != null &&
                    game.secondTerritory != null) {
                  List<List<int>> attack =
                      game.firstTerritory.attackTerritory(game.secondTerritory);
                  view.showAttack(attack);
                  view.markTerritory(game.firstTerritory.id, false);
                  view.markTerritory(game.secondTerritory.id, false);

                  List<String> toupdate = new List();
                  toupdate.add(game.arena.territories[
                      game.firstTerritory.id]); //grab the two actual elements out of the arena
                  toupdate
                      .add(game.arena.territories[game.secondTerritory.id.id]);
                  view.updateSelectedTerritories(toupdate);

                  game.firstTerritory = null;
                  game.secondTerritory = null;
                  parent = "";

                  if (!(game.players.length > 2)) {
                    endTurn = true;
                  }
                }
              }
              //COPYPASTE ALL OF THE ABOVE
            });
          });

          view.endTurn.onClick.listen((_) {
            endTurn = true;
            game.firstTerritory = null;
            game.secondTerritory = null;
            parent = "";
          });
        }
      } else {
        while (!endTurn) {
          if (game.currentPlayer.id == "whitefield") {
            endTurn = true;
          } else {
            List<Territory> actors = game.currentPlayer.turn();
            if (actors.length == 0) {
              endTurn = true;
            } else {
              view.markTerritory(actors[0], true);
              view.markTerritory(actors[1], true);

              List<List<int>> attack = actors[0].attackTerritory(actors[1]);
              view.showAttack(attack);

              view.markTerritory(actors[0], false);
              view.markTerritory(actors[1], false);

              List<String> toupdate = new List();
              toupdate.add(game.arena.territories[actors[
                  0].id]); //grab the two actual elements out of the arena
              toupdate.add(game.arena.territories[actors[1].id]);
              view.updateSelectedTerritories(toupdate);

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
    startGame((int.parse(level.attributes[0].value)) + 1);
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
      print("NIGGA" + e.toString());
    }
    return ret;
  }
}
