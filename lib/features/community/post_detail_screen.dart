import 'package:material_ui/material_ui.dart';

import '../../core/state/app_state.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/badges.dart';
import '../../core/widgets/mk_card.dart';
import '../../core/widgets/mk_image.dart';
import '../../data/models/post.dart';
import 'community_screen.dart';

class PostDetailScreen extends StatefulWidget {
  const PostDetailScreen({super.key, required this.postId});

  final String postId;

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  final _comment = TextEditingController();

  @override
  void dispose() {
    _comment.dispose();
    super.dispose();
  }

  void _send(CommunityPost post) {
    final text = _comment.text.trim();
    if (text.length < 2) return;
    AppScope.read(context).addComment(
      post.id,
      CommunityComment(
        id: 'c-${DateTime.now().microsecondsSinceEpoch}',
        author: AppScope.read(context).user.name,
        role: 'Mkulima · ${AppScope.read(context).user.region}',
        timeAgo: 'Sasa hivi',
        text: text,
      ),
    );
    _comment.clear();
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final posts = state.posts.where((p) => p.id == widget.postId).toList();
    if (posts.isEmpty) {
      return const Scaffold(body: Center(child: Text('Mazungumzo hayapatikani')));
    }
    final post = posts.first;

    return Scaffold(
      appBar: AppBar(title: const Text('Mazungumzo')),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.page,
          AppSpacing.sm,
          AppSpacing.page,
          AppSpacing.sm,
        ),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border(top: BorderSide(color: AppColors.line)),
        ),
        child: SafeArea(
          top: false,
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _comment,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    hintText: 'Andika jibu lako...',
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.md,
                    ),
                    suffixIcon: IconButton(
                      onPressed: () => _send(post),
                      icon: const Icon(
                        Icons.send_rounded,
                        color: AppColors.primary,
                        size: 20,
                      ),
                    ),
                  ),
                  onSubmitted: (_) => _send(post),
                ),
              ),
            ],
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.page,
          AppSpacing.md,
          AppSpacing.page,
          AppSpacing.xxl,
        ),
        children: [
          CommunityPostCard(post: post, expanded: true),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Text(
                'Majibu (${post.comments.length})',
                style: AppText.h2,
              ),
              const Spacer(),
              if (post.isExpert)
                const MkPill(
                  label: 'Jibu la mtaalamu lipo',
                  icon: Icons.verified_rounded,
                  foreground: AppColors.info,
                  background: AppColors.infoSoft,
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          if (post.comments.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
              child: Column(
                children: [
                  const Icon(
                    Icons.forum_outlined,
                    size: 36,
                    color: AppColors.muted,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Kuwa wa kwanza kujibu swali hili.',
                    style: AppText.small,
                  ),
                ],
              ),
            )
          else
            for (final comment in post.comments) ...[
              _CommentTile(comment: comment),
              const SizedBox(height: AppSpacing.sm),
            ],
        ],
      ),
    );
  }
}

class _CommentTile extends StatelessWidget {
  const _CommentTile({required this.comment});

  final CommunityComment comment;

  @override
  Widget build(BuildContext context) {
    return MkCard(
      shadow: AppShadows.soft,
      padding: const EdgeInsets.all(AppSpacing.md),
      color: comment.isExpert ? AppColors.infoSoft : AppColors.surface,
      borderColor: comment.isExpert ? const Color(0xFFCFE6F5) : null,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FarmerAvatar(
            initials: initialsOf(comment.author),
            size: 34,
            backgroundColor: comment.isExpert
                ? AppColors.info
                : AppColors.primary,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        comment.author,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppText.bodyStrong,
                      ),
                    ),
                    if (comment.isExpert) ...[
                      const SizedBox(width: 4),
                      const VerifiedChip(compact: true),
                    ],
                  ],
                ),
                Text(
                  '${comment.role} · ${comment.timeAgo}',
                  style: AppText.small,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(comment.text, style: AppText.body),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
