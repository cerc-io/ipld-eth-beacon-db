
-- +goose Up
CREATE TABLE eth_beacon.historic_process (
  start_slot bigint NOT NULL,
  end_slot bigint NOT NULL,
  checked_out boolean DEFAULT false NOT NULL,
  checked_out_by int,
  entry_time timestamp without time zone DEFAULT (now() at time zone 'utc'),
  priority int DEFAULT 10,
  PRIMARY KEY (start_slot, end_slot)
);

-- +goose Down
DROP TABLE eth_beacon.historic_process;