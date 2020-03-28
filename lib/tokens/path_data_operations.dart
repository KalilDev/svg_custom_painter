import '../utils.dart';
import 'package:meta/meta.dart';

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

@immutable
abstract class PathOperation {
  const PathOperation({this.x, this.y, this.alias});
  final num x, y;
  final String alias;

  @override
  String toString() => alias + ' ' + x.toString() + ' ' + y.toString();

  @override
  operator ==(other) {
    if (runtimeType == other.runtimeType) {
      final PathOperation o = other as PathOperation;
      return x == o.x && y == o.y && alias == o.alias;
    }
    return false;
  }

  @override
  int get hashCode => x.hashCode + y.hashCode + alias.hashCode + runtimeType.hashCode;

  bool get isAbsolute => alias.toUpperCase() == alias;
}

class Move extends PathOperation {
  const Move({
    String alias,
    num x, y
  }) : super(alias: alias, x: x, y: y);

  static Move lerp(Move a, Move b, double t) {
    assert(a != null);
    assert(b != null);
    assert(t != null);
    return Move(alias: a.alias,
        x: lerpDouble(a.x, b.x, t),
        y: lerpDouble(a.y, b.y, t));
  }
}

class Close extends PathOperation {
  const Close() : super(alias: "Z");

  @override
  String toString() => alias;

  static Close lerp(Close a, Close b, double t) {
    assert(a != null);
    assert(b != null);
    assert(t != null);
    return a;
  }
}

class Line extends PathOperation {
  const Line({
    String alias,
    num x, y
  }) : super(alias: alias, x: x, y: y);

  static Line lerp(Line a, Line b, double t) {
    assert(a != null);
    assert(b != null);
    assert(t != null);
    return Line(alias: a.alias,
        x: lerpDouble(a.x, b.x, t),
        y: lerpDouble(a.y, b.y, t));
  }
}

class HorizontalLine extends Line {
  const HorizontalLine({
    String alias,
    num x,
  }) : super(alias: alias, x: x, y: 0);

  @override
  String toString() => alias + ' ' + x.toString();

  static HorizontalLine lerp(VerticalLine a, VerticalLine b, double t) {
    assert(a != null);
    assert(b != null);
    assert(t != null);
    return HorizontalLine(
        alias: a.alias, x: lerpDouble(a.x, b.x, t));
  }
}

class VerticalLine extends Line {
  const VerticalLine({
    String alias,
    num y,
  }) : super(alias: alias, x: 0, y: y);

  @override
  String toString() => alias + ' ' + y.toString();

  static VerticalLine lerp(VerticalLine a, VerticalLine b, double t) {
    assert(a != null);
    assert(b != null);
    assert(t != null);
    return VerticalLine(alias: a.alias, y: lerpDouble(a.y, b.y, t));
  }
}

class CubicBezier extends PathOperation {
  const CubicBezier({
    String alias,
    this.x1,
    this.y1,
    this.x2,
    this.y2,
    num x, y
  }) : super(alias: alias, x: x, y: y);

  final num x1, y1;
  final num x2, y2;

  @override
  String toString() => alias + ' ' + x1.toString() + ' ' + y1.toString() + ' ' + x2.toString() + ' ' + y2.toString() +' ' + x.toString() + ' ' + y.toString();

  @override
  operator ==(other) {
    if (runtimeType == other.runtimeType) {
      final CubicBezier o = other as CubicBezier;
      return x == o.x && y == o.y && x1 == o.x1 && y1 == o.y1 && x2 == o.x2 && y2 == o.y2 && alias == o.alias;
    }
    return false;
  }

  @override
  int get hashCode => super.hashCode + x1.hashCode + y1.hashCode + x2.hashCode + y2.hashCode;

