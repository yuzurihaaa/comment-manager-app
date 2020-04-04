import 'package:comment_manager_app/bloc/bloc.dart';
import 'package:comment_manager_app/model/model.dart';
import 'package:comment_manager_app/service/rest_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class ClientMock extends Mock implements RestClient {}

void main() {
  ClientMock client;
  PostBloc bloc;

  setUp(() {
    client = ClientMock();
    bloc = PostBloc(client);

    when(client.getPosts()).thenAnswer(
      (_) => Future.value([
        Post(
          id: 1,
          userId: 1,
          title: 'title of id 1',
          body: 'body of id 1',
        ),
        Post(
          id: 2,
          userId: 2,
          title: 'title of id 2',
          body: 'body of id 2',
        ),
      ]),
    );

    when(client.getPost(1)).thenAnswer(
      (_) => Future.value(
        Post(
          id: 1,
          userId: 1,
          title: 'title of id 1',
          body: 'body of id 1',
        ),
      ),
    );

    when(client.getComments(1)).thenAnswer(
      (_) => Future.value(
        [
          Comment(
            id: 1,
            postId: 1,
            body: 'body for comment id 1',
            name: 'name for comment id 1',
            email: 'email for comment id 1',
          ),
          Comment(
            id: 2,
            postId: 2,
            body: 'body for comment id 2',
            name: 'name for comment id 2',
            email: 'email for comment id 2',
          ),
        ],
      ),
    );
  });

  tearDown(() {
    bloc?.close();
  });

  test('Test Bloc fetch all posts', () {
    expectLater(
        bloc,
        emitsInOrder([
          PostState.initial(),
          PostState.initial().copyWith(posts: [
            Post(
              id: 1,
              userId: 1,
              title: 'title of id 1',
              body: 'body of id 1',
            ),
            Post(
              id: 2,
              userId: 2,
              title: 'title of id 2',
              body: 'body of id 2',
            ),
          ])
        ]));

    bloc.add(GetPosts());
  });

  test('Test Bloc fetch all posts with error', () {
    when(client.getPosts()).thenAnswer(
      (_) => throw DioError(),
    );

    expectLater(
        bloc,
        emitsInOrder([
          PostState.initial(),
          PostState.initial().copyWith(hasError: true)
        ]));

    bloc.add(GetPosts());
  });

  test('Test Bloc fetch post with id 1', () {
    expectLater(
        bloc,
        emitsInOrder([
          PostState.initial(),
          PostState.initial().copyWith(
            focusedPost: Post(
              id: 1,
              userId: 1,
              title: 'title of id 1',
              body: 'body of id 1',
            ),
          )
        ]));

    bloc.add(const GetPost(postId: 1));
  });

  test('Test Bloc fetch comments with post id 1', () {
    final allComments = [
      Comment(
        id: 1,
        postId: 1,
        body: 'body for comment id 1',
        name: 'name for comment id 1',
        email: 'email for comment id 1',
      ),
      Comment(
        id: 2,
        postId: 2,
        body: 'body for comment id 2',
        name: 'name for comment id 2',
        email: 'email for comment id 2',
      ),
    ];

    expectLater(
        bloc,
        emitsInOrder([
          PostState.initial(),
          PostState.initial().copyWith(
            comments: allComments,
            allComments: allComments,
          ),
        ]));

    bloc.add(const GetComments(postId: 1));
  });

  test('Test Bloc fetch comments with post id 1 and filter comment', () {
    final filteredComments = [
      Comment(
        id: 1,
        postId: 1,
        body: 'body for comment id 1',
        name: 'name for comment id 1',
        email: 'email for comment id 1',
      )
    ];

    final allComments = [
      Comment(
        id: 1,
        postId: 1,
        body: 'body for comment id 1',
        name: 'name for comment id 1',
        email: 'email for comment id 1',
      ),
      Comment(
        id: 2,
        postId: 2,
        body: 'body for comment id 2',
        name: 'name for comment id 2',
        email: 'email for comment id 2',
      ),
    ];

    expectLater(
        bloc,
        emitsInOrder([
          PostState.initial(),
          PostState.initial().copyWith(
            comments: allComments,
            allComments: allComments,
          ),
          PostState.initial().copyWith(
            comments: filteredComments,
            allComments: allComments,
          )
        ]));

    bloc.add(const GetComments(postId: 1));
    bloc.add(const FilterComments(keyword: 'id 1'));
  });

  test('test Post model', () {
    final post = Post(
      userId: 1,
      title: 'post title',
      body: 'post body',
      id: 1,
    );

    expect(post.toJson(), {
      'userId': 1,
      'title': 'post title',
      'body': 'post body',
      'id': 1,
    });

    expect(
        post,
        Post.fromJson({
          'userId': 1,
          'title': 'post title',
          'body': 'post body',
          'id': 1,
        }));
  });

  test('test Comment model', () {
    final comment = Comment(
      email: 'comment email',
      name: 'comment name',
      postId: 1,
      body: 'post body',
      id: 1,
    );

    expect(comment.toJson(), {
      'email': 'comment email',
      'name': 'comment name',
      'postId': 1,
      'body': 'post body',
      'id': 1,
    });

    expect(
        comment,
        Comment.fromJson({
          'email': 'comment email',
          'name': 'comment name',
          'postId': 1,
          'body': 'post body',
          'id': 1,
        }));
  });
}
