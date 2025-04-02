import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App',
      theme: ThemeData(
        fontFamily: 'Roboto',
        primarySwatch: Colors.blue,
      ), // 设置默认字体
      home: const MainHomePage(),
    );
  }
}

class MainHomePage extends StatelessWidget {
  const MainHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: GestureDetector(
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
            child: Container(
              width: MediaQuery.of(context).size.width * 0.7,
              height: 30,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const TextField(
                style: TextStyle(fontSize: 14),
                enabled: false,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16),
                  suffixIcon: Icon(Icons.search, color: Colors.grey),
                  hintText: '搜索...',
                ),
              ),
            ),
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 150,
              height: 150,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder:
                          (context, animation, secondaryAnimation) =>
                              const BiologyApp(),
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
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                ),
                child: const Text('生物篇'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 43,
        leading: Padding(
          padding: const EdgeInsets.only(left: 3),
          child: IconButton(
            icon: const Icon(Icons.arrow_back),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        titleSpacing: 0,
        title: Container(
          margin: const EdgeInsets.only(right: 16),
          height: 30,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const TextField(
            style: TextStyle(fontSize: 14),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16),
              suffixIcon: Icon(Icons.search, color: Colors.grey),
              hintText: '搜索...',
            ),
          ),
        ),
      ),
      body: const Center(child: Text('这里是搜索页面内容')),
    );
  }
}

class Product {
  final String id;
  final String name;

  Product({required this.id, required this.name});
}

class ParentProduct {
  final String id;
  final String name;
  final List<Product> childProducts;

  ParentProduct({
    required this.id,
    required this.name,
    required this.childProducts,
  });
}

class ParentProductGroup {
  final String id;
  final List<ParentProduct> parentProducts;

  ParentProductGroup({required this.id, required this.parentProducts});
}

class Category {
  final String id;
  final List<ParentProductGroup> parentProductGroups;

  Category({required this.id, required this.parentProductGroups});
}

class CategoryMenu extends StatelessWidget {
  final List<Category> categories;
  final int currentIndex;
  final Function(int) onCategorySelected;

