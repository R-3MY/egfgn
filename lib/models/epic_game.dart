class EpicGame {
  EpicGame({
    required this.id,
    required this.title,
    required this.description,
    this.productSlug,
    this.urlSlug,
    this.mappingSlug,
    required this.originalPrice,
    required this.discountPrice,
    required this.isCurrentlyFree,
    required this.isUpcomingFree,
    this.imageUrl,
    this.startDate,
    this.endDate,
  });

  factory EpicGame.fromJson(final Map<String, dynamic> json) {
    final title = json['title'] as String;
    final id = json['id'] as String;
    final description = json['description'] as String;
    final productSlug = json['productSlug'] as String?;
    final urlSlug = json['urlSlug'] as String?;

    final mappings = json['catalogNs']?['mappings'] as List<dynamic>?;
    final offerMappings = json['offerMappings'] as List<dynamic>?;

    String? findProductHomeSlug(final List<dynamic>? list) {
      if (list == null) return null;
      for (final m in list) {
        if (m is Map && m['pageType'] == 'productHome') {
          return m['pageSlug'] as String?;
        }
      }
      for (final m in list) {
        if (m is Map && m['pageSlug'] != null) {
          return m['pageSlug'] as String?;
        }
      }
      return null;
    }

    final mappingSlug =
        findProductHomeSlug(mappings) ?? findProductHomeSlug(offerMappings);

    final price = json['price']?['totalPrice'] as Map<String, dynamic>?;
    final originalPrice = price?['originalPrice'] as int? ?? 0;
    final discountPrice = price?['discountPrice'] as int? ?? 0;

    // Extract image
    String? imageUrl;
    final keyImages = json['keyImages'] as List?;
    if (keyImages != null && keyImages.isNotEmpty) {
      // Prefer OfferImageWide, then Thumbnail
      final wide =
          keyImages.firstWhere(
                (final img) => img['type'] == 'OfferImageWide',
                orElse: () => null,
              )
              as Map<String, dynamic>?;
      final tall =
          keyImages.firstWhere(
                (final img) => img['type'] == 'OfferImageTall',
                orElse: () => null,
              )
              as Map<String, dynamic>?;
      final thumb =
          keyImages.firstWhere(
                (final img) => img['type'] == 'Thumbnail',
                orElse: () => null,
              )
              as Map<String, dynamic>?;
      imageUrl = (wide?['url'] ?? tall?['url'] ?? thumb?['url']) as String?;
    }

    bool isCurrentlyFree = false;
    bool isUpcomingFree = false;
    DateTime? start;
    DateTime? end;

    final promotions = json['promotions'] as Map<String, dynamic>?;
    if (promotions != null) {
      final now = DateTime.now().toUtc();

      // Check current promotions
      final promotionalOffers = promotions['promotionalOffers'] as List?;
      if (promotionalOffers != null && promotionalOffers.isNotEmpty) {
        for (final group in promotionalOffers) {
          final offers = group['promotionalOffers'] as List?;
          if (offers == null) continue;
          for (final offer in offers) {
            final startDate = DateTime.parse(offer['startDate'] as String);
            final endDate = DateTime.parse(offer['endDate'] as String);

            if (now.isAfter(startDate) && now.isBefore(endDate)) {
              if (offer['discountSetting']['discountPercentage'] == 0) {
                isCurrentlyFree = true;
                start = startDate;
                end = endDate;
                break;
              }
            }
          }
          if (isCurrentlyFree) break;
        }
      }

      // Check upcoming promotions if not currently free
      if (!isCurrentlyFree) {
        final upcomingOffers = promotions['upcomingPromotionalOffers'] as List?;
        if (upcomingOffers != null && upcomingOffers.isNotEmpty) {
          for (final group in upcomingOffers) {
            final offers = group['promotionalOffers'] as List?;
            if (offers == null) continue;
            for (final offer in offers) {
              if (offer['discountSetting']['discountPercentage'] == 0) {
                isUpcomingFree = true;
                start = DateTime.parse(offer['startDate'] as String);
                end = DateTime.parse(offer['endDate'] as String);
                break;
              }
            }
            if (isUpcomingFree) break;
          }
        }
      }
    }

    return EpicGame(
      id: id,
      title: title,
      description: description,
      productSlug: productSlug,
      urlSlug: urlSlug,
      mappingSlug: mappingSlug,
      originalPrice: originalPrice,
      discountPrice: discountPrice,
      isCurrentlyFree: isCurrentlyFree,
      isUpcomingFree: isUpcomingFree,
      imageUrl: imageUrl,
      startDate: start,
      endDate: end,
    );
  }

  final String id;
  final String title;
  final String description;
  final String? productSlug;
  final String? urlSlug;
  final String? mappingSlug;
  final int originalPrice;
  final int discountPrice;
  final bool isCurrentlyFree;
  final bool isUpcomingFree;
  final String? imageUrl;
  final DateTime? startDate;
  final DateTime? endDate;

  String get epicUrl {
    final slug = mappingSlug ?? productSlug ?? urlSlug;
    if (slug == null) return 'https://store.epicgames.com/fr/';
    final cleanSlug = slug.endsWith('/home')
        ? slug.substring(0, slug.length - 5)
        : slug;
    return 'https://store.epicgames.com/fr/p/$cleanSlug';
  }

  @override
  String toString() => 'EpicGame(title: $title, isFree: $isCurrentlyFree)';
}
