

import 'dart:html';
import 'dart:math';
import 'dart:async';

class Keyboard {
  Map<int, int> _keys = new Map<int, int>();

  Keyboard() {
    window.onKeyDown.listen((KeyboardEvent e) {
      // If the key is not set yet, set it with a timestamp.
      if (!_keys.containsKey(e.keyCode))
        _keys[e.keyCode] = e.timeStamp;
    });

    window.onKeyUp.listen((KeyboardEvent e) {
      _keys.remove(e.keyCode);
    });
  }

  /**
   * Check if the given key code is pressed. You should use the [KeyCode] class.
   */
  isPressed(int keyCode) => _keys.containsKey(keyCode);
}

class Snakepart{
  num x = 0, y=0;
  Snakepart(this.x,this.y);
  Snakepart.zero() : x = 0, y = 0;
}

class Snake {
  var keyboard = new Keyboard();
  int x,y,points=0,del, width, height;
  String direction;
  bool get;
  CanvasRenderingContext2D ctx;
  var snakepart = new List<Snakepart>();
  var food = new Snakepart.zero();

  var startButton = query('#start');

  Snake(this.ctx,this.width,this.height){

    for(int i=0; i<5; i++)
    {
      snakepart.add(new Snakepart((width/2)+(10*i),(height/2)));
    }
    points = 0;
    del = 80;
    get = false;
    direction = 'l';

// SDL draw rect edges of the game
    drawRect(0,0,width, 10,"black");
    drawRect(0,10,10, height,"black");
    drawRect(10,height-10, width-10, 10,"black");
    drawRect(width-10,10,10, height-20,"black");

    putfood();
    for(var i in snakepart)
    {
      drawSnake(i.x,i.y);
    }













    /*  ============================================================== */
  } // constructor end

  void drawRect(var x,var y,var w,var h,String color){
    ctx.fillStyle = color;
    ctx.fillRect(x,y,w,h);

  }
  void drawSnake(double x,double y){
    ctx. fillStyle = "blue";
    ctx.fillRect(x,y,10,10);
    print("drawrect 2 with $x, $y");
  }
  int getRandomInt(var min, var max){
    var rd = new Random();
    var tmpr =  min + rd.nextInt(max - min);
    return ((tmpr/10).floor()) * 10; // floor() faster than round()
  }
  void putfood(){
    while(true){
      var foodtmpx = getRandomInt(10, width-20);
      var foodtmpy = getRandomInt(10,height-20);
      print(foodtmpx);
      print(foodtmpy);
      for(var k =0; k< snakepart.length; k++){
        if(snakepart[k].x==foodtmpx && snakepart[k].y == foodtmpy){
          continue;
        }
      }
      food.x = foodtmpx;
      food.y = foodtmpy;

      break;
    }
    drawRect(food.x,food.y,10,10,'orange');
  }
  // collison detection
  bool collision(){
    if(snakepart[0].x==0 || snakepart[0].x==width || snakepart[0].y==0 || snakepart[0].y==height){
      return true;
    }
    //collision with itself
    for(var i=2; i<snakepart.length; i++){
      if(snakepart[0].x==snakepart[i].x && snakepart[0].y==snakepart[i].y){
        return true;
      }
    }
    //collsion with food
    if(snakepart[0].x == food.x && snakepart[0].y == food.y){
      get = true;
      // put another food
      putfood();
      points+=10;
      //speed up game
      //pts.innerHTML = this.points;


    }else{
      get = false;
    }

    return false;
  }
  void movesnake(){
    if(!get){
      drawRect(snakepart[snakepart.length-1].x,snakepart[snakepart.length-1].y,10,10,"white");
      snakepart.removeLast();
    }

    if(direction == 'l'){
      var tmpx = snakepart[0].x;
      var tmpy = snakepart[0].y;
      snakepart.insert(0, new Snakepart(tmpx-10,tmpy));
    }
    else if(direction == 'r'){
      snakepart.insert(0, new Snakepart(snakepart[0].x+10,snakepart[0].y));
    }
    else if(direction=='u'){
      snakepart.insert(0, new Snakepart(snakepart[0].x,snakepart[0].y-10));
    }
    else if(direction=='d'){
      snakepart.insert(0, new Snakepart(snakepart[0].x,snakepart[0].y+10));
    }
    else {
      print("direct is niether");
    }
    //now draw newly inserted one
    drawRect(snakepart[0].x,snakepart[0].y,10,10,'blue');
  }

  void initialize(){
    startButton.style.display = 'none';
    ctx.clearRect(0,0,width,height);
    direction = 'l';
    points = 0;


    snakepart.clear();
    for(int i=0; i<5; i++)
    {
      snakepart.add(new Snakepart((width/2)+(10*i),(height/2)));
    }

    //draw snake
    for(var i in snakepart)
    {
      drawSnake(i.x,i.y);
    }


    food = new Snakepart(300,100); // create food object
    putfood();

    //redraw edges
    drawRect(0,0,width, 10,"black");
    drawRect(0,10,10, height,"black");
    drawRect(10,height-10, width-10, 10,"black");
    drawRect(width-10,10,10, height-20,"black");
  }
  //////////////////////////////////////////////////
  void start(){
    initialize();
    const t = const Duration(milliseconds:200);
    new Timer.periodic(t, loop);


  }


  void loop(Timer timer){


    if(collision()){
      print("game over");
      startButton.style.display = 'block';
      timer.cancel();
     }
    movesnake();

    if (keyboard.isPressed(KeyCode.UP)){
      direction = direction == 'd' ? 'd' : 'u';
      print(direction);
    }
    if (keyboard.isPressed(KeyCode.DOWN)){
      direction = direction == 'u' ? 'u' : 'd';
      print(direction);
    }
    if (keyboard.isPressed(KeyCode.LEFT)){
      direction = direction == 'r' ? 'r' : 'l';
      print(direction);
    }
    if (keyboard.isPressed(KeyCode.RIGHT)){
      direction = direction == 'l' ? 'l' : 'r';
      print(direction);
    }


  }


} //end class


