import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';

class StorageRepository {
  StorageRepository(this._client);

  final SupabaseClient? _client;

  Future<String?> uploadProductImage(String fileName, Uint8List bytes) {
    return _upload(
      bucket: 'product-images',
      path: 'products/$fileName',
      bytes: bytes,
      isPublic: true,
    );
  }

  Future<String?> uploadArticleImage(String fileName, Uint8List bytes) {
    return _upload(
      bucket: 'article-images',
      path: 'articles/$fileName',
      bytes: bytes,
      isPublic: true,
    );
  }

  Future<String?> uploadReviewImage(
    String userId,
    String reviewId,
    String fileName,
    Uint8List bytes,
  ) {
    return _upload(
      bucket: 'review-images',
      path: '$userId/$reviewId/$fileName',
      bytes: bytes,
      isPublic: false,
    );
  }

  Future<String?> uploadDeliveryProof(
    String deliveryId,
    String fileName,
    Uint8List bytes,
  ) {
    return _upload(
      bucket: 'delivery-proofs',
      path: '$deliveryId/$fileName',
      bytes: bytes,
      isPublic: false,
    );
  }

  Future<String?> uploadStoreLogo(String fileName, Uint8List bytes) {
    return _upload(
      bucket: 'store-assets',
      path: 'branding/$fileName',
      bytes: bytes,
      isPublic: false,
    );
  }

  Future<String?> _upload({
    required String bucket,
    required String path,
    required Uint8List bytes,
    required bool isPublic,
  }) async {
    final client = _client;
    if (client == null) {
      return null;
    }

    try {
      await client.storage.from(bucket).uploadBinary(
            path,
            bytes,
            fileOptions: const FileOptions(upsert: true),
          );
      if (isPublic) {
        return client.storage.from(bucket).getPublicUrl(path);
      }
      return path;
    } catch (_) {
      return null;
    }
  }
}
