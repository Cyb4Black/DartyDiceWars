part of DartyDiceWars;


class DartyDiceGame{
  int level;
  int playercount;
  Arena _arena;
  List<Player> players;
  DartyDiceGame(int xSize, int ySize, this.level){
    //-----Add Players (and whitefielddummy) to playerlist-----
    players = new List<Player>();
    players.add(new Player(#human, 0));
    players.add(new Player(#whitefield, 0));
    for(int i = 1; i <= level; i++){
      players.add(new Player(#cpu, i));
    }
    playercount = players.length - 1;
    //--------------------Build Arena--------------------------
    this._arena = new Arena(xSize, ySize, (level+1));
    
  }
}

class Arena{
  int _xSize;
  int _ySize;
  Map<String, Tile> field;
  Map<String, Territory> territories;
  
  Arena(this._xSize, this._ySize, int playersCnt){
    this.field = new Map<String, Tile>.from(initializeArena(_xSize, _ySize));
    this.territories = new Map<String, Territory>();
    territories.addAll(initializeTerritories(playersCnt));
  }
  
  Map<String, Tile> initializeArena(int x, int y){
    Map<String, Tile> ret = new Map<String, Tile>();
    //---------------------initialize fieldcorners-------------
    Tile c = new Tile(1,1);
    c.neighbours.add("2_1");
    c.neighbours.add("1_2");
    ret[c.id] = c;
    
    c = new Tile(x, 1);
    c.neighbours.add((x-1).toString() + "_1");
    c.neighbours.add((x-1).toString() + "_2");
    c.neighbours.add(x.toString() + "_2");
    ret[c.id] = c;
    
    c = new Tile(1, y);
    c.neighbours.add("1_" + (y-1).toString());
    c.neighbours.add("2_" + (y-1).toString());
    c.neighbours.add("2_" + (y).toString());
    ret[c.id] = c;
    
    c = new Tile(x, y);
    c.neighbours.add(x.toString() + "_" + (y-1).toString());
    c.neighbours.add((x-1).toString() + "_" + y.toString());
    ret[c.id] = c;
    //---------------------------------------------------------
    //---------------------initialize borders------------------
    for(int ix = 2; ix < x; ix++){
      Tile t = new Tile(ix, 1);//top-border-tile
      Tile b = new Tile(ix, y);//bottom-border-tile
      
      if(ix % 2 == 0){
        t.neighbours.add((ix-1).toString() + "_2");
        t.neighbours.add((ix+1).toString() + "_2");
      }
      if(ix % 2 != 0){
        b.neighbours.add((ix-1).toString() + "_" + (y-1).toString());
        b.neighbours.add((ix+1).toString() + "_" + (y-1).toString());
      }
      
      t.neighbours.add((ix-1).toString() + "_1");
      t.neighbours.add(ix.toString() + "_2");
      t.neighbours.add((ix+1).toString() + "_1");
      b.neighbours.add((ix-1).toString() + "_" + y.toString());
      b.neighbours.add(ix.toString() + "_" + (y-1).toString());
      b.neighbours.add((ix+1).toString() + "_" + y.toString());
      ret[t.id] = t;
      ret[b.id] = b;
    }
    //---------------------------------------------------------
    for(int iy = 2; iy < y; iy++){
      Tile l = new Tile(1, iy);//left-border-tile
      Tile r = new Tile(x, iy);//right-border-tile
      
      l.neighbours.add("1_" + (iy-1).toString());
      l.neighbours.add("2_" + (iy-1).toString());
      l.neighbours.add("2_" + iy.toString());
      l.neighbours.add("1_" + (iy+1).toString());
      
      r.neighbours.add(x.toString() + "_" + (iy-1).toString());
      r.neighbours.add((x-1).toString() + "_" + iy.toString());
      r.neighbours.add((x-1).toString() + "_" + (iy+1).toString());
      r.neighbours.add(x.toString() + "_" + (iy+1).toString());
      
      ret[r.id] = r;
      ret[l.id] = l;
    }
    //---------------------------------------------------------
    //----------------------initialize inner field-------------
    for(int ix = 2; ix < x; ix++){
      if(x % 2 == 0){
        for(int iy = 2; iy < y; iy++){
          Tile n = new Tile(ix, iy);
          n.neighbours.add(ix.toString() + "_" + (iy-1).toString());
          n.neighbours.add((ix-1).toString() + "_" + iy.toString());
          n.neighbours.add((ix+1).toString() + "_" + iy.toString());
          n.neighbours.add((ix-1).toString() + "_" + (iy+1).toString());
          n.neighbours.add(ix.toString() + "_" + (iy+1).toString());
          n.neighbours.add((ix+1).toString() + "_" + (iy+1).toString());
          ret[n.id] = n;
        }
      }else{
        for(int iy = 2; iy < y; iy++){
          Tile n = new Tile(ix, iy);
          n.neighbours.add((ix-1).toString() + "_" + (iy-1).toString());
          n.neighbours.add(ix.toString() + "_" + (iy-1).toString());
          n.neighbours.add((ix+1).toString() + "_" + (iy-1).toString());
          n.neighbours.add((ix-1).toString() + "_" + iy.toString());
          n.neighbours.add((ix+1).toString() + "_" + iy.toString());
          n.neighbours.add(ix.toString() + "_" + (iy+1).toString());
          ret[n.id] = n;
        }
      }
    }
    return ret;
  }
  
  Map<String, Territory> initializeTerritories(int playersCnt){
    Map<String, Territory> ret = new Map<String, Territory>();
    //--------------initialize vars for calculation------------
    int maxFields = ((32/playersCnt) * playersCnt).floor();
    int yMax = Math.sqrt(maxFields).floor();
    int xMax = yMax + ((32-(Math.pow(yMax,2))).floor()/yMax).floor();
    int playerFields = yMax*xMax;
    int whiteFields = maxFields - playerFields;
    //-----------------create/add Territories-------------------
    int n = 1;
    for(int ix = 1; ix <= xMax; ix++){
      for(int iy = 1; iy <= yMax; iy++){
        Territory newT = new Territory(ix, iy, "terr_$n");
        newT.tiles.add("${ix}_${iy}");
        field[newT.tiles[0]].neighbours.forEach((str) => newT.neighbourTiles[str] = "");        
        ret[newT.id] = newT;
        n++;
      }
    }
    while(){
      
    }
    
    //-----------------grow Territories------------------------
    
    
    return ret;
  }
}
/**
 * Territory-Class for managing connected tiles as territory
 */
class Territory{
  String id; //individual ID per territory
  String owner = "";
  int x, y; //coordinates of root tile for Territory
  List<String> tiles;
  Map<String, String> neighbourTiles;
  Map<String, String> neighbours;
  
  Territory(this.x, this.y, this.id){
    this.tiles = new List<String>();
    this.neighbourTiles = new Map<String, String>();
    this.neighbours = new Map<String, String>();
  }
}
/**
 * Tile-Class for managing a single hexagon-tile
 * contains a list of its neighbours for fieldinitialization
 */
class Tile{
  String id;
  int x;
  int y;
  List<String> neighbours;
  
  /**
   * Constructor-class for tile-object
   * 
   * @param x, x-coordinate (in imaginery 2D-array) of Tile
   * @param y, y-coordinate (in imaginery 2D-array) of Tile
   */
  Tile(this.x, this.y){
    this.neighbours = new List<String>();
    this.id = x.toString() + "_" + y.toString();
  }
}

/**
 * Player-class for managing player-properties 
 */
class Player{
  String id;
  Symbol type;
  List<String> territories;
  Symbol aiStyle;
  
  /**
   * Constructor-class for player-object
   * 
   * @param type, symbol of playertype as one of #human, #cpu, #whitefield,
   * whereas #whitefields exists for managing free tiles on battlefield
   * @param num, number for creating id, in case of cpu-type
   */
  Player(this.type, int num){
    if(type == #human){
      this.id = "human";
      this.aiStyle = null;
    }else if(type == #whitefield){
      this.id = "whitefields";
      this.aiStyle = null;
    }else{
      this.id = "cpu_" + num.toString();
      this.aiStyle = #intelligent;
    }
    this.territories = new List<String>();
  }
}