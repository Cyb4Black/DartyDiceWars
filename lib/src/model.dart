part of DartyDiceWars;

class DiceGame {
  XmlNode level;
  int playercount;
  Player currentPlayer;
  Territory firstTerritory;
  Territory secondTerritory;
  Arena _arena;
  List<Player> players;
  DiceGame(int xSize, int ySize, this.level) {
    //-----Add Players (and whitefielddummy) to playerlist-----
    players = new List<Player>();
    players.add(new Human('#human'));
    players.add(new Whitefield('#whitefield'));
    int aggressiveAIs = int.parse(level.children[3].text);
    int defensiveAIs = int.parse(level.children[4].text);
    int smartAIs = int.parse(level.children[5].text);

    for (int i = 1; i < int.parse(level.children[2].text); i++) {
      if (aggressiveAIs > 0) {
        players.add(new Ai_agg('#cpu' + i.toString()));
        aggressiveAIs--;
      } else if (defensiveAIs > 0) {
        players.add(new Ai_deff('#cpu' + i.toString()));
        defensiveAIs--;
      } else if (smartAIs > 0) {
        players.add(new Ai_smart('#cpu' + i.toString()));
        smartAIs--;
      }
    }
    playercount = players.length - 1;
    //--------------------Build Arena--------------------------
    this._arena = new Arena(xSize, ySize, int.parse(level.children[2].text), int.parse(level.children[6].text),int.parse(level.children[0].text));

    int order = players.length - int.parse(level.children[1].text);
     if (order == players.length) {
       order = 0;
     }
    currentPlayer = players[0];
    /* int onTurn = 0;
    while(players.length>2){
      players[onTurn].turn();
      onTurn = onTurn==players.length ? 0 : onTurn++;
    }
  */
  }
  nextPlayer() {
    currentPlayer
        .resupply(); //give this player the right amount of dies on random fields
    for (int i = 0; i < players.length; i++) {
      if (players[i].id == currentPlayer.id) {
        currentPlayer = players[i + 1];
        break;
      }
    }
    //ALSO SET NEXT CURRENTPLAYER
  }
}

class Arena {
  int _xSize;
  int _ySize;
  Map<String, Tile> field;
  Map<String, Territory> territories;

  Arena(this._xSize, this._ySize, int playersCnt, int whitefields, int playerhandycap) {
    this.field = new Map<String, Tile>.from(initializeArena(_xSize, _ySize));
    this.territories = new Map<String, Territory>();
    territories.addAll(initializeTerritories(playersCnt));
  }

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
    //---------------------------------------------------------
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
    //---------------------------------------------------------
    //----------------------initialize inner field-------------
    for (int ix = 2; ix < x; ix++) {
      if (x % 2 == 0) {
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
          n.neighbours
              .add("ID" + (ix - 1).toString() + "_" + (iy - 1).toString());
          n.neighbours.add("ID" + ix.toString() + "_" + (iy - 1).toString());
          n.neighbours
              .add("ID" + (ix + 1).toString() + "_" + (iy - 1).toString());
          n.neighbours.add("ID" + (ix - 1).toString() + "_" + iy.toString());
          n.neighbours.add("ID" + (ix + 1).toString() + "_" + iy.toString());
          n.neighbours.add("ID" + ix.toString() + "_" + (iy + 1).toString());
          ret[n.id] = n;
        }
      }
    }
    return ret;
  }

  Map<String, Territory> initializeTerritories(int playersCnt) {
    Map<String, Territory> ret = new Map<String, Territory>();
    //--------------initialize vars for calculation------------
    int maxFields = ((48 / playersCnt) * playersCnt).floor();
    int yMax = Math.sqrt(maxFields).floor();
    int xMax = yMax + ((48 - (Math.pow(yMax, 2))).floor() / yMax).floor();
    int playerFields = yMax * xMax;
    int whiteFields = maxFields - playerFields;
    //-----------------create/add Territories-------------------
    int n = 1;
    for (int ix = 1; ix <= xMax; ix++) {
      for (int iy = 1; iy <= yMax; iy++) {
        Territory newT = new Territory((60 / xMax * ix).floor() - 3,
            (32 / yMax * iy).floor() - 2, "terr_$n");
        newT.tiles.add("ID${newT.x}_${newT.y}");
        field[newT.tiles[0]].neighbours
            .forEach((str) => newT.neighbourTiles[str] = "");
//        if(ix <=15 && iy <= 10){
//          newT.owner = "human";
//        }
        ret[newT.id] = newT;
        n++;
      }
    }

    //-----------------grow Territories------------------------
    /*  bool growable = true;
    while(growable){
      territories.values.forEach((t){
        
      });
    }*/

    return ret;
  }
}
/**
 * Territory-Class for managing connected tiles as territory
 */
class Territory {
  String id; //individual ID per territory
  String owner = "";
  Player ownerRef;
  int x, y; //coordinates of root tile for Territory
  int dies;
  List<String> tiles;
  Map<String, String> neighbourTiles;
  Map<String, Territory> neighbours;

