import 'package:flutter/material.dart';
import 'package:ringolingo_app/models/artist.dart';

class RightSidebar extends StatelessWidget {
  const RightSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Artist> artists = const [
      Artist(imagePath: "assets/images/taoNgoiSao.png", displayName: "Lim Feng", username: "@limfeng__"),
      Artist(imagePath: "assets/images/taoNgoiSao.png", displayName: "Mi Nga", username: "@lf.mingahaman"),
      Artist(imagePath: "assets/images/taoNgoiSao.png", displayName: "MCK", username: "@rpt.mckeyyyyy"),
      Artist(imagePath: "assets/images/taoNgoiSao.png", displayName: "tlinh", username: "@lf.tlinh"),
      Artist(imagePath: "assets/images/taoNgoiSao.png", displayName: "wxrdie", username: "@wxrdie102"),
      Artist(imagePath: "assets/images/taoNgoiSao.png", displayName: "Lâm Minh", username: "@lamiinh"),
      Artist(imagePath: "assets/images/taoNgoiSao.png", displayName: "DEC AO", username: "@dec.ao"),
    ];

    return ClipRRect(
      borderRadius: BorderRadius.circular(32), // Bo góc tổng thể
      child: Container(
        padding: const EdgeInsets.all(16),
        width: 320,
        color: const Color(0xFFF2E9DE),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top artist
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      'assets/images/taoNgoiSao.png',
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Wren Evans',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '@wrenevans___',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Gợi ý nghệ sĩ',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.separated(
                itemCount: artists.length,
                separatorBuilder: (context, index) => const SizedBox(height: 14),
                itemBuilder: (context, index) {
                  return _buildArtist(artists[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildArtist(Artist artist) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              artist.imagePath,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              artist.displayName,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            Text(
              artist.username,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
