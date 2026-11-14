import 'package:flutter/material.dart';
import '../models/event_item.dart';
import '../models/registration_ticket.dart';

class EventRegistrationScreen extends StatefulWidget {
  final EventItem event;
  final Function(RegistrationTicket) onRegistered;

  const EventRegistrationScreen({Key? key, required this.event, required this.onRegistered}) : super(key: key);

  @override
  State<EventRegistrationScreen> createState() => _EventRegistrationScreenState();
}

class _EventRegistrationScreenState extends State<EventRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _nimController = TextEditingController();
  final _emailController = TextEditingController();
  final _whatsappController = TextEditingController();

  String _participantType = 'Mahasiswa';
  String _selectedDate = '';
  String _seminarKit = 'Standar (Sertifikat & Modul PDF)';
  double _donation = 0.0;
  bool _agreeTerms = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.event.date;
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2026),
      lastDate: DateTime(2027),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = "${picked.day} ${_getMonthName(picked.month)} ${picked.year}";
      });
    }
  }

  String _getMonthName(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Ags', 'Sep', 'Okt', 'Nov', 'Des'];
    return months[month - 1];
  }

  void _submitForm() {
    if (_formKey.currentState!.validate() && _agreeTerms) {
      setState(() => _isLoading = true);

      Future.delayed(const Duration(seconds: 2), () {
        setState(() => _isLoading = false);

        final ticket = RegistrationTicket(
          id: 'TICKET-${DateTime.now().millisecondsSinceEpoch}',
          eventTitle: widget.event.title,
          name: _nameController.text,
          nim: _nimController.text,
          email: _emailController.text,
          whatsapp: _whatsappController.text,
          participantType: _participantType,
          attendanceDate: _selectedDate,
          seminarKit: _seminarKit,
          donation: _donation,
          registeredAt: DateTime.now(),
        );

        widget.onRegistered(ticket);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pendaftaran Berhasil! Tiket Anda telah diterbitkan.'), backgroundColor: Colors.green),
        );

        Navigator.pop(context);
      });
    } else if (!_agreeTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Anda harus menyetujui tata tertib acara.'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Daftar: ${widget.event.title}')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'Nama Lengkap', border: OutlineInputBorder()),
                      validator: (v) => v == null || v.isEmpty ? 'Nama wajib diisi' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _nimController,
                      decoration: const InputDecoration(labelText: 'NIM / Nomor Identitas', border: OutlineInputBorder()),
                      validator: (v) => v == null || v.isEmpty ? 'NIM wajib diisi' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
                      validator: (v) => v == null || !v.contains('@') ? 'Email tidak valid' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _whatsappController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(labelText: 'Nomor WhatsApp', border: OutlineInputBorder()),
                      validator: (v) => v == null || v.isEmpty ? 'Nomor WhatsApp wajib diisi' : null,
                    ),
                    const SizedBox(height: 16),
                    const Text('Tipe Peserta:', style: TextStyle(fontWeight: FontWeight.bold)),
                    DropdownButtonFormField<String>(
                      value: _participantType,
                      items: ['Mahasiswa', 'Dosen', 'Umum'].map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                      onChanged: (val) => setState(() => _participantType = val!),
                      decoration: const InputDecoration(border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(child: Text('Tanggal Kehadiran: $_selectedDate')),
                        ElevatedButton(onPressed: _pickDate, child: const Text('Pilih Tanggal')),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text('Paket Seminar Kit:', style: TextStyle(fontWeight: FontWeight.bold)),
                    ...['Standar (Sertifikat & Modul PDF)', 'Premium (+ Goodie Bag & Kaos)'].map((kit) => RadioListTile<String>(
                          title: Text(kit),
                          value: kit,
                          groupValue: _seminarKit,
                          onChanged: (val) => setState(() => _seminarKit = val!),
                        )),
                    const SizedBox(height: 16),
                    Text('Donasi Sukarela: Rp ${_donation.toStringAsFixed(0)}'),
                    Slider(
                      value: _donation,
                      min: 0,
                      max: 50000,
                      divisions: 5,
                      label: 'Rp ${_donation.toStringAsFixed(0)}',
                      onChanged: (val) => setState(() => _donation = val),
                    ),
                    CheckboxListTile(
                      title: const Text('Saya menyetujui seluruh tata tertib dan ketentuan acara.'),
                      value: _agreeTerms,
                      onChanged: (val) => setState(() => _agreeTerms = val!),
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
                        onPressed: _submitForm,
                        child: const Text('Konfirmasi Pendaftaran', style: TextStyle(fontSize: 16)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}