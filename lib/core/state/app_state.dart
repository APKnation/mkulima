import 'package:material_ui/material_ui.dart';

import '../../data/models/farm.dart';
import '../../data/models/post.dart';
import '../../data/models/product.dart';
import '../../data/models/user.dart';
import '../../data/repositories/catalog_repository.dart';
import '../../data/seed/farm_seed.dart';
import '../../data/seed/misc_seed.dart';
import '../../data/seed/products_seed.dart';

/// Central, dependency-free application state.
///
/// Uses a plain [ChangeNotifier] because the surface is small enough that a
/// third-party state manager would add cost without value.
class AppState extends ChangeNotifier {
  AppState({
    CatalogRepository repository = const CatalogRepository(),
    bool signedIn = false,
  })  : _repo = repository,
        _signedIn = signedIn,
        _posts = repository.seededPosts,
        _favorites = {'54 712 884', '76 330 512'};

  final CatalogRepository _repo;

  bool _signedIn;
  bool _onboarded = false;
  String _phone = userProfileSeed.phone;
  UserProfile _user = userProfileSeed;
  Farm _farm = farmSeed();
  List<FarmExpense>? _expenses;
  final List<Product> _listings = [
    mkP('12 418 900', 'Nyanya za Chamwino', 'mboga', 'nyanya', 'Nyanya',
        1350, 'kilo', 'Baraka John Mwakyusa', 'Mkulima binafsi', 'Chamwino',
        'Dodoma', 'Tenga 25kg · 10 yapo', 'vegetables.jpg',
        desc: 'Nyanya mbichi zilizovunwa shamba la Baraka, Chamwino.',
        verified: true, organic: true, views: 42, reviews: 3),
  ];
  final List<CommunityPost> _posts;
  final List<AppNotification> _notifications = [...notificationsSeed];
  final Set<String> _favorites;
  final List<String> _recentlyViewed = [];
  final List<FarmActivity> _extraActivities = [];

  CatalogRepository get repo => _repo;

  bool get signedIn => _signedIn;
  bool get onboarded => _onboarded;
  String get phone => _phone;
  UserProfile get user => _user;

  Farm get farm => Farm(
        name: _farm.name,
        region: _farm.region,
        ward: _farm.ward,
        sizeHa: _farm.sizeHa,
        crops: _farm.crops,
        livestock: _farm.livestock,
        goal: _farm.goal,
        monthlySales: _farm.monthlySales,
        tasks: _farm.tasks,
        activities: _extraActivities.isEmpty
            ? _farm.activities
            : [..._extraActivities, ..._farm.activities],
        expenses: _expenses ?? _farm.expenses,
        registered: _farm.registered,
      );

  List<Product> get products => [..._listings, ..._repo.products];
  List<Product> get myListings => List.unmodifiable(_listings);
  List<CommunityPost> get posts => List.unmodifiable(_posts);
  List<AppNotification> get notifications => List.unmodifiable(_notifications);
  int get unreadNotifications =>
      _notifications.where((item) => !item.read).length;
  List<Product> get favoriteProducts =>
      products.where((p) => _favorites.contains(p.id)).toList();
  List<Product> get recentlyViewedProducts {
    final items = <Product>[];
    for (final id in _recentlyViewed) {
      final match = products.where((p) => p.id == id);
      if (match.isNotEmpty) items.add(match.first);
    }
    return items;
  }

  int get favoriteCount => _favorites.length;

  void completeOnboarding() {
    _onboarded = true;
    notifyListeners();
  }

  void signIn(String phone) {
    _phone = phone;
    _signedIn = true;
    notifyListeners();
  }

  void signOut() {
    _signedIn = false;
    notifyListeners();
  }

  void updateProfile(UserProfile profile) {
    _user = profile;
    notifyListeners();
  }

  bool isFavorite(String id) => _favorites.contains(id);

  void toggleFavorite(String id) {
    if (!_favorites.remove(id)) _favorites.add(id);
    notifyListeners();
  }

