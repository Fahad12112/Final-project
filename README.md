Task Manager App

A simple and clean mobile app to manage your daily tasks — built with Flutter and Supabase.

About

Task Manager helps you stay organized by letting you add, complete, and delete tasks from anywhere. All your data is saved instantly to the cloud using Supabase, so nothing gets lost.

Features

Authentication — Sign up and log in with email & password

Add Tasks — Quickly add tasks with a title

Complete Tasks — Check off tasks when you're done

Delete Tasks — Remove tasks you no longer need

Profile & Stats — See how many tasks you've completed

Cloud Storage — All data saved in real-time with Supabase


Project Structure

<img width="452" height="611" alt="Screenshot 2026-02-22 172724" src="https://github.com/user-attachments/assets/4c5e5891-397f-4b50-89d9-3123b3e6124c" />


Database Table

<img width="1276" height="601" alt="Screenshot 2026-02-22 172942" src="https://github.com/user-attachments/assets/efd0e9c1-0196-441d-b03c-49a5eb726e1b" />

Supabase Setup

1. Create the table sql

create table tasks (

  id uuid primary key default gen_random_uuid(),
  
  user_id uuid references auth.users(id) on delete cascade,
  
  title text not null,
  
  is_done boolean default false,
  
  created_at timestamptz default now()
  
);

2. Enable Row Level Security sql
 
alter table tasks enable row level security;

create policy "insert own tasks" on task

  for insert with check (auth.uid() = user_id);

create policy "select own tasks" on tasks

  for select using (auth.uid() = user_id);

create policy "update own tasks" on tasks

  for update using (auth.uid() = user_id);

create policy "delete own tasks" on tasks

  for delete using (auth.uid() = user_id);
  
3. Add your credentials in lib/main.dart
   
darturl: 'YOUR_SUPABASE_URL',

anonKey: 'YOUR_SUPABASE_ANON_KEY',

Getting Started

bashflutter pub get

flutter run

Built With


Flutter

Supabase

Dart


Screenshots

<img width="989" height="1566" alt="Screenshot 2026-02-22 172144" src="https://github.com/user-attachments/assets/1b0c9eb3-51f1-4167-86aa-09a022e6e169" />
<img width="997" height="1650" alt="Screenshot 2026-02-22 172244" src="https://github.com/user-attachments/assets/9b4d500a-ebfb-47e3-a34c-40bf32dae3b8" />
<img width="998" height="1649" alt="Screenshot 2026-02-22 172427" src="https://github.com/user-attachments/assets/e0b5fcef-fecf-490f-bf63-bcd396cfacd1" />
<img width="1000" height="1645" alt="Screenshot 2026-02-22 172443" src="https://github.com/user-attachments/assets/d07500d5-906a-4b6c-a368-228d2bb4cec7" />
<img width="998" height="1650" alt="Screenshot 2026-02-22 172514" src="https://github.com/user-attachments/assets/7a437940-4e50-4a7f-a650-84519f2fe5cd" />



Made with love as a final project for the Flutter Bootcamp — TechNation




