import 'dart:io';
import 'package:dio/dio.dart';
import 'package:startup_boilerplate/utils/constants/imports.dart';
import 'package:http/http.dart' as http;
import 'package:startup_boilerplate/controllers/common/sp_controller.dart';
import 'package:startup_boilerplate/models/common/common_data_model.dart';

class ApiServices {

  CommonDM convertToCommonObject(apiResponse) {
    return CommonDM.fromJson(apiResponse);
  }

  void timeOutFunction() {
    String error = ksConnectionTimeoutMessage;
    if (!Get.isSnackbarOpen) {
      showSnackBar(title: ksError, message: error, color: cRedColor);
    }
  }

  Future<http.Response> methodBasedResponse({
    required String method,
    required String? token,
    Map<String, dynamic>? body,
    required Uri uri,
    int? timer,
    required http.Client client,
  }) async {
    if (method == get) {
      return await client.get(
        uri,
        headers: {
          if (token != null) 'Authorization': 'Bearer $token',
        },
      ).timeout(
        Duration(seconds: timer ?? 30),
        onTimeout: () {
          timeOutFunction();
          throw TimeoutException(ksConnectionTimeoutMessage.tr);
        },
      );
    } else if (method == post) {
      return await client.post(
        uri,
        body: body,
        headers: {
          if (token != null) 'Authorization': 'Bearer $token',
        },
      ).timeout(
        Duration(seconds: timer ?? 30),
        onTimeout: () {
          timeOutFunction();
          throw TimeoutException(ksConnectionTimeoutMessage.tr);
        },
      );
    } else if (method == put) {
      return await client.post(
        uri,
        body: body,
        headers: {
          if (token != null) 'Authorization': 'Bearer $token',
        },
      ).timeout(
        Duration(seconds: timer ?? 30),
        onTimeout: () {
          timeOutFunction();
          throw TimeoutException(ksConnectionTimeoutMessage.tr);
        },
      );
    } else {
      return await client.delete(
        uri,
        body: body,
        headers: {
          if (token != null) 'Authorization': 'Bearer $token',
        },
      ).timeout(
        Duration(seconds: timer ?? 30),
        onTimeout: () {
          timeOutFunction();
          throw TimeoutException(ksConnectionTimeoutMessage.tr);
        },
      );
    }
  }

  //* Common Api call
  Future<dynamic> commonApiCall({
    String? token,
    required String url,
    Map<String, dynamic>? body,
    required String requestMethod,
    int? timer,
  }) async {
    ll("Url : $url");
    final http.Client client = http.Client();
    final Uri uri = Uri.parse(Environment.apiUrl + url);
    ll("uri : $uri");
    ll('body: $body');
    http.Response response;
    String error = ksSomethingWentWrong.tr;

    try {
      response = await methodBasedResponse(
        method: requestMethod,
        token: token,
        body: body,
        uri: uri,
        timer: timer,
        client: client,
      );
      ll("response statusCode : ${response.statusCode}");
      if (response.statusCode == 200) {
        final object = json.decode(response.body.toString());
        final prettyString = const JsonEncoder.withIndent('  ').convert(object);
        ll("Response : $prettyString");
        // CommonDM cm = convertToCommonObject(jsonDecode(response.body));
        // return cm;
        return jsonDecode(response.body);
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        await SpController().onLogout();
        Get.offAllNamed(krHome);
        showSnackBar(title: ksError.tr, message: ksUnAuthorizedError.tr, color: cRedColor);
        return null;
      } else {
        if (!Get.isSnackbarOpen) {
          showSnackBar(title: "${response.statusCode} ${ksError.tr}", message: error, color: cRedColor);
        }
        return null;
      }
    } on SocketException {
      error = ksNoInternetConnectionMessage.tr;
      if (!Get.isSnackbarOpen) {
        showSnackBar(title: ksError.tr, message: error, color: cRedColor);
      }
      return null;
    } catch (e) {
      ll(e.toString());
      if (!Get.isSnackbarOpen) {
        showSnackBar(title: ksError.tr, message: error, color: cRedColor);
      }
      return null;
    } finally {
      client.close();
    }
  }

  // dio post type of request
  Future<dynamic> commonPostDio({
    required String url,
    required String? token,
    required body,
    int? timer,
  }) async {
    ll("Url : $url");
    Dio dio = Dio();
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers["authorization"] = "Bearer $token";
    String error = ksSomethingWentWrong.tr;
    try {
      var response = await dio.post(Environment.apiUrl + url, data: body).timeout(Duration(seconds: timer ?? 60), onTimeout: () {
        error = ksConnectionTimeoutMessage.tr;
        showSnackBar(title: ksError.tr, message: error, color: cRedColor);
        throw TimeoutException(ksConnectionTimeoutMessage.tr);
      });
      ll("response statusCode : ${response.statusCode}");
      if (response.statusCode == 200) {
        final object = json.decode(response.toString());
        final prettyString = const JsonEncoder.withIndent('  ').convert(object);
        ll("Response : $prettyString");
        CommonDM cm = convertToCommonObject(response.data);
        return cm;
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        await SpController().onLogout();
        Get.offAllNamed(krHome);
        showSnackBar(title: ksError.tr, message: ksUnAuthorizedError.tr, color: cRedColor);
        return null;
      } else {
        if (!Get.isSnackbarOpen) {
          showSnackBar(title: "${ksError.tr}${response.statusCode}", message: error, color: cRedColor);
        }
        return null;
      }
    } on DioException catch (e) {
      if (e.error is SocketException) {
        error = ksNoInternetConnectionMessage.tr;
        showSnackBar(title: ksError.tr, message: error, color: cRedColor);

        return null;
      } else {
        ll(e.toString());
        showSnackBar(title: ksError.tr, message: error, color: cRedColor);
        return null;
      }
    } finally {
      dio.close();
    }
  }

