import 'package:svg_custom_painter/tokens/path_data.dart';
import 'package:svg_custom_painter/tokens/path_data_operations.dart';

import 'rendering_node.dart';

class StaticCodeGenerator extends RenderingNode {
  List<String> ops;

  @override
  void renderArc(Arc a) {
    ops.add('Arc(alias: ' + "'" + a.alias + "'" + ', rx: ' + a.rx.toString() + ', ry: ' + a.ry.toString() + ', rotation: ' + a.rotation.toString() + ', largeArcFlag: ' + a.largeArcFlag.toString() + ', sweepFlag: ' + a.sweepFlag.toString() + ', x: ' + a.x.toString() + ', y: ' + a.y.toString() + ')');
  }

  @override
  void renderClose() {
    ops.add('Close()');
  }

  @override
  void renderCubic(CubicBezier c) {
    ops.add('CubicBezier(alias: ' + "'" + c.alias + "'" + ', x1: ' + c.x1.toString() + ', y1: ' + c.y1.toString() + ', x2: ' + c.x2.toString() + ', y2: ' + c.y2.toString() + ', x: ' + c.x.toString() + ', y: ' + c.y.toString() + ')');
  }

  @override
  void renderLine(Line l) {
    ops.add('Line(alias: ' + "'" + l.alias + "'" + ', x: ' + l.x.toString() + ', y: ' + l.y.toString() + ')');
  }

  @override
  void renderMove(Move m) {
    ops.add('Move(alias: ' + "'" + m.alias + "'" + ', x: ' + m.x.toString() + ', y: ' + m.y.toString() + ')');
  }

  @override
  void renderQuad(QuadraticBezier q) {
    ops.add('CubicBezier(alias: ' + "'" + q.alias + "'" + ', x1: ' + q.x1.toString() + ', y1: ' + q.y1.toString() + ', x: ' + q.x.toString() + ', y: ' + q.y.toString() + ')');
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