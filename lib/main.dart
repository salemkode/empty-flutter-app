import 'package:flutter/material.dart';

void main() {
  runApp(const TasbeehApp());
}

class TasbeehApp extends StatelessWidget {
  const TasbeehApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Force RTL for Arabic layout
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'مسبحة',
      home: const Directionality(
        textDirection: TextDirection.rtl,
        child: TasbeehHome(),
      ),
    );
  }
}

class TasbeehHome extends StatefulWidget {
  const TasbeehHome({super.key});

  @override
  State<TasbeehHome> createState() => _TasbeehHomeState();
}

class _TasbeehHomeState extends State<TasbeehHome>
    with SingleTickerProviderStateMixin {
  int _count = 0;
  double _scale = 1.0;
  late final AnimationController _anim;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      lowerBound: 0.0,
      upperBound: 0.08,
    );
    _anim.addListener(() {
      setState(() {
        _scale = 1 - _anim.value;
      });
    });
  }

  @override
  // remove animation when remove component
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  void _increment() {
    setState(() => _count += 1);
  }

  void _reset() {
    setState(() => _count = 0);
  }

  String getDhikrText() {
    int part = _count ~/ 33; // يقسم على 33 ويجيب المرحلة (0 أو 1 أو 2)

    switch (part) {
      case 0:
        return "سبحان الله";
      case 1:
        return "الحمد لله";
      case 2:
        return "الله أكبر";
      default:
        return "اعاده تعين";
    }
  }

  @override
  Widget build(BuildContext context) {
    // Colors tuned to match the sample image
    final Color mainGreen = const Color(0xFF7F9963); // circle color

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // Main content
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Spacer to emulate image vertical position
                  // Big tappable circle with glow and shadow
                  GestureDetector(
                    onTapDown: (_) => _anim.forward(),
                    onTapUp: (_) {
                      _anim.reverse();
                      _increment();
                    },
                    onTapCancel: () => _anim.reverse(),
                    child: Transform.scale(
                      scale: _scale,
                      child: Container(
                        width: 240,
                        height: 240,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: mainGreen,
                          // inner subtle gradient
                          gradient: RadialGradient(
                            colors: [
                              mainGreen.withOpacity(0.95),
                              mainGreen,
                            ],
                            center: Alignment(-0.2, -0.1),
                            radius: 0.9,
                          ),
                          // glow shadow surrounding the circle
                          boxShadow: [
                            BoxShadow(
                              color: mainGreen.withOpacity(0.25),
                              blurRadius: 40,
                              spreadRadius: 12,
                            ),
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 8,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // The large number
                            Text(
                              '${_count % 33}',
                              style: const TextStyle(
                                fontSize: 72,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                height: 0.9,
                              ),
                            ),
                            const SizedBox(height: 12),
                            // small label under the number
                            Text(
                              getDhikrText(),
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white.withOpacity(0.9),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 36),
                  // Reset button (small circular with icon and soft shadow)
                  GestureDetector(
                    onTap: _reset,
                    child: Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                          BoxShadow(
                            color: mainGreen.withOpacity(0.12),
                            blurRadius: 24,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Icon(
                          Icons.refresh,
                          color: mainGreen,
                          size: 26,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Optional small hint text
                  Text(
                    'اضغط على الدائرة للتسبيح',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
