import 'dart:io';
import 'dart:math';
import 'package:svg_custom_painter/tokens/path_data.dart';
import 'package:svg_custom_painter/tokens/path_data_operations.dart';

import 'rendering_node.dart';

class CustomPainterCodeGenerator extends RenderingNode {
  CustomPainterCodeGenerator(this.data);
  final String codeTemplate = File(Directory.current.path + "\\templates\\output\\CustomPainter").readAsStringSync();
  List<String> currentCommands = [
    "    Path path = Path()"
  ];
  final PathData data;
  void renderMove(Move m) {
    currentCommands.add("..moveTo(scale * ${m.x}, scale * ${m.y})");
  }
  void renderClose() {
    currentCommands.add("..close();");
    currentCommands.add("canvas.drawPath(path, paint);");
  }
  void renderLine(Line l) {
    currentCommands.add("..lineTo(scale * ${l.x}, scale * ${l.y});");
  }
  void renderCubic(CubicBezier c) {
    currentCommands.add("..cubicTo(scale * ${c.x1}, scale * ${c.y1}, scale * ${c.x2}, scale * ${c.y2}, scale * ${c.x}, scale * ${c.y})");
  }
  void renderQuad(QuadraticBezier q) {
    currentCommands.add("..quadraticBezierTo(scale * ${q.x1}, scale * ${q.y1}, scale * ${q.x}, scale * ${q.y})");
  }
  void renderArc(Arc a) {
    currentCommands.add("..arcToPoint(Offset(scale * ${a.x},scale * ${a.y}),rotation: ${(a.rotation/180)*pi},largeArc: ${a.largeArcFlag},clockwise: ${a.sweepFlag})");
  }

  String getCommands() {
    data.operations.forEach((op)=>renderOp(op));
    return currentCommands.reduce((String s0, String s1)=>s0+'\n    ' + (s1.startsWith('..') ? '    ': '')+s1);
  }

  String getFile({String name = 'PathPainter', String color = '0xFF000000'}) {
    return codeTemplate.replaceAll('{name}', name).replaceAll('{color}', color).replaceAll('{commands}', getCommands());
  }

}