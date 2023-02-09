import 'package:flutter/material.dart';

import 'data.dart';

class StoreAppbar extends SliverAppBar {
  final bool isCollacpsed;
  final void Function(int index) onTap;
  final void Function(bool isCollapsed) onCollapsed;
  final TabController tabController;
  const StoreAppbar(
    this.tabController,
    this.onTap,
    this.onCollapsed, {
    required this.isCollacpsed,
  });

  @override
  Color? get backgroundColor => Colors.amber;

  @override
  Widget? get leading {
    return IconButton(onPressed: () {}, icon: const Icon(Icons.arrow_back));
  }

  @override
  List<Widget>? get actions {
    return [
      IconButton(
        icon: const Icon(Icons.home_outlined),
        onPressed: () {},
      ),
      IconButton(
        icon: const Icon(Icons.star),
        onPressed: () {},
      ),
    ];
  }

  @override
  Widget? get title {
    // AnimatedOpacity => https://api.flutter.dev/flutter/widgets/AnimatedOpacity-class.html
    return AnimatedOpacity(
      // 0 == invisible, 1 == visible
      opacity: isCollacpsed ? 0 : 1, // 判斷 SliverAppBar 是展開還是縮小。
      duration: const Duration(milliseconds: 250),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            "癮茶",
          ),
          SizedBox(height: 4.0),
          Text('text'),
        ],
      ),
    );
  }

  @override
  PreferredSizeWidget? get bottom {
    return PreferredSize(
      preferredSize: const Size.fromHeight(48),
      child: Container(
        color: Colors.green,
        child: TabBar(
          isScrollable: true,
          // 是否可以滾動
          controller: tabController,
          // https://api.flutter.dev/flutter/material/TabController-class.html
          indicatorPadding: const EdgeInsets.symmetric(horizontal: 16.0),
          indicatorColor: Colors.black,
          // tabBar 下面一條線的顏色
          labelColor: Colors.pink,
          // 被選到標籤顏色
          unselectedLabelColor: Colors.red,
          // 為被選到的顏色
          indicatorWeight: 3.0,
          // 下面標籤的高度
          tabs: ExampleData.data.categories.map((e) {
            return Tab(text: e.title);
          }).toList(),
          // 想要把 list 裡面的 data 轉換成 Widget
          onTap: onTap,
        ),
      ),
    );
  }

  @override
  Widget? get flexibleSpace {
    return LayoutBuilder(
      builder: (
        BuildContext context,
        BoxConstraints constraints,
      ) {
        // 現在整塊 flexibleSpace 的高度
        final top = constraints.constrainHeight();
        final collapsedHight =
            MediaQuery.of(context).viewPadding.top + kToolbarHeight + 48;
        // 尚未展開的 flexibleSpace 高度。
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          // 此時如果立刻執行下面的代碼，是獲取不到 BuildContext，因為 widget 還沒有完成繪製
          // addPostFrameCallback 是 StatefulWidget 渲染結束的回調，只會被調用一次，之後 StatefulWidget 需要刷新 UI 也不會被調用
          onCollapsed(collapsedHight != top); // 利用 callback 轉換傳遞現在的 isCollapsed
        });

        return FlexibleSpaceBar(
          collapseMode: CollapseMode.pin, // 展開模式
          background: Column(
            children: [
              Stack(
                children: [
                  Column(
                    children: [
                      HeaderClip(data: ExampleData.data, context: context),
                      // 餐廳上方圖片，有形狀的那個。
                      const SizedBox(height: 90),
                    ],
                  ),
                ],
              ),
              DiscountCard(
                title: ExampleData.data.optionalCard.title,
                subtitle: ExampleData.data.optionalCard.subtitle,
              ),
            ],
          ),
        );
      },
    );
  }
}
