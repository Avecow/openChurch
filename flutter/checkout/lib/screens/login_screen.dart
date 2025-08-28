import 'package:flutter/material.dart';
import 'package:checkout/services/auth_service.dart';
import 'package:checkout/screens/attendance_screen.dart';
import 'package:checkout/screens/signup_screen.dart';

class LoginScreen extends StatelessWidget {
  // AuthService 인스턴스 생성
  final AuthService _authService = AuthService();

  // 이메일, 비밀번호 입력을 위한 컨트롤러 
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding:  EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: '이메일'),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: '비밀번호'),
            ),
            const SizedBox(height: 20,),
            ElevatedButton(
              onPressed: () async{
                // 로그인 버튼 클릭 시 signIn 메소드 호출
                String email = _emailController.text;
                String password = _passwordController.text;

                final user = await _authService.signIn(email, password);

                if (user != null) {
                  // 로그인 성공 시 출석체크 화면으로 이동
                  Navigator.pushReplacement(
                    context, 
                    MaterialPageRoute(builder: (context) => AttendanceScreen()),);
                } else {
                  // 로그인 실패 시 알림 
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('로그인에 실패했습니다.')),
                  );
                }
              }, 
              child: const Text('로그인'),
              
              
              ),
              TextButton(
  onPressed: () {
    // SignUpScreen으로 이동
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SignUpScreen()),
    );
  },
  child: const Text('아직 계정이 없으신가요? 회원가입'),
),
              
          ],),
      ),
    );
    
  }
}