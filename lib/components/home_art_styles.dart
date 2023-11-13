import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:mage/data/constants/art_style.dart';
import 'package:mage/models/art_style.dart';

class HomeArtStyles extends StatelessWidget {
  const HomeArtStyles({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// art title
        const SizedBox(
          width: 335,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(padding: EdgeInsets.all(14)),
              Text('Artistic style', style: TextStyle(fontSize: 16)),
              Padding(padding: EdgeInsets.all(4)),
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
                  artStyleModel.artStyleForm.lora = item['name']!;
                  artStyleModel.updateArtStyleForm();
                },
                child: Column(
                  children: <Widget>[
                    Container(
                      width: 102,
                      height: 62,
                      decoration: artStyleModel.artStyleForm.lora ==
                              item['name']!
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
                      item['name']!,
                      style: artStyleModel.artStyleForm.lora == item['name']!
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
