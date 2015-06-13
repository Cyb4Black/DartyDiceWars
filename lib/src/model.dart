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
    //Add Players (and whitefielddummy to playerlist
    players = new List<Player>();
    players.add(new Player(#human, 0));
    players.add(new Player(#whitefield, 0));
    for(int i = 1; i < _playercount; i++){
      players.add(new Player(#cpu, i));
    }
    this._arena = new Arena(xSize, ySize, _playercount);
  }
}

class Arena{
  int _xSize;
  int _ySize;
  List<Tile> field;
  List<Territory> territories;
  
  Arena(this._xSize, this._ySize, int players){
    this.field = new List<Tile>(initializeArena(_xSize, _ySize));
    this.territories = new List<Territory>(initializeTerritories(players));
  }
  
  List<Tile> initializeArena(int x, int y, int players){
    List<Tile> ret = new List<Tile>();
    int maxfields = (Math.floor(32/players) * players);
    
    return ret;
  }
  
  List<Territory> initializeTerritories(int players){
    List<Territory> ret = new List<Territory>();
    
    
    
    return ret;
  }
}

class Territory{
  String id;
  String owner;
  List<String> tiles;
  List<String> neighbours;
  
  Territory(this.id){
    this.tiles = new List<String>();
    this.neighbours = new List<String>();
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
  
  Player(this.type, int num){
    if(type == #human){
      this.id = "human";
    }else if(type == #whitefield){
      this.id = "whitefields";
    }else{
      this.id = "cpu_" + num.toString();
    }
    this.territories = new List<String>();
  }
}