import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluppyclient/blocUser.dart';
import 'package:fluppyclient/generic_button.dart';
import 'package:fluppyclient/product.dart';
import 'package:fluppyclient/size_config.dart';
import 'package:fluppyclient/store_screen.dart';
import 'package:fluppyclient/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:image_picker/image_picker.dart';


class BusinessProductInfo extends StatefulWidget {
  String image;
  String productName;
  int price;
  int currentUnits;
  String productDescription;
  String userId;
  Map<String, Product>userProducts;
  String provider;
  String productId;
  int productCost;
  String category;
  BuildContext mainContext;
  Color productBackgroundColor;
  String providerId;
  BusinessProductInfo({Key key, this.image,this.price,this.productName,this.currentUnits,
    this.productDescription,this.userId,this.userProducts,
    this.provider,this.productId,this.productCost,this.category,this.mainContext,this.productBackgroundColor,this.providerId});
  @override
  _BusinessProductInfo createState() => _BusinessProductInfo();
}

class _BusinessProductInfo extends State<BusinessProductInfo> {
  UserBloc userBloc;
  String name, description, price, units;
  String priceWithComa;
  RegExp reg = new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
  Function mathFunc = (Match match) => '${match[1]},';
  var _controllerPrice;
  var _controllerUnits;
  var _controllerDescription;
  String image = "assets/FluppyPro.png";
  File imageFile;
  bool changeImage;
  int currentProductUnits;
  int currentPrice;
  String sizeOption;
  String colorOption;
  String cobijaOption;
  String letterColorOption;

  Future getImageGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      this.imageFile = image;
      this.image = image.path;
    });
    print("FILE DE LA IMAGEN  CON GALERIA: ${this.image}");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("EL PROVIDER ES: ${widget.provider}");
    setState(() {
      currentPrice = widget.price;
      priceWithComa =
          this.currentPrice.toString().replaceAllMapped(reg, mathFunc);
      currentProductUnits = 1;
    });
    changeImage = false;
    _controllerPrice = TextEditingController(text: "${widget.price}");
    _controllerUnits = TextEditingController(text: "${widget.currentUnits}");
    _controllerDescription =
        TextEditingController(text: "${widget.productDescription}");
  }

  @override
  Widget build(BuildContext context) {
    print("A FLUPPY LE CUESTA: ${widget.productCost}");
    FocusScope.of(context).unfocus();
    userBloc = BlocProvider.of<UserBloc>(context);
    SizeConfig().init(context);
    return Container();
  }
}