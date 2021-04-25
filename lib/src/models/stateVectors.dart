import 'dart:convert';

StateVector stateVectorFromJson(String str) =>
    StateVector.fromJson(json.decode(str));

String stateVectorToJson(StateVector data) => json.encode(data.toJson());

class StateVector {
  StateVector({
    this.time,
    this.states,
  });

  int time;
  List<List<dynamic>> states;

  factory StateVector.fromJson(Map<String, dynamic> json) => StateVector(
        time: json["time"],
        states: List<List<dynamic>>.from(
            json["states"].map((x) => List<dynamic>.from(x.map((x) => x)))),
      );

  Map<String, dynamic> toJson() => {
        "time": time,
        "states": List<dynamic>.from(
            states.map((x) => List<dynamic>.from(x.map((x) => x)))),
      };
}
