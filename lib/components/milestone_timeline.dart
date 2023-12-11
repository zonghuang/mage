import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:mage/data/constants/art_style.dart';
import 'package:mage/models/record.dart';
import 'package:mage/helper/format_time.dart';
import 'package:mage/helper/save_image.dart';

class MilestoneTimeline extends StatelessWidget {
  const MilestoneTimeline({super.key});

  Future<void> handleSave(BuildContext context, imgUrl) async {
    // 使用Uri解析URL，并获取路径
    Uri uri = Uri.parse(imgUrl);
    // 通过路径获取图片名称
    String imageName = uri.pathSegments.last;
    var isSuccess = await saveNetworkImage(imgUrl, imageName);
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isSuccess
            ? AppLocalizations.of(context)!.successful
            : AppLocalizations.of(context)!.failure),
        action: SnackBarAction(
          label: AppLocalizations.of(context)!.ok,
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

  @override
  Widget build(BuildContext context) {
    return Consumer<RecordModel>(
      builder: (context, recordModel, child) => Expanded(
        child: recordModel.recordList.isEmpty
            ? Text(AppLocalizations.of(context)!.empty)
            : ListView.builder(
                itemCount: recordModel.recordList.length,
                itemBuilder: (context, index) {
                  final item = recordModel.recordList[index];
                  return Container(
                    padding: index == 0 ? const EdgeInsets.only(top: 10) : null,
                    child: TimeLineWidget(
                      isLast: index == recordModel.recordList.length - 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Text(AppLocalizations.of(context)!
                                    .style(artStylesMap[item.lora]!)),
                              ),
                              Align(
                                // widthFactor: 1,
                                heightFactor: 0.5,
                                child: MenuAnchor(
                                    alignmentOffset: const Offset(-64, 0),
                                    builder: (BuildContext context,
                                        MenuController controller,
                                        Widget? child) {
                                      return IconButton(
                                        onPressed: () {
                                          if (controller.isOpen) {
                                            controller.close();
                                          } else {
                                            controller.open();
                                          }
                                        },
                                        icon: const Icon(Icons.more_horiz),
                                        tooltip: AppLocalizations.of(context)!
                                            .showMenu,
                                      );
                                    },
                                    menuChildren: <MenuItemButton>[
                                      MenuItemButton(
                                        onPressed: () {
                                          handleSave(context, item.result);
                                        },
                                        child: Text(
                                            AppLocalizations.of(context)!
                                                .download),
                                      ),
                                      // MenuItemButton(
                                      //   onPressed: () {
                                      //     print('Delete: $item');
                                      //   },
                                      //   child: const Text('Delete'),
                                      // ),
                                    ]),
                              ),
                            ],
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 4, bottom: 4),
                            child: item.status == 'fulfilled'
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: CachedNetworkImage(
                                      fit: BoxFit.cover,
                                      width: 188,
                                      height: 188,
                                      imageUrl: item.result,
                                      placeholder: (context, url) =>
                                          const CircularProgressIndicator(),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                    ),
                                  )
                                : item.status == 'pending'
                                    ? Container(
                                        padding: const EdgeInsets.all(8),
                                        width: 48,
                                        height: 48,
                                        child:
                                            const CircularProgressIndicator(),
                                      )
                                    : const Text('rejected'),
                          ),
                          Text(formatTime(item.timestamp)),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}

class TimeLineWidget extends StatelessWidget {
  const TimeLineWidget({
    super.key,
    this.isLast = false,
    required this.child,
  });
  final bool isLast;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Column(
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.deepPurple[50],
                ),
                child: Center(
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.deepPurple[300],
                    ),
                  ),
                ),
              ),
              if (isLast)
                const SizedBox.shrink()
              else
                Expanded(
                  child: Container(
                    width: .5,
                    color: Colors.deepPurple[200],
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(child: child),
        ],
      ),
    );
  }
}
