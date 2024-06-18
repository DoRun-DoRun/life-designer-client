import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:debounce_throttle/debounce_throttle.dart';

import '../model/cursor_pagination_model.dart';
import '../model/model_with_id.dart';
import '../model/pagination_params.dart';
import '../repository/basic_pagination_repository.dart';

class _PaginationInfo {
  final int fetchCount;
  final bool fetchMore;
  final bool forceRefetch;

  _PaginationInfo({
    this.fetchCount = 20,
    this.fetchMore = false,
    this.forceRefetch = false,
  });
}

class PaginationProvider<T extends IModelWithId,
        U extends IBasePaginationRepository<T>>
    extends StateNotifier<CursorPaginationBase> {
  final U repository;
  final paginationThrottle = Throttle(
    const Duration(seconds: 3),
    initialValue: _PaginationInfo(),
    checkEquality: false,
  );

  PaginationProvider({
    required this.repository,
  }) : super(CursorPaginationLoading()) {
    paginate();

    paginationThrottle.values.listen(
      (state) {
        print(state.forceRefetch);
        _throttledPagination(state);
      },
    );
  }

  Future<void> paginate({
    int fetchCount = 20,
    bool fetchMore = false,
    bool forceRefetch = false,
  }) async {
    print(forceRefetch);
    paginationThrottle.setValue(_PaginationInfo(
      fetchMore: fetchMore,
      fetchCount: fetchCount,
      forceRefetch: forceRefetch,
    ));
  }

  _throttledPagination(_PaginationInfo info) async {
    final fetchCount = info.fetchCount;
    final fetchMore = info.fetchMore;
    final forceRefetch = info.forceRefetch;

    try {
      if (state is CursorPagination && !forceRefetch) {
        final pState = state as CursorPagination;

        if (!pState.meta.hasMore) {
          return;
        }
      }

      final isLoading = state is CursorPaginationLoading;
      final isRefetching = state is CursorPaginationRefetching;
      final isFetchingMore = state is CursorPaginationFetchingMore;

      if (fetchMore && (isLoading || isRefetching || isFetchingMore)) {
        return;
      }

      PaginationParams paginationParams = PaginationParams(
        count: fetchCount,
      );

      if (fetchMore) {
        final pState = state as CursorPagination<T>;

        state = CursorPaginationFetchingMore(
          meta: pState.meta,
          data: pState.data,
        );

        paginationParams = paginationParams.copyWith(
          after: pState.data.last.id,
        );
      } else {
        if (state is CursorPagination && !forceRefetch) {
          final pState = state as CursorPagination<T>;

          state = CursorPaginationRefetching<T>(
            meta: pState.meta,
            data: pState.data,
          );
        }
        // 나미저 상황
        else {
          state = CursorPaginationLoading();
        }
      }

      final resp = await repository.paginate(
        paginationParams: paginationParams,
      );

      if (state is CursorPaginationFetchingMore) {
        final pState = state as CursorPaginationFetchingMore<T>;

        state = resp.copyWith(
          data: [
            ...pState.data,
            ...resp.data,
          ],
        );
      } else {
        state = resp;
      }
    } catch (e, stack) {
      print(e);
      print(stack);
      state = CursorPaginationError(message: '데이터를 가져오지 못했습니다.');
    }
  }
}
