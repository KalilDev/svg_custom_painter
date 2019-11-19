import 'package:svg_custom_painter/tokens/path_data.dart';

import '../tokens/path_data_operations.dart';

List<num> reflectControlPoint(num x1,y1, num x,y) {
  final bool isVert = x1 > 0; // x axis reflection
  final num relX = isVert ? - x1 : x1;
  final num relY = isVert ? y1 : -y1;
  return [x+relX,y+relY];
}

abstract class RenderingNode {
  num cx,cy; // Current coordinates
  num c1x,c1y; // Last control points
  void renderOp(PathOperation op) {
    cx = op.x;
    cy = op.y;
    switch (op.runtimeType) {
      case Move: renderMove(op); c1x = null; c1y = null;break;
      case Close: renderClose(); c1x = null; c1y = null;break;
      case Line: renderLine(op); c1x = null; c1y = null;break;
      case CubicBezier: renderCubic(op); c1x = (op as CubicBezier).x2; c1y = (op as CubicBezier).y2;break;
      case SmoothCubicBezier: renderCubic(_calcSmoothCubic(op));break; // c1x and c1y on calcSmoothCubic
      case QuadraticBezier: renderQuad(op); c1x = (op as QuadraticBezier).x1; c1y = (op as QuadraticBezier).y1;break;
      case SmoothQuadraticBezier: renderQuad(_calcSmoothQuad(op));break; // c1x and c1y on calcSmoothQuad
      case Arc: renderArc(op); c1x = null; c1y = null;break;
    }
  }

  CubicBezier _calcSmoothCubic(SmoothCubicBezier s) { // Depends on the internal state, otherwise the user would have to reimplement c1x and c1y everytime
  final List<num> calc = reflectControlPoint(s.x2,s.y2, cx,cy);
  c1x = s.x2;
  c1y = s.y2;
  return CubicBezier(alias: s.alias, x1: calc[0],y1: calc[1],x2: s.x2,y2:s.x2, x: s.x,y:s.y);
  }

  QuadraticBezier _calcSmoothQuad(SmoothQuadraticBezier s) { // Same as above
  final List<num> calc = reflectControlPoint(c1x,c1y, cx,cy);
  c1x = calc[0];
  c1y = calc[1];
  return QuadraticBezier(alias: s.alias, x1: calc[0],y1: calc[1], x: s.x,y:s.y);
  }

  void renderMove(Move m);
  void renderClose();
  void renderLine(Line l);
  void renderCubic(CubicBezier c);
  void renderQuad(QuadraticBezier q);
  void renderArc(Arc a);
}