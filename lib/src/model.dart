part of DartyDiceWars;

/*
 * Class for the Model of the MVC structure of the game.
 * Manages all subsequent Model-elements and the internal flow of 
 * the game.
 * 
 * XmlNode level - currently played level, as loaded from the levelfile
 * int playercount - current number of players, including the whitefield player
 * Territory firstTerritory - First Playerselected Territory
 * Territory secondTerritory - Second Playerselected Territory
 * Arena _arena - Complete Arena with all Territories and Tiles
 * List<Player> players - List of all players still actively in the game.
 */
class DiceGame {
  XmlNode level;
  int playercount;
  Player currentPlayer;
  Territory firstTerritory;
  Territory secondTerritory;
  Arena _arena;
  List<Player> players;

  /*
   * Constructor for the DiceGame
   * Fills the playerlist and creates the arena. Also selects the player who
   * should play first.
   * 
   * int xSize - intended x Size of the arena
   * int ySize - intended y Size of the arena
   * XmlNode level - level to be played
   */
  DiceGame(int xSize, int ySize, this.level) {
    //-----Add Players (and whitefielddummy) to playerlist-----
    players = new List<Player>();
    players.add(new Whitefield('whitefield'));
    players.add(new Human('human', int.parse(level.children[7].text)));
    int aggressiveAIs = int.parse(level.children[3].text);
    int defensiveAIs = int.parse(level.children[4].text);
    int smartAIs = int.parse(level.children[5].text);
    //add AIs based on settings in levels.xml
    for (int i = 1; i < int.parse(level.children[2].text); i++) {
      if (aggressiveAIs > 0) {
        players.add(new Ai_agg('cpu' + i.toString()));
        aggressiveAIs--;
      } else if (defensiveAIs > 0) {
        players.add(new Ai_deff('cpu' + i.toString()));
        defensiveAIs--;
      } else if (smartAIs > 0) {
        players.add(new Ai_smart('cpu' + i.toString()));
        smartAIs--;
      }
    }
    playercount = players.length - 1;
    //--------------------Build Arena--------------------------
    this._arena = new Arena(xSize, ySize, int.parse(level.children[2].text), int.parse(level.children[6].text), players);
    int order = players.length - int.parse(level.children[1].text);
    if (order == players.length) {
      order = 1;
    }
    currentPlayer = players[order];
    initDice(players, int.parse(level.children[0].text));
  }

  /*
   * Initialises the Startingamount of Dice for all players based on 
   * the starting amount of territories and the handycap
   */
  initDice(List<Player> list, int handycap) {
    int sum = 0;
    for (int i = 1; i < list.length; i++) {
      int temp = list[i].territories.length * 3;
      sum += temp;
    }
    sum = (sum / (list.length - 1)).floor();
    for (int i = 1; i < list.length; i++) {
      if (list[i].id == "human") {
        list[i].giveDice(sum + handycap);
      } else {
        list[i].giveDice(sum);
      }
    }
  }

  /*
   * Resupplies the last player via resupply() and then selects the next player
   */
  nextPlayer() {
    if (currentPlayer.id != "whitefield") {
      currentPlayer.resupply();
    }
    for (int i = 0; i < players.length; i++) {
      if (players[i].id == currentPlayer.id) {
        if (i < players.length - 1) {
          currentPlayer = players[i + 1];
        } else {
          currentPlayer = players[1];
        }
        break;
      }
    }
  }
}

/*
 * Structure to manage the complete arena.
 * 
 * int _xSize - x Size of the arena
 * int _ySize - y Size of the arena
 * Map<String, Tile> field - Map of all the Tile-IDs (same as the <div> elements of the View)
 *                           and the corresponding Tile objects
 * Map<String, Territory> territories - Map of all the Territory-IDs (same as the <div> elements of the View)
 *                                      and the corresponding Territory objects
 * int visited - Checker value to see if all Territories are connected
 * int playerFields - the total amount of playerowned fields (so total territories minus whitefields)
 */
class Arena {
  int _xSize;
  int _ySize;
  Map<String, Tile> field;
  Map<String, Territory> territories;
  int visited;
  int playerFields;

