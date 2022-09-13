import 'package:flutter/material.dart';

class StackedSideAlphabetBar<T> extends StatefulWidget {
  final Map<String, List<T>> alphabetListMap;
  final String selectedAlphabet;
  final void Function(String newVal) updateSelectedAlphabet;
  final double alphabetBarItemHeight;
  final Color alphabetBarSelectedItemColor;
  final bool isBorderedAlphabetBar;
  final double alphabetBarWidth;
  final EdgeInsetsGeometry alphabetBarMargin;
  final TextStyle selectedAlphabetTextStyle;
  final TextStyle unSelectedAlphabetTextStyle;

  const StackedSideAlphabetBar({
    Key? key,
    required this.alphabetListMap,
    required this.selectedAlphabet,
    required this.updateSelectedAlphabet,
    required this.alphabetBarItemHeight,
    required this.alphabetBarSelectedItemColor,
    required this.isBorderedAlphabetBar,
    required this.alphabetBarWidth,
    required this.alphabetBarMargin,
    required this.selectedAlphabetTextStyle,
    required this.unSelectedAlphabetTextStyle,
  }) : super(key: key);

  @override
  State<StackedSideAlphabetBar> createState() => _StackedSideAlphabetBarState();
}

class _StackedSideAlphabetBarState extends State<StackedSideAlphabetBar> {
  Map<String, double> alphabetBarScrollOffsetMap = {
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
    '#': 0,
  };
  late ValueNotifier<Offset> alphabetOffsetValueNotifer;
  @override
  void initState() {
    int index = 0;
    for (var element in alphabetBarScrollOffsetMap.entries) {
      alphabetBarScrollOffsetMap[element.key] =
          widget.alphabetBarItemHeight * index;
      index++;
    }
    alphabetOffsetValueNotifer = ValueNotifier(const Offset(0.0, 0.0));
    alphabetOffsetValueNotifer.addListener(() {
      _addOverlay(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      margin: widget.alphabetBarMargin,
      width: widget.alphabetBarWidth,
      decoration: BoxDecoration(
        border: widget.isBorderedAlphabetBar
            ? Border.all(
                width: 1,
              )
            : const Border(),
        borderRadius: BorderRadius.circular(16),
      ),
      child: GestureDetector(
        onVerticalDragCancel: () {},
        onVerticalDragDown: (DragDownDetails dragDownDetails) {},
        onVerticalDragEnd: (DragEndDetails dragEndDetails) {
          _removeOverlay();
        },
        onVerticalDragStart: (DragStartDetails dragStartDetails) {
          alphabetOffsetValueNotifer.value = dragStartDetails.globalPosition;
        },
        onVerticalDragUpdate: (DragUpdateDetails dragUpdateDetails) {
          if (!(dragUpdateDetails.localPosition.dy <
                  alphabetBarScrollOffsetMap.entries.first.value ||
              dragUpdateDetails.localPosition.dy >
                  alphabetBarScrollOffsetMap.entries.last.value + 16)) {
            widget.updateSelectedAlphabet(
              alphabetBarScrollOffsetMap.entries
                  .firstWhere((element) =>
                      element.value - dragUpdateDetails.localPosition.dy >=
                          -16 &&
                      element.value - dragUpdateDetails.localPosition.dy < 0)
                  .key,
            );
            alphabetOffsetValueNotifer.value = dragUpdateDetails.globalPosition;
          }
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: widget.alphabetListMap.keys
              .map(
                (key) => Container(
                  height: widget.alphabetBarItemHeight,
                  decoration: BoxDecoration(
                    color: widget.selectedAlphabet == key
                        ? widget.alphabetBarSelectedItemColor
                        : Colors.transparent,
                  ),
                  child: Center(
                    child: GestureDetector(
                      onTap: () {
                        widget.updateSelectedAlphabet(key);
                      },
                      child: Text(
                        key,
                        style: widget.selectedAlphabet == key
                            ? widget.selectedAlphabetTextStyle
                            : widget.unSelectedAlphabetTextStyle,
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  static OverlayEntry? overlayEntry;

  void _addOverlay(BuildContext context) {
    OverlayState? overlayState = Overlay.of(context);
    if (overlayState == null) return;
    if (overlayEntry == null) {
      overlayEntry = OverlayEntry(
        builder: (BuildContext ctx) {
          return ValueListenableBuilder(
            valueListenable: alphabetOffsetValueNotifer,
            builder: (context, _, __) {
              return Positioned(
                left: MediaQuery.of(context).size.width -
                    48 -
                    widget.alphabetBarWidth -
                    widget.alphabetBarMargin.horizontal,
                top: alphabetOffsetValueNotifer.value.dy - 16,
                child: Material(
                  color: Colors.transparent,
                  child: AnimatedContainer(
                    height: 42,
                    width: 42,
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    decoration: BoxDecoration(
                      border: Border.all(width: 1),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        widget.selectedAlphabet,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      );
      overlayState.insert(overlayEntry!);
    } else {
      overlayEntry?.markNeedsBuild();
    }
  }

  void _removeOverlay() {
    overlayEntry?.remove();
    overlayEntry = null;
  }
}
