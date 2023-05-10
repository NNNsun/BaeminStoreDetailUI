import 'package:flutter/material.dart';
import 'package:rect_getter/rect_getter.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:store_test/data.dart';

import 'store_appbar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

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
    print(value);
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
    return FAppBar(
      data: data,
      context: context,
      expandedHeight: expandedHeight,
      // 期許展開的高度
      collapsedHeight: collapsedHeight,
      // 折疊高度
      isCollapsed: isCollapsed,
      onCollapsed: onCollapsed,
      tabController: tabController,
      onTap: (index) => animateAndScrollTo(index),
    );
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

class CategorySection extends StatelessWidget {
  TextTheme _textTheme(context) => Theme.of(context).textTheme;

  const CategorySection({
    Key? key,
    required this.category,
  }) : super(key: key);

  final Category category;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      margin: const EdgeInsets.only(bottom: 16),
      color: Colors.blueAccent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTileHeader(context),
          _buildFoodTileList(context),
        ],
      ),
    );
  }

  /// Section Title
  Widget _buildFoodTileList(BuildContext context) {
    return Column(
      children: List.generate(
        category.foods.length,
        (index) {
          final food = category.foods[index];
          bool isLastIndex = index == category.foods.length - 1;
          return _buildFoodTile(
            food: food,
            context: context,
            isLastIndex: isLastIndex,
          );
        },
      ),
    );
  }

  /// FSection Header
  Widget _buildSectionTileHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        _sectionTitle(context),
        const SizedBox(height: 8.0),
        category.subtitle != null
            ? _sectionSubtitle(context)
            : const SizedBox(),
        const SizedBox(height: 16),
      ],
    );
  }

  /// Section Title 的 title
  Widget _sectionTitle(BuildContext context) {
    return Row(
      children: [
        if (category.isHotSale) _buildSectionHotSaleIcon(),
        Text(
          category.title,
          style: _textTheme(context).titleLarge,

          // strutStyle: Helper.buildStrutStyle(_textTheme(context).headline6),
        )
      ],
    );
  }

  /// section Title 的 subTitle
  Widget _sectionSubtitle(BuildContext context) {
    return Text(
      category.subtitle!,
      style: _textTheme(context).titleSmall,
    );
  }

  /// Section body 的 Food 樣式。
  Widget _buildFoodTile({
    required BuildContext context,
    required bool isLastIndex,
    required Food food,
  }) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildFoodDetail(food: food, context: context),
            _buildFoodImage(food.imageUrl),
          ],
        ),
        !isLastIndex ? const Divider(height: 16.0) : const SizedBox(height: 8.0)
      ],
    );
  }

  /// food Image
  Widget _buildFoodImage(String url) {
    return Image.asset(
      'asset/illust02.png',
      height: 40,
      fit: BoxFit.cover,
    );
  }

  /// food Detail
  Widget _buildFoodDetail({
    required BuildContext context,
    required Food food,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(food.name, style: _textTheme(context).titleMedium),
        const SizedBox(height: 16),
        Row(
          children: [
            Text(
              "特價${food.price} ",
              style: _textTheme(context).bodySmall,
            ),
            Text(
              food.comparePrice,
              style: _textTheme(context)
                  .bodySmall
                  ?.copyWith(decoration: TextDecoration.lineThrough),
            ),
            const SizedBox(width: 8.0),
            if (food.isHotSale) _buildFoodHotSaleIcon(),
          ],
        ),
      ],
    );
  }

  /// Section HotSale Icon
  Widget _buildSectionHotSaleIcon() {
    return Container(
      margin: const EdgeInsets.only(right: 4.0),
      child: const Icon(
        Icons.whatshot,
        color: Colors.red,
        size: 20.0,
      ),
    );
  }

  /// Food HotSale Icon
  Widget _buildFoodHotSaleIcon() {
    return Container(
      padding: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: const Icon(Icons.whatshot, color: Colors.amber, size: 16.0),
    );
  }
}
