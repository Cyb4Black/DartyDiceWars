part of DartyDiceWars;

class DiceView{
  
  
  HtmlElement get startButton => querySelector('#start');
  HtmlElement get testButton => querySelector('#test');
    
  
  final arena = querySelector('#arena');
  var territories;
  final testout = querySelector('#testout');
  DiceView(){
  }
  
  void initializeViewField(DiceGame model){
    var field = model._arena;
    String htmlField = "";
    for(int iy = 1; iy <= field._ySize; iy++){
      String rowA = '<div class="hex-row">';
      String rowB = '<div class="hex-row even">';
      
      for(int ix = 1; ix <= field._xSize; ix++){
        if(ix % 2 != 0){
          rowA += '<div id="ID${ix}_${iy}" class="hex"><div class="corner-1"></div><div class="corner-2"></div></div>';
        }else{
          rowB += '<div id="ID${ix}_${iy}" class="hex"><div class="corner-1"></div><div class="corner-2"></div></div>';
        }
        
      }
      htmlField += (rowA + '</div>' + rowB + '</div>');
    }
    startButton.style.display = "none";
    arena.innerHtml = htmlField;
  }
  
  void updateFieldWithTerritorys(DiceGame model){
    model._arena.territories.values.forEach((t){
      t.tiles.forEach((ti){
        HtmlElement change = arena.querySelector("#" + ti.toString());
        change.setAttribute("class", "hex ${t.id} ${t.owner}");
      });
    });
  }
}