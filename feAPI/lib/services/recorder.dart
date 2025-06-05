import 'dart:html';
import 'dart:js_util' as js_util;

Future<void> startRecording() async {
  js_util.callMethod(js_util.globalThis, 'startRecording', []);
}

Future<void> stopRecordingAndSend() async {
  // Nếu stopRecording trả Promise JS
  final base64Audio = await js_util.promiseToFuture(
    js_util.callMethod(js_util.globalThis, 'stopRecording', []),
  );

  final response = await HttpRequest.request(
    'http://localhost:5000/transcribe',
    method: 'POST',
    sendData: 'audio_base64=$base64Audio',
    requestHeaders: {
      'Content-Type': 'application/x-www-form-urlencoded',
    },
  );

  print('Whisper response: ${response.responseText}');
}
