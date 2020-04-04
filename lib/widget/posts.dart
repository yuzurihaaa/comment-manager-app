import 'package:comment_manager_app/bloc/bloc.dart';
import 'package:comment_manager_app/generated/l10n.dart';
import 'package:comment_manager_app/model/model.dart';
import 'package:comment_manager_app/utilities/hook.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import './post.dart' as widget;

class Posts extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final blocListener = useBlocListener<PostBloc, PostState>();
    final bloc = useBloc<PostBloc>();
    useEffect(() {
      bloc.add(GetPosts());

      return bloc.close;
    }, [bloc]);

    final _locale = S.of(context);
    useEffect(() {
      if (blocListener.hasError != null && blocListener.hasError) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showDialog(
            context: context,
            builder: (dialogContext) => AlertDialog(
              title: Text(_locale.error),
              content: Text(_locale.error_fetching),
              actions: <Widget>[
                FlatButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: Text(_locale.close),
                ),
              ],
            ),
          );
        });
      }

      return null;
    }, [blocListener, blocListener?.hasError]);

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).appTitle),
      ),
      body: blocListener.posts == null
          ? Container()
          : ListView.separated(
              separatorBuilder: (_, __) => const Divider(),
              itemCount: blocListener.posts.length,
              itemBuilder: (_, index) => _ListItem(
                post: blocListener.posts[index],
              ),
            ),
    );
  }
}

class _ListItem extends StatelessWidget {
  final Post post;

  const _ListItem({Key key, this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) => ListTile(
        key: Key('${post.id}'),
        onTap: () => widget.Post.push(context, post: post),
        title: Text(post.title),
        subtitle: Text(post.body),
      );
}
