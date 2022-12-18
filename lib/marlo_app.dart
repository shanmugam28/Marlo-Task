import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:marlo_task/api_manager.dart';
import 'package:marlo_task/providers/data_manager.dart';
import 'package:marlo_task/screens/contracts_screen.dart';
import 'package:marlo_task/screens/invite_screen.dart';
import 'package:marlo_task/widgets/my_app_bar.dart';
import 'package:provider/provider.dart';

import 'constants.dart';

class MarloApp extends StatefulWidget {
  const MarloApp({Key? key}) : super(key: key);

  @override
  State<MarloApp> createState() => _MarloAppState();
}

class _MarloAppState extends State<MarloApp> {
  int currentIndex = 2;
  late DataManager dataManager;
  bool isSyncFailed = false;

  @override
  void initState() {
    dataManager = Provider.of<DataManager>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<DataManager>(context);
    debugPrint("_MarloAppState build: ${dataManager.isSyncedOnLaunch} and $isSyncFailed");
    if (!dataManager.isSyncedOnLaunch && !isSyncFailed) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        fetchData(context);
      });
    }
    return Scaffold(
      appBar: MyAppBar(
        title: currentIndex == 2 ? 'Teams' : null,
        actions: currentIndex == 2
            ? [
                const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Icon(Icons.search),
                ),
                PopupMenuButton(
                    itemBuilder: (context) => [
                          PopupMenuItem(
                            child: const Text('Refresh'),
                            onTap: () => Future.delayed(const Duration(milliseconds: 100)).then(
                              (value) => fetchData(context),
                            ),
                          ),
                          PopupMenuItem(
                            child: const Text('Toggle Theme'),
                            onTap: () => DataManager().toggleTheme(),
                          ),
                        ])
              ]
            : null,
      ),
      floatingActionButton: currentIndex == 2
          ? FloatingActionButton(
              onPressed: () async {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const InviteScreen(),
                  ),
                );
              },
              child: const Icon(
                Icons.add,
              ),
            )
          : null,
      bottomNavigationBar: Material(
        elevation: 10.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10.0),
            topRight: Radius.circular(10.0),
          ),
          child: BottomNavigationBar(
            currentIndex: currentIndex,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.monetization_on), label: 'Loans'),
              BottomNavigationBarItem(icon: Icon(Icons.task), label: 'Contracts'),
              BottomNavigationBarItem(icon: Icon(Icons.people_outline), label: 'Teams'),
              BottomNavigationBarItem(icon: Icon(Icons.chat_outlined), label: 'Chat'),
            ],
            onTap: (index) {
              setState(() => currentIndex = index);
            },
          ),
        ),
      ),
      body: _MarloScreens(index: currentIndex),
    );
  }

  fetchData(context) async {
    showDialog(
        barrierColor: Colors.transparent,
        context: context,
        builder: (context) {
          return BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 5,
              sigmaY: 5,
            ),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        });

    if (await isNetworkAvailable()) {
      ApiManager? apiManager = await ApiManager.getInstance();
      if (apiManager != null) {
        debugPrint("_MarloAppState build: not null");
        ApiResponse<Map<String, dynamic>?> response = await apiManager.getPeopleData();
        if (response.status) {
          dataManager
            ..addContacts(response.data!['contacts'])
            ..addInvitedContacts(response.data!['invitedContacts'])
            ..makeAppSynced();
        } else {
          _resetState(context, 'Something went wrong!');
        }
      } else {
        _resetState(context, 'Unable to fetch data!');
      }
    } else {
      _resetState(context, 'No internet');
    }
    if (mounted) {
      Navigator.pop(context);
    }
  }

  _resetState(BuildContext context, String? snackMessage) {
    setState(() {
      isSyncFailed = true;
    });
    if (mounted && snackMessage != null) {
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(snackMessage)));
    }
  }
}

class _MarloScreens extends StatelessWidget {
  final int index;

  const _MarloScreens({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (index) {
      case 0:
        //TODO: implement home screen
        return const SizedBox();
      case 1:
        //TODO: implement loans screen
        return const SizedBox();
      case 2:
        return const ContractScreen();
      case 3:
        //TODO: implement Teams screen
        return const SizedBox();
      case 4:
        //TODO: implement chat screen
        return const SizedBox();
      default:
        //TODO: handle default case
        return const SizedBox();
    }
  }
}
