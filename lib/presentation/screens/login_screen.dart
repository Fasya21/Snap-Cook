import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _rememberMe = false;
  bool _obscurePassword = true;
  final _formKey = GlobalKey<FormState>();

  // Definisi Warna Tema
  // Warna-warna ini dipilih untuk memberikan tampilan yang bersih dan modern
  // dengan aksen yang hangat.
  final Color backgroundColor = const Color(
    0xFFF5F7FA,
  ); // Latar belakang abu-abu muda kebiruan
  final Color cardColor = const Color(0xFFFFFFFF); // Warna kartu putih bersih
  final Color accentColor = const Color(
    0xFFFF7043,
  ); // Warna aksen oranye kemerahan (untuk tombol, link)
  final Color textFieldFillColor = const Color(
    0xFFFFF0E5,
  ); // Warna isian field input yang lebih lembut (turunan dari aksen)
  final Color textColor = const Color(
    0xFF212121,
  ); // Warna teks utama (hitam pekat)
  final Color hintTextColor = Colors.grey.shade500; // Warna teks placeholder
  final Color iconColor = const Color(
    0xFFFF7043,
  ).withOpacity(0.8); // Warna ikon, sedikit transparan dari warna aksen

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(
              24.0,
            ), // Padding seragam di sekitar konten
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // 1. Logo Aplikasi
                  // Pastikan file 'assets/snapcook_logo.png' ada di proyek Anda
                  // dan sudah didaftarkan di pubspec.yaml
                  ClipOval(
                    child: Image.asset(
                      'assets/snapcook_logo.png', // GANTI DENGAN PATH LOGO ANDA
                      height: 100, // Ukuran logo disesuaikan
                      width: 100,
                      fit: BoxFit.cover,
                      // Error builder jika logo tidak ditemukan
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.food_bank_outlined, // Icon placeholder
                            size: 50,
                            color: Colors.grey[700],
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 2. Judul Aplikasi
                  Text(
                    'Snap Cook',
                    style: TextStyle(
                      fontSize: 32, // Ukuran font judul
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // 3. Card untuk Form Input
                  Container(
                    padding: const EdgeInsets.all(
                      24.0,
                    ), // Padding di dalam card
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(
                        20,
                      ), // Border radius card
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(
                            0.08,
                          ), // Bayangan lebih halus
                          blurRadius: 15,
                          spreadRadius: 2,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Input Field Email
                        TextFormField(
                          style: TextStyle(color: textColor, fontSize: 16),
                          decoration: InputDecoration(
                            hintText: 'Email',
                            hintStyle: TextStyle(color: hintTextColor),
                            prefixIcon: Icon(
                              Icons.email_outlined,
                              color: iconColor,
                            ),
                            filled: true,
                            fillColor: textFieldFillColor,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  BorderSide.none, // Tidak ada border luar
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 18,
                              horizontal: 16,
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Email tidak boleh kosong';
                            }
                            if (!RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                            ).hasMatch(value)) {
                              return 'Masukkan format email yang valid';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),

                        // Input Field Password
                        TextFormField(
                          obscureText: _obscurePassword,
                          style: TextStyle(color: textColor, fontSize: 16),
                          decoration: InputDecoration(
                            hintText: 'Password',
                            hintStyle: TextStyle(color: hintTextColor),
                            prefixIcon: Icon(
                              Icons.lock_outline,
                              color: iconColor,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: iconColor,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                            filled: true,
                            fillColor: textFieldFillColor,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 18,
                              horizontal: 16,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Password tidak boleh kosong';
                            }
                            if (value.length < 6) {
                              // Contoh validasi panjang password
                              return 'Password minimal 6 karakter';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Baris "Remember me" & "Forgot Password?"
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: Checkbox(
                                    value: _rememberMe,
                                    onChanged: (bool? val) {
                                      setState(() {
                                        _rememberMe =
                                            val ??
                                            false; // Lebih aman dengan null check
                                      });
                                    },
                                    activeColor: accentColor,
                                    checkColor: Colors.white, // Warna centang
                                    side: BorderSide(
                                      color: Colors.grey.shade400,
                                      width: 1.5,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _rememberMe = !_rememberMe;
                                    });
                                  },
                                  child: Text(
                                    "Remember me",
                                    style: TextStyle(
                                      color: textColor,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            TextButton(
                              onPressed: () {
                                // TODO: Implementasi logika "Forgot Password?"
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Fitur "Forgot Password?" belum ada.',
                                    ),
                                  ),
                                );
                              },
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: const Size(
                                  50,
                                  30,
                                ), // Agar area tap tidak terlalu kecil
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                alignment: Alignment.centerRight,
                              ),
                              child: Text(
                                "Forgot Password?",
                                style: TextStyle(
                                  color: accentColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Tombol "Log in"
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: accentColor,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 3, // Sedikit elevasi untuk tombol
                            ),
                            onPressed: () {
                              if (_formKey.currentState?.validate() ?? false) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Login Berhasil! Mengarahkan ke Home...',
                                    ),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                                // Navigasi ke HomeScreen setelah login berhasil
                                Navigator.pushReplacementNamed(
                                  context,
                                  '/home',
                                ); // Gunakan pushReplacementNamed agar pengguna tidak bisa kembali ke login screen dengan tombol back
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Harap isi semua field dengan benar.',
                                    ),
                                    backgroundColor: Colors.redAccent,
                                  ),
                                );
                              }
                              // if (_formKey.currentState?.validate() ?? false) {
                              //   // TODO: Implementasi Logika Login Sebenarnya
                              //   ScaffoldMessenger.of(context).showSnackBar(
                              //     const SnackBar(
                              //       content: Text('Login Berhasil (Simulasi)'),
                              //       backgroundColor: Colors.green,
                              //     ),
                              //   );
                              //   // Contoh navigasi:
                              //   // Navigator.pushReplacementNamed(context, '/home');
                              // } else {
                              //   ScaffoldMessenger.of(context).showSnackBar(
                              //     const SnackBar(
                              //       content: Text(
                              //         'Harap isi semua field dengan benar.',
                              //       ),
                              //       backgroundColor: Colors.redAccent,
                              //     ),
                              //   );
                              // }
                            },
                            child: const Text(
                              "Log in",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Tautan "Sign up"
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: TextStyle(
                          color: textColor.withOpacity(0.8),
                          fontSize: 15,
                        ),
                      ),
                      TextButton(
                        // Menggunakan TextButton untuk semantik yang lebih baik
                        onPressed: () {
                          // TODO: Navigasi ke halaman Sign Up
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Navigasi ke halaman "Sign Up" belum ada.',
                              ),
                            ),
                          );
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 2,
                          ),
                          minimumSize: const Size(50, 30),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          "Sign up",
                          style: TextStyle(
                            color: accentColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            decoration: TextDecoration.underline,
                            decorationColor: accentColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
