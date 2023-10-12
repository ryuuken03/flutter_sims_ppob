import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sims/model/response_balance.dart';
import 'package:sims/model/response_banner.dart';
import 'package:sims/model/response_general..dart';
import 'package:sims/model/response_history_transaction.dart';
import 'package:sims/model/response_login.dart';
import 'package:sims/model/response_profile.dart';
import 'package:sims/model/response_services.dart';
import 'package:sims/model/response_transaction.dart';
import 'package:http_parser/http_parser.dart';

class Services {

  String baseUrl = dotenv.env['BASE_URL'].toString();

  Future<http.Response> httpPostGetPut(
    int type, 
    String url, {
      Map<String, String>? headers, 
      Object? body,
      Map<String, String>? queryParameters, 
    }) async{
    print(url);
    var response = await http.post(Uri.parse(url),
          headers: headers,
          body: body);
    if(type == 1){
      var uri = Uri.parse(url);
      if(queryParameters != null){
        uri = Uri.parse(url).replace(queryParameters: queryParameters);
      }
      response = await http.get(uri, headers: headers);
    }else if(type == 2){
      response = await http.put(Uri.parse(url), headers: headers, body: body);
    }
    print("${response.statusCode}");
    print("${response.body}");
    return response;

  }

  Future<ResponseGeneral> postRegisterRequest(String _email, String _first_name,
      String _last_name, String _password) async {
    late ResponseGeneral resData;
    print("postRegisterRequest");
    String url = baseUrl + '/registration';
    Map data = {
      'email': _email,
      'first_name': _first_name,
      'last_name': _last_name,
      'password': _password
    };
    try {
      var body = json.encode(data);
      var headers = {
            "accept": "application/json",
            "Content-Type": "application/json"
          };
      var response = await httpPostGetPut(0,url,headers: headers, body: body);
      var decode = jsonDecode(response.body);
      resData = ResponseGeneral.fromJson(decode);
      print("${resData.message}");
    } catch (e) {
      print('Error Occurred' + e.toString());
    }

    return resData;
  }

  Future<ResponseLogin> postLoginRequest(
      String _email, String _password) async {
    late ResponseLogin resData;
    print("postLoginRequest");
    String url = baseUrl + '/login';
    print(url);

    Map data = {'email': _email, 'password': _password};
    try {
      var body = json.encode(data);
      var headers = {
        "accept": "application/json",
        "Content-Type": "application/json"
      };
      var response = await httpPostGetPut(0, url, headers: headers, body: body);
      var decode = jsonDecode(response.body);
      resData = ResponseLogin.fromJson(decode);
      print("${resData.message}");
    } catch (e) {
      print('Error Occurred' + e.toString());
    }

    return resData;
  }

  Future<ResponseProfile> putProfileUpdate(
      String _token, String _first_name, String _last_name) async {
    late ResponseProfile resData;
    print("putProfileUpdate");
    String url = baseUrl + '/profile/update';
    Map data = {
      'first_name': _first_name,
      'last_name': _last_name,
    };
    try {
      var body = json.encode(data);
      var headers = {
        "accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer " + _token
      };
      var response = await httpPostGetPut(2, url, headers: headers, body: body);
      var decode = jsonDecode(response.body);
      resData = ResponseProfile.fromJson(decode);
      print("${resData.message}");
    } catch (e) {
      print('Error Occurred' + e.toString());
    }

    return resData;
  }

  Future<ResponseProfile> putProfileImage(
      String _token, File imageFile) async {
    late ResponseProfile resData;
    print("postProfileImage");
    String url = baseUrl + '/profile/image';
    print(url);
    try {
      var request = http.MultipartRequest(
        "PUT",
        Uri.parse(url),
      );

      request.headers.addAll({
        "accept": "application/json",
        "Content-Type": "multipart/form-data",
        "Authorization": "Bearer " + _token
      });
      print(basename(imageFile.path));
      var multipartFile = http.MultipartFile.fromBytes(
        'file', 
        imageFile.readAsBytesSync(),
        filename: basename(imageFile.path),
        contentType:MediaType('image','jpg'));

      request.files.add(multipartFile);
      var response = await request.send();
      print("${response.statusCode}");
      var responseBytes = await response.stream.toBytes();
      var responseString = utf8.decode(responseBytes);
      print(responseString);
      var decode = jsonDecode(responseString);
      resData = ResponseProfile.fromJson(decode);
      
    } catch (e) {
      print('Error Occurred' + e.toString());
    }
    return resData;
  }

