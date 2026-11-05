import 'package:flutter/material.dart';

// Palet warna retro
const kCream = Color(0xFFF4E9D0);
const kPaper = Color(0xFFFFF8E7);
const kBrown = Color(0xFF3E2723);
const kOrange = Color(0xFFD9534F);
const kMustard = Color(0xFFE9A820);
const kTeal = Color(0xFF2A9D8F);

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Formulir Pendaftaran Kegiatan',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'monospace',
        colorSchemeSeed: kOrange,
        scaffoldBackgroundColor: kCream,
        textTheme: ThemeData.light().textTheme.apply(
              bodyColor: kBrown,
              displayColor: kBrown,
            ),
        checkboxTheme: CheckboxThemeData(
          side: const BorderSide(color: kBrown, width: 2),
          fillColor: WidgetStateProperty.resolveWith(
            (s) => s.contains(WidgetState.selected) ? kTeal : Colors.transparent,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: kPaper,
          labelStyle: const TextStyle(color: kBrown),
          prefixIconColor: kBrown,
          suffixIconColor: kBrown,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: const BorderSide(color: kBrown, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: const BorderSide(color: kBrown, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: const BorderSide(color: kTeal, width: 3),
          ),
        ),
        dialogTheme: DialogThemeData(
          backgroundColor: kPaper,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
            side: const BorderSide(color: kBrown, width: 3),
          ),
        ),
      ),
      home: const FormPendaftaranPage(),
    );
  }
}

class FormPendaftaranPage extends StatefulWidget {
  const FormPendaftaranPage({super.key});

  @override
  State<FormPendaftaranPage> createState() => _FormPendaftaranPageState();
}

class _FormPendaftaranPageState extends State<FormPendaftaranPage> {
  final _formKey = GlobalKey<FormState>();

  final _namaCtrl = TextEditingController();
  final _nimCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  bool _hidePass = true;
  String? _gender;
  final Map<String, bool> _hobi = {
    'Membaca': false,
    'Musik': false,
    'Olahraga': false,
    'Fotografi': false,
  };
  String? _prodi;
  bool _setuju = false;

  final List<String> _prodiList = const [
    'Pendidikan TI',
    'Teknik Informatika',
    'Sistem Informasi',
    'Pendidikan Matematika',
    'Pendidikan Bahasa Inggris',
  ];

  @override
  void dispose() {
    _namaCtrl.dispose();
    _nimCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  // ---------- Validator ----------
  String? _validasiNama(String? v) =>
      (v == null || v.trim().isEmpty) ? 'Nama lengkap wajib diisi' : null;

  String? _validasiNim(String? v) {
    if (v == null || v.trim().isEmpty) return 'NIM wajib diisi';
    if (!RegExp(r'^\d+$').hasMatch(v.trim())) return 'NIM harus berupa angka';
    if (v.trim().length < 8) return 'NIM minimal 8 digit';
    return null;
  }

  String? _validasiEmail(String? v) {
    if (v == null || v.trim().isEmpty) return 'Email wajib diisi';
    final regex = RegExp(r'^[\w.+-]+@[\w-]+(\.[\w-]+)+$');
    if (!regex.hasMatch(v.trim())) return 'Format email tidak valid';
    return null;
  }

  String? _validasiPassword(String? v) {
    if (v == null || v.isEmpty) return 'Password wajib diisi';
    if (v.length < 8) return 'Password minimal 8 karakter';
    return null;
  }

  // ---------- Simpan ----------
  void _simpan() {
    final valid = _formKey.currentState!.validate();
    if (!valid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Periksa kembali isian formulir Anda')),
      );
      return;
    }
    _formKey.currentState!.save();
    _tampilkanRingkasan();
  }

