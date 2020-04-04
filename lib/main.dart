import 'dart:io';

import 'package:comment_manager_app/bloc/post_bloc.dart';
import 'package:comment_manager_app/generated/l10n.dart';
import 'package:dio/adapter.dart';
import 'package:comment_manager_app/service/service.dart';
import 'package:device_proxy/device_proxy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'widget/posts.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final proxyConfig = await DeviceProxy.proxyConfig;

  if (proxyConfig.isEnable) {
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.findProxy = (uri) => 'PROXY ${proxyConfig.proxyUrl}';
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
    };
  }

  runApp(MyApp(
    home: Posts(),
  ));
}

class MyApp extends StatelessWidget {
  /// These three arguments are mainly for unit tests.
  final Locale locale;
  final Widget home;
  final PostBloc bloc;

  const MyApp({
    this.locale,
    this.bloc,
    @required this.home,
  });

  /// We create bloc from [PostBloc] if [bloc] argument is null.
  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (_) => bloc ?? PostBloc(client),
        child: MaterialApp(
          title: 'Comment Manager App',
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            S.delegate,
          ],
          locale: locale,
          supportedLocales: S.delegate.supportedLocales,
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: home,
        ),
      );
}
