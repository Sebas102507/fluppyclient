import 'package:flutter/material.dart';

class ServiceRequest{

  final String userEmail;
  final String userId;
  final String userFirstName;
  final String userLastName;
  final String userPhoneNumber;
  final String userImage;
  final int serviceType;
  final double latitude;
  final double longitude;
  String userAddress;
  final String userPetName;
  final String userPetType;
  final int userTrips;
  final int petNumber;
  int price;
  ServiceRequest({Key key, this.userFirstName,this.userLastName,this.userPhoneNumber, this.userEmail, this.userId,this.userImage,
    this.serviceType, this.latitude, this.longitude,this.userAddress,this.userPetName,this.userPetType,this.userTrips,this.petNumber,this.price});

}