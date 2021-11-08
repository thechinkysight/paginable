import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:paginablelistview_example/paginable_listview_separated.dart';
import './paginable_listview_builder.dart';

void main() => runApp(
      const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Home(),
      ),
    );

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late List<Widget> views;

  late int selectedIndex;

  late void Function(int) onItemTapped;

  late PageStorageBucket bucket;

  @override
  void initState() {
    super.initState();
    views = [
      const PaginableListViewBuilder(
        key: PageStorageKey('PAGINABLE_LISTVIEW_BUILDER'),
      ),
      const PaginableListViewSeparated(
        key: PageStorageKey('PAGINABLE_LISTVIEW_SEPARATED'),
      ),
    ];
    selectedIndex = 0;
    onItemTapped = (index) => setState(() {
          selectedIndex = index;
        });

    bucket = PageStorageBucket();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('PaginableListView'),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: onItemTapped,
          items: const [
            BottomNavigationBarItem(
              label: 'Builder',
              icon: Icon(Icons.reorder_rounded),
            ),
            BottomNavigationBarItem(
              label: 'Separated',
              icon: Icon(Icons.vertical_split_rounded),
            ),
          ],
        ),
        body: PageStorage(
          bucket: bucket,
          child: views.elementAt(selectedIndex),
        ),
      ),
    );
  }
}
