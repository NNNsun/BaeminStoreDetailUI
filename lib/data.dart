class ExampleData {
  ExampleData._internal();

  /// 飲料的圖片
  static List<String> images = ['asset/illust02.png'];

  /// 全部的資料
  static PageData data = PageData(
    title: " 癮茶",
    deliverTime: "外送 15 分鐘",
    bannerText: "指定地區使用線上支付，滿\$150現折\$30,輸入優惠碼【AUT30】,秋高Chill爽立即點!",
    backgroundUrl: 'asset/illust02.png',
    rate: 4.2,
    rateQuantity: 331,
    optionalCard: OptionalCard(
      title: "折扣 30%",
      subtitle: "On the entire menu",
    ),
    categories: [
      category1,
      category2,
      category3,
      category4,
      category4,
      category4,
      category3,
    ],
  );

  /// 每一個 section 的資料
  static Category category1 = Category(
    title: "人氣精選",
    subtitle: "大家都點這些 👇 手刀點起來",
    isHotSale: true,
    foods: List.generate(
      5,
      (index) {
        return Food(
          name: "冰淇淋紅茶",
          price: "40",
          comparePrice: "\$35",
          imageUrl: 'asset/illust02.png',
          isHotSale: index == 3 ? true : false,
        );
      },
    ),
  );

  static Category category2 = Category(
    title: "明星商品",
    subtitle: null,
    isHotSale: false,
    foods: List.generate(
      3,
      (index) {
        return Food(
          name: "耶果青茶",
          price: "35",
          comparePrice: "\$30",
          imageUrl: images[index % images.length],
          isHotSale: index == 2 ? true : false,
        );
      },
    ),
  );

  static Category category3 = Category(
    title: "找奶茶",
    subtitle: null,
    isHotSale: false,
    foods: List.generate(
      1,
      (index) {
        return Food(
          name: "波霸奶茶",
          price: "40",
          comparePrice: "\$35",
          imageUrl: images[index % images.length],
          isHotSale: false,
        );
      },
    ),
  );

  static Category category4 = Category(
    title: "找拿鐵",
    subtitle: null,
    isHotSale: false,
    foods: List.generate(
      5,
      (index) {
        return Food(
          name: "紅茶拿鐵",
          price: "40",
          comparePrice: "\$35",
          imageUrl: 'asset/illust02.png',
          isHotSale: index == 3 ? true : false,
        );
      },
    ),
  );
}

class PageData {
  String title;
  String deliverTime;
  String bannerText;
  String backgroundUrl;

  double rate;
  int rateQuantity;

  OptionalCard optionalCard;
  List<Category> categories;

  PageData({
    required this.title,
    required this.deliverTime,
    required this.bannerText,
    required this.backgroundUrl,
    required this.rate,
    required this.rateQuantity,
    required this.optionalCard,
    required this.categories,
  });
}

class OptionalCard {
  String title;
  String subtitle;
  OptionalCard({
    required this.title,
    required this.subtitle,
  });
}

class Category {
  String title;
  String? subtitle;
  List<Food> foods;
  bool isHotSale;

  Category({
    required this.title,
    required this.subtitle,
    required this.foods,
    required this.isHotSale,
  });
}

class Food {
  String name;
  String price;
  String comparePrice;
  String imageUrl;
  bool isHotSale;

  Food({
    required this.name,
    required this.price,
    required this.comparePrice,
    required this.imageUrl,
    required this.isHotSale,
  });
}
