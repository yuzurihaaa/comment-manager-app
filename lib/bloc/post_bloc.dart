import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:comment_manager_app/bloc/post_state.dart';
import 'package:comment_manager_app/service/service.dart';
import 'package:dio/dio.dart';
import './bloc.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final RestClient client;

  PostBloc(this.client);

  @override
  PostState get initialState => PostState.initial();

  @override
  Stream<PostState> mapEventToState(
    PostEvent event,
  ) async* {
    if (event is GetPosts) {
      try {
        yield PostState.initial();
        final posts = await client.getPosts();
        yield state.copyWith(posts: posts);
      } on DioError catch (_) {
        yield state.copyWith(hasError: true);
      }
    }

    if (event is GetPost) {
      try {
        final post = await client.getPost(event.postId);

        yield state.copyWith(focusedPost: post);
      } on DioError catch (_) {
        yield state.copyWith(hasError: true);
      }
    }

    if (event is GetComments) {
      try {
        final comments = await client.getComments(event.postId);
        yield state.copyWith(allComments: comments, comments: comments);
      } on DioError catch (_) {
        yield state.copyWith(hasError: true);
      }
    }

    if (event is FilterComments) {
      final keyword = event.keyword.toLowerCase();
      final filteredComments = [
        ...state.allComments.where((comment) {
          final isInBody = comment.body.toLowerCase().contains(keyword);
          final isInEmail = comment.email.toLowerCase().contains(keyword);
          final isInName = comment.name.toLowerCase().contains(keyword);

          return isInBody || isInEmail || isInName;
        })
      ];

      yield state.copyWith(comments: filteredComments);
    }
  }
}
