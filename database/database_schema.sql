create table
  public.event (
    id uuid not null default gen_random_uuid (),
    user_id uuid not null default auth.uid (),
    created_at timestamp with time zone not null default now(),
    event_timestamp timestamp with time zone not null,
    title text not null,
    description text null,
    constraint event_pkey primary key (id),
    constraint event_user_id_fkey foreign key (user_id) references auth.users (id) on update cascade on delete cascade
  ) tablespace pg_default;