
import 'package:flutter/material.dart';

enum TabItem { jobs, entries, account, maps }

class TabItemData {
  const TabItemData({@required this.title, @required this.icon});

  final String title;
  final IconData icon;

  static const Map<TabItem, TabItemData> allTabs = {
    TabItem.jobs: TabItemData(title: 'Activités', icon: Icons.work),
    TabItem.entries: TabItemData(title: 'Bilan', icon: Icons.calendar_view_day),
    TabItem.account: TabItemData(title: 'Compte', icon: Icons.person),
    TabItem.maps: TabItemData(title: 'Maps', icon: Icons.map),
  };
}