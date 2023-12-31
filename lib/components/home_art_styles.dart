import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:mage/data/constants/art_style.dart';
import 'package:mage/models/art_style.dart';

class HomeArtStyles extends StatelessWidget {
  const HomeArtStyles({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// art title
        SizedBox(
          width: 335,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(padding: EdgeInsets.all(14)),
              Text(AppLocalizations.of(context)!.artTitle,
                  style: const TextStyle(fontSize: 16)),
              const Padding(padding: EdgeInsets.all(4)),
            ],
          ),
        ),

        /// art styles
        Consumer<ArtStyleModel>(
          builder: (context, artStyleModel, child) => Wrap(
            spacing: 16, // 间距
            runSpacing: 8, // 行间距
            children: artStyles.map((item) {
              return GestureDetector(
                onTap: () {
                  var artStyleModel =
                      Provider.of<ArtStyleModel>(context, listen: false);
                  artStyleModel.artStyleForm.lora = item['name_cn']!;
                  artStyleModel.updateArtStyleForm();
                },
                child: Column(
                  children: <Widget>[
                    Container(
                      width: 102,
                      height: 62,
                      decoration: artStyleModel.artStyleForm.lora ==
                              item['name_cn']!
                          ? BoxDecoration(
                              border: Border.all(
                                width: 2,
                                color: const Color.fromARGB(255, 126, 87, 194),
                              ),
                              borderRadius: BorderRadius.circular(10),
                            )
                          : null,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          item['url']!,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const Padding(padding: EdgeInsets.all(2)),
                    Text(
                      AppLocalizations.of(context)!.style(item['name']!),
                      style: artStyleModel.artStyleForm.lora == item['name_cn']!
                          ? const TextStyle(
                              fontSize: 12,
                              color: Color.fromARGB(255, 126, 87, 194),
                            )
                          : const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),

        /// padding
        const Padding(padding: EdgeInsets.all(4)),
      ],
    );
  }
}
