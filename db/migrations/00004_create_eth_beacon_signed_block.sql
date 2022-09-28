
-- +goose Up
CREATE TABLE eth_beacon.signed_block(
  slot bigint NOT NULL,
  block_root VARCHAR(66),
  parent_block_root VARCHAR(66),
  eth1_data_block_hash VARCHAR(66),
  mh_key text NOT NULL,
  payload_block_number bigint,
  payload_timestamp bigint,
  payload_block_hash VARCHAR(66),
  payload_parent_hash VARCHAR(66),
  payload_state_root VARCHAR(66),
  payload_receipts_root VARCHAR(66),
  payload_transactions_root VARCHAR(66),
  FOREIGN KEY (block_root, slot) REFERENCES eth_beacon.slots(block_root, slot) ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED,
  FOREIGN KEY (mh_key) REFERENCES public.blocks(key) ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED,
  PRIMARY KEY (block_root, slot)
);

CREATE INDEX signed_block_slot_index ON eth_beacon.signed_block USING brin (slot);
CREATE INDEX signed_block_mh_index ON eth_beacon.signed_block USING btree (mh_key);
CREATE INDEX signed_block_payload_block_hash_index ON eth_beacon.signed_block USING btree (payload_block_hash);

-- +goose Down
DROP TABLE eth_beacon.signed_block;
