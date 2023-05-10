import 'package:flutter/material.dart';

import 'data.dart';

class FAppBar extends SliverAppBar {
  final PageData data;
  final BuildContext context;
  final bool isCollapsed;
  @override
  final double? expandedHeight;
  @override
  final double collapsedHeight;
  final TabController tabController;
  final void Function(bool isCollapsed) onCollapsed;
  final void Function(int index) onTap;

  const FAppBar({
    super.key,
    required this.data,
    required this.context,
    required this.isCollapsed,
    required this.expandedHeight, // 展開的高度。
    required this.collapsedHeight,
    required this.onCollapsed,
    required this.onTap,
    required this.tabController,
  }) : super(
            elevation: 4.0,
            pinned: true,
            forceElevated: true,
            expandedHeight: expandedHeight);

  /// super() 是用來繼承父親 Widget 裡面的屬性 or function
  @override
  Color? get backgroundColor => Colors.white;

  /// SliverBar 的 leading

  /// SliverAppBar 的 actions
  @override
  List<Widget>? get actions {
    return [const Icon(Icons.abc)];
  }

  /// SliverAppBar Title 慢慢出現的動畫，只有在縮小才看得到，subTitle 也寫在這。
  @override
  Widget? get title {
    var textTheme = Theme.of(context).textTheme;
    print(isCollapsed);
    // AnimatedOpacity => https://api.flutter.dev/flutter/widgets/AnimatedOpacity-class.html
    return AnimatedOpacity(
      // 0 == invisible, 1 == visible
      opacity: isCollapsed ? 0 : 1, // 判斷 SliverAppBar 是展開還是縮小。
      duration: const Duration(milliseconds: 250),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "癮茶",
            style: textTheme.titleMedium?.copyWith(color: Colors.red),
          ),
          const SizedBox(height: 4.0),
          Text(
            data.deliverTime,
            style: textTheme.bodySmall?.copyWith(color: Colors.blue),
          ),
        ],
      ),
    );
  }

  /// AppBar 的 bottom 不會被縮小。
  @override
  PreferredSizeWidget? get bottom {
    return PreferredSize(
      preferredSize: const Size.fromHeight(48),
      child: Container(
        color: Colors.amber,
        child: TabBar(
          isScrollable: true,
          // 是否可以滾動
          controller: tabController,
          // https://api.flutter.dev/flutter/material/TabController-class.html
          indicatorPadding: const EdgeInsets.symmetric(horizontal: 16.0),
          indicatorColor: Colors.red,
          // tabBar 下面一條線的顏色
          labelColor: Colors.black12,
          // 被選到標籤顏色
          unselectedLabelColor: Colors.blueAccent,
          // 為被選到的顏色
          indicatorWeight: 3.0,
          // 下面標籤的高度
          tabs: data.categories.map((e) {
            return Tab(text: e.title);
          }).toList(),
          // 想要把 list 裡面的 data 轉換成 Widget
          onTap: onTap,
        ),
      ),
    );
  }

  /// 只有展開才看得到的 FlexibleSpaceBar 屬性
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
                  const Text("dtat"),
                  Container(
                    color: Colors.blueGrey,
                  ),
                  Column(
                    children: [
                      Container(
                        color: Colors.amber,
                      ),
                      const SizedBox(height: 90),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
