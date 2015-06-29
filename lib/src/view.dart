part of DartyDiceWars;

class DiceView {
  HtmlElement get startButton => querySelector('#start');
  HtmlElement get endTurn => querySelector('#endTurn');
  final arena = querySelector('#arena');
  var territories;
  
  DiceView() {}

  void initializeViewField(DiceGame model) {
    var field = model._arena;
    String htmlField = "";
    for (int iy = 1; iy <= field._ySize; iy++) {
      String rowA = '<div class="hex-row">';
      String rowB = '<div class="hex-row even">';

      for (int ix = 1; ix <= field._xSize; ix++) {
        if (ix % 2 != 0) {
          rowA +=
              '<div id="ID${ix}_${iy}" class="hex"><div class="corner-1"></div><div class="corner-2"></div></div>';
        } else {
          rowB +=
              '<div id="ID${ix}_${iy}" class="hex"><div class="corner-1"></div><div class="corner-2"></div></div>';
        }
      }
      htmlField += (rowA + '</div>' + rowB + '</div>');
    }
    
    
    endTurn.style.display = "";
    arena.innerHtml = htmlField;
  }
  
  showHover(String ter) {
    if (ter == "") {
      List<Element> turnoff = querySelectorAll(".hover");
              for (HtmlElement t in turnoff) {
                t.classes.toggle('hover');
              }
    } else {
    List<Element> tiles = querySelectorAll("[parent = '$ter']");
      if (!tiles[0].classes.contains('hover') && !tiles[0].classes.contains('selected')) {
        List<Element> turnoff = querySelectorAll(".hover");
        for (HtmlElement t in turnoff) {
          t.classes.toggle('hover');
        }
        
        for (HtmlElement t in tiles) {
                  t.classes.toggle('hover');    
               } 
      } 
    }
  }
  
  //ter = territory to mark, direction true = mark it, false = unmark it
   markTerritory(String ter) {
    showHover("");
    List<Element> tiles = querySelectorAll("[parent = '$ter']");
    for (HtmlElement t in tiles) {
      t.classes.toggle('selected');    
   } 
 
  }

   //display first field getting colored, then wait
  markAIAttack(String ter1, String ter2, List<List<int>> attack){
    List<Element> tiles = querySelectorAll("[parent = '$ter1']");
    for (HtmlElement t in tiles) {
      t.classes.toggle('selected');      
    } 
    new Timer(new Duration(milliseconds: 1000), () => markAIAttack2(ter2, attack));
    
  }
  
  //display second field getting colored, then wait
  markAIAttack2(String ter2, List<List<int>> attack) {
    List<Element> tiles = querySelectorAll("[parent = '$ter2']");
    for (HtmlElement t in tiles) {
      t.classes.toggle('selected');      
    } 
    new Timer(new Duration(milliseconds: 1000), () => simulateAttack(attack));
  }
  
  //wait a bit before starting the attack to display both selected areas
  void showAttack(List<List<int>> attack) {
    //waiting needs to be done here to actually display the thrown dies
    new Timer(new Duration(milliseconds: 1000), () => simulateAttack(attack));
  }
  
  
  //display all the dies etc. WIP
  simulateAttack(List<List<int>> attack) {
    print("Shouldve waited #shrug");
    List<Element> tiles = querySelectorAll(".selected");
       for (HtmlElement t in tiles) {
         t.classes.toggle('selected');
       }
    
  }
  
  void updateSelectedTerritories(List<Territory> territories) {
    //only refresh those certain ids with the new owner and new diecount
  }
  
  void updateFieldWithTerritories(DiceGame model) {
    model._arena.territories.values.forEach((t) {
      t.tiles.forEach((ti) {
        HtmlElement change = arena.querySelector("#" + ti);
        change.setAttribute("class", "hex ${t.ownerRef.id}");
        change.setAttribute("owner", t.ownerRef.id);
        change.setAttribute("parent", t.id);
      });
    });
  }
}
