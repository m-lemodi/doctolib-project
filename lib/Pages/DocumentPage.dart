
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_full_pdf_viewer/full_pdf_viewer_scaffold.dart';

import '../Database/ProfileDataBase.dart';
import '../main.dart';
import '../utils/style.dart';
import 'package:flutter/services.dart' show ByteData, Uint8List, rootBundle;
import 'package:path_provider/path_provider.dart';

String? selectedProfile2 = "All";
String sort = "All";
const String _documentPath = 'lib/Assets/ordo.pdf';

List docs = ["ordonance 1", "ordonance 2", "ordonance 3"];
List proprio = ["emma", "emma", "gribouille"];
List lien = [];

class DocumentPage extends StatefulWidget{

  @override
  State<DocumentPage> createState() => _DocumentPage();

}

class _DocumentPage extends State<DocumentPage> {

  Future<String> prepareTestPdf() async {
    final ByteData bytes =
    await DefaultAssetBundle.of(context).load(_documentPath);
    final Uint8List list = bytes.buffer.asUint8List();

    final tempDir = await getTemporaryDirectory();
    final tempDocumentPath = '${tempDir.path}/$_documentPath';

    final file = await File(tempDocumentPath).create(recursive: true);
    file.writeAsBytesSync(list);
    return tempDocumentPath;
  }



  @override
  Widget build(BuildContext context) {
    final Future<List<Map<String, Object?>>> famille =  ProfileDataBase.getFamille(id_account);

    return Scaffold(
        body: SingleChildScrollView(

        child:  Padding(
            padding: EdgeInsets.all(10.0),
            // child : SingleChildScrollView(
            child:
       Column(
          children: [
            Row(
              children:[
                Spacer(),
                Text("Add Documents", style: TitleStyle),
                IconButton(
                  onPressed: () => print("add"),
                  icon: Icon(Icons.add_circle),
                  color: Colors.green,
                  iconSize: 50,
                  ),
                Spacer(),

              ]
            ),

            FutureBuilder<List<Map<String, Object?>>>(
                future: famille,
                builder: (BuildContext context, AsyncSnapshot<List<Map<String, Object?>>> snapshot)
                {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    print("cry 1");
                    return Text('Erreur: ${snapshot.error}');
                  } else {

                    List<Map<String, Object?>> famille = snapshot.data!;
                    List<String> choices =["All", ...ProfileDataBase.getFamilleName(famille)];
                    return Column(
                    children : [

                      DropdownButtonFormField(
                        value: selectedProfile2,
                        items: choices.map((String value) {
                          return DropdownMenuItem(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedProfile2 = newValue!;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: 'filtre sujet',
                          border: OutlineInputBorder(),

                        )
                    ),
                      Container (
                       height: 2000, // Set an appropriate height value

                       child :
                        ListView.builder(
                        itemCount: docs.length,
                        itemBuilder: (BuildContext context, int index) {

                          return Column (
                            children :[
                              SizedBox(height: 10.0),
                              Container(
                                  decoration: box,
                                  height: 80.0,
                                  child: Row(
                                  children :[
                                    Text(docs[index]),
                                    Spacer(),
                                    Text(proprio[index]),
                                    Spacer(),
                                    IconButton(onPressed: (){

                                      prepareTestPdf().then((path) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => FullPdfViewerScreen(path)),
                                        );
                                      });

                                    }, icon: Icon(Icons.remove_red_eye,
                                      color: Colors.green,))
                                  ]
                                  )
                              )]);})

                  )]); }


                }),
          ],
        )

    )));
  }
}

class FullPdfViewerScreen extends StatelessWidget {
  final String pdfPath;

  FullPdfViewerScreen(this.pdfPath);

  @override
  Widget build(BuildContext context) {
    return PDFViewerScaffold(
        appBar: AppBar(
          title: Text("Document"),
        ),
        path: pdfPath);
  }
}
