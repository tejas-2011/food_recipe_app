# 🍽️ TasteAtlas - AI-Powered Recipe Discovery App

A modern Flutter application that helps users discover delicious recipes based on ingredients, featuring AI-powered ingredient detection using Google Gemini Vision.

**Made with ❤️ by Tejaswini**

---

## ✨ Features

### Core Features
- 🔍 **Smart Recipe Search** - Search thousands of recipes by ingredients or dish name
- 📸 **AI Ingredient Detection** - Take a photo of ingredients and let Gemini AI identify them
- 🥗 **Dietary Filters** - Filter by Vegetarian, Vegan, Gluten-Free, Keto, Paleo
- ❤️ **Favorites** - Save your favorite recipes locally with SQLite
- 🌍 **Cuisine Explorer** - Browse recipes by cuisine (Indian, Chinese, Italian, etc.)
- 📱 **Modern UI** - Clean Material 3 design with custom olive-green theme

### Technical Highlights
- **Gemini 1.5 Flash** for accurate ingredient recognition from images
- **Edamam Recipe API v2** integration with 2M+ recipes
- **BLoC + Provider** architecture for robust state management
- **SQLite** for offline favorites storage
- **Type-safe API handling** with proper error states

---

## 📱 Screenshots

*(Add your app screenshots here)*

---

## 🛠️ Technology Stack

| Category | Technology |
|----------|------------|
| **Framework** | Flutter 3.0+ |
| **Language** | Dart 3.0+ |
| **State Management** | BLoC, Provider |
| **APIs** | Edamam Recipe Search v2, Google Gemini AI |
| **Local Database** | SQLite (sqflite) |
| **Image Handling** | image_picker |
| **Environment Config** | flutter_dotenv |
| **Web View** | webview_flutter |

---

## 📋 Prerequisites

Before running this project, ensure you have:

