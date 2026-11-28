import 'package:material_ui/material_ui.dart';

import '../../core/state/app_state.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../core/utils/ui_helpers.dart';
import '../../core/widgets/badges.dart';
import '../../core/widgets/mk_button.dart';
import '../../core/widgets/mk_card.dart';
import '../../core/widgets/mk_image.dart';
import '../../data/models/post.dart';
import 'create_post_screen.dart';
import 'post_detail_screen.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  String? _type;

  static const _filters = [
    (null, 'Zote'),
    ('swali', 'Maswali'),
    ('ushauri', 'Ushauri'),
    ('mafanikio', 'Mafanikio'),
  ];

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final posts = state.posts
        .where((p) => _type == null || p.type == _type)
        .toList();

    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 58),
        child: FloatingActionButton.extended(
          heroTag: 'community-create-post',
          onPressed: () => pushScreen(context, const CreatePostScreen()),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 2,
          icon: const Icon(Icons.edit_rounded),
          label: const Text('Uliza au shiriki'),
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.page,
            AppSpacing.lg,
            AppSpacing.page,
            110,
          ),
          children: [
            Text('Jamii ya wakulima', style: AppText.display),
            const SizedBox(height: 4),
            Text(
              'Uliza maswali, shiriki uzoefu na jifunze kwa wenzako.',
              style: AppText.body,
            ),
            const SizedBox(height: AppSpacing.lg),
            SizedBox(
              height: 36,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  for (final (value, label) in _filters)
                    Padding(
                      padding: const EdgeInsets.only(right: AppSpacing.sm),
                      child: FilterChip(
                        label: Text(label),
                        selected: _type == value,
                        onSelected: (_) => setState(() => _type = value),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            for (final post in posts) ...[
              CommunityPostCard(post: post),
              const SizedBox(height: AppSpacing.md),
            ],
          ],
        ),
      ),
    );
  }
}

class CommunityPostCard extends StatelessWidget {
  const CommunityPostCard({super.key, required this.post, this.expanded = false});

  final CommunityPost post;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    return MkCard(
      padding: EdgeInsets.zero,
      shadow: AppShadows.soft,
      onTap: () => pushScreen(context, PostDetailScreen(postId: post.id)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.md,
              AppSpacing.md,
              0,
            ),
            child: Row(
              children: [
                FarmerAvatar(
                  initials: initialsOf(post.author),
                  size: 42,
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
                              post.author,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppText.bodyStrong,
                            ),
                          ),
                          if (post.isExpert) ...[
                            const SizedBox(width: 4),
                            const VerifiedChip(compact: true),
                          ],
                        ],
                      ),
                      Text(
                        '${post.role} · ${post.timeAgo}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppText.small,
                      ),
                    ],
                  ),
                ),
                MkPill(
                  label: post.typeLabel,
                  foreground: post.type == 'swali'
                      ? AppColors.info
                      : post.type == 'mafanikio'
                          ? AppColors.success
                          : AppColors.primaryDark,
                  background: post.type == 'swali'
                      ? AppColors.infoSoft
                      : post.type == 'mafanikio'
                          ? AppColors.successSoft
                          : AppColors.primarySoft,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post.content,
                  maxLines: expanded ? null : 4,
                  overflow: expanded ? null : TextOverflow.ellipsis,
                  style: AppText.body.copyWith(color: AppColors.ink),
                ),
                const SizedBox(height: AppSpacing.sm),
                MkPill(
                  label: post.categoryLabel,
                  icon: Icons.eco_rounded,
                  foreground: AppColors.inkSoft,
                  background: AppColors.surfaceAlt,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                ),
              ],
            ),
          ),
          if (post.imageAsset != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.md),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                height: 180,
                width: double.infinity,
                child: MkImage(asset: post.imageAsset!),
              ),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.sm,
              AppSpacing.xs,
              AppSpacing.md,
              AppSpacing.xs,
            ),
            child: Row(
              children: [
                TextButton.icon(
                  onPressed: () => state.toggleLike(post.id),
                  icon: Icon(
                    post.liked
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    size: 18,
                    color: post.liked ? AppColors.danger : AppColors.muted,
                  ),
                  label: Text(
                    '${post.likes}',
                    style: AppText.label.copyWith(
                      color: post.liked ? AppColors.danger : AppColors.inkSoft,
                    ),
                  ),
                ),
                TextButton.icon(
                  onPressed: () =>
                      pushScreen(context, PostDetailScreen(postId: post.id)),
                  icon: const Icon(
                    Icons.chat_bubble_outline_rounded,
                    size: 17,
                    color: AppColors.muted,
                  ),
                  label: Text(
                    '${post.comments.length}',
                    style: AppText.label.copyWith(color: AppColors.inkSoft),
                  ),
                ),
                TextButton.icon(
                  onPressed: () => showAppSheet(
                    context,
                    child: _ReplySheet(post: post),
                  ),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.primaryDark,
                    backgroundColor: AppColors.primarySoft,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    minimumSize: const Size(0, 32),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                    ),
                  ),
                  icon: const Icon(Icons.reply_rounded, size: 17),
                  label: Text(
                    'Jibu',
                    style: AppText.label.copyWith(
                      color: AppColors.primaryDark,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const Spacer(),
                IconButton(
                  tooltip: 'Shiriki',
                  onPressed: () => showAppSnack(
                    context,
                    'Kiungo cha mazungumzo kimenakiliwa',
                    icon: Icons.link_rounded,
                  ),
                  icon: const Icon(
                    Icons.share_outlined,
                    size: 18,
                    color: AppColors.muted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ReplySheet extends StatefulWidget {
  const _ReplySheet({required this.post});

  final CommunityPost post;

  @override
  State<_ReplySheet> createState() => _ReplySheetState();
}

class _ReplySheetState extends State<_ReplySheet> {
  final _replyController = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _replyController.dispose();
    super.dispose();
  }

  void _submit() {
    final text = _replyController.text.trim();
    if (text.length < 3) {
      setState(() => _error = 'Andika jibu lenye maelezo angalau herufi 3');
      return;
    }

    final state = AppScope.read(context);
    state.addComment(
      widget.post.id,
      CommunityComment(
        id: 'c-${DateTime.now().microsecondsSinceEpoch}',
        author: state.user.name,
        role: '${state.user.role} · ${state.user.region}',
        timeAgo: 'Sasa hivi',
        text: text,
      ),
    );

    Navigator.of(context).pop();
    showAppSnack(context, 'Jibu lako limetumwa kwenye jamii ✓');
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.page,
        0,
        AppSpacing.page,
        AppSpacing.xl + bottomInset,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SheetHandle(),
          const SizedBox(height: AppSpacing.md),
          SheetHeader(
            title: 'Jibu swali la ${widget.post.author}',
            subtitle: widget.post.categoryLabel,
          ),
          const SizedBox(height: AppSpacing.md),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.surfaceAlt,
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(color: AppColors.line),
            ),
            child: Text(
              widget.post.content,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: AppText.small.copyWith(color: AppColors.inkSoft),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: _replyController,
            autofocus: true,
            maxLines: 4,
            minLines: 3,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              labelText: 'Jibu lako *',
              hintText: 'Shiriki ushauri, uzoefu au suluhisho lako...',
              alignLabelWithHint: true,
              errorText: _error,
            ),
            onChanged: (_) {
              if (_error != null) setState(() => _error = null);
            },
          ),
          const SizedBox(height: AppSpacing.lg),
          MkButton(
            label: 'Tuma jibu',
            icon: Icons.send_rounded,
            onPressed: _submit,
          ),
        ],
      ),
    );
  }
}
