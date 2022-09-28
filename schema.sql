--
-- PostgreSQL database dump
--

-- Dumped from database version 12.12
-- Dumped by pg_dump version 14.5 (Homebrew)

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
-- Name: historic_process; Type: TABLE; Schema: eth_beacon; Owner: -
--

CREATE TABLE eth_beacon.historic_process (
    start_slot bigint NOT NULL,
    end_slot bigint NOT NULL,
    checked_out boolean DEFAULT false NOT NULL,
    checked_out_by integer,
    entry_time timestamp without time zone DEFAULT timezone('utc'::text, now()),
    priority integer DEFAULT 10
);


--
-- Name: known_gaps; Type: TABLE; Schema: eth_beacon; Owner: -
--

CREATE TABLE eth_beacon.known_gaps (
    start_slot bigint NOT NULL,
    end_slot bigint NOT NULL,
    checked_out boolean DEFAULT false NOT NULL,
    checked_out_by integer,
    reprocessing_error text,
    entry_error text,
    entry_time timestamp without time zone DEFAULT timezone('utc'::text, now()),
    entry_process text,
    priority integer DEFAULT 10
);


--
-- Name: signed_block; Type: TABLE; Schema: eth_beacon; Owner: -
--

CREATE TABLE eth_beacon.signed_block (
    slot bigint NOT NULL,
    block_root character varying(66) NOT NULL,
    parent_block_root character varying(66),
    eth1_data_block_hash character varying(66),
    mh_key text NOT NULL,
    payload_block_number bigint,
    payload_timestamp bigint,
    payload_block_hash character varying(66),
    payload_parent_hash character varying(66),
    payload_state_root character varying(66),
    payload_receipts_root character varying(66),
    payload_transactions_root character varying(66)
);


--
-- Name: slots; Type: TABLE; Schema: eth_beacon; Owner: -
--

CREATE TABLE eth_beacon.slots (
    epoch bigint NOT NULL,
    slot bigint NOT NULL,
    block_root character varying(66) NOT NULL,
    state_root character varying(66),
    status text NOT NULL
);


--
-- Name: state; Type: TABLE; Schema: eth_beacon; Owner: -
--

CREATE TABLE eth_beacon.state (
    slot bigint NOT NULL,
    state_root character varying(66) NOT NULL,
    mh_key text NOT NULL
);


--
-- Name: blocks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.blocks (
    key text NOT NULL,
    data bytea NOT NULL
);


--
-- Name: goose_db_version; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.goose_db_version (
    id integer NOT NULL,
    version_id bigint NOT NULL,
    is_applied boolean NOT NULL,
    tstamp timestamp without time zone DEFAULT now()
);


--
-- Name: goose_db_version_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.goose_db_version_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: goose_db_version_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.goose_db_version_id_seq OWNED BY public.goose_db_version.id;


--
-- Name: goose_db_version id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.goose_db_version ALTER COLUMN id SET DEFAULT nextval('public.goose_db_version_id_seq'::regclass);


--
-- Name: historic_process historic_process_pkey; Type: CONSTRAINT; Schema: eth_beacon; Owner: -
--

ALTER TABLE ONLY eth_beacon.historic_process
    ADD CONSTRAINT historic_process_pkey PRIMARY KEY (start_slot, end_slot);


--
-- Name: known_gaps known_gaps_pkey; Type: CONSTRAINT; Schema: eth_beacon; Owner: -
--

ALTER TABLE ONLY eth_beacon.known_gaps
    ADD CONSTRAINT known_gaps_pkey PRIMARY KEY (start_slot, end_slot);


--
-- Name: signed_block signed_block_pkey; Type: CONSTRAINT; Schema: eth_beacon; Owner: -
--

ALTER TABLE ONLY eth_beacon.signed_block
    ADD CONSTRAINT signed_block_pkey PRIMARY KEY (block_root, slot);


--
-- Name: slots slots_pkey; Type: CONSTRAINT; Schema: eth_beacon; Owner: -
--

ALTER TABLE ONLY eth_beacon.slots
    ADD CONSTRAINT slots_pkey PRIMARY KEY (block_root, slot);


--
-- Name: slots slots_state_root_slot_key; Type: CONSTRAINT; Schema: eth_beacon; Owner: -
--

ALTER TABLE ONLY eth_beacon.slots
    ADD CONSTRAINT slots_state_root_slot_key UNIQUE (state_root, slot);


--
-- Name: state state_pkey; Type: CONSTRAINT; Schema: eth_beacon; Owner: -
--

ALTER TABLE ONLY eth_beacon.state
    ADD CONSTRAINT state_pkey PRIMARY KEY (state_root, slot);


--
-- Name: blocks blocks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.blocks
    ADD CONSTRAINT blocks_pkey PRIMARY KEY (key);


--
-- Name: goose_db_version goose_db_version_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.goose_db_version
    ADD CONSTRAINT goose_db_version_pkey PRIMARY KEY (id);


--
-- Name: signed_block_mh_index; Type: INDEX; Schema: eth_beacon; Owner: -
--

CREATE INDEX signed_block_mh_index ON eth_beacon.signed_block USING btree (mh_key);


--
-- Name: signed_block_payload_block_hash_index; Type: INDEX; Schema: eth_beacon; Owner: -
--

CREATE INDEX signed_block_payload_block_hash_index ON eth_beacon.signed_block USING btree (payload_block_hash);


--
-- Name: signed_block_slot_index; Type: INDEX; Schema: eth_beacon; Owner: -
--

CREATE INDEX signed_block_slot_index ON eth_beacon.signed_block USING brin (slot);


--
-- Name: slots_slot_index; Type: INDEX; Schema: eth_beacon; Owner: -
--

CREATE INDEX slots_slot_index ON eth_beacon.slots USING brin (slot);


--
-- Name: state_mh_index; Type: INDEX; Schema: eth_beacon; Owner: -
--

CREATE INDEX state_mh_index ON eth_beacon.state USING btree (mh_key);


--
-- Name: state_slot_index; Type: INDEX; Schema: eth_beacon; Owner: -
--

CREATE INDEX state_slot_index ON eth_beacon.state USING brin (slot);


--
-- Name: signed_block signed_block_block_root_slot_fkey; Type: FK CONSTRAINT; Schema: eth_beacon; Owner: -
--

ALTER TABLE ONLY eth_beacon.signed_block
    ADD CONSTRAINT signed_block_block_root_slot_fkey FOREIGN KEY (block_root, slot) REFERENCES eth_beacon.slots(block_root, slot) ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;


--
-- Name: signed_block signed_block_mh_key_fkey; Type: FK CONSTRAINT; Schema: eth_beacon; Owner: -
--

ALTER TABLE ONLY eth_beacon.signed_block
    ADD CONSTRAINT signed_block_mh_key_fkey FOREIGN KEY (mh_key) REFERENCES public.blocks(key) ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;


--
-- Name: state state_mh_key_fkey; Type: FK CONSTRAINT; Schema: eth_beacon; Owner: -
--

ALTER TABLE ONLY eth_beacon.state
    ADD CONSTRAINT state_mh_key_fkey FOREIGN KEY (mh_key) REFERENCES public.blocks(key) ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;


--
-- Name: state state_state_root_slot_fkey; Type: FK CONSTRAINT; Schema: eth_beacon; Owner: -
--

ALTER TABLE ONLY eth_beacon.state
    ADD CONSTRAINT state_state_root_slot_fkey FOREIGN KEY (state_root, slot) REFERENCES eth_beacon.slots(state_root, slot) ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;


--
-- PostgreSQL database dump complete
--

