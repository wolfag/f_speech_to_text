import 'package:avatar_glow/avatar_glow.dart';
import 'package:clipboard/clipboard.dart';
import 'package:f_speech_to_text/api/speech_api.dart';
import 'package:f_speech_to_text/main.dart';
import 'package:f_speech_to_text/utils.dart';
import 'package:f_speech_to_text/widget/substring_highlighted.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String text = 'Press the button and start speaking';
  bool isListening = false;

  Future toggleRecording() {
    setState(() {
      text = '';
    });
    return SpeechApi.toggleRecording(
      onResult: (text) {
        setState(() {
          this.text = text;
        });
      },
      onListening: (isListening) {
        setState(() {
          this.isListening = isListening;

          if (!isListening) {
            Future.delayed(const Duration(seconds: 1), () {
              Utils.scanText(text);
            });
          }
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(MyApp.title),
        centerTitle: true,
        actions: [
          Builder(builder: (context) {
            return IconButton(
              onPressed: () async {
                await FlutterClipboard.copy(text);

                Scaffold.of(context).showSnackBar(
                  const SnackBar(content: Text(' Copied to Clipboard')),
                );
              },
              icon: const Icon(Icons.content_copy),
            );
          })
        ],
      ),
      body: SingleChildScrollView(
        reverse: true,
        padding: const EdgeInsets.all(30).copyWith(bottom: 150),
        child: SingleChildScrollView(
          reverse: true,
          padding: const EdgeInsets.all(30).copyWith(bottom: 150),
          child: SubstringHighlight(
            terms: Command.all,
            text: text,
            textStyle: const TextStyle(
              fontSize: 32,
              color: Colors.black,
              fontWeight: FontWeight.w400,
            ),
            textStyleHighlight: const TextStyle(
              fontSize: 32,
              color: Colors.red,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        animate: isListening,
        endRadius: 75,
        glowColor: Theme.of(context).primaryColor,
        child: FloatingActionButton(
          onPressed: toggleRecording,
          child: Icon(
            isListening ? Icons.mic : Icons.mic_none,
            size: 36,
          ),
        ),
      ),
    );
  }
}
