// Sesuai modul hal.42-44 dengan UI FITCORE premium
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/routes/app_router.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/product_provider.dart';
import '../../data/models/product_model.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});
  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Fetch produk saat halaman dibuka (sesuai modul hal.42)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().fetchProducts();
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final product = context.watch<ProductProvider>();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // ── TOP BAR ──────────────────────────────────
            _buildTopBar(auth),

            // ── CONTENT ──────────────────────────────────
            Expanded(
              child: switch (product.status) {
                // Loading (sesuai modul hal.39)
                ProductStatus.loading || ProductStatus.initial => const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(color: AppColors.primary),
                      SizedBox(height: 16),
                      Text(
                        'Memuat produk...',
                        style: TextStyle(color: AppColors.textMuted),
                      ),
                    ],
                  ),
                ),

                // Error (sesuai modul hal.39)
                ProductStatus.error => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 64,
                          color: AppColors.error,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          product.error ?? 'Terjadi kesalahan',
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: AppColors.textMuted),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton.icon(
                          onPressed: product.fetchProducts,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Coba Lagi'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Loaded (sesuai modul hal.39 & 43-44)
                ProductStatus.loaded => RefreshIndicator(
                  onRefresh: product.fetchProducts,
                  color: AppColors.primary,
                  child: CustomScrollView(
                    slivers: [
                      // Search Bar
                      SliverToBoxAdapter(child: _buildSearchBar(product)),

                      // Hero Banner
                      SliverToBoxAdapter(child: _buildHeroBanner(auth)),

                      // Category Chips
                      SliverToBoxAdapter(child: _buildCategories(product)),

                      // Section Title
                      const SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(16, 16, 16, 12),
                          child: Text(
                            '🔥 Produk Tersedia',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ),

                      // Product Grid (sesuai modul hal.43-44)
                      product.products.isEmpty
                          ? const SliverToBoxAdapter(
                              child: Center(
                                child: Padding(
                                  padding: EdgeInsets.all(40),
                                  child: Column(
                                    children: [
                                      Text(
                                        '🔍',
                                        style: TextStyle(fontSize: 48),
                                      ),
                                      SizedBox(height: 12),
                                      Text(
                                        'Produk tidak ditemukan',
                                        style: TextStyle(
                                          color: AppColors.textMuted,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          : SliverPadding(
                              padding: const EdgeInsets.fromLTRB(
                                16,
                                0,
                                16,
                                100,
                              ),
                              sliver: SliverGrid(
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      childAspectRatio: 0.72,
                                      crossAxisSpacing: 12,
                                      mainAxisSpacing: 12,
                                    ),
                                delegate: SliverChildBuilderDelegate(
                                  (_, i) => _ProductCard(
                                    product: product.products[i],
                                  ),
                                  childCount: product.products.length,
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              },
            ),
          ],
        ),
      ),
    );
  }

  // ── TOP BAR ──────────────────────────────────────────────
  Widget _buildTopBar(AuthProvider auth) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(bottom: BorderSide(color: AppColors.borderGlass)),
      ),
      child: Row(
        children: [
          // Logo + greeting
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: AppColors.primaryGradient,
                  ).createShader(bounds),
                  child: const Text(
                    'FIT⚡CORE',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: -0.5,
                    ),
                  ),
                ),
                Text(
                  'Halo, ${auth.firebaseUser?.displayName?.split(' ').first ?? 'Fitcore User'}! 💪',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),

          // Logout button
          GestureDetector(
            onTap: () async {
              await auth.logout();
              if (!mounted) return;
              Navigator.pushReplacementNamed(context, AppRouter.login);
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.cardBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.borderGlass),
              ),
              child: const Icon(
                Icons.logout,
                color: AppColors.textMuted,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── SEARCH BAR ───────────────────────────────────────────
  Widget _buildSearchBar(ProductProvider product) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(color: AppColors.borderGlass),
        ),
        child: TextField(
          controller: _searchCtrl,
          style: const TextStyle(color: AppColors.textPrimary),
          onChanged: product.search,
          decoration: const InputDecoration(
            hintText: 'Cari peralatan gym...',
            prefixIcon: Icon(Icons.search, color: AppColors.textMuted),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          ),
        ),
      ),
    );
  }

  // ── HERO BANNER ──────────────────────────────────────────
  Widget _buildHeroBanner(AuthProvider auth) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF0A0A0F), Color(0xFF1a0533)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.borderGlass),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: AppColors.primaryGradient,
                      ),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const Text(
                      '⚡ New Collection 2025',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ShaderMask(
                    shaderCallback: (b) => const LinearGradient(
                      colors: AppColors.primaryGradient,
                    ).createShader(b),
                    child: const Text(
                      'Train Like\nA Beast.',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        height: 1.1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Peralatan gym premium\nuntuk atlet serius.',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textMuted,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const Text('🏋️', style: TextStyle(fontSize: 64)),
          ],
        ),
      ),
    );
  }

  // ── CATEGORIES ───────────────────────────────────────────
  Widget _buildCategories(ProductProvider product) {
    final cats = ['Semua', 'Kardio', 'Kekuatan', 'Pemulihan', 'Aksesori'];
    return SizedBox(
      height: 52,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
        scrollDirection: Axis.horizontal,
        itemCount: cats.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final isActive = product.selectedCategory == cats[i];
          return GestureDetector(
            onTap: () => product.filterByCategory(cats[i]),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                gradient: isActive
                    ? const LinearGradient(colors: AppColors.primaryGradient)
                    : null,
                color: isActive ? null : AppColors.cardBg,
                borderRadius: BorderRadius.circular(50),
                border: Border.all(
                  color: isActive ? Colors.transparent : AppColors.borderGlass,
                ),
                boxShadow: isActive
                    ? [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.4),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
              child: Text(
                cats[i],
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isActive ? Colors.white : AppColors.textMuted,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ── PRODUCT CARD ──────────────────────────────────────────
class _ProductCard extends StatelessWidget {
  final ProductModel product;
  const _ProductCard({required this.product});

  // Parse hex color
  Color _hexColor(String hex) {
    final h = hex.replaceAll('#', '');
    return Color(int.parse('FF$h', radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    final hasDiscount = product.discountPct > 0;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderGlass),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image area dengan gradient
          Expanded(
            flex: 3,
            child: Stack(
              children: [
                // Gradient background
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        _hexColor(product.gradientFrom),
                        _hexColor(product.gradientTo),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      product.emoji,
                      style: const TextStyle(fontSize: 52),
                    ),
                  ),
                ),

                // Badge
                if (product.badge != 'none')
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: switch (product.badge) {
                          'hot' => AppColors.error,
                          'sale' => const Color(0xFF0F0C29),
                          _ => AppColors.accent,
                        },
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Text(
                        product.badge.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Info area
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                      height: 1.3,
                    ),
                  ),
                  const Spacer(),
                  if (hasDiscount)
                    Text(
                      'Rp ${product.priceOriginal.toInt()}',
                      style: const TextStyle(
                        fontSize: 10,
                        color: AppColors.textMuted,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  ShaderMask(
                    shaderCallback: (b) => const LinearGradient(
                      colors: AppColors.primaryGradient,
                    ).createShader(b),
                    child: Text(
                      product.formattedPrice,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
