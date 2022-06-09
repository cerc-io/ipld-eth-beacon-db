
-- +goose Up
CREATE TABLE eth_beacon.state(
  slot bigint NOT NULL,
  state_root VARCHAR(66),
  mh_key text NOT NULL,
  FOREIGN KEY (mh_key) REFERENCES public.blocks(key) ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED,
  FOREIGN KEY (state_root, slot) REFERENCES eth_beacon.slots(state_root, slot) ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED,
  PRIMARY KEY (state_root, slot)
);

CREATE INDEX state_slot_index ON eth_beacon.state USING brin (slot);
CREATE INDEX state_mh_index ON eth_beacon.state USING btree (mh_key);

-- +goose Down
DROP TABLE eth_beacon.state;
