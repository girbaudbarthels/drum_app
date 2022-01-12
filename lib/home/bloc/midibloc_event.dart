part of 'midibloc_bloc.dart';

@immutable
class MidiblocEvent {}

class MidiblocReadEvent extends MidiblocEvent {
  MidiblocReadEvent({required this.midiData});

  final Uint8List midiData;
}

class MidiblocAddSoundEvent extends MidiblocEvent {
  MidiblocAddSoundEvent({required this.midiNote});
  final String midiNote;
}
