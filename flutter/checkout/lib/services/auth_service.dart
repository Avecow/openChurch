import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  // FirebaseAuth 인스턴스를 클래스 내부에 생성
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // 회원가입 메소드
  Future<User?> signUp(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return result.user;
    } on FirebaseAuthException catch (e) {
      print('회원가입 실패: ${e.message}');
      return null;
    }
  }

  // 로그인 메소드
  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return result.user;
    } on FirebaseAuthException catch (e) {
      print('로그인 실패: ${e.message}');
      return null;
    }
  }

  // 로그아웃 메소드
  Future<void> signOut() async {
    await _auth.signOut();
  }
}

