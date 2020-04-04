import 'package:comment_manager_app/bloc/bloc.dart';
import 'package:comment_manager_app/main.dart';
import 'package:comment_manager_app/model/model.dart' as model;
import 'package:comment_manager_app/widget/post.dart';
import 'package:comment_manager_app/widget/posts.dart';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'bloc_test.dart';

Widget createTestWidget({
  Locale locale = const Locale('en'),
  Widget child,
  PostBloc postBloc,
}) =>
    MyApp(
      locale: locale,
      home: child,
      bloc: postBloc,
    );

void main() {
  testWidgets(
    'Posts screen show all list in Malay',
    (WidgetTester tester) async {
      final client = ClientMock();

      when(client.getPosts()).thenAnswer(
        (_) => Future.value([
          model.Post(
            id: 1,
            userId: 1,
            title: 'title of id 1',
            body: 'body of id 1',
          ),
          model.Post(
            id: 2,
            userId: 2,
            title: 'title of id 2',
            body: 'body of id 2',
          ),
        ]),
      );

      await tester.pumpWidget(createTestWidget(
        locale: const Locale('ms'),
        child: Posts(),
        postBloc: PostBloc(client),
      ));

      await tester.pumpAndSettle();

      expect(find.text('App Pegurusan Komen'), findsOneWidget);
      expect(find.byKey(const Key('1')), findsOneWidget);
      expect(find.byKey(const Key('2')), findsOneWidget);
    },
  );

  testWidgets(
    'Posts screen show all list in English',
    (WidgetTester tester) async {
      final client = ClientMock();

      when(client.getPosts()).thenAnswer(
        (_) => Future.value([
          model.Post(
            id: 1,
            userId: 1,
            title: 'title of id 1',
            body: 'body of id 1',
          ),
          model.Post(
            id: 2,
            userId: 2,
            title: 'title of id 2',
            body: 'body of id 2',
          ),
        ]),
      );

      await tester.pumpWidget(createTestWidget(
        child: Posts(),
        postBloc: PostBloc(client),
      ));

      await tester.pumpAndSettle();

      expect(find.text('Comment Manager App'), findsOneWidget);
      expect(find.byKey(const Key('1')), findsOneWidget);
      expect(find.byKey(const Key('2')), findsOneWidget);
    },
  );

  testWidgets(
    'Posts screen show dialog if error in Malay',
    (WidgetTester tester) async {
      final client = ClientMock();

      when(client.getPosts()).thenAnswer(
        (_) => throw DioError(),
      );

      await tester.pumpWidget(createTestWidget(
        locale: const Locale('ms'),
        child: Posts(),
        postBloc: PostBloc(client),
      ));

      await tester.pumpAndSettle();

      expect(find.text('App Pegurusan Komen'), findsOneWidget);
      expect(find.text('Masalah'), findsOneWidget);
      expect(find.text('Masalah mendapatkan data'), findsOneWidget);
      expect(find.byKey(const Key('1')), findsNothing);
      expect(find.byKey(const Key('2')), findsNothing);
    },
  );

  testWidgets(
    'Posts screen show dialog if error in English',
    (WidgetTester tester) async {
      final client = ClientMock();

      when(client.getPosts()).thenAnswer(
        (_) => throw DioError(),
      );

      await tester.pumpWidget(createTestWidget(
        child: Posts(),
        postBloc: PostBloc(client),
      ));

      await tester.pumpAndSettle();

      expect(find.text('Comment Manager App'), findsOneWidget);
      expect(find.text('Error'), findsOneWidget);
      expect(find.text('Error fetching data'), findsOneWidget);
      expect(find.byKey(const Key('1')), findsNothing);
      expect(find.byKey(const Key('2')), findsNothing);
    },
  );

  testWidgets(
    'Tapping on one item will navigate to next screen',
    (WidgetTester tester) async {
      final client = ClientMock();

      when(client.getPosts()).thenAnswer(
        (_) => Future.value([
          model.Post(
            id: 1,
            userId: 1,
            title: 'title of id 1',
            body: 'body of id 1',
          ),
          model.Post(
            id: 2,
            userId: 2,
            title: 'title of id 2',
            body: 'body of id 2',
          ),
        ]),
      );

      await tester.pumpWidget(createTestWidget(
        child: Posts(),
        postBloc: PostBloc(client),
      ));

      await tester.pumpAndSettle();

      final firstItem = find.byKey(const Key('1'));

      await tester.tap(firstItem);

      await tester.pumpAndSettle();

      verify(client.getPost(1)).called(1);
      verify(client.getComments(1)).called(1);
    },
  );

  testWidgets(
    'In Post screen should have post and comments',
    (WidgetTester tester) async {
      final client = ClientMock();

      when(client.getPost(1)).thenAnswer(
        (_) => Future.value(
          model.Post(
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
            model.Comment(
              id: 1,
              postId: 1,
              body: 'body for comment id 1',
              name: 'name for comment id 1',
              email: 'email for comment id 1',
            ),
            model.Comment(
              id: 2,
              postId: 2,
              body: 'body for comment id 2',
              name: 'name for comment id 2',
              email: 'email for comment id 2',
            ),
          ],
        ),
      );

      await tester.pumpWidget(createTestWidget(
        child: Post(
          post: model.Post(
            id: 1,
            body: 'body post 1',
            title: 'title post 1',
            userId: 1,
          ),
        ),
        postBloc: PostBloc(client),
      ));

      await tester.pumpAndSettle();

      verify(client.getPost(1)).called(1);
      verify(client.getComments(1)).called(1);

      expect(find.text('title of id 1'), findsOneWidget);
      expect(find.text('body of id 1'), findsOneWidget);
      expect(find.text('body of id 1'), findsOneWidget);
      expect(find.text('from name for comment id 1'), findsOneWidget);
      expect(find.text('from name for comment id 2'), findsOneWidget);
    },
  );

  testWidgets(
    'If user type in search box, comments will be filtered',
    (WidgetTester tester) async {
      final client = ClientMock();

      when(client.getPost(1)).thenAnswer(
        (_) => Future.value(
          model.Post(
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
            model.Comment(
              id: 1,
              postId: 1,
              body: 'body for comment id 1',
              name: 'name for comment id 1',
              email: 'email for comment id 1',
            ),
            model.Comment(
              id: 2,
              postId: 2,
              body: 'body for comment id 2',
              name: 'name for comment id 2',
              email: 'email for comment id 2',
            ),
          ],
        ),
      );

      await tester.pumpWidget(createTestWidget(
        child: Post(
          post: model.Post(
            id: 1,
            body: 'body post 1',
            title: 'title post 1',
            userId: 1,
          ),
        ),
        postBloc: PostBloc(client),
      ));

      await tester.pumpAndSettle();

      verify(client.getPost(1)).called(1);
      verify(client.getComments(1)).called(1);

      expect(find.text('title of id 1'), findsOneWidget);
      expect(find.text('body of id 1'), findsOneWidget);
      expect(find.text('from name for comment id 1'), findsOneWidget);
      expect(find.text('from name for comment id 2'), findsOneWidget);

      await tester.enterText(find.byKey(const Key('search box')), 'id 1');

      await tester.pumpAndSettle();

      expect(find.text('from name for comment id 1'), findsOneWidget);
      expect(find.text('from name for comment id 2'), findsNothing);
    },
  );
}
