import 'package:farmsetu/providers/products_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/mock_data.dart';
import '../../models/product.dart';
import '../../providers/auth_provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/language_provider.dart';
import '../../providers/notifications_provider.dart';
import '../../providers/saved_products_provider.dart';
import '../../providers/orders_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';
import '../../widgets/product_card.dart';
import '../../widgets/vendor_card.dart';
import '../cart/cart_screen.dart';
import '../product/product_detail_screen.dart';
import '../profile/address_screen.dart';
import '../profile/notifications_screen.dart';
import '../profile/orders_screen.dart';
import '../profile/saved_products_screen.dart';
import '../settings/settings_screen.dart';
import '../vendor/vendor_profile_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _navIndex = 0;
  String _selectedCategory = 'All';
  String _searchQuery = '';
  final _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Start listening to Firestore products
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductsProvider>().startListening();
      final auth = context.read<AuthProvider>();
      if (auth.isLoggedIn && auth.uid.isNotEmpty) {
        context.read<SavedProductsProvider>().loadForUser(auth.uid);
        context.read<OrdersProvider>().startListening(auth.uid);
      }
    });
  }

  List<Product> get _filtered {
    final prov = context.read<ProductsProvider>();
    List<Product> list;
    if (_searchQuery.isNotEmpty) {
      list = prov.search(_searchQuery);
    } else {
      list = prov.byCategory(_selectedCategory);
    }
    return list;
  }

  void _goToCart() => setState(() => _navIndex = 2);

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cartCount = context.watch<CartProvider>().itemCount;
    final l10n = context.watch<LanguageProvider>().l10n;
    final c = context.col;
    // Watch products so UI rebuilds when data arrives
    final prodProv = context.watch<ProductsProvider>();

    return Scaffold(
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: c.divider, width: 0.5)),
        ),
        child: BottomNavigationBar(
          currentIndex: _navIndex,
          onTap: (i) => setState(() => _navIndex = i),
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.home_outlined),
              activeIcon: const Icon(Icons.home_rounded),
              label: l10n.navHome,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.storefront_outlined),
              activeIcon: const Icon(Icons.storefront_rounded),
              label: l10n.navFarms,
            ),
            BottomNavigationBarItem(
              icon: Badge(
                isLabelVisible: cartCount > 0,
                label: Text('$cartCount', style: const TextStyle(fontSize: 10)),
                child: const Icon(Icons.shopping_bag_outlined),
              ),
              activeIcon: Badge(
                isLabelVisible: cartCount > 0,
                label: Text('$cartCount', style: const TextStyle(fontSize: 10)),
                child: const Icon(Icons.shopping_bag_rounded),
              ),
              label: l10n.navCart,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.person_outline_rounded),
              activeIcon: const Icon(Icons.person_rounded),
              label: l10n.navProfile,
            ),
          ],
        ),
      ),
      body: IndexedStack(
        index: _navIndex,
        children: [
          _HomeTab(
            searchCtrl: _searchCtrl,
            searchQuery: _searchQuery,
            selectedCategory: _selectedCategory,
            filteredProducts: _filtered,
            isLoading: prodProv.isLoading,
            onSearch: (v) => setState(() => _searchQuery = v),
            onClearSearch: () {
              _searchCtrl.clear();
              setState(() => _searchQuery = '');
            },
            onCategoryTap: (cat) => setState(() => _selectedCategory = cat),
            onGoToCart: _goToCart,
          ),
          _FarmsTab(onGoToCart: _goToCart),
          const CartScreen(),
          _ProfileTab(onGoToCart: _goToCart),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Home Tab
// ─────────────────────────────────────────────────────────────
class _HomeTab extends StatelessWidget {
  final TextEditingController searchCtrl;
  final String searchQuery;
  final String selectedCategory;
  final List<Product> filteredProducts;
  final bool isLoading; // ← add this
  final ValueChanged<String> onSearch;
  final VoidCallback onClearSearch;
  final ValueChanged<String> onCategoryTap;
  final VoidCallback onGoToCart;

  const _HomeTab({
    required this.searchCtrl,
    required this.searchQuery,
    required this.selectedCategory,
    required this.filteredProducts,
    required this.isLoading, // ← add this
    required this.onSearch,
    required this.onClearSearch,
    required this.onCategoryTap,
    required this.onGoToCart,
  });

  @override
  Widget build(BuildContext context) {
    final userName = context.watch<AuthProvider>().userName;
    final firstName = userName.isNotEmpty ? userName.split(' ').first : '';
    final l10n = context.watch<LanguageProvider>().l10n;
    final c = context.col;

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${l10n.hello}$firstName 👋',
                              style: TextStyle(
                                  color: c.textSecondary, fontSize: 13)),
                          const SizedBox(height: 2),
                          Text(l10n.findFreshProduce,
                              style: TextStyle(
                                color: c.textPrimary,
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                              )),
                        ],
                      ),
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppTheme.primaryGreen.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.eco_rounded,
                            color: AppTheme.primaryGreen, size: 22),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  TextField(
                    controller: searchCtrl,
                    style: TextStyle(color: c.textPrimary),
                    onChanged: onSearch,
                    decoration: InputDecoration(
                      hintText: l10n.searchHint,
                      prefixIcon:
                          Icon(Icons.search_rounded, color: c.textSecondary),
                      suffixIcon: searchQuery.isNotEmpty
                          ? IconButton(
                              icon: Icon(Icons.clear_rounded,
                                  color: c.textSecondary, size: 18),
                              onPressed: onClearSearch,
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 36,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: MockData.categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (_, i) {
                  final cat = MockData.categories[i];
                  final active = selectedCategory == cat;
                  return GestureDetector(
                    onTap: () => onCategoryTap(cat),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: active ? AppTheme.primaryGreen : c.surfaceHigh,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: active ? AppTheme.primaryGreen : c.divider,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          l10n.categoryName(cat),
                          style: TextStyle(
                            color: active ? Colors.white : c.textSecondary,
                            fontSize: 13,
                            fontWeight:
                                active ? FontWeight.w700 : FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          if (selectedCategory == 'All' && searchQuery.isEmpty) ...[
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 28, 20, 14),
                child: Text(l10n.featuredFarms,
                    style: TextStyle(
                      color: c.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    )),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 160,
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('farmers')
                      .snapshots(),
                  builder: (ctx, snap) {
                    // get approved farmers
                    final docs = (snap.data?.docs ?? []).where((d) {
                      final status =
                          (d.data() as Map<String, dynamic>)['status'];
                      return status == 3 ||
                          status == '3' ||
                          status == 'approved';
                    }).toList();

                    // if no Firestore farms yet, fall back to mock data
                    if (docs.isEmpty) {
                      return ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: MockData.vendors.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemBuilder: (ctx, i) {
                          final vendor = MockData.vendors[i];
                          return GestureDetector(
                            onTap: () => Navigator.push(
                                ctx,
                                MaterialPageRoute(
                                    builder: (_) => VendorProfileScreen(
                                          vendor: vendor,
                                          onGoToCart: onGoToCart,
                                        ))),
                            child: VendorCard(vendor: vendor),
                          );
                        },
                      );
                    }

                    // show real Firestore farms
                    return ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: docs.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemBuilder: (ctx, i) {
                        final data = docs[i].data() as Map<String, dynamic>;
                        final farmId = docs[i].id;
                        final farmName = data['farmName'] ?? 'Unknown Farm';
                        final location = data['location'] ?? '';

                        return GestureDetector(
                          onTap: () => Navigator.push(
                            ctx,
                            MaterialPageRoute(
                              builder: (_) => _FarmDetailScreen(
                                farmId: farmId,
                                farmData: data,
                              ),
                            ),
                          ),
                          child: Container(
                            width: 180,
                            decoration: BoxDecoration(
                              color: AppTheme.cardBg,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: AppTheme.divider),
                            ),
                            clipBehavior: Clip.hardEdge,
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                // Background gradient
                                Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        AppTheme.primaryGreen.withOpacity(0.8),
                                        AppTheme.primaryGreen.withOpacity(0.4),
                                      ],
                                    ),
                                  ),
                                ),
                                // Farm initial letter
                                Center(
                                  child: Text(
                                    farmName[0].toUpperCase(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 52,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                                // Bottom info overlay
                                Positioned(
                                  left: 0,
                                  right: 0,
                                  bottom: 0,
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter,
                                        colors: [
                                          Colors.black.withOpacity(0.7),
                                          Colors.transparent,
                                        ],
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(children: [
                                          Expanded(
                                            child: Text(
                                              farmName,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w700,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          const Icon(Icons.verified_rounded,
                                              color: Colors.white, size: 13),
                                        ]),
                                        if (location.isNotEmpty)
                                          Text(
                                            location,
                                            style: const TextStyle(
                                              color: Colors.white70,
                                              fontSize: 10,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    searchQuery.isNotEmpty
                        ? l10n.searchResults
                        : selectedCategory == 'All'
                            ? l10n.allProducts
                            : l10n.categoryName(selectedCategory),
                    style: TextStyle(
                      color: c.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(l10n.itemsCount(filteredProducts.length),
                      style: TextStyle(color: c.textSecondary, fontSize: 13)),
                ],
              ),
            ),
          ),
          // ── Products Grid ──────────────────────────────────────────
          isLoading
              ? const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 60),
                    child: Center(
                        child: CircularProgressIndicator(
                            color: AppTheme.primaryGreen)),
                  ),
                )
              : filteredProducts.isEmpty
                  ? SliverToBoxAdapter(
                      child: _EmptyState(
                        icon: Icons.search_off_rounded,
                        message: l10n.noProductsFound,
                        subtitle: l10n.tryDifferentSearch,
                      ),
                    )
                  : SliverPadding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                      sliver: SliverGrid(
                        delegate: SliverChildBuilderDelegate(
                          (ctx, i) {
                            final product = filteredProducts[i];
                            return GestureDetector(
                              onTap: () => Navigator.push(
                                  ctx,
                                  MaterialPageRoute(
                                    builder: (_) => ProductDetailScreen(
                                      product: product,
                                      onGoToCart: onGoToCart,
                                    ),
                                  )),
                              child: ProductCard(product: product),
                            );
                          },
                          childCount: filteredProducts.length,
                        ),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          childAspectRatio: 0.72,
                          crossAxisSpacing: 6,
                          mainAxisSpacing: 6,
                        ),
                      ),
                    ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Farms Tab
// ─────────────────────────────────────────────────────────────
class _FarmsTab extends StatelessWidget {
  final VoidCallback onGoToCart;
  const _FarmsTab({required this.onGoToCart});

  @override
  Widget build(BuildContext context) {
    final l10n = context.watch<LanguageProvider>().l10n;
    final c = context.col;

    // DEBUG — check auth state
    final auth = context.watch<AuthProvider>();
    debugPrint(
        '===== FarmsTab: isLoggedIn=${auth.isLoggedIn} email=${auth.userEmail}');
    return SafeArea(
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('farmers').snapshots(),
        builder: (context, snap) {
          // Still loading — show spinner
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: AppTheme.primaryGreen),
            );
          }

          // Error
          if (snap.hasError) {
            return Center(
              child: Text('Error: ${snap.error}',
                  style: TextStyle(color: c.textSecondary)),
            );
          }

          // No data at all yet — show spinner (not empty state)
          if (!snap.hasData) {
            return const Center(
              child: CircularProgressIndicator(color: AppTheme.primaryGreen),
            );
          }

          // Filter approved farmers
          final farmers = snap.data!.docs.where((d) {
            final data = d.data() as Map<String, dynamic>;
            final status = data['status'];
            return status == 3 || status == '3' || status == 'approved';
          }).toList();

          // Only show empty state if we have data but NO approved farmers
          if (farmers.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.storefront_outlined, size: 64, color: c.textMuted),
                  const SizedBox(height: 16),
                  Text('No approved farms yet',
                      style: TextStyle(
                          color: c.textPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Text('Check back soon!',
                      style: TextStyle(color: c.textSecondary, fontSize: 14)),
                ],
              ),
            );
          }

          // Show farms list
          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
                  child: Text(l10n.allFarms,
                      style: TextStyle(
                        color: c.textPrimary,
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                      )),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (ctx, i) {
                      final data = farmers[i].data() as Map<String, dynamic>;
                      final farmName = data['farmName'] ?? 'Unknown Farm';
                      final ownerName = data['name'] ?? '';
                      final location = data['location'] ?? '';
                      final category = data['category'] ?? '';

                      return GestureDetector(
                          onTap: () => Navigator.push(
                                ctx,
                                MaterialPageRoute(
                                  builder: (_) => _FarmDetailScreen(
                                    farmId: farmers[i].id,
                                    farmData: data,
                                  ),
                                ),
                              ),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: c.cardBg,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: c.divider),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 64,
                                  height: 64,
                                  decoration: BoxDecoration(
                                    color:
                                        AppTheme.primaryGreen.withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                    child: Text(
                                      farmName[0].toUpperCase(),
                                      style: const TextStyle(
                                        color: AppTheme.primaryGreen,
                                        fontSize: 28,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(children: [
                                        Expanded(
                                          child: Text(farmName,
                                              style: TextStyle(
                                                color: c.textPrimary,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w700,
                                              )),
                                        ),
                                        const Icon(Icons.verified_rounded,
                                            color: AppTheme.primaryGreen,
                                            size: 16),
                                      ]),
                                      if (ownerName.isNotEmpty) ...[
                                        const SizedBox(height: 4),
                                        Row(children: [
                                          Icon(Icons.person_outline_rounded,
                                              color: c.textMuted, size: 13),
                                          const SizedBox(width: 3),
                                          Text(ownerName,
                                              style: TextStyle(
                                                  color: c.textMuted,
                                                  fontSize: 12)),
                                        ]),
                                      ],
                                      if (location.isNotEmpty) ...[
                                        const SizedBox(height: 4),
                                        Row(children: [
                                          Icon(Icons.location_on_outlined,
                                              color: c.textMuted, size: 13),
                                          const SizedBox(width: 3),
                                          Expanded(
                                            child: Text(location,
                                                style: TextStyle(
                                                    color: c.textMuted,
                                                    fontSize: 12),
                                                overflow:
                                                    TextOverflow.ellipsis),
                                          ),
                                        ]),
                                      ],
                                      if (category.isNotEmpty) ...[
                                        const SizedBox(height: 6),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: AppTheme.primaryGreen
                                                .withOpacity(0.1),
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                          child: Text(category,
                                              style: const TextStyle(
                                                color: AppTheme.primaryGreen,
                                                fontSize: 10,
                                                fontWeight: FontWeight.w600,
                                              )),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Icon(Icons.arrow_forward_ios_rounded,
                                    color: c.textMuted, size: 13),
                              ],
                            ),
                          ));
                    },
                    childCount: farmers.length,
                  ),
                ),
              ),
            ],
          );
        },
      ), // closes SafeArea
    ); // closes build return
  } // closes build()
} // closes _FarmsTab

