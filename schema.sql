--
-- PostgreSQL database dump
--

-- Dumped from database version 14beta3
-- Dumped by pg_dump version 14beta3

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: eth_beacon; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA eth_beacon;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: slots; Type: TABLE; Schema: eth_beacon; Owner: -
--

CREATE TABLE eth_beacon.slots(
    epoch bigint NOT NULL,
    slot bigint NOT NULL,
    block_root VARCHAR(66),
    state_root VARCHAR(66),
    status text NOT NULL
);

--
-- Name: signed_block; Type: TABLE; Schema: eth_beacon; Owner: -
--

CREATE TABLE eth_beacon.signed_block(
    slot bigint NOT NULL,
    block_root VARCHAR(66),
    parent_block_root VARCHAR(66),
    eth1_block_hash VARCHAR(66),
    mh_key text NOT NULL
);

--
-- Name: state; Type: TABLE; Schema: eth_beacon; Owner: -
--

CREATE TABLE eth_beacon.state(
    slot bigint NOT NULL,
    state_root VARCHAR(66),
    mh_key text NOT NULL
);

--
-- Name: known_gaps; Type: TABLE; Schema: eth_beacon; Owner: -
--

CREATE TABLE eth_beacon.known_gaps (
  start_slot bigint NOT NULL,
  end_slot bigint NOT NULL,
  checked_out boolean DEFAULT false NOT NULL,
  checked_out_by int,
  reprocessing_error text,
  entry_error text,
  entry_time timestamp without time zone DEFAULT (now() at time zone 'utc'),
  entry_process text,
  priority int DEFAULT 10
);

--
-- Name: historic_process; Type: TABLE; Schema: eth_beacon; Owner: -
--

CREATE TABLE eth_beacon.historic_process (
  start_slot bigint NOT NULL,
  end_slot bigint NOT NULL,
  checked_out boolean DEFAULT false NOT NULL,
  checked_out_by int,
  entry_time timestamp without time zone DEFAULT (now() at time zone 'utc'),
  priority int DEFAULT 10
);

--
-- Name: blocks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.blocks (
    key text NOT NULL,
    data bytea NOT NULL
);

--
-- Name: slots slots_pkey; Type: CONSTRAINT; Schema: eth_beacon; Owner: -
--

ALTER TABLE ONLY eth_beacon.slots
    ADD CONSTRAINT slots_pkey PRIMARY KEY (block_root, slot);

--
-- Name: slots unique_slot_state_root; Type: CONSTRAINT; Schema: eth_beacon; Owner: -
--

ALTER TABLE ONLY eth_beacon.slots
    ADD CONSTRAINT unique_slot_state_root UNIQUE (state_root, slot);

--
-- Name: slots signed_block_pkey; Type: CONSTRAINT; Schema: eth_beacon; Owner: -
--

ALTER TABLE ONLY eth_beacon.signed_block
    ADD CONSTRAINT signed_block_pkey PRIMARY KEY (block_root, slot);

--
-- Name: slots state_pkey; Type: CONSTRAINT; Schema: eth_beacon; Owner: -
--

ALTER TABLE ONLY eth_beacon.state
    ADD CONSTRAINT state_pkey PRIMARY KEY (state_root, slot);

--
-- Name: slots known_gaps_pkey; Type: CONSTRAINT; Schema: eth_beacon; Owner: -
--

ALTER TABLE ONLY eth_beacon.known_gaps
    ADD CONSTRAINT known_gaps_pkey PRIMARY KEY (start_slot, end_slot);

--
-- Name: slots historic_process_pkey; Type: CONSTRAINT; Schema: eth_beacon; Owner: -
--

ALTER TABLE ONLY eth_beacon.historic_process
    ADD CONSTRAINT historic_process_pkey PRIMARY KEY (start_slot, end_slot);

--
-- Name: blocks blocks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.blocks
    ADD CONSTRAINT blocks_pkey PRIMARY KEY (key);

--
-- Name: slots_slot_index; Type: INDEX; Schema: eth; Owner: -
--

CREATE INDEX slots_slot_index ON eth_beacon.slots USING brin (slot);

--
-- Name: signed_block_slot_index; Type: INDEX; Schema: eth; Owner: -
--

CREATE INDEX signed_block_slot_index ON eth_beacon.signed_block USING brin (slot);

--
-- Name: state_slot_index; Type: INDEX; Schema: eth; Owner: -
--

CREATE INDEX state_slot_index ON eth_beacon.state USING brin (slot);

--
-- Name: signed_block_mh_index; Type: INDEX; Schema: eth; Owner: -
--

CREATE INDEX signed_block_mh_index ON eth_beacon.signed_block USING btree (mh_key);

--
-- Name: state_mh_index; Type: INDEX; Schema: eth; Owner: -
--

CREATE INDEX state_mh_index ON eth_beacon.state USING btree (mh_key);

--
-- Name: slots signed_block_mh_key_fkey; Type: FK CONSTRAINT; Schema: eth; Owner: -
--

ALTER TABLE ONLY eth_beacon.signed_block
    ADD CONSTRAINT signed_block_mh_key_fkey FOREIGN KEY (mh_key) REFERENCES public.blocks(key) ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;

--
-- Name: slots signed_block_slot_fkey; Type: FK CONSTRAINT; Schema: eth; Owner: -
--

ALTER TABLE ONLY eth_beacon.signed_block
  ADD CONSTRAINT signed_block_slot_fkey FOREIGN KEY (block_root, slot) REFERENCES eth_beacon.slots(block_root, slot) ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;

--
-- Name: slots state_mh_key_fkey; Type: FK CONSTRAINT; Schema: eth; Owner: -
--

ALTER TABLE ONLY eth_beacon.state
    ADD CONSTRAINT state_mh_key_fkey FOREIGN KEY (mh_key) REFERENCES public.blocks(key) ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;

--
-- Name: slots state_slot_fkey; Type: FK CONSTRAINT; Schema: eth; Owner: -
--

ALTER TABLE ONLY eth_beacon.state
  ADD CONSTRAINT state_slot_fkey FOREIGN KEY (state_root, slot) REFERENCES eth_beacon.slots(state_root, slot) ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;