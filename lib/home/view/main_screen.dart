import 'dart:async';
import 'package:agro_xplore/screens/profile/cubit/my_user_cubit.dart';
import 'package:agro_xplore/screens/profile/model/user.dart';
import 'package:agro_xplore/screens/profile/provider/my_user_repository.dart';
import 'package:agro_xplore/screens/profile/view/profile_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../home/view/home_body.dart';

MyUser me = MyUser('', '');

StreamController<int>? countStreamController;
StreamController<int> messagesStreamController = StreamController<int>();

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  static Widget create(BuildContext context) {
    return const MainScreen();
  }

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MyUserCubit(MyUserRepository())..getMyUser(),
      child: BlocBuilder<MyUserCubit, MyUserState>(builder: (_, state) {
        if (state is MyUserReadyState) {
          me = state.user;
          return const HomeScreen();
        }
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }),
    );
  }
}

// ignore: must_be_immutable
class HomeScreen extends StatefulWidget {
  static Widget create(BuildContext context) {
    return const HomeScreen();
  }

  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  static const _kTabScreens = <Widget>[
    HomeBody(),
    ProfileBody(),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: _kTabScreens.length,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: TabBarView(
        controller: _tabController,
        children: _kTabScreens,
      ),
      bottomNavigationBar: SizedBox(
        height: 50,
        child: Material(
          color: const Color(0xFFD9D9D9),
          child: TabBar(
            tabs: const <Tab>[
              Tab(icon: Icon(Icons.home, color: Colors.blue)),
              Tab(icon: Icon(Icons.face, color: Colors.blue)),
            ],
            controller: _tabController,
          ),
        ),
      ),
    );
  }
}