  void markViewed(String id) {
    _recentlyViewed
      ..remove(id)
      ..insert(0, id);
    if (_recentlyViewed.length > 8) _recentlyViewed.removeLast();
    notifyListeners();
  }

  void addProduct(Product product) {
    _listings.insert(0, product);
    notifyListeners();
  }

  void removeProduct(String id) {
    _listings.removeWhere((p) => p.id == id);
    notifyListeners();
  }

  void addPost(CommunityPost post) {
    _posts.insert(0, post);
    notifyListeners();
  }

  void toggleLike(String postId) {
    final index = _posts.indexWhere((p) => p.id == postId);
    if (index < 0) return;
    final post = _posts[index];
    final liked = !post.liked;
    _posts[index] = post.copyWith(
      liked: liked,
      likes: post.likes + (liked ? 1 : -1),
    );
    notifyListeners();
  }

  void addComment(String postId, CommunityComment comment) {
    final index = _posts.indexWhere((p) => p.id == postId);
    if (index < 0) return;
    final post = _posts[index];
    _posts[index] = post.copyWith(comments: [...post.comments, comment]);
    notifyListeners();
  }

  void toggleTask(String taskId) {
    final tasks = [
      for (final task in _farm.tasks)
        task.id == taskId ? task.copyWith(done: !task.done) : task,
    ];
    _farm = _farm.copyWith(tasks: tasks);
    notifyListeners();
  }

  void addExpense(FarmExpense expense) {
    _expenses = [...(_expenses ?? _farm.expenses), expense];
    notifyListeners();
  }

  void addActivity(FarmActivity activity) {
    _extraActivities.insert(0, activity);
    notifyListeners();
  }

  void registerFarm(Farm farm) {
    _farm = farm;
    _expenses = farm.expenses;
    _extraActivities.clear();
    notifyListeners();
  }

  void markNotificationRead(String id) {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index < 0) return;
    _notifications[index] = _notifications[index].copyWith(read: true);
    notifyListeners();
  }

  void markAllNotificationsRead() {
    for (var i = 0; i < _notifications.length; i++) {
      _notifications[i] = _notifications[i].copyWith(read: true);
    }
    notifyListeners();
  }

  List<Product> filter(ProductFilter filter) {
    var result = products.where((p) {
      if (filter.categoryId != null && p.categoryId != filter.categoryId) {
        return false;
      }
      if (filter.subcategoryId != null &&
          p.subcategoryId != filter.subcategoryId) {
        return false;
      }
      if (filter.region != null && p.region != filter.region) return false;
      if (filter.maxPrice != null && p.price > filter.maxPrice!) return false;
      if (filter.availableOnly && !p.available) return false;
      if (filter.verifiedOnly && !p.verified) return false;
      if (filter.query.trim().isNotEmpty) {
        final q = filter.query.toLowerCase();
        final matches = p.name.toLowerCase().contains(q) ||
            p.subcategoryName.toLowerCase().contains(q) ||
            p.sellerName.toLowerCase().contains(q) ||
            p.region.toLowerCase().contains(q);
        if (!matches) return false;
      }
      return true;
    }).toList();

    switch (filter.sort) {
      case ProductSort.newest:
        break;
      case ProductSort.priceLow:
        result.sort((a, b) => a.price.compareTo(b.price));
      case ProductSort.priceHigh:
        result.sort((a, b) => b.price.compareTo(a.price));
      case ProductSort.popular:
        result.sort((a, b) => b.views.compareTo(a.views));
    }
    return result;
  }
}

/// Exposes [AppState] to the widget tree and rebuilds dependants on change.
class AppScope extends InheritedNotifier<AppState> {
  const AppScope({super.key, required AppState state, required super.child})
      : super(notifier: state);

  static AppState of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppScope>();
    assert(scope != null, 'AppScope is missing above this widget.');
    return scope!.notifier!;
  }

  /// Reads state without subscribing to rebuilds (for callbacks).
  static AppState read(BuildContext context) {
    final scope = context.getInheritedWidgetOfExactType<AppScope>();
    assert(scope != null, 'AppScope is missing above this widget.');
    return scope!.notifier!;
  }
}
