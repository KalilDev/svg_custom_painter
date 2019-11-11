import 'package:svg_custom_painter/tokens/path_data_operations.dart';
import 'package:svg_custom_painter/tokens/path_data_operation_component.dart';
import 'package:vector_math/vector_math_64.dart';
import 'package:svg_custom_painter/tokens/path_data.dart';

PathOperation convertToOperation(List<PathComponent> pcs) {
  final List<num> computed = [];
  TypeComponent type;
  pcs.forEach((PathComponent c) {
    if (c is TypeComponent) type = c;
    if (c is NumberComponent)
      computed.addAll(NumberComponent.compute(c).map((PathComponent c) =>
          c is IntComponent ? c.i : c is DoubleComponent ? c.d : null));
  });
  final int argCount = typeArgCountMap[type.t];
  if (computed.length != argCount) {
    //fuck, this is ambiguous, throw for now
    throw TypeError();
  }
  switch (type.t) {
    case Move:
      return Move(alias: type.char, start: Vector2(computed[0], computed[1]));
      break;
    case Close:
      return Close();
      break;
    case Line:
      return Line(alias: type.char, point: Vector2(computed[0], computed[1]));
      break;
    case HorizontalLine:
      return HorizontalLine(alias: type.char, x: computed[0]);
      break;
    case VerticalLine:
      return VerticalLine(alias: type.char, y: computed[0]);
      break;
    case CubicBezier:
      return CubicBezier(
          alias: type.char,
          control1: Vector2(computed[0], computed[1]),
          control2: Vector2(computed[2], computed[3]),
          end: Vector2(computed[4], computed[5]));
      break;
    case SmoothCubicBezier:
      return SmoothCubicBezier(
          alias: type.char,
          control2: Vector2(computed[0], computed[1]),
          end: Vector2(computed[2], computed[3]));
      break;
    case QuadraticBezier:
      return QuadraticBezier(
          alias: type.char,
          control: Vector2(computed[0], computed[1]),
          end: Vector2(computed[2], computed[3]));
      break;
    case SmoothQuadraticBezier:
      return SmoothQuadraticBezier(
          alias: type.char, end: Vector2(computed[0], computed[1]));
      break;
    case Arc:
      return Arc(
          alias: type.char,
          radius: Vector2(computed[0], computed[1]),
          rotation: computed[2],
          largeArcFlag: computed[3] == 1,
          sweepFlag: computed[4] == 1,
          end: Vector2(computed[5], computed[6]));
      break;
  }
}

class PathParser {
  PathParser(this.rawPathData);
  final String rawPathData;
  PathData pathData;
  Future<PathData> parse() async {
    //May take long
    return Future<PathData>.microtask(() {
      final List<PathOperation> operations = [];
      List<PathComponent> currentOpBuffer;

      for (int i = 0; i < rawPathData.length; i++) {
        if (i == rawPathData.length - 1) {
          print('end');
        }
        final String char = rawPathData[i];
        try {
          final int number = int.parse(char);
          final PathComponent lastComponent =
              currentOpBuffer[currentOpBuffer.length - 1];
          if (lastComponent is NumberComponent) {
            lastComponent + number;
          } else {
            final NumberComponent newComponent = NumberComponent();
            newComponent + number;
            currentOpBuffer.add(newComponent);
          }
        } on FormatException {
          // Not an int
          if (char == ',' || char == '.') {
            // This is an special case
            final PathComponent lastComponent =
                currentOpBuffer[currentOpBuffer.length - 1];
            if (lastComponent is NumberComponent) {
              lastComponent + char;
            } else {
              currentOpBuffer.add(UnambiguousSeparatorComponent());
            }
            continue;
          }
          if (char == ' ') {
            currentOpBuffer?.add(UnambiguousSeparatorComponent());
            continue;
          }
          if (charTypeMap.containsKey(char.toLowerCase())) {
            if (currentOpBuffer != null) {
              operations.add(convertToOperation(currentOpBuffer));
            }
            currentOpBuffer = [TypeComponent(char)];
          }
        }
      }
      if (currentOpBuffer != null)
        operations.add(convertToOperation(currentOpBuffer));
      pathData = PathData(operations);
      return pathData;
    });
  }
}
