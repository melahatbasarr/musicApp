import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:music_app/common/widget/custom_widget.dart';
import 'package:music_app/config/theme/custom_colors.dart';
import 'package:music_app/features/gps/model/nearby_user_model.dart';
import 'package:music_app/features/player/controller/player_controller.dart';
// Removed permission_handler import as it's causing build issues

class BluetoothController extends GetxController {
  final RxBool isScanning = false.obs;
  final RxList<NearbyUserModel> nearbyUsers = <NearbyUserModel>[].obs;
  final PlayerController _playerController = Get.find<PlayerController>();
  final RxBool hasLocationPermission = false.obs;
  final RxString userLocation = "Unknown".obs;
  
  @override
  void onInit() {
    super.onInit();
    // Örnek veri ekleme - gerçek uygulamada Bluetooth API kullanılır
    _loadMockData();
  }
  
  // Konum izni iste - dialog ile
  Future<bool> requestLocationPermission(BuildContext context) async {
    // SDK versiyonu hatası nedeniyle basit bir dialog gösterelim
    // gerçek izin işlemleri yerine
    bool result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text(
            'Konum İzni Gerekiyor',
            style: TextStyle(
              color: Colors.white,
              fontFamily: "Poppins Medium",
            ),
          ),
          backgroundColor: CustomColors.darkGreyColor,
          contentPadding: const EdgeInsets.all(20),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  const Text(
                    'Çevrenizdeki müzik dinleyen kişileri görebilmek için uygulamamızın konumunuza erişmesi gerekiyor.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                      fontFamily: "Poppins Regular",
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context, false);
                        },
                        child: const Text(
                          'Reddet',
                          style: TextStyle(
                            color: Colors.grey,
                            fontFamily: "Poppins Regular",
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context, true);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: CustomColors.orangeText,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          'İzin Ver',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: "Poppins Medium",
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    ) ?? false;
    
    if (result) {
      hasLocationPermission.value = true;
      _mockGetCurrentLocation();
      return true;
    } else {
      CustomWidgets.showSnackBar(
        message: "Konum izni olmadan, yakınınızdaki kullanıcıları bulamayız.",
      );
      return false;
    }
  }
  
  // Mevcut konumu al - dummy versiyon
  Future<void> _mockGetCurrentLocation() async {
    // Gerçek konum yerine sahte konum kullan
    await Future.delayed(const Duration(seconds: 1));
    
    // Sahte konum bilgisi
    userLocation.value = "41.0082, 28.9784"; // İstanbul koordinatları
    
    // Bilgilendirme mesajı göster
    CustomWidgets.showSnackBar(
      message: "Konumunuz alındı: ${userLocation.value}",
    );
    
    // Mock data'yı güncelle
    _updateNearbyUsers();
  }
  
  // Yakındaki kullanıcıları güncelle (mock)
  void _updateNearbyUsers() {
    // Gerçek uygulamada sunucudan konum bazlı sorgulama yapılır
    // Burada sadece örnek olarak veri güncellendiğini göstermek için
    // rastgele mesafeleri güncelliyoruz
    for (var i = 0; i < nearbyUsers.length; i++) {
      final user = nearbyUsers[i];
      // Rastgele bir mesafe güncelleme (simulasyon)
      final newDistance = (user.distance * 0.8).toPrecision(1);
      
      nearbyUsers[i] = NearbyUserModel(
        id: user.id,
        username: user.username,
        avatarUrl: user.avatarUrl,
        distance: newDistance,
        currentSong: user.currentSong,
        currentArtist: user.currentArtist,
        imageUrl: user.imageUrl,
      );
    }
  }
  
  void startScan() {
    isScanning.value = true;
    // Gerçek uygulamada burada bluetooth taraması başlatılır
    
    // Mock data için 2 saniye bekleme
    Future.delayed(const Duration(seconds: 2), () {
      isScanning.value = false;
    });
  }
  
  void stopScan() {
    isScanning.value = false;
    // Gerçek uygulamada burada bluetooth taraması durdurulur
  }
  
  void playNearbyUserSong(int index) {
    if (index >= 0 && index < nearbyUsers.length) {
      final user = nearbyUsers[index];
      _playerController.playSong(
        user.currentSong,
        user.currentArtist,
        user.imageUrl,
      );
    }
  }
  
  // Mock veri yükleme
  void _loadMockData() {
    nearbyUsers.addAll([
      NearbyUserModel(
        id: '1',
        username: 'Ahmet Y.',
        avatarUrl: 'https://randomuser.me/api/portraits/men/1.jpg',
        distance: 15.5,
        currentSong: 'Lose Yourself',
        currentArtist: 'Eminem',
        imageUrl: 'https://i.scdn.co/image/ab67616d0000b273c08d5fa5c0f1a834acef5100',
      ),
      NearbyUserModel(
        id: '2',
        username: 'Ayşe K.',
        avatarUrl: 'https://randomuser.me/api/portraits/women/2.jpg',
        distance: 32.1,
        currentSong: 'Shape of You',
        currentArtist: 'Ed Sheeran',
        imageUrl: 'https://i.scdn.co/image/ab67616d0000b273ba5db46f4b838ef6027e6f96',
      ),
      NearbyUserModel(
        id: '3',
        username: 'Mehmet S.',
        avatarUrl: 'https://randomuser.me/api/portraits/men/3.jpg',
        distance: 45.7,
        currentSong: 'Blinding Lights',
        currentArtist: 'The Weeknd',
        imageUrl: 'https://i.scdn.co/image/ab67616d0000b2738863bc11d2aa12b54f5aeb36',
      ),
    ]);
  }
} 