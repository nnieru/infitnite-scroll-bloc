import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:infinitelist/posts/bloc/post_bloc.dart";
import "package:infinitelist/posts/widget/bottom_loader.dart";
import "package:infinitelist/posts/widget/post_list_item.dart";

class PostList extends StatefulWidget {
  const PostList({super.key});

  @override
  State<PostList> createState() => _PostListState();
}

class _PostListState extends State<PostList> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController..removeListener(_onScroll)..dispose();
  }

  void _onScroll() {
    if(_isBottom) context.read<PostBloc>().add(PostEventFetched());
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostBloc, PostState>(
      builder: (context, state) {
        switch (state.status) {
          case PostStatus.failure:
            return const Center(child: Text("failed to fetch post"),);
          
          case PostStatus.initial:
            return const Center(child: CircularProgressIndicator());

          case PostStatus.sucess:
            if (state.posts.isEmpty) {
              return const Center(child: Text("no posts"),);
            }

            return ListView.builder(
              itemCount: state.hasReachedMax ? state.posts.length : state.posts.length + 1,
              itemBuilder: (context, index) {
                return index > state.posts.length ? const BottomLoader() :
                  PostListItem(post: state.posts[index]);
              },
              controller: _scrollController,
            );
        }
      }
    );
  }
}