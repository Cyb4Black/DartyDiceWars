part of DartyDiceWars;

class DiceView {
  HtmlElement get startButton => querySelector('#start');
  HtmlElement get endTurn => querySelector('#endTurn');
  HtmlElement get messageBar => querySelector('#messagebar');
  HtmlElement get sideBar => querySelector("#sidebar");
  HtmlElement get titleBar => querySelector('#titlebar');
  HtmlElement get loadingAnim => querySelector('#loadinganim');
  final arena = querySelector('#arena');
  var territories;

  DiceView() {}
  void showAnim(){
    loadingAnim.style.display = "";
  }
  
  void hideAnim(){
    loadingAnim.style.display = "none";
  }

  void initializeViewField(DiceGame model, int maxLevel) {
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
    
    model.players.forEach((pl){
      sideBar.querySelector("." + pl.id).style.display = "";
    });
    titleBar.text = "You're fighting in level ${model.level.attributes[0]} of $maxLevel private!";

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
    sideBar.querySelector("." + player).classes.add("attacker");
  }

  undisplayPlayer(String player) {
    sideBar.querySelector("." + player).classes.remove("attacker");
  }

  clearSidebar(String atk, String def) {
    HtmlElement divAtk = sideBar.querySelector("." + atk);
    HtmlElement divDef = sideBar.querySelector("." + def);
    divAtk.attributes["class"] = "player $atk attacker";
    divDef.attributes["class"] = "player $def";
    
    divAtk.querySelector(".attackbar").text = "";
    divDef.querySelector(".attackbar").text = "";
  }

  //display all the dies etc. WIP
  displayAttack(List<List<int>> attack, String atckr, String dfndr) {
    print("Shouldve waited #shrug");
    
    HtmlElement divAtk = sideBar.querySelector("." + atckr);
    HtmlElement divDef = sideBar.querySelector("." + dfndr);

    //attackbar.innerHtml = ;

    int sum1 = 0;
    int sum2 = 0;
    attack[0].forEach((f) {
      sum1 += f;
    });
    attack[1].forEach((f) {
      sum2 += f;
    });
    divAtk.querySelector(".attackbar").text = "$atckr: ATK: " + attack[0].toString() + " " + sum1.toString();
    divDef.querySelector(".attackbar").text = "$dfndr: DEFENDER DICE: " + attack[1].toString() + " " + sum2.toString();
    if (sum1 > sum2) {
      divAtk.classes.add("winner");
    } else {
      divDef.classes.add("winner");
    }
    List<Element> tiles = querySelectorAll(".selected");
    for (HtmlElement t in tiles) {
      t.classes.toggle('selected');
    }
    new Timer(new Duration(milliseconds: 750), () => this.clearSidebar(atckr, dfndr));
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

  updateAfterAttack(String center1, String center2, List<String> tiles1,
      List<String> tiles2, int dice1, int dice2, String owner1, String owner2,
      int ownLongestRoute, int enemyLongestRoute) {
    print(ownLongestRoute.toString() +
        " BUT ERRYONE ALREADY KNOWS THE REAL MVP IS " +
        enemyLongestRoute.toString());
    for (String ti in tiles1) {
      HtmlElement change = arena.querySelector("#" + ti);

      if (center1 == ti) {
        change.querySelector(".root").text = dice1.toString();
      }

      //  HtmlElement change = arena.querySelector("#" + ti);
      change.setAttribute("class", "hex $owner1");
      change.setAttribute("owner", owner1);
    }
    for (String ti in tiles2) {
      HtmlElement change = arena.querySelector("#" + ti);

      if (center2 == ti) {
        change.querySelector(".root").text = dice2.toString();
      }

      //  HtmlElement change = arena.querySelector("#" + ti);
      change.setAttribute("class", "hex $owner2");
      change.setAttribute("owner", owner2);
    }

    //UPDATE THE PLAYERBAR WITH INFO ON THE MAX CONNECTED TILES
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
