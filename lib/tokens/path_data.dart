import 'path_data_operations.dart';
import 'package:meta/meta.dart';
import '../utils.dart';

class PathData {
  const PathData(this.operations, {@required this.x, @required this.y});
  final List<PathOperation> operations;
  final double x;
  final double y;

  static PathData lerp(PathData a, PathData b, double t) {
    assert(a != null);
    assert(b != null);
    assert(t != null);
    assert(a.operations.length == b.operations.length);
    List<PathOperation> lerp = [];
    for (int i = 0; i < a.operations.length; i++) {
      final PathOperation o1 = a.operations[i];
      final PathOperation o2 = b.operations[i];
      PathOperation result;
      assert(o1.runtimeType == o2.runtimeType);
      switch (o1.runtimeType) {
        case Move:
          result = Move.lerp(o1, o2, t);
          break;
        case Close:
          result = Close.lerp(o1, o2, t);
          break;
        case Line:
          result = Line.lerp(o1, o2, t);
          break;
        case HorizontalLine:
          result = HorizontalLine.lerp(o1, o2, t);
          break;
        case VerticalLine:
          result = VerticalLine.lerp(o1, o2, t);
          break;
        case CubicBezier:
          result = CubicBezier.lerp(o1, o2, t);
          break;
        case SmoothCubicBezier:
          result = SmoothCubicBezier.lerp(o1, o2, t);
          break;
        case QuadraticBezier:
          result = QuadraticBezier.lerp(o1, o2, t);
          break;
        case SmoothQuadraticBezier:
          result = SmoothQuadraticBezier.lerp(o1, o2, t);
          break;
        case Arc:
          result = Arc.lerp(o1, o2, t);
          break;
      }
      lerp.add(result);
    }
    return PathData(lerp, x: lerpDouble(a.x, b.x, t), y: lerpDouble(a.y, b.y, t));
  }
}
