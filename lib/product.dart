import 'package:flutter/material.dart';

class Product{
  final String productName;
  final String id;
  final String description;
  final int units;
  final int price;
  final String image;
  final int currentUnitsInStock;
  final String provider;
  final String providerId;
  final int productCost;
  final String category;
  Product({Key key, @required this.productName,this.description,this.image,this.price,this.units,
    this.id,this.currentUnitsInStock,this.provider,this.productCost,this.category,this.providerId});
}