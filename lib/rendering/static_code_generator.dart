import 'package:svg_custom_painter/tokens/path_data.dart';
import 'package:svg_custom_painter/tokens/path_data_operations.dart';

import 'cubic_only_rendering_node.dart';

class StaticCodeGenerator extends CubicOnlyRenderingNode {
  List<String> ops;

  @override
  void renderClose() {
    ops.add('Close()');
  }

  @override
  void renderCubic(CubicBezier c) {
    ops.add('CubicBezier(x1: ' + c.x1.toString() + ', y1: ' + c.y1.toString() + ', x2: ' + c.x2.toString() + ', y2: ' + c.y2.toString() + ', x: ' + c.x.toString() + ', y: ' + c.y.toString() + ')');
  }

  @override
  void renderMove(Move m) {
    ops.add('Move(alias: ' + "'" + m.alias + "'" + ', x: ' + m.x.toString() + ', y: ' + m.y.toString() + ')');
  }

  String getOps(PathData data) {
    ops = [];
    for (PathOperation op in data.operations) {renderOp(op);}
    final Iterator<String> iter = ops.iterator;
    String result = 'PathData([\n';
    while (iter.moveNext()) {
      result += '\t' + iter.current + ',\n';
    }
    return result + ']);';
  }
  
}