import 'package:e_commerce_app/screens/product_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_event.dart';
import '../blocs/auth/auth_state.dart';

class LoginScreen extends StatelessWidget {
   final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  // @override
  // void dispose() {
  //   _usernameController.dispose();
  //   _passwordController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthAuthenticated) {
              String token = state.token;
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => ProductListScreen(token: token),
                ),
              );
            } else if (state is AuthError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            if (state is AuthLoading) {
              return Center(child: CircularProgressIndicator());
            }
            return Column(
               crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                  const Text(
              'প্রবেশ করুন',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'ইমেইল'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'পাসওয়ার্ড'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            CheckboxListTile(
              title: const Text('আমি শর্তাবলী এবং গোপনীয়তা নীতি সম্পর্কে সচেতন'),
              value: true,
              onChanged: (value) {},
            ),
            const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    final username = _usernameController.text;
                    final password = _passwordController.text;
                    BlocProvider.of<AuthBloc>(context)
                        .add(LoginEvent(username, password));
                  },
                  child: const Text('প্রবেশ ইন করুন'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
