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
    currentCommands.add("..moveTo(scale * ${m.point.x}, scale * ${m.point.y})");
    currentPos = m.point;
    lastControlPoint = null;
  }
  void renderClose() {
    currentCommands.add("..close();");
    currentCommands.add("canvas.drawPath(path, paint);");
    currentPos = null;
    lastControlPoint = null;
  }
  void renderLine(Line l) {
    currentCommands.add("..lineTo(scale * ${l.point.x}, scale * ${l.point.y});");
    currentPos = l.point;
    lastControlPoint = null;
  }
  void renderCubic(CubicBezier c) {
    currentCommands.add("..cubicTo(scale * ${c.control1.x}, scale * ${c.control1.y}, scale * ${c.control2.x}, scale * ${c.control2.y}, scale * ${c.point.x}, scale * ${c.point.y})");
    currentPos = c.point;
    lastControlPoint = c.control2;
  }
  void renderQuad(QuadraticBezier q) {
    currentCommands.add("..quadraticBezierTo(scale * ${q.control.x}, scale * ${q.control.y}, scale * ${q.point.x}, scale * ${q.point.y})");
    currentPos = q.point;
    lastControlPoint = q.control;
  }
  void renderArc(Arc a) {
    currentCommands.add("..arcToPoint(Offset(scale * ${a.point.x},scale * ${a.point.y}),rotation: ${(a.rotation/180)*pi},largeArc: ${a.largeArcFlag},clockwise: ${a.sweepFlag})");
    currentPos = a.point;
    lastControlPoint = null;
  }

  String getCommands() {
    data.operations.forEach((op)=>renderOp(op));
    return currentCommands.reduce((String s0, String s1)=>s0+'\n    ' + (s1.startsWith('..') ? '    ': '')+s1);
  }

  String getFile({String name = 'PathPainter', String color = '0xFF000000'}) {
    return codeTemplate.replaceAll('{name}', name).replaceAll('{color}', color).replaceAll('{commands}', getCommands());
  }

}