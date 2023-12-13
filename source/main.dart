import 'dart:io';

void main() {
  String dictionaryContent = File(['data', 'dictionary.txt'].join(Platform.pathSeparator)).readAsStringSync().toLowerCase();
  String inputContent = File(['data', 'input.txt'].join(Platform.pathSeparator)).readAsStringSync().toLowerCase();

  List unknownWords = [];
  Map dictionaryTree = {};
  
  Map analyzingTreeBranch = dictionaryTree;

  for (int characterIndex = 0; characterIndex < dictionaryContent.length; characterIndex++) {
    String dictionaryCharacter = dictionaryContent[characterIndex];

    if (dictionaryCharacter == '\n') {
      analyzingTreeBranch = dictionaryTree;
      continue;
    }

    if (!analyzingTreeBranch.containsKey(dictionaryCharacter)) {
      analyzingTreeBranch[dictionaryCharacter] = {};
    }

    if (characterIndex != dictionaryContent.length - 1) {
      analyzingTreeBranch = analyzingTreeBranch[dictionaryCharacter];
    }

    else {
      analyzingTreeBranch = dictionaryTree;
    }
  }
  
  
  String analyzingWord = '';
  bool? isWordKnown;

  for (int characterIndex = 0; characterIndex < inputContent.length; characterIndex++) {
    String inputCharacter = inputContent[characterIndex];

    if (SEPARATION_CHARACTERS.contains(inputCharacter)) {
      if (isWordKnown == false && analyzingWord != '') {
        try {
          double.parse(analyzingWord);
        }

        catch (exception) {
          if (!unknownWords.contains(analyzingWord)) {
            unknownWords.add(analyzingWord);
          }

          int unknownWordIndex = characterIndex - analyzingWord.length;

          print('\x1B[36m' + 'An unknown word was found at index ${unknownWordIndex}: ' + '\x1B[0m' + '${analyzingWord}'); 
        }

      }

      analyzingTreeBranch = dictionaryTree;
      analyzingWord = '';

      continue;
    }

    bool isCharacterInBranch = analyzingTreeBranch.containsKey(inputCharacter);

    if (isCharacterInBranch) {
      analyzingTreeBranch = analyzingTreeBranch[inputCharacter];
    }

    analyzingWord += inputCharacter;
    isWordKnown = isCharacterInBranch;
  }
  
  print('\n' + '\x1B[32m' + 'All ${unknownWords.length} unknown words: ' + '\x1B[0m' + '${unknownWords}' + '\n');
}

const SEPARATION_CHARACTERS = ['\n', ' ', ' ', '.', ',', '·', '-', ':', ';', '!', '?', '/', '\\', '(', ')', '*', '%', '#', '@', '"', "'", '©'];