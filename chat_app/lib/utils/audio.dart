import 'package:audioplayers/audioplayers.dart';

final player = AudioPlayer();

void playTapSound() async {
  await player.play(AssetSource('sounds/screen-tap.mp3'));
}
void playMessageSound() async {
  await player.play(AssetSource('sounds/new-message.mp3'));
}
