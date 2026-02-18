import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repository/recipe_repository.dart';
import '../state/recipe_state.dart';
import 'recipe_event.dart';

class RecipeBloc extends Bloc<RecipeEvent, RecipeState> {
  final RecipeRepository repository;

  RecipeBloc(this.repository) : super(RecipeInitial()) {
    on<RecipeEvent>((event, emit) async {
      emit(RecipeLoading());

      try {
        final recipes = await repository.getRecipesByIngredients(
          event.query,
          healthFilter: event.diet,
        );

        if (recipes.isEmpty) {
          emit(RecipeError('No recipes found for "${event.query}".\nTry different ingredients!'));
        } else {
          emit(RecipeLoaded(recipes));
        }
      } catch (e) {
        emit(RecipeError('Failed to fetch recipes.\nPlease check your internet connection.\n\nDetails: $e'));
      }
    });
  }
}