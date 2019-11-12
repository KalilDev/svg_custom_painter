import 'path_data_operations.dart';
import 'dart:math';

getType(String char) {
  return charTypeMap[char.toLowerCase()];
}

class PathComponent {}

class TypeComponent extends PathComponent {
  TypeComponent(String char)
      : char = char,
        t = getType(char);
  final Type t;
  final String char;
}

class UnambiguousSeparatorComponent extends PathComponent {}

// AMBIGUOS
class NumberComponent extends PathComponent {
  String stringRepresentation = '';
  List<int> numberRepresentation = [];
  bool shouldAddNew = true;

  static List<PathComponent> compute(NumberComponent n) {
    List<PathComponent> components = [];
    if (n.numberRepresentation.contains(null)) {
      int current;
      final Iterator<int> iter = n.numberRepresentation.iterator;
      while (iter.moveNext()) {
        if (iter.current == null) {
          if (components.last is IntComponent &&
              (components.last as IntComponent).i == current) {
            components.removeLast();
            final int integer = current;
            iter.moveNext();
            final int decimal = iter.current;
            final double d =
                integer + (decimal / pow(10, decimal.abs().toString().length));
            components.add(DoubleComponent(d));
          }
        } else {
          current = iter.current;
          components.add(IntComponent(current));
        }
      }
    } else {
      n.numberRepresentation
          .forEach((int i) => components.add(IntComponent(i)));
    }
    if (n is NegativeNumberComponent) {
      final first = components.first;
      final neg = first is DoubleComponent ? DoubleComponent(-first.d) : first is IntComponent ? IntComponent(-first._i) : null;
      components..removeAt(0)..insert(0, neg);
    }
    return components;
  }

  operator +(dynamic other) {
    print(other.toString());
    stringRepresentation = stringRepresentation + other.toString();
    if (other == ',' || other == '.') {
      if (other == '.') {
        numberRepresentation.add(null); // use null to indicate an double
      }
      shouldAddNew = true; // New number
    }
    if (other is int) {
      if (shouldAddNew) {
        numberRepresentation.add(other);
        shouldAddNew = false;
      } else {
        final int currentNum =
            numberRepresentation[numberRepresentation.length - 1];
        numberRepresentation[numberRepresentation.length - 1] =
            (currentNum * 10).floor() + other;
      }
    }
  }
}

class NegativeNumberComponent extends NumberComponent {}

class DoubleComponent extends PathComponent {
  DoubleComponent(this.d);
  final double d;
}

class IntComponent extends PathComponent {
  IntComponent(this._i);
  final int _i;
  double get i => 0.0 + _i;
}
