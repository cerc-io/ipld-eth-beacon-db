-- +goose Up
CREATE TABLE ethcl.slots (
  epoch bigint NOT NULL,
  slot bigint NOT NULL,
  block_root VARCHAR(66),
  state_root VARCHAR(66),
  status text NOT NULL,
  UNIQUE (state_root, slot),
  PRIMARY KEY (block_root, slot)
);

CREATE INDEX slots_slot_index ON ethcl.slots USING brin (slot);

-- +goose Down
DROP TABLE ethcl.slots;
