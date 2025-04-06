import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'data/organisms_data.dart';
import 'main.dart';
import 'data/industry_data.dart';
import 'search_page.dart';

class FavoriteApp extends StatefulWidget {
  const FavoriteApp({super.key});

  @override
  State<FavoriteApp> createState() => _FavoriteAppState();
}

class _FavoriteAppState extends State<FavoriteApp> {
  List<Product> _favoriteProducts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final allKeys = prefs.getKeys();

    // Find all favorite keys and get their products
    final favoriteKeys = allKeys.where(
      (key) => key.startsWith('favorite_') && prefs.getBool(key) == true,
    );

    // Convert keys to product IDs by removing 'favorite_' prefix
    final productIds =
        favoriteKeys.map((key) => key.replaceFirst('favorite_', '')).toList();

    // Find all products in organisms data that match these IDs
    final allProducts = <Product>[];
    // 1. 添加生物篇数据
    allProducts.addAll(
      organisms.expand(
        (category) => category.parentProductGroups.expand(
          (group) =>
              group.parentProducts.expand((parent) => parent.childProducts),
        ),
      ),
    );

    // 2. 添加工业篇数据
    factories.forEach((categoryName, products) {
      allProducts.addAll(
        products.map(
          (map) => Product(
            id: map['id'] as String,
            name: List<String>.from(map['name'] as List),
          ),
        ),
      );
    });

    if (mounted) {
      setState(() {
        _favoriteProducts =
            allProducts.where((product) => productIds.contains(product.id)).map(
              (product) {
                final customName =
                    prefs.getString('custom_name_${product.id}') ?? '';
                final description =
                    prefs.getString('description_${product.id}') ?? '';
                return Product(
                  id: product.id,
                  name: product.name,
                  customName: customName,
                  description: description,
                );
              },
            ).toList();
        _isLoading = false;
      });
    }
  }

  Future<void> _showEditDialog(BuildContext context, Product product) async {
    final originalName =
        product.customName.isNotEmpty ? product.customName : product.name[0];
    final originalDescription = product.description ?? '';
    final nameController = TextEditingController(text: originalName);
    final descriptionController = TextEditingController(
      text: originalDescription,
    );

    await showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('编辑项目'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: '自定义名称',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: '简短描述',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('取消'),
              ),
              TextButton(
                onPressed: () async {
                  final newName = nameController.text.trim();
                  final newDescription = descriptionController.text.trim();
                  final prefs = await SharedPreferences.getInstance();
                  if (newName.isNotEmpty && newName != product.name[0]) {
                    // 保存自定义名称
                    await prefs.setString('custom_name_${product.id}', newName);
                  } else {
                    await prefs.remove('custom_name_${product.id}');
                  }
                  // 保存描述
                  if (newDescription.isNotEmpty) {
                    await prefs.setString(
                      'description_${product.id}',
                      newDescription,
                    );
                  } else {
                    await prefs.remove('description_${product.id}');
                  }
                  if (mounted) {
                    await _loadFavorites(); // 等待加载完成
                    Navigator.pop(context);
                  }
                },
                child: const Text('保存'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 每次页面构建时都检查是否需要刷新
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _loadFavorites();
      }
    });
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 100,
        leading: Row(
          children: [
            const SizedBox(width: 10),
            Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(24),
              child: InkWell(
                borderRadius: BorderRadius.circular(24),
                onTap: () => Navigator.pop(context),
                child: const Padding(
                  padding: EdgeInsets.all(12),
                  child: Icon(Icons.arrow_back),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(24),
              child: InkWell(
                borderRadius: BorderRadius.circular(24),
                onTap: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder:
                          (context, animation, secondaryAnimation) =>
                              const SearchPage(),
                      transitionsBuilder: (
                        context,
                        animation,
                        secondaryAnimation,
                        child,
                      ) {
                        const begin = Offset(1.0, 0.0);
                        const end = Offset.zero;
                        const curve = Curves.ease;
                        var tween = Tween(
                          begin: begin,
                          end: end,
                        ).chain(CurveTween(curve: curve));
                        var offsetAnimation = animation.drive(tween);
                        return SlideTransition(
                          position: offsetAnimation,
                          child: child,
                        );
                      },
                    ),
                  );
                },
                child: const Padding(
                  padding: EdgeInsets.all(12),
                  child: Icon(Icons.search),
                ),
              ),
            ),
          ],
        ),
        title: const Text('我的收藏'),
        actions: [
          Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(24),
            child: InkWell(
              borderRadius: BorderRadius.circular(24),
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const MainHomePage()),
                  (route) => false,
                );
              },
              child: const Padding(
                padding: EdgeInsets.all(12),
                child: Icon(Icons.home),
              ),
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _favoriteProducts.isEmpty
              ? const Center(
                child: Text(
                  '暂无收藏内容',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              )
              : ListView.builder(
                itemCount: _favoriteProducts.length,
                itemBuilder: (context, index) {
                  final product = _favoriteProducts[index];
                  // 获取从第3位开始的所有名称（如果存在）
                  final otherNames =
                      product.name.length > 2
                          ? product.name.sublist(2).join(', ')
                          : '暂无其它名称';
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: ListTile(
                      title: Text(
                        product.displayName, // 没有自定义名称时显示其他名称
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.customName.isNotEmpty
                                ? product.name[0]
                                : otherNames,
                            style: TextStyle(fontSize: 11),
                          ),
                          if (product.description?.isNotEmpty ?? false)
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                product.description!,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, size: 20),
                            onPressed: () => _showEditDialog(context, product),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.star_rounded,
                              color: kBilibiliPink,
                            ),
                            onPressed: () async {
                              final prefs =
                                  await SharedPreferences.getInstance();
                              await prefs.setBool(
                                'favorite_${product.id}',
                                false,
                              );
                              await prefs.remove('custom_name_${product.id}');
                              await prefs.remove('description_${product.id}');
                              if (mounted) {
                                _loadFavorites();
                              }
                            },
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    ProductDetailScreen(product: product),
                            transitionsBuilder: (
                              context,
                              animation,
                              secondaryAnimation,
                              child,
                            ) {
                              const begin = Offset(1.0, 0.0);
                              const end = Offset.zero;
                              const curve = Curves.ease;
                              var tween = Tween(
                                begin: begin,
                                end: end,
                              ).chain(CurveTween(curve: curve));
                              var offsetAnimation = animation.drive(tween);
                              return SlideTransition(
                                position: offsetAnimation,
                                child: child,
                              );
                            },
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
    );
  }
}
