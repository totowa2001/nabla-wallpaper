# Nabla Wallpaper — 설치 가이드

QR → 월페이퍼 다운로드 + 방명록 페이지. 비용 0원, 15분 정도.

## 폴더 구성
- `index.html` — 페이지 본체
- `config.js` — Supabase 연결 정보 (2단계에서 채움)
- `guestbook.sql` — 방명록 테이블 생성 SQL
- `wallpaper/` — 월페이퍼 2종 (2880×5760, 1440×2880)
- `qr/` — QR 코드 (`https://totowa2001.github.io/nabla-wallpaper/` 기준)

## 1. Supabase 프로젝트 만들기
1. https://supabase.com 가입 → **New project** (Region: Northeast Asia (Seoul))
2. 왼쪽 **SQL Editor** → `guestbook.sql` 내용 전체 붙여넣기 → **Run**
3. **Table Editor**에 `guestbook` 테이블이 `id · name · created_at · message · is_public` 순으로 생겼는지 확인

## 2. 연결 정보 넣기
1. **Project Settings → API (또는 API Keys)** 에서 두 값을 복사
   - Project URL (`https://xxxx.supabase.co`)
   - `anon` 키 또는 `publishable` 키 (`sb_publishable_…`)
2. `config.js`의 두 값을 교체
3. ⚠️ `service_role` / `secret` 키는 절대 넣지 말 것 (웹에 공개됨)

## 3. GitHub Pages로 배포
1. GitHub에서 **새 Public 저장소** 생성 — 이름을 **`nabla-wallpaper`** 로 (QR이 이 주소 기준)
2. 이 폴더의 파일을 전부 업로드 (Add file → Upload files, 폴더째 드래그)
3. **Settings → Pages** → Source: `Deploy from a branch`, Branch: `main` / `(root)` → Save
4. 1–2분 뒤 `https://totowa2001.github.io/nabla-wallpaper/` 접속 확인
5. 방명록에 테스트 글 하나 남겨보고, Supabase Table Editor에 들어왔는지 확인 (테스트 글은 거기서 삭제)

## 비공개 방명록 보는 법
방문자가 '비공개'를 고른 글은 페이지와 공개 API 어디에도 노출되지 않고, Supabase 대시보드(관리자 권한)에서만 보입니다.

- **가장 간단**: Table Editor → `guestbook_private` 뷰 열기 → 비공개 글만 최신순, 한국 시간으로 정리돼 있음
- **전체 보기**: Table Editor → `guestbook` → `is_public` 열이 `false`인 행이 비공개 글 (상단 Filter로 `is_public = false`)
- **SQL로**: SQL Editor에서 `select * from guestbook_private;` 를 저장(Save)해 두면 다음부터 클릭 한 번
- **보관/백업**: 위 화면에서 Export → CSV
- 폰에서 확인: supabase.com 대시보드는 모바일 브라우저에서도 로그인해서 볼 수 있음

## 운영 메모
- 방문자는 글 **쓰기와 공개 글 읽기만** 가능. 부적절한 글 삭제는 Supabase Table Editor에서 직접.
- 작성 일시는 서버 시간으로 자동 기록되고, 화면엔 한국 시간으로 표시.
- 무료 플랜은 **7일간 요청이 없으면 일시정지**됨 → 전시 시작 직전에 한 번 접속해 두면 안전. 정지되면 대시보드에서 Restore.
- 방명록 백업: Table Editor → Export to CSV.
- 저장소 이름을 바꾸면 주소가 달라지니 QR도 다시 만들어야 함.
