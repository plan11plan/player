import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SkyColor {
  static int colorIndex = 0;

  static final List<LinearGradient> colors = [
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
        Colors.blueGrey.shade900,
        // Colors.indigo.shade900,
        // Colors.indigo.shade800,
        // Colors.pink.shade300,
        Colors.yellow.shade100,
      ],
    ),
    LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Colors.black87,
        Colors.black87,
        Colors.indigo.shade800,
        // Colors.indigo.shade700,
        // Colors.indigo.shade600,
        Colors.pink.shade200,
        Colors.yellow.shade200,
      ],
    ),


    LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Colors.black87,
        Color.fromRGBO(57, 0, 63, 1),  // +20 to each RGB value
        Color.fromRGBO(106, 28, 92, 1),  // +20 to each RGB value
        Color.fromRGBO(135, 56, 96, 1),  // +20 to each RGB value
        Color.fromRGBO(207, 155, 104, 1)  // +20 to each RGB value
      ],
    ),
    LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Colors.black87,
        Colors.purple.shade700,

        Colors.pink.shade100
      ],
    ),
    LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Colors.blueGrey.shade800,

        Colors.blueGrey.shade500,
        // Colors.purple.shade300,
        Colors.orange.shade200
        // Colors.pink.shade100
      ],
    ),
    LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Colors.black87,
        Colors.blueGrey.shade800,
        Colors.blueGrey.shade500,
        // Colors.indigo[800]!,
        Colors.green.shade100!,
      ],
    ),



  ];


  static ValueListenable<Box> getColorBoxListenable() {
    return Hive.box('settings').listenable(keys: ['colorIndex']);
  }

  static Future<void> saveColorIndex() async {
    var box = await Hive.openBox('settings');
    await box.put('colorIndex', colorIndex);
  }

  static BoxDecoration get skyDecoration {
    return BoxDecoration(gradient: colors[colorIndex]);
  }

  ValueListenable<Box> get listenableSettingsBox {
    return Hive.box('settings').listenable();
  }
}



class MoonIconButton extends StatefulWidget {
  final Function callback;

  MoonIconButton({required this.callback});

  @override
  MoonIconButtonState createState() => MoonIconButtonState();
}

class MoonIconButtonState extends State<MoonIconButton> {
  final List<IconData> moonPhases = [
    MdiIcons.moonWaxingCrescent,
    MdiIcons.moonFirstQuarter,
    MdiIcons.moonWaxingGibbous,
    MdiIcons.moonFull,
    MdiIcons.moonWaningGibbous,
    MdiIcons.moonLastQuarter,
    MdiIcons.moonWaningCrescent,
  ];
  static int currentPhase = 0;

  static Future<void> saveCurrentPhase() async {
    var box = await Hive.openBox('settings');
    await box.put('moonPhase', currentPhase);
  }

  static ValueListenable<Box> getMoonPhaseBoxListenable() {
    return Hive.box('settings').listenable(keys: ['moonPhase']);
  }

  static Future<void> loadCurrentPhase() async {
    var box = await Hive.openBox('settings');
    currentPhase = box.get('moonPhase', defaultValue: 0);
  }
  @override
  Widget build(BuildContext context) {
    return AvatarGlow(
      endRadius: 30,
      glowColor: Colors.blueGrey[300]!,
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 500),
        child: IconButton(
          key: ValueKey<int>(currentPhase),
          icon: Icon(moonPhases[currentPhase], color: Colors.yellow[100], size: 30,),
          onPressed: () {
            setState(() {
              currentPhase = (currentPhase + 1) % moonPhases.length;
              saveCurrentPhase();  // Save the current phase of the moon icon
              SkyColor.colorIndex = (SkyColor.colorIndex + 1) % SkyColor.colors.length;
              SkyColor.saveColorIndex();
              widget.callback();
            });
          },
        ),
      ),
    );
  }
}