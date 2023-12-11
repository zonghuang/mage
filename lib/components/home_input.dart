import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:mage/data/constants/art_style.dart';
import 'package:mage/helper/get_random_fileName.dart';
import 'package:mage/models/aliyun.dart';
import 'package:mage/models/art_style.dart';

class HomeInput extends StatelessWidget {
  const HomeInput({super.key});

  Future<void> uploadImage(context) async {
    final ImagePicker picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      try {
        var aliyunModel = Provider.of<AliyunModel>(context, listen: false);
        var artStyleModel = Provider.of<ArtStyleModel>(context, listen: false);
        artStyleModel.updateIsUploading(true);
        var imgUrl = await aliyunModel.putObjectFile(
            pickedFile.path, 'prod/input/${getRandomFileName()}');
        artStyleModel.artStyleForm.qrCodeImage = imgUrl;
        artStyleModel.updateArtStyleForm();
        artStyleModel.updateIsUploading(false);
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.uploadFailure),
            action: SnackBarAction(
              label: 'Ok',
              onPressed: () {},
            ),
            width: 188.0,
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        );
      }
    } else {
      print('No image selected.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 350,
      child: Consumer<ArtStyleModel>(
        builder: (context, artStyleModel, child) => Column(
          children: [
            Container(
              width: 350,
              padding: const EdgeInsets.all(8),
              child: SegmentedButton<Options>(
                segments: <ButtonSegment<Options>>[
                  ButtonSegment<Options>(
                    value: Options.picture,
                    label: Text(
                      AppLocalizations.of(context)!.mode('picture'),
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                  ButtonSegment<Options>(
                    value: Options.text,
                    label: Text(
                      AppLocalizations.of(context)!.mode('text'),
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                  ButtonSegment<Options>(
                    value: Options.prompt,
                    label: Text(
                      AppLocalizations.of(context)!.mode('prompt'),
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ],
                selected: artStyleModel.artStyleForm.mode,
                onSelectionChanged: (Set<Options> newSelection) {
                  var artStyleModel =
                      Provider.of<ArtStyleModel>(context, listen: false);
                  artStyleModel.artStyleForm.mode = newSelection;
                  artStyleModel.updateArtStyleForm();
                },
              ),
            ),
            Visibility(
              visible: artStyleModel.artStyleForm.mode.first.name ==
                  Options.text.name,
              child: Container(
                width: 350,
                padding: const EdgeInsets.all(8),
                child: TextField(
                  onChanged: (text) {
                    artStyleModel.artStyleForm.qrCodeContent = text;
                  },
                  controller: TextEditingController(
                    text: artStyleModel.artStyleForm.qrCodeContent,
                  ),
                  minLines: 2,
                  maxLines: null,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: AppLocalizations.of(context)!.textTips,
                  ),
                ),
              ),
            ),
            Visibility(
              visible: artStyleModel.artStyleForm.mode.first.name ==
                  Options.picture.name,
              child: Container(
                width: artStyleModel.artStyleForm.qrCodeImage == '' ? 350 : 150,
                padding: const EdgeInsets.all(8),
                child: !artStyleModel.isUploading
                    ? GestureDetector(
                        onTap: () {
                          uploadImage(context);
                        },
                        child: artStyleModel.artStyleForm.qrCodeImage == ''
                            ? Container(
                                height: 88,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.black45, width: 1),
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.add, size: 32),
                                    Text(
                                      AppLocalizations.of(context)!.pictureTips,
                                      style: const TextStyle(
                                          color: Colors.black54),
                                    ),
                                  ],
                                ),
                              )
                            : SizedBox(
                                height: 88,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    imageUrl:
                                        artStyleModel.artStyleForm.qrCodeImage,
                                    placeholder: (context, url) =>
                                        const CircularProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  ),
                                ),
                              ),
                      )
                    : Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(24),
                            width: 88,
                            height: 88,
                            child: const CircularProgressIndicator(),
                          ),
                        ],
                      ),
              ),
            ),
            Visibility(
              visible: artStyleModel.artStyleForm.mode.first.name ==
                  Options.prompt.name,
              child: Container(
                width: 350,
                padding: const EdgeInsets.all(8),
                child: TextField(
                  onChanged: (text) {
                    artStyleModel.artStyleForm.prompt = text;
                  },
                  controller: TextEditingController(
                    text: artStyleModel.artStyleForm.prompt,
                  ),
                  minLines: 2,
                  maxLines: null,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: AppLocalizations.of(context)!.promptTips,
                  ),
                ),
              ),
            ),
            const Padding(padding: EdgeInsets.all(8)),
          ],
        ),
      ),
    );
  }
}
