import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:paginablesliverchildbuilderdelegate_example/paginable_sliver_child_builder_delegate_builder.dart';
import 'package:paginablesliverchildbuilderdelegate_example/paginable_sliver_child_builder_delegate_separated.dart';

void main() => runApp(
      const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Home(),
      ),
    );

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
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
      const PaginableSliverChildBuilderDelegateBuilder(
        key: PageStorageKey('PAGINABLESLIVERCHILDBUILDERDELEGATE_BUILDER'),
      ),
      const PaginabelSliverChildBuilderDelegatedSeparated(
        key: PageStorageKey('PAGINABLESLIVERCHILDBUILDERDELEGATE_SEPARATED'),
      )
    ];
    selectedIndex = 0;
    onItemTapped = (index) => setState(() {
          selectedIndex = index;
        });
    bucket = PageStorageBucket();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
