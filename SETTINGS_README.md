# Ghost Screen Saver - 설정 가능한 버전

이 프로젝트는 SwiftUI 기반의 설정 인터페이스를 통해 사용자가 폰트 크기와 하이라이트 색상을 조정할 수 있는 macOS 스크린 세이버입니다.

## 기능

- **사용자 정의 폰트 크기**: 8pt부터 24pt까지 조정 가능
- **사용자 정의 하이라이트 색상**: 색상 피커를 통해 하이라이트 텍스트의 색상 변경
- **SwiftUI 기반 설정 인터페이스**: 직관적이고 현대적인 설정 UI
- **실시간 설정 저장**: ScreenSaverDefaults를 사용하여 설정 자동 저장

## 구현된 구성 요소

### 1. GhostScreenSaverConfigView.swift
SwiftUI로 구현된 설정 뷰입니다:
- 폰트 크기 슬라이더 (8-24pt)
- 색상 피커로 하이라이트 색상 선택
- 기본값으로 재설정 버튼
- 실시간 설정 저장

### 2. GhostScreenSaverView.swift (수정됨)
기존 스크린 세이버 뷰에 다음 기능을 추가했습니다:
- 사용자 설정 읽기 메서드
- 설정 시트 지원 (`hasConfigureSheet`, `configureSheet`)
- 동적 폰트 크기 및 색상 적용

## 설정 저장 방식

설정은 `ScreenSaverDefaults`를 사용하여 저장됩니다:

```swift
// UserDefaults 키
static let fontSize = "GhostScreenSaver.fontSize"
static let highlightColorRed = "GhostScreenSaver.highlightColor.red"
static let highlightColorGreen = "GhostScreenSaver.highlightColor.green"
static let highlightColorBlue = "GhostScreenSaver.highlightColor.blue"
static let highlightColorAlpha = "GhostScreenSaver.highlightColor.alpha"
```

## 사용법

1. **빌드**: Xcode에서 프로젝트를 빌드합니다
2. **설치**: 생성된 `.saver` 파일을 더블 클릭하여 설치
3. **설정**: 시스템 환경설정 > 데스크탑 및 스크린 세이버에서 "Ghost Screen Saver" 선택
4. **사용자 정의**: "옵션..." 버튼을 클릭하여 설정 인터페이스 열기

## 설정 인터페이스

설정 창에서 다음을 조정할 수 있습니다:

### 폰트 크기
- 슬라이더로 8pt~24pt 범위에서 조정
- 실시간으로 값이 표시되며 즉시 저장

### 하이라이트 색상  
- 색상 피커를 통해 원하는 색상 선택
- RGB 및 알파 값이 자동으로 저장

### 기본값 재설정
- 폰트 크기: 12pt
- 하이라이트 색상: 시스템 파란색

## 기술적 세부사항

### 의존성
- ScreenSaver.framework
- SwiftUI
- AppKit

### 호환성
- macOS 15.5+
- Swift 6.0+

### 아키텍처
- MVVM 패턴으로 설정 뷰 구현
- ScreenSaverDefaults를 통한 설정 영속성
- 동적 설정 로딩으로 실시간 변경 반영

## 향후 개선 사항

- [ ] 더 많은 색상 옵션 (배경색, 기본 텍스트 색상 등)
- [ ] 애니메이션 속도 조절
- [ ] 폰트 패밀리 선택 옵션
- [ ] 텍스트 위치 조정 (중앙, 좌측, 우측 등)
- [ ] 프리뷰 기능 추가

## 라이선스

MIT 라이선스에 따라 배포됩니다. 자세한 내용은 LICENSE 파일을 참조하세요.
