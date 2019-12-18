import 'package:svg_custom_painter/rendering/path_simplifier_node.dart';

import 'path_data_operations.dart';
import 'package:meta/meta.dart';
import '../utils.dart';
class PathData {
  const PathData(this.operations, {@required this.x, @required this.y});
  final List<PathOperation> operations;
  final double x;
  final double y;

  @override
  int get hashCode => y.hashCode+x.hashCode+operations.hashCode;

  @override
  String toString() {
    return operations.map((PathOperation o)=>o.toString()).reduce((String s1, String s2)=>s1 + ' ' + s2);
  }

  static final PathSimplifierNode pathSimplifier = PathSimplifierNode();
  static PathData lerp(PathData a, PathData b, double t) {
    assert(a != null);
    assert(b != null);
    assert(t != null);
    bool isSimple(PathOperation o) => o is CubicBezier || o is Move || o is Close;
    // Needed so the lists are growable.
    List<PathOperation> aOps = List.from(a.operations);
    List<PathOperation> bOps = List.from(b.operations);
    if (!(aOps.every(isSimple) && bOps.every(isSimple))) {
      // Simplify using an PathSimplifierNode
      aOps = pathSimplifier.simplify(aOps);
      bOps = pathSimplifier.simplify(bOps);
    }
    if (aOps.length != bOps.length) {
      // Add dummy cubics at the start. This does NOT result in the best possible morph!
      // Probably inserting these at random indexes will look better.
      // Inserting at regular intervals wil look even better prob.
      // TODO: Experiment with these
      final int diff = (aOps.length - bOps.length).abs();
      PathOperation genCubics(PathOperation first) => CubicBezier(alias: 'C', x1: first.x, y1: first.y, x2: first.x, y2: first.y, x: first.x, y: first.y);
      if (aOps.length > bOps.length) {
        final PathOperation first = bOps.first;
        bOps.insertAll(1, Iterable.generate(diff, (int i)=>genCubics(first)));
      } else {
        final PathOperation first = aOps.first;
        aOps.insertAll(1, Iterable.generate(diff, (int i)=>genCubics(first)));
      }
    }

    List<PathOperation> lerp = [];
    for (int i = 0; i < aOps.length; i++) {
      final PathOperation o1 = aOps[i];
      final PathOperation o2 = bOps[i];
      PathOperation result;
      assert(o1.runtimeType == o2.runtimeType);
      if (o1 is Move)
        result = Move.lerp(o1, o2, t);
      if (o1 is Close)
        result = Close.lerp(o1, o2, t);
      if (o1 is CubicBezier)
        result = CubicBezier.lerp(o1, o2, t);
      lerp.add(result);
    }
    return PathData(lerp, x: lerpDouble(a.x, b.x, t), y: lerpDouble(a.y, b.y, t));
}
}
