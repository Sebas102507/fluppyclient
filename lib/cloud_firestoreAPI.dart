import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluppyclient/feed_back_info.dart';
import 'package:fluppyclient/product.dart';
import 'package:fluppyclient/reto.dart';
import 'package:fluppyclient/service_request.dart';
import 'package:fluppyclient/suggestion.dart';
import 'package:fluppyclient/support.dart';
import 'package:fluppyclient/user.dart';

class CloudFireStoreAPI {
  final String USERS="users";  // declaro el nombre de las colecciones
  final String SUGGESTIONS="suggestions";
  final String WALKERS="walkers";
  final String WALKERFEEDBACK="feedBack";
  final String SERVICE_REQUEST="service_request";
  final Firestore _dateBase= Firestore.instance;// obtengo la conexion para poder insertar los datos
  final String USERSCART="usersCart";
  final String USERCART="userCart";
  final String SUPPORT="SUPPORT";
  final String USERSPRODUCTREQUESTS="usersProductsRequests";
  final String USERCHALLENGES="userChallenges";
  final String CHALLENGES= "challenges";

  void updateUserToCoupon(String couponId,User user) async{
    print("ID USUARIO: ${user.id}");
    DocumentReference reference= Firestore.instance.collection("coupons").document(couponId).collection("usersViculated").document(user.id);
    return reference.setData({
      'id': user.id,
      'email': user.email,
      'firstName': user.firstName,
      'lastName': user.lastName,
      'photoUrl': user.photoURl,
      'phoneNumber': user.phone,
      'petName': user.userPetName,
      'petType': user.userPetType,
    },merge: true);// se hace merge para que se aplique realmente a la base de datos, que sí se ingreso al info
  }
  
  
  
  void updateUserData(User user) async{
        print("ID USUARIO: ${user.id}");
    DocumentReference reference= Firestore.instance.collection(USERS).document(user.id);
    return reference.setData({
      'id': user.id,
      'email': user.email, //son los fields, los campos de cada usuario
      'firstName': user.firstName,
      'lastName': user.lastName,
      'photoUrl': user.photoURl,
      'phoneNumber': user.phone,
      'serviceAccepted' : user.serviceAccepted,
      'walkerId': user.walkerId,
      'trips': user.trips,
      'linked': user.linkState,
      'petName': user.userPetName,
      'petType': user.userPetType,
      'serviceAcceptedType': -1,
      'stillLinked': null
    },merge: true);// se hace merge para que se aplique realmente a la base de datos, que sí se ingreso al info
  }

  void updateUserProductRequest(Product product, String userId) async {
    DocumentReference reference = Firestore.instance.collection(USERSCART).document(userId).collection(USERCART).document(product.productName);
    return reference.setData({
      "productName": product.productName,
      "productPrice": product.price,
      "productUnits": product.units,
      "productImage": product.image,
      "productDescription": product.description
    },
        merge: true); // se hace merge para que se aplique realmente a la base de datos, que sí se ingreso al info
  }

  Future<void> updateWalkerFeedBack(FeedBack feedBack) async{
    CollectionReference reference= _dateBase.collection(WALKERS).document(feedBack.walkerId).collection(WALKERFEEDBACK);
    await reference.add({
      'clientFirstName': feedBack.clientFirstName,
      'clientLastName': feedBack.clientLastName,
      'clientPhoto': feedBack.clientPhoto,
      'stars': feedBack.stars
    });
  }
  Future<void> updateSuggestionData(Suggestion suggestion)async{

    CollectionReference reference= _dateBase.collection(SUGGESTIONS);
    await reference.add({
      'stars': suggestion.stars,
      'description': suggestion.description
    });

  }

