import 'package:agro_xplore/login/cubit/auth_cubit.dart';
import 'package:agro_xplore/screens/profile/provider/firebase_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Navigation/navigation.dart';
import '../cubit/my_user_cubit.dart';

class ProfileBody extends StatefulWidget {
  const ProfileBody({super.key});

  @override
  State<ProfileBody> createState() => _ProfileBodyState();
}

class _ProfileBodyState extends State<ProfileBody> {
  FirebaseProvider firebaseProvider = FirebaseProvider();
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile', style: TextStyle(color: Theme.of(context).colorScheme.primary)),
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(
            Icons.chevron_left,
            color: Theme.of(context).colorScheme.primary,
            size: 24,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0,
      ),
      body: isSaving
          ? const Center(child: CircularProgressIndicator())
          : Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 16),
                Text(me.name,
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 16),
                _buildActionCard(
                  context,
                  'Close account',
                  'Sign out of AgroXplore?',
                  Icons.logout,
                  Colors.orange,
                  _signOut,
                ),
                const SizedBox(height: 16),
                _buildActionCard(
                  context,
                  'Delete account',
                  'If you delete your account, all your recorded data will be deleted.',
                  Icons.delete,
                  Colors.red,
                  _deleteAccount,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionCard(BuildContext context, String title, String content, IconData icon, Color color, Function onTap) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color,
          child: Icon(icon, color: Colors.white),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(content),
        trailing: IconButton(
          icon: const Icon(Icons.arrow_forward),
          onPressed: () {
            _showConfirmationDialog(context, title, content, onTap);
          },
        ),
      ),
    );
  }

  void _showConfirmationDialog(BuildContext context, String title, String content, Function onTap) {
    showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              await onTap();
              Navigator.pop(context);
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  Future<void> _signOut() async {
    await context.read<AuthCubit>().signOut().then((value) {
      context.read<MyUserCubit>().logOut();
      Navigator.pop(context);
    });
  }

  Future<void> _deleteAccount() async {
    await firebaseProvider.eliminarCuenta();
    await context.read<AuthCubit>().signOut().then((value) {
      context.read<MyUserCubit>().logOut();
      Navigator.pop(context);
    });
  }
}
