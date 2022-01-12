import 'package:drumm_app/home/cubit/devices_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_midi_command/flutter_midi_command.dart';

class SearchDeviceSidebarWidget extends StatelessWidget {
  const SearchDeviceSidebarWidget({
    Key? key,
    required this.allDevices,
  }) : super(key: key);

  final List<MidiDevice>? allDevices;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DevicesCubit, List<MidiDevice>?>(
      builder: (context, state) {
        if (state!.isEmpty ||
            state.first.name != context.read<DevicesCubit>().selectedDevice) {
          return IconButton(
            iconSize: 80,
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
                          context
                              .read<DevicesCubit>()
                              .selectDevice(loadedDevice);

                          Navigator.of(context).pop();
                        },
                        child: Text(loadedDevice.name),
                      ),
                  ],
                ),
              );
            },
            icon: const Icon(
              Icons.device_hub,
              color: Colors.white,
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
