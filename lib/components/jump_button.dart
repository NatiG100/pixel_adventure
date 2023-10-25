import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

class JumpButton extends SpriteComponent
    with HasGameRef<PixelAdventure>, TapCallbacks {
  JumpButton();
  final margin = 55.0;
  final buttonSize = 64.0;
  @override
  FutureOr<void> onLoad() {
    priority = 1;
    sprite = Sprite(game.images.fromCache('HUD/JumpBtn.png'));
    position = Vector2(
      game.size.x - 300,
      game.size.y  - margin - buttonSize,
    );
    return super.onLoad();
  }

  @override
  void onTapDown(TapDownEvent event) {
    game.player.hasJumped = true;
    super.onTapDown(event);
  }

  @override
  void onTapUp(TapUpEvent event) {
    game.player.hasJumped = false;
    super.onTapUp(event);
  }
}
