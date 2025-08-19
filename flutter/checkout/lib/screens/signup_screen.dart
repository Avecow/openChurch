// lib/screens/signup_screen.dart

import 'package:flutter/material.dart';
import 'package:checkout/services/auth_service.dart'; // AuthService 가져오기
import 'package:firebase_auth/firebase_auth.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  // AuthService 인스턴스
  final AuthService _authService = AuthService();

  // 입력을 위한 컨트롤러
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // _SignUpScreenState 클래스 내부에 _handleSignUp 메서드를 아래와 같이 작성합니다.
 // User 타입 사용을 위해

void _handleSignUp() async {
  // 1. 비밀번호 일치 여부 확인
  if (_passwordController.text != _confirmPasswordController.text) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('비밀번호가 일치하지 않습니다.')),
    );
    return; // 함수 종료
  }

  // 2. AuthService를 통해 회원가입 시도
  final User? user = await _authService.signUp(
    _emailController.text.trim(), // trim()으로 공백 제거
    _passwordController.text.trim(),
  );

  // 3. 결과 처리
  if (user != null) {
    // 회원가입 성공!
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('회원가입에 성공했습니다!')),
    );
    // 현재 화면을 닫고 이전 화면(로그인 화면)으로 돌아가기
    Navigator.of(context).pop();
  } else {
    // 회원가입 실패 (AuthService에서 출력된 에러 외에 UI 피드백)
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('회원가입에 실패했습니다. 이메일 형식을 확인하거나 다른 이메일을 사용해보세요.')),
    );
  }
}

  // 메모리 누수 방지를 위해 컨트롤러 정리
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('회원가입'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: '이메일'),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: '비밀번호'),
              obscureText: true, // 비밀번호 가리기
            ),
            TextField(
              controller: _confirmPasswordController,
              decoration: const InputDecoration(labelText: '비밀번호 확인'),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _handleSignUp, // 회원가입 로직 연결
              child: const Text('가입하기'),
            ),
          ],
        ),
      ),
    );
  }
}