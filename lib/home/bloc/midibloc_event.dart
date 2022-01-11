part of 'midibloc_bloc.dart';

@immutable
class MidiblocEvent {
  MidiblocEvent({required this.midiData});

  final Uint8List midiData;
}
