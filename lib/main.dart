import 'package:api_with_flutter/core/api/api_consumer.dart';
import 'package:api_with_flutter/core/api/dio_consumer.dart';
import 'package:api_with_flutter/core/cache/cache_helper.dart';
import 'package:api_with_flutter/core/di/get_it_services.dart';
import 'package:api_with_flutter/cubit/user_cubit.dart';
import 'package:api_with_flutter/repos/user_repo.dart';
import 'package:api_with_flutter/screens/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupGetIt();
  MyCacheHelper().init();

  runApp(
    BlocProvider(
      create: (context) => UserCubit(getit.get<UserRepo>()),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SignInScreen(),
    );
  }
}
