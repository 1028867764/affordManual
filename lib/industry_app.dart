import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'main.dart';
import 'search_page.dart';
import 'package:cached_network_image/cached_network_image.dart';

class IndustryProductDetailScreen extends StatefulWidget {
  final Map<String, dynamic> product;

  const IndustryProductDetailScreen({super.key, required this.product});

  @override
  State<IndustryProductDetailScreen> createState() => _IndustryProductDetailScreenState();
}

class _IndustryProductDetailScreenState extends State<IndustryProductDetailScreen> {
  bool _isLoading = true;
  String? _enlargedImageUrl;
  final ScrollController _scrollController = ScrollController();
  double _scrollPosition = 0.0;
  List<Map<String, dynamic>> _priceHistory = [];

  @override
  void initState() {
    super.initState();
    _loadPriceHistory();
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) setState(() => _isLoading = false);
    });
  }

  void _loadPriceHistory() {
    final mockData = [
      {"time": "2023-01-01", "price": "¥12.50", "detail": "点击查看详情"},
      {"time": "2023-02-15", "price": "¥13.20", "detail": "点击查看详情"},
    ];
    setState(() => _priceHistory = mockData);
  }

  void _enlargeImage(String imageUrl) {
    _scrollPosition = _scrollController.position.pixels;
    setState(() => _enlargedImageUrl = imageUrl);
  }

  void _closeEnlargedImage() {
    setState(() => _enlargedImageUrl = null);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.jumpTo(_scrollPosition);
    });
  }

  Widget _buildPriceHistoryTable() {
    final latestData = _priceHistory.take(2).toList();
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.orange.shade100,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: const Center(
              child: Text(
                '工业品价格历史',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              dataRowHeight: 30,
              headingRowHeight: 0,
              columnSpacing: 20,
              columns: const [
                DataColumn(label: SizedBox.shrink()),
                DataColumn(label: SizedBox.shrink()),
                DataColumn(label: SizedBox.shrink()),
              ],
              rows: latestData.map((item) => DataRow(
                cells: [
                  DataCell(Text(item['time'])),
                  DataCell(Text(item['price'])),
                  DataCell(
                    InkWell(
                      onTap: () => Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) =>
                              IndustryPriceTag(
                                time: item['time'],
                                price: item['price'],
                                productName: widget.product['name'][0],
                              ),
                          transitionsBuilder: (
                            context,
                            animation,
                            secondaryAnimation,
                            child,
                          ) {
                            const begin = Offset(1.0, 0.0);
                            const end = Offset.zero;
                            const curve = Curves.ease;
                            var tween = Tween(begin: begin, end: end)
                                .chain(CurveTween(curve: curve));
                            var offsetAnimation = animation.drive(tween);
                            return SlideTransition(
                              position: offsetAnimation,
                              child: child,
                            );
                          },
                        ),
                      ),
                      child: const Text(
                        '详情',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ),
                ],
              )).toList(),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final markdownContent = """
# ${widget.product['name'][0]}

## 基本信息
- **产品ID**: ${widget.product['id']}
- **产品名称**: ${widget.product['name'].join(" / ")}

## 产品描述
&emsp;&emsp;这里是工业产品的详细描述。工业产品在现代社会中扮演着至关重要的角色，它们是制造业的基础，支撑着整个经济体系的运转。从原材料到成品，每一个环节都凝聚着人类的智慧和技术的进步。

&emsp;&emsp;工业产品的生产过程通常涉及复杂的工艺流程和严格的质量控制标准。这些产品广泛应用于建筑、交通、电子、化工等各个领域，为社会发展提供了坚实的物质基础。

## 产品图片
![工业产品图片](http://img.tukuppt.com/photo-small/19/94/23/706589110a5f2073682.jpg)

## 技术参数
&emsp;&emsp;以下是该工业产品的主要技术参数：
- 密度: 1.2 g/cm³
- 熔点: 180-200°C
- 抗拉强度: 50 MPa
- 耐腐蚀性: 优良
- 使用寿命: 10年以上

## 应用领域
&emsp;&emsp;该产品广泛应用于以下领域：
1. 建筑行业
2. 汽车制造
3. 电子电器
4. 包装材料
5. 医疗器械

## 产品图片
![工业应用](http://gd-hbimg.huaban.com/2288348e418d1372bab85e5266cae51b2d66503c6155b-KgiKde)
""";

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product['name'][0]),
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
                      pageBuilder: (context, animation, secondaryAnimation) =>
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
                        var tween = Tween(begin: begin, end: end)
                            .chain(CurveTween(curve: curve));
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
      body: _enlargedImageUrl != null
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
                  child: Column(
                    children: [
                      // 价格历史表格（无外边距）
                      Padding(
                        padding: EdgeInsets.zero,
                        child: _buildPriceHistoryTable(),
                      ),
                      Markdown(
                        data: markdownContent,
                        shrinkWrap: true,
                        selectable: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 15),
                        imageBuilder: (uri, title, alt) {
                          return GestureDetector(
                            onTap: () => _enlargeImage(uri.toString()),
                            child: CachedNetworkImage(
                              imageUrl: uri.toString(),
                              placeholder: (context, url) => Container(
                                color: Colors.grey[300],
                                width: 100,
                                height: 100,
                                child: const Icon(
                                  Icons.image,
                                  color: Colors.grey,
                                ),
                              ),
                              errorWidget: (context, url, error) => Container(
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
                    ],
                  ),
                ),
    );
  }
}

class IndustryPriceTag extends StatefulWidget {
  final String time;
  final String price;
  final String productName;

  const IndustryPriceTag({
    super.key,
    required this.time,
    required this.price,
    required this.productName,
  });

@override
  State<IndustryPriceTag> createState() => _IndustryPriceTagState();
}

class _IndustryPriceTagState extends State<IndustryPriceTag> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // 模拟数据加载延迟
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.productName),
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
                      pageBuilder: (context, animation, secondaryAnimation) =>
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
                        var tween = Tween(begin: begin, end: end)
                            .chain(CurveTween(curve: curve));
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
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('时间: ${widget.time}', style: const TextStyle(fontSize: 16)),
            Text('价格: ${widget.price}', style: TextStyle(
              fontSize: 18,
              color: Colors.red.shade700,
              fontWeight: FontWeight.bold,
            )),
          ],
        ),
      ),
    );
  }
}

