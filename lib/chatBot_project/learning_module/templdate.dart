import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DemoTesting extends StatefulWidget {
  const DemoTesting({super.key});

  @override
  State<DemoTesting> createState() => _DemoTestingState();
}

class _DemoTestingState extends State<DemoTesting> {
  List<Map<String, dynamic>> domains = [
    {
      "domain": "Software Development",
      'title': 'softwaredevelopment',
      "description":
          "The process of designing, coding, testing, and maintaining software applications.",
      "pros": ["High demand", "Well-paid career", "Creative problem-solving"],
      "cons": [
        "Requires continuous learning",
        "Can be stressful",
        "Time-consuming debugging"
      ],
      "where_to_learn": ["https://docs.flutter.dev/"],
      "how_to_learn":
          "Start with programming basics like Python, Java, or JavaScript. Learn algorithms and data structures.",
      "topics": [
        "Programming Languages",
        "Software Architecture",
        "Testing and Debugging"
      ],
      "isCompleted": false
    },
    {
      "domain": "App Development",
      'title': 'appdevelopment',
      "description":
          "Creating mobile or web applications using various frameworks and programming languages.",
      "pros": [
        "Growing industry",
        "Opportunities in freelancing and employment"
      ],
      "cons": [
        "Requires multiple skills (UI/UX, backend, database)",
        "High competition"
      ],
      "where_to_learn": [
        "https://developer.android.com/",
        "https://docs.flutter.dev/"
      ],
      "how_to_learn":
          "Start with UI/UX design principles, then learn mobile frameworks like Flutter or Android.",
      "topics": ["UI/UX", "Mobile Frameworks", "Backend Integration"],
      "isCompleted": false
    },
    {
      "domain": "Web Development",
      'title': 'webdevelopment',
      "description": "Building and maintaining websites and web applications.",
      "pros": ["Highly accessible", "Variety of career paths"],
      "cons": [
        "Constantly changing technologies",
        "Can be overwhelming for beginners"
      ],
      "where_to_learn": ["https://developer.mozilla.org/en-US/docs/Learn"],
      "how_to_learn":
          "Learn HTML, CSS, and JavaScript first. Then explore frameworks like React, Angular, or Vue.",
      "topics": ["Front-end", "Back-end", "Full-stack"],
      "isCompleted": false
    },
    {
      "domain": "Data Science",
      'title': 'datascience',
      "description":
          "Extracting insights and knowledge from structured and unstructured data.",
      "pros": ["High-paying jobs", "Wide industry applications"],
      "cons": [
        "Requires strong mathematical background",
        "Data quality issues"
      ],
      "where_to_learn": [
        "https://python-data-science.readthedocs.io/en/latest/"
      ],
      "how_to_learn":
          "Start with Python, learn statistics, machine learning, and data visualization tools.",
      "topics": ["Machine Learning", "Data Analysis", "Big Data"],
      "isCompleted": false
    },
    {
      "domain": "Cybersecurity",
      'title': 'cybersecurity',
      "description":
          "Protecting networks, systems, and data from cyber threats.",
      "pros": ["High demand", "Job security", "Ethical hacking opportunities"],
      "cons": ["Constantly evolving threats", "High-stress job"],
      "where_to_learn": ["https://www.cybersecurityguide.org/"],
      "how_to_learn":
          "Learn networking fundamentals, ethical hacking, and security principles.",
      "topics": ["Network Security", "Penetration Testing", "Encryption"],
      "isCompleted": false
    },
    {
      "domain": "Artificial Intelligence",
      'title': 'artificialintelligence',
      "description":
          "Developing systems that can perform tasks that typically require human intelligence.",
      "pros": ["Future-proof career", "Solves complex problems"],
      "cons": ["Requires deep technical expertise", "Ethical concerns"],
      "where_to_learn": ["https://cloud.google.com/document-ai/docs"],
      "how_to_learn":
          "Learn Python, deep learning, and AI frameworks like TensorFlow and PyTorch.",
      "topics": [
        "Machine Learning",
        "Neural Networks",
        "Natural Language Processing"
      ],
      "isCompleted": false
    },
    {
      "domain": "DevOps",
      'title': 'devops',
      "description":
          "A set of practices that combines software development and IT operations.",
      "pros": ["Automates workflows", "Improves software deployment speed"],
      "cons": [
        "Requires broad skillset",
        "Challenging to implement in legacy systems"
      ],
      "where_to_learn": ["https://aws.amazon.com/devops/what-is-devops/"],
      "how_to_learn":
          "Learn CI/CD, cloud computing, and infrastructure as code tools.",
      "topics": [
        "Continuous Integration",
        "Containerization",
        "Infrastructure as Code"
      ],
      "isCompleted": false
    },
    {
      "domain": "Flutter",
      'title': 'flutter',
      "description":
          "An open-source UI toolkit for building natively compiled applications for mobile, web, and desktop from a single codebase.",
      "pros": ["Fast development", "Cross-platform support"],
      "cons": [
        "Limited third-party libraries",
        "New framework with fewer experienced developers"
      ],
      "where_to_learn": ["https://docs.flutter.dev/"],
      "how_to_learn":
          "Start with Dart, explore Flutter widgets, and build sample apps.",
      "topics": ["Dart Programming", "Flutter Widgets", "State Management"],
      "isCompleted": false
    },
    {
      "domain": "React",
      'title': 'react',
      "description": "A JavaScript library for building user interfaces.",
      "pros": ["Component-based architecture", "Large community support"],
      "cons": ["Fast-changing ecosystem", "Requires understanding of JSX"],
      "where_to_learn": ["https://react.dev/"],
      "how_to_learn":
          "Learn JavaScript, then move on to React concepts like components and hooks.",
      "topics": ["JSX", "React Components", "State Management"],
      "isCompleted": false
    },
    {
      "domain": "Angular",
      'title': 'angular',
      "description":
          "A TypeScript-based framework for building web applications.",
      "pros": ["Strong structure", "Enterprise-ready"],
      "cons": ["Steep learning curve", "Heavy framework"],
      "where_to_learn": ["https://angular.io/"],
      "how_to_learn":
          "Learn TypeScript, then dive into Angular modules, components, and services.",
      "topics": ["TypeScript", "Angular Components", "Directives"],
      "isCompleted": false
    },
    {
      "domain": "Vue",
      'title': 'vue',
      "description":
          "A progressive JavaScript framework for building user interfaces.",
      "pros": ["Easy to learn", "Lightweight framework"],
      "cons": ["Smaller ecosystem than React", "Limited enterprise adoption"],
      "where_to_learn": ["https://vuejs.org/"],
      "how_to_learn":
          "Learn JavaScript, then explore Vue directives and state management.",
      "topics": ["Vue Directives", "Vue Components", "Vuex"],
      "isCompleted": false
    },
    {
      "domain": "Blockchain",
      'title': 'blockchain',
      "description":
          "A decentralized digital ledger that records transactions across multiple computers securely.",
      "pros": ["High security", "Decentralized technology"],
      "cons": ["Scalability issues", "Energy consumption"],
      "where_to_learn": ["https://www.ibm.com/topics/what-is-blockchain"],
      "how_to_learn":
          "Understand cryptography, smart contracts, and blockchain consensus mechanisms.",
      "topics": ["Cryptography", "Smart Contracts", "Consensus Mechanisms"],
      "isCompleted": false
    },
    {
      "domain": "IoT (Internet of Things)",
      'title': 'iot',
      "description":
          "A network of interconnected devices that communicate and share data.",
      "pros": ["Automation", "Improves efficiency"],
      "cons": ["Security risks", "Compatibility challenges"],
      "where_to_learn": ["https://learn.microsoft.com/en-us/azure/iot/"],
      "how_to_learn": "Learn about sensors, networking, and IoT protocols.",
      "topics": ["IoT Sensors", "Edge Computing", "Cloud Integration"],
      "isCompleted": false
    }
  ];

  Future<void> addData() async {
    for (var domain in domains) {
      FirebaseFirestore.instance.collection("domain-details").add(domain);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: ElevatedButton(
              onPressed: () {
                addData();
              },
              child: Text("add")),
        ));
  }
}
