import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {

  // dummy
  final List<String> _students = ['김하은', '이준서', '박서연', '최민준', '정지우', '윤채원'];
  
  // 출석 상태 저장 Map
  final Map<String, String> _attendanceStatus = {};

  Future<void> _saveAttendance() async {
    // Firestore의 'attendance' 컬렉션에 접근
    final collection = FirebaseFirestore.instance.collection('attendance');
    final today = DateTime.now().toIso8601String().substring(0, 10);

    // 학생별 출석 데이터를 Firestore 문서로 하나씩 만들기
    for (final studentName in _students) {
      // 학생의 출석 상태 가져오기 (체크 안했으면 '미입력')
      final status = _attendanceStatus[studentName] ?? '미입력';

      // Firestore에 데이터 추가
      await collection.add({
        'date': today,
        'student_name': studentName,
        'status': status,
        'timestamp': FieldValue.serverTimestamp(),
      });
    }
    
    // 저장 완료 후 확인 메시지 출력
    if (mounted) { // 위젯이 화면에 있을 때만
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('출석 정보가 저장되었습니다.'))
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${DateTime.now().month}월 ${DateTime.now().day}일 출석'),
        actions: [
          IconButton(icon: const Icon(Icons.save),
          onPressed: () {
            //저장 로직
            _saveAttendance();
          },),
        ],
      ),
      body: ListView.builder(
        itemCount: _students.length,
        itemBuilder: (context, index) {
          final studentName = _students[index];
          return Card ( // 각 항목을 카드로 감싸기
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: ListTile(
              title: Text(studentName, style: const TextStyle(fontSize: 18)),
              trailing: Wrap(
                spacing: 8.0,
                children: <Widget>[
                  ChoiceChip(
                    label: const Text('출석'), 
                    selected: _attendanceStatus[studentName] == '출석',
                    selectedColor: Colors.blue.shade100,
                    onSelected: (selected) {
                      // '출석'을 선택했을 때 상태 변경
                      setState(() {
                        if (selected) {
                          _attendanceStatus[studentName] = '출석';
                        }
                      });
                    },
                    ),
                    ChoiceChip(
                      label: const Text('결석'), 
                      selected: _attendanceStatus[studentName] == '결석',
                      selectedColor: Colors.red.shade100,
                      onSelected: (selected) {
                        if (selected) {
                          _attendanceStatus[studentName] = '결석';
                        }
                      },
                      )
                ],
              ),
            ),
          );
        },
      )
    );
  }
}