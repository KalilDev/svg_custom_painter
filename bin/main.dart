import 'dart:math';

import 'package:svg_custom_painter/tokenizers/path_data_parser.dart';
import 'package:svg_custom_painter/tokens/path_data.dart';
import 'package:svg_custom_painter/tokens/path_data_operations.dart';
import 'package:svg_custom_painter/rendering/custom_painter_generator.dart';
import 'package:svg_custom_painter/rendering/static_code_generator.dart';
import 'package:vector_math/vector_math_64.dart';
benchmark(String pathData, String desc) async {
    for (int h = 0; h < 12; h++) {
  final int n = (h.isEven ? pow(10, h/2) : 2* pow(10, (h-1)/2)).round();
  int time = 0;
  for (int i = 0; i < n ; i++) {
  final PathParser parser0 = PathParser(pathData);
  final stopwatch = Stopwatch()..start();
  await parser0.parse();
  stopwatch.stop();
  time += stopwatch.elapsedMicroseconds;
  }
  print(desc + 'Avg (' + n.toString() + ' runs): ' + (time/n).toString());
  }
}
main(List<String> arguments) async {
final PathParser parser1 = PathParser("M 31.767 0.099 C 30.797 0.268 29.718 0.594 29.718 0.594 C 29.718 0.594 27.756 1.189 26.746 1.189 C 25.763 1.189 23.909 0.634 23.809 0.604 C 17.097 1.921 11.057 5.442 6.72 10.568 C 5.852 11.593 5.063 12.67 4.356 13.79 C 3.649 14.91 3.023 16.073 2.483 17.27 C 1.942 18.468 1.486 19.7 1.119 20.957 C 0.752 22.214 0.473 23.497 0.285 24.797 C 0.098 26.097 0.001 27.413 0 28.738 C 0 33.782 1.373 38.738 3.981 43.107 C 4.85 44.563 5.847 45.937 6.957 47.215 C 8.066 48.493 9.289 49.676 10.611 50.749 C 11.933 51.822 13.353 52.785 14.859 53.626 C 19.376 56.148 24.502 57.476 29.718 57.476 C 34.934 57.476 40.06 56.148 44.577 53.626 C 46.083 52.785 47.504 51.822 48.826 50.749 C 50.147 49.676 51.37 48.493 52.48 47.215 C 53.589 45.937 54.586 44.563 55.455 43.107 C 58.063 38.738 59.436 33.782 59.436 28.738 C 59.435 27.485 59.349 26.239 59.181 25.007 C 59.013 23.775 58.762 22.558 58.433 21.362 C 58.103 20.166 57.693 18.992 57.207 17.847 C 56.721 16.703 56.158 15.587 55.52 14.509 C 54.882 13.43 54.171 12.388 53.387 11.39 C 49.47 6.4 43.971 2.783 37.733 1.094 C 36.757 0.926 35.661 0.594 35.661 0.594 C 35.661 0.594 35.578 0.571 35.552 0.563 C 34.302 0.33 33.038 0.175 31.767 0.099 C 31.767 0.099 31.767 0.099 31.767 0.099 Z");
  final PathParser parser2 = PathParser("M 29.718 9.247 C 29.718 9.247 28.464 0.099 18.584 0.001 C 18.584 0.001 18.584 0.001 18.584 0.001 C 18.427 -0.001 18.268 0 18.106 0.003 C 9.985 1.55 4.653 10.957 4.653 10.957 C 4.653 10.957 11.657 8.216 16.4 9.635 C 22.533 11.469 27.867 15.858 27.44 16.376 C 27.085 16.805 21.071 13.721 14.794 13.651 C 8.518 13.58 2.63 15.653 0.642 21.375 C -0.701 25.242 0.481 30.884 0.481 30.884 C 0.481 30.884 6.743 24.166 10.744 22.264 C 17.703 18.955 26.377 19.412 26.377 19.412 C 26.377 19.412 28.062 19.693 28.093 21.19 C 28.23 27.635 26.282 45.973 22.825 54.322 C 21.349 57.888 29.718 57.46 29.718 57.46 C 29.718 57.46 38.087 57.888 36.611 54.322 C 33.154 45.973 31.207 27.635 31.343 21.19 C 31.374 19.693 33.059 19.412 33.059 19.412 C 33.059 19.412 41.734 18.955 48.693 22.264 C 52.693 24.166 58.956 30.884 58.956 30.884 C 58.956 30.884 60.137 25.242 58.794 21.375 C 56.806 15.653 50.918 13.58 44.642 13.651 C 38.366 13.721 32.352 16.805 31.996 16.376 C 31.569 15.858 36.904 11.469 43.037 9.635 C 47.78 8.216 54.783 10.957 54.783 10.957 C 54.783 10.957 49.45 1.55 41.329 0.003 C 38.75 -0.046 36.734 0.507 35.162 1.364 C 33.59 2.222 32.461 3.383 31.655 4.551 C 30.848 5.719 30.364 6.893 30.081 7.775 C 29.799 8.657 29.718 9.247 29.718 9.247 Z");
  await parser1.parse();
  await parser2.parse();
  int microseconds = 0;
  for (int i = 0; i<=100;i++) {
    final Stopwatch timer = Stopwatch()..start();
    PathData.lerp(parser1.pathData, parser2.pathData, i/100);
    timer.stop();
    microseconds += timer.elapsedMicroseconds;
    print(timer.elapsedMicroseconds);
  }
  final StaticCodeGenerator gen = StaticCodeGenerator();
  print(gen.getOps(parser1.pathData));
  print('avg lerp: '+(microseconds/100).toString());  
}
