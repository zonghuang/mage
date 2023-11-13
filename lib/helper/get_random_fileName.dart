import 'dart:math';

String getRandomFileName() {
  const chars =
      'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
  var string = '';
  var rand = Random();
  for (var i = 0; i < 10; i++) {
    var randomPoz = rand.nextInt(chars.length);
    string += chars.substring(randomPoz, randomPoz + 1);
  }

  var time = DateTime.now().millisecondsSinceEpoch;
  return '$string${time.toString().substring(time.toString().length - 8)}.png';
}