// ─────────────────────────────────────────────────────────────
// Profile Tab
// ─────────────────────────────────────────────────────────────
class _ProfileTab extends StatelessWidget {
  final VoidCallback onGoToCart;
  const _ProfileTab({required this.onGoToCart});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final l10n = context.watch<LanguageProvider>().l10n;
    final notifC = context.watch<NotificationsProvider>().unreadCount;
    final c = context.col;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
        children: [
          Center(
            child: Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: AppTheme.primaryGreen.withOpacity(0.12),
                shape: BoxShape.circle,
                border: Border.all(
                    color: AppTheme.primaryGreen.withOpacity(0.4), width: 2),
              ),
              child: const Icon(Icons.person_rounded,
                  color: AppTheme.primaryGreen, size: 46),
            ),
          ),
          const SizedBox(height: 14),
          Center(
            child: Text(
              auth.userName.isEmpty ? l10n.user : auth.userName,
              style: TextStyle(
                  color: c.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(height: 4),
          Center(
            child: Text(auth.userEmail,
                style: TextStyle(color: c.textSecondary, fontSize: 14)),
          ),
          const SizedBox(height: 28),
          _SectionHeader(l10n.navProfile),
          Container(
            decoration: BoxDecoration(
              color: c.cardBg,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: c.divider),
            ),
            child: Column(
              children: [
                _ProfileTile(
                  icon: Icons.shopping_bag_outlined,
                  title: l10n.myOrders,
                  iconColor: AppTheme.primaryGreen,
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const OrdersScreen())),
                ),
                _TileDivider(),
                _ProfileTile(
                  icon: Icons.favorite_border_rounded,
                  title: l10n.savedProducts,
                  iconColor: const Color(0xFFE45C7A),
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) =>
                              SavedProductsScreen(onGoToCart: onGoToCart))),
                ),
                _TileDivider(),
                _ProfileTile(
                  icon: Icons.location_on_outlined,
                  title: l10n.deliveryAddress,
                  iconColor: const Color(0xFF5CB8E4),
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const AddressScreen())),
                ),
                _TileDivider(),
                _ProfileTile(
                  icon: Icons.notifications_outlined,
                  title: l10n.notifications,
                  iconColor: const Color(0xFFE88F3F),
                  badge: notifC > 0 ? '$notifC' : null,
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const NotificationsScreen())),
                ),
                _TileDivider(),
                _ProfileTile(
                  icon: Icons.help_outline_rounded,
                  title: l10n.helpSupport,
                  iconColor: const Color(0xFF9B7FE8),
                ),
                _TileDivider(),
                _ProfileTile(
                  icon: Icons.settings_outlined,
                  title: l10n.settings,
                  iconColor: c.textSecondary,
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const SettingsScreen())),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          OutlinedButton.icon(
            onPressed: () {
              context.read<OrdersProvider>().stopListening();
              context.read<SavedProductsProvider>().clear();
              auth.logout();
            },
            icon: const Icon(Icons.logout_rounded,
                size: 18, color: AppTheme.error),
            label: Text(l10n.signOut,
                style: const TextStyle(color: AppTheme.error)),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppTheme.error),
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Small shared widgets
// ─────────────────────────────────────────────────────────────
class _ProfileTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final VoidCallback? onTap;
  final String? badge;

  const _ProfileTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    this.onTap,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.col;
    return InkWell(
      onTap: onTap ?? () {},
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 18),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(title,
                  style: TextStyle(
                      color: c.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w500)),
            ),
            if (badge != null) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFE88F3F),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(badge!,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w700)),
              ),
              const SizedBox(width: 6),
            ],
            Icon(Icons.arrow_forward_ios_rounded, size: 13, color: c.textMuted),
          ],
        ),
      ),
    );
  }
}

