import 'package:SoinConnect/services/app-service.dart';
import 'package:flutter/material.dart';

class MenuItem extends StatelessWidget {
  String menuTitle;
  Icon menuIcon;
  var page;
  MenuItem(this.menuTitle, this.menuIcon, this.page);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(menuTitle),
      leading: menuIcon,
      trailing: Icon(Icons.arrow_right),
      onTap: () async {
        if (menuTitle == "Déconnecter") {
          await AppService().deleteToken();
          Navigator.pop(context);
          Navigator.pushAndRemoveUntil(
              context, MaterialPageRoute(builder: (context) => page),(e) => false);
        } else {
          Navigator.pop(context);
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => page));
        }
      },
    );
  }
}