  Future<dynamic> mediaUpload({
    String? token,
    required String url,
    required dynamic key,
    required dynamic value,
    Map<String, String>? body,
    int? timer,
  }) async {
    final Uri uri = Uri.parse(Environment.apiUrl + url);
    http.MultipartRequest request = http.MultipartRequest(post, uri);
    String error = ksSomethingWentWrong.tr;
    try {
      request.headers.addAll(
        {
          'Authorization': 'Bearer $token',
          'content-Type': 'multipart/form-data',
        },
      );
      // If image is a file on disk, use fromPath instead of fromBytes
      request.files.add(await http.MultipartFile.fromPath(key, value));
      request.fields.addAll(body ?? {});

      var response = await request.send();
      ll("response statusCode : ${response.statusCode}");
      if (response.statusCode == 200) {
        String res = '';
        await for (var chunk in response.stream) {
          res += utf8.decode(chunk);
        }
        Map<String, dynamic> de = jsonDecode(res);
        CommonDM cm = convertToCommonObject(de);
        return cm;
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        await SpController().onLogout();
        Get.offAllNamed(krHome);
        showSnackBar(title: ksError.tr, message: ksUnAuthorizedError.tr, color: cRedColor);
        return null;
      } else {
        if (!Get.isSnackbarOpen) {
          showSnackBar(title: "${response.statusCode} ${ksError.tr}", message: error, color: cRedColor);
        }
        return null;
      }
    } catch (e) {
      ll(e.toString());
      if (!Get.isSnackbarOpen) {
        showSnackBar(title: ksError.tr, message: error, color: cRedColor);
      }
      return null;
    }
  }

  Future<dynamic> multiMediaUpload({
    String? token,
    required String url,
    required dynamic key,
    required dynamic values,
    Map<String, String>? body,
    int? timer,
  }) async {
    final Uri uri = Uri.parse(Environment.apiUrl + url);
    http.MultipartRequest request = http.MultipartRequest(post, uri);
    String error = ksSomethingWentWrong.tr;
    try {
      request.headers.addAll(
        {
          'Authorization': 'Bearer $token',
          'content-Type': 'multipart/form-data',
        },
      );
      // If image is a file on disk, use fromPath instead of fromBytes
      for (var value in values) {
        request.files.add(await http.MultipartFile.fromPath(key, value.value.path));
      }
      request.fields.addAll(body ?? {});

      var response = await request.send();
      ll("response statusCode : ${response.statusCode}");
      if (response.statusCode == 200) {
        // var res = (await response.stream.transform(utf8.decoder).first);
        // Map<String, dynamic> de = jsonDecode(res);
        // ll(de['data']);
        // CommonDM cm = convertToCommonObject(de);
        // return cm;
        String res = '';
        await for (var chunk in response.stream) {
          res += utf8.decode(chunk);
        }
        Map<String, dynamic> de = jsonDecode(res);
        CommonDM cm = convertToCommonObject(de);
        return cm;
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        await SpController().onLogout();
        Get.offAllNamed(krHome);
        showSnackBar(title: ksError.tr, message: ksUnAuthorizedError.tr, color: cRedColor);
        return null;
      } else {
        if (!Get.isSnackbarOpen) {
          showSnackBar(title: "${response.statusCode} ${ksError.tr}", message: error, color: cRedColor);
        }
        return null;
      }
    } catch (e) {
      ll(e.toString());
      if (!Get.isSnackbarOpen) {
        showSnackBar(title: ksError.tr, message: error, color: cRedColor);
      }
      return null;
    }
  }

  Future<dynamic> mediaUploadMultipleKeyAndValue({
    String? token,
    required String url,
    required List<String> keys,
    required List<dynamic> values,
    Map<String, String>? body,
    int? timer,
  }) async {
    final Uri uri = Uri.parse(Environment.apiUrl + url);
    http.MultipartRequest request = http.MultipartRequest(post, uri);
    String error = ksSomethingWentWrong.tr;
    try {
      request.headers.addAll(
        {
          'Authorization': 'Bearer $token',
          'content-Type': 'multipart/form-data',
        },
      );
      // If image is a file on disk, use fromPath instead of fromBytes
      // for (int i = 0; i < keyValue.length; i++) {
      //   request.files.add(await http.MultipartFile.fromPath(keyValue[i].entries.fi));
      // }
      for (int i = 0; i < keys.length; i++) {
        request.files.add(await http.MultipartFile.fromPath(keys[i], values[i]));
      }
      // request.files.add(await http.MultipartFile.fromPath(key1, value1));
      // request.files.add(await http.MultipartFile.fromPath(key2, value2));
      request.fields.addAll(body ?? {});

      var response = await request.send();
      ll("response statusCode : ${response.statusCode}");
      if (response.statusCode == 200) {
        var res = (await response.stream.transform(utf8.decoder).first);
        Map<String, dynamic> de = jsonDecode(res);
        ll(de.toString());
        CommonDM cm = convertToCommonObject(de);
        return cm;
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        await SpController().onLogout();
        Get.offAllNamed(krHome);
        showSnackBar(title: ksError.tr, message: ksUnAuthorizedError.tr, color: cRedColor);
        return null;
      } else {
        if (!Get.isSnackbarOpen) {
          showSnackBar(title: "${response.statusCode} ${ksError.tr}", message: error, color: cRedColor);
        }
        return null;
      }
    } catch (e) {
      ll(e.toString());
      if (!Get.isSnackbarOpen) {
        showSnackBar(title: ksError.tr, message: error, color: cRedColor);
      }
      return null;
    }
  }
}
