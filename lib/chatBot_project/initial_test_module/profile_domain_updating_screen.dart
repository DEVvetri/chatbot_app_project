import 'package:chatbot_app_project/chatBot_project/commons.dart';
import 'package:chatbot_app_project/chatBot_project/initial_test_module/controllers/domain_selection_handler.dart';
import 'package:chatbot_app_project/chatBot_project/initial_test_module/test_module/test_Screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DomainSelectionScreen extends StatelessWidget {
  final DomainSelectionController controller =
      Get.put(DomainSelectionController());
  final TextEditingController searchController = TextEditingController();

  DomainSelectionScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Commons().blueColor,
          title: const Text('Select Your Domains')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Select Your Primary Domain",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Obx(() => DropdownButtonFormField<String>(
                  value: controller.selectedDomain.value.isEmpty
                      ? null
                      : controller.selectedDomain.value,
                  items: controller.availableDomains.map((domain) {
                    return DropdownMenuItem<String>(
                      value: domain,
                      child: Text(domain),
                    );
                  }).toList(),
                  onChanged: (value) {
                    controller.selectedDomain.value = value!;
                  },
                  decoration:
                      const InputDecoration(border: OutlineInputBorder()),
                )),
            const Text("Select Your Level of hardness",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Obx(() => DropdownButtonFormField<String>(
                  value: controller.selectedLevel.value,
                  items: controller.levelList.map((domain) {
                    return DropdownMenuItem(
                      value: domain,
                      child: Text(domain),
                    );
                  }).toList(),
                  onChanged: (value) {
                    controller.selectedLevel.value = value!;
                  },
                  decoration:
                      const InputDecoration(border: OutlineInputBorder()),
                )),
            const SizedBox(height: 20),
            const Text("Select Your Interested Domains",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: "Search domains...",
                border: OutlineInputBorder(),
                prefixIcon: const Icon(Icons.search),
              ),
              onChanged: (query) {
                controller.filterDomains(query);
              },
            ),
            const SizedBox(height: 10),
            Obx(() => Wrap(
                  spacing: 5.0,
                  children: controller.interestedDomains.map((domain) {
                    return Chip(
                      backgroundColor: Commons().blueColor,
                      label: Text(domain),
                      deleteIcon: const Icon(Icons.close),
                      onDeleted: () => controller.removeInterest(domain),
                    );
                  }).toList(),
                )),
            const SizedBox(height: 10),
            searchController.text.isEmpty
                ? Expanded(
                    child: Obx(() => ListView(
                          children: controller.filteredDomains.map((domain) {
                            return ListTile(
                              title: Text(domain),
                              trailing: IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () => controller.addInterest(domain),
                              ),
                            );
                          }).toList(),
                        )),
                  )
                : SizedBox(),
          ],
        ),
      ),
      persistentFooterButtons: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              controller
                  .updateProfile(context)
                  .whenComplete(() => Get.to(() => TestScreen(
                        domain: controller.selectedDomain.value,
                        level: controller.selectedLevel.value,
                      )));
            },
            child: const Text("Save & Start Test"),
          ),
        )
      ],
    );
  }
}
