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
    );
  }
}

class DiagnosisPage extends StatefulWidget {
  @override
  _DiagnosisPageState createState() => _DiagnosisPageState();
}

class _DiagnosisPageState extends State<DiagnosisPage> {
  // Daftar gejala
  final List<String> gejalaList = [
    "Bercak putih di tubuh ikan",
    "Ikan sering menggosok tubuh ke benda",
    "Sirip rusak",
    "Ikan terlihat lemas",
    "Nafsu makan menurun",
    "Luka bernanah di tubuh ikan",
    "Sirip dan insang membusuk",
    "Insang tampak pucat",
    "Ikan sering berenang ke permukaan",
    "Insang berwarna merah tua",
    "Kulit ikan merah (udang: usus bengkak)",
    "Bintik putih di kulit dan cangkang udang",
    "Benang putih seperti kapas di luka",
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

  // Penjelasan penyakit
  final Map<String, String> penjelasan = {
    "White Spot Disease (Ichthyophthirius)": "Parasit: bercak putih seperti garam; pengobatan dengan formalin atau garam.",
    "Columnaris": "Bakteri: sirip rusak dan lesi; penanganan dengan antibiotik.",
    "Aeromonas hydrophila": "Bakteri: borok dan luka berdarah; pencegahan dengan kualitas air baik dan vaksinasi.",
    "Vibrio spp.": "Bakteri: kulit memerah, usus bengkak; disebabkan salinitas tidak stabil.",
    "Viral Nervous Necrosis (VNN)": "Virus: berenang melingkar, tubuh gemetar; pencegahan biosekuriti.",
    "White Spot Syndrome Virus (WSSV)": "Virus: bercak putih pada udang; penanganan dengan desinfeksi tambak.",
    "Ichthyophthirius multifiliis (Ich)": "Parasit: bintik putih; pengobatan formalin atau garam.",
    "Trichodiniasis": "Parasit: insang pucat, menggosok tubuh; pengobatan garam atau formalin.",
    "Saprolegnia": "Fungi: benang putih seperti kapas; penanganan malachite green.",
    "Keracunan amonia/nitrit": "Non-infeksius: megap-megap di permukaan; solusinya ganti air dan aerasi.",
    "Stres lingkungan": "Non-infeksius: suhu atau salinitas ekstrem; solusi stabilisasi lingkungan.",
  };

  final double threshold = 50.0;
  List<int> selectedGejala = [];
  List<Map<String, dynamic>> hasilDiagnosis = [];

  void diagnose() {
    hasilDiagnosis.clear();
    for (var entry in penyakitData.entries) {
      String namaPenyakit = entry.key;
      List<int> gejalaPenyakit = entry.value;

      int cocok = gejalaPenyakit.where((gejala) => selectedGejala.contains(gejala)).length;
      double persen = (cocok / gejalaPenyakit.length) * 100;

      if (persen >= threshold) {
        hasilDiagnosis.add({
          "nama": namaPenyakit,
          "persen": persen,
          "penjelasan": penjelasan[namaPenyakit],
        });
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Diagnosis Penyakit Ikan"),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Pilih Gejala:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: gejalaList.length,
                itemBuilder: (context, index) {
                  return CheckboxListTile(
                    title: Text(gejalaList[index]),
                    value: selectedGejala.contains(index),
                    onChanged: (bool? value) {
                      setState(() {
                        if (value == true) {
                          selectedGejala.add(index);
                        } else {
                          selectedGejala.remove(index);
                        }
                      });
                    },
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: diagnose,
              child: Text("Diagnosa"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              ),
            ),
            SizedBox(height: 20),
            if (hasilDiagnosis.isNotEmpty)
              Text(
                "Hasil Diagnosis:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ...hasilDiagnosis.map((hasil) {
              return Card(
                margin: EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  title: Text("${hasil['nama']} (${hasil['persen'].toStringAsFixed(1)}%)"),
                  subtitle: Text(hasil['penjelasan']),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}