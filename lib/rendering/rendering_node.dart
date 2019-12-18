import 'package:svg_custom_painter/rendering/arc_to_cubic.dart';
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
    if (op is Move) {renderMove(op); c1x = null; c1y = null;}
    if (op is Close) {renderClose(); c1x = null; c1y = null;}
    if (op is Line) {renderLine(op); c1x = null; c1y = null;}
    if (op is CubicBezier) {renderCubic(op); c1x = op.x2; c1y = op.y2;}
    if (op is SmoothCubicBezier) {renderCubic(_calcSmoothCubic(op));}
    if (op is QuadraticBezier) {renderQuad(op); c1x = op.x1; c1y = op.y1;}
    if (op is SmoothQuadraticBezier) {renderQuad(_calcSmoothQuad(op));}
    if (op is Arc) {renderArc(op); c1x = null; c1y = null;}
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