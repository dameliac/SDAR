import 'package:sdar/bar%20graph/individualbar.dart';

class BarData {
  final double Trip1;
  final double Trip2;
  final double Trip3;
  final double Trip4;
  final double Trip5;
  final double Trip6;
  final double Trip7;
  final double Trip8;
  final double Trip9;
  final double Trip10;

  BarData({
    required this.Trip1,
    required this.Trip2,
    required this.Trip3,
    required this.Trip4,
    required this.Trip5,
    required this.Trip6,
    required this.Trip7,
    required this.Trip8,
    required this.Trip9,
    required this.Trip10,
  });

  List<IndividualBar> barData = [];

  void initialiseBarData(){
    barData = [
      IndividualBar(x: 0, y: Trip1),
      IndividualBar(x: 1, y: Trip2),
      IndividualBar(x: 2, y: Trip3),
      IndividualBar(x: 3, y: Trip4),
      IndividualBar(x: 4, y: Trip5),
      IndividualBar(x: 5, y: Trip6),
      IndividualBar(x: 6, y: Trip7),
      IndividualBar(x: 7, y: Trip8),
      IndividualBar(x: 8, y: Trip9),
      IndividualBar(x: 9, y: Trip10),
      

    ];
  }
}