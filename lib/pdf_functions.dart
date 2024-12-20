import 'package:asinfos_invoice/components/button.dart';
import 'package:asinfos_invoice/components/dialog_box.dart';
import 'package:asinfos_invoice/components/text_field.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class PdfFunctions {
  // Calling The Hive there
  final _myBox = Hive.box('myBox');
  List<dynamic> productList = [
    // ["Development", false, 1000],
    // ["Design", false, 2000],
    // ['Testing', false, 1000],
    // ["SEO", false, 5000],
    // ["Deployment", false, 5000],
  ];

  // run this method if this is the 1st time Ever open the app
  void createInitialData() {
    productList = [
      ["Development", false, 1000.00],
      ["Design", false, 2000.25],
      ['Testing', false, 1000.00],
      ["SEO", false, 5000.00],
      // ["Deployment", false, 5000],
    ];
  }

  // load data from Hive
  void loadData() {
    productList = _myBox.get("ProductList");
  }

  // Update the data Base Now
  void updateDataBase() {
    _myBox.put("ProductList", productList);
  }

  final List<dynamic> productItemsAllDate = [];
  final List<double> productPrices = [];

  String fileLocation = 'Select File Location';

  // Function to delete a product
  void deleteProduct(BuildContext context,
      TextEditingController prodectSerialNum, Function setStateCallback) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          content: SizedBox(
            height: 180,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                MyTextField(
                  lableText: "Enter Product Number",
                  controller: prodectSerialNum,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    MyButton(
                      height: 50,
                      width: 100,
                      buttonColor: Colors.green,
                      text: "Delete",
                      onTap: () {
                        int? deleteIndex = int.tryParse(prodectSerialNum.text);
                        if (deleteIndex != null &&
                            deleteIndex > 0 &&
                            deleteIndex <= productList.length) {
                          setStateCallback(() {
                            productList.removeAt(
                                deleteIndex - 1); // Adjusted for 1-based index
                          });
                          updateDataBase();
                          Navigator.of(context)
                              .pop(); // Close the dialog after deletion
                          prodectSerialNum.clear();
                        } else {
                          print("Invalid product number.");
                        }
                      },
                    ),
                    MyButton(
                      height: 50,
                      width: 100,
                      buttonColor: Colors.red,
                      text: "Cancel",
                      onTap: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Function to edit a product
  void editProduct(
      BuildContext context,
      TextEditingController prodectSerialNum,
      TextEditingController controllerProdectName,
      TextEditingController controllerProdectPrice,
      Function setStateCallback) {
    showDialog(
      context: context,
      builder: (context) {
        return MyDialogBox2(
          boxColor: const Color.fromARGB(255, 255, 213, 79),
          indexNumber: prodectSerialNum,
          textEditingControllerProdect: controllerProdectName,
          textEditingControllerPrice: controllerProdectPrice,
          onPressSave: () {
            String prodectName = controllerProdectName.text;
            String pPrice = controllerProdectPrice.text;

            if (prodectName.isNotEmpty &&
                pPrice.isNotEmpty &&
                prodectSerialNum.text.isNotEmpty) {
              double? prodectPrice = double.tryParse(pPrice);
              int? indexNumber = int.tryParse(prodectSerialNum.text);

              if (prodectPrice != null && indexNumber != null) {
                indexNumber = indexNumber - 1;

                if (indexNumber >= 0 && indexNumber < productList.length) {
                  setStateCallback(() {
                    productList[indexNumber!] = [
                      prodectName,
                      false,
                      prodectPrice
                    ];
                  });
                  updateDataBase();
                  controllerProdectName.clear();
                  controllerProdectPrice.clear();
                  prodectSerialNum.clear();
                  Navigator.of(context).pop();
                } else {
                  print("Error: Invalid index number.");
                }
              } else {
                print("Error: Unable to parse the price or index.");
              }
            } else {
              print("Error: Product name, price, or index is empty.");
            }
          },
          onPressCancle: () {
            controllerProdectName.clear();
            controllerProdectPrice.clear();
            prodectSerialNum.clear();
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  // Function to create a new product
  void createNewProduct(
      BuildContext context,
      TextEditingController controllerProdectName,
      TextEditingController controllerProdectPrice,
      Function setStateCallback) {
    showDialog(
      context: context,
      builder: (context) {
        return MyDialogBox(
          boxColor: const Color.fromARGB(255, 129, 212, 250),
          textEditingControllerProdect: controllerProdectName,
          textEditingControllerPrice: controllerProdectPrice,
          onPressSave: () {
            String prodectName = controllerProdectName.text;
            String pPrice = controllerProdectPrice.text;

            if (pPrice.isNotEmpty) {
              double? prodectPrice = double.tryParse(pPrice);
              if (prodectPrice != null) {
                setStateCallback(() {
                  productList.add([prodectName, false, prodectPrice]);
                });
                updateDataBase();
                controllerProdectName.clear();
                controllerProdectPrice.clear();
                Navigator.of(context).pop();
              } else {
                print("Error: Unable to parse the price.");
              }
            }
          },
          onPressCancle: () => Navigator.of(context).pop(),
        );
      },
    );
  }

  //************************************************************/
  // The Function is used to Select The File
  Future<String> fileLOcation() async {
    String? fileLocation = await FilePicker.platform.getDirectoryPath();
    if (fileLocation != null) {
      return fileLocation;
    }
    return fileLocation = 'Select File Location';
  }
}
