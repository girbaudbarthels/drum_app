import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:flutter_midi_command/flutter_midi_command.dart';
import 'package:meta/meta.dart';

part 'midibloc_event.dart';
part 'midibloc_state.dart';

class MidiblocBloc extends Bloc<MidiblocEvent, MidiblocState> {
  MidiblocBloc() : super(MidiblocInitial()) {
    on<MidiblocEvent>((event, emit) {
      try {
        MidiCommand().onMidiDataReceived!.listen((packet) {
          print('eee');
          // print('received packet $packet');
          var data = packet.data;
          var timestamp = packet.timestamp;
          var device = packet.device;

          String fullData =
              "data $data @ time $timestamp from device ${device.name}:${device.id}";
          var status = data[0];

          if (data.length >= 2) {
            var d1 = data[1];
            var d2 = data[2];

            emit(MidiBlocReceivedState(
                midiNumber: d1, fullData: fullData, velocity: d2));
          }
        });
      } catch (e) {
        print(e);
      }
    });
  }
}
