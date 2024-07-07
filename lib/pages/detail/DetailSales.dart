import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uas/services/api_services.dart';

class DetailSalesPage extends StatefulWidget {
  final String id;

  const DetailSalesPage({Key? key, required this.id}) : super(key: key);

  @override
  _DetailSalesPageState createState() => _DetailSalesPageState();
}

class _DetailSalesPageState extends State<DetailSalesPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController buyerController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController statusController = TextEditingController();

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
    _fetchSalesDetail();
  }

  void _fetchSalesDetail() async {
    setState(() {
      isLoading = true;
    });

    try {
      final sales = await ApiService().getSales(widget.id);

      buyerController.text = sales.buyer;
      phoneController.text = sales.phone;
      dateController.text = sales.date;
      statusController.text = sales.status;
    } catch (e) {
      print('Failed to fetch sales details: $e');
      _showDialog('Error', 'Failed to fetch sales details');
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
        title: const Text('Edit Sales', style: TextStyle(color: Colors.white)),
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
                        controller: buyerController,
                        decoration: const InputDecoration(
                          labelText: 'Buyer',
                          border: OutlineInputBorder(),
                        ),
                        // Prevent editing in view mode
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: phoneController,
                        decoration: const InputDecoration(
                          labelText: 'Phone',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: dateController,
                        decoration: const InputDecoration(
                          labelText: 'Date',
                          border: OutlineInputBorder(),
                        ),
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2101),
                          );
                          if (pickedDate != null) {
                            setState(() {
                              dateController.text =
                                  DateFormat('dd-MM-yyyy').format(pickedDate);
                            });
                          }
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter date';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: statusController,
                        decoration: const InputDecoration(
                          labelText: 'Status',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter status';
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
                              // Implement update functionality here
                              if (_formKey.currentState!.validate()) {
                                final String buyer = buyerController.text;
                                final String phone = phoneController.text;
                                final String date = dateController.text;
                                final String status = statusController.text;

                                try {
                                  final response = await ApiService().editSales(
                                      buyer, phone, date, status, widget.id);
                                  if (response.statusCode != 200) {
                                    throw Exception('Failed to update Sales');
                                  }
                                  Navigator.of(context).pop();
                                  _showDialog(
                                      'Success', 'Sales updated successfully!');
                                } catch (e) {
                                  print(e);
                                  _showDialog(
                                      'Failed', 'Failed to update Sales');
                                }
                              }
                            },
                            child: const Text('Edit'),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () async {
                              // Implement delete functionality here
                              try {
                                final response =
                                    await ApiService().delSales(widget.id);
                                if (response.statusCode == 204) {
                                  Navigator.of(context).pop();
                                  _showDialog(
                                      'Success', 'Sales deleted successfully!');
                                } else {
                                  throw Exception('Failed to delete Sales');
                                }
                              } catch (e) {
                                print(e);
                                _showDialog('Failed', 'Failed to delete Sales');
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
