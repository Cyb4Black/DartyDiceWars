part of DartyDiceWars;

/* Controllerpart of the MVC structure of DiceWars
 * 
 * Here, the Playerinput and the general flow of the game are handled. Also,
 * the given file containing levelinformation is loaded via the DiceController.
 * 
 * This class creates all subsequent classes needed to run the Game
 */
class DiceController {
  /*
   * Controller variables:
   * final view - View module of the game
   * DiceGame game - Model module of the game
   * XmlNode level - the imported levelfile
   * int maxlevels - maximum number of levels in the current session
   * String last - ID of the last clicked tile. Only way to prevent mutiple clicks
   *               on a tile to be registered.
   */
  final view = new DiceView();
  DiceGame game;
  XmlNode level;
  int maxlevels;
  String last = "";
  
  /*
   * Constructor for the DiceController. 
   * Here, all the Listeners for Playerinput are handled. Detailed explanations 
   * for the exact usage are above each Listener.
   */
  DiceController() {
    /*
     * Starts a new game with the first level of the levelsfile. The displayed
     * Button also gets disabled to prevent the creation of multiple games at 
     * the same time.
     */
    view.startButton.onClick.listen((_) {
      if (level == null) {
        view.startButton.style.display = "none";
        startGame(1);
      }
    });
    
    /*
     * Listener for the Hoverfunction of the territories. Only one territory can
     * be hovered at one time and a territory cannot be selected and hovered at 
     * once.
     */
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
    
    /*
     * Additional Listener to turn of hovereffect if the mouse moves out of the 
     * arena.
     */
    view.arena.onMouseLeave.listen((ev) {
      view.showHover("");
    });

    /*
     * Listener to handle all clicking actions of the player inside of the arena.
     * To prevent multiple events from triggering with one click, it is impossible
     * to click the same hexagon twice in a row.
     * First click on a valid territory (at least 2 dice, owned by the player) selects
     * the first territory.
     * Second click on a valid territoy (enemy-owned territory adjacent to the first one)
     * Clicking twice on the same territory deselects it.
     * If two territories are selected, an attack gets computed and shown on the view.
     * 
     */
    view.arena.onMouseEnter.listen((ev) {                 
      querySelectorAll('.hex').onClick.listen((_) {     
        if (last != _.currentTarget.id) {                   
          if (!_.currentTarget.classes.contains('.corner-1') && !_.currentTarget.classes.contains('.corner-2')) {
            if (game != null && game.currentPlayer.id == "human") { 
              String parent = _.currentTarget.getAttribute("parent");
              String owner = _.currentTarget.getAttribute("owner");
              
              last = _.currentTarget.id;
             
              print(game._arena.territories[parent].dice);
              if (game.firstTerritory == null &&
                  owner == "human" &&
                  game._arena.territories[parent].dice > 1) {
                game.firstTerritory = game._arena.territories[parent];
                view.markTerritory(parent);
              } else if (game.firstTerritory != null &&
                  parent == game.firstTerritory.id) {
                game.firstTerritory = null;
                view.markTerritory(parent);
              } else if (game.firstTerritory != null &&
                  game.secondTerritory == null &&
                  game.firstTerritory.neighbours.keys.contains(parent) &&
                  owner != "human" &&
                  owner != "whitefield") {
                game.secondTerritory = game._arena.territories[parent];
                view.markTerritory(parent);
              }
              if (game.firstTerritory != null && game.secondTerritory != null) {
                String attacker = game.firstTerritory.ownerRef.id;
                String defender = game.secondTerritory.ownerRef.id;
                Player attackedPlayer = game.secondTerritory.ownerRef;
                bool attackingEmperor = game.secondTerritory.emperorDice;
                List<List<int>> attack =
                    game.firstTerritory.attackTerritory(game.secondTerritory);
                view.displayAttack(attack, attacker, defender);
//          view.displayAttack(attack, actors[0].ownerRef.id, defender));
                if (attacker == game.secondTerritory.ownerRef.id && attackingEmperor) {
                  new Timer(new Duration(milliseconds: 1000 ), () => 
                  view.showMessage("The Emperor Dice got stolen!"));
                  new Timer(new Duration(milliseconds: 3000), () => view.showMessage("Now playing: " + game.currentPlayer.id));
                }
                String center1 = "ID" +
                    game._arena.territories[game.firstTerritory.id].x
                        .toString() +
                    "_" +
                    game._arena.territories[game.firstTerritory.id].y
                        .toString();
                String center2 = "ID" +
                    game._arena.territories[game.secondTerritory.id].x
                        .toString() +
                    "_" +
                    game._arena.territories[game.secondTerritory.id].y
                        .toString();
                List<String> tiles1 =
                    game._arena.territories[game.firstTerritory.id].tiles;
                List<String> tiles2 =
                    game._arena.territories[game.secondTerritory.id].tiles;
                int dice1 =
                    game._arena.territories[game.firstTerritory.id].dice;
                int dice2 =
                    game._arena.territories[game.secondTerritory.id].dice;
                int ownLongestRoute = 1;
                String newOwner = game._arena.territories[game.secondTerritory.id].ownerRef.id;
                bool emperorFlag1 = game.firstTerritory.emperorDice;
                bool emperorFlag2 = game.secondTerritory.emperorDice;
                int enemyLongestRoute = 1;
                int temp;
                for (int i = 0; i < game.currentPlayer.territories.length; i++) {
                  List<Territory> list = new List<Territory>();
                  temp = game.currentPlayer.longestRoute(
                      game.currentPlayer.territories[i], list, game.currentPlayer.id);
                  if (temp > ownLongestRoute) ownLongestRoute = temp;
                } 
                for (int i = 0; i < attackedPlayer.territories.length; i++) {
                  List<Territory> list = new List<Territory>();
                  temp = attackedPlayer.longestRoute(
                      attackedPlayer.territories[i], list, attackedPlayer.id);
                  if (temp > enemyLongestRoute) enemyLongestRoute = temp;
                }
  
                new Timer(new Duration(milliseconds: 2000), () => view
                    .updateAfterAttack(center1, center2, tiles1, tiles2, dice1,
                        dice2, attacker, defender, ownLongestRoute, enemyLongestRoute, newOwner, emperorFlag1, emperorFlag2));

                if (attackedPlayer.territories.length == 0) {
                  print(attackedPlayer.id + " WAS DEFEATED.");
                  view.showMessage(attackedPlayer.id + " was defeated!");
                  game.players.remove(attackedPlayer);
                  view.removeDefeatedPlayer(attackedPlayer);
                }

                game.firstTerritory = null;
                game.secondTerritory = null;
                parent = "";

                if (!(game.players.length > 2)) {
                  this.nextTurn();
                }
              }
            }
          }
        }
      });
    });

    /*
     * Finishes the current playerturn on click
     */
    view.endTurn.onClick.listen((_) {
      if (game != null && game.currentPlayer.id == "human") {
        if (game.firstTerritory != null) {
          view.markTerritory(game.firstTerritory.id);
        }
        game.firstTerritory = null;
        game.secondTerritory = null;
        last = "";
        
        this.nextTurn();
      }
    });
  }

