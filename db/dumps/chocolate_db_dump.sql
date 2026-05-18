WARNING:  database "chocolate_db" has a collation version mismatch
DETAIL:  The database was created using collation version 2.36, but the operating system provides version 2.41.
HINT:  Rebuild all objects in this database that use the default collation and run ALTER DATABASE chocolate_db REFRESH COLLATION VERSION, or build PostgreSQL with the right library version.
--
-- PostgreSQL database dump
--

\restrict UerOgZEOqYeK6PJlDY6wnBNEqxgJWxqP7RtjVldbd0jBkHXExVLaEa48lOaz2kx

-- Dumped from database version 15.15 (Debian 15.15-1.pgdg13+1)
-- Dumped by pg_dump version 15.15 (Debian 15.15-1.pgdg13+1)

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: chocolate_variants; Type: TABLE; Schema: public; Owner: chocolate_admin
--

CREATE TABLE public.chocolate_variants (
    id integer NOT NULL,
    chocolate_id integer NOT NULL,
    size character varying(50) NOT NULL,
    weight numeric(6,2),
    price numeric(8,2) NOT NULL
);


ALTER TABLE public.chocolate_variants OWNER TO chocolate_admin;

--
-- Name: chocolate_variants_id_seq; Type: SEQUENCE; Schema: public; Owner: chocolate_admin
--

CREATE SEQUENCE public.chocolate_variants_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.chocolate_variants_id_seq OWNER TO chocolate_admin;

--
-- Name: chocolate_variants_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: chocolate_admin
--

ALTER SEQUENCE public.chocolate_variants_id_seq OWNED BY public.chocolate_variants.id;


--
-- Name: chocolates; Type: TABLE; Schema: public; Owner: chocolate_admin
--

CREATE TABLE public.chocolates (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    ingredients text,
    photo_urls text[]
);


ALTER TABLE public.chocolates OWNER TO chocolate_admin;

--
-- Name: chocolates_id_seq; Type: SEQUENCE; Schema: public; Owner: chocolate_admin
--

CREATE SEQUENCE public.chocolates_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.chocolates_id_seq OWNER TO chocolate_admin;

--
-- Name: chocolates_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: chocolate_admin
--

ALTER SEQUENCE public.chocolates_id_seq OWNED BY public.chocolates.id;


--
-- Name: chocolate_variants id; Type: DEFAULT; Schema: public; Owner: chocolate_admin
--

ALTER TABLE ONLY public.chocolate_variants ALTER COLUMN id SET DEFAULT nextval('public.chocolate_variants_id_seq'::regclass);


--
-- Name: chocolates id; Type: DEFAULT; Schema: public; Owner: chocolate_admin
--

ALTER TABLE ONLY public.chocolates ALTER COLUMN id SET DEFAULT nextval('public.chocolates_id_seq'::regclass);


--
-- Data for Name: chocolate_variants; Type: TABLE DATA; Schema: public; Owner: chocolate_admin
--

COPY public.chocolate_variants (id, chocolate_id, size, weight, price) FROM stdin;
1	1	Small	50.00	5.50
2	1	Medium	100.00	9.90
3	2	Small	55.00	6.00
4	2	Medium	110.00	10.50
5	3	Small	60.00	6.20
6	3	Medium	120.00	11.20
7	4	Small	52.00	5.80
8	4	Medium	105.00	10.10
9	5	Small	58.00	6.10
10	5	Medium	115.00	11.00
11	6	Small	54.00	5.90
12	6	Medium	108.00	10.30
\.


--
-- Data for Name: chocolates; Type: TABLE DATA; Schema: public; Owner: chocolate_admin
--

COPY public.chocolates (id, name, ingredients, photo_urls) FROM stdin;
1	Dark Delight	Cocoa, Sugar, Milk	{/photos/dark_large_3.jpg,/photos/dark_small_1.jpg}
2	Hazelnut Delight	Cocoa, Sugar, Hazelnuts	{/photos/dark_large_3.jpg,/photos/dark_small_1.jpg}
3	Snickers	Peanut butter, nuts	{/photos/dark_large_3.jpg,/photos/dark_small_1.jpg}
4	Angel	Cotton candy, pistachio	{/photos/dark_large_3.jpg,/photos/dark_small_1.jpg}
5	Test	Surprise	{/photos/dark_large_3.jpg,/photos/dark_small_1.jpg}
6	Lazy	Biscuits, milk concentrate, pistachio	{/photos/dark_large_3.jpg,/photos/dark_small_1.jpg}
\.


--
-- Name: chocolate_variants_id_seq; Type: SEQUENCE SET; Schema: public; Owner: chocolate_admin
--

SELECT pg_catalog.setval('public.chocolate_variants_id_seq', 12, true);


--
-- Name: chocolates_id_seq; Type: SEQUENCE SET; Schema: public; Owner: chocolate_admin
--

SELECT pg_catalog.setval('public.chocolates_id_seq', 6, true);


--
-- Name: chocolate_variants chocolate_variants_pkey; Type: CONSTRAINT; Schema: public; Owner: chocolate_admin
--

ALTER TABLE ONLY public.chocolate_variants
    ADD CONSTRAINT chocolate_variants_pkey PRIMARY KEY (id);


--
-- Name: chocolates chocolates_pkey; Type: CONSTRAINT; Schema: public; Owner: chocolate_admin
--

ALTER TABLE ONLY public.chocolates
    ADD CONSTRAINT chocolates_pkey PRIMARY KEY (id);


--
-- Name: chocolate_variants chocolate_variants_chocolate_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: chocolate_admin
--

ALTER TABLE ONLY public.chocolate_variants
    ADD CONSTRAINT chocolate_variants_chocolate_id_fkey FOREIGN KEY (chocolate_id) REFERENCES public.chocolates(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict UerOgZEOqYeK6PJlDY6wnBNEqxgJWxqP7RtjVldbd0jBkHXExVLaEa48lOaz2kx

