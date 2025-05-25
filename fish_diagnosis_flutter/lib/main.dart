import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DiagnosisPage(),
      theme: ThemeData(
        primarySwatch: Colors.teal,
        fontFamily: 'Roboto',
      ),
    );
  }
}

class DiagnosisPage extends StatefulWidget {
  @override
  _DiagnosisPageState createState() => _DiagnosisPageState();
}

class _DiagnosisPageState extends State<DiagnosisPage> with SingleTickerProviderStateMixin {
  // Daftar gejala dengan bobot
  final List<Map<String, dynamic>> gejalaListWithWeight = [
    {"gejala": "Bercak putih di tubuh ikan", "weight": 2},
    {"gejala": "Ikan sering menggosok tubuh ke benda", "weight": 3},
    {"gejala": "Sirip rusak", "weight": 2},
    {"gejala": "Ikan terlihat lemas", "weight": 1},
    {"gejala": "Nafsu makan menurun", "weight": 1},
    {"gejala": "Luka bernanah di tubuh ikan", "weight": 3},
    {"gejala": "Sirip dan insang membusuk", "weight": 2},
    {"gejala": "Insang tampak pucat", "weight": 1},
    {"gejala": "Ikan sering berenang ke permukaan", "weight": 1},
    {"gejala": "Insang berwarna merah tua", "weight": 2},
    {"gejala": "Kulit ikan merah (udang: usus bengkak)", "weight": 3},
    {"gejala": "Bintik putih di kulit dan cangkang udang", "weight": 3},
    {"gejala": "Benang putih seperti kapas di luka", "weight": 4},
  ];

  // Definisi penyakit dan gejalanya
  final Map<String, List<int>> penyakitData = {
    "White Spot Disease (Ichthyophthirius)": [0, 1, 3, 8],
    "Columnaris": [2, 3, 5],
    "Aeromonas hydrophila": [5, 6, 2],
    "Vibrio spp.": [10],
    "Viral Nervous Necrosis (VNN)": [3, 6],
    "White Spot Syndrome Virus (WSSV)": [11],
    "Ichthyophthirius multifiliis (Ich)": [0, 1],
    "Trichodiniasis": [7, 1],
    "Saprolegnia": [12],
    "Keracunan amonia/nitrit": [3, 4],
    "Stres lingkungan": [3, 4],
  };

  // Penjelasan penyakit dengan bahasa yang lebih sederhana
  final Map<String, String> penjelasan = {
    "White Spot Disease (Ichthyophthirius)": "Penyakit parasit yang menyebabkan bercak putih seperti garam pada tubuh ikan. Pengobatannya dengan formalin atau garam.",
    "Columnaris": "Bakteri yang merusak sirip dan menyebabkan luka. Pengobatannya dengan antibiotik.",
    "Aeromonas hydrophila": "Bakteri yang menyebabkan borok dan luka berdarah. Pencegahannya dengan menjaga kualitas air dan vaksinasi.",
    "Vibrio spp.": "Bakteri yang menyebabkan kulit ikan memerah dan usus bengkak. Disebabkan oleh perubahan salinitas yang tidak stabil.",
    "Viral Nervous Necrosis (VNN)": "Virus yang menyebabkan ikan berenang melingkar dan tubuh gemetar. Pencegahannya dengan menjaga biosekuriti.",
    "White Spot Syndrome Virus (WSSV)": "Virus yang menyebabkan bercak putih pada tubuh udang. Penanganannya dengan desinfeksi tambak.",
    "Ichthyophthirius multifiliis (Ich)": "Penyakit parasit yang menyebabkan bintik putih. Pengobatannya dengan formalin atau garam.",
    "Trichodiniasis": "Penyakit parasit yang menyebabkan insang pucat dan ikan sering menggosok tubuh. Dapat diobati dengan garam atau formalin.",
    "Saprolegnia": "Fungi yang menyebabkan benang putih seperti kapas pada luka. Pengobatannya dengan malachite green.",
    "Keracunan amonia/nitrit": "Penyakit non-infeksius yang menyebabkan ikan megap-megap di permukaan. Solusinya dengan mengganti air dan meningkatkan aerasi.",
    "Stres lingkungan": "Penyakit non-infeksius akibat suhu atau salinitas yang ekstrem. Solusinya adalah dengan menstabilkan lingkungan tambak.",
  };