  static CubicBezier lerp(CubicBezier a, CubicBezier b, double t) {
    assert(a != null);
    assert(b != null);
    assert(t != null);
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
  const SmoothCubicBezier({
    String alias,
    this.x2,
    this.y2,
    num x, y
  }) : super(alias: alias, x: x, y: y);

  final num x2, y2;

  @override
  String toString() => alias + ' ' + x2.toString() + ' ' + y2.toString() + ' ' + x.toString() + ' ' + y.toString();

  @override
  operator ==(other) {
    if (runtimeType == other.runtimeType) {
      final SmoothCubicBezier o = other as SmoothCubicBezier;
      return x == o.x && y == o.y && x2 == o.x2 && y2 == o.y2 && alias == o.alias;
    }
    return false;
  }

  @override
  int get hashCode => super.hashCode + x2.hashCode + y2.hashCode;

  static SmoothCubicBezier lerp(
      SmoothCubicBezier a, SmoothCubicBezier b, double t) {
    assert(a != null);
    assert(b != null);
    assert(t != null);
    return SmoothCubicBezier(
        alias: a.alias,
        x2: lerpDouble(a.x2, b.x2, t),
        y2: lerpDouble(a.y2, b.y2, t),
        x: lerpDouble(a.x, b.x, t),
        y: lerpDouble(a.y, b.y, t));
  }
}

class QuadraticBezier extends PathOperation {
  const QuadraticBezier({
    String alias,
    this.x1,
    this.y1,
    num x, y
  }) : super(alias: alias, x: x, y: y);

  final num x1, y1;

  @override
  String toString() => alias + ' ' + x1.toString() + ' ' + y1.toString() + ' ' + x.toString() + ' ' + y.toString();

  @override
  operator ==(other) {
    if (runtimeType == other.runtimeType) {
      final QuadraticBezier o = other as QuadraticBezier;
      return x == o.x && y == o.y && x1 == o.x1 && y1 == o.y1 && alias == o.alias;
    }
    return false;
  }

  @override
  int get hashCode => super.hashCode + x1.hashCode + y1.hashCode;

  static QuadraticBezier lerp(QuadraticBezier a, QuadraticBezier b, double t) {
    assert(a != null);
    assert(b != null);
    assert(t != null);
    return QuadraticBezier(
        alias: a.alias,
        x1: lerpDouble(a.x1, b.x1, t),
        y1: lerpDouble(a.y1, b.y1, t),
        x: lerpDouble(a.x, b.x, t),
        y: lerpDouble(a.y, b.y, t));
  }
}

class SmoothQuadraticBezier extends PathOperation {
  const SmoothQuadraticBezier({
    String alias,
    num x, y
  }) : super(alias: alias, x: x, y: y);

  static SmoothQuadraticBezier lerp(
      SmoothQuadraticBezier a, SmoothQuadraticBezier b, double t) {
    assert(a != null);
    assert(b != null);
    assert(t != null);
    return SmoothQuadraticBezier(
        alias: a.alias,
        x: lerpDouble(a.x, b.x, t),
        y: lerpDouble(a.y, b.y, t));
  }
}

class Arc extends PathOperation {
  const Arc({
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

  @override
  String toString() => alias + ' ' + rx.toString() + ' ' + ry.toString() + ' ' + rotation.toString() + ' ' + largeArcFlag.toString() +' ' + sweepFlag.toString() + ' ' + x.toString() + ' ' + y.toString();

  @override
  operator ==(other) {
    if (runtimeType == other.runtimeType) {
      final Arc o = other as Arc;
      return x == o.x && y == o.y && rx == o.rx && ry == o.ry && rotation == o.rotation && largeArcFlag == o.largeArcFlag && sweepFlag == o.sweepFlag && alias == o.alias;
    }
    return false;
  }

  @override
  int get hashCode => super.hashCode + rx.hashCode + ry.hashCode + rotation.hashCode + largeArcFlag.hashCode + sweepFlag.hashCode;

  static Arc lerp(Arc a, Arc b, double t) {
    assert(a != null);
    assert(b != null);
    assert(t != null);
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
