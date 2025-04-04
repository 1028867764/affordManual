import 'package:flutter/material.dart';
import 'main.dart';
import 'industry_app.dart';
import 'luxury_app.dart';
import 'data/organisms_data.dart';
import 'data/industry_data.dart';

List<Map<String, dynamic>> _getCombinedData() {
  final List<Map<String, dynamic>> combinedData = [];

  // 1. 添加 factories 数据
  factories.forEach((category, items) {
    for (var item in items) {
      combinedData.add({'id': item['id'], 'name': item['name']});
    }
  });

  // 2. 添加 organisms 数据
  for (var category in organisms) {
    for (var parentGroup in category.parentProductGroups) {
      for (var parentProduct in parentGroup.parentProducts) {
        for (var product in parentProduct.childProducts) {
          combinedData.add({'id': product.id, 'name': product.name});
        }
      }
    }
  }

  return combinedData;
}

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _searchHistory = [];
  List<Map<String, dynamic>> _searchResults = [];
  bool _showResults = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch() {
    final query = _searchController.text.trim();

    if (query.isEmpty) {
      setState(() {
        _showResults = false;
        _searchResults.clear();
      });
      return;
    }

    if (!_searchHistory.contains(query)) {
      setState(() {
        _searchHistory.insert(0, query);
      });
    }

    setState(() {
      _showResults = true;
      _searchResults =
          _getCombinedData().where((item) {
            final names = item['name'] is List ? item['name'] : [item['name']];
            return names.any(
              (name) =>
                  name.toString().toLowerCase().contains(query.toLowerCase()),
            );
          }).toList();
    });
  }

  void _removeSearchItem(int index) {
    setState(() {
      _searchHistory.removeAt(index);
    });
  }

  void _clearAllHistory() {
    setState(() {
      _searchHistory.clear();
    });
  }

  void _fillSearchBox(String text) {
    setState(() {
      _searchController.text = text;
      _performSearch();
    });
  }

  void _navigateToDetail(Map<String, dynamic> item) {
    final names = item['name'] is List ? item['name'] : [item['name']];

    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => ProductDetailScreen(
              product: Product(
                id: item['id'].toString(),
                name: List<String>.from(names.map((n) => n.toString())),
              ),
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 43,
        leading: Padding(
          padding: const EdgeInsets.only(left: 3),
          child: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: Container(
          margin: const EdgeInsets.only(right: 16),
          height: 36,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
          ),
          child: TextField(
            controller: _searchController,
            autofocus: true,
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16),
              suffixIcon: Icon(Icons.search, color: Colors.grey),
              hintText: '搜索...',
            ),
            onChanged: (_) => _performSearch(),
            textInputAction: TextInputAction.search,
            onSubmitted: (_) => _performSearch(),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_showResults)
              Expanded(
                child:
                    _searchResults.isEmpty
                        ? const Center(
                          child: Text(
                            '没有找到匹配结果',
                            style: TextStyle(color: Colors.grey),
                          ),
                        )
                        : ListView.builder(
                          itemCount: _searchResults.length,
                          itemBuilder: (context, index) {
                            final item = _searchResults[index];
                            final names =
                                item['name'] is List
                                    ? item['name']
                                    : [item['name']];
                            final primaryName =
                                names.isNotEmpty ? names[0].toString() : '未命名';

                            return ListTile(
                              title: Text(primaryName),
                              subtitle:
                                  names.length > 1
                                      ? Text(names.sublist(1).join(' / '))
                                      : null,
                              onTap: () => _navigateToDetail(item),
                            );
                          },
                        ),
              )
            else if (_searchHistory.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '搜索历史',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: _clearAllHistory,
                        child: const Text(
                          '全部清空',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children:
                          _searchHistory.asMap().entries.map((entry) {
                            return Stack(
                              clipBehavior: Clip.none,
                              children: [
                                GestureDetector(
                                  onTap: () => _fillSearchBox(entry.value),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Text(entry.value),
                                  ),
                                ),
                                Positioned(
                                  right: -4,
                                  top: -4,
                                  child: GestureDetector(
                                    onTap: () => _removeSearchItem(entry.key),
                                    child: Container(
                                      padding: const EdgeInsets.all(2),
                                      decoration: const BoxDecoration(
                                        color: Colors.grey,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.close,
                                        size: 14,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                    ),
                  ),
                ],
              )
            else
              const Center(
                child: Text('暂无搜索历史', style: TextStyle(color: Colors.grey)),
              ),
          ],
        ),
      ),
    );
  }
}
