import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_app/config/theme/custom_colors.dart';
import 'package:music_app/features/mini_player/screens/mini_player_page.dart';
import 'package:music_app/features/navigator/controller/navigator_controller.dart';
import 'package:music_app/features/player/controller/player_controller.dart';

final class NavigatorPage extends StatefulWidget {
  final int initialIndex;
  
  const NavigatorPage({
    super.key,
    this.initialIndex = 0,
  });

  @override
  State<NavigatorPage> createState() => _NavigatorPageState();
}

final class _NavigatorPageState extends State<NavigatorPage> {
  late final NavigatorController _controller;
  
  @override
  void initState() {
    super.initState();
    try {
      _controller = Get.put(NavigatorController());
      
      // Set the initial index if provided
      if (widget.initialIndex >= 0 && widget.initialIndex < _controller.pages.length) {
        _controller.currentIndex.value = widget.initialIndex;
        print("NavigatorPage: initialIndex set to ${widget.initialIndex}");
      } else {
        print("NavigatorPage: initialIndex out of bounds (${widget.initialIndex}), using default");
        _controller.currentIndex.value = 0;
      }
    } catch (e) {
      print("NavigatorPage init error: $e");
      // Hata durumunda varsayılan değeri kullan
      _controller = Get.put(NavigatorController());
      _controller.currentIndex.value = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          body: Obx(
            () => _controller.pages[_controller.currentIndex.value],
          ),
          bottomNavigationBar: Obx(
            () => BottomAppBar(
              elevation: 0,
              shape: const CircularNotchedRectangle(),
              notchMargin: 8.0,
              child: Container(
                height: 80,
                color: CustomColors.darkGreyColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: _buildNavigationItem(Icons.home, 0),
                    ),
                    Expanded(
                      child: _buildNavigationItem(null, 1, isCenter: true, useImage: true),
                    ),
                    Expanded(
                      child: _buildNavigationItem(Icons.library_music, 2),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        // Mini player'ı navigation bar'ın üzerine gelecek şekilde konumlandır
        Positioned(
          left: 0,
          right: 0,
          bottom: 100, // Daha fazla boşluk bırakalım
          child: Obx(() {
            try {
              // PlayerController instance'ına güvenli erişim
              final PlayerController playerController = Get.find<PlayerController>();
              
              // Eğer şarkı bilgisi yoksa gösterme
              if (playerController.currentTitle.value.isEmpty) {
                return const SizedBox.shrink();
              }
              
              return const MiniPlayer();
            } catch (e) {
              print("MiniPlayer error: $e");
              return const SizedBox.shrink(); // Hata durumunda gösterme
            }
          }),
        ),
      ],
    );
  }

  Widget _buildNavigationItem(IconData? iconData, int index, {bool isCenter = false, bool useImage = false}) {
    final bool isSelected = _controller.currentIndex.value == index;
    
    return InkWell(
      onTap: () => _controller.changePage(index),
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          border: isSelected && !isCenter
              ? const Border(
                  top: BorderSide(
                    color: CustomColors.orangeText,
                    width: 3.0,
                  ),
                )
              : null,
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (useImage)
                // Böcek görselini kullan - turuncu daireyi büyütelim
                Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    color: isSelected ? CustomColors.orangeText : Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Image.asset(
                      'assets/icons/bocek.png',
                      height: 36,
                      width: 36,
                      color: isSelected ? Colors.white : Colors.grey,
                    ),
                  ),
                )
              else
                Icon(
                  iconData,
                  color: isSelected ? CustomColors.orangeText : Colors.grey,
                  size: 36,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
