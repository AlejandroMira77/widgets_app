import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SlideInfo {
  final String title;
  final String caption;
  final String imageUrl;

  SlideInfo(this.title, this.caption, this.imageUrl);
}

final slides = <SlideInfo>[
  SlideInfo('Busca la comida', 'texto caption 1', 'assets/images/1.png'),
  SlideInfo('Entrega rápida', 'texto caption 2', 'assets/images/2.png'),
  SlideInfo('Disfruta la comida', 'texto caption 3', 'assets/images/3.png'),
];

class AppTutorialScreen extends StatefulWidget {

  static const String name = 'tutorial_screen';

  const AppTutorialScreen({super.key});

  @override
  State<AppTutorialScreen> createState() => _AppTutorialScreenState();
}

class _AppTutorialScreenState extends State<AppTutorialScreen> {

  final PageController pageviewController = PageController();
  bool endReached = false;

  @override
  void initState() {
    super.initState();
    pageviewController.addListener(() {
      final page = pageviewController.page ?? 0;
      if (!endReached && page >= (slides.length - 1.5)) {
        setState(() {
          endReached = true;
        });
      }
    });
  }

  @override
  void dispose() {
    pageviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          PageView(
            controller: pageviewController,
            physics: const BouncingScrollPhysics(),
            children: slides.map((slideData) => _Slide(
              title: slideData.title,
              caption: slideData.caption,
              imageUrl: slideData.imageUrl
            )).toList()
          ),
          Positioned(
            right: 20,
            top: 50,
            child: TextButton(
              child: const Text('Saltar'),
              onPressed: () => context.pop(),
            )
          ),
          endReached ? Positioned(
            right: 20,
            bottom: 30,
            child: FadeInRight(
              from: 15,
              delay: const Duration(seconds: 1),
              child: FilledButton(
                onPressed: () => context.pop(),
                child: const Text('Comenzar')
              ),
            ),
          ) : const SizedBox()
        ],
      ),
    );
  }
}

class _Slide extends StatelessWidget {

  final String title;
  final String caption;
  final String imageUrl;

  const _Slide({
    required this.title,
    required this.caption,
    required this.imageUrl
  });

  @override
  Widget build(BuildContext context) {

    final TextTheme(:bodyLarge, :titleLarge) = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image(image: AssetImage(imageUrl)),
            const SizedBox(height: 20),
            Text(title, style: titleLarge),
            const SizedBox(height: 20),
            Text(caption, style: bodyLarge),
          ],
        ),
      ),
    );
  }
}