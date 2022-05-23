
-- +goose Up
CREATE TABLE ethcl.historic_process (
  start_slot bigint NOT NULL,
  end_slot bigint NOT NULL,
  checked_out boolean DEFAULT false NOT NULL,
  entry_time timestamp without time zone DEFAULT (now() at time zone 'utc'),
  priority int DEFAULT 10,
  PRIMARY KEY (start_slot, end_slot)
);

-- +goose Down
DROP TABLE ethcl.historic_process;