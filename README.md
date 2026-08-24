# iOS Prototype (DDOSPrototype)

Тестовое приложение-заглушка в стиле "жидкое стекло" (glassmorphism) на SwiftUI.

## Структура репозитория

```
.
├── DDOSPrototype/
│   ├── App.swift
│   ├── ContentView.swift
│   └── Info.plist
├── .github/workflows/
│   └── build.yml
├── project.yml
├── exportOptions.plist
└── README.md
```

## Сборка IPA через GitHub Actions

1. Создай репозиторий на GitHub и загрузи все файлы из этой папки.
2. Перейди в Actions → выбери workflow "Build and Export IPA" → запусти вручную (или сделай push в main).
3. После завершения сборки скачай артефакт `DDOSPrototype.ipa`.

## Ручная сборка (если есть Xcode)

Если у тебя есть Xcode, можно собрать локально:

```bash
# Установи xcodegen (если ещё нет)
brew install xcodegen

# Сгенерируй проект
xcodegen generate

# Открой проект
open DDOSPrototype.xcodeproj
```

Или собери через командную строку:

```bash
xcodebuild archive -project DDOSPrototype.xcodeproj -scheme DDOSPrototype -archivePath build/DDOSPrototype.xcarchive -sdk iphoneos CODE_SIGNING_ALLOWED=NO
xcodebuild -exportArchive -archivePath build/DDOSPrototype.xcarchive -exportPath build/ipa -exportOptionsPlist exportOptions.plist CODE_SIGNING_ALLOWED=NO
```

## Примечания

- Проект не требует сторонних библиотек, только SwiftUI.
- Для подписи IPA нужен Apple Developer аккаунт. В GitHub Actions используется `CODE_SIGNING_ALLOWED=NO` для сборки без подписи (можно установить позже через сервисы или использовать ad-hoc).
- Если нужна полноценная подпись, заполни `teamID` в `exportOptions.plist` и настрой сертификаты.
