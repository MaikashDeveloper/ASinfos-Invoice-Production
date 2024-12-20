import 'package:asinfos_invoice/backend/pdf_file_design.dart';
import 'package:asinfos_invoice/backend/pdf_functions.dart';
import 'package:asinfos_invoice/components/button.dart';
import 'package:asinfos_invoice/components/ceck_box.dart';
import 'package:asinfos_invoice/components/features_box.dart';
import 'package:asinfos_invoice/components/text_field.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';

// UI Class
class DesktopView extends StatefulWidget {
  const DesktopView({super.key});

  @override
  State<DesktopView> createState() => _DesktopViewState();
}

class _DesktopViewState extends State<DesktopView> {
  final _myBox = Hive.box('myBox');
  PdfFunctions pdfFuc = PdfFunctions();
  late String fileName, clientName, invoiceNumber;
  String selectLocation = '', discountText = "1";
  String date = DateFormat.yMMMd('en_US').toString();
  @override
  void initState() {
    // if this the first time app run Tell the data Given ok
    if (_myBox.get("ProductList") == null) {
      pdfFuc.createInitialData();
    } else {
      // There alread data is
      // Hive.deleteBoxFromDisk('myBox');
      pdfFuc.loadData();
    }
    super.initState();
  }

  final TextEditingController controllerProdectName = TextEditingController();
  final TextEditingController controllerProdectPrice = TextEditingController();
  final TextEditingController prodectSerialNum = TextEditingController();
  final TextEditingController fileNameController = TextEditingController();
  final TextEditingController clientNameController = TextEditingController();
  final TextEditingController invoiceNumberControler = TextEditingController();
  final TextEditingController discountControler = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Flex(
          direction: Axis.horizontal,
          children: [
            // First Box (File Inputs and Buttons)
            Expanded(
              flex: 3,
              child: Container(
                margin: const EdgeInsets.only(bottom: 60),
                height: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 20,
                    color: Colors.black,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MyTextField(
                      lableText: "Enter File Name",
                      controller: fileNameController,
                    ),
                    MyTextField(
                      lableText: "Enter Client Name",
                      controller: clientNameController,
                    ),
                    MyTextField(
                      lableText: "Enter Invoice Number",
                      controller: invoiceNumberControler,
                    ),
                    Column(
                      children: [
                        MyButton(
                          height: 60,
                          width: 200,
                          buttonColor: const Color.fromARGB(255, 229, 115, 115),
                          text: "Select File Location",
                          onTap: () async {
                            print("₹");
                            selectLocation = await pdfFuc.fileLOcation();
                            setState(() {
                              pdfFuc.fileLocation = selectLocation;
                            });
                          },
                        ),
                        Text(pdfFuc.fileLocation),
                      ],
                    ),
                    MyButton(
                      height: 60,
                      width: 200,
                      buttonColor: const Color.fromARGB(255, 92, 245, 79),
                      text: "Generate File",
                      //text: '\u{20B9}',
                      onTap: () async {
                        print(pdfFuc.productItemsAllDate);
                        double totalPrice =
                            pdfFuc.productPrices.reduce((a, b) => a + b);
                        print(
                            "${pdfFuc.productPrices} \n The total Price $totalPrice");

                        // The Datas are setting now
                        fileName = fileNameController.text;
                        invoiceNumber = invoiceNumberControler.text;
                        clientName = clientNameController.text;
                        // Calling the Design Page Class instances
                        InvoiceDesign design = InvoiceDesign(
                          context: context,
                          fileName: fileName,
                          clientName: clientName,
                          invoiceNumber: invoiceNumber,
                          date: date,
                          fileLocation: selectLocation,
                          prodectsItems: pdfFuc.productItemsAllDate,
                          total: totalPrice,
                        );
                        design.pdfFileDesign();

                        fileNameController.clear();
                        invoiceNumberControler.clear();
                        clientNameController.clear();
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 20),
            // Second Box (CheckBox List)
            Expanded(
              flex: 4,
              child: Column(
                children: [
                  Container(
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Prodect Serial No:"),
                        Text("Service Name"),
                        Text("Service Price"),
                        Text("Select The Service"),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: pdfFuc.productList.length,
                      itemBuilder: (context, index) {
                        return MyCheckBox(
                          prodectserialNumber: index,
                          productName: pdfFuc.productList[index][0],
                          productPrice: pdfFuc.productList[index][2].toString(),
                          itemSellect: pdfFuc.productList[index][1],
                          discountText: discountText,
                          controller: discountControler,
                          onChanged: (newValue) {
                            setState(() {
                              pdfFuc.productList[index][1] = newValue;
                              if (newValue == true) {
                                pdfFuc.productItemsAllDate.add([
                                  pdfFuc.productList[index][0],
                                  pdfFuc.productList[index][2],
                                  discountControler.text.isEmpty
                                      ? "1"
                                      : discountControler.text,
                                ]);
                                pdfFuc.productPrices.add(
                                  pdfFuc.productList[index][2],
                                );
                              } else {
                                pdfFuc.productItemsAllDate.removeWhere(
                                  (item) =>
                                      item[0] == pdfFuc.productList[index][0] &&
                                      item[1] == pdfFuc.productList[index][2],
                                );
                                pdfFuc.productPrices
                                    .remove(pdfFuc.productList[index][2]);
                              }
                            });
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 20),
            // Third Box (Features)
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  Expanded(
                    child: MyFeatureBox(
                      height: 250,
                      width: 250,
                      boxName: "ADD FORM THE LIST",
                      boxIcon: const Icon(
                        Icons.add,
                        size: 50,
                      ),
                      boxColor: const Color.fromARGB(255, 144, 202, 249),
                      onTap: () {
                        pdfFuc.createNewProduct(context, controllerProdectName,
                            controllerProdectPrice, setState);
                      },
                    ),
                  ),
                  Expanded(
                    child: MyFeatureBox(
                      height: 250,
                      width: 250,
                      boxName: "EDIT FORM THE LIST",
                      boxIcon: const Icon(
                        Icons.edit,
                        size: 50,
                      ),
                      boxColor: const Color.fromARGB(255, 144, 202, 249),
                      onTap: () {
                        pdfFuc.editProduct(
                            context,
                            prodectSerialNum,
                            controllerProdectName,
                            controllerProdectPrice,
                            setState);
                      },
                    ),
                  ),
                  Expanded(
                    child: MyFeatureBox(
                      height: 250,
                      width: 250,
                      boxName: "DELETE FORM THE LIST",
                      boxIcon: const Icon(
                        Icons.delete,
                        size: 50,
                      ),
                      boxColor: const Color.fromARGB(255, 144, 202, 249),
                      onTap: () {
                        pdfFuc.deleteProduct(
                            context, prodectSerialNum, setState);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
