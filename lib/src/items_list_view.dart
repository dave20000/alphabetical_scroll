import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';

typedef AlphabetViewItemBuilder<T> = Widget Function(
  BuildContext context,
  T contactInfo,
);

typedef AlphabetItemOnTap<T> = void Function(T item);

class ItemsListView<T> extends StatefulWidget {
  final ScrollController listScrollController;
  final StickyHeaderController stickyHeaderController;
  final Map<String, List<T>> alphabetListMap;
  final double contactItemHeight;
  final AlphabetViewItemBuilder<T> itemBuilder;
  final TextStyle headerTextStyle;
  final AlphabetItemOnTap<T>? onTap;
  final bool hasBorder;
  final bool isHeaderShown;
  const ItemsListView({
    Key? key,
    required this.listScrollController,
    required this.stickyHeaderController,
    required this.alphabetListMap,
    required this.contactItemHeight,
    required this.itemBuilder,
    required this.headerTextStyle,
    this.onTap,
    required this.hasBorder,
    required this.isHeaderShown,
  }) : super(key: key);

  @override
  State<ItemsListView<T>> createState() => _ItemsListViewState<T>();
}

class _ItemsListViewState<T> extends State<ItemsListView<T>> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: widget.listScrollController,
      slivers: widget.alphabetListMap.entries.map(
        (entry) {
          return SliverStickyHeader(
            controller: widget.stickyHeaderController,
            overlapsContent: true,
            header: Align(
              alignment: Alignment.centerLeft,
              child: Visibility(
                visible: widget.isHeaderShown,
                child: Padding(
                  padding: const EdgeInsets.only(top: 14.0),
                  child: Text(
                    entry.key,
                    style: widget.headerTextStyle,
                  ),
                ),
              ),
            ),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return GestureDetector(
                    onTap: () {
                      if (widget.onTap != null) {
                        widget.onTap!(entry.value[index]);
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 24.0),
                      decoration: BoxDecoration(
                        border:
                            widget.hasBorder ? Border.all() : const Border(),
                      ),
                      height: widget.contactItemHeight,
                      // child: ContactTile(
                      //   name: entry.value[index],
                      // ),
                      child: widget.itemBuilder(context, entry.value[index]),
                    ),
                  );
                },
                childCount: entry.value.length,
              ),
            ),
          );
        },
      ).toList(),
    );
  }
}
