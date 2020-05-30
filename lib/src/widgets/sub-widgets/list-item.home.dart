import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:listify/src/components/list/index.dart';
import 'package:listify/src/data/list-data.dart';
import 'package:listify/src/widgets/pages/add-list.dart';
import 'package:momentum/momentum.dart';
import 'package:relative_scale/relative_scale.dart';

class ListItemHome extends StatelessWidget {
  final int i;
  final ListData listData;

  const ListItemHome({
    Key key,
    this.i,
    this.listData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _listController = Momentum.of<ListController>(context);
    return RelativeBuilder(
      builder: (context, screenHeight, screenWidth, sy, sx) {
        IconData icon;
        Color color;
        var checkState = _listController.getCheckState(i);
        if (checkState == true) {
          icon = Icons.check_circle;
          color = Colors.green;
        }
        if (checkState == false) {
          icon = Icons.crop_square;
          color = Colors.black.withOpacity(0.4);
        }
        if (checkState == null) {
          icon = Icons.remove_circle;
          color = Colors.blue;
        }
        return Card(
          margin: EdgeInsets.only(top: sy(8)),
          child: InkWell(
            onTap: () {},
            child: ListTile(
              leading: Icon(
                icon,
                color: color,
                size: sy(16),
              ),
              title: AutoSizeText(
                listData.listName,
                style: TextStyle(fontSize: sy(11)),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.content_copy,
                      size: sy(18),
                    ),
                    onPressed: () {
                      _listController.createCopy(i);
                      Router.goto(context, AddNewList);
                    },
                    tooltip: 'Create Copy',
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.close,
                      size: sy(18),
                      color: Colors.red,
                    ),
                    onPressed: () {
                      _listController.removeItem(i);
                    },
                    tooltip: 'Remove Item',
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
