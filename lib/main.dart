import 'package:flutter/material.dart';

// Model sederhana untuk antrean online warung ndeso
class NdesoQueue {
  final int number;
  final String name;
  final String phone; // Ganti email jadi nomor HP, lebih sesuai desa
  final String service; // 'Makan di Warung', 'Takeaway Nasi', 'Pesan Ayam Goreng'
  final int partySize; // Jumlah orang
  final String status; // 'Menunggu', 'Dipanggil', 'Selesai'
  final DateTime timestamp;

  NdesoQueue({
    required this.number,
    required this.name,
    required this.phone,
    required this.service,
    required this.partySize,
    required this.status,
    required this.timestamp,
  });
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Antrean Online Warung Ndeso',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<NdesoQueue> queue = []; // Daftar antrean online
  int nextNumber = 1;
  bool isLoading = false; // Simulasi loading online

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController partySizeController = TextEditingController();
  String selectedService = 'Makan di Warung'; // Default layanan

  void takeOnlineQueue() async {
    if (nameController.text.isEmpty || phoneController.text.isEmpty || partySizeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Harap isi semua data! 📝')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    // Simulasi kirim data online (delay 2 detik)
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      queue.add(NdesoQueue(
        number: nextNumber,
        name: nameController.text,
        phone: phoneController.text,
        service: selectedService,
        partySize: int.parse(partySizeController.text),
        status: 'Menunggu',
        timestamp: DateTime.now(),
      ));
      nextNumber++;
      isLoading = false;
    });

