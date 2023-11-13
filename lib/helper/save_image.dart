import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

Future<bool> saveNetworkImage(String url, String imageName) async {
  var response =
      await Dio().get(url, options: Options(responseType: ResponseType.bytes));
  final result = await ImageGallerySaver.saveImage(
    Uint8List.fromList(response.data),
    quality: 60,
    name: imageName,
  );
  return result['isSuccess'];
}
