// ignore_for_file: deprecated_member_use, unused_element, file_names, must_be_immutable

import 'package:chatbot_app_project/chatBot_project/learning_module/timeLine_event.dart';
import 'package:chatbot_app_project/chatBot_project/learning_module/timeLine_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TimelineScreen extends StatefulWidget {
  DocumentSnapshot docId;
  TimelineScreen({super.key, required this.docId});

  @override
  State<TimelineScreen> createState() => _TimelineScreenState();
}

class _TimelineScreenState extends State<TimelineScreen>
    with SingleTickerProviderStateMixin {
  List<TimelineEvent> events = [];
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  final double _progress = 0.6; // Example progress value
  List<Map<String, String>> linksList = [
    {
      "domain": "software development",
      "link": "https://docs.flutter.dev/"
    }, //yes
    {
      "domain": "app development",
      "link": "https://developer.android.com/"
    }, //yes
    {
      "domain": "web development",
      "link": "https://developer.mozilla.org/en-US/docs/Learn"
    }, //yes
    {
      "domain": "data science",
      "link": "https://python-data-science.readthedocs.io/en/latest/"
    }, //yes
    {
      "domain": "cyber security",
      "link": "https://www.cybersecurityguide.org/"
    }, //yes
    {
      "domain": "artificial intelligence",
      "link": "https://cloud.google.com/document-ai/docs"
    }, //yes
    {
      "domain": "devops",
      "link": "https://aws.amazon.com/devops/what-is-devops/"
    }, //yes
    {"domain": "flutter", "link": "https://docs.flutter.dev/"}, //yes
    {"domain": "react", "link": "https://react.dev/"}, //yes
    {"domain": "angular", "link": "https://angular.io/"}, //yes
    {"domain": "vue", "link": "https://vuejs.org/"}, //yes
    {
      "domain": "blockchain",
      "link": "https://www.ibm.com/topics/what-is-blockchain"
    }, //yes
    {
      "domain": "iot",
      "link": "https://learn.microsoft.com/en-us/azure/iot/"
    }, //yes
  ];

  List iconslist = [
    Icons.design_services,
    Icons.code,
    Icons.code,
    Icons.verified_user,
    Icons.rocket_launch,
  ];
  List colorslist = [
    Color(0xFF43A047),
    Color.fromARGB(255, 31, 83, 162),
    Color(0xFF7B1FA2),
    Color(0xFFD81B60),
    Color(0xFFFF7043),
  ];
  late Timestamp gettime;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    setState(() {
      gettime = widget.docId.get('created_on');
    });
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );

    _fadeController.forward();
    addEventstoList();
  }

  addEventstoList() {
    try {
      List listWorks = widget.docId.get('list_of_works');

      for (var i = 0; i < listWorks.length; i++) {
        Map<dynamic, dynamic> work = listWorks[i];

        events.add(
          TimelineEvent(
            title: work['topic'],
            subtitle: work['subtopics'],
            description:
                'Coordinated deployment across all platforms, monitoring system health, and implementing feedback loops for continuous improvement.',
            icon: iconslist[i],
            color: colorslist[i],
            completionDate: DateTime(2024, 6, 15),
            status: 'Upcoming',
          ),
        );
      }
      // print(events.length);
    } catch (e) {
      print("error: $e");
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(),
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
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SafeArea(
            child: Column(
              children: [
                _buildProjectHeader(),
                _buildProgressSection(),
                const SizedBox(height: 16),
                events.isNotEmpty
                    ? Expanded(
                        child: TimelineWidget(
                          events: events,
                          domain: widget.docId.get("title"),
                        ),
                      )
                    : SizedBox()
              ],
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.filter_list, color: Colors.black87),
          onPressed: () => _showFilterDialog(),
        ),
        IconButton(
          icon: const Icon(Icons.info_outline, color: Colors.black87),
          onPressed: () => _showInfoDialog(),
        ),
      ],
      title: const Text(
        'Learning Timeline',
        style: TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.w600,
          fontSize: 20,
        ),
      ),
      centerTitle: false,
    );
  }

  Widget _buildProjectHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  //'title learning',
                  widget.docId.get('title'),
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Started: ${gettime.toDate().toString().split(' ')[0]}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.black54, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          _buildStatusChip('On Track', Colors.green),
        ],
      ),
    );
  }

  Widget _buildProgressSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Overall Progress',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
              Text(
                '${(_progress * 100).toInt()}%',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).canvasColor,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: _progress),
              duration: const Duration(milliseconds: 1000),
              builder: (context, value, child) {
                return LinearProgressIndicator(
                  value: value,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).primaryColor,
                  ),
                  minHeight: 8,
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildProgressStat('Completed', '2/5', Colors.greenAccent),
              _buildProgressStat('In Progress', '1/5', Colors.orange),
              _buildProgressStat('Upcoming', '2/5', Colors.blue),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.black54,
              ),
        ),
      ],
    );
  }

  Widget _buildStatusChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.9)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.check_circle,
            size: 16,
            color: Colors.white,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Filter Timeline',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 20),
            _buildFilterOption('All Milestones', true),
            _buildFilterOption('Completed', false),
            _buildFilterOption('In Progress', false),
            _buildFilterOption('Upcoming', false),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterOption(String label, bool selected) {
    return ListTile(
      title: Text(label),
      leading: Icon(
        selected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
        color: Theme.of(context).primaryColor,
      ),
      onTap: () {
        Navigator.pop(context);
        // Implement filter logic
      },
    );
  }

  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              Icons.timeline,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(width: 8),
            const Text('Learning Timeline'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'This timeline shows the key milestones and progress of our project. '
              'Each stage can be expanded to view more details about the activities '
              'and deliverables.',
            ),
            const SizedBox(height: 16),
            _buildInfoItem(
              Icons.touch_app,
              'Tap any milestone to see detailed information',
            ),
            _buildInfoItem(
              Icons.calendar_today,
              'Track progress and upcoming deadlines',
            ),
            _buildInfoItem(
              Icons.update,
              'Real-time status updates for each phase',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, IconData icon, {int maxLines = 1}) {
    return TextField(
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
    );
  }
}
