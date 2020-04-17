import 'package:test_api/src/frontend/expect.dart';
import 'package:test_core/test_core.dart';
import 'package:test/test.dart';
import '../lib/Home.dart';
import '../lib/Global.dart' as global;

void main() {
  group("String", ()
  {
    Map<String, String> header;
    test('Check header for API query : accessToken = null', () {
      global.accessToken = null;
      header = getHeaders();
      expect(header["Authorization"], equals("Client-ID " + global.clientId));
    });
    test('Check header for API query : accessToken != null', () {
      global.accessToken = "AerRTDFZDSC23345DFaled";
      header = getHeaders();
      expect(header["Authorization"], equals("Bearer " + global.accessToken));
    });
  });
}