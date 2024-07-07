import 'package:flutter/material.dart';
import 'package:uas/services/api_services.dart';

class DetailProductPage extends StatefulWidget {
  final String id;

  const DetailProductPage({Key? key, required this.id}) : super(key: key);

  @override
  _DetailProductPageState createState() => _DetailProductPageState();
}

class _DetailProductPageState extends State<DetailProductPage> {
  final ApiService apiService = ApiService();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController qtyController = TextEditingController();
  final TextEditingController attrController = TextEditingController();
  final TextEditingController weightController = TextEditingController();

  bool isLoading = false;

  void _showDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchProductDetail();
  }

  void _fetchProductDetail() async {
    setState(() {
      isLoading = true;
    });

    try {
      final product = await apiService.getProduct(widget.id);

      nameController.text = product.name;
      priceController.text = product.price.toString();
      qtyController.text = product.qty.toString();
      attrController.text = product.attr;
      weightController.text = product.weight.toString();
    } catch (e) {
      print('Failed to fetch product details: $e');
      _showDialog('Error', 'Failed to fetch product details');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title:
            const Text('Edit Product', style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: isLoading
              ? Center(child: CircularProgressIndicator())
              : Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextFormField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          labelText: 'Name',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter product name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: priceController,
                        decoration: const InputDecoration(
                          labelText: 'Price',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter product price';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: qtyController,
                        decoration: const InputDecoration(
                          labelText: 'Quantity',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter product quantity';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: attrController,
                        decoration: const InputDecoration(
                          labelText: 'Attribute',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter product attribute';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: weightController,
                        decoration: const InputDecoration(
                          labelText: 'Weight',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter product weight';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  final String name = nameController.text;
                                  final int price =
                                      int.tryParse(priceController.text) ?? 0;
                                  final int qty =
                                      int.tryParse(qtyController.text) ?? 0;
                                  final String attr = attrController.text;
                                  final int weight =
                                      int.tryParse(weightController.text) ?? 0;

                                  try {
                                    final response =
                                        await ApiService().editProduct(
                                      name,
                                      price,
                                      qty,
                                      attr,
                                      weight,
                                      widget.id,
                                    );
                                    if (response.statusCode != 200) {
                                      throw Exception(
                                          'Failed to update product');
                                    }
                                    Navigator.of(context).pop();
                                    _showDialog('Success',
                                        'Product updated successfully!');
                                  } catch (e) {
                                    print(e);
                                    _showDialog(
                                        'Error', 'Failed to update product');
                                  }
                                }
                              },
                              child: const Text('Edit Product'),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () async {
                                // Implement delete functionality here
                                try {
                                  final response =
                                      await ApiService().delProduct(widget.id);
                                  if (response.statusCode == 204) {
                                    Navigator.of(context).pop();
                                    _showDialog('Success',
                                        'Product deleted successfully!');
                                  } else {
                                    throw Exception('Failed to delete product');
                                  }
                                } catch (e) {
                                  print(e);
                                  _showDialog(
                                      'Error', 'Failed to delete product');
                                }
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    WidgetStateProperty.all(Colors.red),
                              ),
                              child: const Text('Delete Product',
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
