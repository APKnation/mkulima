import 'package:material_ui/material_ui.dart';

import '../../core/state/app_state.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/ui_helpers.dart';
import '../../core/widgets/mk_button.dart';
import '../../core/widgets/mk_card.dart';
import '../../data/models/post.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _content = TextEditingController();
  String _type = 'swali';
  String? _categoryId;
  bool _attachImage = false;
  String? _error;

  static const _types = [
    ('swali', 'Swali', Icons.help_outline_rounded),
    ('ushauri', 'Ushauri', Icons.tips_and_updates_outlined),
    ('mafanikio', 'Mafanikio', Icons.emoji_events_outlined),
  ];

  @override
  void dispose() {
    _content.dispose();
    super.dispose();
  }

  void _submit() {
    if (_content.text.trim().length < 10) {
      setState(() => _error = 'Andika maelezo ya kutosha (herufi 10+)');
      return;
    }
    if (_categoryId == null) {
      setState(() => _error = 'Chagua kategoria');
      return;
    }
    final state = AppScope.read(context);
    final category = state.repo.category(_categoryId);
    state.addPost(
      CommunityPost(
        id: 'post-${DateTime.now().microsecondsSinceEpoch}',
        author: state.user.name,
        role: '${state.user.role} · ${state.user.region}',
        location: state.user.ward,
        timeAgo: 'Sasa hivi',
        content: _content.text.trim(),
        categoryLabel: category?.name ?? 'Kilimo',
        type: _type,
        imageAsset: _attachImage ? category?.imageAsset : null,
      ),
    );
    Navigator.of(context).pop();
    showAppSnack(context, 'Chapisho lako limewekwa kwenye jamii');
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Shiriki na jamii')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.page,
          0,
          AppSpacing.page,
          AppSpacing.xxxl,
        ),
        children: [
          Row(
            children: [
              FarmerAvatar(
                initials: state.user.name
                    .split(' ')
                    .take(2)
                    .map((part) => part.characters.first.toUpperCase())
                    .join(),
                size: 42,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(state.user.name, style: AppText.bodyStrong),
                    Text(
                      'Inaonekana kwa wakulima wote',
                      style: AppText.small,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          Text('Aina ya chapisho', style: AppText.h3),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              for (final (value, label, icon) in _types) ...[
                Expanded(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    onTap: () => setState(() => _type = value),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: _type == value
                            ? AppColors.primarySoft
                            : AppColors.surface,
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        border: Border.all(
                          color: _type == value
                              ? AppColors.primary
                              : AppColors.line,
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            icon,
                            size: 20,
                            color: _type == value
                                ? AppColors.primaryDark
                                : AppColors.muted,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            label,
                            style: AppText.label.copyWith(
                              color: _type == value
                                  ? AppColors.primaryDark
                                  : AppColors.muted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (value != _types.last.$1) const SizedBox(width: AppSpacing.sm),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          DropdownButtonFormField<String>(
            initialValue: _categoryId,
            isExpanded: true,
            decoration: const InputDecoration(labelText: 'Kategoria'),
            hint: const Text('Chagua kategoria'),
            items: [
              for (final category in state.repo.categories)
                DropdownMenuItem(
                  value: category.id,
                  child: Text(category.name),
                ),
            ],
            onChanged: (value) => setState(() => _categoryId = value),
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: _content,
            maxLines: 7,
            maxLength: 600,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(
              hintText:
                  'Eleza swali lako au shiriki uzoefu wako kwa undani...',
              alignLabelWithHint: true,
            ),
          ),
          MkCard(
            shadow: const [],
            color: AppColors.surfaceAlt,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.xs,
            ),
            child: SwitchListTile(
              value: _attachImage,
              onChanged: (value) => setState(() => _attachImage = value),
              contentPadding: EdgeInsets.zero,
              secondary: const Icon(
                Icons.image_outlined,
                color: AppColors.primaryDark,
              ),
              title: Text('Ambatanisha picha', style: AppText.bodyStrong),
              subtitle: Text(
                'Picha ya kategoria itaambatishwa kwa mfano',
                style: AppText.small,
              ),
            ),
          ),
          if (_error != null) ...[
            const SizedBox(height: AppSpacing.md),
            Text(
              _error!,
              style: AppText.small.copyWith(color: AppColors.danger),
            ),
          ],
          const SizedBox(height: AppSpacing.xl),
          MkButton(
            label: 'Chapisha',
            icon: Icons.send_rounded,
            onPressed: _submit,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Tafadhali shiriki taarifa sahihi. Usichapishe namba za simu za wengine '
            'bila idhini au matangazo yasiyohusiana na kilimo.',
            textAlign: TextAlign.center,
            style: AppText.small,
          ),
        ],
      ),
    );
  }
}
