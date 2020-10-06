
import 'package:fluppyclient/cloud_firestoreAPI.dart';
import 'package:fluppyclient/feed_back_info.dart';
import 'package:fluppyclient/product.dart';
import 'package:fluppyclient/reto.dart';
import 'package:fluppyclient/service_request.dart';
import 'package:fluppyclient/suggestion.dart';
import 'package:fluppyclient/support.dart';
import 'package:fluppyclient/user.dart';

class CloudFirestoreRepository {
  final _cloudFirestoreAPI = CloudFireStoreAPI();

  void updateUserDataFirestore(User user) {
    _cloudFirestoreAPI.updateUserData(user);
  }

  void updateWalkerFeedBack(FeedBack feedBack) async {
    _cloudFirestoreAPI.updateWalkerFeedBack(feedBack);
  }

  Future<void> updateSuggestionData(Suggestion suggestion) {
    return _cloudFirestoreAPI.updateSuggestionData(suggestion);
  }

  void updateServiceRequireData(ServiceRequest request) {
    _cloudFirestoreAPI.updateServiceRequestData(request);
  }

  void submitSupportRequest(Support support) async {
    _cloudFirestoreAPI.submitSupportRequest(support);
  }

  void updateUserProductRequest(Product product, String userId) async {
    _cloudFirestoreAPI.updateUserProductRequest(product, userId);
  }
  void updateUserProductsRequestedInfo(User user, String address, int orderPrice,double latitude, double longitude,int paymentMethod) async{
    _cloudFirestoreAPI.updateUserProductsRequestedInfo(user, address, orderPrice,latitude,longitude, paymentMethod);
  }
  void updateUserProductsRequested(String userId, Product product, String image,int paymentMethod) async{
    _cloudFirestoreAPI.updateUserProductsRequested(userId, product,image,paymentMethod);
  }
  void updateUserProductsRequestedBusiness(String userId,String businessId, Product product,String image,int paymentMethod) async{
    _cloudFirestoreAPI.updateUserProductsRequestedBusiness(userId,businessId, product,image,paymentMethod);
  }
  void updateUserProductsRequestedInfoBusiness(String businessId,String userId,String address,
      double latitude, double longitude, int paymentMethod,int total,String clientNumber,String petName) async{
    _cloudFirestoreAPI.updateUserProductsRequestedInfoBusiness(businessId, userId, address, latitude, longitude, paymentMethod, total, clientNumber,petName);
  }

  void updateUserRequestChallenge(Reto reto) async{
     _cloudFirestoreAPI.updateUserRequestChallenge(reto);
  }

  void updateUserToCoupon(String couponId,User user) async{
    _cloudFirestoreAPI.updateUserToCoupon(couponId, user);
  }

}