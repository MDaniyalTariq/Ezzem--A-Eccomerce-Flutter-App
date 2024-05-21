import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class BookOnlinePage extends StatefulWidget {
  @override
  _BookOnlinePageState createState() => _BookOnlinePageState();
}

class _BookOnlinePageState extends State<BookOnlinePage> {
  String? selectedCountry;
  String? selectedState;
  String? selectedCity;
  String? selectedDeliveryOption;
  String? selectedPaymentMethod;
  bool _confirmOrder = false;
  File? _file;
  String? selectedCategory;
  String? selectedSubCategory;
  String? selectedSize;
  int? selectedQuantity;

  List<String> categories = [
    'Select Category',
    'Category 1',
    'Category 2',
    'Category 3'
  ];
  Map<String, List<String>> subCategories = {
    'Category 1': [
      'Select Sub-Category',
      'Sub-Category 1-1',
      'Sub-Category 1-2',
      'Sub-Category 1-3'
    ],
    'Category 2': [
      'Select Sub-Category',
      'Sub-Category 2-1',
      'Sub-Category 2-2',
      'Sub-Category 2-3'
    ],
    'Category 3': [
      'Select Sub-Category',
      'Sub-Category 3-1',
      'Sub-Category 3-2',
      'Sub-Category 3-3'
    ],
  };
  List<String> sizes = ['Select Size', 'Small', 'Medium', 'Large'];
  List<int> quantities = [10, 20, 30, 40, 50];

  List<String> countries = [
    'Select Country',
    'Country 1',
    'Country 2',
    'Country 3'
  ];
  Map<String, List<String>> states = {
    'Country 1': ['Select State', 'State 1-1', 'State 1-2', 'State 1-3'],
    'Country 2': ['Select State', 'State 2-1', 'State 2-2', 'State 2-3'],
    'Country 3': ['Select State', 'State 3-1', 'State 3-2', 'State 3-3'],
  };

  Map<String, List<String>> cities = {
    'State 1-1': ['Select City', 'City 1-1-1', 'City 1-1-2', 'City 1-1-3'],
    'State 1-2': ['Select City', 'City 1-2-1', 'City 1-2-2', 'City 1-2-3'],
    'State 1-3': ['Select City', 'City 1-3-1', 'City 1-3-2', 'City 1-3-3'],
    'State 2-1': ['Select City', 'City 2-1-1', 'City 2-1-2', 'City 2-1-3'],
    'State 2-2': ['Select City', 'City 2-2-1', 'City 2-2-2', 'City 2-2-3'],
    'State 2-3': ['Select City', 'City 2-3-1', 'City 2-3-2', 'City 2-3-3'],
    'State 3-1': ['Select City', 'City 3-1-1', 'City 3-1-2', 'City 3-1-3'],
    'State 3-2': ['Select City', 'City 3-2-1', 'City 3-2-2', 'City 3-2-3'],
    'State 3-3': ['Select City', 'City 3-3-1', 'City 3-3-2', 'City 3-3-3'],
  };

