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
const Map<String, int> charArgCountMap = {
  'm': 2,
  'z': 0,
  'l': 2,
  'h': 1,
  'v': 1,
  'c': 6,
  's': 4,
  'q': 4,
  't': 2,
  'a': 7
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
  PathOperation({this.x, this.y, this.alias});
  final num x, y;
  final String alias;

  bool get isAbsolute => alias.toUpperCase() == alias;
}

class Move extends PathOperation {
  Move({
    String alias,
    num x, y
  }) : super(alias: alias, x: x, y: y);

  static Move lerp(Move a, Move b, double t) {
    assert(a != null);
    assert(b != null);
    assert(t != null);
    assert(a.alias == b.alias);
    return Move(alias: a.alias,
        x: lerpDouble(a.x, b.x, t),
        y: lerpDouble(a.y, b.y, t));
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
    num x, y
  }) : super(alias: alias, x: x, y: y);

  static Line lerp(Line a, Line b, double t) {
    assert(a != null);
    assert(b != null);
    assert(t != null);
    assert(a.alias == b.alias);
    return Line(alias: a.alias,
        x: lerpDouble(a.x, b.x, t),
        y: lerpDouble(a.y, b.y, t));
  }
}

class HorizontalLine extends Line {
  HorizontalLine({
    String alias,
    num x,
  }) : super(alias: alias, x: x, y: 0);

  static HorizontalLine lerp(VerticalLine a, VerticalLine b, double t) {
    assert(a != null);
    assert(b != null);
    assert(t != null);
    assert(a.alias == b.alias);
    return HorizontalLine(
        alias: a.alias, x: lerpDouble(a.x, b.x, t));
  }
}

class VerticalLine extends Line {
  VerticalLine({
    String alias,
    num y,
  }) : super(alias: alias, x: 0, y: y);

  static VerticalLine lerp(VerticalLine a, VerticalLine b, double t) {
    assert(a != null);
    assert(b != null);
    assert(t != null);
    assert(a.alias == b.alias);
    return VerticalLine(alias: a.alias, y: lerpDouble(a.y, b.y, t));
  }
}

class CubicBezier extends PathOperation {
  CubicBezier({
    String alias,
    this.x1,
    this.y1,
    this.x2,
    this.y2,
    num x, y
  }) : super(alias: alias, x: x, y: y);

  final num x1, y1;
  final num x2, y2;

  static CubicBezier lerp(CubicBezier a, CubicBezier b, double t) {
    assert(a != null);
    assert(b != null);
    assert(t != null);
    assert(a.alias == b.alias);
    return CubicBezier(
        alias: a.alias,
        x1: lerpDouble(a.x1, b.x1, t),
        y1: lerpDouble(a.y1, b.y1, t),
        x2: lerpDouble(a.x2, b.x2, t),
        y2: lerpDouble(a.y2, b.y2, t),
        x: lerpDouble(a.x, b.x, t),
        y: lerpDouble(a.y, b.y, t));
  }
}

class SmoothCubicBezier extends PathOperation {
  SmoothCubicBezier({
    String alias,
    this.x2,
    this.y2,
    num x, y
  }) : super(alias: alias, x: x, y: y);

  final num x2, y2;

  static SmoothCubicBezier lerp(
      SmoothCubicBezier a, SmoothCubicBezier b, double t) {
    assert(a != null);
    assert(b != null);
    assert(t != null);
    assert(a.alias == b.alias);
    return SmoothCubicBezier(
        alias: a.alias,
        x2: lerpDouble(a.x2, b.x2, t),
        y2: lerpDouble(a.y2, b.y2, t),
        x: lerpDouble(a.x, b.x, t),
        y: lerpDouble(a.y, b.y, t));
  }
}

class QuadraticBezier extends PathOperation {
  QuadraticBezier({
    String alias,
    this.x1,
    this.y1,
    num x, y
  }) : super(alias: alias, x: x, y: y);

  final num x1, y1;

  static QuadraticBezier lerp(QuadraticBezier a, QuadraticBezier b, double t) {
    assert(a != null);
    assert(b != null);
    assert(t != null);
    assert(a.alias == b.alias);
    return QuadraticBezier(
        alias: a.alias,
        x1: lerpDouble(a.x1, b.x1, t),
        y1: lerpDouble(a.y1, b.y1, t),
        x: lerpDouble(a.x, b.x, t),
        y: lerpDouble(a.y, b.y, t));
  }
}

class SmoothQuadraticBezier extends PathOperation {
  SmoothQuadraticBezier({
    String alias,
    num x, y
  }) : super(alias: alias, x: x, y: y);

  static SmoothQuadraticBezier lerp(
      SmoothQuadraticBezier a, SmoothQuadraticBezier b, double t) {
    assert(a != null);
    assert(b != null);
    assert(t != null);
    assert(a.alias == b.alias);
    return SmoothQuadraticBezier(
        alias: a.alias,
        x: lerpDouble(a.x, b.x, t),
        y: lerpDouble(a.y, b.y, t));
  }
}

class Arc extends PathOperation {
  Arc({
    String alias,
    this.rx,
    this.ry,
    this.rotation,
    this.largeArcFlag,
    this.sweepFlag,
    num x, y
  }) : super(alias: alias, x: x, y: y);

  final num rx, ry;
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
        rx: lerpDouble(a.rx, b.rx, t),
        ry: lerpDouble(a.ry, b.ry, t),
        rotation: lerpDouble(a.rotation, b.rotation, t),
        largeArcFlag: lerpBool(a.largeArcFlag, b.largeArcFlag, t),
        sweepFlag: lerpBool(a.sweepFlag, b.sweepFlag, t),
        x: lerpDouble(a.x, b.x, t),
        y: lerpDouble(a.y, b.y, t));
  }
}
