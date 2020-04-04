import 'package:dio/dio.dart';

import 'rest_client.dart';

final Dio dio = Dio();

final RestClient client = RestClient(dio);
