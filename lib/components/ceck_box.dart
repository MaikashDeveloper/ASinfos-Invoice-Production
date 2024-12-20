import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MyCheckBox extends StatelessWidget {
  final String productName, discountText;
  final int prodectserialNumber;
  final String productPrice;
  final bool itemSellect;
  Function(bool?)? onChanged;
  final TextEditingController controller;

  MyCheckBox({
    super.key,
    required this.prodectserialNumber,
    required this.productName,
    required this.productPrice,
    required this.itemSellect,
    required this.onChanged,
    required this.discountText,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          color: itemSellect
              ? Colors.green
              : const Color.fromARGB(255, 7, 132, 204),
        ),
        child: Flex(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            //  Flexible Widget for Product Serial Number

            SizedBox(
              height: 50,
              child: Center(
                child: Text(
                  (prodectserialNumber + 1).toString(),
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            ),

            // First Flexible Widget for Product Name
            Flexible(
              flex: 2,
              child: SizedBox(
                height: 50,
                child: Center(
                  child: Text(
                    productName,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
            // Second Flexible Widget for Product Price
            Flexible(
              flex: 1,
              child: SizedBox(
                height: 50,
                child: Center(
                  child: Text(
                    productPrice.toString(),
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
            // The new textfild to used to fill the number of discount want to appliyed

            // Third Flexible Widget for Checkbox
            Flexible(
              flex: 1,
              child: SizedBox(
                height: 50,
                child: Center(
                  child: Checkbox(
                    value: itemSellect,
                    onChanged: onChanged,
                    fillColor: WidgetStateProperty.resolveWith<Color>(
                      (Set<WidgetState> states) {
                        if (states.contains(WidgetState.hovered)) {
                          return itemSellect ? Colors.red : Colors.green;
                        }
                        return const Color.fromARGB(255, 0, 153, 255);
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
