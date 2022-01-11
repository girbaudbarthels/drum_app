// Copyright (c) 2021, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:bloc/bloc.dart';
import 'package:flutter_midi_command/flutter_midi_command.dart';

class CounterCubit extends Cubit<String> {
  CounterCubit() : super('empty');

  Future<String> getDevice() async {
    final devices = await MidiCommand().devices;
    print(devices);
    emit(devices!.first.name);
    return devices.first.name;
  }
}
