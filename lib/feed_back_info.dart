import 'package:flutter/material.dart';

class FeedBack{
  final String walkerId;
  final String clientId;
  final String clientPhoto;
  final String clientFirstName;
  final String clientLastName;
  final double stars;
  FeedBack({Key key, this.walkerId,this.clientId,this.clientPhoto,this.clientFirstName,this.clientLastName,this.stars});
}