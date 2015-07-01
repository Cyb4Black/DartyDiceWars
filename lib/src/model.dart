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
    players.add(new Whitefield('whitefield'));
    players.add(new Human('human'));
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
    this._arena = new Arena(xSize, ySize, int.parse(level.children[2].text),
        int.parse(level.children[6].text), int.parse(level.children[0].text),
        players);

    //select first player based on startposition in levels.xml
    int order = players.length - int.parse(level.children[1].text);
    if (order == players.length) {
      order = 0;
    }
    currentPlayer = players[order];

    initDies(players);
  }

  initDies(List<Player> list) {
    int sum = 0;
    for (int i = 1; i < list.length; i++) {
      int temp = list[i].territories.length * 3;
      sum += temp;
    }
    sum = (sum / list.length - 1).round();
    for (int i = 1; i < list.length; i++) {
      list[i].giveDies(sum);
    }
  }

  nextPlayer() {
    if (currentPlayer.id != "whitefield") {
      currentPlayer
          .resupply(); //give this player the right amount of dies on random fields
    }

    for (int i = 0; i < players.length; i++) {
      if (players[i].id == currentPlayer.id) {
        if (i < players.length - 1) {
          currentPlayer = players[i + 1];
        } else {
          currentPlayer = players[0];
        }

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

  Arena(this._xSize, this._ySize, int playersCnt, int whitefields,
      int playerhandycap, List<Player> players) {
    this.field = new Map<String, Tile>.from(initializeArena(_xSize, _ySize));
    this.territories = new Map<String, Territory>();
    territories.addAll(initializeTerritories(playersCnt, whitefields, players));
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

  Map<String, Territory> initializeTerritories(
      int playersCnt, int whiteFields, List<Player> players) {
    int visited = 0;
    Map<String, Territory> ret;
    int playerFields;
    while (visited != playerFields) {
      ret = new Map<String, Territory>();
      //--------------initialize vars for calculation------------
      int maxFields = (((48 - whiteFields) / (playersCnt)).floor() *
              (playersCnt)) +
          whiteFields;
      int yMax = Math.sqrt(maxFields).floor();
      int xMax = yMax + ((48 - (Math.pow(yMax, 2))).floor() / yMax).floor();
      playerFields = yMax * xMax - whiteFields;
      //-----------------create/add Territories-------------------
      int n = 1;
      for (int ix = 1; ix <= xMax; ix++) {
        for (int iy = 1; iy <= yMax; iy++) {
          if (iy % 2 == 0) {
            Territory newT = new Territory(
                (60 / xMax * ix).floor(), (32 / yMax * iy).floor(), "terr_$n");
            newT.tiles.add("ID${newT.x}_${newT.y}");
            field[newT.tiles[0]].parentTerr = newT.id;
            field[newT.tiles[0]].neighbours
                .forEach((str) => newT.neighbourTiles[str] = field[str]);
            ret[newT.id] = newT;
            n++;
          } else {
            Territory newT = new Territory(
                (60 / xMax * ix).floor(), (32 / yMax * iy).floor(), "terr_$n");
            newT.tiles.add("ID${newT.x}_${newT.y}");
            field[newT.tiles[0]].parentTerr = newT.id;
            field[newT.tiles[0]].neighbours
                .forEach((str) => newT.neighbourTiles[str] = field[str]);
            ret[newT.id] = newT;
            n++;
          }
        }
      }
      //-----------------grow Territories 1.---------------------
      ret.values.forEach((t) {
        field[t.tiles[0]].neighbours.forEach((ti) {
          if (field[ti].parentTerr != null) {
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
          print(ranD);
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
      List<Territory> temp = new List<Territory>();
      visited = allVisited(players[1].territories[0], temp);
      print(
          "WhiteFields: $whiteFields \nPlayerFields: $playerFields \n Visited: $visited \n TmpLänge: ${temp.length}");
    }

    return ret;
  }

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
    /*current.neighbours.values.forEach((f) {
        if (current.ownerRef.id != "whitefield" && !(visited.contains(f))) {
          visited.add(f);
          ret = 1;
          ret  += allVisited(f, visited);
        }
      });*/
    return ret;
  }

  void assignTerritories(Map<String, Territory> newTs, List<Player> players,
      int whiteFields, int playerFields) {
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
/**
 * Territory-Class for managing connected tiles as territory
 */
class Territory {
  String id; //individual ID per territory
  String owner = "";
  Player ownerRef;
  int x, y; //coordinates of root tile for Territory
  int dice;
  List<String> tiles;
  Map<String, Tile> neighbourTiles;
  Map<String, Territory> neighbours;

  Territory(this.x, this.y, this.id) {
    this.tiles = new List<String>();
    this.neighbourTiles = new Map<String, Tile>();
    this.neighbours = new Map<String, Territory>();
    dice = 1;
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
      for (int i = 0; i < dice; i++) {
        temp = 1 + _random.nextInt(5);
        myMax += temp;
        myList.add(temp);
      }
      for (int i = 0; i < ter.dice; i++) {
        temp = 1 + _random.nextInt(5);
        hisMax += temp;
        hisList.add(temp);
      }
      if (myMax > hisMax) {
        print("ATTACKER SUCCESSFUL");
        ter.ownerRef.territories.remove(ter);
        ter.owner = owner;
        ter.ownerRef = ownerRef;
        ownerRef.territories.add(ter);
        ter.dice = dice - 1;
        dice = 1;
      } else {
        print("ATTACKER GOT PWNED KEK");
        dice = 1;
      }
      print("MY ATTACKS:" + myList.toString());
      print("HIS DEFENSE:" + hisList.toString());
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
  var pool;
  /**
   * Constructor-class for player-object
   * 
   * @param type, symbol of playertype as one of #human, #cpu, #whitefield,
   * whereas #whitefields exists for managing free tiles on battlefield
   * @param num, number for creating id, in case of cpu-type
   */
  Player(this.id) {
    territories = new List<Territory>();
    pool = 0;
  }
  List<Territory> turn();
  void resupply() {
    int max = 1;
    int temp = 1;
    List<Territory> territory = new List<Territory>();
    for (int i = 0; i < territories.length; i++) {
      List<Territory> list = new List<Territory>();
      // list.add(territories[i]);
      if (territories[i].dice < 8) {
        territory.add(territories[i]);
      }
      temp = longestRoute(territories[i], list, this.id);
      if (temp > max) max = temp;
    }

    print("Resupplying with $max dies.");
    var _random = new Math.Random();

    for (int i = 0; i < max + pool; i++) {
      var random;
      if (territory.length != 0) {
        if (territory.length != 1) random =
            _random.nextInt(territory.length - 1);
        else random = 0;
        territory[random].dice++;
        if (territory[random].dice == 8) territory.removeAt(random);
      } else {
        if (i < max) pool += max - (i);
        if (pool > 20) pool = 20;
        break;
      }
    }
  }
  giveDies(int dies) {
    List<Territory> list = new List<Territory>();
    for (int i = 0; i < territories.length; i++) {
      if (territories[i].dice < 8) list.add(territories[i]);
    }
    var _random = new Math.Random();
    while (list.length > 0 && dies != 0) {
      var random = _random.nextInt(list.length - 1);
      list[random].dice++;
      if (list[random].dice == 8) list.removeAt(random);
      dies--;
    }
    if (dies > 0) pool += dies;
  }
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

class Ai_agg extends Player {
  Ai_agg(id) : super(id);
  List<Territory> turn() {
    List<Territory> list = new List<Territory>();
    for (int i = 0; i < territories.length; i++) {
      if (territories[i].dice > 1) {
        territories[i].neighbours.values.forEach((f) {
          if (territories[i].ownerRef.id != f.ownerRef.id &&
              f.ownerRef.id != "whitefield") {
            list.add(territories[i]);
            list.add(f);
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
      if (territories[i].dice > 2) {
        territories[i].neighbours.values.forEach((f) {
          if (territories[i].ownerRef.id != f.ownerRef.id &&
              f.ownerRef.id != "whitefield") {
            if (territories[i].dice > f.dice + 1 || territories[i].dice == 8) {
              list.add(territories[i]);
              list.add(f);
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
      if (territories[i].dice > 2) {
        territories[i].neighbours.values.forEach((f) {
          if (territories[i].ownerRef.id != f.ownerRef.id &&
              f.ownerRef.id != "whitefield") {
            if (territories[i].dice > f.dice + 1 || territories[i].dice == 8) {
              list.add(territories[i]);
              list.add(f);
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
