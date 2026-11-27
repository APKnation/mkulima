import 'package:material_ui/material_ui.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/ui_helpers.dart';
import '../../core/widgets/badges.dart';
import '../../core/widgets/mk_image.dart';
import '../../data/models/business_tools.dart';
import '../../data/seed/business_tools_seed.dart';

class AiAssistantScreen extends StatefulWidget {
  const AiAssistantScreen({super.key});

  @override
  State<AiAssistantScreen> createState() => _AiAssistantScreenState();
}

class _AiAssistantScreenState extends State<AiAssistantScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  late List<AiChatMessage> _messages;
  bool _isReplying = false;
  String? _pendingAttachment;

  @override
  void initState() {
    super.initState();
    _messages = List.from(initialAiChatSeed);
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage([String? textOverride]) {
    final text = textOverride ?? _messageController.text.trim();
    if (text.isEmpty && _pendingAttachment == null) return;

    final userMessage = AiChatMessage(
      id: 'msg-${DateTime.now().microsecondsSinceEpoch}',
      text: text,
      isUser: true,
      timestamp: 'Sasa hivi',
      attachedImage: _pendingAttachment,
    );

    setState(() {
      _messages.add(userMessage);
      _messageController.clear();
      _pendingAttachment = null;
      _isReplying = true;
    });

    _scrollToBottom();

    // Simulated intelligent response (Backend ready)
    Future.delayed(const Duration(milliseconds: 1400), () {
      if (!mounted) return;
      String replyText = '';
      final lower = text.toLowerCase();

      if (lower.contains('nyanya') || lower.contains('madoa')) {
        replyText =
            'Kulingana na maelezo yako na dalili za kawaida za kitropiki, madoa meusi kwenye nyanya yanasababishwa na ugonjwa wa Kinyausi (Early/Late Blight).\n\n'
            '🔍 Hatua za Haraka:\n'
            '1. Punguza unyevu shambani kwa kuondoa majani ya chini yanayogusa ardhi.\n'
            '2. Pulizia dawa yenye mchanganyiko wa Mancozeb au Ridomil Gold asubuhi mapema.\n'
            '3. Epuka kumwagilia kwa mfumo wa rasharasha (sprinklers) wakati huu, tumia matone (drip).\n\n'
            'Je, unahitaji duka la pembejeo lililopo karibu nawe lenye dawa hizi?';
      } else if (lower.contains('mbolea') || lower.contains('urea')) {
        replyText =
            'Wakati sahihi zaidi wa kuweka UREA kwenye mahindi ni wiki ya 3 hadi ya 4 baada ya kuota (mmea ukiwa na majani 5 hadi 6).\n\n'
            '💡 Ushauri:\n'
            '• Tumia kiasi cha nusu kifuniko cha soda au gramu 5 kwa kila shina.\n'
            '• Weka umbali wa sm 5 hadi 7 kutoka kwenye shina na fukia kidogo kwenye ardhi yenye unyevu.\n'
            '• Epuka kuweka mbolea ardhi ikiwa kavu kabisa au jua kali sana bila maji.';
      } else if (lower.contains('vitunguu') || lower.contains('gharama')) {
        replyText =
            'Kwa ekari 1 ya vitunguu maji, wastani wa mtaji unahitajika ni kati ya Tsh 1,000,000 hadi 1,200,000 ikijumuisha:\n'
            '• Mbegu bora (k.m. Red Creole / Bombay Red): ~Tsh 200,000\n'
            '• Mbolea (DAP, CAN & NPK): ~Tsh 380,000\n'
            '• Dawa za ukungu na wadudu: ~Tsh 200,000\n'
            '• Vibarua na palizi: ~Tsh 320,000\n\n'
            'Mavuno tarajiwa ni gunia 100 - 150 zenye thamani ya Tsh 12,000,000 hadi 18,000,000 sokoni!';
      } else {
        replyText =
            'Nimepokea swali lako vizuri kuhusu "$text".\n\n'
            'Kama msaidizi wako wa AI ya kilimo, nakushauri kuhakikisha unazingatia afya ya udongo, mbegu bora zilizoidhinishwa (TOSCI), na ratiba sahihi ya unyevu.\n\n'
            'Unaweza pia kuangalia sehemu ya Miongozo au Kikokotoo cha Faida kwa mahesabu zaidi.';
      }

      setState(() {
        _isReplying = false;
        _messages.add(
          AiChatMessage(
            id: 'ai-${DateTime.now().microsecondsSinceEpoch}',
            text: replyText,
            isUser: false,
            timestamp: 'Sasa hivi',
            suggestedActions: [
              'Angalia maduka ya pembejeo',
              'Hesabu faida kwenye Kikokotoo',
              'Fungua kalenda ya shamba',
            ],
          ),
        );
      });
      _scrollToBottom();
    });
  }

  void _attachSampleImage() {
    setState(() {
      _pendingAttachment = 'assets/images/vegetables.jpg';
    });
    showAppSnack(
      context,
      'Picha ya mmea imeambatanishwa tayari kwa uchambuzi wa AI',
      icon: Icons.image_rounded,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: AppColors.secondary,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.auto_awesome_rounded,
                size: 16,
                color: AppColors.primaryDeep,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Mkulima AI Assistant', style: TextStyle(fontSize: 16)),
                Text(
                  'Ushauri wa Kitaalamu wa Kilimo',
                  style: TextStyle(fontSize: 11, color: AppColors.muted),
                ),
              ],
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Chat history list
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(AppSpacing.page),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final msg = _messages[index];
                  return _ChatMessageBubble(
                    message: msg,
                    onSuggestionTap: (prompt) => _sendMessage(prompt),
                  );
                },
              ),
            ),

            if (_isReplying)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.page),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceAlt,
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(
                            width: 12,
                            height: 12,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Text(
                            'Mkulima AI anachambua...',
                            style: AppText.small.copyWith(color: AppColors.muted),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

            // Pending attachment preview
            if (_pendingAttachment != null)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: AppSpacing.page),
                padding: const EdgeInsets.all(AppSpacing.xs),
                decoration: BoxDecoration(
                  color: AppColors.surfaceAlt,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                      child: SizedBox(
                        width: 44,
                        height: 44,
                        child: MkImage(asset: _pendingAttachment!),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text('Picha ya mmea imeambatanishwa', style: AppText.small),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, size: 18),
                      onPressed: () => setState(() => _pendingAttachment = null),
                    ),
                  ],
                ),
              ),

            // Input bar
            Container(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.sm,
                AppSpacing.xs,
                AppSpacing.sm,
                AppSpacing.xs,
              ),
              decoration: const BoxDecoration(
                color: AppColors.surface,
                border: Border(top: BorderSide(color: AppColors.line)),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.camera_alt_outlined),
                    color: AppColors.primary,
                    tooltip: 'Pakia picha ya mmea kwa AI',
                    onPressed: _attachSampleImage,
                  ),
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: const InputDecoration(
                        hintText: 'Uliza swali lolote la kilimo...',
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                        ),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send_rounded),
                    color: AppColors.primary,
                    onPressed: () => _sendMessage(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatMessageBubble extends StatelessWidget {
  const _ChatMessageBubble({
    required this.message,
    required this.onSuggestionTap,
  });

  final AiChatMessage message;
  final ValueChanged<String> onSuggestionTap;

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Column(
        crossAxisAlignment:
            isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment:
                isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isUser) ...[
                Container(
                  width: 32,
                  height: 32,
                  margin: const EdgeInsets.only(right: AppSpacing.xs),
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.auto_awesome_rounded,
                    size: 16,
                    color: AppColors.secondary,
                  ),
                ),
              ],
              Flexible(
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: isUser ? AppColors.primary : AppColors.surfaceAlt,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(AppRadius.lg),
                      topRight: const Radius.circular(AppRadius.lg),
                      bottomLeft: isUser
                          ? const Radius.circular(AppRadius.lg)
                          : const Radius.circular(2),
                      bottomRight: isUser
                          ? const Radius.circular(2)
                          : const Radius.circular(AppRadius.lg),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (message.attachedImage != null) ...[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(AppRadius.md),
                          child: SizedBox(
                            height: 120,
                            width: 180,
                            child: MkImage(asset: message.attachedImage!),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                      ],
                      Text(
                        message.text,
                        style: AppText.body.copyWith(
                          color: isUser ? Colors.white : AppColors.ink,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (message.suggestedActions != null &&
              message.suggestedActions!.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xs,
              children: [
                for (final action in message.suggestedActions!)
                  ActionChip(
                    label: Text(action, style: const TextStyle(fontSize: 12)),
                    backgroundColor: AppColors.surface,
                    side: const BorderSide(color: AppColors.primarySoft),
                    onPressed: () => onSuggestionTap(action),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
