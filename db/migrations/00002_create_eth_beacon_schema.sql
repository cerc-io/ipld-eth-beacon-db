-- +goose Up
CREATE SCHEMA eth_beacon;

-- +goose Down
DROP SCHEMA eth_beacon;
