import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/address.dart';
import '../../providers/address_provider.dart';
import '../../providers/language_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';

class AddressScreen extends StatelessWidget {
  const AddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final addrP = context.watch<AddressProvider>();
    final l10n  = context.watch<LanguageProvider>().l10n;
    final c     = context.col;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.deliveryAddress),
        leading: _BackBtn(),
        actions: [
          if (addrP.canAdd)
            TextButton.icon(
              onPressed: () => _showAddSheet(context),
              icon: const Icon(Icons.add_rounded,
                  color: AppTheme.primaryGreen, size: 18),
              label: const Text('Add',
                  style: TextStyle(
                      color: AppTheme.primaryGreen,
                      fontWeight: FontWeight.w600)),
            ),
        ],
      ),
      body: addrP.addresses.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.location_on_outlined,
                      size: 64, color: c.textMuted),
                  const SizedBox(height: 16),
                  Text('No addresses saved',
                      style: TextStyle(
                          color: c.textPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Text('Add up to 5 delivery addresses',
                      style: TextStyle(
                          color: c.textSecondary, fontSize: 14)),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => _showAddSheet(context),
                    icon: const Icon(Icons.add_rounded, size: 18),
                    label: const Text('Add Address'),
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size(180, 46)),
                  ),
                ],
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                ...addrP.addresses.map((addr) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _AddressCard(
                    address:  addr,
                    selected: addrP.selectedId == addr.id,
                    onSelect: () => addrP.selectAddress(addr.id),
                    onDelete: () => addrP.removeAddress(addr.id),
                  ),
                )),
                if (addrP.canAdd)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: OutlinedButton.icon(
                      onPressed: () => _showAddSheet(context),
                      icon: const Icon(Icons.add_rounded,
                          color: AppTheme.primaryGreen, size: 18),
                      label: Text(
                        'Add Address '
                        '(${addrP.addresses.length}/${AddressProvider.maxAddresses})',
                        style: const TextStyle(
                            color: AppTheme.primaryGreen),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                            color: AppTheme.primaryGreen),
                        minimumSize: const Size(double.infinity, 48),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
              ],
            ),
    );
  }

  void _showAddSheet(BuildContext context) => showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => const _AddAddressSheet(),
      );
}

class _AddressCard extends StatelessWidget {
  final Address      address;
  final bool         selected;
  final VoidCallback onSelect;
  final VoidCallback onDelete;
  const _AddressCard({
    required this.address, required this.selected,
    required this.onSelect, required this.onDelete,
  });

  IconData get _icon => switch (address.label) {
    'Work'  => Icons.work_outline_rounded,
    'Other' => Icons.place_outlined,
    _       => Icons.home_outlined,
  };

