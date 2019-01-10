import 'package:flutter_weather/commom_import.dart';

class GiftGankViewModel extends ViewModel {
  final _service = GiftGankService();

  final data = StreamController<List<MziData>>();
  final _photoData = StreamController<List<MziData>>();

  Stream<List<MziData>> photoStream;
  List<MziData> _cacheData = List();
  int _page = 1;
  LoadType _reloadType = LoadType.NEW_LOAD;

  GiftGankViewModel() {
    photoStream = _photoData.stream.asBroadcastStream();
  }

  Future<Null> loadData({@required LoadType type}) async {
    if (selfLoading) return;
    selfLoading = true;

    if (type == LoadType.REFRESH) {
      _page = 1;
      _cacheData.clear();
    } else {
      isLoading.add(true);
    }

    try {
      final list = await _service.getData(page: _page);
      _cacheData.addAll(list);
      data.add(_cacheData);
      _photoData.add(_cacheData);
      _page++;
    } on DioError catch (e) {
      _reloadType = type;
      doError(e);
    } finally {
      selfLoading = false;
      if (!isLoading.isClosed) {
        isLoading.add(false);
      }
    }
  }

  void reload() {
    loadData(type: _reloadType);
  }

  void loadMore() {
    loadData(type: LoadType.LOAD_MORE);
  }

  @override
  void dispose() {
    _service.dispose();
    _cacheData.clear();

    data.close();
    _photoData.close();

    super.dispose();
  }
}
