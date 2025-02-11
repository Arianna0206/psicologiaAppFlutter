import 'dart:async';
import 'package:flutter/material.dart';

class AnimatedTimer extends StatefulWidget {
  final int duration;
  final VoidCallback onFinish; 

  const AnimatedTimer({super.key, required this.duration, required this.onFinish});

  @override
  _AnimatedTimerState createState() => _AnimatedTimerState();
}

class _AnimatedTimerState extends State<AnimatedTimer> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  Timer? _timer;
  int countdown = 0;
  bool isRunning = false;

  @override
  void initState() {
    super.initState();
    countdown = widget.duration;

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.duration),
    );

    _controller.addListener(() {
      setState(() {});
    });
  }

  void startTimer() {
    if (isRunning) return;

    setState(() {
      isRunning = true;
      countdown = widget.duration;
    });

    _controller.reset();
    _controller.forward();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdown > 0) {
        setState(() {
          countdown--;
        });
      } else {
        stopTimer();
        widget.onFinish();
      }
    });
  }

  void stopTimer() {
    setState(() {
      isRunning = false;
    });
    _timer?.cancel();
    _controller.stop();
  }

  void resetTimer() {
    stopTimer();
    setState(() {
      countdown = widget.duration;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
                valueColor: AlwaysStoppedAnimation<Color>(getColorFromTime(countdown)),
              ),
            ),
            Text(
              "$countdown s",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),

        ElevatedButton(
          onPressed: isRunning ? stopTimer : startTimer,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
          ),
          child: Text(isRunning ? 'Detener' : 'Iniciar'),
        ),
      ],
    );
  }

  Color getColorFromTime(int time) {
    if (time >= 10) return Colors.green;
    if (time <= 10) return Colors.yellow;
    return Colors.red;
  }
}
