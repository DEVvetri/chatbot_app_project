// ignore_for_file: must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class LinkPageScreen extends StatefulWidget {
  String domain;
  LinkPageScreen({super.key, required this.domain});

  @override
  State<LinkPageScreen> createState() => _LinkPageScreenState();
}

class _LinkPageScreenState extends State<LinkPageScreen> {
  List<Map<String, dynamic>> linksList = [
    {
      "domain": "software development",
      "links": ["https://docs.flutter.dev/"]
    }, //yes
    {
      "domain": "appdevelopment",
      "links": ["https://developer.android.com/"]
    }, //yes
    {
      "domain": "webdevelopment",
      "links": ["https://developer.mozilla.org/en-US/docs/Learn"]
    }, //yes
    {
      "domain": "datascience",
      "links": ["https://python-data-science.readthedocs.io/en/latest/"]
    }, //yes
    {
      "domain": "cybersecurity",
      "links": ["https://www.cybersecurityguide.org/"]
    }, //yes
    {
      "domain": "artificialintelligence",
      "links": ["https://cloud.google.com/document-ai/docs"]
    }, //yes
    {
      "domain": "devops",
      "links": ["https://aws.amazon.com/devops/what-is-devops/"]
    }, //yes
    {
      "domain": "flutter",
      "links": ["https://docs.flutter.dev/"]
    }, //yes
    {
      "domain": "react",
      "links": [
        "https://react.dev/",
      ]
    }, //yes
    {
      "domain": "angular",
      "links": ["https://angular.io/"]
    }, //yes
    {
      "domain": "vue",
      "links": ["https://vuejs.org/"]
    }, //yes
    {
      "domain": "blockchain",
      "links": ["https://www.ibm.com/topics/what-is-blockchain"]
    }, //yes
    {
      "domain": "iot",
      "links": ["https://learn.microsoft.com/en-us/azure/iot/"]
    }, //yes
  ];

  Map<dynamic, dynamic> gettedDomain = {"domain": "", 'links': []};

  @override
  void initState() {
    super.initState();

    for (var i = 0; i < linksList.length; i++) {
      if (linksList[i]['domain'] == widget.domain.toLowerCase()) {
        setState(() {
          gettedDomain['domain'] = linksList[i]['domain'];
          gettedDomain['links'] = linksList[i]['links'];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          title: Text("links for ${gettedDomain['domain']}"),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.blueAccent,
                Colors.grey[50]!,
              ],
              stops: const [0.0, 1.0],
            ),
          ),
          child: ListView.builder(
            itemCount: gettedDomain['links'].length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: OutlineButtonFb1(
                  text: gettedDomain['links'][index],
                  index: (index + 1).toString(),
                ),
              );
            },
          ),
        ));
  }
}

class OutlineButtonFb1 extends StatelessWidget {
  final String text;
  final String index;
  const OutlineButtonFb1({required this.text, required this.index, super.key});
  void copyToClipboard(String text, BuildContext context) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Copied to clipboard: $text"),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xff2749FD);

    const double borderRadius = 40;

    return OutlinedButton(
      onPressed: () {
        copyToClipboard(text, context);
      },
      style: ButtonStyle(
          side: WidgetStateProperty.all(
              BorderSide(color: primaryColor, width: 1.4)),
          padding: WidgetStateProperty.all(
              EdgeInsets.only(top: 10, bottom: 10, right: 30, left: 20)),
          shape: WidgetStateProperty.all(RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(borderRadius))))),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Container(
          width: 35,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(100)),
          child: Center(
            child: Text(
              overflow: TextOverflow.ellipsis,
              index,
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: primaryColor),
            ),
          ),
        ),
        SizedBox(
          width: 200,
          child: Text(
            overflow: TextOverflow.ellipsis,
            text,
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        Icon(Icons.copy, color: primaryColor)
      ]),
    );
  }
}

class DomainViewScreen extends StatelessWidget {
  final String domain; // Passed domain name

  const DomainViewScreen({super.key, required this.domain});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(domain),
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blueAccent,
              Colors.grey[50]!,
            ],
            stops: const [0.0, 1.0],
          ),
        ),
        child: FutureBuilder<QuerySnapshot>(
          future: FirebaseFirestore.instance
              .collection("domain-details")
              .where("title",
                  isEqualTo: domain
                      .toLowerCase()) // Query Firestore for matching title
              .get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text("Domain not found"));
            }

            var data = snapshot.data!.docs.first.data() as Map<String, dynamic>;

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  Text("Domain:",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text(data["domain"], style: TextStyle(fontSize: 16)),
                  Text("Description:",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text(data["description"], style: TextStyle(fontSize: 16)),
                  SizedBox(height: 16),
                  Text("Pros:",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ...data["pros"]
                      .map<Widget>(
                          (p) => Text("• $p", style: TextStyle(fontSize: 16)))
                      .toList(),
                  SizedBox(height: 16),
                  Text("Cons:",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ...data["cons"]
                      .map<Widget>(
                          (c) => Text("• $c", style: TextStyle(fontSize: 16)))
                      .toList(),
                  SizedBox(height: 16),
                  Text("Where to Learn:",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ...data["where_to_learn"]
                      .map<Widget>((url) => GestureDetector(
                            onTap: () => launchUrl(Uri.parse(url)),
                            child: Text(url,
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.blue,
                                    decoration: TextDecoration.underline)),
                          ))
                      .toList(),
                  SizedBox(height: 16),
                  Text("How to Learn:",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text(data["how_to_learn"], style: TextStyle(fontSize: 16)),
                  SizedBox(height: 16),
                  Text("Topics Covered:",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ...data["topics"]
                      .map<Widget>((topic) =>
                          Text("• $topic", style: TextStyle(fontSize: 16)))
                      .toList(),
                  SizedBox(height: 16),
                  Text("Completed:",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text(data["isCompleted"] ? "✅ Yes" : "❌ No",
                      style: TextStyle(fontSize: 16)),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void launchUrl(Uri url) async {
    if (await canLaunchUrl(url)) {
      await launchUrlString(url.path);
    } else {
      throw 'Could not launch $url';
    }
  }
}