  Territory(this.x, this.y, this.id) {
    this.tiles = new List<String>();
    this.neighbourTiles = new Map<String, String>();
    this.neighbours = new Map<String, Territory>();
    dies =1;
  }
  List<List<int>> attackTerritory(Territory ter) {
    List<List<int>> ret = new List();
    if (neighbours.containsValue(ter)) {
      var _random = new Math.Random();
      int myMax = 0;
      int hisMax = 0;
      int temp;
      List<int> myList = new List();
      List<int> hisList = new List();
      for (int i = 0; i < dies; i++) {
        temp = 1 + _random.nextInt(5);
        myMax += temp;
        myList.add(temp);
      }
      for (int i = 0; i < ter.dies; i++) {
        temp = 1 + _random.nextInt(5);
        hisMax += temp;
        hisList.add(temp);
      }
      if (myMax > hisMax) {
        ter.ownerRef.territories.remove(ter);
        ter.owner = owner;
        ter.ownerRef = ownerRef;
        ownerRef.territories.add(ter);
        ter.dies = dies - 1;
        dies = 1;
      } else {
        dies = 1;
      }
      ret.add(myList);
      ret.add(hisList);
    }
    return ret;
  }
}
/**
 * Tile-Class for managing a single hexagon-tile
 * contains a list of its neighbours for fieldinitialization
 */
class Tile {
  String id;
  String parentTerr;
  int x;
  int y;
  List<String> neighbours;

  /**
   * Constructor-class for tile-object
   * 
   * @param x, x-coordinate (in imaginery 2D-array) of Tile
   * @param y, y-coordinate (in imaginery 2D-array) of Tile
   */
  Tile(this.x, this.y) {
    this.neighbours = new List<String>();
    this.id = "ID" + x.toString() + "_" + y.toString();
  }
}

/**
 * Player-class for managing player-properties 
 */
abstract class Player {
  String id;
  List<Territory> territories;
  /**
   * Constructor-class for player-object
   * 
   * @param type, symbol of playertype as one of #human, #cpu, #whitefield,
   * whereas #whitefields exists for managing free tiles on battlefield
   * @param num, number for creating id, in case of cpu-type
   */
  Player(this.id) {
    territories = new List<Territory>();
  }
  List<Territory> turn();
  void resupply() {
    int max = 1;
    int temp = 1;
    for (int i = 0; i < territories.length; i++) {
      List<Territory> list = new List<Territory>();
      list.add(territories[i]);
      temp = longestRoute(territories[i], list, 1);
      if (temp > max) max = temp;
    }
    var _random = new Math.Random();
    for (int i = 0; i < max; i++) {
      territories[_random.nextInt(territories.length - 1)].dies++;
    }
  }

  int longestRoute(Territory territory, List<Territory> list, int max) {
    int ret = max;
    int temp;
    territory.neighbours.values.forEach((f) {
      if (territory.owner == f.owner && !list.contains(f)) {
        List<Territory> out = new List<Territory>();
        out.addAll(list);
        out.add(territory);
        temp = longestRoute(f, out, max + 1);
        if (temp > ret) ret = temp;
      }
    });
    return ret;
  }
}

class Ai_agg extends Player {
  Ai_agg(id) : super(id);
  List<Territory> turn() {
    List<Territory> list = new List<Territory>();
    for (int i = 0; i < territories.length; i++) {
      if (territories[i].dies > 1) {
        territories[i].neighbours.values.forEach((f) {
          if (territories[i].owner != f.owner) {
            list[0] = territories[i];
            list[1] = f;
            return list;
          }
        });
      }
    }
    return list;
  }
}
class Ai_deff extends Player {
  Ai_deff(id) : super(id);
  List<Territory> turn() {
    List<Territory> list = new List<Territory>();
    for (int i = 0; i < territories.length; i++) {
      if (territories[i].dies > 2) {
        territories[i].neighbours.values.forEach((f) {
          if (territories[i].owner != f.owner) {
            if (territories[i].dies > f.dies + 1 || territories[i].dies == 8) {
              list[0] = territories[i];
              list[1] = f;
              return list;
            }
          }
        });
      }
    }
    return list;
  }
}
class Ai_smart extends Player {
  Ai_smart(id) : super(id);
  List<Territory> turn() {
    List<Territory> list = new List<Territory>();
    for (int i = 0; i < territories.length; i++) {
      if (territories[i].dies > 2) {
        territories[i].neighbours.values.forEach((f) {
          if (territories[i].owner != f.owner) {
            if (territories[i].dies > f.dies + 1 || territories[i].dies == 8) {
              list[0] = territories[i];
              list[1] = f;
              return list;
            }
          }
        });
      }
    }
    return list;
  }
}
class Human extends Player {
  Human(id) : super(id);
  List<Territory> turn() => null;
}
class Whitefield extends Player {
  Whitefield(id) : super(id);
  List<Territory> turn() => null;
}
