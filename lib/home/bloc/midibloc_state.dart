part of 'midibloc_bloc.dart';

@immutable
abstract class MidiblocState {}

class MidiblocInitial extends MidiblocState {}

class MidiBlocReceivedState extends MidiblocState {
  MidiBlocReceivedState(
      {required this.midiNumber,
      required this.fullData,
      required this.velocity});

  final int midiNumber;
  final String fullData;
  final int velocity;
}
