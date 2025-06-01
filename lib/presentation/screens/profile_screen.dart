import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Warna dari palet yang telah kita sepakati
  final Color backgroundColor = const Color(0xFFF5F7FA);
  final Color cardColor = const Color(0xFFFFFFFF);
  final Color accentColor = const Color(0xFFFF7043);
  final Color textColor = const Color(0xFF212121);
  final Color iconColor = const Color(0xFFFF7043);
  final Color listTileIconColor = Colors.grey.shade600;

  // Data pengguna dummy (nantinya akan diambil dari state atau database)
  final String userName = "Pengguna SnapCook";
  final String userEmail = "pengguna@snapcook.com";
  final String userProfileImageUrl =
      ""; // Kosongkan untuk placeholder, atau isi URL jika ada

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          'Profil Saya',
          style: TextStyle(
            color: accentColor,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        backgroundColor: backgroundColor,
        elevation: 0,
        centerTitle: false,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        children: [
          _buildProfileHeader(),
          const SizedBox(height: 24),
          _buildProfileMenuItem(
            icon: Icons.edit_outlined,
            title: 'Edit Profil',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Fitur "Edit Profil" belum diimplementasikan.'),
                ),
              );
            },
          ),
          _buildProfileMenuItem(
            icon: Icons.bookmark_border_outlined,
            title: 'Resep Disimpan',
            onTap: () {
              // Navigasi ke halaman koleksi jika berbeda atau filter khusus
              // Untuk contoh ini, kita anggap sama dengan tab Koleksi
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Lihat tab "Koleksi" untuk resep disimpan.'),
                ),
              );
            },
          ),
          _buildProfileMenuItem(
            icon: Icons.notifications_none_outlined,
            title: 'Pengaturan Notifikasi',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Fitur "Pengaturan Notifikasi" belum diimplementasikan.',
                  ),
                ),
              );
            },
          ),
          _buildProfileMenuItem(
            icon: Icons.settings_outlined,
            title: 'Pengaturan Aplikasi',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Fitur "Pengaturan Aplikasi" belum diimplementasikan.',
                  ),
                ),
              );
            },
          ),
          _buildProfileMenuItem(
            icon: Icons.info_outline_rounded,
            title: 'Tentang Aplikasi',
            onTap: () {
              // Tampilkan dialog atau halaman tentang aplikasi
              showDialog(
                context: context,
                builder:
                    (context) => AlertDialog(
                      title: const Text('Tentang Snap Cook'),
                      content: const Text(
                        'Snap Cook v1.0.0\nAplikasi untuk menemukan resep berdasarkan bahan makanan dari foto.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(
                            'Tutup',
                            style: TextStyle(color: accentColor),
                          ),
                        ),
                      ],
                    ),
              );
            },
          ),
          const Divider(height: 32, thickness: 1, indent: 16, endIndent: 16),
          _buildProfileMenuItem(
            icon: Icons.logout_rounded,
            title: 'Logout',
            isLogout: true,
            onTap: () {
              // Implementasi logika logout
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Logout'),
                    content: const Text('Apakah Anda yakin ingin keluar?'),
                    actions: <Widget>[
                      TextButton(
                        child: Text(
                          'Batal',
                          style: TextStyle(color: textColor.withOpacity(0.7)),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: Text(
                          'Logout',
                          style: TextStyle(
                            color: Colors.red.shade700,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop(); // Tutup dialog
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/login',
                            (Route<dynamic> route) => false,
                          );
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: accentColor.withOpacity(0.2),
            backgroundImage:
                userProfileImageUrl.isNotEmpty
                    ? NetworkImage(userProfileImageUrl)
                    : null, // Placeholder jika tidak ada gambar
            child:
                userProfileImageUrl.isEmpty
                    ? Icon(
                      Icons.person_outline_rounded,
                      size: 45,
                      color: accentColor,
                    )
                    : null,
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userName,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  userEmail,
                  style: TextStyle(
                    fontSize: 14,
                    color: textColor.withOpacity(0.7),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isLogout = false,
  }) {
    return Material(
      color:
          Colors
              .transparent, // Agar ripple effect terlihat baik di atas backgroundColor
      child: InkWell(
        onTap: onTap,
        splashColor: accentColor.withOpacity(0.1),
        highlightColor: accentColor.withOpacity(0.05),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Row(
            children: [
              Icon(
                icon,
                color: isLogout ? Colors.red.shade600 : listTileIconColor,
                size: 24,
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    color: isLogout ? Colors.red.shade700 : textColor,
                    fontWeight: isLogout ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
              if (!isLogout)
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: Colors.grey.shade400,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
