import 'dart:convert' as convert;

import 'package:catdemo/models/random_image_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main(List<String> arguments) async {
  var url = Uri.https('https://api.thecatapi.com/v1/images/search');

  var response = await http.get(url);

  if (response.statusCode == 200) {
    var jsonResponse = convert.jsonDecode(response.body);

    var randomModel = RandomModel.fromJson(jsonResponse[0]);
    debugPrint('ID: ${randomModel.id}');
    debugPrint('URL: ${randomModel.url}');
    debugPrint('Width: ${randomModel.width}');
    debugPrint('Height: ${randomModel.height}');
  } else {
    debugPrint("Request Faild with status: ${response.statusCode}");
  }
}
