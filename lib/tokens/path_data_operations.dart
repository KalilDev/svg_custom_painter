import 'package:vector_math/vector_math_64.dart';
import '../utils.dart';

const Map<String, Type> charTypeMap = {
  'm': Move,
  'z': Close,
  'l': Line,
  'h': HorizontalLine,
  'v': VerticalLine,
  'c': CubicBezier,
  's': SmoothCubicBezier,
  'q': QuadraticBezier,
  't': SmoothQuadraticBezier,
  'a': Arc
};

const Map<Type, int> typeArgCountMap = {
  Move: 2,
  Close: 0,
  Line: 2,
  HorizontalLine: 1,
  VerticalLine: 1,
  CubicBezier: 6,
  SmoothCubicBezier: 4,
  QuadraticBezier: 4,
  SmoothQuadraticBezier: 2,
  Arc: 7
};

abstract class PathOperation {
  PathOperation({this.point, this.alias});
  final Vector2 point;
  final String alias;

  bool get isAbsolute => alias.toUpperCase() == alias;
}

class Move extends PathOperation {
  Move({
    String alias,
    Vector2 start,
  }) : super(alias: alias, point: start);

  static Move lerp(Move a, Move b, double t) {
    assert(a != null);
    assert(b != null);
    assert(t != null);
    assert(a.alias == b.alias);
    return Move(alias: a.alias, start: lerpVector2(a.point, b.point, t));
  }
}

class Close extends PathOperation {
  static Close lerp(Close a, Close b, double t) {
    assert(a != null);
    assert(b != null);
    assert(t != null);
    assert(a.alias == b.alias);
    return a;
  }
}

class Line extends PathOperation {
  Line({
    String alias,
    Vector2 point,
  }) : super(alias: alias, point: point);

  static Line lerp(Line a, Line b, double t) {
    assert(a != null);
    assert(b != null);
    assert(t != null);
    assert(a.alias == b.alias);
    return Line(alias: a.alias, point: lerpVector2(a.point, b.point, t));
  }
}

class HorizontalLine extends Line {
  HorizontalLine({
    String alias,
    num x,
  }) : super(alias: alias, point: Vector2(x, 0));

  static HorizontalLine lerp(VerticalLine a, VerticalLine b, double t) {
    assert(a != null);
    assert(b != null);
    assert(t != null);
    assert(a.alias == b.alias);
    return HorizontalLine(
        alias: a.alias, x: lerpDouble(a.point.x, b.point.x, t));
  }
}

class VerticalLine extends Line {
  VerticalLine({
    String alias,
    num y,
  }) : super(alias: alias, point: Vector2(0, y));

  static VerticalLine lerp(VerticalLine a, VerticalLine b, double t) {
    assert(a != null);
    assert(b != null);
    assert(t != null);
    assert(a.alias == b.alias);
    return VerticalLine(alias: a.alias, y: lerpDouble(a.point.y, b.point.y, t));
  }
}

class CubicBezier extends PathOperation {
  CubicBezier({
    String alias,
    this.control1,
    this.control2,
    Vector2 end,
  }) : super(alias: alias, point: end);

  final Vector2 control1;
  final Vector2 control2;

  static CubicBezier lerp(CubicBezier a, CubicBezier b, double t) {
    assert(a != null);
    assert(b != null);
    assert(t != null);
    assert(a.alias == b.alias);
    return CubicBezier(
        alias: a.alias,
        control1: lerpVector2(a.control1, b.control1, t),
        control2: lerpVector2(a.control2, b.control2, t),
        end: lerpVector2(a.point, b.point, t));
  }
}

class SmoothCubicBezier extends PathOperation {
  SmoothCubicBezier({
    String alias,
    this.control2,
    Vector2 end,
  }) : super(alias: alias, point: end);

  final Vector2 control2;

  static SmoothCubicBezier lerp(
      SmoothCubicBezier a, SmoothCubicBezier b, double t) {
    assert(a != null);
    assert(b != null);
    assert(t != null);
    assert(a.alias == b.alias);
    return SmoothCubicBezier(
        alias: a.alias,
        control2: lerpVector2(a.control2, b.control2, t),
        end: lerpVector2(a.point, b.point, t));
  }
}

class QuadraticBezier extends PathOperation {
  QuadraticBezier({
    String alias,
    this.control,
    Vector2 end,
  }) : super(alias: alias, point: end);

  final Vector2 control;

  static QuadraticBezier lerp(QuadraticBezier a, QuadraticBezier b, double t) {
    assert(a != null);
    assert(b != null);
    assert(t != null);
    assert(a.alias == b.alias);
    return QuadraticBezier(
        alias: a.alias,
        control: lerpVector2(a.control, b.control, t),
        end: lerpVector2(a.point, b.point, t));
  }
}

class SmoothQuadraticBezier extends PathOperation {
  SmoothQuadraticBezier({
    String alias,
    Vector2 end,
  }) : super(alias: alias, point: end);

  static SmoothQuadraticBezier lerp(
      SmoothQuadraticBezier a, SmoothQuadraticBezier b, double t) {
    assert(a != null);
    assert(b != null);
    assert(t != null);
    assert(a.alias == b.alias);
    return SmoothQuadraticBezier(
        alias: a.alias, end: lerpVector2(a.point, b.point, t));
  }
}

class Arc extends PathOperation {
  Arc({
    String alias,
    this.radius,
    this.rotation,
    this.largeArcFlag,
    this.sweepFlag,
    Vector2 end,
  }) : super(alias: alias, point: end);

  final Vector2 radius;
  final double rotation; // Degrees
  final bool largeArcFlag;
  final bool sweepFlag;

  static Arc lerp(Arc a, Arc b, double t) {
    assert(a != null);
    assert(b != null);
    assert(t != null);
    assert(a.alias == b.alias);
    return Arc(
        alias: a.alias,
        radius: lerpVector2(a.radius, b.radius, t),
        rotation: lerpDouble(a.rotation, b.rotation, t),
        largeArcFlag: lerpBool(a.largeArcFlag, b.largeArcFlag, t),
        sweepFlag: lerpBool(a.sweepFlag, b.sweepFlag, t),
        end: lerpVector2(a.point, b.point, t));
  }
}