  /*
   * Starts a new game based on the given levelnumber.
   * Also initiates the model and the arena for the new level.
   * Async to handle the import of the levelfiler
   * 
   * int levelnr - level that should be loaded
   */
  startGame(int levelnr) async {
    await this.loadLevelData(levelnr);
    view.showAnim();
    game = new DiceGame(60, 32, level);
    view.hideAnim();
    List<int> startRoutes = new List();
    for (int j = 1; j < game.players.length; j++) {
      int temp;
                startRoutes.add(1);
                for (int i = 0; i < game.players[j].territories.length; i++) {
                  List<Territory> list = new List<Territory>();
                  temp = game.players[j].longestRoute(
                      game.players[j].territories[i], list, game.players[j].id);
                  if (temp > startRoutes[j-1]) startRoutes[j-1] = temp;
                }
    }
    view.initializeViewField(game, maxlevels, startRoutes);
    view.updateFieldWithTerritories(game);
    print("First Player: " + game.currentPlayer.id.toString());
    view.showMessage("First Player: " + game.currentPlayer.id.toString());
    if (game.currentPlayer.id != "human") {
      this.onTurn();
    }
  }

  /*
   * Selects the next player and ends the game if there is only one player left.
   * Also decides what to do when the game is over.
   */
  nextTurn() {
    if (!(game.players.length > 2)) {
      if (game.currentPlayer.id == "human") {
        view.showMessage("You won the game!");
        int nextLevel = (int.parse(game.level.attributes[0].value)) + 1;
        view.showMessage("You won the game!");
        if (nextLevel == maxlevels ) {
          game = null;
          level = null;
          new Timer(new Duration(milliseconds: 5000), () => view.gameOver(false));
          return;
        } else {

                        new Timer(new Duration(milliseconds: 5000), () => startGame(nextLevel));
                        game = null;
                        return;
        }      
      } else {
        view.showMessage("You lost the game!");
        game = null;
        level = null;
        new Timer(new Duration(milliseconds: 5000), () => view.gameOver(true));
        return;
      }
      
    }
    Player oldPlayer = game.currentPlayer;
    view.undisplayPlayer(oldPlayer.id);
    List<Territory> toUpdate = game.currentPlayer.territories;
    game.nextPlayer();
    view.updateSelectedTerritories(toUpdate);
    //resupply n stuff, ALSO ASSIGN NEW CURRENT PLAYER
    view.displayPlayer(game.currentPlayer.id, oldPlayer);
    print("Next Player: " + game.currentPlayer.id);
    view.showMessage("Now playing: " + game.currentPlayer.id);
    if (game.currentPlayer.id != "human") {
      this.onTurn();
    }
  }

