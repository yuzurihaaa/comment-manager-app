import 'package:comment_manager_app/model/model.dart';
import 'package:equatable/equatable.dart';

class PostState extends Equatable {
  final List<Post> posts;
  final Post focusedPost;
  final List<Comment> comments;
  final List<Comment> allComments;

  const PostState({
    this.posts,
    this.focusedPost,
    this.comments,
    this.allComments,
  });

  PostState copyWith({
    List<Post> posts,
    Post focusedPost,
    List<Comment> comments,
    final List<Comment> allComments,
  }) =>
      PostState(
        posts: posts ?? this.posts,
        focusedPost: focusedPost ?? this.focusedPost,
        comments: comments ?? this.comments,
        allComments: allComments ?? this.allComments,
      );

  factory PostState.initial() => const PostState(
        comments: null,
        focusedPost: null,
        posts: null,
        allComments: null,
      );

  @override
  List<Object> get props => [
        posts,
        focusedPost,
        comments,
        allComments,
      ];
}