- **Flutter SDK** (3.0 or higher) - [Install Flutter](https://flutter.dev/docs/get-started/install)
- **Dart SDK** (3.0 or higher)
- **Android Studio** or **Xcode** (for mobile development)
- **API Keys** (free):
    - Edamam Recipe API
    - Google Gemini API

---

## 🚀 Installation & Setup

### 1️⃣ Clone the Repository

```bash
git clone https://github.com/tejas-2011/food_recipe_app.git
cd food_recipe_app
```

### 2️⃣ Install Dependencies

```bash
flutter pub get
```

### 3️⃣ Get Your API Keys

#### Edamam Recipe API (Free)
1. Go to [https://developer.edamam.com/](https://developer.edamam.com/)
2. Sign up for a free account
3. Select **"Recipe Search API"**
4. Copy your:
    - Application ID
    - Application Key
    - Account username (shown in top-right after login)

#### Google Gemini API (Free)
1. Go to [https://aistudio.google.com/app/apikey](https://aistudio.google.com/app/apikey)
2. Sign in with your Google account
3. Click **"Create API Key"**
4. Copy the key (starts with `AIzaSy...`)

### 4️⃣ Configure Environment Variables

Create a `.env` file in the project root:

```bash
cp .env.example .env
```

Edit `.env` and add your API keys:

```env
FOOD_RECIPE_APP_KEY=your_edamam_app_key_here
FOOD_RECIPE_APP_ID=your_edamam_app_id_here
EDAMAM_USER_NAME=your_edamam_username_here
GEMINI_API_KEY=your_gemini_api_key_here
```

⚠️ **Important:** Never commit `.env` to GitHub — it's already in `.gitignore`

### 5️⃣ Verify .env is in Assets

Make sure `pubspec.yaml` includes `.env` in assets:

```yaml
flutter:
  assets:
    - .env
```

### 6️⃣ Run the App

```bash
# Clean build (recommended first time)
flutter clean
flutter pub get

# Run on connected device/emulator
flutter run
```

---

## 🏗️ Project Structure

```
lib/
├── config/
│   ├── routes/
│   │   └── app_routes.dart          # Navigation routes
│   └── theme/
│       ├── app_colors.dart          # Custom color palette
│       └── app_theme.dart           # Material 3 theme
│
├── core/
│   └── utils/
│       └── helpers.dart             # Utility functions
│
├── data/
│   ├── local/
│   │   └── database_helper.dart     # SQLite favorites DB
│   ├── models/
│   │   └── recipe_model.dart        # Recipe data model
│   ├── repository/
│   │   └── recipe_repository.dart   # Data layer abstraction
│   └── services/
│       ├── ai/
│       │   └── ai_service.dart      # Gemini AI integration
│       └── api/
│           ├── recipe_api_service.dart  # Edamam API calls
│           └── service.dart         # Legacy service
│
├── presentation/
│   ├── bloc/
│   │   ├── recipe_bloc.dart         # Recipe search BLoC
│   │   ├── recipe_event.dart        # BLoC events
│   │   └── recipe_state.dart        # BLoC states
│   ├── providers/
│   │   └── favorite_provider.dart   # Favorites state
│   ├── screens/
│   │   ├── home_screen.dart         # Main app screen
│   │   ├── recipe_detail_screen.dart
│   │   ├── recipe_view_page.dart    # Web view for recipes
│   │   └── splash_screen.dart
│   └── widgets/
│       ├── common/
│       │   ├── app_bar.dart
│       │   ├── category_scroll.dart
│       │   ├── custom_search_bar.dart
│       │   └── dietry_filter_chips.dart
│       └── recipe/
│           └── recipe_card.dart     # Recipe grid card
│
├── resources/
│   └── constants/
│       ├── api_constants.dart       # API base URLs
│       ├── app_constants.dart       # App-wide constants
│       └── url_s.dart               # URL builders
│
└── main.dart                        # App entry point
```

---

## 🎯 Key Features Explained

### 1. AI Ingredient Detection
- Uses **Gemini 1.5 Flash** vision model
- Analyzes food photos and returns specific ingredient names
- Smart filtering removes generic labels (e.g., "food", "dish")
- Interactive chip UI lets users confirm/edit detected ingredients

### 2. Recipe Search
- Powered by **Edamam Recipe API v2**
- Search by ingredients or recipe name
- 2 million+ recipes with nutritional data
- Real-time search with loading states

### 3. State Management Architecture
- **BLoC** for recipe search (RecipeBloc)
    - Loading, Loaded, Error states
    - Handles API calls and error handling
- **Provider** for favorites
    - Local persistence with SQLite
    - Reactive UI updates

### 4. Error Handling
- Type-safe JSON parsing with proper null checks
- Network error handling with user-friendly messages
- API key validation with helpful error messages

---

## 📦 Dependencies

Key packages used in this project:

```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # State Management
  flutter_bloc: ^8.1.3
  provider: ^6.1.1
  
  # Networking
  http: ^1.1.0
  
  # Environment Config
  flutter_dotenv: ^5.1.0
  
  # Local Database
  sqflite: ^2.3.0
  path: ^1.8.3
  
  # Image Handling
  image_picker: ^1.0.4
  
  # Web View
  webview_flutter: ^4.4.2
  
  # Utilities
  intl: ^0.18.1
```

See `pubspec.yaml` for the complete list.

---

## 🐛 Troubleshooting

### Issue: "No recipes found"
**Solution:**
1. Check your `.env` file has correct Edamam API credentials
2. Run `flutter clean && flutter pub get && flutter run`
3. Verify internet connection

### Issue: "GEMINI_API_KEY missing from .env"
**Solution:**
1. Make sure `.env` file exists in project root
2. Verify `GEMINI_API_KEY` is set with your actual key
3. Check `pubspec.yaml` has `.env` in assets
4. Run `flutter clean && flutter pub get`

### Issue: "type 'double' is not a subtype of type 'int'"
**Solution:** Already fixed in `recipe_model.dart` — update to latest version

### Issue: Ingredient detection returns "bread", "hotdog" for carrot
**Solution:** Already fixed! Now using Gemini AI instead of ML Kit base model

---

## 🔄 Recent Updates

### v1.0.0 (Current)
- ✅ Switched from ML Kit to **Gemini AI** for 10x better ingredient accuracy
- ✅ Fixed type casting errors in recipe parsing
- ✅ Added smart label filtering for AI responses
- ✅ Implemented interactive ingredient confirmation dialog
- ✅ Added "Made by Tejaswini" in Profile tab
- ✅ Centralized all API URLs in `url_s.dart`
- ✅ Protected API keys in `.env` (never committed to GitHub)

---

## 👤 Developer

**Tejaswini**  
Flutter Developer

---

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

---

## 🙏 Acknowledgments

- **Edamam** for their comprehensive Recipe Search API
- **Google** for Gemini AI vision capabilities
- **Flutter Team** for the amazing cross-platform framework
- All open-source package maintainers

---

## 🤝 Contributing

This is a student project for assignment submission. If you find bugs or have suggestions, feel free to open an issue.

---

## 📞 Support

If you encounter any issues:
1. Check the Troubleshooting section above
2. Verify all API keys are correctly configured
3. Make sure Flutter SDK is up to date (`flutter upgrade`)

---

**Happy Cooking! 🍳**