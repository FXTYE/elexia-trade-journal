-- ============================================================
-- Elexia Trade Journal — Accounts v2 Migration
-- Run this in: Supabase Dashboard → SQL Editor → New Query
-- ============================================================

-- 1. Add eval_cost column to trading_accounts
ALTER TABLE trading_accounts
  ADD COLUMN IF NOT EXISTS eval_cost NUMERIC(12,2) DEFAULT 0;

-- 2. Create account_history table
CREATE TABLE IF NOT EXISTS account_history (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id     UUID REFERENCES auth.users NOT NULL,
  account_id  UUID REFERENCES trading_accounts(id) ON DELETE CASCADE NOT NULL,
  event_type  TEXT NOT NULL CHECK (event_type IN ('passed','failed','breached','expired','payout')),
  event_date  DATE NOT NULL,
  amount      NUMERIC(12,2) DEFAULT 0,
  note        TEXT DEFAULT '',
  created_at  TIMESTAMPTZ DEFAULT now()
);

-- 3. Enable Row Level Security
ALTER TABLE account_history ENABLE ROW LEVEL SECURITY;

-- 4. RLS Policy — users can only see/edit their own history
CREATE POLICY "Users manage own account history"
  ON account_history
  FOR ALL
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- 5. Index for fast per-account lookups
CREATE INDEX IF NOT EXISTS idx_account_history_account_id
  ON account_history(account_id);

CREATE INDEX IF NOT EXISTS idx_account_history_user_id
  ON account_history(user_id);
