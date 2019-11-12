import '../tokens/path_data_operations.dart';
import 'package:vector_math/vector_math_64.dart';

Vector2 reflectControlPoint(Vector2 controlPoint,Vector2 currentPos) {
  final Vector2 relC = controlPoint; // Relative vector for controlPoint
  final bool isVert = relC.x > 0; // x axis reflection
  final Vector2 relativeC1 = isVert ? Vector2(- relC.x,relC.y) : Vector2(relC.x, -relC.y);
  return currentPos + relativeC1;
}

abstract class RenderingNode {
  Vector2 currentPos;
  Vector2 lastControlPoint;
  void renderOp(PathOperation op) {
    print(op.runtimeType);
    switch (op.runtimeType) {
      case Move: renderMove(op);break;
      case Close: renderClose();break;
      case Line: renderLine(op);break;
      case CubicBezier: renderCubic(op);break;
      case SmoothCubicBezier: renderCubic(calcSmoothCubic(op));break;
      case QuadraticBezier: renderQuad(op);break;
      case SmoothQuadraticBezier: renderQuad(calcSmoothQuad(op));break;
      case Arc: renderArc(op);break;
    }
  }

  CubicBezier calcSmoothCubic(SmoothCubicBezier s) {
  return CubicBezier(alias: s.alias, control1: reflectControlPoint(s.control2, currentPos),control2: s.control2, end: s.point);
  }

  QuadraticBezier calcSmoothQuad(SmoothQuadraticBezier s) {
  return QuadraticBezier(alias: s.alias,end: s.point,control: reflectControlPoint(lastControlPoint, currentPos));
  }

  void renderMove(Move m);
  void renderClose();
  void renderLine(Line l);
  void renderCubic(CubicBezier c);
  void renderQuad(QuadraticBezier q);
  void renderArc(Arc a);
}