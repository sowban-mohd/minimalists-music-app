import 'package:flutter_riverpod/flutter_riverpod.dart';

final tonearmStateProvider =
    NotifierProvider<TonearmStateNotifier, TonearmState>(
      TonearmStateNotifier.new,
    );

class TonearmState {
  final double rotationAngle;
  final bool isSnappedToCd;

  TonearmState({required this.rotationAngle, required this.isSnappedToCd});

  TonearmState copyWith({double? rotationAngle, bool? isSnappedToCd}) {
    return TonearmState(
      rotationAngle: rotationAngle ?? this.rotationAngle,
      isSnappedToCd: isSnappedToCd ?? this.isSnappedToCd,
    );
  }
}

class TonearmStateNotifier extends Notifier<TonearmState> {
  @override
  TonearmState build() =>
      (TonearmState(rotationAngle: 0.0, isSnappedToCd: false));

  static const double _cdThresholdAngle = -0.35;
  static const double _cdSnapAngle = -0.50;
  static const double _restingAngle = 0.0;
  static const double _sensitivity = 0.01;

  void rotateTonearm(double deltaX) {
    double newAngle = state.rotationAngle + deltaX * _sensitivity; //convert deltax value to radian angle
    bool snapped = state.isSnappedToCd;

    if (!snapped) {
      if (newAngle <= _cdThresholdAngle) {
        snapped = true;
        newAngle = _cdSnapAngle;
      } else if (newAngle >= _restingAngle) {
        newAngle = _restingAngle;
      }
    } else {
      if (newAngle >= _cdThresholdAngle) {
        snapped = false;
      }
      newAngle = newAngle.clamp(_cdSnapAngle, _restingAngle);
    }

    state = state.copyWith(rotationAngle: newAngle, isSnappedToCd: snapped);
  }

  void resetToResting() {
    if (!state.isSnappedToCd) {
      state = state.copyWith(rotationAngle: _restingAngle);
    }
  }

  void unsnapFromCd() {
  state = state.copyWith(
    isSnappedToCd: false,
    rotationAngle: _restingAngle,
  );
}
}
