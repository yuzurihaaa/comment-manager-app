import 'package:comment_manager_app/model/model.dart';
import 'package:equatable/equatable.dart';

class PostState extends Equatable {
  final List<Post> posts;
  final Post focusedPost;
  final List<Comment> comments;
  final List<Comment> allComments;
  final bool hasError;

  const PostState({
    this.posts,
    this.focusedPost,
    this.comments,
    this.allComments,
    this.hasError,
  });

  PostState copyWith({
    List<Post> posts,
    Post focusedPost,
    List<Comment> comments,
    final List<Comment> allComments,
    bool hasError,
  }) =>
      PostState(
        posts: posts ?? this.posts,
        focusedPost: focusedPost ?? this.focusedPost,
        comments: comments ?? this.comments,
        allComments: allComments ?? this.allComments,
        hasError: hasError,
      );

  factory PostState.initial() => const PostState(
        comments: null,
        focusedPost: null,
        posts: null,
        allComments: null,
        hasError: false,
      );

  @override
  List<Object> get props => [
        posts,
        focusedPost,
        comments,
        allComments,
        hasError,
      ];
}
