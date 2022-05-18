
-- +goose Up
CREATE TABLE ethcl.signed_beacon_block(
  slot bigint NOT NULL,
  block_root VARCHAR(66) UNIQUE,
  parent_block_root VARCHAR(66),
  eth1_block_hash VARCHAR(66),
  mh_key text NOT NULL,
  FOREIGN KEY (slot, block_root) REFERENCES ethcl.slots(slot, block_root) ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED,
  FOREIGN KEY (mh_key) REFERENCES public.blocks(key) ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED,
  PRIMARY KEY (slot, block_root)
);

-- +goose Down
DROP TABLE ethcl.signed_beacon_block;
