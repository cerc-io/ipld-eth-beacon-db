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
-- Name: ethcl; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA ethcl;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: slots; Type: TABLE; Schema: ethcl; Owner: -
--

CREATE TABLE ethcl.slots(
    epoch bigint NOT NULL,
    slot bigint NOT NULL,
    block_root VARCHAR(66),
    state_root VARCHAR(66),
    status text NOT NULL
);

--
-- Name: signed_beacon_block; Type: TABLE; Schema: ethcl; Owner: -
--

CREATE TABLE ethcl.signed_beacon_block(
    slot bigint NOT NULL,
    block_root VARCHAR(66),
    parent_block_root VARCHAR(66),
    eth1_block_hash VARCHAR(66),
    mh_key text NOT NULL
);

--
-- Name: beacon_state; Type: TABLE; Schema: ethcl; Owner: -
--

CREATE TABLE ethcl.beacon_state(
    slot bigint NOT NULL,
    state_root VARCHAR(66),
    mh_key text NOT NULL
);

--
-- Name: known_gaps; Type: TABLE; Schema: ethcl; Owner: -
--

CREATE TABLE ethcl.known_gaps (
  start_slot bigint NOT NULL,
  end_slot bigint NOT NULL,
  checked_out boolean DEFAULT false NOT NULL,
  reprocessing_error text,
  entry_error text,
  entry_time timestamp without time zone DEFAULT (now() at time zone 'utc'),
  entry_process text
);

--
-- Name: blocks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.blocks (
    key text NOT NULL,
    data bytea NOT NULL
);

--
-- Name: slots slots_pkey; Type: CONSTRAINT; Schema: ethcl; Owner: -
--

ALTER TABLE ONLY ethcl.slots
    ADD CONSTRAINT slots_pkey PRIMARY KEY (slot, block_root);

--
-- Name: slots signed_beacon_block_pkey; Type: CONSTRAINT; Schema: ethcl; Owner: -
--

ALTER TABLE ONLY ethcl.signed_beacon_block
    ADD CONSTRAINT signed_beacon_block_pkey PRIMARY KEY (slot, block_root);

--
-- Name: slots beacon_state_pkey; Type: CONSTRAINT; Schema: ethcl; Owner: -
--

ALTER TABLE ONLY ethcl.beacon_state
    ADD CONSTRAINT beacon_state_pkey PRIMARY KEY (slot, state_root);

--
-- Name: slots known_gaps; Type: CONSTRAINT; Schema: ethcl; Owner: -
--

ALTER TABLE ONLY ethcl.known_gaps
    ADD CONSTRAINT known_gaps_pkey PRIMARY KEY (start_slot, end_slot);

--
-- Name: blocks blocks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.blocks
    ADD CONSTRAINT blocks_pkey PRIMARY KEY (key);

--
-- Name: beacon_state_mh_index; Type: INDEX; Schema: eth; Owner: -
--

CREATE UNIQUE INDEX beacon_state_mh_index ON ethcl.beacon_state USING btree (mh_key);

--
-- Name: slots signed_beacon_block_mh_key_fkey; Type: FK CONSTRAINT; Schema: eth; Owner: -
--

ALTER TABLE ONLY ethcl.signed_beacon_block
    ADD CONSTRAINT signed_beacon_block_mh_key_fkey (mh_key) REFERENCES public.blocks(key) ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;

--
-- Name: slots signed_beacon_block_slot_fkey; Type: FK CONSTRAINT; Schema: eth; Owner: -
--

ALTER TABLE ONLY ethcl.signed_beacon_block
  ADD CONSTRAINT signed_beacon_block_slot_fkey (slot, block_root) REFERENCES ethcl.slots(slot, block_root) ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;

--
-- Name: slots beacon_state_mh_key_fkey; Type: FK CONSTRAINT; Schema: eth; Owner: -
--

ALTER TABLE ONLY ethcl.beacon_state
    ADD CONSTRAINT beacon_state_mh_key_fkey FOREIGN KEY (mh_key) REFERENCES public.blocks(key) ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;

--
-- Name: slots beacon_state_slot_fkey; Type: FK CONSTRAINT; Schema: eth; Owner: -
--

ALTER TABLE ONLY ethcl.beacon_state
  ADD CONSTRAINT beacon_state_slot_fkey (slot, state_root) REFERENCES ethcl.slots(slot, state_root) ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;