import 'package:bloc/bloc.dart';
import 'package:flutter_midi_command/flutter_midi_command.dart';
import 'package:meta/meta.dart';

part 'midibloc_event.dart';
part 'midibloc_state.dart';

class MidiblocBloc extends Bloc<MidiblocEvent, MidiblocState> {
  MidiblocBloc() : super(MidiblocInitial()) {
    on<MidiblocEvent>((event, emit) {
      MidiCommand().onMidiDataReceived!.listen((packet) {
        // Received an input
        final data = packet.data;
        if (data.length >= 2) {
          //Midinumber
          final d1 = data[1];
          //Velocity
          final d2 = data[2];
          //Update the state so the values can be rendered in the UI
          emit(MidiBlocReceivedState(midiNumber: d1, velocity: d2));
        }
      });
    });
  }
}
