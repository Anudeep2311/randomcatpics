import 'dart:convert';
import 'package:catdemo/models/random_image_model.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class RandomCatImageProvider with ChangeNotifier {
  RandomModel? _randomModel;

  RandomModel? get randomModel => _randomModel;

  Future<void> fetchRandomImage() async {
    var url = Uri.parse('https://api.thecatapi.com/v1/images/search');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      _randomModel = RandomModel.fromJson(jsonResponse[0]);
      notifyListeners(); // Notify listeners to update UI
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }
}