  /*
   * Constructor for the Arena.
   * Creates new playing fields until one where all territories are reachable is generated.
   * 
   * int _xSize - intended x-Size of the arena
   * int _ySize - intended y-Size of the arena
   * int playersCnt - number of different players in the game, excluding the whitefield-player
   * int whitefields - number of intended whitefields to show up in the finished arena
   */
  Arena(this._xSize, this._ySize, int playersCnt, int whitefields, List<Player> players) {
    visited = 0;
    while (visited != playerFields) {
      players.forEach((p) {
        p.territories.clear();
      });
      this.field = null;
      this.territories = null;
      this.field = new Map<String, Tile>.from(initializeArena(_xSize, _ySize));
      this.territories = new Map<String, Territory>();
      territories.addAll(initializeTerritories(playersCnt, whitefields, players));
      List<Territory> temp = new List<Territory>();
      visited = allVisited(players[1].territories[0], temp);
      print("WhiteFields: $whitefields \nPlayerFields: $playerFields \n Visited: $visited \n TmpLänge: ${temp.length}");
    }
  }

  /*
   * Generates a Map with all the Tiles of the arena, giving each an unique ID etc.
   * 
   * int x - intended x-Size of the arena
   * int y - intended y-Size of the arena
   * return Map<String, Tile> - a Map with all the Tiles of the playfield, identified via the String id
   */
  Map<String, Tile> initializeArena(int x, int y) {
    Map<String, Tile> ret = new Map<String, Tile>();
    //---------------------initialize fieldcorners-------------
    Tile c = new Tile(1, 1);
    c.neighbours.add("ID2_1");
    c.neighbours.add("ID1_2");
    ret[c.id] = c;
    c = new Tile(x, 1);
    c.neighbours.add("ID" + (x - 1).toString() + "_1");
    c.neighbours.add("ID" + (x - 1).toString() + "_2");
    c.neighbours.add("ID" + x.toString() + "_2");
    ret[c.id] = c;
    c = new Tile(1, y);
    c.neighbours.add("ID1_" + (y - 1).toString());
    c.neighbours.add("ID2_" + (y - 1).toString());
    c.neighbours.add("ID2_" + (y).toString());
    ret[c.id] = c;
    c = new Tile(x, y);
    c.neighbours.add("ID" + x.toString() + "_" + (y - 1).toString());
    c.neighbours.add("ID" + (x - 1).toString() + "_" + y.toString());
    ret[c.id] = c;
    //---------------------initialize borders------------------
    for (int ix = 2; ix < x; ix++) {
      Tile t = new Tile(ix, 1); //top-border-tile
      Tile b = new Tile(ix, y); //bottom-border-tile
      if (ix % 2 == 0) {
        t.neighbours.add("ID" + (ix - 1).toString() + "_2");
        t.neighbours.add("ID" + (ix + 1).toString() + "_2");
      }
      if (ix % 2 != 0) {
        b.neighbours.add("ID" + (ix - 1).toString() + "_" + (y - 1).toString());
        b.neighbours.add("ID" + (ix + 1).toString() + "_" + (y - 1).toString());
      }
      t.neighbours.add("ID" + (ix - 1).toString() + "_1");
      t.neighbours.add("ID" + ix.toString() + "_2");
      t.neighbours.add("ID" + (ix + 1).toString() + "_1");
      b.neighbours.add("ID" + (ix - 1).toString() + "_" + y.toString());
      b.neighbours.add("ID" + ix.toString() + "_" + (y - 1).toString());
      b.neighbours.add("ID" + (ix + 1).toString() + "_" + y.toString());
      ret[t.id] = t;
      ret[b.id] = b;
    }
    //---------------------------------------------------------
    for (int iy = 2; iy < y; iy++) {
      Tile l = new Tile(1, iy); //left-border-tile
      Tile r = new Tile(x, iy); //right-border-tile
      l.neighbours.add("ID1_" + (iy - 1).toString());
      l.neighbours.add("ID2_" + (iy - 1).toString());
      l.neighbours.add("ID2_" + iy.toString());
      l.neighbours.add("ID1_" + (iy + 1).toString());
      r.neighbours.add("ID" + x.toString() + "_" + (iy - 1).toString());
      r.neighbours.add("ID" + (x - 1).toString() + "_" + iy.toString());
      r.neighbours.add("ID" + (x - 1).toString() + "_" + (iy + 1).toString());
      r.neighbours.add("ID" + x.toString() + "_" + (iy + 1).toString());
      ret[r.id] = r;
      ret[l.id] = l;
    }
    //----------------------initialize inner field-------------
    for (int ix = 2; ix < x; ix++) {
      if (ix % 2 == 0) {
        for (int iy = 2; iy < y; iy++) {
          Tile n = new Tile(ix, iy);
          n.neighbours.add("ID" + ix.toString() + "_" + (iy - 1).toString());
          n.neighbours.add("ID" + (ix - 1).toString() + "_" + iy.toString());
          n.neighbours.add("ID" + (ix + 1).toString() + "_" + iy.toString());
          n.neighbours
              .add("ID" + (ix - 1).toString() + "_" + (iy + 1).toString());
          n.neighbours.add("ID" + ix.toString() + "_" + (iy + 1).toString());
          n.neighbours
              .add("ID" + (ix + 1).toString() + "_" + (iy + 1).toString());
          ret[n.id] = n;
        }
      } else {
        for (int iy = 2; iy < y; iy++) {
          Tile n = new Tile(ix, iy);
          n.neighbours.add("ID" + (ix - 1).toString() + "_" + (iy - 1).toString());
          n.neighbours.add("ID" + ix.toString() + "_" + (iy - 1).toString());
          n.neighbours.add("ID" + (ix + 1).toString() + "_" + (iy - 1).toString());
          n.neighbours.add("ID" + (ix - 1).toString() + "_" + iy.toString());
          n.neighbours.add("ID" + (ix + 1).toString() + "_" + iy.toString());
          n.neighbours.add("ID" + ix.toString() + "_" + (iy + 1).toString());
          ret[n.id] = n;
        }
      }
    }
    return ret;
  }

