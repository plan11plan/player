import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:avatar_glow/avatar_glow.dart';

class SkyColor {
  static int colorIndex = 0;

  static final List<LinearGradient> colors = [
    LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color.fromRGBO(57, 2, 63, 1),
        Color.fromRGBO(96, 18, 82, 1),
        Color.fromRGBO(125, 46, 86, 1),
        Color.fromRGBO(187, 135, 84, 1)
      ],
    ),
    LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Colors.indigo.shade900,
        Colors.indigo.shade700,
            Colors.indigo.shade400,
            Colors.pink.shade200,
            Colors.yellow.shade200,
      ],
    ),
    LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Colors.indigo.shade800,
        Colors.indigo.shade700,
        Colors.pink.shade200,
        Colors.yellow.shade200,
      ],
    ),
    LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Colors.deepPurple.shade800.withOpacity(0.8),
        Colors.deepPurple.shade700.withOpacity(0.99),
        Colors.indigo.shade800.withOpacity(0.76),
        Colors.indigo.shade700.withOpacity(0.76),
        Colors.deepPurple.shade300.withOpacity(0.9),
        Colors.deepPurple.shade200.withOpacity(0.8),
      ],
    ),
    LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Colors.blue[700]!,
        Colors.blue[200]!,
      ],
    ),
    LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Colors.indigo[700]!,
        Colors.indigo[200]!,
      ],
    ),
    LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Colors.purple[700]!,
        Colors.purple[200]!,
      ],
    ),
  ];

  static BoxDecoration get skyDecoration {
    return BoxDecoration(
      gradient: colors[colorIndex],
    );
  }
  static Future<void> saveColorIndex() async {
    var box = await Hive.openBox('settings');
    await box.put('colorIndex', colorIndex);
  }

  static Future<void> loadColorIndex() async {
    var box = await Hive.openBox('settings');
    colorIndex = box.get('colorIndex', defaultValue: 0);
  }

}

class MoonIconButton extends StatefulWidget {
  final Function callback;

  MoonIconButton({required this.callback});

  @override
  _MoonIconButtonState createState() => _MoonIconButtonState();
}

class _MoonIconButtonState extends State<MoonIconButton> {
  final List<IconData> moonPhases = [
    MdiIcons.moonWaxingCrescent,
    MdiIcons.moonFirstQuarter,
    MdiIcons.moonWaxingGibbous,
    MdiIcons.moonFull,
    MdiIcons.moonWaningGibbous,
    MdiIcons.moonLastQuarter,
    MdiIcons.moonWaningCrescent,
  ];
  int currentPhase = 0;

  @override
  Widget build(BuildContext context) {
    return AvatarGlow(
      endRadius: 25,
      glowColor: Colors.blueGrey[300]!,
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 300), // 여기서 애니메이션 지속시간을 조정할 수 있습니다.
        child: IconButton(
          key: ValueKey<int>(currentPhase), // 키를 사용하여 어떤 위젯이 애니메이션되어야 할지 결정합니다.
          icon: Icon(moonPhases[currentPhase], color: Colors.yellow[100]),
          onPressed: () {
            setState(() {
              currentPhase = (currentPhase + 1) % moonPhases.length;
              SkyColor.colorIndex = (SkyColor.colorIndex + 1) % SkyColor.colors.length;
              SkyColor.saveColorIndex(); // Save color index whenever the icon is pressed
              widget.callback();
            });
          },
        ),
      ),
    );
  }
}