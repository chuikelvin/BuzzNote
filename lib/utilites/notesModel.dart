class NoteModel {
  late String title;
  late String note;

  NoteModel(this.title, this.note);

  String get note_val {
    return this.note;
  }

  set note_val(String name) {
    this.note = name;
  }

  String get title_val {
    return this.title;
  }

  set title_val(String name) {
    this.title = name;
  }
}