  /*
   * Generates a Map with all the different Territories the arena should have. 
   * Uses the method assignTerritories before returning the Map
   * 
   * int playersCnt - number of players, excluding the whitefield-player
   * int whiteFields - number of intended Whitefieldterritories
   * List<Player> players - a List with all the currently existing players - including whitefield-player
   * return Map<String, Territory> - finished List of Territories - each assigned to a player etc.
   */
  Map<String, Territory> initializeTerritories(int playersCnt, int whiteFields, List<Player> players) {
    Map<String, Territory> ret;
    ret = new Map<String, Territory>();
    //--------------initialize vars for calculation------------
    int maxFields = 48 - whiteFields;
    playerFields = (maxFields / playersCnt).floor() * playersCnt;
    int yMax = Math.sqrt(48).floor();
    int xMax = yMax + ((48 - (Math.pow(yMax, 2))).floor() / yMax).floor();
    whiteFields = 48 - playerFields;
    //-----------------create/add Territories-------------------
    int n = 1;
    for (int ix = 1; ix <= xMax; ix++) {
      for (int iy = 1; iy <= yMax; iy++) {
        Territory newT = new Territory((60 / xMax * ix).floor(), (32 / yMax * iy).floor(), "terr_$n");
        newT.tiles.add("ID${newT.x}_${newT.y}");
        field[newT.tiles[0]].parentTerr = newT.id;
        field[newT.tiles[0]].neighbours.forEach((str) => newT.neighbourTiles[str] = field[str]);
        ret[newT.id] = newT;
        n++;
      }
    }
    //-----------------grow Territories 1.---------------------
    ret.values.forEach((t) {
      field[t.tiles[0]].neighbours.forEach((ti) {
        if (field[ti].parentTerr == null) {
          t.tiles.add(ti);
          field[ti].neighbours.forEach((f) {
            t.neighbourTiles[f] = field[f];
          });
          t.neighbourTiles.remove(ti);
          field[ti].parentTerr = t.id;
        }
      });
    });

    //-----------------grow Territories 2.---------------------
    var rng = new Math.Random();
    List<Tile> tilesLeft = new List<Tile>();
    tilesLeft.addAll(field.values);
    tilesLeft.removeWhere((tiL) => tiL.parentTerr != null);
    while (tilesLeft.isNotEmpty) {
      ret.values.where((t) => t.neighbourTiles.length > 0).forEach((t) {
        int ranD = rng.nextInt(t.neighbourTiles.length);
        Tile testTile = t.neighbourTiles.values.toList()[ranD];
        if (testTile.parentTerr == null) {
          t.tiles.add(testTile.id);
          testTile.neighbours.forEach((n) {
            t.neighbourTiles[n] = field[n];
          });
          field[testTile.id].parentTerr = t.id;
          t.neighbourTiles.remove(testTile.id);
          tilesLeft.remove(testTile);
        } else {
          t.neighbours[testTile.parentTerr] = ret[testTile.parentTerr];
          t.neighbourTiles.remove(testTile.id);
        }
      });
    }
    assignTerritories(ret, players, whiteFields, playerFields);
    return ret;
  }

