class ClinicExamine {
  final String? id;
  final String title;
  final String description;
  final List<ClinicExamine> children;

  ClinicExamine({
    this.id,
    required this.title,
    required this.description,
    required this.children,
  });

  // Factory method to create the full examination structure
  factory ClinicExamine.createFullStructure() {
    return ClinicExamine(
      id: 'root',
      title: '化验单项目',
      description: '完整的化验项目列表',
      children: [
        ClinicExamine(
          id: 'blood_type',
          title: '血型鉴定',
          description: '血型相关检测',
          children: [
            ClinicExamine(
              id: 'abo',
              title: 'ABO血型',
              description: 'ABO血型系统检测',
              children: [],
            ),
            ClinicExamine(
              id: 'rh',
              title: 'Rh血型系统',
              description: 'Rh血型系统检测',
              children: [],
            ),
          ],
        ),
        ClinicExamine(
          id: 'blood_routine',
          title: '血常规',
          description: '血液常规检查',
          children: [
            ClinicExamine(
              id: 'wbc',
              title: '白细胞及分类',
              description: '白细胞相关检测',
              children: [
                ClinicExamine(
                  id: 'wbc_count',
                  title: '白细胞计数',
                  description: '白细胞数量检测',
                  children: [],
                ),
                ClinicExamine(
                  id: 'neutrophil',
                  title: '中性粒细胞',
                  description: '中性粒细胞检测(包括核象变化)',
                  children: [],
                ),
                ClinicExamine(
                  id: 'lymphocyte',
                  title: '淋巴细胞',
                  description: '淋巴细胞检测',
                  children: [],
                ),
                ClinicExamine(
                  id: 'monocyte',
                  title: '单核细胞',
                  description: '单核细胞检测',
                  children: [],
                ),
                ClinicExamine(
                  id: 'eosinophil',
                  title: '嗜酸性粒细胞',
                  description: '嗜酸性粒细胞检测',
                  children: [],
                ),
                ClinicExamine(
                  id: 'basophil',
                  title: '嗜碱性粒细胞',
                  description: '嗜碱性粒细胞检测',
                  children: [],
                ),
              ],
            ),
            ClinicExamine(
              id: 'rbc',
              title: '红细胞',
              description: '红细胞检测',
              children: [],
            ),
            ClinicExamine(
              id: 'hemoglobin',
              title: '血红蛋白',
              description: '血红蛋白检测',
              children: [],
            ),
            ClinicExamine(
              id: 'platelet',
              title: '血小板',
              description: '血小板检测',
              children: [],
            ),
          ],
        ),
        ClinicExamine(
          id: 'urine_routine',
          title: '尿常规',
          description: '尿液常规检查',
          children: [
            ClinicExamine(
              id: 'urine_wbc',
              title: '镜检白细胞',
              description: '尿液中白细胞检测',
              children: [],
            ),
            ClinicExamine(
              id: 'urine_rbc',
              title: '镜检红细胞',
              description: '尿液中红细胞检测',
              children: [],
            ),
            ClinicExamine(
              id: 'urine_protein',
              title: '尿蛋白质',
              description: '尿蛋白检测',
              children: [],
            ),
            ClinicExamine(
              id: 'urine_glucose',
              title: '尿葡萄糖',
              description: '尿糖检测',
              children: [],
            ),
            ClinicExamine(
              id: 'urine_ketone',
              title: '尿酮体',
              description: '尿酮体检测',
              children: [],
            ),
            ClinicExamine(
              id: 'hcg',
              title: '人绒毛促性腺激素',
              description: 'HCG检测(妊娠试验)',
              children: [],
            ),
          ],
        ),
        ClinicExamine(
          id: 'liver_function',
          title: '肝功能',
          description: '肝脏功能检测',
          children: [
            ClinicExamine(
              id: 'transaminase',
              title: '氨基转移酶',
              description: '肝酶检测',
              children: [
                ClinicExamine(
                  id: 'alt',
                  title: '丙氨酸氨基转移酶',
                  description: 'ALT检测',
                  children: [],
                ),
                ClinicExamine(
                  id: 'ast',
                  title: '天门冬氨酸氨基转移酶',
                  description: 'AST检测',
                  children: [],
                ),
              ],
            ),
            ClinicExamine(
              id: 'bilirubin',
              title: '胆红素',
              description: '胆红素检测',
              children: [
                ClinicExamine(
                  id: 'total_bilirubin',
                  title: '总胆红素',
                  description: '总胆红素检测',
                  children: [],
                ),
                ClinicExamine(
                  id: 'conjugated_bilirubin',
                  title: '结合胆红素',
                  description: '直接胆红素检测',
                  children: [],
                ),
                ClinicExamine(
                  id: 'unconjugated_bilirubin',
                  title: '非结合胆红素',
                  description: '间接胆红素检测',
                  children: [],
                ),
              ],
            ),
            ClinicExamine(
              id: 'protein',
              title: '蛋白质',
              description: '蛋白质检测',
              children: [
                ClinicExamine(
                  id: 'total_protein',
                  title: '总蛋白',
                  description: '血清总蛋白检测',
                  children: [],
                ),
                ClinicExamine(
                  id: 'albumin',
                  title: '白蛋白',
                  description: '血清白蛋白检测',
                  children: [],
                ),
                ClinicExamine(
                  id: 'globulin',
                  title: '球蛋白',
                  description: '血清球蛋白检测',
                  children: [],
                ),
              ],
            ),
            ClinicExamine(
              id: 'tba',
              title: '总胆汁酸',
              description: '总胆汁酸检测',
              children: [],
            ),
            ClinicExamine(
              id: 'ggt',
              title: 'γ-谷酰胺转肽酶',
              description: 'GGT检测',
              children: [],
            ),
            ClinicExamine(
              id: 'alp',
              title: '碱性磷酸酶',
              description: 'ALP检测',
              children: [],
            ),
          ],
        ),
        ClinicExamine(
          id: 'kidney_function',
          title: '肾功能',
          description: '肾脏功能检测',
          children: [
            ClinicExamine(
              id: 'creatinine',
              title: '血清肌酐',
              description: '肌酐检测(可估测肾小球滤过率)',
              children: [],
            ),
            ClinicExamine(
              id: 'bun',
              title: '血尿素氮',
              description: 'BUN检测',
              children: [],
            ),
            ClinicExamine(
              id: 'uric_acid',
              title: '血尿酸',
              description: '尿酸检测',
              children: [],
            ),
            ClinicExamine(
              id: 'cystatin_c',
              title: '胱抑素C',
              description: '胱抑素C检测',
              children: [],
            ),
          ],
        ),
        ClinicExamine(
          id: 'heart_function',
          title: '心功能',
          description: '心脏功能检测',
          children: [
            ClinicExamine(
              id: 'ck',
              title: '肌酸激酶',
              description: 'CK检测',
              children: [],
            ),
            ClinicExamine(
              id: 'ck_mb',
              title: '肌酸激酶同工酶',
              description: 'CK-MB检测',
              children: [],
            ),
            ClinicExamine(
              id: 'troponin',
              title: '肌钙蛋白',
              description: '心肌肌钙蛋白检测',
              children: [],
            ),
            ClinicExamine(
              id: 'myoglobin',
              title: '肌红蛋白',
              description: '肌红蛋白检测',
              children: [],
            ),
          ],
        ),
        ClinicExamine(
          id: 'blood_sugar',
          title: '血糖',
          description: '血糖相关检测',
          children: [
            ClinicExamine(
              id: 'fasting_glucose',
              title: '空腹血糖',
              description: '空腹血糖检测',
              children: [],
            ),
            ClinicExamine(
              id: 'postprandial_glucose',
              title: '餐后2小时血糖',
              description: '餐后血糖检测',
              children: [],
            ),
            ClinicExamine(
              id: 'hba1c',
              title: '糖化血红蛋白',
              description: 'HbA1c检测',
              children: [],
            ),
            ClinicExamine(
              id: 'glycated_albumin',
              title: '糖化血清白蛋白',
              description: '糖化白蛋白检测',
              children: [],
            ),
          ],
        ),
        ClinicExamine(
          id: 'blood_lipid',
          title: '血脂',
          description: '血脂相关检测',
          children: [
            ClinicExamine(
              id: 'total_cholesterol',
              title: '总胆固醇',
              description: 'TC检测',
              children: [],
            ),
            ClinicExamine(
              id: 'triglyceride',
              title: '三酰甘油',
              description: 'TG检测',
              children: [],
            ),
            ClinicExamine(
              id: 'lipoprotein',
              title: '脂蛋白',
              description: '脂蛋白检测',
              children: [
                ClinicExamine(
                  id: 'hdl_c',
                  title: '高密度脂蛋白-胆固醇',
                  description: 'HDL-C检测',
                  children: [],
                ),
                ClinicExamine(
                  id: 'ldl_c',
                  title: '低密度脂蛋白-胆固醇',
                  description: 'LDL-C检测',
                  children: [],
                ),
              ],
            ),
            ClinicExamine(
              id: 'apolipoprotein',
              title: '载脂蛋白',
              description: '载脂蛋白检测',
              children: [
                ClinicExamine(
                  id: 'apo_a1',
                  title: '载脂蛋白A1',
                  description: 'ApoA1检测',
                  children: [],
                ),
                ClinicExamine(
                  id: 'apo_b',
                  title: '载脂蛋白B',
                  description: 'ApoB检测',
                  children: [],
                ),
              ],
            ),
          ],
        ),
        ClinicExamine(
          id: 'tumor_markers',
          title: '肿瘤标志物',
          description: '肿瘤标志物检测',
          children: [
            ClinicExamine(
              id: 'afp',
              title: '甲胎蛋白',
              description: 'AFP检测',
              children: [],
            ),
            ClinicExamine(
              id: 'cea',
              title: '癌胚抗原',
              description: 'CEA检测',
              children: [],
            ),
          ],
        ),
      ],
    );
  }
}