  const CategoryMenu({
    super.key,
    required this.categories,
    required this.currentIndex,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      color: Colors.grey[200],
      child: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => onCategorySelected(index),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              color: index == currentIndex ? Colors.white : Colors.grey[200],
              margin: const EdgeInsets.only(bottom: 2),
              alignment: Alignment.center,
              child: Text(
                categories[index].id,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight:
                      index == currentIndex
                          ? FontWeight.bold
                          : FontWeight.normal,
                  color: index == currentIndex ? Colors.orange: null,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class ProductGrid extends StatelessWidget {
  final Category category;
  final Function(Product) onProductSelected;

  const ProductGrid({
    super.key,
    required this.category,
    required this.onProductSelected,
  });

  @override
  Widget build(BuildContext context) {
    bool isSingleGroup = category.parentProductGroups.length == 1;
    int groupCount = category.parentProductGroups.length;

    return ListView.builder(
      itemCount: groupCount * 2 - 1,
      itemBuilder: (context, index) {
        if (index.isOdd) {
          return const SizedBox(height: 15);
        }

        final groupIndex = index ~/ 2;
        final group = category.parentProductGroups[groupIndex];
        final isFirstGroup = groupIndex == 0;
        final isLastGroup = groupIndex == groupCount - 1;

        // 当有多个组时，包装整个组
        if (!isSingleGroup) {
          return Container(
            margin: EdgeInsets.only(
              left: 10,
              right: 10,
              top: isFirstGroup ? 10 : 0,  // 第一个组顶部有间距
              bottom: isLastGroup ? 10 : 0, // 最后一个组底部有间距
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.orange[50],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: _buildGroupContent(group, isSingleGroup, groupIndex, isLastGroup),
            ),
          );
        } else {
          // 单个组时直接返回内容
          return _buildGroupContent(group, isSingleGroup, groupIndex, isLastGroup);
        }
      },
    );
  }

Widget _buildGroupContent(
  ParentProductGroup group, 
  bool isSingleGroup, 
  int groupIndex,
  bool isLastGroup,
) {
  int parentProductCount = group.parentProducts.length;

  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    mainAxisAlignment: MainAxisAlignment.start, // 确保子项从顶部开始排列
    children: [
      if (!isSingleGroup && group.id.isNotEmpty)
        Container(
          child: Align( // 替换原来的 Center
          alignment: Alignment.centerLeft, // 左对齐
            child: IntrinsicWidth(
              child: Container( // 通过Container设置颜色
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.orange[300],
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(12), // 仅右下角圆角
                  ),
                ),
          child: Text(
            group.id,
            style: const TextStyle(
              fontSize: 15,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
            ),
          ),
        ),
      ...group.parentProducts.map((parentProduct) {
        final isLastParentProduct = group.parentProducts.indexOf(parentProduct) == parentProductCount - 1;

        return Container(
          margin: EdgeInsets.only(
            top: isSingleGroup ? (groupIndex == 0 ? 10 : 0) : 0,
            left: isSingleGroup ? 10 : 0,
            right: isSingleGroup ? 10 : 0,
            bottom: isSingleGroup ? (isLastParentProduct ? 10 : 0) : 0, // 确保最后一个 ParentProduct 没有下边距
          ),
          decoration: BoxDecoration(
            color: isSingleGroup ? Colors.orange[50] : Colors.orange[50],
            borderRadius: isSingleGroup ? BorderRadius.circular(12) : BorderRadius.zero,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch, // 确保子项拉伸填充
            children: [
              Padding(
                padding: EdgeInsets.zero, // 所有方向内边距为 0
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (isSingleGroup) 
  LayoutBuilder(
    builder: (context, constraints) {
      return Container(  
        child: Align(
        alignment: Alignment.centerLeft, // 左对齐
      child: IntrinsicWidth(                          // 使用 IntrinsicWidth 包裹 Text
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          decoration: BoxDecoration(
            color: Colors.orange[300],
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(0),
              bottomLeft: Radius.circular(0),
              bottomRight: Radius.circular(12)
            )
          ),
          child: Text(
            parentProduct.id,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
              color: Colors.white,
            ),
          ),
        ),
        ),
      ),
    );
    },
  ),
                    if (isSingleGroup)
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          parentProduct.name,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    if (!isSingleGroup)
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          parentProduct.id,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    if (!isSingleGroup)
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          parentProduct.name,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 0.8,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                padding: const EdgeInsets.only(
                  top: 0,
                  bottom: 10,
                  left: 10,
                  right: 10,
                ),
                itemCount: parentProduct.childProducts.length,
                itemBuilder: (context, index) {
                  final product = parentProduct.childProducts[index];
                  return GestureDetector(
                    onTap: () => onProductSelected(product),
                    child: Card(
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            product.name,
                            style: const TextStyle(fontSize: 11),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      }).toList(), // 确保 map 返回的是一个列表
    ],
  );
}
}

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  bool _isLoading = true;
  String? _enlargedImageUrl;
  ScrollController _scrollController = ScrollController();
  double _scrollPosition = 0.0;

  void _enlargeImage(String imageUrl) {
    _scrollPosition = _scrollController.position.pixels;
    setState(() {
      _enlargedImageUrl = imageUrl;
    });
  }

  void _closeEnlargedImage() {
    setState(() {
      _enlargedImageUrl = null;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.jumpTo(_scrollPosition);
    });
  }

  void _copyText(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('已复制到剪贴板: $text')));
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final markdownContent = """
# 产品详情

## 基本信息
- ​**产品ID**: ${widget.product.id}
- ​**产品名称**: ${widget.product.name}

## &emsp;产品描述
&emsp;&emsp;这是一段示例描述。《零的焦点》则以一对夫妻的生活为切入点，展现了一幅日本战后社会的众生相。女主人公绫子看似拥有幸福美满的家庭，然而，丈夫的神秘失踪打破了这份平静。随着调查的深入，一系列惊人的真相逐渐浮出水面。原来，丈夫的过去涉及到一些不为人知的秘密，而这些秘密与当时日本社会的种种问题紧密相连。在这个过程中，作者揭示了战争给人们带来的创伤以及战后社会的混乱与迷茫。人们在追求物质生活的同时，往往忽略了内心的真实需求，导致道德观念的扭曲和人际关系的冷漠。通过对这起案件的描写，读者不仅能够感受到推理小说的紧张刺激，还能对社会现实进行深刻的反思。  
## 产品图片
![示例图片](http://img.tukuppt.com/photo-small/19/94/23/706589110a5f2073682.jpg)
## &emsp;产品描述
&emsp;&emsp;《夜蝉》的故事发生在一个宁静而又略显封闭的小镇。小镇的生活节奏缓慢，人们过着平淡而又规律的日子，仿佛时间在这里停滞了一般。然而，一起突如其来的谋杀案打破了这份宁静，如同平静的湖面投入了一颗巨石。  
&emsp;&emsp;案件发生在一个看似普通的夜晚，一位与小镇生活息息相关的人物被发现离奇死亡。随着调查的展开，各种线索逐渐浮出水面，但这些线索却如同夜空中的繁星，看似繁多却又各自独立，让人难以捉摸其中的关联。北村薰以其独特的叙事手法，将读者带入了一个充满悬念和神秘色彩的世界，让人们对这起案件充满了好奇和探索的欲望。
## &emsp;产品描述
&emsp;&emsp;这是一段示例描述。《零的焦点》则以一对夫妻的生活为切入点，展现了一幅日本战后社会的众生相。女主人公绫子看似拥有幸福美满的家庭，然而，丈夫的神秘失踪打破了这份平静。随着调查的深入，一系列惊人的真相逐渐浮出水面。原来，丈夫的过去涉及到一些不为人知的秘密，而这些秘密与当时日本社会的种种问题紧密相连。在这个过程中，作者揭示了战争给人们带来的创伤以及战后社会的混乱与迷茫。人们在追求物质生活的同时，往往忽略了内心的真实需求，导致道德观念的扭曲和人际关系的冷漠。通过对这起案件的描写，读者不仅能够感受到推理小说的紧张刺激，还能对社会现实进行深刻的反思。  
## 产品图片
![示例图片](http://gd-hbimg.huaban.com/2288348e418d1372bab85e5266cae51b2d66503c6155b-KgiKde)
## &emsp;产品描述
&emsp;&emsp;《夜蝉》的故事发生在一个宁静而又略显封闭的小镇。小镇的生活节奏缓慢，人们过着平淡而又规律的日子，仿佛时间在这里停滞了一般。然而，一起突如其来的谋杀案打破了这份宁静，如同平静的湖面投入了一颗巨石。  
&emsp;&emsp;案件发生在一个看似普通的夜晚，一位与小镇生活息息相关的人物被发现离奇死亡。随着调查的展开，各种线索逐渐浮出水面，但这些线索却如同夜空中的繁星，看似繁多却又各自独立，让人难以捉摸其中的关联。北村薰以其独特的叙事手法，将读者带入了一个充满悬念和神秘色彩的世界，让人们对这起案件充满了好奇和探索的欲望。 
    """;

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
        title: Text(widget.product.name),
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
          _enlargedImageUrl != null
              ? GestureDetector(
                onTap: _closeEnlargedImage,
                child: Container(
                  color: Colors.black.withOpacity(0.9),
                  child: Center(
                    child: InteractiveViewer(
                      panEnabled: true,
                      minScale: 0.5,
                      maxScale: 4.0,
                      child: Image.network(_enlargedImageUrl!),
                    ),
                  ),
                ),
              )
              : _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                controller: _scrollController,
                child: Markdown(
                  data: markdownContent,
                  shrinkWrap: true,
                  selectable: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  imageBuilder: (uri, title, alt) {
                    return GestureDetector(
                      onTap: () => _enlargeImage(uri.toString()),
                      child: CachedNetworkImage(
                        imageUrl: uri.toString(),
                        placeholder:
                            (context, url) => Container(
                              color: Colors.grey[300],
                              width: 100,
                              height: 100,
                              child: const Icon(
                                Icons.image,
                                color: Colors.grey,
                              ),
                            ),
                        errorWidget:
                            (context, url, error) => Container(
                              color: Colors.grey[300],
                              width: 100,
                              height: 100,
                              child: const Icon(
                                Icons.broken_image,
                                color: Colors.grey,
                              ),
                            ),
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                ),
              ),
    );
  }
}

class BiologyApp extends StatefulWidget {
  const BiologyApp({super.key});

  @override
  State<BiologyApp> createState() => _BiologyAppState();
}

class _BiologyAppState extends State<BiologyApp> {
  int currentCategoryIndex = 0;
  bool _isLoading = false;

  final List<Category> categories = [
    Category(
      id: "唇形目",
      parentProductGroups: [
        ParentProductGroup(
          id: "唇形科",
          parentProducts: [
            ParentProduct(
              id: "Mentha",
              name: "薄荷属",
              childProducts: [
                Product(id: "1", name: "椒样薄荷"),
                Product(id: "2", name: "留兰香薄荷"),
              ],
            ),
            ParentProduct(
              id: "Pogostemon",
              name: "刺蕊草属",
              childProducts: [Product(id: "3", name: "广藿香")],
            ),
            ParentProduct(
              id: "Platostoma",
              name: "仙草属",
              childProducts: [Product(id: "4", name: "仙草")],
            ),
            ParentProduct(
              id: "Perilla",
              name: "紫苏属",
              childProducts: [Product(id: "5", name: "紫苏")],
            ),
          ],
        ),
        ParentProductGroup(
          id: "木樨科",
          parentProducts: [
            ParentProduct(
              id: "Jasminum",
              name: "素馨属",
              childProducts: [Product(id: "6", name: "茉莉花")],
            ),
          ],
        ),
        ParentProductGroup(
          id: "脂麻科",
          parentProducts: [
            ParentProduct(
              id: "Sesamum",
              name: "脂麻属",
              childProducts: [Product(id: "7", name: "芝麻粒")],
            ),
          ],
        ),
      ],
    ),

    Category(
      id: "豆科",
      parentProductGroups: [
        ParentProductGroup(
          id: "豆科",
          parentProducts: [
            ParentProduct(
              id: "Phaseolus",
              name: "菜豆属",
              childProducts: [
                Product(id: "8", name: "荷包豆"),
                Product(id: "9", name: "四季豆"),
              ],
            ),
            ParentProduct(
              id: "Glycine",
              name: "大豆属",
              childProducts: [
                Product(id: "10", name: "毛豆"),
                Product(id: "11", name: "青大豆"),
                Product(id: "12", name: "黄大豆1号"),
                Product(id: "13", name: "黑大豆"),
                Product(id: "14", name: "黄大豆粉"),
                Product(id: "15", name: "豆腐"),
                Product(id: "16", name: "豆腐泡"),
                Product(id: "17", name: "豆腐干"),
                Product(id: "18", name: "腐竹"),
                Product(id: "19", name: "大豆油"),
                Product(id: "20", name: "酱油"),
                Product(id: "21", name: "黑豆豉"),
                Product(id: "22", name: "黄豆酱"),
                Product(id: "23", name: "腐乳"),
                Product(id: "24", name: "豆粕"),
                Product(id: "25", name: "黄豆芽"),
              ],
            ),
            ParentProduct(
              id: "Vigna",
              name: "豇豆属",
              childProducts: [
                Product(id: "26", name: "豇豆荚"),
                Product(id: "27", name: "白豇豆"),
                Product(id: "28", name: "绿豆"),
                Product(id: "29", name: "绿豆芽"),
                Product(id: "30", name: "绿豆淀粉"),
                Product(id: "31", name: "红豆"),
              ],
            ),
            ParentProduct(
              id: "Arachis",
              name: "落花生属",
              childProducts: [
                Product(id: "32", name: "带壳花生"),
                Product(id: "33", name: "花生仁"),
                Product(id: "34", name: "花生油"),
                Product(id: "35", name: "花生粕"),
              ],
            ),
            ParentProduct(
              id: "Pisum",
              name: "豌豆属",
              childProducts: [
                Product(id: "36", name: "豌豆荚"),
                Product(id: "37", name: "豌豆"),
                Product(id: "38", name: "豌豆藤"),
                Product(id: "39", name: "豌豆芽"),
                Product(id: "40", name: "豌豆淀粉"),
              ],
            ),
            ParentProduct(
              id: "Glycyrrhiza",
              name: "甘草属",
              childProducts: [Product(id: "41", name: "甘草")],
            ),
          ],
        ),
      ],
    ),

    Category(
      id: "禾本目",
      parentProductGroups: [
        ParentProductGroup(
          id: "凤梨科",
          parentProducts: [
            ParentProduct(
              id: "Ananas",
              name: "凤梨属",
              childProducts: [Product(id: "42", name: "菠萝")],
            ),
          ],
        ),
        ParentProductGroup(
          id: "禾本科",
          parentProducts: [
            ParentProduct(
              id: "Oryza",
              name: "稻属",
              childProducts: [
                Product(id: "43", name: "籼米"),
                Product(id: "44", name: "粘米粉"),
                Product(id: "45", name: "糯米"),
                Product(id: "46", name: "糯米粉"),
                Product(id: "47", name: "米糠"),
                Product(id: "48", name: "米酒"),
                Product(id: "49", name: "米醋"),
                Product(id: "50", name: "稻秆"),
              ],
            ),
            ParentProduct(
              id: "Saccharum",
              name: "甘蔗属",
              childProducts: [
                Product(id: "51", name: "甘蔗"),
                Product(id: "52", name: "一级白糖"),
                Product(id: "53", name: "三氯蔗糖"),
                Product(id: "54", name: "蔗渣"),
              ],
            ),
            ParentProduct(
              id: "Triticum",
              name: "小麦属",
              childProducts: [
                Product(id: "55", name: "高筋面粉"),
                Product(id: "56", name: "中筋面粉"),
                Product(id: "57", name: "低筋面粉"),
                Product(id: "58", name: "澄粉"),
                Product(id: "59", name: "麦麸"),
                Product(id: "60", name: "麦秆"),
              ],
            ),
            ParentProduct(
              id: "Zea",
              name: "玉米属",
              childProducts: [
                Product(id: "61", name: "饲料玉米棒"),
                Product(id: "62", name: "饲料玉米粒"),
                Product(id: "63", name: "水果玉米棒"),
                Product(id: "64", name: "水果玉米粒"),
                Product(id: "65", name: "糯玉米棒"),
                Product(id: "66", name: "玉米淀粉"),
                Product(id: "67", name: "玉米秆"),
              ],
            ),
          ],
        ),
        ParentProductGroup(
          id: "竹亚科",
          parentProducts: [
            ParentProduct(
              id: "Bambusoideae",
              name: "竹亚科",
              childProducts: [
                Product(id: "68", name: "竹笋"),
                Product(id: "69", name: "竹浆"),
                Product(id: "70", name: "竹木材"),
                Product(id: "71", name: "竹叶"),
                Product(id: "72", name: "竹篾"),
              ],
            ),
          ],
        ),
      ],
    ),

    Category(
      id: "葫芦科",
      parentProductGroups: [
        ParentProductGroup(
          id: "葫芦科",
          parentProducts: [
            ParentProduct(
              id: "Cucumis",
              name: "黄瓜属",
              childProducts: [
                Product(id: "73", name: "黄瓜"),
                Product(id: "74", name: "哈密瓜"),
                Product(id: "75", name: "香瓜"),
              ],
            ),
            ParentProduct(
              id: "Siraitia",
              name: "罗汉果属",
              childProducts: [Product(id: "76", name: "罗汉果")],
            ),
            ParentProduct(
              id: "Citrullus",
              name: "西瓜属",
              childProducts: [
                Product(id: "77", name: "西瓜"),
                Product(id: "78", name: "西瓜籽"),
              ],
            ),
            ParentProduct(
              id: "Cucurbita",
              name: "南瓜属",
              childProducts: [
                Product(id: "79", name: "南瓜"),
                Product(id: "80", name: "南瓜籽"),
                Product(id: "81", name: "南瓜苗"),
                Product(id: "82", name: "南瓜花"),
              ],
            ),
            ParentProduct(
              id: "Luffa",
              name: "丝瓜属",
              childProducts: [Product(id: "83", name: "丝瓜")],
            ),
            ParentProduct(
              id: "Benincasa",
              name: "冬瓜属",
              childProducts: [Product(id: "84", name: "冬瓜")],
            ),
          ],
        ),
      ],
    ),

    Category(
      id: "姜目",
      parentProductGroups: [
        ParentProductGroup(
          id: "芭蕉科",
          parentProducts: [
            ParentProduct(
              id: "Musa",
              name: "芭蕉属",
              childProducts: [Product(id: "85", name: "Williams香蕉")],
            ),
          ],
        ),
        ParentProductGroup(
          id: "竹芋科",
          parentProducts: [
            ParentProduct(
              id: "Phrynium",
              name: "柊叶属",
              childProducts: [Product(id: "86", name: "柊叶")],
            ),
          ],
        ),
        ParentProductGroup(
          id: "姜科",
          parentProducts: [
            ParentProduct(
              id: "Curcuma",
              name: "姜黄属",
              childProducts: [Product(id: "87", name: "姜黄")],
            ),
            ParentProduct(
              id: "Zingiber",
              name: "姜属",
              childProducts: [Product(id: "88", name: "生姜")],
            ),
            ParentProduct(
              id: "Wurfbainia",
              name: "砂仁属",
              childProducts: [Product(id: "89", name: "爪哇白豆蔻")],
            ),
            ParentProduct(
              id: "Lanxangia",
              name: "草果属",
              childProducts: [Product(id: "90", name: "草果")],
            ),
          ],
        ),
      ],
    ),

    Category(
      id: "菊科",
      parentProductGroups: [
        ParentProductGroup(
          id: "菊科",
          parentProducts: [
            ParentProduct(
              id: "Taraxacum",
              name: "蒲公英属",
              childProducts: [Product(id: "91", name: "蒲公英")],
            ),
            ParentProduct(
              id: "Lactuca",
              name: "莴苣属",
              childProducts: [
                Product(id: "92", name: "生菜"),
                Product(id: "93", name: "油麦菜"),
                Product(id: "94", name: "莴笋"),
              ],
            ),
            ParentProduct(
              id: "Helianthus",
              name: "向日葵属",
              childProducts: [Product(id: "95", name: "葵花籽")],
            ),
            ParentProduct(
              id: "Chrysanthemum",
              name: "菊属",
              childProducts: [Product(id: "96", name: "菊花")],
            ),
          ],
        ),
      ],
    ),

    Category(
      id: "壳斗目",
      parentProductGroups: [
        ParentProductGroup(
          id: "壳斗科",
          parentProducts: [
            ParentProduct(
              id: "Castanea",
              name: "栗属",
              childProducts: [Product(id: "97", name: "板栗")],
            ),
          ],
        ),
        ParentProductGroup(
          id: "胡桃科",
          parentProducts: [
            ParentProduct(
              id: "Juglans",
              name: "胡桃属",
              childProducts: [Product(id: "98", name: "核桃")],
            ),
            ParentProduct(
              id: "Engelhardtia",
              name: "黄杞属",
              childProducts: [Product(id: "99", name: "大叶茶")],
            ),
          ],
        ),
      ],
    ),

    Category(
      id: "蔷薇目",
      parentProductGroups: [
        ParentProductGroup(
          id: "蔷薇科",
          parentProducts: [
            ParentProduct(
              id: "Fragaria",
              name: "草莓属",
              childProducts: [Product(id: "100", name: "草莓")],
            ),
            ParentProduct(
              id: "Pyrus",
              name: "梨属",
              childProducts: [Product(id: "101", name: "梨子")],
            ),
            ParentProduct(
              id: "Prunus",
              name: "李属",
              childProducts: [
                Product(id: "102", name: "扁桃仁"),
                Product(id: "103", name: "桃子"),
                Product(id: "104", name: "李子"),
                Product(id: "105", name: "梅子"),
              ],
            ),
            ParentProduct(
              id: "Eriobotrya",
              name: "枇杷属",
              childProducts: [
                Product(id: "106", name: "枇杷"),
                Product(id: "107", name: "枇杷叶"),
              ],
            ),
            ParentProduct(
              id: "Malus",
              name: "苹果属",
              childProducts: [Product(id: "108", name: "80mm红富士苹果")],
            ),
            ParentProduct(
              id: "Rosa",
              name: "蔷薇属",
              childProducts: [
                Product(id: "109", name: "卡罗拉玫瑰"),
                Product(id: "110", name: "黑魔术玫瑰"),
                Product(id: "111", name: "戴安娜玫瑰"),
                Product(id: "112", name: "精油玫瑰"),
              ],
            ),
            ParentProduct(
              id: "Crataegus",
              name: "山楂属",
              childProducts: [Product(id: "113", name: "山楂")],
            ),
          ],
        ),
        ParentProductGroup(
          id: "鼠李科",
          parentProducts: [
            ParentProduct(
              id: "Ziziphus",
              name: "枣属",
              childProducts: [Product(id: "114", name: "一级红枣")],
            ),
          ],
        ),
      ],
    ),

    Category(
      id: "茄目",
      parentProductGroups: [
        ParentProductGroup(
          id: "茄科",
          parentProducts: [
            ParentProduct(
              id: "Capsicum",
              name: "辣椒属",
              childProducts: [Product(id: "115", name: "辣椒")],
            ),
            ParentProduct(
              id: "Solanum",
              name: "茄属",
              childProducts: [
                Product(id: "116", name: "番茄"),
                Product(id: "117", name: "茄子"),
                Product(id: "118", name: "土豆"),
              ],
            ),
          ],
        ),
        ParentProductGroup(
          id: "旋花科",
          parentProducts: [
            ParentProduct(
              id: "Ipomoea",
              name: "番薯属",
              childProducts: [
                Product(id: "119", name: "红薯"),
                Product(id: "120", name: "紫薯"),
                Product(id: "121", name: "红薯叶"),
                Product(id: "122", name: "空心菜"),
              ],
            ),
          ],
        ),
      ],
    ),

    Category(
      id: "伞形科",
      parentProductGroups: [
        ParentProductGroup(
          id: "伞形科",
          parentProducts: [
            ParentProduct(
              id: "Angelica",
              name: "当归属",
              childProducts: [Product(id: "123", name: "白芷")],
            ),
            ParentProduct(
              id: "Daucus",
              name: "胡萝卜属",
              childProducts: [Product(id: "124", name: "胡萝卜")],
            ),
            ParentProduct(
              id: "Foeniculum",
              name: "茴香属",
              childProducts: [Product(id: "125", name: "茴香籽")],
            ),
            ParentProduct(
              id: "Apium",
              name: "芹属",
              childProducts: [
                Product(id: "126", name: "细芹菜"),
                Product(id: "127", name: "粗芹菜"),
              ],
            ),
            ParentProduct(
              id: "Coriandrum",
              name: "芫荽属",
              childProducts: [
                Product(id: "128", name: "芫荽"),
                Product(id: "129", name: "芫荽籽"),
              ],
            ),
            ParentProduct(
              id: "Cuminum",
              name: "孜然芹属",
              childProducts: [Product(id: "130", name: "孜然籽")],
            ),
          ],
        ),
      ],
    ),

    Category(
      id: "十字花科",
      parentProductGroups: [
        ParentProductGroup(
          id: "十字花科",
          parentProducts: [
            ParentProduct(
              id: "Raphanus",
              name: "萝卜属",
              childProducts: [Product(id: "131", name: "萝卜")],
            ),
            ParentProduct(
              id: "Isatis",
              name: "菘蓝属",
              childProducts: [
                Product(id: "132", name: "大青叶"),
                Product(id: "133", name: "板蓝根"),
              ],
            ),
            ParentProduct(
              id: "Brassica_juncea",
              name: "芸薹属_芥菜",
              childProducts: [
                Product(id: "134", name: "榨菜"),
                Product(id: "135", name: "大头菜"),
                Product(id: "136", name: "雪里蕻"),
                Product(id: "137", name: "包心芥菜"),
                Product(id: "138", name: "其它芥菜"),
                Product(id: "139", name: "黄芥末籽"),
              ],
            ),
            ParentProduct(
              id: "Brassica_oleracea",
              name: "芸薹属_甘蓝",
              childProducts: [
                Product(id: "140", name: "西兰花"),
                Product(id: "141", name: "花椰菜"),
                Product(id: "142", name: "卷心菜"),
                Product(id: "143", name: "其它甘蓝"),
              ],
            ),
            ParentProduct(
              id: "Brassica_rapa",
              name: "芸薹属_芸薹",
              childProducts: [
                Product(id: "144", name: "大白菜"),
                Product(id: "145", name: "娃娃菜"),
                Product(id: "146", name: "白菜苔"),
                Product(id: "147", name: "其它白菜"),
              ],
            ),
          ],
        ),
      ],
    ),

    Category(
      id: "松柏目",
      parentProductGroups: [
        ParentProductGroup(
          id: "柏科",
          parentProducts: [
            ParentProduct(
              id: "Cunninghamia",
              name: "杉属",
              childProducts: [Product(id: "148", name: "杉木材")],
            ),
          ],
        ),
        ParentProductGroup(
          id: "松科",
          parentProducts: [
            ParentProduct(
              id: "Pinus",
              name: "松属",
              childProducts: [Product(id: "149", name: "马尾松木材")],
            ),
          ],
        ),
      ],
    ),

    Category(
      id: "桃金娘科",
      parentProductGroups: [
        ParentProductGroup(
          id: "桃金娘科",
          parentProducts: [
            ParentProduct(
              id: "Eucalyptus",
              name: "桉属",
              childProducts: [Product(id: "150", name: "尾叶桉木材")],
            ),
            ParentProduct(
              id: "Syzygium",
              name: "蒲桃属",
              childProducts: [Product(id: "151", name: "公丁香")],
            ),
          ],
        ),
      ],
    ),

    Category(
      id: "石蒜科",
      parentProductGroups: [
        ParentProductGroup(
          id: "石蒜科",
          parentProducts: [
            ParentProduct(
              id: "Allium",
              name: "葱属",
              childProducts: [
                Product(id: "152", name: "葱"),
                Product(id: "153", name: "韭菜"),
                Product(id: "154", name: "蒜瓣"),
                Product(id: "155", name: "蒜苗"),
                Product(id: "156", name: "荞头"),
                Product(id: "157", name: "洋葱"),
                Product(id: "158", name: "红葱头"),
              ],
            ),
          ],
        ),
      ],
    ),

    Category(
      id: "无患子目",
      parentProductGroups: [
        ParentProductGroup(
          id: "漆树科",
          parentProducts: [
            ParentProduct(
              id: "Mangifera",
              name: "芒果属",
              childProducts: [Product(id: "159", name: "芒果")],
            ),
            ParentProduct(
              id: "Anacardium",
              name: "腰果属",
              childProducts: [Product(id: "160", name: "腰果仁")],
            ),
          ],
        ),
        ParentProductGroup(
          id: "无患子科",
          parentProducts: [
            ParentProduct(
              id: "Litchi",
              name: "荔枝属",
              childProducts: [Product(id: "161", name: "荔枝")],
            ),
            ParentProduct(
              id: "Dimocarpus",
              name: "龙眼属",
              childProducts: [Product(id: "162", name: "龙眼")],
            ),
          ],
        ),
        ParentProductGroup(
          id: "芸香科",
          parentProducts: [
            ParentProduct(
              id: "Citrus",
              name: "柑橘属",
              childProducts: [
                Product(id: "163", name: "柚"),
                Product(id: "164", name: "橘"),
                Product(id: "165", name: "橙"),
                Product(id: "166", name: "柑"),
                Product(id: "167", name: "柠檬"),
                Product(id: "168", name: "橘皮"),
              ],
            ),
            ParentProduct(
              id: "Zanthoxylum",
              name: "花椒属",
              childProducts: [Product(id: "169", name: "花椒")],
            ),
          ],
        ),
      ],
    ),

    Category(
      id: "樟科",
      parentProductGroups: [
        ParentProductGroup(
          id: "樟科",
          parentProducts: [
            ParentProduct(
              id: "Cinnamomum",
              name: "肉桂属",
              childProducts: [Product(id: "170", name: "肉桂")],
            ),
            ParentProduct(
              id: "Laurus",
              name: "月桂属",
              childProducts: [Product(id: "171", name: "月桂叶")],
            ),
            ParentProduct(
              id: "Camphora",
              name: "樟属",
              childProducts: [Product(id: "172", name: "樟树木材")],
            ),
          ],
        ),
      ],
    ),

    Category(
      id: "棕榈科",
      parentProductGroups: [
        ParentProductGroup(
          id: "棕榈科",
          parentProducts: [
            ParentProduct(
              id: "Cocos",
              name: "椰属",
              childProducts: [
                Product(id: "173", name: "椰子油"),
                Product(id: "174", name: "椰子壳"),
              ],
            ),
            ParentProduct(
              id: "Elaeis",
              name: "油棕属",
              childProducts: [
                Product(id: "175", name: "棕榈油"),
                Product(id: "176", name: "棕榈仁油"),
              ],
            ),
          ],
        ),
      ],
    ),

    Category(
      id: "其它植物",
      parentProductGroups: [
        ParentProductGroup(
          id: "五味子科",
          parentProducts: [
            ParentProduct(
              id: "Illicium",
              name: "八角属",
              childProducts: [Product(id: "177", name: "八角")],
            ),
          ],
        ),
        ParentProductGroup(
          id: "锦葵科",
          parentProducts: [
            ParentProduct(
              id: "Gossypium",
              name: "棉花属",
              childProducts: [
                Product(id: "178", name: "棉花"),
                Product(id: "179", name: "棉纱"),
              ],
            ),
          ],
        ),
        ParentProductGroup(
          id: "莲科",
          parentProducts: [
            ParentProduct(
              id: "Nelumbo",
              name: "莲属",
              childProducts: [Product(id: "180", name: "莲藕")],
            ),
          ],
        ),
        ParentProductGroup(
          id: "忍冬科",
          parentProducts: [
            ParentProduct(
              id: "Lonicera",
              name: "忍冬属",
              childProducts: [Product(id: "181", name: "忍冬花")],
            ),
          ],
        ),
        ParentProductGroup(
          id: "山茶科",
          parentProducts: [
            ParentProduct(
              id: "Camellia",
              name: "山茶属",
              childProducts: [
                Product(id: "182", name: "茶叶"),
                Product(id: "183", name: "红茶粉"),
              ],
            ),
          ],
        ),
        ParentProductGroup(
          id: "茜草科",
          parentProducts: [
            ParentProduct(
              id: "Gardenia",
              name: "栀子属",
              childProducts: [Product(id: "184", name: "栀子")],
            ),
          ],
        ),
        ParentProductGroup(
          id: "葡萄科",
          parentProducts: [
            ParentProduct(
              id: "Vitis",
              name: "葡萄属",
              childProducts: [
                Product(id: "185", name: "葡萄"),
                Product(id: "186", name: "葡萄干"),
              ],
            ),
          ],
        ),
        ParentProductGroup(
          id: "仙人掌科",
          parentProducts: [
            ParentProduct(
              id: "Selenicereus",
              name: "蛇鞭柱属",
              childProducts: [Product(id: "187", name: "火龙果")],
            ),
          ],
        ),
        ParentProductGroup(
          id: "大戟科",
          parentProducts: [
            ParentProduct(
              id: "Manihot",
              name: "木薯属",
              childProducts: [Product(id: "188", name: "木薯淀粉")],
            ),
          ],
        ),
        ParentProductGroup(
          id: "天南星科",
          parentProducts: [
            ParentProduct(
              id: "Colocasia",
              name: "芋属",
              childProducts: [
                Product(id: "189", name: "芋头"),
                Product(id: "190", name: "芋叶柄"),
              ],
            ),
          ],
        ),
      ],
    ),

    Category(
      id: "雉科",
      parentProductGroups: [
        ParentProductGroup(
          id: "雉科",
          parentProducts: [
            ParentProduct(
              id: "Gallus",
              name: "原鸡属",
              childProducts: [
                Product(id: "191", name: "活鸡"),
                Product(id: "192", name: "白条鸡"),
                Product(id: "193", name: "鸡胸肉"),
                Product(id: "194", name: "鸡腿"),
                Product(id: "195", name: "鸡翅"),
                Product(id: "196", name: "鸡翅尖"),
                Product(id: "197", name: "鸡翅根"),
                Product(id: "198", name: "鸡爪"),
                Product(id: "199", name: "鸡肠"),
                Product(id: "200", name: "鸡胗"),
                Product(id: "201", name: "鸡心"),
                Product(id: "202", name: "鸡肝"),
                Product(id: "203", name: "鸡皮"),
                Product(id: "204", name: "鸡蛋"),
                Product(id: "205", name: "鸡毛"),
              ],
            ),
          ],
        ),
      ],
    ),

    Category(
      id: "鸭科",
      parentProductGroups: [
        ParentProductGroup(
          id: "鸭科",
          parentProducts: [
            ParentProduct(
              id: "Anas_Cairina",
              name: "鸭属|疣鼻栖鸭属",
              childProducts: [
                Product(id: "206", name: "活鸭"),
                Product(id: "207", name: "白条鸭"),
                Product(id: "208", name: "鸭翅"),
                Product(id: "209", name: "鸭腿"),
                Product(id: "210", name: "鸭掌"),
                Product(id: "211", name: "鸭肠"),
                Product(id: "212", name: "鸭胗"),
                Product(id: "213", name: "鸭舌"),
                Product(id: "214", name: "鸭脖"),
                Product(id: "215", name: "鸭心"),
                Product(id: "216", name: "鸭肝"),
                Product(id: "217", name: "鸭蛋"),
                Product(id: "218", name: "皮蛋"),
                Product(id: "219", name: "鸭毛"),
              ],
            ),
          ],
        ),
      ],
    ),

    Category(
      id: "猪科",
      parentProductGroups: [
        ParentProductGroup(
          id: "猪科",
          parentProducts: [
            ParentProduct(
              id: "Sus",
              name: "猪属",
              childProducts: [
                Product(id: "220", name: "生猪"),
                Product(id: "221", name: "白条猪"),
                Product(id: "222", name: "猪皮"),
                Product(id: "223", name: "猪板油"),
                Product(id: "224", name: "肥膘肉"),
                Product(id: "225", name: "猪面颊"),
                Product(id: "226", name: "猪下巴"),
                Product(id: "227", name: "猪颈肉"),
                Product(id: "228", name: "猪舌头"),
                Product(id: "229", name: "猪耳"),
                Product(id: "230", name: "猪脑"),
                Product(id: "231", name: "猪脊骨"),
                Product(id: "232", name: "猪肋排骨"),
                Product(id: "233", name: "猪外脊肉"),
                Product(id: "234", name: "猪里脊肉"),
                Product(id: "235", name: "五花肉"),
                Product(id: "236", name: "猪肩胛肉"),
                Product(id: "237", name: "猪前大腿"),
                Product(id: "238", name: "猪后大腿"),
                Product(id: "239", name: "猪大腿骨"),
                Product(id: "240", name: "猪前肘"),
                Product(id: "241", name: "猪后肘"),
                Product(id: "242", name: "猪前蹄"),
                Product(id: "243", name: "猪后蹄"),
                Product(id: "244", name: "猪尾巴"),
                Product(id: "245", name: "猪腰子"),
                Product(id: "246", name: "猪心"),
                Product(id: "247", name: "猪肝"),
                Product(id: "248", name: "猪肺"),
                Product(id: "249", name: "猪小肠"),
                Product(id: "250", name: "猪大肠"),
                Product(id: "251", name: "猪肚"),
              ],
            ),
          ],
        ),
      ],
    ),

    Category(
      id: "其它动物",
      parentProductGroups: [
        ParentProductGroup(
          id: "拟步行虫科",
          parentProducts: [
            ParentProduct(
              id: "Tenebrio",
              name: "粉甲虫属",
              childProducts: [Product(id: "252", name: "面包虫")],
            ),
          ],
        ),
        ParentProductGroup(
          id: "对虾科",
          parentProducts: [
            ParentProduct(
              id: "Penaeidae",
              name: "对虾科",
              childProducts: [Product(id: "253", name: "对虾")],
            ),
          ],
        ),
        ParentProductGroup(
          id: "田螺科",
          parentProducts: [
            ParentProduct(
              id: "Viviparidae",
              name: "田螺科",
              childProducts: [Product(id: "254", name: "田螺")],
            ),
          ],
        ),
      ],
    ),

    Category(
      id: "菌类",
      parentProductGroups: [
        ParentProductGroup(
          id: "菌类",
          parentProducts: [
            ParentProduct(
              id: "Junlei",
              name: "味精·菌类",
              childProducts: [
                Product(id: "255", name: "米曲霉菌"),
                Product(id: "256", name: "酿酒酵母"),
                Product(id: "257", name: "醋酸菌"),
                Product(id: "258", name: "毛霉菌"),
                Product(id: "259", name: "乳杆菌"),
                Product(id: "260", name: "谷氨酸钠"),
                Product(id: "261", name: "IMP"),
                Product(id: "262", name: "GMP"),
                Product(id: "263", name: "黑木耳"),
                Product(id: "264", name: "金针菇"),
                Product(id: "265", name: "香菇"),
              ],
            ),
          ],
        ),
      ],
    ),
  ];

  void selectCategory(int index) {
    setState(() {
      _isLoading = true;
      currentCategoryIndex = index;
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '生物篇',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        backgroundColor: Colors.grey[200], // 设置为淡黄色
        foregroundColor: Colors.black,
        centerTitle: true,
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
      body: Row(
        children: [
          CategoryMenu(
            categories: categories,
            currentIndex: currentCategoryIndex,
            onCategorySelected: selectCategory,
          ),
          Expanded(
            child: Container(
              color: Colors.white,
              child:
                  _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : ProductGrid(
                        category: categories[currentCategoryIndex],
                        onProductSelected: (product) {
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
            ),
          ),
        ],
      ),
    );
  }
}
