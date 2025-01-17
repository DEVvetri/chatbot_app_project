import 'package:chatbot_app_project/chatBot_project/commons.dart';
import 'package:chatbot_app_project/chatBot_project/games_modules/learning_games/learning_game.dart';
import 'package:chatbot_app_project/chatBot_project/games_modules/problem_solving_games/problem_solving_game.dart';
import 'package:flutter/material.dart';
class GamesListingScreen extends StatefulWidget {
  const GamesListingScreen({super.key});

  @override
  State<GamesListingScreen> createState() => _GamesListingScreenState();
}

class _GamesListingScreenState extends State<GamesListingScreen> {
  @override
  Widget build(BuildContext context) {
   return Scaffold(
      backgroundColor: Commons().black1Color,
      appBar: AppBar(
        backgroundColor: Colors.black38,
        leading: BackButton(
          color: Colors.white,
        ),
        title: Text(
          "Games World",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Maths Games',
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
              ),
            ),
            _buildGamesBox1(
              context,
              'assets/images/think.png',
              'assets/images/playbutton.png',
              'Maths Games',
              () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AdaptiveGameScreen(),
                  )),
            ),
            Text(
              'Adaptive Games',
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
              ),
            ),
            _buildGamesBox1(
                context,
                'assets/images/games2.png',
                'assets/images/playbutton.png',
                'Adaptive Games',
                () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SimulationGameScreen(),
                    )))
          ],
        ),
      ),
    );
  }

  Widget _buildGamesBox1(BuildContext context, String image, String play,
      String text, GestureTapCallback onTap) {
    return Stack(
      // mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: 200,
            width: MediaQuery.of(context).size.width - 50,
            child: text == "Maths Games" ? Icon3DFb5() : Icon3DFb4(),
          ),
        ),
        Positioned(
          right: 0,
          bottom: -70,
          child: GestureDetector(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 180,
                width: 180,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(play), fit: BoxFit.fill)),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class Icon3DFb5 extends StatelessWidget {
  const Icon3DFb5({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.network(
      "https://firebasestorage.googleapis.com/v0/b/flutterbricks-public.appspot.com/o/3d%20icons%2Fcalculator-dynamic-color.png?alt=media&token=02b5ac45-619c-4d8b-9884-dfd479313110",
      fit: BoxFit.fill,
    );
  }
}

class Icon3DFb4 extends StatelessWidget {
  const Icon3DFb4({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.network(
      "https://firebasestorage.googleapis.com/v0/b/flutterbricks-public.appspot.com/o/3d%20icons%2Fbulb-dynamic-color.png?alt=media&token=6fe7b51a-7267-43cb-9810-76936fb121f5",
      fit: BoxFit.fill,
    );
  }
}