class IndustryApp extends StatefulWidget {
  const IndustryApp({super.key});

  @override
  State<IndustryApp> createState() => _IndustryAppState();
}

class _IndustryAppState extends State<IndustryApp> {
  final Map<String, List<Map<String, dynamic>>> factories = {
    "橡胶": [
      {"id": 1, "name": ["异戊二烯", "Isoprene"]},
      {"id": 2, "name": ["苯乙烯", "Styrene"]},
      {"id": 3, "name": ["丁二烯", "Butadiene"]},
      {"id": 4, "name": ["异戊橡胶", "Isoprene rubber"]},
      {"id": 5, "name": ["丁苯橡胶", "Styrene-butadiene rubber"]},
      {"id": 6, "name": ["顺丁橡胶", "Cis-butadiene rubber"]},
      {"id": 7, "name": ["SBS橡胶", "SBS rubber"]},
      {"id": 8, "name": ["丁腈橡胶", "Nitrile rubber"]},
      {"id": 9, "name": ["20号胶", "No.20 rubber"]},
    ],
    "树脂": [
      {"id": 10, "name": ["PE树脂", "PE resin"]},
      {"id": 11, "name": ["PP树脂", "PP resin"]},
      {"id": 12, "name": ["PVC树脂", "PVC resin"]},
      {"id": 13, "name": ["PS树脂", "PS resin"]},
      {"id": 14, "name": ["PC树脂", "PC resin"]},
      {"id": 15, "name": ["双酚A", "Bisphenol A"]},
      {"id": 16, "name": ["聚四氟乙烯", "Polytetrafluoroethylene"]},
      {"id": 17, "name": ["ABS树脂", "ABS resin"]},
      {"id": 18, "name": ["丙烯腈", "Acrylonitrile"]},
      {"id": 19, "name": ["PMMA", "Polymethyl methacrylate"]},
      {"id": 20, "name": ["EVA树脂", "EVA resin"]},
      {"id": 21, "name": ["尼龙66", "Nylon 66"]},
      {"id": 22, "name": ["己二胺", "Hexamethylenediamine"]},
      {"id": 23, "name": ["己二酸", "Adipic acid"]},
      {"id": 24, "name": ["尼龙6", "Nylon 6"]},
      {"id": 25, "name": ["己内酰胺", "Caprolactam"]},
      {"id": 26, "name": ["PET", "Polyethylene terephthalate"]},
      {"id": 27, "name": ["PBT", "Polybutylene terephthalate"]},
      {"id": 28, "name": ["TDI", "Toluene diisocyanate"]},
      {"id": 29, "name": ["MDI", "Methylene diphenyl diisocyanate"]},
      {"id": 30, "name": ["聚四氢呋喃", "Polytetrahydrofuran"]},
      {"id": 31, "name": ["聚丙烯腈", "Polyacrylonitrile"]},
      {"id": 32, "name": ["甲醛", "Formaldehyde"]},
      {"id": 33, "name": ["苯酚", "Phenol"]},
      {"id": 34, "name": ["尿素", "Urea"]},
      {"id": 35, "name": ["三聚氰胺", "Melamine"]},
      {"id": 36, "name": ["酚醛树脂", "Phenolic resin"]},
      {"id": 37, "name": ["脲醛树脂", "Urea-formaldehyde resin"]},
      {"id": 38, "name": ["密胺树脂", "Melamine resin"]},
      {"id": 39, "name": ["双酚A型环氧树脂", "Bisphenol A epoxy resin"]},
      {"id": 40, "name": ["二乙烯三胺", "Diethylenetriamine"]},
    ],
    "粘合": [
      {"id": 41, "name": ["羟丙甲纤维素", "Hypromellose"]},
      {"id": 42, "name": ["羧甲纤维素钠", "Sodium carboxymethyl cellulose"]},
      {"id": 43, "name": ["甲基苯酚", "Methylphenol"]},
      {"id": 44, "name": ["白乳胶", "White glue"]},
      {"id": 45, "name": ["502胶水", "502 glue"]},
      {"id": 46, "name": ["氯丁胶", "Neoprene adhesive"]},
      {"id": 47, "name": ["2-氯-1，3-丁二烯", "2-Chloro-1,3-butadiene"]},
      {"id": 48, "name": ["甲苯", "Toluene"]},
      {"id": 49, "name": ["氯苯", "Chlorobenzene"]},
    ],
    "制冷": [
      {"id": 50, "name": ["氨", "Ammonia"]},
      {"id": 51, "name": ["氟利昂_12", "Freon-12"]},
      {"id": 52, "name": ["氟利昂_22", "Freon-22"]},
      {"id": 53, "name": ["氟利昂_134a", "Freon-134a"]},
      {"id": 54, "name": ["环戊烷", "Cyclopentane"]},
    ],
    "食品添加": [
      {"id": 55, "name": ["单硬脂酸甘油酯", "Glyceryl monostearate"]},
      {"id": 56, "name": ["蔗糖脂肪酸酯", "Sucrose fatty acid ester"]},
      {"id": 57, "name": ["硬脂酰乳酸钠", "Sodium stearoyl lactylate"]},
      {"id": 58, "name": ["卵磷脂", "Lecithin"]},
      {"id": 59, "name": ["植脂末T90", "Non-dairy creamer T90"]},
      {"id": 60, "name": ["酪蛋白", "Casein"]},
      {"id": 61, "name": ["L-赖氨酸", "L-Lysine"]},
      {"id": 62, "name": ["葡萄糖酸-δ-内酯", "Glucono-delta-lactone"]},
      {"id": 63, "name": ["卡拉胶", "Carrageenan"]},
      {"id": 64, "name": ["乙基麦芽酚", "Ethyl maltol"]},
    ],
    "木材·纸": [
      {"id": 65, "name": ["木粉", "Wood flour"]},
      {"id": 66, "name": ["胶合板", "Plywood"]},
      {"id": 67, "name": ["刨花板", "Particle board"]},
      {"id": 68, "name": ["纤维板", "Fiberboard"]},
      {"id": 69, "name": ["漂白硫酸盐针叶木浆", "Bleached sulfate softwood pulp"]},
      {"id": 70, "name": ["漂白硫酸盐阔叶木浆", "Bleached sulfate hardwood pulp"]},
      {"id": 71, "name": ["五层AB瓦楞纸", "Five-layer AB corrugated paper"]},
      {"id": 72, "name": ["五层BE瓦楞纸", "Five-layer BE corrugated paper"]},
    ],
    "建筑": [
      {"id": 73, "name": ["铁矿石", "Iron ore"]},
      {"id": 74, "name": ["生铁", "Pig iron"]},
      {"id": 75, "name": ["不锈钢304", "Stainless steel 304"]},
      {"id": 76, "name": ["废铁", "Scrap iron"]},
      {"id": 77, "name": ["1#铬", "No.1 chromium"]},
      {"id": 78, "name": ["1#电解镍", "No.1 electrolytic nickel"]},
      {"id": 79, "name": ["A00铝", "A00 aluminum"]},
      {"id": 80, "name": ["6063铝合金", "6063 aluminum alloy"]},
      {"id": 81, "name": ["1#铜", "No.1 copper"]},
      {"id": 82, "name": ["0#锌", "No.0 zinc"]},
      {"id": 83, "name": ["氧化钙", "Calcium oxide"]},
      {"id": 84, "name": ["氧化铝", "Aluminum oxide"]},
      {"id": 85, "name": ["氧化钾", "Potassium oxide"]},
      {"id": 86, "name": ["氧化钠", "Sodium oxide"]},
      {"id": 87, "name": ["生石膏", "Gypsum"]},
      {"id": 88, "name": ["熟石膏", "Plaster of Paris"]},
      {"id": 89, "name": ["氯化镁", "Magnesium chloride"]},
      {"id": 90, "name": ["滑石", "Talc"]},
      {"id": 91, "name": ["石灰岩碎石", "Limestone gravel"]},
      {"id": 92, "name": ["石灰岩粗砂", "Limestone coarse sand"]},
      {"id": 93, "name": ["石灰岩细砂", "Limestone fine sand"]},
      {"id": 94, "name": ["2#石英", "No.2 quartz"]},
      {"id": 95, "name": ["高岭土", "Kaolin"]},
      {"id": 96, "name": ["325水泥", "325 cement"]},
      {"id": 97, "name": ["425水泥", "425 cement"]},
      {"id": 98, "name": ["525水泥", "525 cement"]},
      {"id": 99, "name": ["钠钙玻璃", "Soda-lime glass"]},
      {"id": 100, "name": ["氯化钙", "Calcium chloride"]},
      {"id": 101, "name": ["标准红砖", "Standard red brick"]},
      {"id": 102, "name": ["烧碱", "Caustic soda"]},
      {"id": 103, "name": ["元明粉", "Glauber's salt"]},
      {"id": 104, "name": ["纯碱", "Soda ash"]},
      {"id": 105, "name": ["硅酸钠", "Sodium silicate"]},
    ],
    "电动车": [
      {"id": 106, "name": ["钕铁硼", "Neodymium magnet"]},
      {"id": 107, "name": ["钕", "Neodymium"]},
      {"id": 108, "name": ["1#锡", "No.1 tin"]},
      {"id": 109, "name": ["1#铅", "No.1 lead"]},
      {"id": 110, "name": ["磷酸亚铁锂", "Lithium iron phosphate"]},
      {"id": 111, "name": ["1#钴", "No.1 cobalt"]},
      {"id": 112, "name": ["1#电解锰", "No.1 electrolytic manganese"]},
      {"id": 113, "name": ["碳酸锂", "Lithium carbonate"]},
      {"id": 114, "name": ["六氟磷酸锂", "Lithium hexafluorophosphate"]},
      {"id": 115, "name": ["氮化镓", "Gallium nitride"]},
    ],
    "能源": [
      {"id": 116, "name": ["液化石油气", "Liquefied petroleum gas"]},
      {"id": 117, "name": ["92#汽油", "92# gasoline"]},
      {"id": 118, "name": ["95#汽油", "95# gasoline"]},
      {"id": 119, "name": ["98#汽油", "98# gasoline"]},
      {"id": 120, "name": ["0#柴油", "0# diesel"]},
      {"id": 121, "name": ["石蜡", "Paraffin wax"]},
      {"id": 122, "name": ["沥青", "Asphalt"]},
      {"id": 123, "name": ["伦敦brent原油", "London Brent crude oil"]},
      {"id": 124, "name": ["纽约WTI原油", "New York WTI crude oil"]},
      {"id": 125, "name": ["天然气", "Natural gas"]},
      {"id": 126, "name": ["5500大卡动力煤", "5500 kcal thermal coal"]},
    ],
    "表面活性": [
      {"id": 127, "name": ["月桂醇聚醚硫酸酯钠", "Sodium laureth sulfate"]},
      {"id": 128, "name": ["月桂醇硫酸酯钠", "Sodium lauryl sulfate"]},
      {"id": 129, "name": ["月桂酰胺肌氨酸钠", "Sodium lauroyl sarcosinate"]},
      {"id": 130, "name": ["月桂酰胺谷氨酸钠", "Sodium lauroyl glutamate"]},
      {"id": 131, "name": ["月桂酰胺基丙基甜菜碱", "Lauramidopropyl betaine"]},
      {"id": 132, "name": ["硬脂酸钠", "Sodium stearate"]},
      {"id": 133, "name": ["棕榈酸钠", "Sodium palmitate"]},
      {"id": 134, "name": ["直链十二烷基苯磺酸钠", "Linear alkylbenzene sulfonate"]},
      {"id": 135, "name": ["椰油酰胺DEA", "Cocamide DEA"]},
      {"id": 136, "name": ["椰油酰胺MEA", "Cocamide MEA"]},
      {"id": 137, "name": ["鲸蜡硬脂基三甲基氯化铵", "Cetrimonium chloride"]},
      {"id": 138, "name": ["直链烷基葡萄糖苷", "Alkyl polyglucoside"]},
    ],
    "助溶": [
      {"id": 139, "name": ["鲸蜡硬脂醇", "Cetearyl alcohol"]},
      {"id": 140, "name": ["甘油", "Glycerin"]},
      {"id": 141, "name": ["聚二甲基硅氧烷", "Dimethicone"]},
      {"id": 142, "name": ["聚二甲基硅氧烷醇", "Dimethiconol"]},
      {"id": 143, "name": ["二甲醚", "Dimethyl ether"]},
      {"id": 144, "name": ["乙醇", "Ethanol"]},
      {"id": 145, "name": ["丙二醇", "Propylene glycol"]},
      {"id": 146, "name": ["丁二醇", "Butylene glycol"]},
      {"id": 147, "name": ["异丙醇", "Isopropyl alcohol"]},
      {"id": 148, "name": ["对甲苯磺酸钠", "Sodium p-toluenesulfonate"]},
      {"id": 149, "name": ["二甲苯磺酸钠", "Sodium xylenesulfonate"]},
      {"id": 150, "name": ["月桂酸", "Lauric acid"]},
      {"id": 151, "name": ["肉豆蔻酸", "Myristic acid"]},
      {"id": 152, "name": ["棕榈酸", "Palmitic acid"]},
      {"id": 153, "name": ["硬脂酸", "Stearic acid"]},
      {"id": 154, "name": ["油酸", "Oleic acid"]},
      {"id": 155, "name": ["亚油酸", "Linoleic acid"]},
    ],
    "香味": [
      {"id": 156, "name": ["香芹酮", "Carvone"]},
      {"id": 157, "name": ["薄荷醇", "Menthol"]},
      {"id": 158, "name": ["β-苯乙醇", "β-Phenylethyl alcohol"]},
      {"id": 159, "name": ["月桂醇", "Lauryl alcohol"]},
      {"id": 160, "name": ["芳樟醇", "Linalool"]},
      {"id": 161, "name": ["柠檬醛", "Citral"]},
      {"id": 162, "name": ["橙花醇", "Nerol"]},
      {"id": 163, "name": ["牻牛儿醇", "Geraniol"]},
      {"id": 164, "name": ["丁香油酚", "Eugenol"]},
      {"id": 165, "name": ["玫瑰醚", "Rose oxide"]},
      {"id": 166, "name": ["异戊酸异戊酯", "Isoamyl isovalerate"]},
      {"id": 167, "name": ["山梨糖醇", "Sorbitol"]},
      {"id": 168, "name": ["木糖醇", "Xylitol"]},
      {"id": 169, "name": ["糖精钠", "Sodium saccharin"]},
    ],
    "颜色": [
      {"id": 170, "name": ["硅酸锆", "Zirconium silicate"]},
      {"id": 171, "name": ["氧化镁", "Magnesium oxide"]},
      {"id": 172, "name": ["氢氧化铝", "Aluminum hydroxide"]},
      {"id": 173, "name": ["铬酸铅", "Lead chromate"]},
      {"id": 174, "name": ["群青蓝", "Ultramarine blue"]},
      {"id": 175, "name": ["金红石型钛白粉", "Rutile titanium dioxide"]},
      {"id": 176, "name": ["炭黑", "Carbon black"]},
      {"id": 177, "name": ["石墨", "Graphite"]},
      {"id": 178, "name": ["氧化铁系颜料", "Iron oxide pigment"]},
      {"id": 179, "name": ["腻子粉", "Putty powder"]},
      {"id": 180, "name": ["CI_19140", "CI 19140"]},
    ],
    "自来水": [
      {"id": 181, "name": ["活性炭", "Activated carbon"]},
      {"id": 182, "name": ["聚合氯化铝", "Polyaluminum chloride"]},
      {"id": 183, "name": ["聚合硫酸铝", "Polyaluminum sulfate"]},
      {"id": 184, "name": ["聚合氯化铁", "Polyferric chloride"]},
      {"id": 185, "name": ["聚合硫酸铁", "Polyferric sulfate"]},
      {"id": 186, "name": ["PVC管", "PVC pipe"]},
      {"id": 187, "name": ["PPR管", "PPR pipe"]},
    ],
    "其他": [
      {"id": 188, "name": ["氟氯醚菊酯", "Flumethrin"]},
      {"id": 189, "name": ["靛蓝", "Indigo"]},
      {"id": 190, "name": ["保险粉", "Sodium dithionite"]},
      {"id": 191, "name": ["高锰酸钾", "Potassium permanganate"]},
      {"id": 192, "name": ["草酸", "Oxalic acid"]},
      {"id": 193, "name": ["硫磺", "Sulfur"]},
      {"id": 194, "name": ["硝酸钾", "Potassium nitrate"]},
      {"id": 195, "name": ["苯氧乙醇", "Phenoxyethanol"]},
      {"id": 196, "name": ["苯甲酸钠", "Sodium benzoate"]},
      {"id": 197, "name": ["山梨酸钾", "Potassium sorbate"]},
      {"id": 198, "name": ["柠檬酸", "Citric acid"]},
      {"id": 199, "name": ["氧化锌", "Zinc oxide"]},
      {"id": 200, "name": ["吡硫鎓锌", "Zinc pyrithione"]},
      {"id": 201, "name": ["磷酸氢钙", "Calcium hydrogen phosphate"]},
      {"id": 202, "name": ["聚乙二醇", "Polyethylene glycol"]},
      {"id": 203, "name": ["单氟磷酸钠", "Sodium monofluorophosphate"]},
      {"id": 204, "name": ["次氯酸盐", "Hypochlorite"]},
      {"id": 205, "name": ["碱性蛋白酶", "Alkaline protease"]},
      {"id": 206, "name": ["EDTA二钠", "Disodium EDTA"]},
      {"id": 207, "name": ["EDTA四钠", "Tetrasodium EDTA"]},
      {"id": 208, "name": ["乙二醇二硬脂酸钠", "Ethylene glycol distearate"]},
      {"id": 209, "name": ["泛醇", "Panthenol"]},
    ]
  };