  /*
   * Recursive method for counting the Number of reached Territories from one starting point
   * 
   * Territory current - currently iterated Territory
   * List<Territory> visited - List with all visited territories
   * return int - number of previously unvisited territories visited 
   */
  int allVisited(Territory current, List<Territory> visited) {
    int ret = 0;
    if (current.ownerRef.id != "whitefield") {
      ret = 1;
      visited.add(current);
      current.neighbours.values.forEach((f) {
        if (!(visited.contains(f))) {
          ret += allVisited(f, visited);
        }
      });
    }
    return ret;
  }

  /*
   * Method to assign each territory on the newly generated field to a player
   * Map<String, Territory> newTs - Generated territories, without owners
   * List<Player> players - List of all current Players
   * int whiteFields - number of territories that should be assigned to the whitefield-player
   * int playerFields - number of areas each player should start with
   */
  void assignTerritories(Map<String, Territory> newTs, List<Player> players, int whiteFields, int playerFields) {
    var rng = new Math.Random();
    List<Territory> toAssign = new List<Territory>();
    toAssign.addAll(newTs.values);
    for (int i = 0; i < whiteFields;) {
      Territory getT = toAssign[rng.nextInt(toAssign.length)];
      if (getT.ownerRef == null) {
        getT.ownerRef = players[0];
        players[0].territories.add(getT);
        toAssign.remove(getT);
        i++;
      }
    }
    int nextPlay = 1;
    while (toAssign.isNotEmpty) {
      Territory getT = toAssign[rng.nextInt(toAssign.length)];
      if (getT.ownerRef == null) {
        players[nextPlay].territories.add(getT);
        toAssign.remove(getT);
        getT.ownerRef = players[nextPlay];
        if (nextPlay == players.length - 1) {
          nextPlay = 1;
        } else {
          nextPlay++;
        }
      }
    }
  }
}

/*
 * Territory class to manage all the different territories in the arena
 * 
 * String id - Identifier of the Territory
 * Player ownerRef - Player currently owning this territory
 * bool emperorDice - boolean telling wether this territory contains an emperor die or not
 * int x - x-Coordinate for the centerpoint of this territory
 * int y - y-Coordinate for the centerpoint of this territory
 * int dice - number of dice this territory is currently possessing
 * List<String> tiles - A list containing all the tiles that make up this territory together
 * Map<String, Tile> neighbourTiles - map managing the adjacent Tiles of near territories; only needed for generation
 * Map<String, Territory> neighbours - map containing all adjacent territories, identified via their String id
 */
class Territory {
  String id;
  Player ownerRef;
  bool emperorDice = false;
  int x, y;
  int dice;
  List<String> tiles;
  Map<String, Tile> neighbourTiles;
  Map<String, Territory> neighbours;

  /*
   * Constructor for a new Territory
   * 
   * int x - x-coordinate of the anchorpoint
   * int y - y-coordinate of the anchorpoint
   * String id - identifier for the new territory
   */
  Territory(this.x, this.y, this.id) {
    this.tiles = new List<String>();
    this.neighbourTiles = new Map<String, Tile>();
    this.neighbours = new Map<String, Territory>();
    dice = 1;
    emperorDice = false;
  }
  
  /*
   * Method that computes an attack from a territory on another. Called from
   * the attacking territory.
   * 
   * Territory ter - Defending territory
   * return List<List<int>> - results of the fight in the form [[Attackerdice],[Defenderdice]]
   */
  List<List<int>> attackTerritory(Territory ter) {
    List<List<int>> ret = new List();
    if (neighbours.containsValue(ter)) {
      var _random = new Math.Random();
      int myMax = 0;
      int hisMax = 0;
      int temp;
      List<int> myList = new List();
      List<int> hisList = new List();
      if (emperorDice == true && this.dice >= ter.dice) {
        print("ATTACK WITH EMPEROR DICE!");
        myMax = 9999;
        hisMax = 1;
        myList.add(9999);
        hisList.add(1);
        emperorDice = false;
        ter.emperorDice = true;
      } else {
        if (emperorDice == true && this.dice <= ter.dice) {
          myMax = 1;
          hisMax = 9999;
          myList.add(1);
          hisList.add(9999);
        } else {
          for (int i = 0; i < this.dice; i++) {
            temp = 1 + _random.nextInt(5);
            myMax += temp;
            myList.add(temp);
          }
          for (int i = 0; i < ter.dice; i++) {
            temp = 1 + _random.nextInt(5);
            hisMax += temp;
            hisList.add(temp);
          }
        }
      }
      if (myMax > hisMax) {
        print("ATTACKER SUCCESSFUL");
        ter.ownerRef.territories.remove(ter);
        ter.ownerRef = ownerRef;
        ownerRef.territories.add(ter);
        if (ter.emperorDice == true) {
          this.ownerRef.hasEmperor = true;
          ter.ownerRef.hasEmperor = false;
          ter.ownerRef.territories.forEach((t) {
            if (t.emperorDice) {
              ter.ownerRef.hasEmperor = true;
            }
          });
        }
        ter.dice = this.dice - 1;
        this.dice = 1;
      } else {
        print("ATTACKER DEFEATED!");
        this.dice = 1;
        if (emperorDice) {
          emperorDice = false;
          this.ownerRef.hasEmperor = false;
          print("EMPEROR DICE LOST!");
        }
      }
      print(ownerRef.toString());
      print("MY ATTACKS:" + myList.toString());
      print("HIS DEFENSE:" + hisList.toString());
      ret.add(myList);
      ret.add(hisList);
    }
    return ret;
  }
}

