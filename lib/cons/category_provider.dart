import 'package:flutter/material.dart';

class CategoryProvider extends ChangeNotifier {
  // 과목 카테고리
  List<String> _subjectCategories = [];

  // 일반 카테고리
  List<String> _generalCategories = [];

  List<String> get subjectCategories => _subjectCategories;
  List<String> get generalCategories => _generalCategories;

  // 과목 카테고리 추가
  void addSubjectCategory(String category) {
    _subjectCategories.add(category);
    notifyListeners();
  }

  // 일반 카테고리 추가
  void addGeneralCategory(String category) {
    _generalCategories.add(category);
    notifyListeners();
  }

  // 과목 카테고리 삭제
  void removeSubjectCategory(String category) {
    _subjectCategories.remove(category);
    notifyListeners();
  }

  // 일반 카테고리 삭제
  void removeGeneralCategory(String category) {
    _generalCategories.remove(category);
    notifyListeners();
  }
}