  String selectedCategory = "橡胶";
  bool _isLoadingProducts = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    selectedCategory = factories.keys.first;
  }

  void _changeCategory(String category) {
    setState(() {
      selectedCategory = category;
      _isLoadingProducts = true;
    });
    
    // Simulate loading delay
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _isLoadingProducts = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '工业篇',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        backgroundColor: Colors.grey[200],
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
                      pageBuilder: (context, animation, secondaryAnimation) =>
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
                        var tween = Tween(begin: begin, end: end)
                            .chain(CurveTween(curve: curve));
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
          // 左侧导航栏
          Container(
            width: 100,
            color: Colors.grey[200],
            child: ListView.builder(
              itemCount: factories.keys.length,
              itemBuilder: (context, index) {
                final category = factories.keys.elementAt(index);
                return GestureDetector(
                  onTap: () => _changeCategory(category),
                  child: Container(
                    height: 40,
                    color: selectedCategory == category
                        ? Colors.white
                        : Colors.grey[200],
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    alignment: Alignment.center,
                    child: Text(
                      category,
                      style: TextStyle(
                        fontSize: 13,
                        color: selectedCategory == category
                            ? Colors.blue
                            : Colors.black,
                        fontWeight: selectedCategory == category
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                );
              },
            ),
          ),
          // 右侧商品列表
          Expanded(
            child: Container(
              color: Colors.white,
              child: _isLoadingProducts
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : CustomScrollView(
                      controller: _scrollController,
                      slivers: [
                        SliverPadding(
                          padding: const EdgeInsets.all(16),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                final item = factories[selectedCategory]![index];
                                final itemName = item['name'][0];
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        pageBuilder: (context, animation, secondaryAnimation) =>
                                            IndustryProductDetailScreen(
                                              product: item,
                                            ),
                                        transitionsBuilder: (
                                          context,
                                          animation,
                                          secondaryAnimation,
                                          child,
                                        ) {
                                          const begin = Offset(1.0, 0.0);
                                          const end = Offset.zero;
                                          const curve = Curves.ease;
                                          var tween = Tween(begin: begin, end: end)
                                              .chain(CurveTween(curve: curve));
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
                                    margin: const EdgeInsets.only(bottom: 12),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[50],
                                      borderRadius: BorderRadius.circular(8),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.1),
                                          spreadRadius: 1,
                                          blurRadius: 3,
                                          offset: const Offset(0, 1),
                                        ),
                                      ],
                                    ),
                                    child: ListTile(
                                      leading: Container(
                                        width: 48,
                                        height: 48,
                                        decoration: BoxDecoration(
                                          color: Colors.blue[50],
                                          shape: BoxShape.circle,
                                        ),
                                        child: Center(
                                          child: Text(
                                            itemName.substring(0, 1),
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blue,
                                            ),
                                          ),
                                        ),
                                      ),
                                      title: Text(
                                        itemName,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      subtitle: const Text(
                                        '暂无价格',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 8,
                                      ),
                                    ),
                                  ),
                                );
                              },
                              childCount: factories[selectedCategory]!.length,
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}