  @override
  Widget build(BuildContext context) {
    final c = context.col;
    return GestureDetector(
      onTap: onSelect,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color:  selected
              ? AppTheme.primaryGreen.withOpacity(0.06)
              : c.cardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected
                ? AppTheme.primaryGreen.withOpacity(0.4)
                : c.divider,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 38, height: 38,
              decoration: BoxDecoration(
                color: selected
                    ? AppTheme.primaryGreen.withOpacity(0.12)
                    : c.surfaceHigh,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(_icon,
                  color: selected
                      ? AppTheme.primaryGreen
                      : c.textMuted,
                  size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: selected
                            ? AppTheme.primaryGreen.withOpacity(0.12)
                            : c.surfaceHigh,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(address.label,
                          style: TextStyle(
                            color: selected
                                ? AppTheme.primaryGreen
                                : c.textMuted,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          )),
                    ),
                    if (selected) ...[
                      const SizedBox(width: 6),
                      const Icon(Icons.check_circle_rounded,
                          color: AppTheme.primaryGreen, size: 14),
                    ],
                  ]),
                  const SizedBox(height: 6),
                  Text(address.fullName,
                      style: TextStyle(
                          color: c.textPrimary,
                          fontWeight: FontWeight.w600,
                          fontSize: 14)),
                  const SizedBox(height: 2),
                  Text(address.line1,
                      style: TextStyle(
                          color: c.textSecondary, fontSize: 13)),
                  Text('${address.city}, ${address.state} - ${address.pincode}',
                      style: TextStyle(
                          color: c.textSecondary, fontSize: 13)),
                  const SizedBox(height: 2),
                  Text(address.phone,
                      style: TextStyle(
                          color: c.textMuted, fontSize: 12)),
                ],
              ),
            ),
            IconButton(
              onPressed: onDelete,
              icon: const Icon(Icons.delete_outline_rounded,
                  color: AppTheme.error, size: 18),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddAddressSheet extends StatefulWidget {
  const _AddAddressSheet();
  @override
  State<_AddAddressSheet> createState() => _AddAddressSheetState();
}

class _AddAddressSheetState extends State<_AddAddressSheet> {
  final _formKey = GlobalKey<FormState>();
  String _label  = 'Home';
  final _name    = TextEditingController();
  final _phone   = TextEditingController();
  final _line1   = TextEditingController();
  final _city    = TextEditingController();
  final _st      = TextEditingController();
  final _pin     = TextEditingController();

  @override
  void dispose() {
    _name.dispose(); _phone.dispose(); _line1.dispose();
    _city.dispose(); _st.dispose(); _pin.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    context.read<AddressProvider>().addAddress(Address(
      id:       DateTime.now().millisecondsSinceEpoch.toString(),
      label:    _label,
      fullName: _name.text.trim(),
      phone:    _phone.text.trim(),
      line1:    _line1.text.trim(),
      city:     _city.text.trim(),
      state:    _st.text.trim(),
      pincode:  _pin.text.trim(),
    ));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final c = context.col;
    return Container(
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius:
            const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.fromLTRB(
          20, 16, 20,
          MediaQuery.of(context).viewInsets.bottom + 20),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 40, height: 4,
                  decoration: BoxDecoration(
                      color: c.divider,
                      borderRadius: BorderRadius.circular(2)),
                ),
              ),
              const SizedBox(height: 16),
              Text('Add Delivery Address',
                  style: TextStyle(
                      color: c.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.w700)),
              const SizedBox(height: 16),
              // Label chips
              Row(
                children: ['Home', 'Work', 'Other'].map((lbl) =>
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () => setState(() => _label = lbl),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 7),
                        decoration: BoxDecoration(
                          color: _label == lbl
                              ? AppTheme.primaryGreen
                              : c.surfaceHigh,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: _label == lbl
                                ? AppTheme.primaryGreen
                                : c.divider,
                          ),
                        ),
                        child: Text(lbl,
                            style: TextStyle(
                              color: _label == lbl
                                  ? Colors.white
                                  : c.textSecondary,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            )),
                      ),
                    ),
                  )).toList(),
              ),
              const SizedBox(height: 16),
              _Field('Full Name', _name,
                  Icons.person_outline_rounded),
              const SizedBox(height: 10),
              _Field('Phone Number', _phone,
                  Icons.phone_outlined,
                  type: TextInputType.phone),
              const SizedBox(height: 10),
              _Field('Address Line 1', _line1,
                  Icons.home_outlined),
              const SizedBox(height: 10),
              Row(children: [
                Expanded(
                    child: _Field('City', _city,
                        Icons.location_city_outlined)),
                const SizedBox(width: 10),
                Expanded(
                    child: _Field('State', _st,
                        Icons.map_outlined)),
              ]),
              const SizedBox(height: 10),
              _Field('Pincode', _pin, Icons.pin_outlined,
                  type: TextInputType.number),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _save,
                  child: const Text('Save Address'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  final String                hint;
  final TextEditingController ctrl;
  final IconData              icon;
  final TextInputType         type;
  const _Field(this.hint, this.ctrl, this.icon,
      {this.type = TextInputType.text});

  @override
  Widget build(BuildContext context) => TextFormField(
        controller:   ctrl,
        keyboardType: type,
        validator: (v) =>
            (v == null || v.trim().isEmpty) ? 'Required' : null,
        decoration: InputDecoration(
          hintText:   hint,
          prefixIcon: Icon(icon, size: 18),
          isDense:    true,
        ),
      );
}

class _BackBtn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final c = context.col;
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: c.surfaceHigh,
            borderRadius: BorderRadius.circular(10)),
        child: Icon(Icons.arrow_back_ios_new_rounded,
            size: 16, color: c.textPrimary),
      ),
    );
  }
}