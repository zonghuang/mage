import 'package:flutter/material.dart';
import 'package:mage/data/constants/art_style.dart';

class ArtStyleModel extends ChangeNotifier {
  late ArtStyleForm _artStyleForm;
  late String _result = '';
  late bool _isUploading = false;

  ArtStyleModel() {
    _artStyleForm =
        ArtStyleForm('赛博朋克', <Options>{Options.picture}, '', '', '');
  }

  ArtStyleForm get artStyleForm => _artStyleForm;
  String get result => _result;
  bool get isUploading => _isUploading;

  set artStyleForm(ArtStyleForm value) {
    _artStyleForm = value;
    notifyListeners();
  }

  void updateArtStyleForm() {
    notifyListeners();
  }

  void updateResult(value) {
    _result = value;
    notifyListeners();
  }

  void updateIsUploading(value) {
    _isUploading = value;
    notifyListeners();
  }
}

class ArtStyleForm {
  String lora;
  Set<Options> mode;
  String qrCodeContent;
  String qrCodeImage;
  String prompt;

  ArtStyleForm(
    this.lora,
    this.mode,
    this.qrCodeContent,
    this.qrCodeImage,
    this.prompt,
  );
}

class ArtStyleResult {
  final String imgUrl;

  const ArtStyleResult({required this.imgUrl});

  factory ArtStyleResult.fromJson(Map<Object, dynamic> json) {
    return ArtStyleResult(
      imgUrl: json['imgUrl'],
    );
  }
}
