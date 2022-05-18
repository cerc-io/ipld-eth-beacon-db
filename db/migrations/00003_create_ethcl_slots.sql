-- +goose Up
CREATE TABLE ethcl.slots (
  epoch bigint NOT NULL,
  slot bigint NOT NULL,
  block_root VARCHAR(66),
  state_root VARCHAR(66),
  status text NOT NULL,
  UNIQUE (state_root, slot),
  INDEX USING brin (slot),
  PRIMARY KEY (block_root, slot)
);

-- +goose Down
DROP TABLE ethcl.slots;
