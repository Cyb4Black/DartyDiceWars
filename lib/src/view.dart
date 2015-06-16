part of DartyDiceWars;

class DartyDiceView{
  
  
  HtmlElement get startButton => querySelector('#start');
    
  
  final arena = querySelector('#arena');
  var territories;
  
  DartyDiceView(){
  }
  
  void initializeViewField(DartyDiceGame model){
    var field = model._arena;
    String htmlField = "";
    for(int iy = 1; iy <= field._ySize; iy++){
      String rowA = '<div class="hex-row">';
      String rowB = '<div class="hex-row even">';
      
      for(int ix = 1; ix <= field._ySize; ix++){
        if(ix % 2 != 0){
          rowA += '<div id="${ix}_${iy}" class="hex"><div class="corner-1"></div><div class="corner-2"></div></div>';
        }else{
          rowB += '<div id="${ix}_${iy}" class="hex"><div class="corner-1"></div><div class="corner-2"></div></div>';
        }
        
      }
      htmlField += (rowA + '</div>' + rowB + '</div>');
    }
    startButton.style.display = "none";
    arena.innerHtml = htmlField;
  }
  
  void updateFieldWithTerritorys(DartyDiceGame model){
    
  }
}