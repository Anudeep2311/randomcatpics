import 'dart:convert' as convert;

import 'package:catdemo/models/random_image_model.dart';
import 'package:http/http.dart' as http;

void main(List<String> arguments) async {
  var url = Uri.https('https://api.thecatapi.com/v1/images/search');

  var response = await http.get(url);

  if (response.statusCode == 200) {
    var jsonResponse = convert.jsonDecode(response.body);

    var randomModel = RandomModel.fromJson(jsonResponse[0]);
    print('ID: ${randomModel.id}');
    print('URL: ${randomModel.url}');
    print('Width: ${randomModel.width}');
    print('Height: ${randomModel.height}');
  } else {
    print("Request Faild with status: ${response.statusCode}");
  }
}
