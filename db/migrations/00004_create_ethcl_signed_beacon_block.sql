
-- +goose Up
CREATE TABLE ethcl.signed_beacon_block(
  slot bigint NOT NULL,
  block_root VARCHAR(66),
  parent_block_root VARCHAR(66),
  eth1_block_hash VARCHAR(66),
  mh_key text NOT NULL,
  FOREIGN KEY (block_root, slot) REFERENCES ethcl.slots(block_root, slot) ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED,
  FOREIGN KEY (mh_key) REFERENCES public.blocks(key) ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED,
  INDEX USING brin (slot),
  PRIMARY KEY (block_root, slot)
);

-- +goose Down
DROP TABLE ethcl.signed_beacon_block;
