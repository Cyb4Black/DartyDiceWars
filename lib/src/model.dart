part of DartyDiceWars;

class DartyDiceWar{
  DartyDiceGame game;
  int level;
  DartyDiceWar(this.level){    
    this.game = new DartyDiceGame(32, 28, (level+1));
    
  }
}
class DartyDiceGame{
  int _playercount;
  Arena _arena;
  List<Player> players;
  DartyDiceGame(int xSize, int ySize, this._playercount){
    //-----Add Players (and whitefielddummy) to playerlist-----
    players = new List<Player>();
    players.add(new Player(#human, 0));
    players.add(new Player(#whitefield, 0));
    for(int i = 1; i < _playercount; i++){
      players.add(new Player(#cpu, i));
    }
    //--------------------Build Arena--------------------------
    this._arena = new Arena(xSize, ySize, _playercount);
    
  }
}

class Arena{
  int _xSize;
  int _ySize;
  Map<String, Tile> field;
  Map<String, Territory> territories;
  
  Arena(this._xSize, this._ySize, int players){
    this.field = new Map<String, Tile>(initializeArena(_xSize, _ySize));
    this.territories = new Map<String, Territory>(initializeTerritories(players));
  }
  
  Map<String, Tile> initializeArena(int x, int y){
    Map<String, Tile> ret = new List<Tile>();
    //---------------------initialize fieldcorners-------------
    Tile c = new Tile(1,1);
    c.neighbours.add("2_1");
    c.neighbours.add("1_2");
    ret.add(c.id, c);
    
    c = new Tile(x, 1);
    c.neighbours.add((x-1).toString() + "_1");
    c.neighbours.add((x-1).toString() + "_2");
    c.neighbours.add(x.toString() + "_2");
    ret.add(c.id, c);
    
    c = new Tile(1, y);
    c.neighbours.add("1_" + (y-1).toString());
    c.neighbours.add("2_" + (y-1).toString());
    c.neighbours.add("2_" + (y).toString());
    ret.add(c.id, c);
    
    c = new Tile(x, y);
    c.neighbours.add(x.toString() + "_" + (y-1).toString());
    c.neighbours.add((x-1).toString() + "_" + y.toString());
    ret.add(c.id, c);
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
      ret.add(t.id, t);
      ret.add(b.id, b);
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
      
      ret.add(r.id, r);
      ret.add(l.id, l);
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
          ret.add(n.id, n);
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
          ret.add(n.id, n);
        }
      }
    }
    return ret;
  }
  
  Map<String, Territory> initializeTerritories(int players){
    Map<String, Territory> ret = new List<Territory>();
    //--------------initialize vars for calculation------------
    int maxFields = (Math.floor(32/players) * players);
    int yMax = Math.floor(Math.sqrt(MaxFields));
    int xMax = yMax + Math.floor(floor(32-(Math.pow(y,2)))/y);
    int playerFields = y*x;
    int whiteFields = maxfields - playerFields;
    //-----------------create/add Territories-------------------
    int n = 1;
    for(int i = 1; i <= xMax; i++){
      for(int j = 1; j <= yMax; j++){
        Territory newT = new Territory(x, y, "terr_$n");
        newT.tiles.add("$x_$y");
        newT.neighbourTiles.add(field[newT.id].neighbours, "");
        ret.add(newT.id, newT);
        n++;
      }
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
  int x, y; //coordinates of root tile for Territory
  List<String> tiles;
  Map<String, String> neighbourTiles;
  Map<String, String> neighbours;
  
  Territory(this.x, this.y, this.id){
    this.tiles = new List<String>();
    this.neighbourTiles = new Map<String, String>();
    this.neighbours = new Map<String, String>();
    this.owner = "";
  }
}

class Tile{
  String id;
  int x;
  int y;
  List<String> neighbours;
  
  Tile(this.x, this.y){
    this.neighbours = new List<String>();
    this.id = x.toString() + "_" + y.toString();
  }
}

class Player{
  String id;
  Symbol type;
  List<String> territories;
  Symbol aiStyle;
  
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