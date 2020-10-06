import 'package:flutter/material.dart';

class User{
  final String email;
  final String id;
  final String firstName;
  final String lastName;
  final String photoURl;
  final bool serviceAccepted;
  final String walkerId;
  final int trips;
  final String linkState="preLinked";
  final String phone;
  final String userPetName;
  final String userPetType;
  final int userPoints;
  User({Key key, @required this.email , @required this.id, this.firstName,this.lastName, this.photoURl,
    this.serviceAccepted,this.walkerId,this.trips,this.phone,this.userPetName,this.userPetType,this.userPoints});
}