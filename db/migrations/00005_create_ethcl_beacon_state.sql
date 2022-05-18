
-- +goose Up
CREATE TABLE ethcl.beacon_state(
  slot bigint NOT NULL,
  state_root VARCHAR(66),
  mh_key text NOT NULL,
  FOREIGN KEY (mh_key) REFERENCES public.blocks(key) ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED,
  FOREIGN KEY (slot, state_root) REFERENCES ethcl.slots(slot, state_root) ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED,
  PRIMARY KEY (slot, state_root)
);

-- +goose Down
DROP TABLE ethcl.beacon_state;
