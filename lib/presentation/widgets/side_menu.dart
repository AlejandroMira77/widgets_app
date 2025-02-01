import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:widgets_app/config/menu/menu_items.dart';

class SideMenu extends StatefulWidget {

  final GlobalKey<ScaffoldState> scaffoldKey;

  const SideMenu({
    super.key,
    required this.scaffoldKey
  });

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {

  int navDrawerIndex = 0;

  @override
  Widget build(BuildContext context) {

    // valida el tamaño del notch del dispositivo
    final hasNotch = MediaQuery.of(context).viewPadding.top > 35;

    return NavigationDrawer( // es un widget para realizar un menu lateral
      selectedIndex: navDrawerIndex,
      onDestinationSelected: (value) {
        setState(() {
          navDrawerIndex = value;
        });
        final menuItem = appMenuItems[value];
        context.push(menuItem.link);
        widget.scaffoldKey.currentState?.closeDrawer();
      },
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(28, hasNotch ? 10 : 20, 16, 10),
          child: const Text('Main'),
        ),
        // recorremos el array y dentro agregamos el navigationDrawer
        ...appMenuItems
        .sublist(0,3) // solo carga los 3 primeros elementos
        .map((item) => NavigationDrawerDestination(
          icon: Icon(item.icon),
          label: Text(item.title)
        )),
        const Padding(
          padding: EdgeInsets.fromLTRB(28, 16, 28, 10),
          child: Divider(),
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(28, 10, 16, 10),
          child: Text('More options'),
        ),
        ...appMenuItems
        .sublist(3) // toma desde el 3 en adelante
        .map((item) => NavigationDrawerDestination(
          icon: Icon(item.icon),
          label: Text(item.title)
        )),
      ],
    );
  }
}