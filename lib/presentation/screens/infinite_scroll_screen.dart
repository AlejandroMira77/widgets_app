import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class InfiniteScrollScreen extends StatefulWidget {

  static const String name = 'infinite_screen';

  const InfiniteScrollScreen({super.key});

  @override
  State<InfiniteScrollScreen> createState() => _InfiniteScrollScreenState();
}

class _InfiniteScrollScreenState extends State<InfiniteScrollScreen> {

  List<int> imagesIds = [1,2,3,4,5];
  final ScrollController scrollController = ScrollController();
  bool isLoading = false;
  bool isMounted = true;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if ((scrollController.position.pixels + 500) >= scrollController.position.maxScrollExtent) {
        loadNextPage();
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    isMounted = false; // se llama cuando el componente esta siendo destruido, ya esta, o esta marcado para destruir
    super.dispose();
  }

  // metodo para cargar 5 imagenes mas
  void addFiveImages() {
    final lastId = imagesIds.last;
    imagesIds.addAll(
      [1,2,3,4,5].map((e) => lastId + e)
    );
  }

  // para cargar mas imagenes si llega al final
  Future loadNextPage() async {
    if (isLoading) return;
    isLoading = true;
    setState(() {});
    await Future.delayed(const Duration(seconds: 2));
    addFiveImages();
    isLoading = false;
    if (!isMounted) return; // se debe hacer esta validacion porque si no el setstate fallaria
    setState(() {});
    moveScrollToBottom();
  }

  // cuando estas en el top y quieres cargar nuevas imagenes
  Future<void> onRefresh() async {
    isLoading = true;
    setState(() {});

    await Future.delayed(const Duration(seconds: 3));
    if (!isMounted) return;

    isLoading = false;
    final lastId = imagesIds.last;
    imagesIds.clear();
    imagesIds.add(lastId + 1);
    addFiveImages();

    setState(() {});
  }

  // cuando llega al final y se quiere cargar mas imagenes realiza un scroll pequeño para ver las imagenes siguientes
  void moveScrollToBottom() {
    if (scrollController.position.pixels + 150 <= scrollController.position.maxScrollExtent) return;
    scrollController.animateTo(
      scrollController.position.pixels + 120,
      duration: const Duration(milliseconds: 300),
      curve: Curves.fastOutSlowIn
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        removeBottom: true,
        child: RefreshIndicator(
          onRefresh: onRefresh,
          edgeOffset: 10,
          strokeWidth: 2,
          child: ListView.builder(
            controller: scrollController,
            itemCount: imagesIds.length,
            itemBuilder: (context, index) {
              return const FadeInImage(
                fit: BoxFit.cover,
                width: double.infinity,
                placeholder: AssetImage('assets/images/jar-loading.gif'),
                image: AssetImage('assets/images/1.png')// lo hago con imagenes propias porque con NetworkImage no carga y se pega el pc
                // image: NetworkImage('https://picsum.photos/${imagesIds[index]}/1/500/300')
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.pop(),
        child: isLoading ? 
        SpinPerfect(
          infinite: true,
          child: const Icon(Icons.refresh_rounded),
        ) : const Icon(Icons.arrow_back_ios_new_outlined),
      ),
    );
  }
}