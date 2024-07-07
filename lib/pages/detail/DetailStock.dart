import 'package:flutter/material.dart';
import 'package:uas/services/api_services.dart'; // Sesuaikan dengan nama package dan service API yang digunakan

class DetailStockPage extends StatefulWidget {
  final String id;

  const DetailStockPage({Key? key, required this.id}) : super(key: key);

  @override
  _DetailStockPageState createState() => _DetailStockPageState();
}

class _DetailStockPageState extends State<DetailStockPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
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
    _fetchStockDetail();
  }

  void _fetchStockDetail() async {
    setState(() {
      isLoading = true;
    });

    try {
      final stock = await ApiService().getStock(widget.id);

      nameController.text = stock.name;
      qtyController.text = stock.qty.toString();
      attrController.text = stock.attr;
      weightController.text = stock.weight.toString();
    } catch (e) {
      print('Failed to fetch stock details: $e');
      _showDialog('Error', 'Failed to fetch stock details');
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
        title: const Text('Edit Stock', style: TextStyle(color: Colors.white)),
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
                            return 'Please enter stock name';
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
                            return 'Please enter stock quantity';
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
                            return 'Please enter stock attribute';
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
                            return 'Please enter stock weight';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                final String name = nameController.text;
                                final int qty =
                                    int.tryParse(qtyController.text) ?? 0;
                                final String attr = attrController.text;
                                final int weight =
                                    int.tryParse(weightController.text) ?? 0;

                                try {
                                  final response = await ApiService().editStock(
                                      name, qty, attr, weight, widget.id);
                                  if (response.statusCode != 200) {
                                    throw Exception('Failed to update Stock');
                                  }
                                  Navigator.of(context).pop();
                                  _showDialog(
                                      'Success', 'Stock updated successfully!');
                                } catch (e) {
                                  print(e);
                                  _showDialog(
                                      'Failed', 'Failed to update Stock');
                                }
                              }
                            },
                            child: const Text('Edit'),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () async {
                              try {
                                final response =
                                    await ApiService().delStock(widget.id);
                                if (response.statusCode == 204) {
                                  Navigator.of(context).pop();
                                  _showDialog(
                                      'Success', 'Stock deleted successfully!');
                                } else {
                                  throw Exception('Failed to delete Stock');
                                }
                              } catch (e) {
                                print(e);
                                _showDialog('Failed', 'Failed to delete Stock');
                              }
                            },
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.red),
                            ),
                            child: const Text('Delete',
                                style: TextStyle(color: Colors.white)),
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
