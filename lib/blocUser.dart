import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluppyclient/cloud_firestore_repository.dart';
import 'package:fluppyclient/feed_back_info.dart';
import 'package:fluppyclient/firabase_storage_repository.dart';
import 'package:fluppyclient/product.dart';
import 'package:fluppyclient/reto.dart';
import 'package:fluppyclient/service_request.dart';
import 'package:fluppyclient/suggestion.dart';
import 'package:fluppyclient/support.dart';
import 'package:fluppyclient/user.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'auth_repository.dart';
class UserBloc implements Bloc{
  final auth_repository= AuthRepository();
//Flujo de datos_Stream
  //Stream _ Firebase

  Stream<FirebaseUser> streamFirebase = FirebaseAuth.instance.onAuthStateChanged;// nos devuelve el stream que estamos esperando

  Stream<FirebaseUser> get authStatus{// devuleve el estado de la sesión
    return streamFirebase;
  }

  final _firebaseStorageRepository= FirebaseStorageRepository();

  Future<StorageUploadTask> uploadFile(String path, File image,bool isVideo){
    return _firebaseStorageRepository.uploadFile(path, image,isVideo);
  }

  //Casos de uso
  //1.Sign In a la aplicación

  //2.Registar usuario en base de datos
  final _cloudFirestoreRepository= CloudFirestoreRepository();

  void updateUserData(User user){
    _cloudFirestoreRepository.updateUserDataFirestore(user);
  }

  void updateWalkerFeedBack(FeedBack feedBack) async {
    _cloudFirestoreRepository.updateWalkerFeedBack(feedBack);
  }

  void submitSupportRequest(Support support) async {
    _cloudFirestoreRepository.submitSupportRequest(support);
  }

/////////////
  Future <FirebaseUser> signIn(){
    return auth_repository.signInFirebase();
  }

  signOut(){
    auth_repository.signOut();
  }

  Future<void> updateSuggestionData(Suggestion suggestion){
    return _cloudFirestoreRepository.updateSuggestionData(suggestion);
  }
  void updateServiceRequireData(ServiceRequest request) {
     _cloudFirestoreRepository.updateServiceRequireData(request);
  }
  void updateUserProductRequest(Product product, String userId) async {
    _cloudFirestoreRepository.updateUserProductRequest(product, userId);
  }
  void updateUserProductsRequestedInfo(User user, String address, int orderPrice,double latitude, double longitude,int paymentMethod) async{
    _cloudFirestoreRepository.updateUserProductsRequestedInfo(user, address, orderPrice,latitude,longitude,paymentMethod);
  }

  void updateUserProductsRequested(String userId,Product product,String image,int paymentMethod) async{
    _cloudFirestoreRepository.updateUserProductsRequested(userId, product, image,paymentMethod);
  }
  void updateUserProductsRequestedBusiness(String userId,String businessId, Product product,String image,int paymentMethod) async{
    _cloudFirestoreRepository.updateUserProductsRequestedBusiness(userId,businessId, product,image,paymentMethod);
  }
  void updateUserProductsRequestedInfoBusiness(String businessId,String userId,String address,
      double latitude, double longitude, int paymentMethod,int total,String clientNumber,String petName) async{
    _cloudFirestoreRepository.updateUserProductsRequestedInfoBusiness(businessId, userId, address, latitude, longitude, paymentMethod, total, clientNumber,petName);
  }

  void updateUserRequestChallenge(Reto reto) async{
    _cloudFirestoreRepository.updateUserRequestChallenge(reto);
  }
  void updateUserToCoupon(String couponId,User user) async{
    _cloudFirestoreRepository.updateUserToCoupon(couponId, user);
  }

  @override
  void dispose() {

  }

}