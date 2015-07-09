part of DartyDiceWars;

class DiceView {
  HtmlElement get startButton => querySelector('#start');
  HtmlElement get endTurn => querySelector('#endTurn');
  HtmlElement get messageBar => querySelector('#messagebar');
  HtmlElement get sideBar => querySelector("#sidebar");
  HtmlElement get titleBar => querySelector('#titlebar');
  HtmlElement get loadingAnim => querySelector('#loadinganim');
  List<Element> spinningDiceAnim = querySelectorAll('.cuboid-1');
  final arena = querySelector('#arena');

  DiceView() {}

  void initializeViewField(DiceGame model, int maxLevel, List<int> pools) {
    sideBar.style.display = "";
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
    sideBar.querySelectorAll(".player").forEach((pl) {
      pl.querySelectorAll("div").forEach((d) {
        d.text = "";
      });
      pl.style.display = "none";
    });
    for (int i = 1; i < model.players.length; i++) {
      sideBar.querySelector("." + model.players[i].id).style.display = "";
      sideBar
          .querySelector("." + model.players[i].id)
          .querySelector(".plSupply").text = "MaxChain: ${pools[i - 1]}";
      sideBar
          .querySelector("." + model.players[i].id)
          .querySelector(".plPool").text = "Dice pool: 0";
      sideBar
          .querySelector("." + model.players[i].id)
          .querySelector(".plName").text = "${model.players[i].id}";
    }

    titleBar.text =
        "Now playing Level ${model.level.attributes[0].value} of $maxLevel.";
    messageBar.text = "";

    endTurn.style.display = "";
    arena.innerHtml = htmlField;
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

  void showAnim() {
    loadingAnim.style.display = "";
  }

  void hideAnim() {
    loadingAnim.style.display = "none";
  }

  void showSpin() {
    spinningDiceAnim.forEach((e) {
      e.style.display = "";
    });
  }

  void hideSpin() {
    spinningDiceAnim.forEach((e) {
      e.style.display = "none";
    });
  }

  void showMessage(String m) {
    messageBar.text = m;
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
          // print("toggled on: ${t.id}");
        }

        for (HtmlElement t in tiles) {
          t.classes.toggle('hover');
          // print("toggled on: ${t.id}");
        }
      }
    }
  }

  void gameOver(bool won) {
    if (won) {
      endTurn.style.display = "none";
      sideBar.style.display = "none";
      arena.innerHtml = "";

      titleBar.text = "You won! Congratulations for beating all levels!";
      showMessage("The game is over, but do you want to restart at Level 1?");
      startButton.innerHtml = "Restart";
      startButton.style.display = "";
      showAnim();
    } else {
      endTurn.style.display = "none";
      sideBar.style.display = "none";
      arena.innerHtml = "";

      titleBar.text = "You lost! Better luck next time!";
      showMessage("The game is over, but do you want to restart at Level 1?");
      startButton.innerHtml = "Restart";
      startButton.style.display = "";
      showAnim();
    }
  }

  void removeDefeatedPlayer(Player attackedPlayer) {
    sideBar.querySelector("." + attackedPlayer.id).style.display = "none";
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

  displayPlayer(String newPlayer, Player oldPlayer) {
    sideBar.querySelector("." + oldPlayer.id).querySelector(".plPool").text =
        "DicePool: ${oldPlayer.pool}";
    sideBar.querySelector("." + newPlayer).classes.add("attacker");
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
    HtmlElement divAtk = sideBar.querySelector("." + atckr);
    HtmlElement divDef = sideBar.querySelector("." + dfndr);

    //attackbar.innerHtml = ;
    if (attack[0][0] == 9999) {
      showMessage("Emperor Dice Attack!");
      new Timer(new Duration(milliseconds: 1000),
          () => showMessage("Now playing: " + atckr));
    }
    if (attack[1][0] == 9999) {
      showMessage("Emperor Dice was lost!");
      new Timer(new Duration(milliseconds: 1000),
          () => showMessage("Now playing: " + atckr));
    }

    int sum1 = 0;
    int sum2 = 0;
    attack[0].forEach((f) {
      sum1 += f;
    });
    attack[1].forEach((f) {
      sum2 += f;
    });
    divAtk.querySelector(".attackbar").text =
        "ATK: " + attack[0].toString() + " " + sum1.toString();
    divDef.querySelector(".attackbar").text =
        "DEF: " + attack[1].toString() + " " + sum2.toString();
    if (sum1 > sum2) {
      divAtk.classes.add("winner");
    } else {
      divDef.classes.add("winner");
    }
    List<Element> tiles = querySelectorAll(".selected");
    for (HtmlElement t in tiles) {
      t.classes.toggle('selected');
    }
    if (atckr == "human") {
      new Timer(new Duration(milliseconds: 2000),
          () => this.clearSidebar(atckr, dfndr));
    } else {
      new Timer(new Duration(milliseconds: 1000),
          () => this.clearSidebar(atckr, dfndr));
    }
  }

  updateSelectedTerritories(List<Territory> ters) {
    for (Territory t in ters) {
      t.tiles.forEach((ti) {
        HtmlElement change = arena.querySelector("#" + ti);

        if (!(t.ownerRef.id == "whitefield")) {
          String mid = "ID" + t.x.toString() + "_" + t.y.toString();
          if (mid == ti) {
            change.querySelector(".root").text = t.dice.toString();
            if (t.emperorDice == true) {
              change.querySelector(".root").classes.toggle("emperor", true);
            } else {
              change.querySelector(".root").classes.toggle("emperor", false);
            }
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
      List<String> tiles2, int dice1, int dice2, String attacker,
      String defender, int ownLongestRoute, int enemyLongestRoute,
      String newOwner, bool flag1, bool flag2) {
    for (String ti in tiles1) {
      HtmlElement change = arena.querySelector("#" + ti);

      if (center1 == ti) {
        change.querySelector(".root").text = dice1.toString();
        if (flag1) {
          change.querySelector(".root").classes.toggle("emperor", true);
        } else {
          change.querySelector(".root").classes.toggle("emperor", false);
        }
      }

      //  HtmlElement change = arena.querySelector("#" + ti);
      change.setAttribute("class", "hex $attacker");
      change.setAttribute("owner", attacker);
    }
    for (String ti in tiles2) {
      HtmlElement change = arena.querySelector("#" + ti);

      if (center2 == ti) {
        change.querySelector(".root").text = dice2.toString();
        if (flag2) {
          change.querySelector(".root").classes.toggle("emperor", true);
        } else {
          change.querySelector(".root").classes.toggle("emperor", false);
        }
      }

      //  HtmlElement change = arena.querySelector("#" + ti);
      change.setAttribute("class", "hex $newOwner");
      change.setAttribute("owner", newOwner);
    }

    //UPDATE THE PLAYERBAR WITH INFO ON THE MAX CONNECTED TILES
    HtmlElement divOwn1 = sideBar.querySelector("." + attacker);
    HtmlElement divOwn2 = sideBar.querySelector("." + defender);
    divOwn1.querySelector(".plSupply").text = "MaxChain: $ownLongestRoute";
    divOwn2.querySelector(".plSupply").text = "MaxChain: $enemyLongestRoute";
  }
}
