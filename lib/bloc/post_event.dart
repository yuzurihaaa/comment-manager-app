import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

abstract class PostEvent extends Equatable {
  const PostEvent();
}

class GetPosts extends PostEvent {
  @override
  List<Object> get props => null;
}

class GetPost extends PostEvent {
  final num postId;

  const GetPost({this.postId});

  @override
  List<Object> get props => [postId];
}

class GetComments extends PostEvent {
  final num postId;

  const GetComments({@required this.postId});

  @override
  List<Object> get props => [postId];
}

class FilterComments extends PostEvent {
  final String keyword;

  const FilterComments({@required this.keyword});

  @override
  List<Object> get props => [keyword];
}
