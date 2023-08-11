import 'package:flutter/material.dart';
import 'package:neucalcu/ui/record/records_page.dart';
import 'package:neucalcu/ui/setting/settings_page.dart';
import 'package:neucalcu/ui/widgets/custom_icon_button.dart';
import 'package:neucalcu/utils/utilities.dart';

class CalculatorAppbar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(height: 25.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CustomIconButton(
              icon: Icons.percent,
              size: 25.0,
              onPressed: () => Navigator.pushNamed(
                context,
                SettingsPage.id,
              ),
            ),
            Text('NeuCalcu', style: appBarStyle(context)),
            CustomIconButton(
              icon: Icons.history,
              size: 25.0,
              onPressed: () => Navigator.pushNamed(
                context,
                RecordsPage.id,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
