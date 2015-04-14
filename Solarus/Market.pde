public class Market extends State {

  //set up UIGroups
  private UIGroup GMMenu;
  private UIGroup BSButtons;
  private UIGroup UpButtons;

  //Set up The Availiabel Resources and thier colours
  private Resource[] TradeGoods = new Resource[8];
  private color[] colours = {
    color(255, 0, 0), 
    color(255, 128, 0), 
    color(255, 255, 0), 
    color(0, 255, 0), 
    color(0, 255, 255), 
    color(0, 0, 255), 
    color(128, 0, 255), 
    color(255, 0, 255)
  };

  //set up the Goods inventory and money 
  private int[] GoodsStore = new int[8];
  private int Money;

  //Constructor calls super and initalizes the availiable resources
  public Market(StateManager sm) {
    super(sm);

    TradeGoods[0] = new Resource("Polyvinyl Chloride", 500, 65, 0, colours[0]);
    TradeGoods[1] = new Resource("Polycarbonate", 500, 80, PI-QUARTER_PI, colours[1]);
    TradeGoods[2] = new Resource("Deuterium", 500, 70, PI+QUARTER_PI, colours[2]);
    TradeGoods[3] = new Resource("Tritium", 500, 85, QUARTER_PI, colours[3]);
    TradeGoods[4] = new Resource("Adamantium", 500, 60, TAU-QUARTER_PI, colours[4]);
    TradeGoods[5] = new Resource("Titanium", 500, 95, HALF_PI, colours[5]);
    TradeGoods[6] = new Resource("Water", 500, 100, TAU-HALF_PI, colours[6]);
    TradeGoods[7] = new Resource("Food", 500, 90, PI, colours[7]);

    Money = 500;

    GMMenu = new UIGroup(new PVector(width/2, height/2), new PVector(0, 0));
  }

  //initializes state upon entering
  public void init() {

    //buttons for both buying/selling resources and upgrades
    BSButtons = new UIGroup(new PVector(width/2, height/2));
    BSButtons.add(new UIButton(new PVector(395, -405), new PVector(35, 20), "", new BuyGoods0(), color(0, 255, 0), color(75, 200, 255)));
    BSButtons.add(new UIButton(new PVector(435, -405), new PVector(35, 20), "", new SellGoods0(), color(255, 0, 0), color(75, 200, 255)));
    BSButtons.add(new UIButton(new PVector(395, -310), new PVector(35, 20), "", new BuyGoods1(), color(0, 255, 0), color(75, 200, 255)));
    BSButtons.add(new UIButton(new PVector(435, -310), new PVector(35, 20), "", new SellGoods1(), color(255, 0, 0), color(75, 200, 255)));
    BSButtons.add(new UIButton(new PVector(395, -215), new PVector(35, 20), "", new BuyGoods2(), color(0, 255, 0), color(75, 200, 255)));
    BSButtons.add(new UIButton(new PVector(435, -215), new PVector(35, 20), "", new SellGoods2(), color(255, 0, 0), color(75, 200, 255)));
    BSButtons.add(new UIButton(new PVector(395, -120), new PVector(35, 20), "", new BuyGoods3(), color(0, 255, 0), color(75, 200, 255)));
    BSButtons.add(new UIButton(new PVector(435, -120), new PVector(35, 20), "", new SellGoods3(), color(255, 0, 0), color(75, 200, 255)));
    BSButtons.add(new UIButton(new PVector(395, -25), new PVector(35, 20), "", new BuyGoods4(), color(0, 255, 0), color(75, 200, 255)));
    BSButtons.add(new UIButton(new PVector(435, -25), new PVector(35, 20), "", new SellGoods4(), color(255, 0, 0), color(75, 200, 255)));
    BSButtons.add(new UIButton(new PVector(395, 70), new PVector(35, 20), "", new BuyGoods5(), color(0, 255, 0), color(75, 200, 255)));
    BSButtons.add(new UIButton(new PVector(435, 70), new PVector(35, 20), "", new SellGoods5(), color(255, 0, 0), color(75, 200, 255)));
    BSButtons.add(new UIButton(new PVector(395, 165), new PVector(35, 20), "", new BuyGoods6(), color(0, 255, 0), color(75, 200, 255)));
    BSButtons.add(new UIButton(new PVector(435, 165), new PVector(35, 20), "", new SellGoods6(), color(255, 0, 0), color(75, 200, 255)));
    BSButtons.add(new UIButton(new PVector(395, 260), new PVector(35, 20), "", new BuyGoods7(), color(0, 255, 0), color(75, 200, 255)));
    BSButtons.add(new UIButton(new PVector(435, 260), new PVector(35, 20), "", new SellGoods7(), color(255, 0, 0), color(75, 200, 255)));

    UpButtons = new UIGroup(new PVector(0, 0));
    UpButtons.add(new UIButton(new PVector(470, 870), new PVector(112, 112), "", new BuyHealth(), color(0, 0, 0, 0), color(75, 200, 255)));
    UpButtons.add(new UIButton(new PVector(635, 870), new PVector(112, 112), "", new BuyDamage(), color(0, 0, 0, 0), color(75, 200, 255)));
    UpButtons.add(new UIButton(new PVector(800, 870), new PVector(112, 112), "", new BuyShield(), color(0, 0, 0, 0), color(75, 200, 255)));
    UpButtons.add(new UIButton(new PVector(965, 870), new PVector(112, 112), "", new BuyRepair(), color(0, 0, 0, 0), color(75, 200, 255)));
    UpButtons.add(new UIButton(new PVector(1130, 870), new PVector(112, 112), "", new BuyShip(), color(0, 0, 0, 0), color(75, 200, 255)));


    //updates the values of the availible resources
    for (int i=0; i<TradeGoods.length; i++)
    {
      TradeGoods[i].update();
    }

    //pause menu
    PGraphics tmpBack = createGraphics(500, 650);
    tmpBack.beginDraw();
    tmpBack.fill(50, 50, 50, 150);
    tmpBack.stroke(50, 50, 50);
    tmpBack.rect(0, 0, 500, 650);
    tmpBack.endDraw();
    GMMenu.add(new UIImage(
    new PVector(0, 0), 
    new PVector(500, 650), 
    tmpBack ));

    PGraphics tmpBack2 = createGraphics(width, height);
    tmpBack2.beginDraw();
    tmpBack2.fill(0, 0, 0, 100);
    tmpBack2.stroke(0, 0, 0, 100);
    tmpBack2.rect(0, 0, width, height);
    tmpBack2.endDraw();
    GMMenu.add(new UIImage(
    new PVector(0, 0), 
    new PVector(width, height), 
    tmpBack2 ));

    GMMenu.add(new UIButton(
    new PVector(0, -225), 
    new PVector(400, 100), 
    "Resume Game", 
    new unpause() ));

    class tempSave implements Command { 
      public void execute() {
        println("Saved Game.");
      }
    }
    GMMenu.add(new UIButton(
    new PVector(0, -75), 
    new PVector(400, 100), 
    "Save Game", 
    new tempSave() ));

    GMMenu.add(new UIButton(
    new PVector(0, 75), 
    new PVector(400, 100), 
    "Options", 
    new options() ));

    class ReturnToLevel implements Command { 
      public void execute() {
        sm.returnToPrev();
      }
    }
    GMMenu.add(new UIButton(
    new PVector(0, 225), 
    new PVector(400, 100), 
    "Return to Level", 
    new ReturnToLevel() ));
  }

  //updates buttons in pause menu or market screen
  public boolean update() {
    if (!pause)
    {
      BSButtons.update();
      UpButtons.update();
    }
    //If menu is up
    else
    {
      if (keys[9] && keysS[9])
      {
        for (int i=0; i<TradeGoods.length; i++)
        {
          TradeGoods[i].update();
        }
        keysS[9] = false;
      }

      if (options)
      {
        sm.optionsMenu.update();
      } else
      {
        GMMenu.update();
      }
    }

    return true;
  }
  //renders the market screen or pause menu
  public void render() {
    background(0);
    //renders gaph
    for (int i=0; i<TradeGoods.length; i++) {
      TradeGoods[i].render((i+1)*95);
      fill(TradeGoods[i].col);
      text(TradeGoods[i].name, 85, ((i+1)*95)-4);
      textSize(20);
      text((TradeGoods[i].name+": "+GoodsStore[i]), 1418, (350+((i+1)*30)));
    }
    stroke(75, 200, 255);
    noFill();
    rectMode(CORNERS);
    rect(170, 83, 1170, 772);
    for (int i=1; i<5; i++) {
      line(170+(i*200), 83, 170+(i*200), 772);
    }
    //stroke(255, 0, 0);
    //line(185, 77, 185, 724);

    //renders buttons
    BSButtons.render(new PVector(0, 0));
    UpButtons.render(new PVector(0, 0));

    //redners upgrade button graphics
    textSize(20);
    noStroke();
    fill(0, 255, 0);
    rect(457, 820, 483, 920);
    rect(420, 857, 520, 883);
    text("Health", 470, 940);

    fill(255, 0, 0);
    triangle(635, 820, 582, 920, 690, 920);
    fill(0);
    triangle(635, 865, 606, 920, 665, 920);
    fill(255, 0, 0);
    text("Damage", 635, 940);

    fill(0, 0, 255);
    ellipse(800, 870, 35, 50);
    text("Sheild", 800, 940);

    fill(255, 255, 0);
    rect(952, 820, 978, 920);
    rect(915, 857, 1017, 883);
    text("Repair", 965, 940);

    fill(255);
    rect(1117, 820, 1143, 920);
    rect(1080, 857, 1180, 883);
    text("Ship", 1130, 940);

    textSize(20);
    fill(75, 200, 255);
    text(("Money: "+Money), 1418, 190); 

    //renders pause menu
    if (pause)
    {
      if (options)
      {
        sm.optionsMenu.render(new PVector(0, 0));
      } else
      {
        GMMenu.render(new PVector(0, 0));
      }
    }
  }
  //buy/sell button functions
  class BuyGoods0 implements Command {
    public void execute()
    {
      if (Money>=TradeGoods[0].value) {
        GoodsStore[0]++;
        Money-=TradeGoods[0].value;
      }
    }
  }
  class SellGoods0 implements Command {
    public void execute()
    {
      if (GoodsStore[0]>0) {
        GoodsStore[0]--;
        Money+=TradeGoods[0].value;
      }
    }
  }
  class BuyGoods1 implements Command {
    public void execute()
    {
      if (Money>=TradeGoods[1].value) {
        GoodsStore[1]++;
        Money-=TradeGoods[1].value;
      }
    }
  }
  class SellGoods1 implements Command {
    public void execute()
    {
      if (GoodsStore[1]>0) {
        GoodsStore[1]--;
        Money+=TradeGoods[1].value;
      }
    }
  }
  class BuyGoods2 implements Command {
    public void execute()
    {
      if (Money>=TradeGoods[2].value) {
        GoodsStore[2]++;
        Money-=TradeGoods[2].value;
      }
    }
  }
  class SellGoods2 implements Command {
    public void execute()
    {
      if (GoodsStore[2]>0) {
        GoodsStore[2]--;
        Money+=TradeGoods[2].value;
      }
    }
  }
  class BuyGoods3 implements Command {
    public void execute()
    {
      if (Money>=TradeGoods[3].value) {
        GoodsStore[3]++;
        Money-=TradeGoods[3].value;
      }
    }
  }
  class SellGoods3 implements Command {
    public void execute()
    {
      if (GoodsStore[3]>0) {
        GoodsStore[3]--;
        Money+=TradeGoods[3].value;
      }
    }
  }
  class BuyGoods4 implements Command {
    public void execute()
    {
      if (Money>=TradeGoods[4].value) {
        GoodsStore[4]++;
        Money-=TradeGoods[4].value;
      }
    }
  }
  class SellGoods4 implements Command {
    public void execute()
    {
      if (GoodsStore[4]>0) {
        GoodsStore[4]--;
        Money+=TradeGoods[4].value;
      }
    }
  }
  class BuyGoods5 implements Command {
    public void execute()
    {
      if (Money>=TradeGoods[5].value) {
        GoodsStore[5]++;
        Money-=TradeGoods[5].value;
      }
    }
  }
  class SellGoods5 implements Command {
    public void execute()
    {
      if (GoodsStore[5]>0) {
        GoodsStore[5]--;
        Money+=TradeGoods[5].value;
      }
    }
  }
  class BuyGoods6 implements Command {
    public void execute()
    {
      if (Money>=TradeGoods[6].value) {
        GoodsStore[6]++;
        Money-=TradeGoods[6].value;
      }
    }
  }
  class SellGoods6 implements Command {
    public void execute()
    {
      if (GoodsStore[6]>0) {
        GoodsStore[6]--;
        Money+=TradeGoods[6].value;
      }
    }
  }
  class BuyGoods7 implements Command {
    public void execute()
    {
      if (Money>=TradeGoods[7].value) {
        GoodsStore[7]++;
        Money-=TradeGoods[7].value;
      }
    }
  }
  class SellGoods7 implements Command {
    public void execute()
    {
      if (GoodsStore[7]>0) {
        GoodsStore[7]--;
        Money+=TradeGoods[7].value;
      }
    }
  }
  //buy upgrade button functions
  class BuyHealth implements Command {
    public void execute()
    {
      if (Money>=100) {
        println("Health Upgrade Bought");
        for (int i=0; i<gameRef.players.size (); i++) {
          gameRef.players.get(i).getHealthMax().add(5);
        }
        Money -= 100;
      }
    }
  }
  class BuyDamage implements Command {
    public void execute()
    {
      if (Money>=100) {
        println("Damage Upgrade Bought");
        Money -= 100;
      }
    }
  }
  class BuyShield implements Command {
    public void execute()
    {
      if (Money>=100) {
        println("Shield Upgrade Bought");
        for (int i=0; i<gameRef.players.size (); i++) {
          gameRef.players.get(i).getShieldMax().add(200);
        }
        Money -= 100;
      }
    }
  }
  class BuyRepair implements Command {
    public void execute()
    {
      if (Money>=100) {
        println("Repairs Bought");
        for (int i=0; i<gameRef.players.size (); i++) {
          gameRef.players.get(i).getHealth().add(5);
        }
        Money -= 100;
      }
    }
  }
  class BuyShip implements Command {
    public void execute()
    {
      if (Money>=100) {
        println("Ship Bought");
        PC p;
        p = parsePC("enemy_basic.player");
        //PGraphics im = createGraphics(40,40);
        //im.beginDraw();
        //im.stroke(0,255,0);
        //im.fill(0,255,0);
        //im.triangle(0, 40, 20, 0, 40, 40);
        //im.endDraw();
        //p.setImage(im);
        p.setImageInd(gameRef.control.getImageInd());
        p.setImage(playerImages[p.getImageInd()]);
        p.moveTo(new PVector(gameRef.control.pos.x + random(-200, 200), 
        gameRef.control.pos.y + random(-200, 200)));
        p.projList = gameRef.playerProj;
        p.enemyList = gameRef.enemies;
        gameRef.players.add(p);
        Money -= 100;
      }
    }
  }
}

