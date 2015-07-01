part of DartyDiceWars;

class DiceView {
  HtmlElement get startButton => querySelector('#start');
  HtmlElement get endTurn => querySelector('#endTurn');
  HtmlElement get playerbar => querySelector('#playerbar');
  HtmlElement get attackResult => querySelector("#attackRes");
  HtmlElement get defender => querySelector('#defender');
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
      if (!tiles[0].classes.contains('hover') &&
          !tiles[0].classes.contains('selected')) {
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

  displayPlayer(String player) {
    playerbar.text = player;
    playerbar.style.display = "";
  }

  clearFooter(String player) {
    playerbar.text = player;
    playerbar.classes.clear();
    defender.classes.clear();
    defender.text = "";
    defender.style.display = "none";
  }

  //display all the dies etc. WIP
  displayAttack(List<List<int>> attack, String atckr, String dfndr) {
    print("Shouldve waited #shrug");

    //attackbar.innerHtml = ;

    int sum1 = 0;
    int sum2 = 0;
    attack[0].forEach((f) {
      sum1 += f;
    });
    attack[1].forEach((f) {
      sum2 += f;
    });
    playerbar.text = "$atckr: ATTACKER DICE: " +
        attack[0].toString() +
        " " +
        sum1.toString();
    defender.text = "$dfndr: DEFENDER DICE: " +
        attack[1].toString() +
        " " +
        sum2.toString();
    defender.style.display = "";
    if (sum1 > sum2) {
      playerbar.classes.add("winner");
    } else {
      defender.classes.add("winner");
    }
    List<Element> tiles = querySelectorAll(".selected");
    for (HtmlElement t in tiles) {
      t.classes.toggle('selected');
    }
    new Timer(new Duration(milliseconds: 1000), () => this.clearFooter(atckr));
  }

  updateSelectedTerritories(List<Territory> ters) {
    for (Territory t in ters) {
      t.tiles.forEach((ti) {
        HtmlElement change = arena.querySelector("#" + ti);

        if (!(t.ownerRef.id == "whitefield")) {
          String mid = "ID" + t.x.toString() + "_" + t.y.toString();
          if (mid == ti) {
            change.querySelector(".root").text = t.dice.toString();
          }
        }
        //  HtmlElement change = arena.querySelector("#" + ti);
        change.setAttribute("class", "hex ${t.ownerRef.id}");
        change.setAttribute("owner", t.ownerRef.id);
        change.setAttribute("parent", t.id);
      });
    }
  }
  
  updateAfterAttack() {
    
  }
  
  

  void updateFieldWithTerritories(DiceGame model) {
    model._arena.territories.values.forEach((t) {
      t.tiles.forEach((ti) {
        HtmlElement change = arena.querySelector("#" + ti);

        if (!(t.ownerRef.id == "whitefield")) {
          String mid = "ID" + t.x.toString() + "_" + t.y.toString();
          if (mid == ti) {
            String newEl = '<div class="root">' + t.dice.toString() + '</div>';
            change.appendHtml(newEl);
            //change.children.add((new HtmlElement.created().text = t.dice.toString()));
            //change.text = t.dice.toString();
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
