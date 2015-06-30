part of DartyDiceWars;

class DiceView {
  HtmlElement get startButton => querySelector('#start');
  HtmlElement get endTurn => querySelector('#endTurn');
  HtmlElement get attackbar => querySelector('#attackbar');
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
  markAIAttack(String ter1) async {
    List<Element> tiles = querySelectorAll("[parent = '$ter1']");
    for (HtmlElement t in tiles) {
      t.classes.toggle('selected');      
    } 
  }
  
  //display second field getting colored, then wait
  markAIAttack2(String ter2) {
    List<Element> tiles = querySelectorAll("[parent = '$ter2']");
    for (HtmlElement t in tiles) {
      t.classes.toggle('selected');      
    } 
  }
  
  displayPlayer(String player){
    Element el = querySelector("#playerbar");
    el.text=player+": ";
    el.style.display = "";
  }
  
  //display all the dies etc. WIP
  displayAttack(List<List<int>> attack) {
    print("Shouldve waited #shrug");
    
    //attackbar.innerHtml = ;
    
    Element el = querySelector("#attackbar");
    int sum1=0;
    int sum2=0;
    attack[0].forEach((f){sum1+=f;});
    attack[1].forEach((f){sum2+=f;});
    el.text="ATTACKER DIES: " + attack[0].toString() +" "+sum1.toString()+ ".\nDEFENDER DIES: " + attack[1].toString()+" "+sum2.toString();
    el.style.display = "";
    List<Element> tiles = querySelectorAll(".selected");
       for (HtmlElement t in tiles) {
         t.classes.toggle('selected');
       }
  }
  
  
  

  
  updateSelectedTerritories(List<Territory> territories) {
    for (Territory t in territories) {
             t.tiles.forEach((ti) {
               HtmlElement change = arena.querySelector("#" + ti);
               
            if (!(t.ownerRef.id == "whitefield")) {
               String mid = "ID"+ t.x.toString() +"_"+t.y.toString();
             if (mid == ti){
                 change.text = t.dies.toString();
               }
            }     
             //  HtmlElement change = arena.querySelector("#" + ti);
               change.setAttribute("class", "hex ${t.ownerRef.id}");
               change.setAttribute("owner", t.ownerRef.id);
               change.setAttribute("parent", t.id);
             });
           }
  }
  
  void updateFieldWithTerritories(DiceGame model) {
    model._arena.territories.values.forEach((t) {
      t.tiles.forEach((ti) {
        HtmlElement change = arena.querySelector("#" + ti);
        
     if (!(t.ownerRef.id == "whitefield")) {
        String mid = "ID"+ t.x.toString() +"_"+t.y.toString();
      if (mid == ti){
          change.text = t.dies.toString();
        }
     }

        
        
        
      //  HtmlElement change = arena.querySelector("#" + ti);
        change.setAttribute("class", "hex ${t.ownerRef.id}");
        change.setAttribute("owner", t.ownerRef.id);
        change.setAttribute("parent", t.id);
      });
    });
    
  }
  
}
