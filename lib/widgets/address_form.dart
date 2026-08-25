import 'package:flutter/material.dart';

class AddressForm extends StatefulWidget {
  final void Function(
  String name,
  String phone,
  String address,
  String city,
  String postalCode,
)? onSaved;

  const AddressForm({
    super.key,
    this.onSaved,
  });

  @override
  State<AddressForm> createState() => _AddressFormState();
}

class _AddressFormState extends State<AddressForm> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _postalCodeController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _postalCodeController.dispose();

    super.dispose();
  }

 void _saveAddress() {
  if (_formKey.currentState!.validate()) {
    widget.onSaved?.call(
      _nameController.text.trim(),
      _phoneController.text.trim(),
      _addressController.text.trim(),
      _cityController.text.trim(),
      _postalCodeController.text.trim(),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return SafeArea(child:  Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildField(
            controller: _nameController,
            label: 'Full Name',
            hint: 'Enter your full name',
            icon: Icons.person_outline,
          ),

          const SizedBox(height: 14),

          _buildField(
            controller: _phoneController,
            label: 'Phone Number',
            hint: 'Enter your phone number',
            icon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
          ),

          const SizedBox(height: 14),

          _buildField(
            controller: _addressController,
            label: 'Address',
            hint: 'House / Street / Area',
            icon: Icons.location_on_outlined,
            maxLines: 2,
          ),

          const SizedBox(height: 14),

          _buildField(
            controller: _cityController,
            label: 'City',
            hint: 'Enter your city',
            icon: Icons.location_city_outlined,
          ),

          const SizedBox(height: 14),

          _buildField(
            controller: _postalCodeController,
            label: 'Postal Code',
            hint: 'Enter postal code',
            icon: Icons.markunread_mailbox_outlined,
            keyboardType: TextInputType.number,
          ),

          const SizedBox(height: 22),

          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: _saveAddress,
              icon: const Icon(
                Icons.check_rounded,
                size: 20,
              ),
              label: const Text(
                'Save Address',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter $label';
        }

        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
      ),
    );
  }
}