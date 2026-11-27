import 'package:material_ui/material_ui.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../core/utils/ui_helpers.dart';
import '../../core/widgets/badges.dart';
import '../../core/widgets/mk_button.dart';
import '../../core/widgets/mk_card.dart';
import '../../data/models/business_tools.dart';
import '../../data/seed/business_tools_seed.dart';

class AgriReceiptsScreen extends StatefulWidget {
  const AgriReceiptsScreen({super.key});

  @override
  State<AgriReceiptsScreen> createState() => _AgriReceiptsScreenState();
}

class _AgriReceiptsScreenState extends State<AgriReceiptsScreen> {
  late List<AgriReceipt> _receipts;

  @override
  void initState() {
    super.initState();
    _receipts = List.from(initialReceiptsSeed);
  }

  void _createNewReceipt() {
    showAppSheet(
      context,
      child: _NewReceiptSheet(
        onCreated: (newReceipt) {
          setState(() {
            _receipts.insert(0, newReceipt);
          });
          showAppSnack(
            context,
            'Risiti #${newReceipt.receiptNumber} imetengenezwa kikamilifu',
            icon: Icons.check_circle_outline_rounded,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final totalSales = _receipts.fold<double>(0, (sum, r) => sum + r.totalAmount);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Risiti na Mauzo'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'create-receipt-fab',
        onPressed: _createNewReceipt,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Toa Risiti'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.page,
          AppSpacing.sm,
          AppSpacing.page,
          100,
        ),
        children: [
          // Total revenue overview card
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              gradient: AppColors.heroGradient,
              borderRadius: BorderRadius.circular(AppRadius.xl),
              boxShadow: AppShadows.floating,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Jumla ya Mauzo Yaliyothibitishwa',
                      style: AppText.small.copyWith(color: Colors.white70),
                    ),
                    const MkPill(
                      label: 'Daftari Rasmi',
                      foreground: AppColors.primaryDeep,
                      background: AppColors.secondary,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  formatTsh(totalSales),
                  style: AppText.display.copyWith(
                    color: Colors.white,
                    fontSize: 32,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${_receipts.length} risiti zimetolewa mwezi huu',
                  style: AppText.small.copyWith(color: Colors.white70),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Orodha ya Risiti', style: AppText.h2),
              Text(
                '${_receipts.length} Zilizotolewa',
                style: AppText.small,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          for (final rcpt in _receipts) ...[
            _ReceiptTile(
              receipt: rcpt,
              onTap: () => pushScreen(context, _ReceiptDetailPage(receipt: rcpt)),
            ),
            const SizedBox(height: AppSpacing.md),
          ],
        ],
      ),
    );
  }
}

class _ReceiptTile extends StatelessWidget {
  const _ReceiptTile({required this.receipt, required this.onTap});

  final AgriReceipt receipt;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return MkCard(
      onTap: onTap,
      shadow: AppShadows.soft,
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                receipt.receiptNumber,
                style: AppText.bodyStrong.copyWith(color: AppColors.primaryDark),
              ),
              MkPill(
                label: receipt.paymentMethod,
                foreground: AppColors.ink,
                background: AppColors.surfaceAlt,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(receipt.productName, style: AppText.h3),
          const SizedBox(height: 2),
          Text(
            'Mteja: ${receipt.customerName} · ${receipt.quantity.toInt()} ${receipt.unit}',
            style: AppText.small,
          ),
          const Divider(height: AppSpacing.lg),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(receipt.date, style: AppText.small),
              Text(
                formatTsh(receipt.totalAmount),
                style: AppText.h3.copyWith(color: AppColors.primaryDeep),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ReceiptDetailPage extends StatelessWidget {
  const _ReceiptDetailPage({required this.receipt});

  final AgriReceipt receipt;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Risiti #${receipt.receiptNumber}')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.page),
        child: Column(
          children: [
            MkCard(
              shadow: AppShadows.soft,
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.receipt_long_rounded,
                    size: 48,
                    color: AppColors.primary,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text('RISITI YA MAUZO YA SHAMBA', style: AppText.bodyStrong),
                  Text('Mkulima Digital Platform', style: AppText.small),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    receipt.receiptNumber,
                    style: AppText.h2.copyWith(color: AppColors.primaryDark),
                  ),
                  Text('Tarehe: ${receipt.date}', style: AppText.small),
                  const Divider(height: AppSpacing.xl),

                  // Customer details
                  _DetailRow(label: 'Mteja:', value: receipt.customerName),
                  _DetailRow(label: 'Simu ya Mteja:', value: receipt.customerPhone),
                  _DetailRow(label: 'Zao / Bidhaa:', value: receipt.productName),
                  _DetailRow(
                    label: 'Kiasi:',
                    value: '${receipt.quantity.toInt()} ${receipt.unit}',
                  ),
                  _DetailRow(
                    label: 'Bei kwa kipimo:',
                    value: formatTsh(receipt.unitPrice),
                  ),
                  _DetailRow(label: 'Njia ya Malipo:', value: receipt.paymentMethod),
                  _DetailRow(label: 'Hali ya Malipo:', value: receipt.status),
                  const Divider(height: AppSpacing.xl),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('JUMLA KUU:', style: AppText.h2),
                      Text(
                        formatTsh(receipt.totalAmount),
                        style: AppText.h2.copyWith(color: AppColors.primaryDeep),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Row(
              children: [
                Expanded(
                  child: MkButton(
                    label: 'Tuma kwa SMS / WhatsApp',
                    icon: Icons.share_rounded,
                    onPressed: () {
                      showAppSnack(
                        context,
                        'Risiti #${receipt.receiptNumber} imeshirikiwa kwa ${receipt.customerName}',
                        icon: Icons.send_rounded,
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppText.small),
          Text(value, style: AppText.bodyStrong),
        ],
      ),
    );
  }
}

class _NewReceiptSheet extends StatefulWidget {
  const _NewReceiptSheet({required this.onCreated});

  final ValueChanged<AgriReceipt> onCreated;

  @override
  State<_NewReceiptSheet> createState() => _NewReceiptSheetState();
}

class _NewReceiptSheetState extends State<_NewReceiptSheet> {
  final _customerName = TextEditingController();
  final _customerPhone = TextEditingController();
  final _productName = TextEditingController(text: 'Mahindi Chotara');
  final _quantity = TextEditingController(text: '10');
  final _unitPrice = TextEditingController(text: '65000');
  String _unit = 'Gunia (100kg)';
  String _paymentMethod = 'M-Pesa';

  @override
  void dispose() {
    _customerName.dispose();
    _customerPhone.dispose();
    _productName.dispose();
    _quantity.dispose();
    _unitPrice.dispose();
    super.dispose();
  }

  void _save() {
    final qty = double.tryParse(_quantity.text.trim()) ?? 0;
    final price = double.tryParse(_unitPrice.text.replaceAll(',', '').trim()) ?? 0;

    if (_customerName.text.trim().isEmpty || qty <= 0 || price <= 0) {
      showAppSnack(
        context,
        'Weka jina la mteja, kiasi na bei sahihi',
        isError: true,
      );
      return;
    }

    final newReceipt = AgriReceipt(
      id: 'rcpt-${DateTime.now().microsecondsSinceEpoch}',
      receiptNumber: 'MK-2026-${(DateTime.now().millisecond % 900) + 100}',
      customerName: _customerName.text.trim(),
      customerPhone: _customerPhone.text.trim().isEmpty ? '0700 000 000' : _customerPhone.text.trim(),
      productName: _productName.text.trim(),
      quantity: qty,
      unit: _unit,
      unitPrice: price,
      totalAmount: qty * price,
      paymentMethod: _paymentMethod,
      date: 'Leo',
      status: 'Imelipwa',
    );

    widget.onCreated(newReceipt);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.page,
          0,
          AppSpacing.page,
          AppSpacing.xxl,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SheetHandle(),
            const SizedBox(height: AppSpacing.lg),
            const SheetHeader(
              title: 'Toa Risiti Mpya ya Mauzo',
              subtitle: 'Weka taarifa za mnunuzi na mazao yaliyouzwa',
            ),
            const SizedBox(height: AppSpacing.lg),
            TextField(
              controller: _customerName,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(labelText: 'Jina la Mteja / Kampuni'),
            ),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: _customerPhone,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: 'Simu ya Mteja (Hiari)'),
            ),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: _productName,
              decoration: const InputDecoration(labelText: 'Jina la Zao / Bidhaa'),
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _quantity,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Kiasi / Idadi'),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: TextField(
                    controller: _unitPrice,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Bei kwa Kipimo'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            DropdownButtonFormField<String>(
              initialValue: _paymentMethod,
              decoration: const InputDecoration(labelText: 'Njia ya Malipo'),
              items: const [
                DropdownMenuItem(value: 'M-Pesa', child: Text('M-Pesa')),
                DropdownMenuItem(value: 'Tigo Pesa', child: Text('Tigo Pesa')),
                DropdownMenuItem(value: 'Airtel Money', child: Text('Airtel Money')),
                DropdownMenuItem(value: 'Taslimu', child: Text('Taslimu (Cash)')),
                DropdownMenuItem(value: 'Benki (NMB/CRDB)', child: Text('Benki (NMB/CRDB)')),
              ],
              onChanged: (val) {
                if (val != null) setState(() => _paymentMethod = val);
              },
            ),
            const SizedBox(height: AppSpacing.xl),
            MkButton(
              label: 'Thibitisha na Toa Risiti',
              icon: Icons.check_rounded,
              onPressed: _save,
            ),
          ],
        ),
      ),
    );
  }
}
