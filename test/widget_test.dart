import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:biblio_files/main.dart';
import 'package:google_sign_in_mocks/google_sign_in_mocks.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    final googleSignIn = MockGoogleSignIn();
    final signinAccount = await googleSignIn.signIn();
    final googleAuth = await signinAccount?.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    // Sign in.
    final userMap = MockUser(
      isAnonymous: false,
      uid: 'someuid',
      email: 'bob@somedomain.com',
      displayName: 'Bob',
    );
    final auth = MockFirebaseAuth(mockUser: userMap);
    await auth.signInWithCredential(credential);

    await tester.pumpWidget(const MyApp());
    expect(find.text('Initializing app...'), findsOneWidget);
  });
}
