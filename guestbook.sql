-- Nabla 방명록 테이블
-- 저장 순서: 이름 → 작성 일시(자동) → 내용(최대 1000자) → 공개 여부
-- Supabase 대시보드 > SQL Editor 에 통째로 붙여넣고 Run
-- (이전 버전 SQL을 이미 실행했어도 그대로 다시 Run 하면 됨)

create table if not exists public.guestbook (
  id          uuid primary key default gen_random_uuid(),
  name        text        not null check (char_length(btrim(name)) between 1 and 30),
  created_at  timestamptz not null default now(),
  message     text        not null check (char_length(btrim(message)) between 1 and 1000),
  is_public   boolean     not null default true
);

-- 이전 버전에서 만든 테이블이면 공개 여부 칸만 추가
alter table public.guestbook add column if not exists is_public boolean not null default true;

create index if not exists guestbook_created_at_idx on public.guestbook (created_at desc);

alter table public.guestbook enable row level security;

-- 방문자(로그인 없음)
--   읽기: 공개 글만 (비공개 글은 페이지·API 어디서도 안 보임)
--   쓰기: 가능 / 수정·삭제: 불가
drop policy if exists "guestbook read"  on public.guestbook;
drop policy if exists "guestbook write" on public.guestbook;
create policy "guestbook read"  on public.guestbook for select to anon using (is_public);
create policy "guestbook write" on public.guestbook for insert to anon with check (true);

-- 방문자는 이름·내용·공개 여부만 넣을 수 있음 → 작성 일시는 항상 서버 시간으로 자동 기록
revoke all on public.guestbook from anon, authenticated;
grant select on public.guestbook to anon;
grant insert (name, message, is_public) on public.guestbook to anon;

-- 작가 전용 보기: 비공개 글만 최신순
-- (대시보드의 Table Editor / SQL Editor는 관리자 권한이라 비공개 글도 보임.
--  이 뷰는 방문자에게 열려 있지 않음)
create or replace view public.guestbook_private
with (security_invoker = true) as
  select name, created_at at time zone 'Asia/Seoul' as created_at_kst, message
  from public.guestbook
  where not is_public
  order by created_at desc;
revoke all on public.guestbook_private from anon, authenticated;
