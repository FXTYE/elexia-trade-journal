-- ============================================================
-- Elexia Trade Journal — Theme + UI Prefs Sync Migration
-- Run in: Supabase Dashboard → SQL Editor → New Query
-- ============================================================

-- Add theme column (stores admin customizer values as JSON)
ALTER TABLE user_settings
  ADD COLUMN IF NOT EXISTS theme JSONB DEFAULT NULL;

-- Add ui_prefs column (stores view mode preferences etc.)
ALTER TABLE user_settings
  ADD COLUMN IF NOT EXISTS ui_prefs JSONB DEFAULT NULL;
