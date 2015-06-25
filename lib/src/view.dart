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
    startButton.style.display = "none";
    
    endTurn.style.display = "";
    arena.innerHtml = htmlField;
  }
  //ter = territory to mark, direction true = mark it, false = unmark it
  void markTerritory(String ter, bool direction) {
    //a short wait 1/10th second or so needs to be done here too for effects <3
  }
  
  void showAttack(List<List<int>> attack) {
    //waiting needs to be done here to actually display the thrown dies
  }
  
  void updateSelectedTerritories(List<Territory> territories) {
    //only refresh those certain ids with the new owner and new diecount
  }
  
  void updateFieldWithTerritories(DiceGame model) {
    model._arena.territories.values.forEach((t) {
      t.tiles.forEach((ti) {
        HtmlElement change = arena.querySelector("#" + ti.toString());
        change.setAttribute("class", "hex ${t.id} ${t.owner}");
      });
    });
  }
}
