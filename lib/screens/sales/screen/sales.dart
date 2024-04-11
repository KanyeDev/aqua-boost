import 'dart:convert';
import 'dart:typed_data';

import 'package:aquaboost/core/hight_and_width.dart';
import 'package:aquaboost/utilities/toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:printing/printing.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../streamBuilders/sales_stream_builder.dart';
import '../../../widgets/search_and_sort.dart';
import '../widget/sales_table_entries.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'package:url_launcher_web/url_launcher_web.dart';


class Sales extends StatefulWidget {
  Sales({super.key});

  @override
  State<Sales> createState() => _SalesState();
}

class _SalesState extends State<Sales> {
  final sales = FirebaseFirestore.instance.collection('sales').snapshots();

  final salesToPrint = FirebaseFirestore.instance.collection('sales');

  TextEditingController salesController = TextEditingController();

  String mail = "adekanyeabdulkabir@gmail.com";
  Uint8List? pdfBytes;

  Future<void> generatePdfFromStream(
      Stream<QuerySnapshot<Map<String, dynamic>>> stream) async {
    // Listen for data from the Firestore stream
    try {
      await for (QuerySnapshot<Map<String, dynamic>> snapshot in stream) {
        // Extract data from the snapshot and convert it to a list of maps
        List<Map<String, dynamic>> data =
            snapshot.docs.map((doc) => doc.data()).toList();

        // Generate PDF using the data
        await generatePdf(data);
      }
    } catch (e) {
      Utility().toastMessage(e.toString());
    }
  }

// Function to generate PDF from a list of maps
  Future<Uint8List> generatePdf(List<Map<String, dynamic>> data) async {
    print("i see here 1");
    // try {
      final pdf = pw.Document();

      final font = await PdfGoogleFonts.nunitoExtraLight();
      // Add content to the PDF
      pdf.addPage(
        pw.MultiPage(
          pageTheme: pw.PageTheme(
            orientation: pw.PageOrientation.portrait,
            theme: pw.ThemeData.withFont(
              base: font,

            ),
          ),
          build: (context) => [
            // Add data from the list of maps to PDF
            for (var item in data)
              pw.Text(
                  '${item["black"]}: ${item["red"]}'),
          ],
        ),
      );

      print("i see here 2");
      // Save the PDF file
    final Uint8List pdfBytes = await pdf.save();
    await sendEmailWithAttachment(pdfBytes).then((value) {
      Utility().toastMessage("Pdf sent to $mail");
    }).onError((error, stackTrace) {
      Utility().toastMessage(error.toString());
    });


      print("i see here 3");
      print('PDF sent  to: $mail');
    // } catch (e) {
    //   Utility().toastMessage(e.toString());
    // }

    return pdfBytes;
  }

  Future<Uri> sendEmailWithAttachment(Uint8List pdfBytes) async {
    // Encode the PDF bytes as base64
    String pdfBase64 = base64Encode(pdfBytes);

    // Construct the mailto URI with the attached PDF
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: mail,
      queryParameters: {
        'subject': 'PDF Attachment',
        'body': 'Attached is the PDF file.',
        'attachments': 'data:application/pdf;base64,$pdfBase64',
      },
    );
return emailUri;
  }

  void launchMail(Uri emailUri)async{

    // Launch the user's email client with the mailto URI
    if (await canLaunchUrl(emailUri)) {
    await launchUrl(emailUri);
    } else {
    throw 'Could not launch email';
    }
  }


  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Gap(20),
          Container(
            height: mHeight(context)/1.5 + 30,
            width: mWidth(context)/1.3,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 2,
                  offset: const Offset(0.8, 2), // changes position of shadow
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  const Gap(30),
                  SearchAndSort(
                    text: 'Sales Summary',
                    onPressed: ()  {
                      //  pdfBytes = await generatePdf([
                      //   {"black" : 23, "red": 2},
                      //   {"black": 89, "red":22}
                      // ]);
                      //

                    }, onEditTap: (value) {
                      setState(() {}); // Trigger rebuild when search query changes
                    }
                  , editController: salesController,
                  ),
                  const Gap(10),
                  const Divider(
                    color: Colors.black87,
                  ),
                  const SalesTableEntries(),
                  const Divider(
                    color: Colors.black87,
                  ),
                  SalesStreamData(sales, salesController)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