    // Navigasi ke halaman antrean
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => OnlineQueuePage(queueItem: queue.last, onStatusUpdate: (updatedItem) {
          setState(() {
            int index = queue.indexWhere((q) => q.number == updatedItem.number);
            if (index != -1) queue[index] = updatedItem;
          });
        }),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    );

    // Reset form
    nameController.clear();
    phoneController.clear();
    partySizeController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( // Komponen App Bar
        title: Text('🌾 Antrean Online Warung Ndeso'),
        backgroundColor: Colors.greenAccent,
        actions: [
          IconButton(
            icon: Icon(Icons.grass),
            onPressed: () {
              // Navigator ke halaman status online
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => OnlineStatusPage(queue: queue)),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green.shade100, Colors.brown.shade100],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column( // Komponen Column
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Icon(Icons.restaurant_menu, size: 80, color: Colors.green), // Ikon warung
                      SizedBox(height: 10),
                      Text( // Komponen Text
                        'Ambil antrean online di warung ndeso!',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20),
                      TextField(
                        controller: nameController,
                        decoration: InputDecoration(
                          labelText: 'Nama Lengkap',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.person),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: phoneController,
                        decoration: InputDecoration(
                          labelText: 'Nomor HP',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.phone),
                        ),
                        keyboardType: TextInputType.phone,
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: partySizeController,
                        decoration: InputDecoration(
                          labelText: 'Jumlah Orang',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.group),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(height: 20),
                      DropdownButtonFormField<String>(
                        value: selectedService,
                        items: ['Makan di Warung', 'Takeaway Nasi', 'Pesan Ayam Goreng'].map((service) {
                          return DropdownMenuItem(
                            value: service,
                            child: Text(service),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedService = value!;
                          });
                        },
                        decoration: InputDecoration(
                          labelText: 'Pilih Layanan',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.fastfood),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30),
              Row( // Komponen Row untuk tombol
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  isLoading
                      ? CircularProgressIndicator(color: Colors.green)
                      : ElevatedButton(
                          onPressed: takeOnlineQueue,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text('Ambil Antrean Online 🍛'),
                        ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OnlineQueuePage extends StatefulWidget {
  final NdesoQueue queueItem;
  final Function(NdesoQueue) onStatusUpdate;

  OnlineQueuePage({required this.queueItem, required this.onStatusUpdate});

  @override
  _OnlineQueuePageState createState() => _OnlineQueuePageState();
}

class _OnlineQueuePageState extends State<OnlineQueuePage> {
  late NdesoQueue currentItem;

  @override
  void initState() {
    super.initState();
    currentItem = widget.queueItem;
    // Simulasi update status real-time (setiap 10 detik)
    Future.delayed(Duration(seconds: 10), () {
      if (mounted && currentItem.status == 'Menunggu') {
        setState(() {
          currentItem = NdesoQueue(
            number: currentItem.number,
            name: currentItem.name,
            phone: currentItem.phone,
            service: currentItem.service,
            partySize: currentItem.partySize,
            status: 'Dipanggil',
            timestamp: currentItem.timestamp,
          );
        });
        widget.onStatusUpdate(currentItem);
      }
    });
  }

  String estimateWaitTime(String service, int number, int partySize) {
    // Simulasi estimasi waktu online: Berdasarkan layanan dan ukuran kelompok, lebih cepat untuk warung
    int baseTime = service == 'Takeaway Nasi' ? 5 : service == 'Pesan Ayam Goreng' ? 10 : 15;
    int totalTime = baseTime + (number * 3) + (partySize * 1); // Lebih cepat dari restoran
    return '$totalTime menit';
  }

  void shareQueue() {
    // Simulasi share (dalam dunia nyata, gunakan share package)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Nomor antrean ${currentItem.number} dibagikan! 📤')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( // Komponen App Bar
        title: Text('Antrean Online Warung'),
        backgroundColor: Colors.greenAccent,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.brown.shade100, Colors.green.shade100],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
        child: Column( // Komponen Column
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Icon(Icons.grass, size: 80, color: Colors.green), // Ikon desa
                    SizedBox(height: 10),
                    Text( // Komponen Text
                      'Antrean Online Warung Ndeso',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Nomor: ${currentItem.number}',
                      style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.brown),
                    ),
                    Text('Nama: ${currentItem.name}', style: TextStyle(fontSize: 16)),
                    Text('Layanan: ${currentItem.service}', style: TextStyle(fontSize: 16)),
                    Text('Jumlah Orang: ${currentItem.partySize}', style: TextStyle(fontSize: 16)),
                    Text('Status: ${currentItem.status}', style: TextStyle(fontSize: 16, color: currentItem.status == 'Menunggu' ? Colors.orange : Colors.green)),
                    Text('Estimasi Tunggu: ${estimateWaitTime(currentItem.service, currentItem.number, currentItem.partySize)}', style: TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Row( // Komponen Row untuk tombol
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: shareQueue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text('Bagikan Antrean 📤'),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Kembali
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text('Kembali'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class OnlineStatusPage extends StatefulWidget {
  final List<NdesoQueue> queue;

  OnlineStatusPage({required this.queue});

  @override
  _OnlineStatusPageState createState() => _OnlineStatusPageState();
}

class _OnlineStatusPageState extends State<OnlineStatusPage> {
  void updateStatus(int index, String newStatus) {
    setState(() {
      widget.queue[index] = NdesoQueue(
        number: widget.queue[index].number,
        name: widget.queue[index].name,
        phone: widget.queue[index].phone,
        service: widget.queue[index].service,
        partySize: widget.queue[index].partySize,
        status: newStatus,
        timestamp: widget.queue[index].timestamp,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( // Komponen App Bar
        title: Text('Status Online Warung Ndeso'),
        backgroundColor: Colors.greenAccent,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.yellow.shade100, Colors.green.shade100],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column( // Komponen Column
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: Text( // Komponen Text
                'Kelola Antrean Online Warung',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: widget.queue.isEmpty
                  ? Center(child: Text('Tidak ada antrean online 🌾', style: TextStyle(fontSize: 18)))
                  : ListView.builder(
                      itemCount: widget.queue.length,
                      itemBuilder: (context, index) {
                        final item = widget.queue[index];
                        return Card(
                          elevation: 5,
                          margin: EdgeInsets.all(10),
                          child: Row( // Komponen Row
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Nomor: ${item.number}', style: TextStyle(fontWeight: FontWeight.bold)),
                                      Text('Nama: ${item.name}'),
                                      Text('Layanan: ${item.service}'),
                                      Text('Jumlah: ${item.partySize} orang'),
                                      Text('Status: ${item.status}', style: TextStyle(color: item.status == 'Menunggu' ? Colors.orange : Colors.green)),
                                    ],
                                  ),
                                ),
                              ),
                              if (item.status == 'Menunggu')
                                ElevatedButton(
                                  onPressed: () => updateStatus(index, 'Dipanggil'),
                                  child: Text('Panggil'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                  ),
                                ),
                              if (item.status == 'Dipanggil')
                                ElevatedButton(
                                  onPressed: () => updateStatus(index, 'Selesai'),
                                  child: Text('Selesai'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}