import 'package:flutter/material.dart';
import 'package:uas/models/stock.dart';
import 'package:uas/pages/detail/DetailStock.dart';
import 'package:uas/pages/tambah/TambahStock.dart';
import 'package:uas/services/api_services.dart';

class StockPage extends StatefulWidget {
  const StockPage({super.key});

  @override
  State<StockPage> createState() => _StockPageState();
}

class _StockPageState extends State<StockPage> {
  final ApiService apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const TambahStock()),
            ).then((_) async {
              await apiService.getStocks();
              setState(() {});
            });
          },
          shape: const CircleBorder(),
          backgroundColor: const Color.fromARGB(255, 255, 0, 0),
          foregroundColor: const Color.fromARGB(255, 255, 255, 255),
          child: const Icon(Icons.add),
        ),
        body: Column(
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(10, 50, 10, 10),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              alignment: Alignment.centerLeft,
              height: 100,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 255, 0, 0),
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: const Row(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Toko Hayam',
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                      Text(
                        'Stock Page',
                        style: TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255),
                            fontSize: 24,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  await apiService.getStocks();
                  setState(() {});
                },
                child: FutureBuilder<List<Stock>>(
                  future: apiService.getStocks(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text('No Data found'));
                    } else {
                      List<Stock> stock = snapshot.data!;

                      return ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: stock.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      DetailStockPage(id: stock[index].id),
                                ),
                              );
                              setState(() {
                                // Optionally update state here if needed after navigation
                              });
                            },
                            child: Card(
                              elevation: 2.0,
                              margin: const EdgeInsets.symmetric(
                                  vertical: 4.0, horizontal: 10.0),
                              color: Colors.red[100],
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Colors.red,
                                      foregroundColor: Colors.white,
                                      child: Text(stock[index].qty.toString()),
                                    ),
                                    const SizedBox(width: 10.0),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(stock[index].name,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        Text(
                                            'Berat: ${stock[index].weight} Kg / ${stock[index].attr}'),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ));
  }
}