/*
 * Class for a Tile, the logical respresentation of a hexagon on the playfield
 * 
 * String id - Identifier of the Tile
 * String parentTerr - Identifier of the territory this tile belongs to
 * int x - x-coordinate of the tile
 * int y - y-coordinate of the tile
 * List<String> neighbours - ids of all adjacent Tiles (used for fieldgeneration only)
 */
class Tile {
  String id;
  String parentTerr;
  int x;
  int y;
  List<String> neighbours;

  /*
   * Constructor for tile-object
   * 
   * int x - x-coordinate of the Tile
   * int y - y-coordinate of the Tile
   */
  Tile(this.x, this.y) {
    this.neighbours = new List<String>();
    this.id = "ID" + x.toString() + "_" + y.toString();
  }
}

/*
 * abstract Class for managing all Players and their properties
 * 
 * String id - Identifier of that player ('human', 'cpu1' etc.) 
 * bool hasEmperor - boolean about wether or not the player owns an Emperor Die
 * List<Territory> territories - List of all territories this player currently owns
 * int pool - Dicepool this player currently has, between 0 and 60
 * int empChance - Chance this player has of getting an emperor Die at the end of his turn
 */
abstract class Player {
  String id;
  bool hasEmperor = false;
  List<Territory> territories;
  int pool;
  int empChance;
  
  /*
   * Constructor for a new Player
   * 
   * String id - Identifier of the new player
   * int empChance - Emperor Die chance
   */
  Player(this.id, this.empChance) {
    territories = new List<Territory>();
    pool = 0;
  }
  
  /*
   * Method to compute a playerstep, implemented in each class that inherits the player
   */
  List<Territory> turn();
  
  /*
   * Method to give a player dice based on his biggest territorychain at the end of his turn
   */
  void resupply() {
    int max = 1;
    int temp = 1;
    List<Territory> territory = new List<Territory>();
    for (int i = 0; i < territories.length; i++) {
      List<Territory> list = new List<Territory>();
      if (territories[i].dice < 8) {
        territory.add(territories[i]);
      }
      temp = longestRoute(territories[i], list, this.id);
      if (temp > max) max = temp;
    }
    print("Resupplying with $max dice.");
    var _random = new Math.Random();
    bool giveEmperor = false;
    if (id == "human" && hasEmperor == false) {
      int giveEmperorRand = _random.nextInt(100);
      if (giveEmperorRand > (100 - this.empChance)) {
        giveEmperor = true;
      }
    }
    int oldpool = pool;
    pool = 0;
    for (int i = 0; i < max + oldpool; i++) {
      var random;
      if (territory.length != 0) {
        if (territory.length != 1) random =
            _random.nextInt(territory.length - 1);
        else random = 0;
        if (giveEmperor) {
          territory[random].emperorDice = true;
          hasEmperor = true;
          giveEmperor = false;
        }
        territory[random].dice++;
        if (territory[random].dice == 8) territory.removeAt(random);
      } else {
        pool = oldpool + (max - (i));
        if (pool < 0) pool = 0;
        if (pool > 60) pool = 60;
        break;
      }
    }
  }

