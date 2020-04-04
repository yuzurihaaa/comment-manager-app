import 'package:comment_manager_app/model/model.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'rest_client.g.dart';

@RestApi(baseUrl: 'https://jsonplaceholder.typicode.com')
abstract class RestClient {
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;

  @GET('/posts')
  Future<List<Post>> getPosts();

  @GET('/posts/{post_id}')
  Future<Post> getPost(@Path('post_id') num postId);

  @GET('/comments')
  Future<List<Comment>> getComments(@Query('postId') num postId);
}
