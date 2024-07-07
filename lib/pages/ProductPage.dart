import 'package:flutter/material.dart';
import 'package:uas/models/product.dart';
import 'package:uas/pages/detail/DetailProduct.dart';
import 'package:uas/pages/tambah/TambahProduct.dart';
import 'package:uas/services/api_services.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final ApiService apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          shape: const CircleBorder(),
          backgroundColor: const Color.fromARGB(255, 255, 0, 0),
          foregroundColor: const Color.fromARGB(255, 255, 255, 255),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const TambahProduct()),
            ).then((_) async {
              await apiService.getProducts();
              setState(() {});
            });
          },
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
                        'Product Page',
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
                  await apiService.getProducts();
                  setState(() {});
                },
                child: FutureBuilder<List<Product>>(
                  future: apiService.getProducts(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text('No products found'));
                    } else {
                      List<Product> products = snapshot.data!;

                      return ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          String formattedPrice =
                              _formatPrice(products[index].price);
                          return GestureDetector(
                            onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      DetailProductPage(id: products[index].id),
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
                                      child:
                                          Text(products[index].qty.toString()),
                                    ),
                                    const SizedBox(width: 10.0),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(products[index].name,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        Text(
                                            'Harga: Rp.${formattedPrice} / ${products[index].attr}'),
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

String _formatPrice(num price) {
  // Convert price to string and split decimal part
  List<String> parts = price.toStringAsFixed(2).split('.');
  String formatted = parts[0].replaceAllMapped(
    RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
    (Match m) => '${m[1]}.',
  );
  return formatted;
}
