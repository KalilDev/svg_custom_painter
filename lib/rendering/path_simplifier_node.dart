import 'package:svg_custom_painter/tokens/path_data_operations.dart';
import 'cubic_only_rendering_node.dart';

class PathSimplifierNode extends CubicOnlyRenderingNode {
  List<PathOperation> ops = [];
  @override
  void renderClose() {
    ops.add(Close());
  }

  @override
  void renderCubic(CubicBezier c) {
    ops.add(c);
  }

  @override
  void renderMove(Move m) {
    ops.add(m);
  }

  List<PathOperation> simplify(List<PathOperation> ops) {
    for (PathOperation op in ops) {
      renderOp(op);
    }
    return this.ops;
  }
  
}