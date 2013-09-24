
import 'dart:html';
import 'snake.dart';

void main() {
  CanvasElement canvas = query("#area");
  print ("hello world");

  var ctx = canvas.getContext("2d");
  int width = canvas.width;
  int height = canvas.height;
  var s = new Snake(ctx,width,height);
  s.start();

}


