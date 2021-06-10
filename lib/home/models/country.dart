import 'dart:convert';
import 'package:hive/hive.dart';
part 'country.g.dart';
Country countryFromJson(String str) => Country.fromJson(json.decode(str));
String countryToJson(Country data) => json.encode(data.toJson());


@HiveType(typeId: 1)
class Country extends HiveObject {

  // ignore: public_member_api_docs
  Country({
    this.name,
    this.code,
    this.currency,
    this.states,
  });

  Country copyWith({
    name,
    code,
    currency,
    states,
  })=>  Country(name: name ??
        this.name,code: code ?? this.code,currency: currency ?? this.currency,
        states: states ?? this.states);

  @HiveField(0)
  String name;
  @HiveField(1)
  String code;
  @HiveField(2)
  String currency;
  @HiveField(3)
  List<dynamic> states;
  @HiveField(4)
  DateTime visitedTime;


  @override
  factory Country.fromJson(Map<String, dynamic> json) => Country(
    name: json["name"],
    code: json["code"],
    currency: json["currency"],
    states: List<dynamic>.from(json["states"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "code": code,
    "currency": currency,
    "states": List<dynamic>.from(states.map((x) => x)),
  };




}