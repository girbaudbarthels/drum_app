import 'package:drumm_app/home/bloc/midibloc_bloc.dart';
import 'package:drumm_app/home/cubit/devices_cubit.dart';
import 'package:drumm_app/home/cubit/home_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
        actions: [
          //Open dropdown with available devices
          IconButton(
            onPressed: () async {
              await context.read<DevicesCubit>().getDevice();
              //for (var loadedDevice in allDevices)
              return showCupertinoModalPopup<void>(
                context: context,
                builder: (ctx) => CupertinoActionSheet(
                  actions: [
                    if (allDevices!.isEmpty)
                      CupertinoActionSheetAction(
                        onPressed: () {},
                        child: const Text('No devices found'),
                      ),
                    for (var loadedDevice in allDevices)
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
              child: Column(
                children: [
                  Center(child: Text(device)),
                  BlocBuilder<MidiblocBloc, MidiblocState>(
                    builder: (context, state) {
                      if (state is MidiBlocReceivedState) {
                        return Column(
                          children: [
                            Text('Midi number: ${state.midiNumber.toString()}'),
                            Text('velocity: ${state.velocity}'),
                          ],
                        );
                      }
                      return Container();
                    },
                  ),
                ],
              ),
            ),
            Flexible(
              flex: 8,
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: 12,
                      itemBuilder: (context, index) {
                        final instrument = index + 1;
                        return ListTile(
                          title: Text(
                            'Instrument $instrument | Note: ${59 + instrument}',
                          ),
                          //onTap: () => context.read<MidiblocBloc>().playSnare(),
                          onTap: () => context.read<MidiblocBloc>().playSound(
                              context
                                  .read<MidiblocBloc>()
                                  .sounds['${59 + instrument}'] as String,
                              "127"),
                          onLongPress: () => context.read<MidiblocBloc>().add(
                                MidiblocAddSoundEvent(
                                  midiNote: '${59 + instrument}',
                                ),
                              ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
