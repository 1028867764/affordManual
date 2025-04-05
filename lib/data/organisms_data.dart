class Product {
  final String id;
  final List<String> name; // 改为数组形式

  Product({required this.id, required this.name});
}

class ParentProduct {
  final String id;
  final List<String> name; // 改为数组形式
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

final List<Category> organisms = [
  Category(
    id: "唇形目",
    parentProductGroups: [
      ParentProductGroup(
        id: "唇形科",
        parentProducts: [
          ParentProduct(
            id: "Mentha",
            name: ["薄荷属"],
            childProducts: [
              Product(id: "organismsMentha1", name: ["椒样薄荷"]),
              Product(id: "organismsMentha2", name: ["留兰香薄荷"]),
            ],
          ),
          ParentProduct(
            id: "Pogostemon",
            name: ["刺蕊草属"],
            childProducts: [
              Product(id: "organismsPogostemon1", name: ["广藿香"]),
            ],
          ),
          ParentProduct(
            id: "Platostoma",
            name: ["仙草属"],
            childProducts: [
              Product(id: "organismsPlatostoma1", name: ["仙草"]),
            ],
          ),
          ParentProduct(
            id: "Perilla",
            name: ["紫苏属"],
            childProducts: [
              Product(id: "organismsPerilla1", name: ["紫苏"]),
            ],
          ),
        ],
      ),
      ParentProductGroup(
        id: "木樨科",
        parentProducts: [
          ParentProduct(
            id: "Jasminum",
            name: ["素馨属"],
            childProducts: [
              Product(id: "organismsJasminum1", name: ["茉莉花"]),
            ],
          ),
        ],
      ),
      ParentProductGroup(
        id: "脂麻科",
        parentProducts: [
          ParentProduct(
            id: "Sesamum",
            name: ["脂麻属"],
            childProducts: [
              Product(id: "organismsSesamum1", name: ["芝麻粒"]),
            ],
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
            name: ["菜豆属"],
            childProducts: [
              Product(id: "organismsPhaseolus1", name: ["荷包豆"]),
              Product(id: "organismsPhaseolus2", name: ["四季豆"]),
            ],
          ),
          ParentProduct(
            id: "Glycine",
            name: ["大豆属"],
            childProducts: [
              Product(id: "organismsGlycine1", name: ["毛豆"]),
              Product(id: "organismsGlycine2", name: ["青大豆"]),
              Product(id: "organismsGlycine3", name: ["黄大豆1号"]),
              Product(id: "organismsGlycine4", name: ["黑大豆"]),
              Product(id: "organismsGlycine5", name: ["黄大豆粉"]),
              Product(id: "organismsGlycine6", name: ["豆腐"]),
              Product(id: "organismsGlycine7", name: ["豆腐泡"]),
              Product(id: "organismsGlycine8", name: ["豆腐干"]),
              Product(id: "organismsGlycine9", name: ["腐竹"]),
              Product(id: "organismsGlycine10", name: ["大豆油"]),
              Product(id: "organismsGlycine11", name: ["酱油"]),
              Product(id: "organismsGlycine12", name: ["黑豆豉"]),
              Product(id: "organismsGlycine13", name: ["黄豆酱"]),
              Product(id: "organismsGlycine14", name: ["腐乳"]),
              Product(id: "organismsGlycine15", name: ["豆粕"]),
              Product(id: "organismsGlycine16", name: ["黄豆芽"]),
            ],
          ),
          ParentProduct(
            id: "Vigna",
            name: ["豇豆属"],
            childProducts: [
              Product(id: "organismsVigna1", name: ["豇豆荚"]),
              Product(id: "organismsVigna2", name: ["白豇豆"]),
              Product(id: "organismsVigna3", name: ["绿豆"]),
              Product(id: "organismsVigna4", name: ["绿豆芽"]),
              Product(id: "organismsVigna5", name: ["绿豆淀粉"]),
              Product(id: "organismsVigna6", name: ["红豆"]),
            ],
          ),
          ParentProduct(
            id: "Arachis",
            name: ["落花生属"],
            childProducts: [
              Product(id: "organismsArachis1", name: ["带壳花生"]),
              Product(id: "organismsArachis2", name: ["花生仁"]),
              Product(id: "organismsArachis3", name: ["花生油"]),
              Product(id: "organismsArachis4", name: ["花生粕"]),
            ],
          ),
          ParentProduct(
            id: "Pisum",
            name: ["豌豆属"],
            childProducts: [
              Product(id: "organismsPisum1", name: ["豌豆荚"]),
              Product(id: "organismsPisum2", name: ["豌豆"]),
              Product(id: "organismsPisum3", name: ["豌豆藤"]),
              Product(id: "organismsPisum4", name: ["豌豆芽"]),
              Product(id: "organismsPisum5", name: ["豌豆淀粉"]),
            ],
          ),
          ParentProduct(
            id: "Glycyrrhiza",
            name: ["甘草属"],
            childProducts: [
              Product(id: "organismsGlycyrrhiza1", name: ["甘草"]),
            ],
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
            name: ["凤梨属"],
            childProducts: [
              Product(id: "organismsAnanas1", name: ["菠萝"]),
            ],
          ),
        ],
      ),
      ParentProductGroup(
        id: "禾本科",
        parentProducts: [
          ParentProduct(
            id: "Oryza",
            name: ["稻属"],
            childProducts: [
              Product(id: "organismsOryza1", name: ["籼米"]),
              Product(id: "organismsOryza2", name: ["粘米粉"]),
              Product(id: "organismsOryza3", name: ["糯米"]),
              Product(id: "organismsOryza4", name: ["糯米粉"]),
              Product(id: "organismsOryza5", name: ["米糠"]),
              Product(id: "organismsOryza6", name: ["米酒"]),
              Product(id: "organismsOryza7", name: ["米醋"]),
              Product(id: "organismsOryza8", name: ["稻秆"]),
            ],
          ),
          ParentProduct(
            id: "Saccharum",
            name: ["甘蔗属"],
            childProducts: [
              Product(id: "organismsSaccharum1", name: ["甘蔗"]),
              Product(id: "organismsSaccharum2", name: ["一级白糖"]),
              Product(id: "organismsSaccharum3", name: ["三氯蔗糖"]),
              Product(id: "organismsSaccharum4", name: ["蔗渣"]),
            ],
          ),
          ParentProduct(
            id: "Triticum",
            name: ["小麦属"],
            childProducts: [
              Product(id: "organismsTriticum1", name: ["高筋面粉"]),
              Product(id: "organismsTriticum2", name: ["中筋面粉"]),
              Product(id: "organismsTriticum3", name: ["低筋面粉"]),
              Product(id: "organismsTriticum4", name: ["澄粉"]),
              Product(id: "organismsTriticum5", name: ["麦麸"]),
              Product(id: "organismsTriticum6", name: ["麦秆"]),
            ],
          ),
          ParentProduct(
            id: "Zea",
            name: ["玉米属"],
            childProducts: [
              Product(id: "organismsZea1", name: ["饲料玉米棒"]),
              Product(id: "organismsZea2", name: ["饲料玉米粒"]),
              Product(id: "organismsZea3", name: ["水果玉米棒"]),
              Product(id: "organismsZea4", name: ["水果玉米粒"]),
              Product(id: "organismsZea5", name: ["糯玉米棒"]),
              Product(id: "organismsZea6", name: ["玉米淀粉"]),
              Product(id: "organismsZea7", name: ["玉米秆"]),
            ],
          ),
        ],
      ),
      ParentProductGroup(
        id: "竹亚科",
        parentProducts: [
          ParentProduct(
            id: "Bambusoideae",
            name: ["竹亚科"],
            childProducts: [
              Product(id: "organismsBambusoideae1", name: ["竹笋"]),
              Product(id: "organismsBambusoideae2", name: ["竹浆"]),
              Product(id: "organismsBambusoideae3", name: ["竹木材"]),
              Product(id: "organismsBambusoideae4", name: ["竹叶"]),
              Product(id: "organismsBambusoideae5", name: ["竹篾"]),
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
            name: ["黄瓜属"],
            childProducts: [
              Product(id: "organismsCucumis1", name: ["黄瓜"]),
              Product(id: "organismsCucumis2", name: ["哈密瓜"]),
              Product(id: "organismsCucumis3", name: ["香瓜"]),
            ],
          ),
          ParentProduct(
            id: "Siraitia",
            name: ["罗汉果属"],
            childProducts: [
              Product(id: "organismsSiraitia1", name: ["罗汉果"]),
            ],
          ),
          ParentProduct(
            id: "Citrullus",
            name: ["西瓜属"],
            childProducts: [
              Product(id: "organismsCitrullus1", name: ["西瓜"]),
              Product(id: "organismsCitrullus2", name: ["西瓜籽"]),
            ],
          ),
          ParentProduct(
            id: "Cucurbita",
            name: ["南瓜属"],
            childProducts: [
              Product(id: "organismsCucurbita1", name: ["南瓜"]),
              Product(id: "organismsCucurbita2", name: ["南瓜籽"]),
              Product(id: "organismsCucurbita3", name: ["南瓜苗"]),
              Product(id: "organismsCucurbita4", name: ["南瓜花"]),
            ],
          ),
          ParentProduct(
            id: "Luffa",
            name: ["丝瓜属"],
            childProducts: [
              Product(id: "organismsLuffa1", name: ["丝瓜"]),
            ],
          ),
          ParentProduct(
            id: "Benincasa",
            name: ["冬瓜属"],
            childProducts: [
              Product(id: "organismsBenincasa1", name: ["冬瓜"]),
            ],
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
            name: ["芭蕉属"],
            childProducts: [
              Product(id: "organismsMusa1", name: ["Williams香蕉"]),
            ],
          ),
        ],
      ),
      ParentProductGroup(
        id: "竹芋科",
        parentProducts: [
          ParentProduct(
            id: "Phrynium",
            name: ["柊叶属"],
            childProducts: [
              Product(id: "organismsPhrynium1", name: ["柊叶"]),
            ],
          ),
        ],
      ),
      ParentProductGroup(
        id: "姜科",
        parentProducts: [
          ParentProduct(
            id: "Curcuma",
            name: ["姜黄属"],
            childProducts: [
              Product(id: "organismsCurcuma1", name: ["姜黄"]),
            ],
          ),
          ParentProduct(
            id: "Zingiber",
            name: ["姜属"],
            childProducts: [
              Product(id: "organismsZingiber1", name: ["生姜"]),
            ],
          ),
          ParentProduct(
            id: "Wurfbainia",
            name: ["砂仁属"],
            childProducts: [
              Product(id: "organismsWurfbainia1", name: ["爪哇白豆蔻"]),
            ],
          ),
          ParentProduct(
            id: "Lanxangia",
            name: ["草果属"],
            childProducts: [
              Product(id: "organismsLanxangia1", name: ["草果"]),
            ],
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
            name: ["蒲公英属"],
            childProducts: [
              Product(id: "organismsTaraxacum1", name: ["蒲公英"]),
            ],
          ),
          ParentProduct(
            id: "Lactuca",
            name: ["莴苣属"],
            childProducts: [
              Product(id: "organismsLactuca1", name: ["生菜"]),
              Product(id: "organismsLactuca2", name: ["油麦菜"]),
              Product(id: "organismsLactuca3", name: ["莴笋"]),
            ],
          ),
          ParentProduct(
            id: "Helianthus",
            name: ["向日葵属"],
            childProducts: [
              Product(id: "organismsHelianthus1", name: ["葵花籽"]),
              Product(id: "organismsHelianthus2", name: ["葵花籽仁"]),
            ],
          ),
          ParentProduct(
            id: "Chrysanthemum",
            name: ["菊属"],
            childProducts: [
              Product(id: "organismsChrysanthemum1", name: ["菊花"]),
            ],
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
            name: ["栗属"],
            childProducts: [
              Product(id: "organismsCastanea1", name: ["板栗"]),
            ],
          ),
        ],
      ),
      ParentProductGroup(
        id: "胡桃科",
        parentProducts: [
          ParentProduct(
            id: "Juglans",
            name: ["胡桃属"],
            childProducts: [
              Product(id: "organismsJuglans1", name: ["核桃"]),
            ],
          ),
          ParentProduct(
            id: "Engelhardtia",
            name: ["黄杞属"],
            childProducts: [
              Product(id: "organismsEngelhardtia1", name: ["大叶茶"]),
            ],
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
            name: ["草莓属"],
            childProducts: [
              Product(id: "organismsFragaria1", name: ["草莓"]),
            ],
          ),
          ParentProduct(
            id: "Pyrus",
            name: ["梨属"],
            childProducts: [
              Product(id: "organismsPyrus1", name: ["梨子"]),
            ],
          ),
          ParentProduct(
            id: "Prunus",
            name: ["李属"],
            childProducts: [
              Product(id: "organismsPrunus1", name: ["扁桃仁"]),
              Product(id: "organismsPrunus2", name: ["桃子"]),
              Product(id: "organismsPrunus3", name: ["李子"]),
              Product(id: "organismsPrunus4", name: ["梅子"]),
            ],
          ),
          ParentProduct(
            id: "Eriobotrya",
            name: ["枇杷属"],
            childProducts: [
              Product(id: "organismsEriobotrya1", name: ["枇杷"]),
              Product(id: "organismsEriobotrya2", name: ["枇杷叶"]),
            ],
          ),
          ParentProduct(
            id: "Malus",
            name: ["苹果属"],
            childProducts: [
              Product(id: "organismsMalus1", name: ["80mm红富士苹果"]),
            ],
          ),
          ParentProduct(
            id: "Rosa",
            name: ["蔷薇属"],
            childProducts: [
              Product(id: "organismsRosa1", name: ["卡罗拉玫瑰"]),
              Product(id: "organismsRosa2", name: ["黑魔术玫瑰"]),
              Product(id: "organismsRosa3", name: ["戴安娜玫瑰"]),
              Product(id: "organismsRosa4", name: ["精油玫瑰"]),
            ],
          ),
          ParentProduct(
            id: "Crataegus",
            name: ["山楂属"],
            childProducts: [
              Product(id: "organismsCrataegus1", name: ["山楂"]),
            ],
          ),
        ],
      ),
      ParentProductGroup(
        id: "鼠李科",
        parentProducts: [
          ParentProduct(
            id: "Ziziphus",
            name: ["枣属"],
            childProducts: [
              Product(id: "organismsZiziphus1", name: ["一级红枣"]),
            ],
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
            name: ["辣椒属"],
            childProducts: [
              Product(id: "organismsCapsicum1", name: ["辣椒"]),
            ],
          ),
          ParentProduct(
            id: "Solanum",
            name: ["茄属"],
            childProducts: [
              Product(id: "organismsSolanum1", name: ["番茄"]),
              Product(id: "organismsSolanum2", name: ["茄子"]),
              Product(id: "organismsSolanum3", name: ["土豆"]),
            ],
          ),
        ],
      ),
      ParentProductGroup(
        id: "旋花科",
        parentProducts: [
          ParentProduct(
            id: "Ipomoea",
            name: ["番薯属"],
            childProducts: [
              Product(id: "organismsIpomoea1", name: ["红薯"]),
              Product(id: "organismsIpomoea2", name: ["紫薯"]),
              Product(id: "organismsIpomoea3", name: ["红薯叶"]),
              Product(id: "organismsIpomoea4", name: ["空心菜"]),
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
            name: ["当归属"],
            childProducts: [
              Product(id: "organismsAngelica1", name: ["白芷"]),
            ],
          ),
          ParentProduct(
            id: "Daucus",
            name: ["胡萝卜属"],
            childProducts: [
              Product(id: "organismsDaucus1", name: ["胡萝卜"]),
            ],
          ),
          ParentProduct(
            id: "Foeniculum",
            name: ["茴香属"],
            childProducts: [
              Product(id: "organismsFoeniculum1", name: ["茴香籽"]),
            ],
          ),
          ParentProduct(
            id: "Apium",
            name: ["芹属"],
            childProducts: [
              Product(id: "organismsApium1", name: ["细芹菜"]),
              Product(id: "organismsApium2", name: ["粗芹菜"]),
            ],
          ),
          ParentProduct(
            id: "Coriandrum",
            name: ["芫荽属"],
            childProducts: [
              Product(id: "organismsCoriandrum1", name: ["芫荽"]),
              Product(id: "organismsCoriandrum2", name: ["芫荽籽"]),
            ],
          ),
          ParentProduct(
            id: "Cuminum",
            name: ["孜然芹属"],
            childProducts: [
              Product(id: "organismsCuminum1", name: ["孜然籽"]),
            ],
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
            name: ["萝卜属"],
            childProducts: [
              Product(id: "organismsRaphanus1", name: ["萝卜"]),
            ],
          ),
          ParentProduct(
            id: "Isatis",
            name: ["菘蓝属"],
            childProducts: [
              Product(id: "organismsIsatis1", name: ["大青叶"]),
              Product(id: "organismsIsatis2", name: ["板蓝根"]),
            ],
          ),
          ParentProduct(
            id: "Brassica_juncea",
            name: ["芸薹属_芥菜"],
            childProducts: [
              Product(id: "organismsBrassica_juncea1", name: ["榨菜"]),
              Product(id: "organismsBrassica_juncea2", name: ["大头菜"]),
              Product(id: "organismsBrassica_juncea3", name: ["雪里蕻"]),
              Product(id: "organismsBrassica_juncea4", name: ["包心芥菜"]),
              Product(id: "organismsBrassica_juncea5", name: ["其它芥菜"]),
              Product(id: "organismsBrassica_juncea6", name: ["黄芥末籽"]),
            ],
          ),
          ParentProduct(
            id: "Brassica_oleracea",
            name: ["芸薹属_甘蓝"],
            childProducts: [
              Product(id: "organismsBrassica_oleracea1", name: ["西兰花"]),
              Product(id: "organismsBrassica_oleracea2", name: ["花椰菜"]),
              Product(id: "organismsBrassica_oleracea3", name: ["卷心菜"]),
              Product(id: "organismsBrassica_oleracea4", name: ["其它甘蓝"]),
            ],
          ),
          ParentProduct(
            id: "Brassica_rapa",
            name: ["芸薹属_芸薹"],
            childProducts: [
              Product(id: "organismsBrassica_rapa1", name: ["大白菜"]),
              Product(id: "organismsBrassica_rapa2", name: ["娃娃菜"]),
              Product(id: "organismsBrassica_rapa3", name: ["白菜苔"]),
              Product(id: "organismsBrassica_rapa4", name: ["其它白菜"]),
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
            name: ["杉属"],
            childProducts: [
              Product(id: "organismsCunninghamia1", name: ["杉木材"]),
            ],
          ),
        ],
      ),
      ParentProductGroup(
        id: "松科",
        parentProducts: [
          ParentProduct(
            id: "Pinus",
            name: ["松属"],
            childProducts: [
              Product(id: "organismsPinus1", name: ["马尾松木材"]),
            ],
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
            name: ["桉属"],
            childProducts: [
              Product(id: "organismsEucalyptus1", name: ["尾叶桉木材"]),
            ],
          ),
          ParentProduct(
            id: "Syzygium",
            name: ["蒲桃属"],
            childProducts: [
              Product(id: "organismsSyzygium1", name: ["公丁香"]),
            ],
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
            name: ["葱属"],
            childProducts: [
              Product(id: "organismsAllium1", name: ["葱"]),
              Product(id: "organismsAllium2", name: ["韭菜"]),
              Product(id: "organismsAllium3", name: ["蒜瓣"]),
              Product(id: "organismsAllium4", name: ["蒜苗"]),
              Product(id: "organismsAllium5", name: ["荞头"]),
              Product(id: "organismsAllium6", name: ["洋葱"]),
              Product(id: "organismsAllium7", name: ["红葱头"]),
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
            name: ["芒果属"],
            childProducts: [
              Product(id: "organismsMangifera1", name: ["芒果"]),
            ],
          ),
          ParentProduct(
            id: "Anacardium",
            name: ["腰果属"],
            childProducts: [
              Product(id: "organismsAnacardium1", name: ["腰果仁"]),
            ],
          ),
        ],
      ),
      ParentProductGroup(
        id: "无患子科",
        parentProducts: [
          ParentProduct(
            id: "Litchi",
            name: ["荔枝属"],
            childProducts: [
              Product(id: "organismsLitchi1", name: ["荔枝"]),
            ],
          ),
          ParentProduct(
            id: "Dimocarpus",
            name: ["龙眼属"],
            childProducts: [
              Product(id: "organismsDimocarpus1", name: ["龙眼"]),
            ],
          ),
        ],
      ),
      ParentProductGroup(
        id: "芸香科",
        parentProducts: [
          ParentProduct(
            id: "Citrus",
            name: ["柑橘属"],
            childProducts: [
              Product(id: "organismsCitrus1", name: ["柚"]),
              Product(id: "organismsCitrus2", name: ["橘"]),
              Product(id: "organismsCitrus3", name: ["橙"]),
              Product(id: "organismsCitrus4", name: ["柑"]),
              Product(id: "organismsCitrus5", name: ["柠檬"]),
              Product(id: "organismsCitrus6", name: ["橘皮"]),
            ],
          ),
          ParentProduct(
            id: "Zanthoxylum",
            name: ["花椒属"],
            childProducts: [
              Product(id: "organismsZanthoxylum1", name: ["花椒"]),
            ],
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
            name: ["肉桂属"],
            childProducts: [
              Product(id: "organismsCinnamomum1", name: ["肉桂"]),
            ],
          ),
          ParentProduct(
            id: "Laurus",
            name: ["月桂属"],
            childProducts: [
              Product(id: "organismsLaurus1", name: ["月桂叶"]),
            ],
          ),
          ParentProduct(
            id: "Camphora",
            name: ["樟属"],
            childProducts: [
              Product(id: "organismsCamphora1", name: ["樟树木材"]),
            ],
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
            name: ["椰属"],
            childProducts: [
              Product(id: "organismsCocos1", name: ["椰子油"]),
              Product(id: "organismsCocos2", name: ["椰子壳"]),
            ],
          ),
          ParentProduct(
            id: "Elaeis",
            name: ["油棕属"],
            childProducts: [
              Product(id: "organismsElaeis1", name: ["棕榈油"]),
              Product(id: "organismsElaeis2", name: ["棕榈仁油"]),
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
            name: ["八角属"],
            childProducts: [
              Product(id: "organismsIllicium1", name: ["八角"]),
            ],
          ),
        ],
      ),
      ParentProductGroup(
        id: "锦葵科",
        parentProducts: [
          ParentProduct(
            id: "Gossypium",
            name: ["棉花属"],
            childProducts: [
              Product(id: "organismsGossypium1", name: ["棉花"]),
              Product(id: "organismsGossypium2", name: ["棉纱"]),
            ],
          ),
        ],
      ),
      ParentProductGroup(
        id: "莲科",
        parentProducts: [
          ParentProduct(
            id: "Nelumbo",
            name: ["莲属"],
            childProducts: [
              Product(id: "organismsNelumbo1", name: ["莲藕"]),
            ],
          ),
        ],
      ),
      ParentProductGroup(
        id: "忍冬科",
        parentProducts: [
          ParentProduct(
            id: "Lonicera",
            name: ["忍冬属"],
            childProducts: [
              Product(id: "organismsLonicera1", name: ["忍冬花"]),
            ],
          ),
        ],
      ),
      ParentProductGroup(
        id: "山茶科",
        parentProducts: [
          ParentProduct(
            id: "Camellia",
            name: ["山茶属"],
            childProducts: [
              Product(id: "organismsCamellia1", name: ["阿萨姆红茶"]),
              //   Product(id: "organismsCamellia2", name: ["红茶粉"]),
            ],
          ),
        ],
      ),
      ParentProductGroup(
        id: "茜草科",
        parentProducts: [
          ParentProduct(
            id: "Gardenia",
            name: ["栀子属"],
            childProducts: [
              Product(id: "organismsGardenia1", name: ["栀子"]),
            ],
          ),
        ],
      ),
      ParentProductGroup(
        id: "葡萄科",
        parentProducts: [
          ParentProduct(
            id: "Vitis",
            name: ["葡萄属"],
            childProducts: [
              Product(id: "organismsVitis1", name: ["葡萄"]),
              Product(id: "organismsVitis2", name: ["葡萄干"]),
            ],
          ),
        ],
      ),
      ParentProductGroup(
        id: "仙人掌科",
        parentProducts: [
          ParentProduct(
            id: "Selenicereus",
            name: ["蛇鞭柱属"],
            childProducts: [
              Product(id: "organismsSelenicereus1", name: ["火龙果"]),
            ],
          ),
        ],
      ),
      ParentProductGroup(
        id: "大戟科",
        parentProducts: [
          ParentProduct(
            id: "Manihot",
            name: ["木薯属"],
            childProducts: [
              Product(id: "organismsManihot1", name: ["木薯淀粉"]),
            ],
          ),
        ],
      ),
      ParentProductGroup(
        id: "天南星科",
        parentProducts: [
          ParentProduct(
            id: "Colocasia",
            name: ["芋属"],
            childProducts: [
              Product(id: "organismsColocasia1", name: ["芋头"]),
              Product(id: "organismsColocasia2", name: ["芋叶柄"]),
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
            name: ["原鸡属"],
            childProducts: [
              Product(id: "organismsGallus1", name: ["活鸡"]),
              Product(id: "organismsGallus2", name: ["白条鸡"]),
              Product(id: "organismsGallus3", name: ["鸡胸肉"]),
              Product(id: "organismsGallus4", name: ["鸡腿"]),
              Product(id: "organismsGallus5", name: ["鸡翅"]),
              Product(id: "organismsGallus6", name: ["鸡翅尖"]),
              Product(id: "organismsGallus7", name: ["鸡翅根"]),
              Product(id: "organismsGallus8", name: ["鸡爪"]),
              Product(id: "organismsGallus9", name: ["鸡肠"]),
              Product(id: "organismsGallus10", name: ["鸡胗"]),
              Product(id: "organismsGallus11", name: ["鸡心"]),
              Product(id: "organismsGallus12", name: ["鸡肝"]),
              Product(id: "organismsGallus13", name: ["鸡皮"]),
              Product(id: "organismsGallus14", name: ["鸡蛋"]),
              Product(id: "organismsGallus15", name: ["鸡毛"]),
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
            name: ["鸭属|疣鼻栖鸭属"],
            childProducts: [
              Product(id: "organismsAnas_Cairina1", name: ["活鸭"]),
              Product(id: "organismsAnas_Cairina2", name: ["白条鸭"]),
              Product(id: "organismsAnas_Cairina3", name: ["鸭翅"]),
              Product(id: "organismsAnas_Cairina4", name: ["鸭腿"]),
              Product(id: "organismsAnas_Cairina5", name: ["鸭掌"]),
              Product(id: "organismsAnas_Cairina6", name: ["鸭肠"]),
              Product(id: "organismsAnas_Cairina7", name: ["鸭胗"]),
              Product(id: "organismsAnas_Cairina8", name: ["鸭舌"]),
              Product(id: "organismsAnas_Cairina9", name: ["鸭脖"]),
              Product(id: "organismsAnas_Cairina10", name: ["鸭心"]),
              Product(id: "organismsAnas_Cairina11", name: ["鸭肝"]),
              Product(id: "organismsAnas_Cairina12", name: ["鸭蛋"]),
              Product(id: "organismsAnas_Cairina13", name: ["皮蛋"]),
              Product(id: "organismsAnas_Cairina14", name: ["鸭毛"]),
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
            name: ["猪属"],
            childProducts: [
              Product(id: "organismsSus1", name: ["生猪"]),
              Product(id: "organismsSus2", name: ["白条猪"]),
              Product(id: "organismsSus3", name: ["猪皮"]),
              Product(id: "organismsSus4", name: ["猪板油"]),
              Product(id: "organismsSus5", name: ["肥膘肉"]),
              Product(id: "organismsSus6", name: ["猪面颊"]),
              Product(id: "organismsSus7", name: ["猪下巴"]),
              Product(id: "organismsSus8", name: ["猪颈肉"]),
              Product(id: "organismsSus9", name: ["猪舌头"]),
              Product(id: "organismsSus10", name: ["猪耳"]),
              Product(id: "organismsSus11", name: ["猪脑"]),
              Product(id: "organismsSus12", name: ["猪脊骨"]),
              Product(id: "organismsSus13", name: ["猪肋排骨"]),
              Product(id: "organismsSus14", name: ["猪外脊肉"]),
              Product(id: "organismsSus15", name: ["猪里脊肉"]),
              Product(id: "organismsSus16", name: ["五花肉"]),
              Product(id: "organismsSus17", name: ["猪肩胛肉"]),
              Product(id: "organismsSus18", name: ["猪前大腿"]),
              Product(id: "organismsSus19", name: ["猪后大腿"]),
              Product(id: "organismsSus20", name: ["猪大腿骨"]),
              Product(id: "organismsSus21", name: ["猪前肘"]),
              Product(id: "organismsSus22", name: ["猪后肘"]),
              Product(id: "organismsSus23", name: ["猪前蹄"]),
              Product(id: "organismsSus24", name: ["猪后蹄"]),
              Product(id: "organismsSus25", name: ["猪尾巴"]),
              Product(id: "organismsSus26", name: ["猪腰子"]),
              Product(id: "organismsSus27", name: ["猪心"]),
              Product(id: "organismsSus28", name: ["猪肝"]),
              Product(id: "organismsSus29", name: ["猪肺"]),
              Product(id: "organismsSus30", name: ["猪小肠"]),
              Product(id: "organismsSus31", name: ["猪大肠"]),
              Product(id: "organismsSus32", name: ["猪肚"]),
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
            name: ["粉甲虫属"],
            childProducts: [
              Product(id: "organismsTenebrio1", name: ["面包虫"]),
            ],
          ),
        ],
      ),
      ParentProductGroup(
        id: "对虾科",
        parentProducts: [
          ParentProduct(
            id: "Penaeidae",
            name: ["对虾科"],
            childProducts: [
              Product(id: "organismsPenaeidae1", name: ["对虾"]),
            ],
          ),
        ],
      ),
      ParentProductGroup(
        id: "田螺科",
        parentProducts: [
          ParentProduct(
            id: "Viviparidae",
            name: ["田螺科"],
            childProducts: [
              Product(id: "organismsViviparidae1", name: ["田螺"]),
            ],
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
            name: ["味精·菌类"],
            childProducts: [
              Product(id: "organismsJunlei1", name: ["米曲霉菌"]),
              Product(id: "organismsJunlei2", name: ["酿酒酵母"]),
              Product(id: "organismsJunlei3", name: ["醋酸菌"]),
              Product(id: "organismsJunlei4", name: ["毛霉菌"]),
              Product(id: "organismsJunlei5", name: ["乳杆菌"]),
              Product(id: "organismsJunlei6", name: ["谷氨酸钠"]),
              Product(id: "organismsJunlei7", name: ["IMP"]),
              Product(id: "organismsJunlei8", name: ["GMP"]),
              Product(id: "organismsJunlei9", name: ["黑木耳"]),
              Product(id: "organismsJunlei10", name: ["金针菇"]),
              Product(id: "organismsJunlei11", name: ["香菇"]),
            ],
          ),
        ],
      ),
    ],
  ),
];