  Future<ResponseProfile> getProfile(String _token) async {
    late ResponseProfile resData;
    print("getProfile");
    String url = baseUrl + '/profile';
    try {
      var headers = {
        "accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer " + _token
      };
      var response = await httpPostGetPut(1, url, headers: headers);
      var decode = jsonDecode(response.body);
      resData = ResponseProfile.fromJson(decode);
      print("${resData.message}");
    } catch (e) {
      print('Error Occurred' + e.toString());
    }

    return resData;
  }

  Future<ResponseBalance> getBalance(String _token) async {
    late ResponseBalance resData;
    print("getBalance");
    String url = baseUrl + '/balance';
    try {
      var headers = {
        "accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer " + _token
      };
      var response = await httpPostGetPut(1, url, headers: headers);
      var decode = jsonDecode(response.body);
      resData = ResponseBalance.fromJson(decode);
      print("${resData.message}");
    } catch (e) {
      print('Error Occurred' + e.toString());
    }

    return resData;
  }

  Future<ResponseServices> getServices(String _token) async {
    late ResponseServices resData;
    print("getServices");
    String url = baseUrl + '/services';
    try {
      var headers = {
        "accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer " + _token
      };
      var response = await httpPostGetPut(1, url, headers: headers);
      var decode = jsonDecode(response.body);
      resData = ResponseServices.fromJson(decode);
    } catch (e) {
      print('Error Occurred' + e.toString());
    }

    return resData;
  }

  Future<ResponseBanner> getBanners(String _token) async {
    late ResponseBanner resData;
    print("getBanner");
    String url = baseUrl + '/banner';
    try {
      var headers = {
        "accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer " + _token
      };
      var response = await httpPostGetPut(1, url, headers: headers);
      var decode = jsonDecode(response.body);
      resData = ResponseBanner.fromJson(decode);
    } catch (e) {
      print('Error Occurred' + e.toString());
    }

    return resData;
  }

  Future<ResponseBalance> postTopUp(String _token, int _top_up_amount) async {
    late ResponseBalance resData;
    print("postTopUp");
    String url = baseUrl + '/topup';
    Map data = {'top_up_amount': _top_up_amount};
    try {
      var body = json.encode(data);
      var headers = {
        "accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer " + _token
      };
      var response = await httpPostGetPut(0, url, headers: headers,body: body);
      var decode = jsonDecode(response.body);
      resData = ResponseBalance.fromJson(decode);
      print("${resData.message}");
    } catch (e) {
      print('Error Occurred' + e.toString());
    }

    return resData;
  }

  Future<ResponseHistoryTransaction> getHistoryTransactions(String _token,
      {int offset = 0, int limit = 5}) async {
    late ResponseHistoryTransaction resData;
    print("getHistoryTransactions");
    print("offset : " + offset.toString());
    String url = baseUrl + '/transaction/history';
    final queryParameters = {
      'limit': limit.toString(),
      'offset': offset.toString(),
    };
    try {
      var headers = {
        "accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer " + _token
      };
      var response = await httpPostGetPut(1, url, headers: headers, queryParameters: queryParameters);
      var decode = jsonDecode(response.body);
      resData = ResponseHistoryTransaction.fromJson(decode);
    } catch (e) {
      print('Error Occurred' + e.toString());
    }

    return resData;
  }

  Future<ResponseTransaction> postPayment(
      String _token, String _service_code) async {
    late ResponseTransaction resData;
    print("postPayment");
    String url = baseUrl + '/transaction';
    Map data = {'service_code': _service_code};
    try {
      var body = json.encode(data);
      var headers = {
        "accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer " + _token
      };
      var response = await httpPostGetPut(0, url, headers: headers, body: body);
      var decode = jsonDecode(response.body);
      resData = ResponseTransaction.fromJson(decode);
      print("${resData.message}");
    } catch (e) {
      print('Error Occurred' + e.toString());
    }
    return resData;
  }
}
