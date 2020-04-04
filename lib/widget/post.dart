import 'package:comment_manager_app/bloc/bloc.dart';
import 'package:comment_manager_app/generated/l10n.dart';
import 'package:comment_manager_app/utilities/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:comment_manager_app/model/model.dart' as model;

class Post extends HookWidget {
  static Future push(
    BuildContext context, {
    @required model.Post post,
  }) =>
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Post(post: post)),
      );

  final model.Post post;

  const Post({this.post});

  @override
  Widget build(BuildContext context) {
    final blocListener = useBlocListener<PostBloc, PostState>();
    final bloc = useBloc<PostBloc>();
    useEffect(() {
      bloc.add(GetPost(postId: post.id));
      bloc.add(GetComments(postId: post.id));

      return null;
    }, [bloc]);
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).appTitle),
      ),
      body: blocListener.focusedPost != null
          ? _PostDetail(post: blocListener.focusedPost)
          : Container(),
    );
  }
}

class _PostDetail extends HookWidget {
  final model.Post post;

  const _PostDetail({this.post});

  @override
  Widget build(BuildContext context) {
    final blocListener = useBlocListener<PostBloc, PostState>();
    final bloc = useBloc<PostBloc>();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              post.title,
              style: Theme.of(context).textTheme.title,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              post.body,
              style: Theme.of(context).textTheme.subtitle,
            ),
          ),
          const Divider(),
          Text(S.of(context).comments),
          TextFormField(
            onChanged: (value) => bloc.add(FilterComments(keyword: value)),
            decoration: InputDecoration(
              hintText: S.of(context).searchBy,
            ),
          ),
          if (blocListener.comments != null)
            Expanded(
              child: ListView.separated(
                separatorBuilder: (_, __) => const Divider(),
                shrinkWrap: true,
                itemCount: blocListener.comments.length,
                itemBuilder: (_, index) {
                  final comment = blocListener.comments[index];

                  return ListTile(
                    title: Text('${comment.name} ${comment.email}'),
                    subtitle: Text(comment.body),
                  );
                },
              ),
            )
        ],
      ),
    );
  }
}
