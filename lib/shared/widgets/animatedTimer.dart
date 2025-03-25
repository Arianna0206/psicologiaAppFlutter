import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AnimatedTimer extends StatefulWidget {
  final int duration;
  final String categoryId;
  final String methodId;
  final int exerciseIndex;
  final VoidCallback onFinish;

  const AnimatedTimer({
    super.key,
    required this.duration,
    required this.categoryId,
    required this.methodId,
    required this.exerciseIndex,
    required this.onFinish,
  });

  @override
  _AnimatedTimerState createState() => _AnimatedTimerState();
}

class _AnimatedTimerState extends State<AnimatedTimer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  Timer? _timer;
  int timeLeft = 0;
  bool isRunning = false;
  bool isPaused = false;
  int attemptCount = 0;
  String userId = FirebaseAuth.instance.currentUser?.uid ?? "";

  @override
  void initState() {
    super.initState();
    timeLeft = widget.duration;

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.duration),
    );

    _controller.addListener(() {
      setState(() {});
    });

    _loadAttemptCount();
  }

  Future<void> _loadAttemptCount() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("completed_exercises")
        .doc("exercise_${widget.exerciseIndex}")
        .get();

    if (doc.exists && doc.data() != null && mounted) {
      setState(() {
        attemptCount = (doc["attempts"] ?? 0);
      });
    }
  }

  void startTimer() {
    if (isRunning) return;

    setState(() {
      isRunning = true;
      isPaused = false;
    });

    _controller.duration = Duration(seconds: timeLeft);
    _controller.forward(from: 1 - (timeLeft / widget.duration));

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timeLeft > 0) {
        setState(() {
          timeLeft--;
        });
      } else {
        stopTimer();
        _incrementAttempt();
        widget.onFinish();
      }
    });
  }

  void stopTimer() {
    if (!isRunning) return;

    setState(() {
      isRunning = false;
      isPaused = true;
    });

    _timer?.cancel();
    _controller.stop();
  }

  void resetTimer() {
    stopTimer();
    setState(() {
      timeLeft = widget.duration;
      isPaused = false;
    });
    _controller.reset();
    _incrementAttempt();
  }

  void _incrementAttempt() async {
    setState(() {
      attemptCount++;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.removeListener(() {});
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: resetTimer,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFBC57B8),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          ),
          child: const Text(
            'Reiniciar',
            style: TextStyle(color: Colors.white),
          ),
        ),

        const SizedBox(height: 15),

        // Text(
        //   "Intentos: $attemptCount",
        //   style: const TextStyle(
        //     fontSize: 16,
        //     fontWeight: FontWeight.bold,
        //     color: Colors.white,
        //   ),
        // ),

        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 70,
              height: 70,
              child: CircularProgressIndicator(
                value: _controller.value,
                strokeWidth: 8,
                backgroundColor: Colors.white,
                valueColor:
                    AlwaysStoppedAnimation<Color>(getColorFromTime(timeLeft)),
              ),
            ),
            Text(
              "$timeLeft s",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),

        const SizedBox(height: 15),

        ElevatedButton(
          onPressed: isRunning ? stopTimer : startTimer,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
          ),
          child: Text(
              isRunning ? 'Detener' : (isPaused ? 'Continuar' : 'Iniciar')),
        ),
      ],
    );
  }

  Color getColorFromTime(int time) {
    if (time >= 10) return Colors.green;
    if (time >= 5) return Colors.yellow;
    return Colors.red;
  }
}
