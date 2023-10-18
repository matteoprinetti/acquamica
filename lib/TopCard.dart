import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Quiz.dart';

class TopCard extends StatelessWidget {
  const TopCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
         /*   const ListTile(
              leading: Icon(Icons.album),
              title: Text('The Enchanted Nightingale'),
              subtitle: Text('Music by Julie Gable. Lyrics by Sidney Stein.'),
            ),*/
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                TextButton(
                  child: const Icon(Icons.question_mark),
                  onPressed: () { showQuiz(context);},
                ),
                const Text("Quiz e video"),
                TextButton(
                  child: const Icon(Icons.local_movies),
                  onPressed: () { showVideo(context);},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
