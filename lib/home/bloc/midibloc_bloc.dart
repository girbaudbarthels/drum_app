import 'dart:async';
import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_midi_command/flutter_midi_command.dart';
import 'package:meta/meta.dart';

part 'midibloc_event.dart';
part 'midibloc_state.dart';

class MidiblocBloc extends Bloc<MidiblocEvent, MidiblocState> {
  MidiblocBloc() : super(MidiblocInitial()) {
    on<MidiblocEvent>(_onMidiUpdate);
    audioPlayer = AudioPlayer();
//Initialise event listener for midi updates, this is auto called when the bloc is provided
    _midiListener = MidiCommand().onMidiDataReceived!.listen((packet) {
      if (packet.data.isEmpty) return;
      // Received an input
      final data = packet.data;
      //Update the state so the values can be rendered in the UI
      add(
        MidiblocEvent(midiData: data),
      );
    });
  }
  //subscription for listening to individual midi updates
  StreamSubscription<MidiPacket>? _midiListener;
  AudioPlayer? audioPlayer;
  //If the midicontroller sent a value, this function will update it and render the values in the UI
  void _onMidiUpdate(MidiblocEvent event, Emitter emit) {
    emit(
      MidiBlocReceivedState(
        midiNumber: event.midiData[1],
        velocity: event.midiData[2],
      ),
    );
  }

  Future<void> playSnare() async {
    await audioPlayer!.play('assets/Snares/Unique Snare.wav', isLocal: true);
    return;
  }

//Dispose stream and player when this bloc is abandoned
  @override
  Future<void> close() async {
    await _midiListener?.cancel();
    await audioPlayer?.dispose();
    return super.close();
  }
}
