import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:widgets_app/config/theme/app_theme.dart';

final isDarkModeProvider = StateProvider<bool>((ref) => true);

// listado de colores inmutable
// el provider es para valores inmutables
final colorListProvider = Provider((ref) => colorList);

// el state es para mantener una pieza de estado
final selectedColorProvider = StateProvider((ref) => 0);






// un objeto de tipo AppTheme custom
// StateNotifierProvider para mantener un estado un poco mas elaborado
// el primer valor es la clase que se encarga de controlar el estado y el estado interno es una instancia de apptheme
final themeNotifierProvider = StateNotifierProvider<ThemeNotifier, AppTheme>(
  (ref) => ThemeNotifier(),
);

// controller o notifier
class ThemeNotifier extends StateNotifier<AppTheme> {

  ThemeNotifier(): super(AppTheme()); // necesito crear la primera instancia de mi AppTheme - establecer el estado inicial

  void toggleDarkmode() {
    state = state.copyWith(isDarkMode: !state.isDarkMode);
  }

  void changeColorIndex(int colorIndex) {
    state = state.copyWith(selectedColor: colorIndex);
  }

}