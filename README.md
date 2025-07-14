# ExchangesApp

**ExchangesApp**는 전 세계 환율 정보를 실시간으로 조회하고, 간편하게 환율 계산까지 가능한 iOS 앱
**Swift**, **UIKit**, **MVVM**, **RxSwift**, **CoreData**를 기반으로 설계되었으며 
앱 상태 저장/복원, 검색, 즐겨찾기, 다크 모드 대응 등 사용자 편의성을 극대화한 기능을 제공

---

## 주요 기능

- 실시간 환율 정보 조회
- 통화 검색 기능 (`UISearchBar`)
- 즐겨찾기 추가/제거 기능 (CoreData)
- 환율 계산기 기능 (입력 → 변환)
- 다크모드 대응 (system 색상 사용)
- 앱 종료 후 마지막 화면 자동 복원 (CoreData 기반), 계산기 화면 제외..

---

## 사용 기술 스택

| 기술 | 설명 |
|------|------|
| Swift | 앱 전체 로직 구현 |
| UIKit | 사용자 UI 구성 |
| SnapKit | 오토레이아웃 코드 간결화 |
| RxSwift / RxCocoa | 검색창 실시간 반응 구현 |
| CoreData | 환율 정보, 즐겨찾기, 마지막 화면 정보 저장 |
| MVVM | 로직 분리 및 테스트 가능성 향상 |

---

## 주요 화면 소개

### ExchangeRateViewController.swift

- **환율 리스트 + 검색 기능**
- `RxSwift` 기반으로 `searchBar` 텍스트를 debounce 처리 후 실시간 필터링
- `noResultLabel`로 검색 결과 없을 시 사용자 안내
- 셀 선택 → 해당 통화에 대한 계산기로 이동 (`CalculatorViewController`)
- 앱 복귀 시 마지막 화면으로 저장

### CalculatorViewController.swift

- **입력값을 기반으로 환율 계산 결과 출력**
- 통화 코드 / 국가명 UI 상단에 표시
- `환율 × 입력 금액` 계산 → 포맷팅된 문자열로 결과 출력
- 입력값이 비어 있거나 숫자가 아닌 경우 알림 처리
- 앱이 이 화면에서 종료될 경우 해당 상태 CoreData에 저장

---

## 디렉토리 구조

```bash
ExchangesApp/
├── CoreData/                    # CoreData 모델 및 데이터 매니저
│   ├── CoreDataManager.swift   # 즐겨찾기/환율/화면 상태 저장
│   └── *.xcdatamodeld          # LastScreen, CurrencyRate, FavoriteCurrency
├── View/
│   ├── ExchangeRate/           # 환율 리스트 화면
│   ├── Calculator/             # 환율 계산기 화면
│   └── Components/             # 재사용 가능한 셀, UI 컴포넌트
├── ViewModel/
│   ├── ExchangeRateViewModel.swift  # 필터링, 데이터 fetch 로직
├── Service/
│   ├── ExchangeRateService.swift    # API 호출 및 응답 처리
│   └── CurrencyMapper.swift         # 통화 코드 ↔ 국가명 매핑
├── Resources/
│   ├── currencies.json         # 통화-국가 매핑 JSON
│   └── Assets.xcassets         # 앱 이미지 및 컬러
├── App/
│   ├── SceneDelegate.swift     # 앱 시작 시 화면 복원 처리
│   └── AppDelegate.swift       # CoreData 기본 설정 포함
