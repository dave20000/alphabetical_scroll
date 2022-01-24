import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';

import 'package:alphabetical_scroll/alphabetical_scroll.dart';

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
}

class AlphabetListScreen<T> extends StatefulWidget {
  final List<T> sources;
  final List<String> soruceFilterItemList;
  final double contactItemHeight;
  final AlphabetViewItemBuilder<T> itemBuilder;
  final TextStyle headerTextStyle;
  final EdgeInsetsGeometry contactListPadding;
  final EdgeInsetsGeometry sideAlphabetBarPadding;

  final double alphabetBarItemHeight;
  final Color alphabetBarSelectedItemColor;
  final bool isBorderedAlphabetBar;
  final double alphbaetBarWidth;
  final EdgeInsetsGeometry alphabetBarMargin;

  final TextStyle selectedAlphabetTextStyle;
  final TextStyle unSelectedAlphabetTextStyle;

  final bool hasBorder;
  final bool isHeaderShown;

  final AlphabetItemOnTap<T>? onTap;
  const AlphabetListScreen({
    Key? key,
    required this.sources,
    required this.soruceFilterItemList,
    this.contactItemHeight = 56.0,
    required this.itemBuilder,
    this.onTap,
    this.headerTextStyle = const TextStyle(
      color: Colors.indigo,
      fontSize: 22,
    ),
    this.contactListPadding = const EdgeInsets.only(
      left: 16.0,
      right: 24.0,
      top: 8,
      bottom: 8.0,
    ),
    this.sideAlphabetBarPadding = const EdgeInsets.only(
      top: 16.0,
    ),
    this.alphabetBarItemHeight = 16.0,
    this.alphabetBarSelectedItemColor = Colors.blue,
    this.isBorderedAlphabetBar = true,
    this.alphbaetBarWidth = 24,
    this.alphabetBarMargin = const EdgeInsets.symmetric(horizontal: 2),
    this.selectedAlphabetTextStyle = const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    this.unSelectedAlphabetTextStyle = const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.normal,
      color: Colors.black,
    ),
    this.hasBorder = false,
    this.isHeaderShown = true,
  }) : super(key: key);

  @override
  _AlphabetListScreenState<T> createState() => _AlphabetListScreenState<T>();
}

class _AlphabetListScreenState<T> extends State<AlphabetListScreen<T>> {
  late StickyHeaderController stickyHeaderController;
  late ScrollController listScrollController;

  late String selectedAlphabet;
  late Map<String, List<T>> alphabetListMap;

  int lenToJump = 0;
  Map<String, double> alphabetListScrollOffsetMap = {
    'A': 0,
    'B': 0,
    'C': 0,
    'D': 0,
    'E': 0,
    'F': 0,
    'G': 0,
    'H': 0,
    'I': 0,
    'J': 0,
    'K': 0,
    'L': 0,
    'M': 0,
    'N': 0,
    'O': 0,
    'P': 0,
    'Q': 0,
    'R': 0,
    'S': 0,
    'T': 0,
    'U': 0,
    'V': 0,
    'W': 0,
    'X': 0,
    'Y': 0,
    'Z': 0,
  };

  @override
  void initState() {
    listScrollController = ScrollController();
    stickyHeaderController = StickyHeaderController();
    alphabetListMap = {
      'A': [],
      'B': [],
      'C': [],
      'D': [],
      'E': [],
      'F': [],
      'G': [],
      'H': [],
      'I': [],
      'J': [],
      'K': [],
      'L': [],
      'M': [],
      'N': [],
      'O': [],
      'P': [],
      'Q': [],
      'R': [],
      'S': [],
      'T': [],
      'U': [],
      'V': [],
      'W': [],
      'X': [],
      'Y': [],
      'Z': [],
      '#': [],
    };

    for (int index = 0; index < widget.sources.length; index++) {
      if (widget.soruceFilterItemList[index].startsWith(RegExp(r'[A-Za-z]'))) {
        alphabetListMap[widget.soruceFilterItemList[index][0].capitalize()]!
            .add(widget.sources[index]);
      } else {
        alphabetListMap['#']!.add(widget.sources[index]);
      }
    }

    selectedAlphabet = alphabetListMap.entries.first.key;

    for (var element in alphabetListMap.entries) {
      alphabetListScrollOffsetMap[element.key] =
          lenToJump * widget.contactItemHeight;

      lenToJump += element.value.length;
    }

    stickyHeaderController.addListener(() {
      if (alphabetListScrollOffsetMap
          .containsValue(stickyHeaderController.stickyHeaderScrollOffset)) {
        var mapVal = alphabetListScrollOffsetMap.entries.lastWhere((element) =>
            element.value == stickyHeaderController.stickyHeaderScrollOffset);

        SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
          setState(() {
            selectedAlphabet = mapVal.key;
          });
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: widget.contactListPadding,
          child: ItemsListView<T>(
            onTap: (T hello) {
              widget.onTap!(hello);
            },
            itemBuilder: widget.itemBuilder,
            listScrollController: listScrollController,
            stickyHeaderController: stickyHeaderController,
            alphabetListMap: alphabetListMap,
            contactItemHeight: widget.contactItemHeight,
            headerTextStyle: widget.headerTextStyle,
            hasBorder: widget.hasBorder,
            isHeaderShown: widget.isHeaderShown,
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: widget.sideAlphabetBarPadding,
            child: StackedSideAlphabetBar<T>(
              alphabetListMap: alphabetListMap,
              selectedAlphabet: selectedAlphabet,
              updateSelectedAlphabet: (newVal) async {
                setState(() {
                  selectedAlphabet = newVal;
                });
                int itemLengthToJump = 0;
                for (var entry in alphabetListMap.entries) {
                  if (entry.key == selectedAlphabet) {
                    listScrollController.jumpTo(
                      widget.contactItemHeight * itemLengthToJump,
                    );
                    break;
                  } else {
                    itemLengthToJump += entry.value.length;
                  }
                }
              },
              alphabetBarItemHeight: widget.alphabetBarItemHeight,
              alphabetBarSelectedItemColor: widget.alphabetBarSelectedItemColor,
              alphabetBarMargin: widget.alphabetBarMargin,
              alphbaetBarWidth: widget.alphbaetBarWidth,
              isBorderedAlphabetBar: widget.isBorderedAlphabetBar,
              selectedAlphabetTextStyle: widget.selectedAlphabetTextStyle,
              unSelectedAlphabetTextStyle: widget.unSelectedAlphabetTextStyle,
            ),
          ),
        ),
      ],
    );
  }
}