  Map<String, List<String>> postalCodes = {
    'City 1-1-1': [
      'Select Postal Code',
      'Code 1-1-1-1',
      'Code 1-1-1-2',
      'Code 1-1-1-3'
    ],
    'City 1-1-2': [
      'Select Postal Code',
      'Code 1-1-2-1',
      'Code 1-1-2-2',
      'Code 1-1-2-3'
    ],
    'City 1-1-3': [
      'Select Postal Code',
      'Code 1-1-3-1',
      'Code 1-1-3-2',
      'Code 1-1-3-3'
    ],
    'City 1-2-1': [
      'Select Postal Code',
      'Code 1-2-1-1',
      'Code 1-2-1-2',
      'Code 1-2-1-3'
    ],
    'City 1-2-2': [
      'Select Postal Code',
      'Code 1-2-2-1',
      'Code 1-2-2-2',
      'Code 1-2-2-3'
    ],
    'City 1-2-3': [
      'Select Postal Code',
      'Code 1-2-3-1',
      'Code 1-2-3-2',
      'Code 1-2-3-3'
    ],
    'City 1-3-1': [
      'Select Postal Code',
      'Code 1-3-1-1',
      'Code 1-3-1-2',
      'Code 1-3-1-3'
    ],
    'City 1-3-2': [
      'Select Postal Code',
      'Code 1-3-2-1',
      'Code 1-3-2-2',
      'Code 1-3-2-3'
    ],
    'City 1-3-3': [
      'Select Postal Code',
      'Code 1-3-3-1',
      'Code 1-3-3-2',
      'Code 1-3-3-3'
    ],
    'City 2-1-1': [
      'Select Postal Code',
      'Code 2-1-1-1',
      'Code 2-1-1-2',
      'Code 2-1-1-3'
    ],
    'City 2-1-2': [
      'Select Postal Code',
      'Code 2-1-2-1',
      'Code 2-1-2-2',
      'Code 2-1-2-3'
    ],
    'City 2-1-3': [
      'Select Postal Code',
      'Code 2-1-3-1',
      'Code 2-1-3-2',
      'Code 2-1-3-3'
    ],
    'City 2-2-1': [
      'Select Postal Code',
      'Code 2-2-1-1',
      'Code 2-2-1-2',
      'Code 2-2-1-3'
    ],
    'City 2-2-2': [
      'Select Postal Code',
      'Code 2-2-2-1',
      'Code 2-2-2-2',
      'Code 2-2-2-3'
    ],
    'City 2-2-3': [
      'Select Postal Code',
      'Code 2-2-3-1',
      'Code 2-2-3-2',
      'Code 2-2-3-3'
    ],
    'City 2-3-1': [
      'Select Postal Code',
      'Code 2-3-1-1',
      'Code 2-3-1-2',
      'Code 2-3-1-3'
    ],
    'City 2-3-2': [
      'Select Postal Code',
      'Code 2-3-2-1',
      'Code 2-3-2-2',
      'Code 2-3-2-3'
    ],
    'City 2-3-3': [
      'Select Postal Code',
      'Code 2-3-3-1',
      'Code 2-3-3-2',
      'Code 2-3-3-3'
    ],
    'City 3-1-1': [
      'Select Postal Code',
      'Code 3-1-1-1',
      'Code 3-1-1-2',
      'Code 3-1-1-3'
    ],
    'City 3-1-2': [
      'Select Postal Code',
      'Code 3-1-2-1',
      'Code 3-1-2-2',
      'Code 3-1-2-3'
    ],
    'City 3-1-3': [
      'Select Postal Code',
      'Code 3-1-3-1',
      'Code 3-1-3-2',
      'Code 3-1-3-3'
    ],
    'City 3-2-1': [
      'Select Postal Code',
      'Code 3-2-1-1',
      'Code 3-2-1-2',
      'Code 3-2-1-3'
    ],
    'City 3-2-2': [
      'Select Postal Code',
      'Code 3-2-2-1',
      'Code 3-2-2-2',
      'Code 3-2-2-3'
    ],
    'City 3-2-3': [
      'Select Postal Code',
      'Code 3-2-3-1',
      'Code 3-2-3-2',
      'Code 3-2-3-3'
    ],
    'City 3-3-1': [
      'Select Postal Code',
      'Code 3-3-1-1',
      'Code 3-3-1-2',
      'Code 3-3-1-3'
    ],
    'City 3-3-2': [
      'Select Postal Code',
      'Code 3-3-2-1',
      'Code 3-3-2-2',
      'Code 3-3-2-3'
    ],
    'City 3-3-3': [
      'Select Postal Code',
      'Code 3-3-3-1',
      'Code 3-3-3-2',
      'Code 3-3-3-3'
    ],
  };
  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        _file = File(result.files.single.path!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Online'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your Trusted Partner for Bulk Orders of Trendy Safety Gear and Precision Surgical Instruments',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'Please use the form below to place an order for Gloves, Jackets, Apparel, Surgical Instruments, or related gear to ensure safe and continued work practices. We will provide confirmation of your order within 24 hours.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Business Area'),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Name'),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Email Address'),
                  ),
                  DropdownButtonFormField<String>(
                    value: selectedCountry,
                    items: countries.map((String country) {
                      return DropdownMenuItem<String>(
                        value: country,
                        child: Text(country),
                      );
                    }).toList(),
                    decoration: InputDecoration(labelText: 'Country'),
                    onChanged: (value) {
                      setState(() {
                        selectedCountry = value;
                        selectedState = null;
                        selectedCity = null;
                      });
                    },
                  ),
                  SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: selectedState,
                    items: selectedCountry != null
                        ? states[selectedCountry]!.map((String state) {
                            return DropdownMenuItem<String>(
                              value: state,
                              child: Text(state),
                            );
                          }).toList()
                        : [],
                    decoration: InputDecoration(labelText: 'State/Province'),
                    onChanged: (value) {
                      setState(() {
                        selectedState = value;
                        selectedCity = null;
                      });
                    },
                    onSaved: (value) {
                      setState(() {
                        selectedState = value;
                      });
                    },
                  ),
                  SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: selectedCity,
                    items: selectedState != null
                        ? cities[selectedState]!.map((String city) {
                            return DropdownMenuItem<String>(
                              value: city,
                              child: Text(city),
                            );
                          }).toList()
                        : [],
                    decoration: InputDecoration(labelText: 'City'),
                    onChanged: (value) {
                      setState(() {
                        selectedCity = value;
                      });
                    },
                    onSaved: (value) {
                      setState(() {
                        selectedCity = value;
                      });
                    },
                  ),
                  SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: null,
                    items: selectedCity != null
                        ? postalCodes[selectedCity]!.map((String postalCode) {
                            return DropdownMenuItem<String>(
                              value: postalCode,
                              child: Text(postalCode),
                            );
                          }).toList()
                        : [],
                    decoration:
                        InputDecoration(labelText: 'Postal Code/Zip Code'),
                    onChanged: (value) {},
                    onSaved: (value) {},
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Shipping Address'),
                  ),
                  SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    value: selectedCategory,
                    items: categories.map((String category) {
                      return DropdownMenuItem<String>(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    decoration: InputDecoration(labelText: 'Category'),
                    onChanged: (value) {
                      setState(() {
                        selectedCategory = value;
                        selectedSubCategory =
                            null;
                      });
                    },
                  ),
                  SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: selectedSubCategory,
                    items: selectedCategory != null
                        ? subCategories[selectedCategory!]!
                            .map((String subCategory) {
                            return DropdownMenuItem<String>(
                              value: subCategory,
                              child: Text(subCategory),
                            );
                          }).toList()
                        : [
                            DropdownMenuItem<String>(
                                value: 'Select Sub-Category',
                                child: Text('Select Sub-Category'))
                          ],
                    decoration: InputDecoration(labelText: 'Sub-Category'),
                    onChanged: (value) {
                      setState(() {
                        selectedSubCategory = value;
                      });
                    },
                  ),
                  SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: selectedSize,
                    items: sizes.map((String size) {
                      return DropdownMenuItem<String>(
                        value: size,
                        child: Text(size),
                      );
                    }).toList(),
                    decoration: InputDecoration(labelText: 'Size'),
                    onChanged: (value) {
                      setState(() {
                        selectedSize = value;
                      });
                    },
                  ),
                  SizedBox(height: 10),
                  DropdownButtonFormField<int>(
                    value: selectedQuantity,
                    items: quantities.map((int quantity) {
                      return DropdownMenuItem<int>(
                        value: quantity,
                        child: Text(quantity.toString()),
                      );
                    }).toList(),
                    decoration: InputDecoration(labelText: 'Quantity'),
                    onChanged: (value) {
                      setState(() {
                        selectedQuantity = value!;
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    value: selectedPaymentMethod,
                    items: [
                      DropdownMenuItem(
                        value: 'Credit Card',
                        child: Text('Credit Card'),
                      ),
                      DropdownMenuItem(
                        value: 'Paypal',
                        child: Text('Paypal'),
                      ),
                    ],
                    decoration: InputDecoration(
                      labelText: 'Preferred Payment Method',
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    ),
                    onChanged: (value) {
                      setState(() {});
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _pickFile,
                    child: Text('Upload File'),
                  ),
                  SizedBox(height: 20),
                  if (_file != null) Text('Selected File: ${_file!.path}'),
                  SizedBox(height: 20),
                  SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    value: selectedDeliveryOption,
                    items: [
                      DropdownMenuItem(
                        value: 'Standard Delivery',
                        child: Text('Standard Delivery'),
                      ),
                      DropdownMenuItem(
                        value: 'Express Delivery',
                        child: Text('Express Delivery'),
                      ),
                    ],
                    decoration: InputDecoration(
                      labelText: 'Preferred Delivery Option',
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    ),
                    onChanged: (value) {
                      setState(() {
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Checkbox(
                        value: _confirmOrder,
                        onChanged: (value) {
                          setState(() {
                            _confirmOrder = true;
                          });
                        },
                      ),
                      Expanded(
                        child: Text(
                          'I confirm that I have approval to place this order.',
                          overflow:
                              TextOverflow.clip,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: double.infinity,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(10),

                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFFF82249),
                              spreadRadius: 2,
                              blurRadius: 1,
                              offset:
                                  Offset(0, 3),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors
                                .transparent,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(10),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Order Now",
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
