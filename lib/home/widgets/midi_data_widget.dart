import 'package:drumm_app/home/bloc/midibloc_bloc.dart';
import 'package:drumm_app/home/widgets/search_device_sidebar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_midi_command_platform_interface/midi_device.dart';

class MidiDataWidget extends StatelessWidget {
  const MidiDataWidget({
    Key? key,
    required this.allDevices,
  }) : super(key: key);

  final List<MidiDevice>? allDevices;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MidiblocBloc, MidiblocState>(
      builder: (context, state) {
        if (state is MidiBlocReceivedState) {
          return Column(
            children: [
              Text(
                'Midi number: ${state.midiNumber.toString()}',
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
              Text(
                'velocity: ${state.velocity}',
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ],
          );
        }
        return SearchDeviceSidebarWidget(
          allDevices: allDevices,
        );
      },
    );
  }
}
