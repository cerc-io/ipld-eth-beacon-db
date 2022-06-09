
-- +goose Up
CREATE TABLE ethcl.known_gaps(
  start_slot bigint NOT NULL,
  end_slot bigint NOT NULL,
  checked_out boolean DEFAULT false NOT NULL,
  checked_out_by int,
  reprocessing_error text,
  entry_error text,
  entry_time timestamp without time zone DEFAULT (now() at time zone 'utc'),
  entry_process text,
  priority int DEFAULT 10,
  PRIMARY KEY (start_slot, end_slot)
);

-- +goose Down
DROP TABLE ethcl.known_gaps;
