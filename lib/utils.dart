import 'package:vector_math/vector_math_64.dart';

bool lerpBool(bool a, bool b, double t) {
  if (a == null && b == null) return null;
  if (t <= 0.5) {
    return a;
  } else {
    return b;
  }
}

/// Linearly interpolate between two numbers.
double lerpDouble(num a, num b, double t) {
  if (a == null && b == null) return null;
  a ??= 0.0;
  b ??= 0.0;
  return a + (b - a) * t;
}

