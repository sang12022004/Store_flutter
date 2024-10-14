import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(),
      routes: {
        '/home': (context) => HomeScreen(),
        '/cart': (context) => CartPage(cart: Cart()),
      },
    );
  }
}

enum AppColors {
  darkBackground,
  secondaryBackground,
  primaryAccent,
  lightAccent,
}

Color getColor(AppColors color) {
  switch (color) {
    case AppColors.darkBackground:
      return Color(0xFF35374B);
    case AppColors.secondaryBackground:
      return Color(0xFF344955);
    case AppColors.primaryAccent:
      return Color(0xFF50727B);
    case AppColors.lightAccent:
      return Color(0xFF78A083);
    default:
      return Colors.black;
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, "/home");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: getColor(AppColors.darkBackground),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('Image/logo.png', width: 150, height: 150),
            SizedBox(height: 20),
            Text(
              "Student Management",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: getColor(AppColors.lightAccent),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class Product {
  final String name;
  final String description;
  final double price;

  Product({required this.name, required this.description, required this.price});
}

class Cart {
  Map<Product, int> items = {};

  void addToCart(Product product, int quantity) {
    if (items.containsKey(product)) {
      items[product] = items[product]! + quantity;
    } else {
      items[product] = quantity;
    }
  }

  void removeFromCart(Product product) {
    items.remove(product);
  }

  double getTotalPrice() {
    double total = 0.0;
    items.forEach((product, quantity) {
      total += product.price * quantity;
    });
    return total;
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Cart cart = Cart();
  final List<Product> products = [
    Product(name: "MacBook Air M1", description: "Laptop Apple MacBook Air 13\" với chip M1, RAM 8GB, SSD 256GB, màn hình Retina sắc nét.", price: 1500),
    Product(name: "iPhone 14 Pro", description: "Điện thoại iPhone 14 Pro với chip A16 Bionic, màn hình 120Hz, hệ thống camera chuyên nghiệp.", price: 1200),
    Product(name: "Sony WH-1000XM4", description: "Tai nghe chống ồn Sony WH-1000XM4 với âm thanh chất lượng cao, thời lượng pin dài, và kết nối Bluetooth.", price: 350),
    Product(name: "Apple Watch Series 7", description: "Đồng hồ thông minh Apple Watch Series 7 với màn hình lớn hơn, chống nước và nhiều tính năng theo dõi sức khỏe.", price: 450),
    Product(name: "Samsung Galaxy S22 Ultra", description: "Điện thoại Samsung Galaxy S22 Ultra với bút S Pen tích hợp, camera 108MP và màn hình Dynamic AMOLED.", price: 1300),
    Product(name: "Dell XPS 13", description: "Laptop Dell XPS 13 với màn hình InfinityEdge, Intel Core i7, RAM 16GB, SSD 512GB.", price: 1600),
    Product(name: "Bose SoundLink", description: "Loa Bluetooth Bose SoundLink với âm thanh sống động, kết nối không dây và thời lượng pin dài.", price: 250),
    Product(name: "GoPro HERO10", description: "Camera hành trình GoPro HERO10 với khả năng quay 5.3K, chống nước và nhiều phụ kiện đi kèm.", price: 500),
    Product(name: "PlayStation 5", description: "Máy chơi game PlayStation 5 với bộ vi xử lý mạnh mẽ, hỗ trợ độ phân giải 4K và hiệu suất tuyệt vời.", price: 600),
    Product(name: "Nintendo Switch", description: "Máy chơi game Nintendo Switch với khả năng chuyển đổi linh hoạt giữa máy cầm tay và máy console.", price: 300),
  ];

  List<Product> filteredProducts = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredProducts = products;
  }

  void _filterProducts(String query) {
    List<Product> filteredList = products.where((product) {
      return product.name.toLowerCase().contains(query.toLowerCase());
    }).toList();

    setState(() {
      filteredProducts = filteredList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: searchController,
          decoration: InputDecoration(
            hintText: 'Tìm kiếm sản phẩm...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white),
          ),
          style: TextStyle(color: Colors.white),
          onChanged: (value) {
            _filterProducts(value);
          },
        ),
        backgroundColor: getColor(AppColors.primaryAccent),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => CartPage(cart: cart)));
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: filteredProducts.length,
        itemBuilder: (context, index) {
          final product = filteredProducts[index];
          String shortDescription = product.description.length > 50
              ? product.description.substring(0, 50) + '...'
              : product.description;

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetailPage(product: product, cart: cart),
                ),
              );
            },
            child: Card(
              margin: EdgeInsets.all(10),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          color: getColor(AppColors.secondaryBackground),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.name,
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Text(shortDescription),
                              SizedBox(height: 5),
                              Text('${product.price} VND', style: TextStyle(fontSize: 16)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: () {
                          cart.addToCart(product, 1);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Thêm vào giỏ hàng")));
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(getColor(AppColors.primaryAccent)),
                          padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 20, vertical: 10)),
                        ),
                        child: Text('Thêm giỏ hàng', style: TextStyle(fontSize: 16)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class CartPage extends StatefulWidget {
  final Cart cart;

  CartPage({required this.cart});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  void _confirmDelete(Product product) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Xác nhận"),
          content: Text("Bạn có chắc chắn muốn xóa sản phẩm này khỏi giỏ hàng không?"),
          actions: [
            TextButton(
              child: Text("Hủy"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Xóa"),
              onPressed: () {
                setState(() {
                  widget.cart.removeFromCart(product);
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Đã xóa sản phẩm")));
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Giỏ hàng'),
        backgroundColor: getColor(AppColors.primaryAccent),
      ),
      body: ListView.builder(
        itemCount: widget.cart.items.length,
        itemBuilder: (context, index) {
          final product = widget.cart.items.keys.elementAt(index);
          final quantity = widget.cart.items[product];
          return ListTile(
            leading: Container(
              width: 50,
              height: 50,
              color: getColor(AppColors.secondaryBackground),
            ),
            title: Text(product.name),
            subtitle: Text('Số lượng: $quantity'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: () {
                    setState(() {
                      if (quantity! > 1) {
                        widget.cart.addToCart(product, -1);
                      } else {
                        _confirmDelete(product);
                      }
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    setState(() {
                      widget.cart.addToCart(product, 1);
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    _confirmDelete(product);
                  },
                ),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetailPage(product: product, cart: widget.cart),
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        child: BottomAppBar(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Tổng tiền: ${widget.cart.getTotalPrice()} VND',
                  style: TextStyle(
                    color: getColor(AppColors.lightAccent),
                    fontSize: 16,
                  ),
                ),
                SizedBox(
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Đã thanh toán")));
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(getColor(AppColors.primaryAccent)),
                      padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 20)),
                    ),
                    child: Text(
                      'Thanh toán',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ProductDetailPage extends StatelessWidget {
  final Product product;
  final Cart cart;

  ProductDetailPage({required this.product, required this.cart});

  @override
  Widget build(BuildContext context) {
    TextEditingController quantityController = TextEditingController(text: '1');

    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
        backgroundColor: getColor(AppColors.primaryAccent),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => CartPage(cart: cart)));
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 200,
              height: 200,
              color: getColor(AppColors.secondaryBackground),
            ),
            SizedBox(height: 10),
            Text(product.name, style: TextStyle(fontSize: 24, color: getColor(AppColors.lightAccent))),
            Text('${product.price} VND', style: TextStyle(fontSize: 20, color: getColor(AppColors.lightAccent))),
            SizedBox(height: 10),
            Text(product.description, style: TextStyle(color: getColor(AppColors.lightAccent))),
            SizedBox(height: 20),
            TextField(
              controller: quantityController,
              decoration: InputDecoration(
                labelText: 'Số lượng',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                int quantity = int.parse(quantityController.text);
                cart.addToCart(product, quantity);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Thêm vào giỏ hàng")));
              },
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(getColor(AppColors.primaryAccent))),
              child: Text('Thêm giỏ hàng'),
            ),
          ],
        ),
      ),
    );
  }
}
