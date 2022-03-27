class Mynote {
  int? id;
  String? _title;
  String? _note;
  String? _createDate;
  String? _updateDate;
  String? _sortDate;

  Mynote(
    this._title,
    this._note,
    this._createDate,
    this._updateDate,
    this._sortDate,
  );

  Mynote.map(dynamic obj) {
    _title = obj["title"];
    _note = obj["note"];
    _createDate = obj["createDate"];
    _updateDate = obj["updateDate"];
    _sortDate = obj["sortDate"];
  }

  String get title => _title.toString();
  String get note => _note.toString();
  String get createDate => _createDate.toString();
  String get updateDate => _updateDate.toString();
  String get sortDate => _sortDate.toString();

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};

    map["title"] = _title;
    map["note"] = _note;
    map["createDate"] = _createDate;
    map["updateDate"] = _updateDate;
    map["sortDate"] = _sortDate;

    return map;
  }

  void setNoteId(int id) {
    this.id = id;
  }
}
