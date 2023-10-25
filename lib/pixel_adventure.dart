import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:pixel_adventure/components/jump_button.dart';
import 'package:pixel_adventure/components/player.dart';
import 'package:pixel_adventure/components/level.dart';

class PixelAdventure extends FlameGame
    with
        HasKeyboardHandlerComponents,
        DragCallbacks,
        HasCollisionDetection,
        TapCallbacks {
  @override
  Color backgroundColor() => const Color(0xFF211F30);

  late JoystickComponent joystick;
  late CameraComponent cam;
  Player player = Player(character: 'Ninja Frog');
  bool showControls = true;
  List<String> levelNames = ['level_01', 'level_02'];
  int currentLevelIndex = 0;

  @override
  FutureOr<void> onLoad() async {
    // Load all images into cache
    await images.loadAllImages();
    _loadLevel();
    joystick = addJoyStick();
    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (showControls) {
      updateJoystic();
    }
    super.update(dt);
  }

  JoystickComponent addJoyStick() {
    joystick = JoystickComponent(
      priority: 200,
      knob: SpriteComponent(
        sprite: Sprite(
          images.fromCache('HUD/Knob.png'),
        ),
      ),
      background: SpriteComponent(
        sprite: Sprite(
          images.fromCache('HUD/Joystick.png'),
        ),
      ),
      margin: const EdgeInsets.only(left: 32, bottom: 55),
    );
    return joystick;
  }

  void updateJoystic() {
    switch (joystick.direction) {
      case JoystickDirection.left:
      case JoystickDirection.upLeft:
      case JoystickDirection.downLeft:
        player.horizontalMovement = -1;
        break;
      case JoystickDirection.right:
      case JoystickDirection.downRight:
      case JoystickDirection.upRight:
        player.horizontalMovement = 1;
        break;
      default:
        player.horizontalMovement = 0;
        break;
    }
  }

  void loadNextLevel() {
    removeWhere((component) => component is Level);
    if (currentLevelIndex < levelNames.length - 1) {
      currentLevelIndex++;
      _loadLevel();
    } else {
      currentLevelIndex = 0;
      _loadLevel();
      // no more level
    }
  }

  void _loadLevel() {
    Future.delayed(
        const Duration(
          seconds: 1,
        ), () {
      Level world = Level(
        levelName: levelNames[currentLevelIndex],
        player: player,
      );

      List<Component> components = [];
      if (showControls) {
        components.addAll([joystick]);
      }
      cam = CameraComponent.withFixedResolution(
        world: world,
        width: 640,
        height: 360,
        hudComponents: components,
      );
      cam.viewfinder.anchor = Anchor.topLeft;

      addAll([cam, world]);
      if (showControls) {
        world.add(JumpButton());
      }
    });
  }
}
