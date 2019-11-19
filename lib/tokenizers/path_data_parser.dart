import 'package:svg_custom_painter/tokens/path_data_operations.dart';
import 'package:vector_math/vector_math_64.dart';
import 'package:svg_custom_painter/tokens/path_data.dart';

PathOperation convertToOperationNew(String op, List<double> computed) {
  switch (charTypeMap[op.toLowerCase()]) {
    case Move:
      return Move(alias: op,
          x: computed[0],
          y: computed[1]);
      break;
    case Close:
      return Close();
      break;
    case Line:
      return Line(alias: op,
          x: computed[0],
          y: computed[1]);
      break;
    case HorizontalLine:
      return HorizontalLine(alias: op, x: computed[0]);
      break;
    case VerticalLine:
      return VerticalLine(alias: op, y: computed[0]);
      break;
    case CubicBezier:
      return CubicBezier(
          alias: op,
          x1: computed[0],
          y1: computed[1],
          x2: computed[2],
          y2: computed[3],
          x: computed[4],
          y: computed[5]);
      break;
    case SmoothCubicBezier:
      return SmoothCubicBezier(
          alias: op,
          x2: computed[0],
          y2: computed[1],
          x: computed[2],
          y: computed[3]);
      break;
    case QuadraticBezier:
      return QuadraticBezier(
          alias: op,
          x1: computed[0],
          y1: computed[1],
          x: computed[2],
          y: computed[3]);
      break;
    case SmoothQuadraticBezier:
      return SmoothQuadraticBezier(
          alias: op, x: computed[0], y: computed[1]);
      break;
    case Arc:
      return Arc(
          alias: op,
          rx: computed[0],
          ry: computed[1],
          rotation: computed[2],
          largeArcFlag: computed[3] == 1,
          sweepFlag: computed[4] == 1,
          x: computed[5],
          y: computed[6],);
      break;
  }
}
int getAlgarism(int c) {
  switch (c) {
    case 48: return 0;
    case 49: return 1;
    case 50: return 2;
    case 51: return 3;
    case 52: return 4;
    case 53: return 5;
    case 54: return 6;
    case 55: return 7;
    case 56: return 8;
    case 57: return 9;
    default: return null;
  }
}

bool isDecimalSeparator(int c) => (c == 44 || c == 46); // ',' or '.'
bool isUnambiguousSeparator(int c) => c == 32; // ' '
bool isSubtractionOperator(int c) => c == 45; // '-'

class PathParser {
  PathParser(this.rawPathData);
  final String rawPathData;
  PathData pathData;
  PathData parse() {
    // This parses only WELL FORMED paths.
    // On the form C double double double....
    // With spaces as separators, and commas or dots as separators
    // for the decimal and integer parts
      final List<PathOperation> operations = [];
      String opCode;
      int intPart;
      int decPart;
      int carriedDivision = 1; // Will be used because otherwise 0 would be ignored
      bool isNeg = false;
      int remainingArgs;
      List<double> numbers = [];
      final Iterator iter = rawPathData.codeUnits.iterator;
      while (iter.moveNext()) {
        final int c = iter.current;

        // Deal with subtraction first
        if (isSubtractionOperator(c)) {
          isNeg = true;
          continue;
        }

        // Deal with decimal operator
        if (isDecimalSeparator(c)) {
          decPart = 0;
          continue;
        }

        // Deal with an finished num
        if (isUnambiguousSeparator(c)) {
          if (intPart == null && decPart == null)
            continue; // This was before any number, just skip.
          if (decPart != null) {
            numbers.add(isNeg ? intPart + (decPart/carriedDivision) : -intPart + (decPart/carriedDivision));
            decPart = null;
            carriedDivision = 1;
          } else {
            numbers.add(isNeg ? -intPart.toDouble() : intPart.toDouble());
          }
          intPart = null;
          isNeg = false;
          continue;
        }

        // Otherwise, assume this is an algarism, else it MUST be a command
        final int alg = getAlgarism(c);
        if (alg != null) {
          if (decPart != null) {
            // This algarism is part of the decimal part
              carriedDivision *= 10;
              decPart = decPart *10 + alg;
          } else {
            intPart ??= 0;
            intPart = intPart*10 +alg;
          }
          continue;
        }

        final String op = String.fromCharCode(c);
        final bool isValidOp = charTypeMap.containsKey(op.toLowerCase());
        if (isValidOp) {
          // Finish the previous op
          if (opCode != null) {
            if (remainingArgs != numbers.length) {
              operations.add(Close());
              break;
            }
            operations.add(convertToOperationNew(opCode, numbers));
          }
          // Start a new op
          opCode = op;
          intPart = null;
          decPart = null;
          carriedDivision = 1;
          isNeg = false;
          remainingArgs = charArgCountMap[opCode.toLowerCase()];
          numbers = [];
        }}
      pathData = PathData(operations);
      return pathData;
  }
}