  /*
   * Distributes a given number of dice over all the territories this player currently owns
   * 
   * int dice - number of dice 
   */
  giveDice(int dice) {
    List<Territory> list = new List<Territory>();
    for (int i = 0; i < territories.length; i++) {
      if (territories[i].dice < 8) list.add(territories[i]);
    }
    var _random = new Math.Random();
    while (list.length > 0 && dice != 0) {
      if (list.length == 1) {
        list[0].dice++;
        if (list[0].dice == 8) list.removeAt(0);
        dice--;
      } else {
        var random = _random.nextInt(list.length - 1);
        list[random].dice++;
        if (list[random].dice == 8) list.removeAt(random);
        dice--;
      }
    }
    if (dice > 0) pool += dice;
  }

  /*
   * recursive method to find the biggest connected area of that player
   * 
   * Territory current -  currently iterated territory
   * List<Territory> visited - List of all visited territories
   * String owner - Player id for whom the route is checked
   * return int - number of previously unvisited territories visited 
   */
  int longestRoute(Territory current, List<Territory> visited, String owner) {
    int ret = 0;
    if (current.ownerRef.id == owner) {
      ret = 1;
      visited.add(current);
      current.neighbours.values.forEach((f) {
        if (!(visited.contains(f))) {
          ret += longestRoute(f, visited, owner);
        }
      });
    }
    return ret;
  }
}

/*
 * Aggressive AI, extending the Player
 * Constructor identical to the normal Player
 * For information about the AI-behaviour
 */
class Ai_agg extends Player {
  Ai_agg(id) : super(id, 0);
  List<Territory> turn() {
    List<Territory> list = new List<Territory>();
    for (int i = 0; i < territories.length; i++) {
      if (territories[i].dice > 1) {
        territories[i].neighbours.values.forEach((f) {
          if (territories[i].ownerRef.id != f.ownerRef.id &&
              f.ownerRef.id != "whitefield" &&
              territories[i].dice >= f.dice - 3) {
            if (list.length == 0) {
              list.add(territories[i]);
              list.add(f);
            } else {
              if (f.emperorDice == true) {
                list.removeLast();
                list.add(f);
              }
            }
          }
        });
      }
    }
    return list;
  }
}
/*
 * Defensive AI, extending the Player
 * Constructor identical to the normal Player
 * For information about the AI-behaviour
 */
class Ai_deff extends Player {
  Ai_deff(id) : super(id, 0);
  List<Territory> turn() {
    List<Territory> list = new List<Territory>();
    for (int i = 0; i < territories.length; i++) {
      if (territories[i].dice > 2) {
        territories[i].neighbours.values.forEach((f) {
          if (territories[i].ownerRef.id != f.ownerRef.id &&
              f.ownerRef.id != "whitefield") {
            if (territories[i].dice > f.dice + 1 ||
                territories[i].dice == 8 ||
                (territories[i].dice == f.dice &&
                    territories[i].emperorDice == true)) {
              if (list.length == 0) {
                list.add(territories[i]);
                list.add(f);
              } else {
                if (f.emperorDice == true) {
                  list.removeLast();
                  list.add(f);
                }
              }
            }
          }
        });
      }
    }
    return list;
  }
}
/*
 * Smart AI, extending the Player
 * Constructor identical to the normal Player
 * For information about the AI-behaviour
 */
class Ai_smart extends Player {
  Ai_smart(id) : super(id, 0);
  List<Territory> turn() {
    int max = 0;
    List<Territory> list = new List<Territory>();
    for (int i = 0; i < territories.length; i++) {
      if (territories[i].dice > 2) {
        territories[i].neighbours.values.forEach((f) {
          if (territories[i].ownerRef.id != f.ownerRef.id &&
              f.ownerRef.id != "whitefield") {
            if (territories[i].dice > f.dice + 1 ||
                territories[i].dice == 8 ||
                (territories[i].dice == f.dice &&
                    territories[i].emperorDice == true)) {
              f.neighbours.values.forEach((nf) {
                if (territories[i].ownerRef.id != f.ownerRef.id &&
                    f.ownerRef.id != "whitefield") {
                  if (max < nf.dice) max = nf.dice;
                }
              });
              if (territories[i].dice >= max - 2) {
                if (list.length == 0) {
                  list.add(territories[i]);
                  list.add(f);
                } else {
                  if (f.emperorDice == true) {
                    list.removeLast();
                    list.add(f);
                  }
                }
              }
            }
          }
        });
      }
    }
    return list;
  }
}

/*
 * Human player
 * turn computed in control.dart
 */
class Human extends Player {
  Human(id, empChance) : super(id, empChance);
  List<Territory> turn() => null;
}

/*
 * Whitefield player
 * no turn behaviour intended
 */
class Whitefield extends Player {
  Whitefield(id) : super(id, 0);
  List<Territory> turn() => null;
}