  /*
   * Handles the AI-turn. 
   */
  onTurn() {
    int waitfor = 0;
    bool turn = true;
    while (turn) {
      if (game.currentPlayer.id == "whitefield") {
        turn = false;
      } else if (game.currentPlayer.id != "human") {
        List<Territory> actors = game.currentPlayer.turn();
        if (actors.length == 0) {
          turn = false;
        } else {
          String defender = actors[1].ownerRef.id;
          Player attackedPlayer = actors[1].ownerRef;
          bool attackingEmperor = actors[1].emperorDice;
          List<List<int>> attack = actors[0].attackTerritory(actors[1]);
          new Timer(new Duration(milliseconds: 300 + (waitfor * 2000)),
              () => view.markAIAttack(actors[0].id));
          new Timer(new Duration(milliseconds: 500 + (waitfor * 2000)),
              () => view.markAIAttack(actors[1].id));
          new Timer(new Duration(milliseconds: 1000 + (waitfor * 2000)), () =>
              view.displayAttack(attack, actors[0].ownerRef.id, defender));
          if (actors[0].ownerRef.id == actors[1].ownerRef.id && attackingEmperor) {
            new Timer(new Duration(milliseconds: 1000 + (waitfor * 2000)), () => 
            view.showMessage("The Emperor Dice got stolen!"));
            new Timer(new Duration(milliseconds: 1000), () => view.showMessage("Now playing: " + game.currentPlayer.id));
          }
          
          
          
          //save all the content that is needed for the viewupdate so that it can get updated after the given delay
          String center1 = "ID" +
              game._arena.territories[actors[0].id].x.toString() +
              "_" +
              game._arena.territories[actors[0].id].y.toString();
          String center2 = "ID" +
              game._arena.territories[actors[1].id].x.toString() +
              "_" +
              game._arena.territories[actors[1].id].y.toString();
          List<String> tiles1 = game._arena.territories[actors[0].id].tiles;
          List<String> tiles2 = game._arena.territories[actors[1].id].tiles;
          int dice1 = game._arena.territories[actors[0].id].dice;
          int dice2 = game._arena.territories[actors[1].id].dice;
          String owner1 = game.currentPlayer.id;
          String owner2 = attackedPlayer.id;
          String newOwner = game._arena.territories[actors[1].id].ownerRef.id;
          bool emperorFlag1 = actors[0].emperorDice;
          bool emperorFlag2 = actors[1].emperorDice;
          int ownLongestRoute = 1;
          int enemyLongestRoute = 1;
          int temp;
          
          for (int i = 0; i < game.currentPlayer.territories.length; i++) {
            List<Territory> list = new List<Territory>();
            temp = game.currentPlayer.longestRoute(
                game.currentPlayer.territories[i], list, game.currentPlayer.id);
            if (temp > ownLongestRoute) ownLongestRoute = temp;
          }
     
          for (int i = 0; i < attackedPlayer.territories.length; i++) {
            List<Territory> list = new List<Territory>();
            temp = attackedPlayer.longestRoute(
                attackedPlayer.territories[i], list, attackedPlayer.id);
            if (temp > enemyLongestRoute) enemyLongestRoute = temp;
          }

          new Timer(new Duration(milliseconds: 1000 + (waitfor * 2000)),
              () => view.updateAfterAttack(center1, center2, tiles1, tiles2,
                  dice1, dice2, owner1, owner2, ownLongestRoute, enemyLongestRoute, newOwner, emperorFlag1, emperorFlag2));

          waitfor++;

          if (attackedPlayer.territories.length == 0) {
            print(attackedPlayer.id + " WAS DEFEATED. DAMN SON.");
            view.showMessage(attackedPlayer.id + " WAS DEFEATED. DAMN SON.");
            game.players.remove(attackedPlayer);

            view.removeDefeatedPlayer(attackedPlayer);
          }

          if (!(game.players.length > 2)) {
            turn = false;
          }
        }
      }
      //new Timer(new Duration(milliseconds: 100), () => view.clearFooter(game.currentPlayer.id.toString()));
    }
    if (game.currentPlayer.id != "whitefield") {
      new Timer(new Duration(milliseconds: 1000 + (waitfor * 2000)),
          () => this.nextTurn());
    } else this.nextTurn();
  }

 loadLevelData(int levelnr) async {
    try {
      dynamic file = await HttpRequest.getString('levels.xml');
      var levels = parse(file);
      print(file);
      maxlevels = levels.firstChild.children.length;
      
      for (XmlNode x in levels.firstChild.children) {
        if (x.attributes[0].value == levelnr.toString()) {
          level = x;
        }
      }
    } catch (e) {
      print("How did you even get here?! oh also: " + e.toString());
    }
    
    
  }
  
}
