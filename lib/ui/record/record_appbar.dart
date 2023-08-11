import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:neucalcu/models/record.dart';
import 'package:neucalcu/ui/widgets/custom_icon_button.dart';
import 'package:neucalcu/utils/utilities.dart';

class RecordAppbar extends StatelessWidget {
  final _recordBox = Hive.box<Record>(boxRecord);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(height: 25.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            CustomIconButton(
              icon: Icons.arrow_left,
              onPressed: () => Navigator.pop(context),
            ),
            Text('Record History', style: appBarStyle(context)),
            CustomIconButton(
              icon: Icons.traffic,
              onPressed: () {
                _recordBox..clear();
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ],
    );
  }
}
