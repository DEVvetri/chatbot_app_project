// ignore_for_file: must_be_immutable

import 'package:chatbot_app_project/chatBot_project/commons.dart';
import 'package:chatbot_app_project/chatBot_project/leaderboard_module/handlers/leaderboard_handler.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class LeaderBoardMainScreen extends StatelessWidget {
  LeaderboardHandler leaderboardHandler = Get.put(LeaderboardHandler());
  List<String> tabs = ['Weekly', 'All time'];
  LeaderBoardMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Commons().blueColor,
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 50,
              ),
              _buildAppBar(),
              _buildTabBar(context),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                spacing: 14,
                children: [
                  Column(
                    spacing: 10,
                    children: [
                      _buildBarData('Vetrivel', '200'),
                      _buildBarsWithHieght(120, '2'),
                    ],
                  ),
                  Column(
                    spacing: 10,
                    children: [
                      _buildBarData('Subitsha', '200'),
                      _buildBarsWithHieght(150, '1'),
                    ],
                  ),
                  Column(
                    spacing: 10,
                    children: [
                      _buildBarData('vetri maren', '200'),
                      _buildBarsWithHieght(100, '3'),
                    ],
                  ),
                ],
              )
            ],
          ),
          Positioned(
            bottom: 0,
            child: Container(
              height: Commons().getSizeOf(context, 'H') * 0.48,
              width: Commons().getSizeOf(context, 'H') * 0.459,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30))),
              child: _buildListingData(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        BackButton(),
        Text(
          "Leaderboard",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(
          width: 50,
        )
      ],
    );
  }

  Widget _buildTabBar(BuildContext context) {
    return Container(
      height: 40,
      width: Commons().getSizeOf(context, 'W') * 0.35,
      decoration: BoxDecoration(
          color: Colors.white54, borderRadius: BorderRadius.circular(50)),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          children: [
            Obx(
              () => Expanded(
                child: GestureDetector(
                  onTap: () => leaderboardHandler.tabToggler(tabs[0]),
                  child: Container(
                    decoration: BoxDecoration(
                        color: leaderboardHandler.selectedTab.value == tabs[0]
                            ? Colors.white
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(50)),
                    child: Center(
                      child: Text(
                        tabs[0],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: leaderboardHandler.selectedTab.value == tabs[0]
                              ? Colors.black
                              : Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Obx(() => Expanded(
                  child: GestureDetector(
                    onTap: () => leaderboardHandler.tabToggler(tabs[1]),
                    child: Container(
                      decoration: BoxDecoration(
                          color: leaderboardHandler.selectedTab.value == tabs[1]
                              ? Colors.white
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(50)),
                      child: Center(
                        child: Text(
                          tabs[1],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color:
                                leaderboardHandler.selectedTab.value == tabs[1]
                                    ? Colors.black
                                    : Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }

  Widget _buildBarsWithHieght(double barH, String position) {
    return Container(
      height: barH,
      width: 85,
      decoration: BoxDecoration(
          color: Colors.white54, borderRadius: BorderRadius.circular(15)),
      child: Center(
        child: Text(
          position,
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 25, color: Colors.black),
        ),
      ),
    );
  }

  Widget _buildBarData(String name, String points) {
    return Column(
      spacing: 2,
      children: [
        CircleAvatar(
          radius: 30,
        ),
        Text(
          name,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(50)),
          child: Padding(
            padding: const EdgeInsets.only(left: 5, right: 5),
            child: Text(
              '${points}pts',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildListingData() {
    return Expanded(
        child: ListView.separated(
      separatorBuilder: (context, index) {
        return Divider();
      },
      itemCount: 10,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text("Vetrivel"),
          subtitle: Text("150 pts"),
          leading: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 20,
            children: [Text((index + 1).toString()), CircleAvatar()],
          ),
          trailing: Icon(
            Icons.arrow_drop_up,
            size: 30,
            color: Colors.green,
          ),
        );
      },
    ));
  }
}