class _TileDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Divider(
        height: 1,
        indent: 66,
        color: context.col.divider.withOpacity(0.6),
      );
}

class _SectionHeader extends StatelessWidget {
  final String text;
  const _SectionHeader(this.text);
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 10, left: 2),
        child: Text(text.toUpperCase(),
            style: TextStyle(
              color: context.col.textMuted,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.1,
            )),
      );
}

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String message;
  final String subtitle;
  const _EmptyState({
    required this.icon,
    required this.message,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.col;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 60),
      child: Column(
        children: [
          Icon(icon, color: c.textMuted, size: 52),
          const SizedBox(height: 14),
          Text(message,
              style: TextStyle(
                  color: c.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          Text(subtitle,
              style: TextStyle(color: c.textSecondary, fontSize: 13)),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Farm Detail Screen
// ─────────────────────────────────────────────────────────────
class _FarmDetailScreen extends StatelessWidget {
  final String farmId;
  final Map<String, dynamic> farmData;
  const _FarmDetailScreen({required this.farmId, required this.farmData});

  @override
  Widget build(BuildContext context) {
    final c = context.col;
    final farmName = farmData['farmName'] ?? 'Unknown Farm';
    final owner = farmData['name'] ?? '';
    final location = farmData['location'] ?? '';
    final category = farmData['category'] ?? '';
    final bio = farmData['bio'] ?? '';
    final phone = farmData['phone'] ?? '';

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: AppTheme.primaryGreen,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppTheme.primaryGreen,
                      AppTheme.primaryGreen.withOpacity(0.7),
                    ],
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: farmData['photoUrl'] != null &&
                                (farmData['photoUrl'] as String).isNotEmpty
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: CachedNetworkImage(
                                  imageUrl: farmData['photoUrl'] as String,
                                  fit: BoxFit.cover,
                                  placeholder: (_, __) => Center(
                                    child: Text(
                                      farmName[0].toUpperCase(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 40,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                  errorWidget: (_, __, ___) => Center(
                                    child: Text(
                                      farmName[0].toUpperCase(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 40,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : Center(
                                child: Text(
                                  farmName[0].toUpperCase(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 40,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                      ),
                      const SizedBox(height: 10),
                      Text(farmName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          )),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(children: [
                    Icon(Icons.verified_rounded,
                        color: AppTheme.primaryGreen, size: 16),
                    SizedBox(width: 6),
                    Text('Verified Farm',
                        style: TextStyle(
                            color: AppTheme.primaryGreen,
                            fontWeight: FontWeight.w600,
                            fontSize: 13)),
                  ]),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: c.cardBg,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: c.divider),
                    ),
                    child: Column(
                      children: [
                        if (owner.isNotEmpty)
                          _InfoRow(
                              Icons.person_outline_rounded, 'Owner', owner),
                        if (location.isNotEmpty)
                          _InfoRow(
                              Icons.location_on_outlined, 'Location', location),
                        if (category.isNotEmpty)
                          _InfoRow(
                              Icons.category_outlined, 'Category', category),
                        if (phone.isNotEmpty)
                          _InfoRow(Icons.phone_outlined, 'Phone', phone),
                      ],
                    ),
                  ),
                  if (bio.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    Text('About the Farm',
                        style: TextStyle(
                          color: c.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        )),
                    const SizedBox(height: 8),
                    Text(bio,
                        style: TextStyle(
                            color: c.textSecondary, fontSize: 14, height: 1.5)),
                  ],
                  const SizedBox(height: 24),
                  Text('Products from this Farm',
                      style: TextStyle(
                        color: c.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      )),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
            sliver: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('products')
                  .where('farmerId', isEqualTo: farmId)
                  .where('isAvailable', isEqualTo: true)
                  .snapshots(),
              builder: (ctx, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return const SliverToBoxAdapter(
                    child: Center(
                        child: CircularProgressIndicator(
                            color: AppTheme.primaryGreen)),
                  );
                }
                final products = snap.data?.docs ?? [];
                if (products.isEmpty) {
                  return SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Text('No products listed yet',
                            style: TextStyle(color: c.textSecondary)),
                      ),
                    ),
                  );
                }
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (ctx, i) {
                      final data = products[i].data() as Map<String, dynamic>;
                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: c.cardBg,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: c.divider),
                        ),
                        child: Row(children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: AppTheme.primaryGreen.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.eco_outlined,
                                color: AppTheme.primaryGreen),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(data['name'] ?? '',
                                  style: TextStyle(
                                    color: c.textPrimary,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  )),
                              const SizedBox(height: 3),
                              Text(
                                  '${data['category'] ?? ''} · Stock: ${data['stock'] ?? 0}',
                                  style: TextStyle(
                                      color: c.textMuted, fontSize: 12)),
                            ],
                          )),
                          Text('₹${(data['price'] ?? 0).toInt()}',
                              style: const TextStyle(
                                color: AppTheme.primaryGreen,
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                              )),
                        ]),
                      );
                    },
                    childCount: products.length,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _InfoRow(this.icon, this.label, this.value);

  @override
  Widget build(BuildContext context) {
    final c = context.col;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(children: [
        Icon(icon, color: c.textMuted, size: 16),
        const SizedBox(width: 10),
        Text('$label: ', style: TextStyle(color: c.textMuted, fontSize: 13)),
        Expanded(
          child: Text(value,
              style: TextStyle(
                color: c.textPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              )),
        ),
      ]),
    );
  }
}
