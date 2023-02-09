class ExampleData {
  ExampleData._internal();

  /// 飲料的圖片
  static List<String> images = [
    "https://pixabay.com/get/g604fe6e52ea7830d061de7f7fb3a737f8c5190eb51d3ffa308d4de6d96f269203ebc47717d4a1009dc02d230487c24ea_1280.jpg",
    "https://pixabay.com/get/gfaf3d3204f47667f5f8af5a565f4b22ad65e2b4d88825899ece9056571308e9cc66b0669731075c3c9a2b7abef2aacfd_1280.jpg",
    "https://pixabay.com/get/g17bbabd2482cf07e8fffc63711e06271a610748366c0ecade31288602349aae23385a6e4d3115ec7f06178c2fbde9237_1280.png",
    "https://pixabay.com/get/gf2a7622df422b726b8dd1ee3b2731385ce08685605d43fbe7ea1ae73f45fc5de4dc58fe02f1e9ac43d5c2f418af3a683_1280.jpg",
    "https://pixabay.com/get/g623b27568b176f9749aa491a14ced7f6134da8a5cc11c7a779a8464ad8bb791bf449a020dad4fb97e17ddee617e1bb79_1280.jpg",
  ];

  /// 全部的資料
  static PageData data = PageData(
    title: " 癮茶",
    deliverTime: "外送 15 分鐘",
    bannerText: "指定地區使用線上支付，滿\$150現折\$30,輸入優惠碼【AUT30】,秋高Chill爽立即點!",
    backgroundUrl:
        "https://pixabay.com/get/g7194e36b9eb0644793a67fbb37a6e2517f29507672b1b8a2f11bbb3ef27fe77ea3a4965eccedf6b47cc4f6101af788df_1280.jpg",
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
          imageUrl: images[index % images.length],
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
          imageUrl: images[index % images.length],
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
