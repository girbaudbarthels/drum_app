import 'dart:async';
import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:bloc/bloc.dart';
import 'package:drumm_app/home/domain/add_sound_repository.dart';
import 'package:flutter_midi_command/flutter_midi_command.dart';
import 'package:meta/meta.dart';

part 'midibloc_event.dart';
part 'midibloc_state.dart';

class MidiblocBloc extends Bloc<MidiblocEvent, MidiblocState> {
  MidiblocBloc() : super(MidiblocInitial()) {
    on<MidiblocReadEvent>(_onMidiUpdate);
    on<MidiblocAddSoundEvent>(_addSound);
    //Initialise event listener for midi updates, this is auto called when the bloc is provided
    _midiListener = MidiCommand().onMidiDataReceived!.listen((packet) {
      if (packet.data.isEmpty) return;
      // Received an input
      final data = packet.data;
      //Update the state so the values can be rendered in the UI
      add(
        MidiblocReadEvent(midiData: data),
      );
    });
  }
  //subscription for listening to individual midi updates
  StreamSubscription<MidiPacket>? _midiListener;
  AudioPlayer audioPlayer = AudioPlayer(mode: PlayerMode.LOW_LATENCY);

  Map<String, String?> sounds = {};
  //If the midicontroller sent a value, this function will update it and render the values in the UI
  void _onMidiUpdate(MidiblocReadEvent event, Emitter emit) {
    final _midiNote = event.midiData[1];
    final _velocity = event.midiData[2];
    final _path = sounds['$_midiNote'];
    if (_path != null) playSound(_path, _velocity.toString());
    emit(
      MidiBlocReceivedState(
        midiNumber: event.midiData[1],
        velocity: event.midiData[2],
      ),
    );
  }

  Future<void> _addSound(MidiblocAddSoundEvent event, Emitter emit) async {
    final _midiNote = event.midiNote;

    final path = await AddSoundRepository().addSoundToMidiNote(_midiNote);

    if (sounds.containsKey(_midiNote)) {
      sounds.update(_midiNote, (value) => path);
    } else {
      sounds.putIfAbsent(_midiNote, () => path);
    }
  }

  void playSound(String path, String velocity) async {
    try {
      await audioPlayer.play(path, isLocal: true);
    } catch (e) {
      print(e);
    }

    return;
  }

//Dispose stream and player when this bloc is abandoned
  @override
  Future<void> close() async {
    await _midiListener?.cancel();
    await audioPlayer.dispose();
    return super.close();
  }
}
