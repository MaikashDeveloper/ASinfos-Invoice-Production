import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart' show rootBundle;
import 'package:printing/printing.dart';

class InvoiceDesign {
  InvoiceDesign({
    required this.context,
    required this.fileName,
    required this.clientName,
    required this.invoiceNumber,
    required this.date,
    required this.fileLocation,
    required this.prodectsItems,
    required this.total,
  });

  final logo = "assets/logo.svg";
  final bgShape = "assets/invoice.svg";

  BuildContext context;
  String fileName;
  String clientName;
  String invoiceNumber;
  String fileLocation;
  String date;
  double total;
  List<dynamic> prodectsItems;

  // Function to create a PDF file with specified content and style
  void pdfFileDesign() async {
    final doc = pw.Document();

    // Load the SVG file content before building the PDF
    String? svgString;
    try {
      svgString = await rootBundle.loadString(logo);
    } catch (e) {
      print('Error loading SVG: $e');
    }

    // Load the SVG file content before building the PDF
    String? svgStringBg;
    try {
      svgStringBg = await rootBundle.loadString(bgShape);
    } catch (e) {
      print('Error loading SVG: $e');
    }

    doc.addPage(
      pw.MultiPage(
        pageTheme: _buildTheme(
          await PdfGoogleFonts.robotoRegular(),
          await PdfGoogleFonts.robotoBold(),
          await PdfGoogleFonts.robotoItalic(),
          svgStringBg,
        ),
        header: (pw.Context context) => buildHeader(
          context,
          svgString,
          invoiceNumber,
        ),
        footer: (context) => _buildFooter(context),
        build: (context) => [
          _contentHeader(context),
          _contentTable(context),
          _contentFooter(context),
          _termsAndConditions(context),
        ],
      ),
    );

    final file = File('$fileLocation/$fileName.pdf');
    await file.writeAsBytes(await doc.save());

    // Show a message that the PDF was saved
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Invoice saved to $fileLocation'),
      ),
    );
  }

  pw.PageTheme _buildTheme(
    pw.Font base,
    pw.Font bold,
    pw.Font italic,
    String? bgShape,
  ) {
    return pw.PageTheme(
      theme: pw.ThemeData.withFont(
        base: base,
        bold: bold,
        italic: italic,
      ),
      buildBackground: (context) => pw.FullPage(
        ignoreMargins: true,
        child: bgShape != null
            ? pw.SvgImage(svg: bgShape)
            : pw.PdfLogo(), // Fallback to PDF logo if SVG is null
      ),
    );
  }

  pw.Widget buildHeader(
      pw.Context context, String? svgString, String invoiceNumber) {
    return pw.Column(
      children: [
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Expanded(
              child: pw.Column(
                mainAxisSize: pw.MainAxisSize.min,
                children: [
                  pw.Container(
                    alignment: pw.Alignment.topRight,
                    padding: const pw.EdgeInsets.only(
                      bottom: 8,
                      left: 20,
                      right: 40,
                    ),
                    height: 150,
                    width: 150,
                    child: svgString != null
                        ? pw.SvgImage(svg: svgString)
                        : pw.PdfLogo(), // Fallback to PDF logo if SVG is null
                  ),
                ],
              ),
            ),
            pw.Expanded(
              child: pw.Column(
                children: [
                  pw.Container(
                    height: 50,
                    padding: const pw.EdgeInsets.only(left: 20),
                    alignment: pw.Alignment.centerLeft,
                    child: pw.Text(
                      'ASinfos',
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 40,
                        color: PdfColors.deepPurple,
                      ),
                    ),
                  ),
                  pw.Container(
                    decoration: const pw.BoxDecoration(
                      borderRadius: pw.BorderRadius.all(pw.Radius.circular(2)),
                    ),
                    padding: const pw.EdgeInsets.only(
                      left: 40,
                      top: 10,
                      bottom: 10,
                      right: 20,
                    ),
                    alignment: pw.Alignment.centerLeft,
                    height: 50,
                    child: pw.DefaultTextStyle(
                      style: const pw.TextStyle(
                        fontSize: 12,
                        // Set default text color to black
                      ),
                      child: pw.Wrap(
                        spacing: 4,
                        runSpacing: 4,
                        children: [
                          pw.Text(
                            'Invoice :',
                            style: const pw.TextStyle(), // Blue color for label
                          ),
                          pw.Text(
                            '$invoiceNumber \n',
                            style: const pw
                                .TextStyle(), // Green color for invoice number
                          ),
                          pw.Text(
                            'Date:',
                            style: const pw.TextStyle(), // Blue color for label
                          ),
                          pw.Text(
                            'date',
                            style: const pw.TextStyle(
                              color: PdfColors.black,
                            ), // Orange color for date
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        if (context.pageNumber > 1) pw.SizedBox(height: 20),
      ],
    );
  }

  pw.Widget _buildFooter(pw.Context context) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        pw.Container(
          height: 20,
          width: 100,
          child: pw.BarcodeWidget(
            barcode: pw.Barcode.pdf417(),
            data: 'Invoice# 20',
            drawText: true,
          ),
        ),
        pw.Text(
          'Page ${context.pageNumber}/${context.pagesCount}',
          style: const pw.TextStyle(
            fontSize: 12,
            color: PdfColors.pink,
          ),
        ),
      ],
    );
  }

  // The Body Head
  pw.Widget _contentHeader(pw.Context context) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Expanded(
          child: pw.Container(
            margin: const pw.EdgeInsets.symmetric(horizontal: 20),
            height: 70,
            child: pw.FittedBox(
              child: pw.Text(
                'Total: ${_formatCurrency(total)}',
                style: pw.TextStyle(
                  color: PdfColors.black,
                  fontStyle: pw.FontStyle.italic,
                ),
              ),
            ),
          ),
        ),
        pw.Expanded(
          child: pw.Row(
            children: [
              pw.Container(
                margin: const pw.EdgeInsets.only(left: 10, right: 10),
                height: 70,
                child: pw.Text(
                  'Invoice to:',
                  style: pw.TextStyle(
                    color: PdfColors.black,
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              pw.Expanded(
                child: pw.Container(
                  height: 70,
                  child: pw.RichText(
                    text: pw.TextSpan(
                      text: clientName,
                      style: pw.TextStyle(
                        color: PdfColors.black,
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 12,
                      ),
                      children: [
                        const pw.TextSpan(
                          text: '\n',
                          style: pw.TextStyle(
                            fontSize: 5,
                          ),
                        ),
                        pw.TextSpan(
                          text: "The Customer Address Editable Now",
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.normal,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // The Body Foter this is
  pw.Widget _contentFooter(pw.Context context) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Expanded(
          flex: 2,
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Thank you for your business',
                style: pw.TextStyle(
                  color: PdfColors.black,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Container(
                margin: const pw.EdgeInsets.only(top: 20, bottom: 8),
                child: pw.Text(
                  'Payment Info:',
                  style: pw.TextStyle(
                    color: PdfColors.black,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.Text(
                "paymentInfo if want to Edit ",
                style: const pw.TextStyle(
                  fontSize: 8,
                  lineSpacing: 5,
                  color: PdfColors.black,
                ),
              ),
            ],
          ),
        ),
        pw.Expanded(
          flex: 1,
          child: pw.DefaultTextStyle(
            style: const pw.TextStyle(
              fontSize: 10,
              color: PdfColors.black,
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Sub Total:'),
                    pw.Text('₹$total'),
                  ],
                ),
                pw.SizedBox(height: 5),
                // pw.Row(
                //   mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                //   children: [
                //     pw.Text('Tax:'),
                //     pw.Text('{(tax * 100).toStringAsFixed(1)}%'),
                //   ],
                // ),
                pw.Divider(
                  color: PdfColors.purple,
                ),
                pw.DefaultTextStyle(
                  style: pw.TextStyle(
                    color: PdfColors.black,
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                  ),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('Total:'),
                      pw.Text('₹$total'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // The Body Temrms and Conductions
  pw.Widget _termsAndConditions(pw.Context context) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        pw.Expanded(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Container(
                decoration: const pw.BoxDecoration(
                  border: pw.Border(
                      top: pw.BorderSide(
                    color: PdfColors.purple,
                  )),
                ),
                padding: const pw.EdgeInsets.only(top: 10, bottom: 4),
                child: pw.Text(
                  'Terms & Conditions',
                  style: pw.TextStyle(
                    fontSize: 12,
                    color: PdfColors.deepPurple,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.Text(
                pw.LoremText().paragraph(40),
                textAlign: pw.TextAlign.justify,
                style: const pw.TextStyle(
                  fontSize: 6,
                  lineSpacing: 2,
                  color: PdfColors.black,
                ),
              ),
            ],
          ),
        ),
        pw.Expanded(
          child: pw.SizedBox(),
        ),
      ],
    );
  }

  // The Table Part
  pw.Widget _contentTable(pw.Context context) {
    const tableHeaders = [
      'Item Description',
      'Price',
      'Quantity',
      'Total',
    ];

    return pw.TableHelper.fromTextArray(
      border: pw.TableBorder.all(
        width: 0.5,
        color: PdfColors.grey300,
      ),
      cellPadding: const pw.EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      cellAlignment: pw.Alignment.centerLeft,
      headerDecoration: const pw.BoxDecoration(
        color: PdfColors.deepPurple,
        borderRadius: pw.BorderRadius.vertical(
          top: pw.Radius.circular(4),
        ),
      ),
      headerHeight: 30,
      cellHeight: 30,
      cellAlignments: {
        0: pw.Alignment.centerLeft,
        1: pw.Alignment.centerRight,
        2: pw.Alignment.center, // Quantity centered
        3: pw.Alignment.centerRight,
      },
      headerStyle: pw.TextStyle(
        color: PdfColors.white,
        fontSize: 12,
        fontWeight: pw.FontWeight.bold,
      ),
      cellStyle: const pw.TextStyle(
        color: PdfColors.grey800,
        fontSize: 10,
      ),
      rowDecoration: const pw.BoxDecoration(
        border: pw.Border(
          bottom: pw.BorderSide(
            color: PdfColors.grey300,
            width: 0.5,
          ),
        ),
      ),
      headers: tableHeaders,
      data: List<List<String>>.generate(
        prodectsItems.length,
        (row) => [
          prodectsItems[row][0].toString(), // Item Description
          prodectsItems[row][1].toString(), // Price
          "1", // Quantity (always set to "1")
          prodectsItems[row][1].toString(), // Total
        ],
      ),
    );
  }

  String _formatCurrency(double amount) {
    return '₹${amount.toStringAsFixed(2)}';
  }

  String _formatDate(DateTime date) {
    final format = DateFormat.yMMMd('en_US');
    return format.format(date);
  }
}
