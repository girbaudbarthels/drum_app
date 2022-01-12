import 'package:drumm_app/home/bloc/midibloc_bloc.dart';
import 'package:drumm_app/home/cubit/devices_cubit.dart';
import 'package:drumm_app/home/cubit/home_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_midi_command/flutter_midi_command.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  //Wrap the homepage with the homecubit
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => HomeCubit(),
        ),
        BlocProvider(
          create: (context) => DevicesCubit(),
        ),
        BlocProvider(
          create: (context) => MidiblocBloc(),
        ),
      ],
      child: const HomeView(),
    );
  }
}

//Homeview, initial screen is rendered here
class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final device = context.select((DevicesCubit cubit) => cubit.selectedDevice);
    final allDevices = context.select((DevicesCubit cubit) => cubit.state);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Drumm App'),
        elevation: 0,
        actions: [
          //Open dropdown with available devices
          IconButton(
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
            icon: const Icon(Icons.device_hub),
          ),
        ],
      ),
      body: SizedBox.expand(
        child: Row(
          children: [
            Flexible(
              flex: 4,
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Center(
                        child: Text(
                      device,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    )),
                    BlocBuilder<MidiblocBloc, MidiblocState>(
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
                        return BlocBuilder<DevicesCubit, List<MidiDevice>?>(
                          builder: (context, state) {
                            if (state!.isEmpty ||
                                state.first.name !=
                                    context
                                        .read<DevicesCubit>()
                                        .selectedDevice) {
                              return IconButton(
                                iconSize: 80,
                                onPressed: () async {
                                  final devices = await context
                                      .read<DevicesCubit>()
                                      .getDevice();
                                  return showCupertinoModalPopup<void>(
                                    context: context,
                                    builder: (ctx) => CupertinoActionSheet(
                                      actions: [
                                        if (allDevices!.isEmpty &&
                                            devices!.isEmpty)
                                          CupertinoActionSheetAction(
                                            onPressed: () {},
                                            child:
                                                const Text('No devices found'),
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
                      },
                    ),
                  ],
                ),
              ),
            ),
            Flexible(
              flex: 8,
              child: Container(
                color: Colors.grey[900],
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: 12,
                        itemBuilder: (context, index) {
                          final instrument = index + 1;

                          return Column(
                            children: [
                              InkWell(
                                onTap: () => context
                                    .read<MidiblocBloc>()
                                    .playSound(
                                        context
                                                .read<MidiblocBloc>()
                                                .sounds['${59 + instrument}']
                                            as String,
                                        "127"),
                                child: Container(
                                  padding: const EdgeInsets.all(20),
                                  height: 80,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      InkWell(
                                        onTap: () => context
                                            .read<MidiblocBloc>()
                                            .add(
                                              MidiblocAddSoundEvent(
                                                midiNote: '${59 + instrument}',
                                              ),
                                            ),
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.music_note,
                                              size: 40,
                                              color: Colors.white,
                                            ),
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            Text(
                                              'Instrument $instrument',
                                              style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width: 100,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '${59 + instrument}',
                                              style: const TextStyle(
                                                fontSize: 20,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const Icon(
                                              Icons.keyboard,
                                              size: 40,
                                              color: Colors.white,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const Divider(
                                color: Colors.white10,
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
