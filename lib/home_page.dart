import 'package:flutter/material.dart';
import 'add_transaction_page.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> transactions = [];

  final formatCurrency =
  NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  double get totalSaldo {
    double total = 0;
    for (var t in transactions) {
      if (t['type'] == 'Pemasukan') {
        total += t['amount'];
      } else {
        total -= t['amount'];
      }
    }
    return total;
  }

  void addTransaction(Map<String, dynamic> newTransaction) {
    setState(() {
      transactions.add(newTransaction);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Finote"),
        elevation: 2,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              elevation: 4,
              margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              color: Colors.green,
              child: SizedBox(
                width: double.infinity,
                height: 140,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Total Saldo",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        formatCurrency.format(totalSaldo),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Riwayat Transaksi",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            Expanded(
              child: transactions.isEmpty
                  ? const Center(
                child: Text(
                  "Belum ada catatan",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              )
                  : ListView.builder(
                itemCount: transactions.length,
                itemBuilder: (context, index) {
                  final t = transactions[index];
                  final isIncome = t['type'] == 'Pemasukan';

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor:
                        isIncome ? Colors.green : Colors.red,
                        child: Icon(
                          isIncome
                              ? Icons.arrow_downward
                              : Icons.arrow_upward,
                          color: Colors.white,
                        ),
                      ),
                      title: Text(
                        t['title'],
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      subtitle: Text(
                        t['type'],
                        style: TextStyle(
                          color: isIncome ? Colors.green : Colors.red,
                        ),
                      ),
                      trailing: Text(
                        formatCurrency.format(t['amount']),
                        style: TextStyle(
                          color: isIncome ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddTransactionPage(),
            ),
          );
          if (result != null) {
            addTransaction(result);
          }
        },
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}
