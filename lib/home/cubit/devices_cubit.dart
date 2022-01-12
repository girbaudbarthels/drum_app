import 'package:bloc/bloc.dart';
import 'package:flutter_midi_command/flutter_midi_command.dart';

class DevicesCubit extends Cubit<List<MidiDevice>?> {
  DevicesCubit() : super([]);

  String selectedDevice = 'No Device Selected';

  Future<List<MidiDevice>?> getDevice() async {
    //Search for all devices
    final devices = await MidiCommand().devices;
    //Update the state with all of the available devices
    emit(devices);
    return devices;
  }

  void selectDevice(MidiDevice device) {
    //Set the selected device name
    selectedDevice = device.name;
    //Connect the selected midi
    MidiCommand().connectToDevice(device);
    //update the state
    emit([device]);
  }
}
