part of DartyDiceWars;

/*
 * Viewpart of the MVC structure of DiceWars
 * 
 * Here, the internal results get displayed on the HTML document
 */
class DiceView {

  /*
   * View Variables:
   * HtmlElement startButton - Button displayed for the gamestart
   * HtmlElement endTurn - Button allowing the player to end his turn
   * HtmlElement messageBar - Bar for displaying various messages to the player
   * HtmlElement sideBar - Bar displaying all active players
   * HtmlElement titleBar - upper Bar for displaying levelinformation
   * HtmlElement loadingAnim - Element for displaying the rotating circle animation
   * List<Element> spinningDiceAnim - List managing all the Elements of the rotating Die
   * final arena - contains all the Elements in the arena, such as all hexagons
   */
  HtmlElement get startButton => querySelector('#start');
  HtmlElement get endTurn => querySelector('#endTurn');
  HtmlElement get messageBar => querySelector('#messagebar');
  HtmlElement get sideBar => querySelector("#sidebar");
  HtmlElement get titleBar => querySelector('#titlebar');
  HtmlElement get loadingAnim => querySelector('#loadinganim');
  List<Element> spinningDiceAnim = querySelectorAll('.cuboid-1');
  final arena = querySelector('#arena');

  /*
   * Constructor for the DiceView, not intended to do anything
   */
  DiceView() {}

  /*
   * Generates a Field of hexagons with unique ids, allowing the field of Tiles generated in the Model to 
   * be displayed for the Viewer. Also initializes the Sidebar.
   * 
   * DiceGame model - Model element containing all territories and tiles
   * int maxLevel - Number of Levels given in 'levels.xml'
   * List<int> pools - List with all starting numbers of maximum connected areas of all players
   */
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
    titleBar.text = "Now playing Level ${model.level.attributes[0].value} of $maxLevel.";
    messageBar.text = "";
    endTurn.style.display = "";
    arena.innerHtml = htmlField;
  }

  /*
   * Updates the View with all Territories in the Model, used only for initialization
   * 
   * DiceGame model - Model element containing all territories
   */
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

  /*
   * switches the Loadinganimation on
   */
  void showAnim() {
    loadingAnim.style.display = "";
  }

  /*
   * switches the Loadinganimation off
   */
  void hideAnim() {
    loadingAnim.style.display = "none";
  }

  /*
   * switches the display of rotating dice on
   */
  void showSpin() {
    spinningDiceAnim.forEach((e) {
      e.style.display = "";
    });
  }

  /*
   * switches the display of rotating dice off
   */
  void hideSpin() {
    spinningDiceAnim.forEach((e) {
      e.style.display = "none";
    });
  }
  
  /*
   * Displays a given message on the Messagebar
   * 
   * String m - Message that should be displayed
   */
  void showMessage(String m) {
    messageBar.text = m;
  }

  /*
   * Displays the Hovereffect on the given area by assingning the CSS class (opacity: 0.9). 
   * Note that only one area at a time can have the Hovereffect.
   * 
   * String ter - Territory that should get the Hover effect
   */
  void showHover(String ter) {
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

  /*
   * Notifies the player about the end of the current game - either because he finished
   * all levels or lost
   * 
   * bool won - true if the player won all levels or false if he got defeated
   */
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

  /*
   * Removes a given player from the displayed playerlist, taking him out of 
   * the visible game
   * 
   * Player attackedPlayer - Player that just lost and thus needs to be removed
   */
  void removeDefeatedPlayer(Player attackedPlayer) {
    sideBar.querySelector("." + attackedPlayer.id).style.display = "none";
  }

/*
 * Marks a territory as selected by assigning the CSS class (opacity: 0.7)
 * 
 * String ter - territory that should be updated
 */
  void markTerritory(String ter) {
    showHover("");
    List<Element> tiles = querySelectorAll("[parent = '$ter']");
    for (HtmlElement t in tiles) {
      t.classes.toggle('selected');
    }
  }

  /*
   * Marks a territory as selected for the AI attack by assigning the CSS class (opacity: 0.7) 
   * 
   * String ter1 - territory that should be updated
   */
  void markAIAttack(String ter1) {
    List<Element> tiles = querySelectorAll("[parent = '$ter1']");
    for (HtmlElement t in tiles) {
      t.classes.toggle('selected');
    }
  }


  /*
   * Updates the PlayerBar with new information 
   * 
   * String newPlayer - id of the now current Player
   * String oldPlayer - id of the last Player
   */
  void updatePlayerBar(String newPlayer, Player oldPlayer) {
    sideBar.querySelector("." + oldPlayer.id).querySelector(".plPool").text =
        "DicePool: ${oldPlayer.pool}";
    sideBar.querySelector("." + oldPlayer.id).classes.remove("attacker");
    sideBar.querySelector("." + newPlayer).classes.add("attacker");
  }

  /*
   * Displays the current attack to the Player, showing the results of all dice as well as 
   * the winner of the fight.
   * 
   * List<List<int>> attack - results of the fight in the form [[Attackerdice],[Defenderdice]]
   * String atckr - id of the Attacker
   * String dfndr - id of the Defender
   */
  void displayAttack(List<List<int>> attack, String atckr, String dfndr) {
    HtmlElement divAtk = sideBar.querySelector("." + atckr);
    HtmlElement divDef = sideBar.querySelector("." + dfndr);
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

/*
 * Clears the Sidebar of all additionally displayed information from the fight
 * 
 * String atk - id of the Attacker
 * String def - id of the Defender
 */
  void clearSidebar(String atk, String def) {
    HtmlElement divAtk = sideBar.querySelector("." + atk);
    HtmlElement divDef = sideBar.querySelector("." + def);
    divAtk.attributes["class"] = "player $atk attacker";
    divDef.attributes["class"] = "player $def";

    divAtk.querySelector(".attackbar").text = "";
    divDef.querySelector(".attackbar").text = "";
  }
  
  /*
   * Updates all the given territories with current informations. Used at end of turn
   * 
   * List<Territory> ters - List of all territories that need to be updated
   */
  void updateSelectedTerritories(List<Territory> ters) {
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
        change.setAttribute("class", "hex ${t.ownerRef.id}");
        change.setAttribute("owner", t.ownerRef.id);
        change.setAttribute("parent", t.id);
      });
    }
  }

  /*
   * Updates the arena with the new information after an attack
   * 
   * String center1 - Centerpoint of the attackerterritory
   * String center2 - Centerpoint of the defenderterritory
   * List<String> tiles1- List containing all tiles of the attackerterritory
   * List<String> tiles2- List containing all tiles of the defenderterritory
   * int dice1 - new number of dice in attackerterritory
   * int dice2 - new number of dice in defenderterritory
   * String attacker - id of the attacking player
   * String defender - id of the defending player
   * int ownLongestRoute - longest connected Areachain of the attacker
   * int enemyLongestRoute - longest connected Areachain of the defender
   * String newOwner - new Owner of the attacked Territory
   * bool flag1 - boolean for updating the Emperor Die location
   * bool flag2 - boolean for updating the Emperor Die location
   */
  void updateAfterAttack(String center1, String center2, List<String> tiles1,
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