  void updateServiceRequestData(ServiceRequest request) async{
    print("INFO DE LA SUGGESTIONS");
    print(request.userFirstName);
    print(request.userLastName);
        print(request.userEmail);
            print(request.userId);
    print(request.userImage);
    print(request.serviceType);
    print(request.latitude);
        print(request.longitude);
        print(request.userAddress);
    print(request.userPhoneNumber);
    print(request.userPetName);
    print(request.userPetType);
        print(request.userTrips);
    print("AQUÍ DEBE MANDAR LA INFO PARA LA SOLICIUD");
    DocumentReference reference= Firestore.instance.collection(SERVICE_REQUEST).document(request.userId);
    return reference.setData({
      'userFirstName':request.userFirstName,
      'userLastName': request.userLastName,
      'userEmail': request.userEmail,
      'userId': request.userId,
      'userImage':request.userImage,
      'serviceType': request.serviceType,
      'latitude': request.latitude,
      'longitude': request.longitude,
      'UserAddress': request.userAddress,
      'userPhone': request.userPhoneNumber,
      'userPetName': request.userPetName,
      'userPetType': request.userPetType,
      'userTrips': request.userTrips,
      'petNumber': request.petNumber,
      'price': request.price
    },merge: true);// se hace merge para que se aplique realmente a la base de datos, que sí se ingreso al info
  }

  void updateUserProductsRequestedInfo(User user, String address, int orderPrice, double latitude, double longitude,int paymentMethod) async{

    DocumentReference reference= Firestore.instance.collection(USERSPRODUCTREQUESTS).document(user.id);
    return reference.setData({
      "userName": "${user.firstName} ${user.lastName}",
      "userAddres": address,
      "userPhone": user.phone,
      "orderPrice": orderPrice,
      "userId": user.id,
      "estimatedTime": "por confirmar...",
      "petName": user.userPetName,
      "latitude": latitude,
      "longitude": longitude,
      "paymentMethod": paymentMethod
    },merge: true);
  }


  void updateUserProductsRequestedInfoBusiness(String businessId,String userId,String address,
      double latitude, double longitude, int paymentMethod,int total,String clientNumber,String petName) async{ //info basica para un pedido para una marca aliada
    DocumentReference reference= Firestore.instance.collection("businessesProductRequests").document(businessId).collection("requests").document(userId);
    return reference.setData({
      "userAddres": address,
      "userPhone": clientNumber,
      "orderPrice": total,
      "userId": userId,
      "latitude": latitude,
      "longitude": longitude,
      "paymentMethod": paymentMethod,
      "petName": petName,
      "notified": false,
      "estimatedTime": "Por confirmar"
    },merge: true);
  }

  void updateUserProductsRequested(String  userId, Product product,String image,int paymentMethod) async{
    DocumentReference reference= Firestore.instance.collection(USERSPRODUCTREQUESTS).document(userId).collection("PRODUCTS").document();
    return reference.setData({
      "image": (product.image.contains("firebase") ? product.image: image),
      "productName": product.productName,
      "unitsRequested": product.units,
      "price": product.price,
      "provider": product.provider,
      "productCost": product.productCost,
      "productId": product.id,
      "category": product.category,
      "paymentMethod": paymentMethod
    },merge: true);
  }

  void updateUserProductsRequestedBusiness(String  userId,String businessId, Product product,String image,int paymentMethod) async{
    DocumentReference reference= Firestore.instance.collection("businessesProductRequests").document(businessId).collection("requests").document(userId).collection("Products").document();
    return reference.setData({
      "image": (product.image.contains("firebase") ? product.image: image),
      "productName": product.productName,
      "unitsRequested": product.units,
      "price": product.price,
      "provider": product.provider,
      "productCost": product.productCost,
      "productId": product.id,
      "category": product.category,
      "description": product.description,
      "paymentMethod": paymentMethod,
    },merge: true);
  }



  void submitSupportRequest(Support support) async {
    DocumentReference reference = Firestore.instance.collection(SUPPORT).document();
    return reference.setData({
      'personId': support.id,
      'description': support.description,
      'email': support.email,
      'type': support.type,
      "phoneNumber": support.phoneNumber
    },
        merge: true); // se hace merge para que se aplique realmente a la base de datos, que sí se ingreso al info
  }

  void updateUserRequestChallenge(Reto reto) async{
    DocumentReference reference= Firestore.instance.collection(CHALLENGES).document(reto.retoId).collection("usersChallengeList").document(reto.userId);
    return reference.setData({
      'userId': reto.userId,
      'retoId': reto.retoId, //son los fields, los campos de cada usuario
      'filePath': reto.filePath,
      'retoCoins': reto.retoCoins,
      'retoName': reto.retoName,
      'retoDescription': reto.retoDescription,
      "userCurrentCoins": reto.userCurrentCoins,
    },merge: true);// se hace merge para que se aplique realmente a la base de datos, que sí se ingreso al info
  }

}