  void _tampilkanRingkasan() {
    final hobiDipilih =
        _hobi.entries.where((e) => e.value).map((e) => e.key).join(', ');

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.fact_check, color: kOrange),
            SizedBox(width: 8),
            Text('Ringkasan Data'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _baris('Nama Lengkap', _namaCtrl.text.trim()),
              _baris('NIM', _nimCtrl.text.trim()),
              _baris('Email', _emailCtrl.text.trim()),
              _baris('Password', '•' * _passCtrl.text.length),
              _baris('Jenis Kelamin', _gender ?? '-'),
              _baris('Hobi', hobiDipilih),
              _baris('Program Studi', _prodi ?? '-'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              _reset();
            },
            child: const Text('Isi Ulang'),
          ),
        ],
      ),
    );
  }

  Widget _baris(String label, String nilai) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: const TextStyle(fontSize: 12, color: Colors.black54)),
            Text(nilai,
                style: const TextStyle(
                    fontSize: 15, fontWeight: FontWeight.w600)),
          ],
        ),
      );

  void _reset() {
    _formKey.currentState!.reset();
    _namaCtrl.clear();
    _nimCtrl.clear();
    _emailCtrl.clear();
    _passCtrl.clear();
    setState(() {
      _gender = null;
      _hobi.updateAll((key, value) => false);
      _prodi = null;
      _setuju = false;
      _hidePass = true;
    });
  }

  // ---------- UI ----------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kCream,
      appBar: AppBar(
        title: const Text('FORMULIR DATA PENGGUNA',
            style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.5)),
        backgroundColor: kBrown,
        foregroundColor: kMustard,
        leading: const Icon(Icons.assignment),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(6),
          child: Row(children: [
            Expanded(child: ColoredBox(color: kOrange, child: SizedBox(height: 6))),
            Expanded(child: ColoredBox(color: kMustard, child: SizedBox(height: 6))),
            Expanded(child: ColoredBox(color: kTeal, child: SizedBox(height: 6))),
          ]),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Nama lengkap
              TextFormField(
                controller: _namaCtrl,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Nama Lengkap',
                  prefixIcon: Icon(Icons.person),
                ),
                validator: _validasiNama,
              ),
              const SizedBox(height: 14),

              // NIM
              TextFormField(
                controller: _nimCtrl,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'NIM',
                  prefixIcon: Icon(Icons.badge),
                ),
                validator: _validasiNim,
              ),
              const SizedBox(height: 14),

              // Email
              TextFormField(
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                ),
                validator: _validasiEmail,
              ),
              const SizedBox(height: 14),

              // Password
              TextFormField(
                controller: _passCtrl,
                obscureText: _hidePass,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                        _hidePass ? Icons.visibility_off : Icons.visibility),
                    onPressed: () => setState(() => _hidePass = !_hidePass),
                  ),
                ),
                validator: _validasiPassword,
              ),
              const SizedBox(height: 18),

              // Jenis kelamin (Radio)
              FormField<String>(
                validator: (_) =>
                    _gender == null ? 'Pilih jenis kelamin' : null,
                builder: (state) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Jenis Kelamin',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Row(
                      children: [
                        for (final g in ['Laki-laki', 'Perempuan'])
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                setState(() => _gender = g);
                                state.didChange(g);
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    _gender == g
                                        ? Icons.radio_button_checked
                                        : Icons.radio_button_unchecked,
                                    color: kOrange,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(g),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                    if (state.hasError) _errorText(state.errorText!),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // Hobi (Checkbox, boleh lebih dari satu)
              FormField<bool>(
                validator: (_) => _hobi.values.any((v) => v)
                    ? null
                    : 'Pilih minimal satu hobi',
                builder: (state) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text.rich(TextSpan(children: [
                      TextSpan(
                          text: 'Hobi ',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(
                          text: '(boleh lebih dari satu)',
                          style:
                              TextStyle(fontSize: 12, color: Colors.black54)),
                    ])),
                    Wrap(
                      children: _hobi.keys.map((h) {
                        return SizedBox(
                          width: 170,
                          child: CheckboxListTile(
                            dense: true,
                            contentPadding: EdgeInsets.zero,
                            controlAffinity: ListTileControlAffinity.leading,
                            title: Text(h),
                            value: _hobi[h],
                            onChanged: (v) {
                              setState(() => _hobi[h] = v ?? false);
                              state.didChange(v);
                            },
                          ),
                        );
                      }).toList(),
                    ),
                    if (state.hasError) _errorText(state.errorText!),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // Program studi (Dropdown)
              DropdownButtonFormField<String>(
                initialValue: _prodi,
                decoration: const InputDecoration(
                  labelText: 'Program Studi',
                  prefixIcon: Icon(Icons.school),
                ),
                items: _prodiList
                    .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                    .toList(),
                onChanged: (v) => setState(() => _prodi = v),
                validator: (v) => v == null ? 'Pilih program studi' : null,
              ),
              const SizedBox(height: 14),

              // Persetujuan
              FormField<bool>(
                validator: (_) =>
                    _setuju ? null : 'Anda harus menyetujui syarat dan ketentuan',
                builder: (state) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                      title: const Text('Saya menyetujui syarat dan ketentuan'),
                      value: _setuju,
                      onChanged: (v) {
                        setState(() => _setuju = v ?? false);
                        state.didChange(v);
                      },
                    ),
                    if (state.hasError) _errorText(state.errorText!),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Tombol simpan
              SizedBox(
                width: double.infinity,
                height: 50,
                child: FilledButton.icon(
                  onPressed: _simpan,
                  icon: const Icon(Icons.send),
                  label: const Text('SIMPAN',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2)),
                  style: FilledButton.styleFrom(
                    backgroundColor: kOrange,
                    foregroundColor: kPaper,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                      side: const BorderSide(color: kBrown, width: 3),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _errorText(String text) => Padding(
        padding: const EdgeInsets.only(left: 12, top: 4),
        child: Text(text,
            style: TextStyle(
                color: Theme.of(context).colorScheme.error, fontSize: 12)),
      );
}