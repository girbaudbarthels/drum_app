import 'package:drumm_app/home/cubit/devices_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_midi_command_platform_interface/midi_device.dart';

class AppbarActionWidget extends StatelessWidget {
  const AppbarActionWidget({
    Key? key,
    required this.allDevices,
  }) : super(key: key);

  final List<MidiDevice>? allDevices;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        final devices = await context.read<DevicesCubit>().getDevice();
        return showCupertinoModalPopup<void>(
          context: context,
          builder: (ctx) => CupertinoActionSheet(
            actions: [
              if (allDevices!.isEmpty && devices!.isEmpty)
                CupertinoActionSheetAction(
                  onPressed: () {},
                  child: const Text('No devices found'),
                ),
              for (var loadedDevice in devices!)
                CupertinoActionSheetAction(
                  onPressed: () {
                    context.read<DevicesCubit>().selectDevice(loadedDevice);

                    Navigator.of(context).pop();
                  },
                  child: Text(loadedDevice.name),
                ),
            ],
          ),
        );
      },
      icon: const Icon(Icons.device_hub),
    );
  }
}
