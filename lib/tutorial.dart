import 'package:flutter/material.dart';
import 'utility/local.dart';
import 'package:video_player/video_player.dart';

//TODO - Implement the instructions/instructional videos

///Tutorial page - This is where the user can find instructions on how to work
///the model they have been assigned
class Tutorial extends StatefulWidget {
  const Tutorial({Key? key}) : super(key: key);

  @override
  State<Tutorial> createState() => _TutorialState();
}

class _TutorialState extends State<Tutorial> {
  String? _obj;
  late VideoPlayerController _controller;
  late Future<void> _initialiseVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    getObject().then((value) {
      setState((){
        _obj = value;
      });
    });

    //TODO - Once we have them, add the files to the project, then add correct file to controller and do the required things
    switch(_obj){
      case "Cube":
        break;
      case "Card":
        break;
      case "Pendant":
        break;
      default:
        break;
    }
  }

  //TODO - Override dispose to ensure video player closed

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Help"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          getEnumObject(_obj!) == Objects.cube ?
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("Cube", style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.5)),
                const Text("This model is built to replicate a die, leaning in to the idea of authentication objects being multi-use. To authenticate, touch the correct four sides to the screen in the correct order, the press the button to authenticate."),
                const Text("\n The combination set for this objects requires the sequence: 4 -> 1 -> 4 -> 2. When touching the screen with the object, ensure that the face of the object is completely within the outlined box and that you are touching any of the black dots on any of the sides."),
                /* //TODO - Uncomment this when video stuff set up
                FutureBuilder(
                  future: _initialiseVideoPlayerFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      // If the VideoPlayerController has finished initialization, use
                      // the data it provides to limit the aspect ratio of the video.
                      return AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        // Use the VideoPlayer widget to display the video.
                        child: VideoPlayer(_controller),
                      );
                    } else {
                      // If the VideoPlayerController is still initializing, show a
                      // loading spinner.
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                )
                 */
              ]
            ) : const SizedBox(height:0),
          getEnumObject(_obj!) == Objects.pendant ?
            const Text("Here will be instructions for the pendant") : const SizedBox(height:0),
          getEnumObject(_obj!) == Objects.card ?
            const Text("Here will be instructions for the card") : const SizedBox(height:0),
        ]
      )
    );
  }
}
