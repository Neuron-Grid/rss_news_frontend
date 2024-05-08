// スペースチェックを行う独立した関数
String? _checkSpaces(String? value) {
  // 全ての位置での半角スペースまたは全角スペースをチェック
  if (value!.contains(' ') || value.contains('\u3000')) {
    return 'スペース（半角、全角）を含むことはできません';
  }
  return null;
}

class AccountValidator {
  // Emailのバリデーション
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Emailを入力してください';
    }
    final spaceError = _checkSpaces(value);
    if (spaceError != null) return spaceError;

    String pattern = r'\b[\w\.-]+@[\w\.-]+\.\w{2,4}\b';
    if (!RegExp(pattern).hasMatch(value)) {
      return '有効なEmailアドレスを入力してください';
    }
    return null;
  }

  // パスワードのバリデーション
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'パスワードを入力してください';
    }
    final spaceError = _checkSpaces(value);
    if (spaceError != null) return spaceError;

    if (value.length < 10) {
      return 'パスワードは10文字以上である必要があります';
    }
    return null;
  }

  // ユーザー名のバリデーション
  static String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'ユーザ名を入力してください';
    }
    final spaceError = _checkSpaces(value);
    if (spaceError != null) return spaceError;

    String pattern = r'^[a-zA-Z0-9]+$';
    if (!RegExp(pattern).hasMatch(value)) {
      return 'ユーザ名には英数字のみ使用できます';
    }
    return null;
  }
}
