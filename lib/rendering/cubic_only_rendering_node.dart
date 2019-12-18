import 'rendering_node.dart';
import 'package:svg_custom_painter/tokens/path_data_operations.dart';
import 'arc_to_cubic.dart';

abstract class CubicOnlyRenderingNode extends RenderingNode {
  void renderMove(Move m);
  void renderClose();
  void renderCubic(CubicBezier c);

  @override
  void renderLine(Line l) {
    // We will place the handles in the middle
    final double deltaX = cx - l.x;
    final double deltaY = cy - l.y;
    renderCubic(CubicBezier(x1: cx + (deltaX/2),y1: cy + (deltaY/2),x2: cx + (deltaX/2),y2: cy + (deltaY/2),x: l.x,y: l.y));
  }

  @override
  void renderQuad(QuadraticBezier q) {
    final double x1 = cx + 2/3 * (q.x1-cx);
    final double y1 = cy + 2/3 * (q.y1-cy);
    final double x2 = q.x + 2/3 * (q.x1-q.x);
    final double y2 = q.y + 2/3 * (q.y1-q.y);
    renderCubic(CubicBezier(x1: x1, y1: y1, x2: x2, y2: y2, x: q.x, y: q.y));
  }

  @override
  void renderArc(Arc a) {
    List<CubicBezier> ops = arcToCubics(cx, cy, a);
    if (ops == null || ops.isEmpty)
      return null;
    for (int i = 0; i<ops.length; i++) {
      final CubicBezier op = ops[i];
      renderCubic(op);
    }
  }
}