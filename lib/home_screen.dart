import 'package:flutter/material.dart';
import 'package:rect_getter/rect_getter.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:store_test/data.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  /// 使否展開
  bool isCollapsed = false;
  late AutoScrollController scrollController;
  late TabController tabController;

  /// 展開高度
  final double expandedHeight = 500.0;

  /// 頁面資料
  final PageData data = ExampleData.data;

  /// 折疊高度
  final double collapsedHeight = kToolbarHeight;

  /// Instantiate RectGetter
  final wholePage = RectGetter.createGlobalKey();
  Map<int, dynamic> itemKeys = {};

  /// prevent animate when press on tab bar
  /// 避免當我們點擊 tab bar 時，動畫還在動，還在計算。
  bool pauseRectGetterIndex = false;

  @override
  void initState() {
    /// tabController 出使話
    tabController = TabController(length: data.categories.length, vsync: this);
    scrollController = AutoScrollController();
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    tabController.dispose();
    super.dispose();
  }

  /// 取得螢幕可看到的 index 有哪些
  List<int> getVisibleItemsIndex() {
    // get ListView Rect
    Rect? rect = RectGetter.getRectFromKey(wholePage);
    List<int> items = [];
    if (rect == null) return items;
    itemKeys.forEach((index, key) {
      Rect? itemRect = RectGetter.getRectFromKey(key);
      if (itemRect == null) return;
      if (itemRect.top > rect.bottom) return;
      if (itemRect.bottom < rect.top) return;
      items.add(index);
    });

    return items;
  }

  void onCollapsed(bool value) {
    if (isCollapsed == value) return;
    setState(() => isCollapsed = value);
  }

  bool onScrollNotification(ScrollNotification notification) {
    if (pauseRectGetterIndex) return true;
    int lastTabIndex = tabController.length - 1;
    List<int> visibleItems = getVisibleItemsIndex();

    bool reachLastTabIndex = visibleItems.isNotEmpty &&
        visibleItems.length <= 2 &&
        visibleItems.last == lastTabIndex;
    if (reachLastTabIndex) {
      tabController.animateTo(lastTabIndex);
    } else {
      int sumIndex = visibleItems.reduce((value, element) => value + element);
      int middleIndex = sumIndex ~/ visibleItems.length;
      if (tabController.index != middleIndex) {
        tabController.animateTo(middleIndex);
      }
    }
    return false;
  }

  void animateAndScrollTo(int index) {
    pauseRectGetterIndex = true;
    tabController.animateTo(index);
    scrollController
        .scrollToIndex(index, preferPosition: AutoScrollPosition.begin)
        .then((value) => pauseRectGetterIndex = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, //是否延伸body至顶部。
      backgroundColor: Colors.brown,
      body: RectGetter(
        key: wholePage,
        child: NotificationListener<ScrollNotification>(
          onNotification: onScrollNotification,
          child: buildSliverScrollView(),
        ),
      ),
    );
  }

  /// CustomScrollView + SliverList + SliverAppBar
  Widget buildSliverScrollView() {
    return CustomScrollView(
      controller: scrollController,
      slivers: [
        buildAppBar(),
        buildBody(),
      ],
    );
  }

  /// AppBar
  SliverAppBar buildAppBar() {
    return StoreAppbar();
  }

  /// Body
  SliverList buildBody() {
    return SliverList(
      delegate: SliverChildListDelegate(List.generate(
        data.categories.length,
        (index) {
          return buildCategoryItem(index);
        },
      )),
    );
  }

  /// ListItem
  Widget buildCategoryItem(int index) {
    // 建立 itemKeys 的 Key
    itemKeys[index] = RectGetter.createGlobalKey();
    Category category = data.categories[index];
    return RectGetter(
      // 傳GlobalKey，之後可以 RectGetter.getRectFromKey(key) 的方式獲得 Rect
      key: itemKeys[index],
      child: AutoScrollTag(
        key: ValueKey(index),
        index: index,
        controller: scrollController,
        child: CategorySection(category: category),
      ),
    );
  }
}
