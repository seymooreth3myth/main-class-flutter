part of main_class.business;

enum InfiniteListState {
  waiting,
  quering,
  success,
  error,
}

class SnapshotInfiniteList<M extends Model, Q extends Query> {
  final List<M> data;
  final InfiniteListState state;
  final Q query;
  final dynamic error;
  final dynamic nextPageRef;
  final int total;

  const SnapshotInfiniteList({
    required this.data,
    required this.state,
    required this.query,
    this.error,
    this.nextPageRef,
    required this.total,
  });

  bool get hasNext => nextPageRef != null;

  SnapshotInfiniteList<M, Q> copyWith({
    required List<M> data,
    required InfiniteListState state,
    required Q query,
    dynamic error,
    dynamic nextPageRef,
    required int total,
  }) {
    return SnapshotInfiniteList<M, Q>(
      data: data,
      state: state,
      query: query,
      error: error ?? this.error,
      nextPageRef: nextPageRef ?? this.nextPageRef,
      total: total,
    );
  }
}

abstract class InfiniteListBloc<M extends Model, Q extends Query>
    implements Bloc {
  BehaviorSubject<SnapshotInfiniteList<M, Q>> items;

  final QueryDAO<M, Q> queryDAO;

  final Q rootQuery;

  SnapshotInfiniteList<M, Q> get list => items.value;

  Stream<SnapshotInfiniteList<M, Q>> get listStream => items.stream;

  InfiniteListBloc({
    required this.items,
    required this.queryDAO,
    required this.rootQuery,
  });

  Future<Page<M>> query(Q query, {bool reset = false}) async {
    items.add(
      items.value.copyWith(
        data: [],
        state: InfiniteListState.quering,
        query: query,
        total: 0,
      ),
    );

    try {
      Page<M> page = await queryDAO.query(query);

      items.add(
        items.value.copyWith(
          state: InfiniteListState.success,
          nextPageRef: page.nextPageRef,
          query: query,
          data: [
            ...(items.value.data),
            ...page.result,
          ],
          total: page.total,
        ),
      );

      return page;
      // ignore: unused_catch_stack
    } catch (e, stack) {
      items.add(items.value.copyWith(
        query: query,
        data: [],
        total: 0,
        state: InfiniteListState.error,
        error: e,
      ));

      throw e;
    }
  }

  Future<Page<M>> nextPage() {
    Q q = items.value.query.copyWith() as Q;
    q.pageRef = items.value.nextPageRef;
    return query(q);
  }

  @override
  void dispose() {
    items.close();
  }

  @override
  Future<void> init() async {
    items = new BehaviorSubject<SnapshotInfiniteList<M, Q>>.seeded(
      SnapshotInfiniteList(
        data: const [],
        query: rootQuery,
        state: InfiniteListState.waiting,
        total: 0,
      ),
    );

    query(rootQuery);
  }

  Future<Page<M>> refresh() async {
    return await query(rootQuery, reset: true);
  }
}
