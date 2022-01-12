part of 'midibloc_bloc.dart';

@immutable
class MidiblocEvent {
  const MidiblocEvent({required this.midiData});

  final Uint8List midiData;
}
