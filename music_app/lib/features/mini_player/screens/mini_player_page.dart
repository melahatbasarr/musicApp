import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_app/features/mini_player/screens/full_player_page.dart';
import 'package:music_app/features/player/controller/player_controller.dart';
import 'package:music_app/config/theme/custom_colors.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    try {
      final PlayerController playerController = Get.find<PlayerController>();

      // Güvenlik kontrolü
      if (playerController.currentTitle.value.isEmpty) {
        return const SizedBox.shrink();
      }

      return GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => FullPlayerPage(
                title: playerController.currentTitle.value,
                artist: playerController.currentArtist.value,
                imageUrl: playerController.currentImageUrl.value,
              ),
            ),
          );
        },
        child: Material(
          color: CustomColors.darkGreyColor,
          elevation: 0, // Gölgeyi kaldırıyoruz
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
          child: Container(
            margin: const EdgeInsets.only(bottom: 10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // İlerleme çubuğu - daha belirgin hale getirelim
                SliderTheme(
                  data: SliderThemeData(
                    trackHeight: 4.0, // Daha kalın track
                    thumbShape: SliderComponentShape.noThumb,
                    overlayShape: SliderComponentShape.noOverlay,
                  ),
                  child: Obx(() => Slider(
                    value: playerController.progress.value,
                    activeColor: CustomColors.orangeText,
                    inactiveColor: Colors.grey.withOpacity(0.3), // Daha görünür arkaplan
                    onChanged: (value) {
                      playerController.updateProgress(value);
                    },
                  )),
                ),
                
                Container(
                  height: 60,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      // Albüm resmi
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: playerController.currentImageUrl.value.startsWith('http')
                          ? Image.network(
                              playerController.currentImageUrl.value,
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.orange,
                                  ),
                                  child: const Icon(Icons.music_note, color: Colors.white, size: 20),
                                );
                              },
                            )
                          : Image.asset(
                              playerController.currentImageUrl.value,
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.orange,
                                  ),
                                  child: const Icon(Icons.music_note, color: Colors.white, size: 20),
                                );
                              },
                            ),
                      ),
                      const SizedBox(width: 12),
                      
                      // Şarkı ve sanatçı bilgisi
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              playerController.currentTitle.value,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            Text(
                              playerController.currentArtist.value,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ],
                        ),
                      ),
                      
                      // Oynatma kontrolleri
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            iconSize: 22,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(), // Boşluk kısıtlamalarını kaldırır
                            icon: const Icon(Icons.skip_previous, color: Colors.white),
                            onPressed: playerController.playPreviousSong,
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            iconSize: 30,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            icon: Obx(() => Icon(
                              playerController.isPlaying.value ? Icons.pause : Icons.play_arrow,
                              color: Colors.white,
                            )),
                            onPressed: playerController.togglePlayPause,
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            iconSize: 22,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            icon: const Icon(Icons.skip_next, color: Colors.white),
                            onPressed: playerController.playNextSong,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } catch (e) {
      // Hata durumunda boş bir widget döndürülür
      return const SizedBox.shrink();
    }
  }
}
