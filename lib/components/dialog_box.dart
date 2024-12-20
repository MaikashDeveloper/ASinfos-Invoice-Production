import 'package:asinfos_invoice/components/button.dart';
import 'package:asinfos_invoice/components/text_field.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MyDialogBox extends StatelessWidget {
  final Color boxColor;
  VoidCallback onPressSave;
  VoidCallback onPressCancle;
  final TextEditingController textEditingControllerProdect,
      textEditingControllerPrice;
  MyDialogBox({
    super.key,
    required this.boxColor,
    required this.textEditingControllerProdect,
    required this.textEditingControllerPrice,
    required this.onPressSave,
    required this.onPressCancle,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: boxColor,
      content: SizedBox(
        height: 360,
        width: 460,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // get Prodect name
              MyTextField(
                lableText: 'Enter Prodect Name',
                controller: textEditingControllerProdect,
              ),
              const SizedBox(
                height: 40,
              ),
              // get Prodect Price
              MyTextField(
                lableText: 'Enter Prodect Price in Number only',
                controller: textEditingControllerPrice,
              ),
              const SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  MyButton(
                    height: 50,
                    width: 100,
                    buttonColor: Colors.green,
                    text: "Save",
                    onTap: onPressSave,
                  ),
                  MyButton(
                    height: 50,
                    width: 100,
                    buttonColor: Colors.red,
                    text: "Cancle",
                    onTap: onPressCancle,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class MyDialogBox2 extends StatelessWidget {
  final Color boxColor;
  VoidCallback onPressSave;
  VoidCallback onPressCancle;
  final TextEditingController textEditingControllerProdect,
      textEditingControllerPrice,
      indexNumber;
  MyDialogBox2({
    super.key,
    required this.boxColor,
    required this.indexNumber,
    required this.textEditingControllerProdect,
    required this.textEditingControllerPrice,
    required this.onPressSave,
    required this.onPressCancle,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: boxColor,
      content: SizedBox(
        height: 360,
        width: 460,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              MyTextField(
                lableText: 'Enter Prodect Index Number',
                controller: indexNumber,
              ),
              const SizedBox(
                height: 40,
              ),
              // get Prodect name
              MyTextField(
                lableText: 'Enter Prodect Name',
                controller: textEditingControllerProdect,
              ),
              const SizedBox(
                height: 40,
              ),
              // get Prodect Price
              MyTextField(
                lableText: 'Enter Prodect Price in Number only',
                controller: textEditingControllerPrice,
              ),
              const SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  MyButton(
                    height: 50,
                    width: 100,
                    buttonColor: Colors.green,
                    text: "Save",
                    onTap: onPressSave,
                  ),
                  MyButton(
                    height: 50,
                    width: 100,
                    buttonColor: Colors.red,
                    text: "Cancle",
                    onTap: onPressCancle,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
