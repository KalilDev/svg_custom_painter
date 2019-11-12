import 'dart:io';
import 'dart:math';
import 'package:svg_custom_painter/tokens/path_data.dart';
import 'package:svg_custom_painter/tokens/path_data_operations.dart';

import 'rendering_node.dart';

// Cant implement or extend because the arguments to the functions are different
class CustomPainterAnimatedCodeGenerator {
  CustomPainterAnimatedCodeGenerator(this.d1, this.d2);
  final String codeTemplate = File(Directory.current.path + "\\templates\\output\\AnimatedCustomPainter").readAsStringSync();
  List<String> currentCommands = [
    "    Path path = Path()"
  ];
  final PathData d1;
  final PathData d2;
  void renderOp(PathOperation o1, PathOperation o2) {
    switch (o1.runtimeType) {
      case Move: renderMove(o1,o2);break;
      case Close: renderClose();break;
      case Line: renderLine(o1,o2);break;
      case CubicBezier: renderCubic(o1,o2);break;
      //case SmoothCubicBezier: renderCubic(calcSmoothCubic(op));break;
      case QuadraticBezier: renderQuad(o1,o2);break;
      //case SmoothQuadraticBezier: renderQuad(calcSmoothQuad(op));break;
      case Arc: renderArc(o1,o2);break;
    }
  }

  String lerp(double d1, double d2) {
    return 'lerpDouble(${d1}, ${d2}, t)';
  }
  String lerpBool(bool d1, bool d2) {
    return 'lerpBool(${d1}, ${d2}, t)';
  }

  void renderMove(Move m1, Move m2) {
    currentCommands.add("..moveTo(scale * ${lerp(m1.point.x,m2.point.x)}, scale * ${lerp(m1.point.y,m2.point.y)})");
    //currentPos = m.point;
    //lastControlPoint = null;
  }
  void renderClose() {
    currentCommands.add("..close();");
    currentCommands.add("canvas.drawPath(path, paint);");
    //currentPos = null;
    //lastControlPoint = null;
  }
  void renderLine(Line l1, Line l2) {
    currentCommands.add("..lineTo(scale * ${lerp(l1.point.x,l2.point.x)}, scale * ${lerp(l1.point.y,l2.point.y)});");
    //currentPos = l.point;
    //lastControlPoint = null;
  }
  void renderCubic(CubicBezier c1, CubicBezier c2) {
    currentCommands.add("..cubicTo(scale * ${lerp(c1.control1.x,c2.control1.x)}, scale * ${lerp(c1.control1.y, c2.control1.y)}, scale * ${lerp(c1.control2.x,c2.control2.x)}, scale * ${lerp(c1.control2.y,c2.control2.y)}, scale * ${lerp(c1.point.x,c2.point.x)}, scale * ${lerp(c1.point.y,c2.point.y)})");
    //currentPos = c.point;
    //lastControlPoint = c.control2;
  }
  void renderQuad(QuadraticBezier q1, QuadraticBezier q2) {
    currentCommands.add("..quadraticBezierTo(scale * ${lerp(q1.control.x,q2.control.x)}, scale * ${lerp(q1.control.y,q2.control.y)}, scale * ${lerp(q1.point.x,q2.point.x)}, scale * ${lerp(q1.point.y,q2.point.y)})");
    //currentPos = q.point;
    //lastControlPoint = q.control;
  }
  void renderArc(Arc a1, Arc a2) {
    currentCommands.add("..arcToPoint(Offset(scale * ${lerp(a1.point.x,a2.point.x)},scale * ${lerp(a1.point.y,a2.point.y)}),rotation: ${lerp((a1.rotation/180)*pi, (a2.rotation/180)*pi)},largeArc: ${lerpBool(a1.largeArcFlag, a2.largeArcFlag)},clockwise: ${lerpBool(a1.sweepFlag, a2.sweepFlag)})");
    //currentPos = a.point;
    //lastControlPoint = null;
  }

  String getCommands() {
    final i1 = d1.operations.iterator;
    final i2 = d2.operations.iterator;
    while (i1.moveNext() && i2.moveNext()) {
      final o1 = i1.current;
      final o2 = i2.current;
      renderOp(o1,o2);
    }
    return currentCommands.reduce((String s0, String s1)=>s0+'\n    ' + (s1.startsWith('..') ? '    ': '')+s1);
  }

  String getFile({String name = 'PathPainter', String color = '0xFF000000'}) {
    return codeTemplate.replaceAll('{name}', name).replaceAll('{color}', color).replaceAll('{commands}', getCommands());
  }

}