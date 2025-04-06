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
  List<CollectionFolder> _folders = [];
  // 添加筛选状态
  String? _currentFilterFolderId;
  String? _currentFilterFolderName;
  List<Product>? _filteredProducts; // 新增成员变量

  @override
  void initState() {
    super.initState();
    _isLoading = true; // Ensure initial state is loading
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      await _loadFavorites();
      await _loadFolders();
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
      debugPrint('Error loading data: $e');
      // Optionally show error to user
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('加载收藏失败: ${e.toString()}')));
    }
  }

  Future<void> _loadFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final allKeys = prefs.getKeys();

      final favoriteKeys = allKeys.where(
        (key) => key.startsWith('favorite_') && prefs.getBool(key) == true,
      );

      final productIds =
          favoriteKeys.map((key) => key.replaceFirst('favorite_', '')).toList();

      final allProducts = <Product>[];
      allProducts.addAll(
        organisms.expand(
          (category) => category.parentProductGroups.expand(
            (group) =>
                group.parentProducts.expand((parent) => parent.childProducts),
          ),
        ),
      );

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

      final loadedProducts =
          allProducts.where((product) => productIds.contains(product.id)).map((
            product,
          ) {
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
          }).toList();

      if (mounted) {
        setState(() {
          _favoriteProducts = loadedProducts;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      // Consider showing an error message to the user
      debugPrint('Error loading favorites: $e');
    }
  }

  Future<void> _loadFolders() async {
    final prefs = await SharedPreferences.getInstance();
    final folderKeys =
        prefs.getKeys().where((key) => key.startsWith('folder_')).toList();

    final folders = <CollectionFolder>[];
    for (var key in folderKeys) {
      final folderData = prefs.getString(key);
      if (folderData != null) {
        final parts = folderData.split('|');
        if (parts.length >= 2) {
          folders.add(
            CollectionFolder(
              id: key.replaceFirst('folder_', ''),
              name: parts[0],
              description: parts[1],
            ),
          );
        }
      }
    }

    if (mounted) {
      setState(() {
        _folders = folders;
      });
    }
  }

  Future<void> _showSaveToFolderDialog(
    BuildContext context,
    Product product,
  ) async {
    await showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('保存到收藏夹'),
            content: SizedBox(
              width: double.maxFinite,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      final newFolder = await Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  const CreateFolderPage(),
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
                      if (newFolder != null && mounted) {
                        await _loadFolders();
                        _saveProductToFolder(product, newFolder.id);
                      }
                    },
                    child: const Text('新建收藏夹'),
                  ),
                  const SizedBox(height: 16),
                  const Text('选择现有收藏夹:'),
                  const SizedBox(height: 8),
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _folders.length,
                      itemBuilder: (context, index) {
                        final folder = _folders[index];
                        return ListTile(
                          title: Text(folder.name),
                          subtitle: Text(folder.description),
                          onTap: () {
                            Navigator.pop(context);
                            _saveProductToFolder(product, folder.id);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('取消'),
              ),
            ],
          ),
    );
  }

  Future<void> _saveProductToFolder(Product product, String folderId) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'folder_${folderId}_item_${product.id}';
    await prefs.setString(
      key,
      '${product.displayName}|${product.description ?? ''}',
    );

    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('已保存到收藏夹')));
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
                    await prefs.setString('custom_name_${product.id}', newName);
                  } else {
                    await prefs.remove('custom_name_${product.id}');
                  }
                  if (newDescription.isNotEmpty) {
                    await prefs.setString(
                      'description_${product.id}',
                      newDescription,
                    );
                  } else {
                    await prefs.remove('description_${product.id}');
                  }
                  if (mounted) {
                    await _loadFavorites();
                    Navigator.pop(context);
                  }
                },
                child: const Text('保存'),
              ),
            ],
          ),
    );
  }

  Future<void> _removeFavorite(Product product) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('favorite_${product.id}', false);

    if (mounted) {
      setState(() {
        _favoriteProducts.removeWhere((p) => p.id == product.id);
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('已取消收藏')));
    }
  }

  @override
  Widget build(BuildContext context) {
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

      body: Column(
        children: [
          // 添加筛选头部
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    final selectedFolder = await showDialog<CollectionFolder>(
                      context: context,
                      builder:
                          (context) => AlertDialog(
                            title: const Text('按照收藏夹筛选'),
                            content: SizedBox(
                              width: double.maxFinite,
                              child:
                                  _folders.isEmpty
                                      ? const Text('暂无收藏夹')
                                      : ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: _folders.length,
                                        itemBuilder: (context, index) {
                                          final folder = _folders[index];
                                          return ListTile(
                                            title: Text(folder.name),
                                            subtitle: Text(folder.description),
                                            onTap: () {
                                              Navigator.pop(context, folder);
                                            },
                                          );
                                        },
                                      ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('取消'),
                              ),
                            ],
                          ),
                    );

                    if (selectedFolder != null && mounted) {
                      setState(() {
                        _currentFilterFolderId = selectedFolder.id;
                        _currentFilterFolderName = selectedFolder.name;
                      });
                    }
                  },
                  child: const Text('按照收藏夹筛选'),
                ),
                if (_currentFilterFolderId != null)
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _currentFilterFolderId = null;
                        _currentFilterFolderName = null;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[300],
                    ),
                    child: const Text('清空筛选条件'),
                  ),
              ],
            ),
          ),
          // 显示当前筛选状态
          if (_currentFilterFolderName != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Text(
                    '当前筛选: ${_currentFilterFolderName}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          Expanded(
            child:
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _favoriteProducts.isEmpty
                    ? const Center(
                      child: Text(
                        '暂无收藏内容',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    )
                    : FutureBuilder<List<String>>(
                      future: _getFilteredProductIds(_currentFilterFolderId),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        final filteredProductIds = snapshot.data ?? [];
                        final filteredProducts =
                            _currentFilterFolderId == null
                                ? _favoriteProducts
                                : _favoriteProducts
                                    .where(
                                      (product) => filteredProductIds.contains(
                                        product.id,
                                      ),
                                    )
                                    .toList();

                        return ListView.builder(
                          itemCount: filteredProducts.length,
                          itemBuilder: (context, index) {
                            final product = filteredProducts[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              child: ListTile(
                                title: Text(
                                  product.customName.isNotEmpty
                                      ? product.customName
                                      : product.name[0],
                                  style: const TextStyle(fontSize: 16),
                                ),
                                subtitle:
                                    product.description?.isNotEmpty ?? false
                                        ? Text(product.description!)
                                        : null,
                                trailing: PopupMenuButton<String>(
                                  onSelected: (value) async {
                                    if (value == 'edit') {
                                      await _showEditDialog(context, product);
                                    } else if (value == 'save') {
                                      await _showSaveToFolderDialog(
                                        context,
                                        product,
                                      );
                                    } else if (value == 'remove') {
                                      await _removeFavorite(product);
                                    }
                                  },
                                  itemBuilder:
                                      (context) => [
                                        const PopupMenuItem(
                                          value: 'edit',
                                          child: Text('编辑'),
                                        ),
                                        const PopupMenuItem(
                                          value: 'save',
                                          child: Text('保存到收藏夹'),
                                        ),
                                        const PopupMenuItem(
                                          value: 'remove',
                                          child: Text('取消收藏'),
                                        ),
                                      ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder:
                  (context, animation, secondaryAnimation) =>
                      const CreateFolderPage(),
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
                return SlideTransition(position: offsetAnimation, child: child);
              },
            ),
          );
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }

  // 添加辅助方法获取收藏夹中的产品ID
  Future<List<String>> _getFilteredProductIds(String? folderId) async {
    if (folderId == null) return [];

    final prefs = await SharedPreferences.getInstance();
    final allKeys = prefs.getKeys();
    final folderItemKeys =
        allKeys
            .where((key) => key.startsWith('folder_${folderId}_item_'))
            .toList();

    return folderItemKeys
        .map((key) => key.replaceFirst('folder_${folderId}_item_', ''))
        .toList();
  }
}

class CollectionFolder {
  final String id;
  final String name;
  final String description;

  CollectionFolder({
    required this.id,
    required this.name,
    required this.description,
  });
}

class CreateFolderPage extends StatefulWidget {
  const CreateFolderPage({super.key});

  @override
  State<CreateFolderPage> createState() => _CreateFolderPageState();
}

class _CreateFolderPageState extends State<CreateFolderPage> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('新建收藏夹'),
        actions: [
          IconButton(icon: const Icon(Icons.save), onPressed: _saveFolder),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: '收藏夹名称',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: '收藏夹简介',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveFolder() async {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('请填写收藏夹名称')));
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final folderId = DateTime.now().millisecondsSinceEpoch.toString();
    await prefs.setString(
      'folder_$folderId',
      '${_nameController.text.trim()}|${_descriptionController.text.trim()}',
    );

    if (mounted) {
      Navigator.pop(
        context,
        CollectionFolder(
          id: folderId,
          name: _nameController.text.trim(),
          description: _descriptionController.text.trim(),
        ),
      );
    }
  }
}