  final double threshold = 80.0; // Threshold untuk 70% kecocokan
  List<int> selectedGejala = [];
  List<Map<String, dynamic>> hasilDiagnosis = [];

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _showWelcomeDialog();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
  }

  void _showWelcomeDialog() async {
    await Future.delayed(Duration(milliseconds: 400));
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.set_meal, color: Colors.teal, size: 32),
            SizedBox(width: 8),
            Text("Selamat Datang!"),
          ],
        ),
        content: Text(
          "Aplikasi ini membantu mendiagnosis penyakit ikan dan udang berdasarkan gejala yang Anda pilih. Silakan lanjutkan untuk mulai diagnosis.",
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Mulai"),
          ),
        ],
      ),
    );
  }

  // Fungsi untuk mendiagnosis penyakit berdasarkan gejala yang dipilih
  void diagnose() {
    if (selectedGejala.isEmpty) {
      // Tampilkan pesan jika tidak ada gejala yang dipilih
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Perhatian"),
          content: Text("Silakan pilih beberapa gejala untuk melakukan diagnosis."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("OK"),
            ),
          ],
        ),
      );
      return; // Hentikan fungsi jika tidak ada gejala yang dipilih
    }

    hasilDiagnosis.clear();
    for (var entry in penyakitData.entries) {
      String namaPenyakit = entry.key;
      List<int> gejalaPenyakit = entry.value;

      double cocok = 0;  
      double totalWeight = 0;

      // Menghitung kecocokan gejala dengan bobot
      for (int gejalaIndex in gejalaPenyakit) {
        if (selectedGejala.contains(gejalaIndex)) {
          cocok += gejalaListWithWeight[gejalaIndex]['weight'];
        }
        totalWeight += gejalaListWithWeight[gejalaIndex]['weight'];
      }

      // Menghitung persentase kecocokan
      double persen = (cocok / totalWeight) * 100;

      if (persen >= threshold) {
        hasilDiagnosis.add({
          "nama": namaPenyakit,
          "persen": persen,
          "penjelasan": penjelasan[namaPenyakit],
        });
      }
    }
    _controller.forward(from: 0);
    setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _resetDiagnosis() {
    setState(() {
      selectedGejala.clear();
      hasilDiagnosis.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.shade50,
      appBar: AppBar(
        title: Text("Diagnosis Penyakit Ikan & Udang"),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            tooltip: "Reset",
            onPressed: _resetDiagnosis,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Pilih Gejala:",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.teal.shade900),
            ),
            SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: gejalaListWithWeight.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: Colors.white,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: CheckboxListTile(
                      title: Text(
                        gejalaListWithWeight[index]['gejala'],
                        style: TextStyle(fontSize: 16),
                      ),
                      value: selectedGejala.contains(index),
                      activeColor: Colors.teal,
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true && selectedGejala.length < 5) {  // Batasi hanya 5 gejala yang bisa dipilih
                            selectedGejala.add(index);
                          } else if (value == false) {
                            selectedGejala.remove(index);
                          }
                        });
                      },
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: diagnose,
                    icon: Icon(Icons.search),
                    label: Text("Diagnosa Sekarang"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      padding: EdgeInsets.symmetric(vertical: 14),
                      textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            if (hasilDiagnosis.isNotEmpty)
              Text(
                "Hasil Diagnosis:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal.shade900),
              ),
            ...hasilDiagnosis.map((hasil) {
              return SizeTransition(
                sizeFactor: _animation,
                axis: Axis.vertical,
                child: Card(
                  color: Colors.white,
                  elevation: 4,
                  margin: EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  child: ListTile(
                    leading: Icon(Icons.medical_services, color: Colors.teal),
                    title: Text("${hasil['nama']} (${hasil['persen'].toStringAsFixed(1)}%)"),
                    subtitle: Text(hasil['penjelasan']),
                  ),
                ),
              );
            }).toList(),
            if (hasilDiagnosis.isEmpty && selectedGejala.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  "Tidak ditemukan penyakit dengan gejala yang dipilih.",
                  style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
