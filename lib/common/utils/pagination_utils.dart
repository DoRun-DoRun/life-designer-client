import 'package:flutter/material.dart';

import '../provider/pagination_provider.dart';

class PaginationUtils {
  static void paginate({
    required ScrollController controller,
    required PaginationProvider provider,
  }) {
    if (controller.offset > controller.position.maxScrollExtent - 300) {
      provider.paginate(
        fetchMore: true,
      );
    }
  }
}