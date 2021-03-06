part of 'midibloc_bloc.dart';

@immutable
abstract class MidiblocState {}

class MidiblocInitial extends MidiblocState {}

class MidiBlocReceivedState extends MidiblocState {
  MidiBlocReceivedState({
    required this.midiNumber,
    required this.velocity,
  });

  final int midiNumber;
  final int velocity;
}

class MidiBlocInstrumentListState extends MidiblocState {
  MidiBlocInstrumentListState({required this.instrumentList});

  final Map instrumentList;
}
