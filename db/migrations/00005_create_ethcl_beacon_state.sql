
-- +goose Up
CREATE TABLE ethcl.beacon_state(
  slot bigint NOT NULL,
  state_root VARCHAR(66),
  mh_key text NOT NULL,
  FOREIGN KEY (mh_key) REFERENCES public.blocks(key) ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED,
  FOREIGN KEY (state_root, slot) REFERENCES ethcl.slots(state_root, slot) ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED,
  INDEX beacon_state_slot_index ON ethcl.beacon_state USING brin (slot),
  PRIMARY KEY (state_root, slot)
);

-- +goose Down
DROP TABLE ethcl.beacon_state;
