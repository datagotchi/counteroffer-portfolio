--
-- PostgreSQL database dump
--

-- Dumped from database version 13.4
-- Dumped by pg_dump version 14.12 (Homebrew)

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
-- Name: experiences; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.experiences (
    id integer NOT NULL,
    user_id integer NOT NULL,
    title text NOT NULL,
    company text NOT NULL,
    startdate date NOT NULL,
    enddate date,
    summary text,
    is_education boolean DEFAULT false
);


ALTER TABLE public.experiences OWNER TO postgres;

--
-- Name: experiences_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.experiences_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.experiences_id_seq OWNER TO postgres;

--
-- Name: experiences_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.experiences_id_seq OWNED BY public.experiences.id;


--
-- Name: facts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.facts (
    id integer NOT NULL,
    user_id integer NOT NULL,
    key text NOT NULL,
    value text NOT NULL,
    theme_id integer
);


ALTER TABLE public.facts OWNER TO postgres;

--
-- Name: facts_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.facts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.facts_id_seq OWNER TO postgres;

--
-- Name: facts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.facts_id_seq OWNED BY public.facts.id;


--
-- Name: jobs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.jobs (
    id integer NOT NULL,
    user_id integer NOT NULL,
    email text NOT NULL,
    company text,
    archived boolean DEFAULT false NOT NULL
);


ALTER TABLE public.jobs OWNER TO postgres;

--
-- Name: jobs_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.jobs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.jobs_id_seq OWNER TO postgres;

--
-- Name: jobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.jobs_id_seq OWNED BY public.jobs.id;


--
-- Name: messages; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.messages (
    id integer NOT NULL,
    value text,
    question_id integer NOT NULL,
    sender text,
    job_id integer,
    datetime timestamp without time zone
);


ALTER TABLE public.messages OWNER TO postgres;

--
-- Name: messages_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.messages_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.messages_id_seq OWNER TO postgres;

--
-- Name: messages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.messages_id_seq OWNED BY public.messages.id;


--
-- Name: publications; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.publications (
    id integer NOT NULL,
    user_id integer NOT NULL,
    title text NOT NULL,
    venue text NOT NULL,
    link text,
    experience_id integer NOT NULL,
    date date NOT NULL,
    authors text
);


ALTER TABLE public.publications OWNER TO postgres;

--
-- Name: publications_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.publications_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.publications_id_seq OWNER TO postgres;

--
-- Name: publications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.publications_id_seq OWNED BY public.publications.id;


--
-- Name: questions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.questions (
    id integer NOT NULL,
    user_id integer NOT NULL,
    question character varying(255),
    type character varying(20),
    required boolean DEFAULT true NOT NULL
);


ALTER TABLE public.questions OWNER TO postgres;

--
-- Name: questions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.questions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.questions_id_seq OWNER TO postgres;

--
-- Name: questions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.questions_id_seq OWNED BY public.questions.id;


--
-- Name: tags; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tags (
    id integer NOT NULL,
    experience_id integer NOT NULL,
    value text NOT NULL
);


ALTER TABLE public.tags OWNER TO postgres;

--
-- Name: tags_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tags_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tags_id_seq OWNER TO postgres;

--
-- Name: tags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tags_id_seq OWNED BY public.tags.id;


--
-- Name: themes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.themes (
    id integer NOT NULL,
    user_id integer,
    name text,
    tags text[]
);


ALTER TABLE public.themes OWNER TO postgres;

--
-- Name: themes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.themes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.themes_id_seq OWNER TO postgres;

--
-- Name: themes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.themes_id_seq OWNED BY public.themes.id;


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_id_seq OWNER TO postgres;

--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id integer DEFAULT nextval('public.users_id_seq'::regclass) NOT NULL,
    email character varying NOT NULL,
    hashed_password character varying NOT NULL,
    current_session character varying,
    name character varying(255),
    username character varying(255),
    location text,
    phone text
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: experiences id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.experiences ALTER COLUMN id SET DEFAULT nextval('public.experiences_id_seq'::regclass);


--
-- Name: facts id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.facts ALTER COLUMN id SET DEFAULT nextval('public.facts_id_seq'::regclass);


--
-- Name: jobs id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.jobs ALTER COLUMN id SET DEFAULT nextval('public.jobs_id_seq'::regclass);


--
-- Name: messages id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.messages ALTER COLUMN id SET DEFAULT nextval('public.messages_id_seq'::regclass);


--
-- Name: publications id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.publications ALTER COLUMN id SET DEFAULT nextval('public.publications_id_seq'::regclass);


--
-- Name: questions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.questions ALTER COLUMN id SET DEFAULT nextval('public.questions_id_seq'::regclass);


--
-- Name: tags id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tags ALTER COLUMN id SET DEFAULT nextval('public.tags_id_seq'::regclass);


--
-- Name: themes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.themes ALTER COLUMN id SET DEFAULT nextval('public.themes_id_seq'::regclass);


--
-- Data for Name: experiences; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.experiences (id, user_id, title, company, startdate, enddate, summary, is_education) FROM stdin;
11	1	Data Scientist (Graduate Intern)	ScanScout	2008-05-01	2008-08-01	● Analyzed behavioral data mining system to optimize video ad placement (in R)\n● Developed optimizer evaluation system using statistical significance measures (in R embedded in LaTeX)	f
12	1	MS in Information Science	Pennsylvania State University	2007-09-01	2010-05-01	● Relevant Classes: Pattern Recognition, Human-Computer Interaction, Information Management, Organizational Informatics.\n● Research: Decision tree induction machine learning using R.\n● Thesis: Hand gesture recognition using machine learning for immersive training systems in Java.\n● Honors: Jordan H. Rednor Graduate Fellowship.	t
13	1	Software Engineering Team Lead (Intern)	IBM	2007-05-01	2007-08-01	● Led team that developed a web renderer for IBM’s XML dialect for user interfaces (Abstract User Interface Markup Language, AUIML)	f
9	1	Government R&D Scientist & Project Lead	Charles River Analytics	2010-10-01	2013-03-01	● Technical lead for over 5 government R&D projects involving data visualizations and machine learning.\n● Published peer-reviewed research papers project outcomes.\n● Managed the development and maintenance of a Bayesian network machine learning toolkit.	f
10	1	Government R&D Engineer	BBN Technologies	2008-08-01	2010-10-01	● Developed & user-tested gesture recognition system using hidden Markov Models (Java, Matlab)\n● Designed & developed a distributed natural language processing pipeline (Python)\n● Developed a web app for team collaboration (ASP/C# .NET, HTML, CSS, JS)	f
3	1	Lead Frontend Engineer	Tanium	2016-08-01	2018-06-01	● Led the frontend engineering team for the core administrative product, working with design.\n● Managed SOAP-based backend request flow to optimize tech stack performance.\n● Provided expert guidance through code reviews, ensuring alignment with project goals.\n● Implemented CI/CD practices and and Agile methodology to enhance development efficiency.	f
4	1	Lead UX Engineer & Product Manager	Driven Inc.	2015-07-01	2016-08-01	● Led frontend engineering team and supported backend development to boost system performance, utilizing Agile methodology.\n● Enhanced user experience through user research, product analytics, and intuitive feature flows.\n● Directed a strategic pivot targeting cluster operators/administrators, collaborating with sales, marketing, and executives.	f
14	1	Software Engineering Team Lead (Intern)	IBM	2005-01-01	2005-08-01	● Started out developing software with SQL-embedded C using IBM’s DB2 database system\n● Was promoted to lead a summer team to create a tool to aid bug-fixing these applications\n● Interviewed developer “customers” to determine their software development habits and needs	f
22	1	Founder & Developer	Offend.org	1996-01-01	1998-12-01	● My first web app and company in the form of a shared discussion forum	f
16	1	Data Science Teaching Assistant	General Assembly	2016-05-01	2016-07-31	● Tutored students on descriptive and inferential statistics—data analysis, and machine learning models (linear and logistic regression, k-nearest neighbors, decision trees/random forests, latent dirichlet allocation/LDA, and time series autocorrelation).\n● Mastered Python technologies (SK Learn, NumPy, Pandas, iPython/Jupyter Notebook).	f
18	1	Founder & Developer	Simhack	2002-01-01	2004-01-01	● A massive, multiplayer online game about computer security; written first with PHP with a MySQL database, and later with Java servlets (J2EE).	f
15	1	IT Administrator & Web/Database Developer	Great Lakes Label, LLC	2002-01-01	2004-01-01	● Worked part-time (full-time in summers) while in high school and early college.\n● Created an ERP system that tracked all aspects of the business, including printing inventory, purchase orders, and payments.\n● Implemented with FileMaker Pro database and later hooked up to a custom PHP ecommerce website so customers could place orders in the system.	f
7	1	Lead UX Engineer	Collusion	2013-12-01	2014-11-01	● Led frontend team and supported middle-tier and back-end development to ensure a high-performing application stack.\n● Deployed a responsive web interface to complement the iOS app, ensuring cross-platform compatibility.	f
8	1	Full-Stack Software Engineer & Assistant Product Manager	Exaptive	2013-03-01	2013-10-01	● Worked with the founder to define product direction and target market segments.\n● Developed data analytics and visualizations to provide insights from complex datasets.	f
20	1	Founder & Developer	The Disconnection Network	2003-01-01	2007-01-01	● A network of web apps for shared blogging, a Shoutcast radio station, and customer web pages	f
6	1	Co-Founder & UX Consultant	Social Ergonomics Consulting	2014-11-01	2015-07-01	● Assisted user research of and solutions to clients’ problems.\n● Led the development of front-end prototypes with Javascript (D3.js) data visualizations.\n● Developed a comprehensive dashboard tool to integrate user research data, feature roadmaps, and evaluation results for product managers and startup founders.	f
17	1	Founder	Infinity Computing Services	2003-01-01	2005-01-01	● Created company that provided web hosting, email hosting, and IT support services; had several customers and web site paid for itself	f
1	1	Technology Research Scientist & Spinoff Entrepreneur	Datagotchi Labs	2018-01-01	\N	Incubating an R&D firm to “empower people with information” in underserved market segments.\n\n● Inspect: Enabling sharing important, reliable online news on social media.\n  · Interviewed prospective users to determine their news consumption habits and needs.\n  · Designed & developed a mobile app to empower users to share news summaries online & tested it with real users.\n\n● Counteroffer: Enhancing candidate-job fit by visualizing skills and matches to job listings.\n  · Interviewed prospective users to determine their job application processes and needs.\n  · Designed & developed a skill visualization web app to for job candidates to illustrate their fit for jobs & tested it with real users.	f
21	1	BS in Computer Science	Michigan Technological University	2003-08-01	2007-05-01	● Relevant Classes: Discrete Structures, Data Structures, Intro to Operating Systems, Object-Oriented Design, Advanced Artificial Intelligence, Real Analysis, Regression Analysis.\n● Research: Temporal data mining for computer architecture simulation results; machine learning for “expert” Go playing data; evolutionary algorithms for relational database optimization.\n● Activities: Workshop on Data Visualization and its Role in the Practice of Statistics, Phi Kappa Phi Honor Society, Upsilon Pi Epsilon Honor Society chapter president.\n● Honors: Upsilon Pi Epsilon Honor Society Jim Nolen Scholarship, Mathematics Department Certificate of Merit, Board of Controls Merit Scholarship.	t
\.


--
-- Data for Name: facts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.facts (id, user_id, key, value, theme_id) FROM stdin;
12	1	Objective	To apply my Information Science training and broad experiences in technology research, entreprenurship, & software engineering to get a job in product management.	13
\.


--
-- Data for Name: jobs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.jobs (id, user_id, email, company, archived) FROM stdin;
15	1	bob@datagotchi.net	\N	f
\.


--
-- Data for Name: messages; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.messages (id, value, question_id, sender, job_id, datetime) FROM stdin;
25	Javascript,Typescript	1	bob@datagotchi.net	13	\N
26		2	bob@datagotchi.net	13	\N
27		3	bob@datagotchi.net	13	\N
28	Product Strategy	1	bob@datagotchi.net	15	\N
29	asdf	2	bob@datagotchi.net	15	\N
30	asdf	3	bob@datagotchi.net	15	\N
31	asdf	4	bob@datagotchi.net	15	\N
\.


--
-- Data for Name: publications; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.publications (id, user_id, title, venue, link, experience_id, date, authors) FROM stdin;
31	1	CS4099 Database Research Final Report	Independent Study	https://www.dropbox.com/scl/fi/qkm16fvino5e4lbd9dd6t/db-sqo-paper.pdf?rlkey=cy2qwnqqhnoa9hswxygbvdq5g&st=7wc8iws8&dl=0	21	2005-12-12	Richards, R.S. & Stark, R.F.
6	1	Development of Dynamic Visual Artifacts for Resilient Human-Automation Collaboration	4th International Conference on Applied Human Factors and Ergonomics (AHFE)	\N	9	2012-07-01	Stark, R.F., Voshell, M., Mahoney, S., & Farry, M.
19	1	Tracking the Reliability of Information	Datagotchi.net	https://datagotchi.net/2020/11/16/tracking-the-reliability-of-information/	1	2020-11-16	Stark, R.F.
20	1	My Solution for Tracking the Reliability of Information	Datagotchi.net	https://datagotchi.net/2020/11/22/my-solution-for-tracking-the-reliability-of-information/	1	2020-11-22	Stark, R.F.
16	1	A Better Approach for Iteratively Creating New Technology	Medium.com	https://medium.com/@bobstark/a-better-approach-for-iteratively-creating-new-technology-cce311404482	1	2020-06-19	Stark, R.F.
15	1	Enabling Human-Machine Collaboration to Improve the Use of AI	Medium.com	https://medium.com/@bobstark/enabling-human-machine-collaboration-to-improve-the-use-of-ai-5742b5517f28	1	2020-06-15	Stark, R.F.
14	1	Information Science as a Lens for Better Software	Medium.com	https://medium.com/@bobstark/information-science-as-a-lens-for-better-software-580ac1d50fa1	1	2020-06-13	Stark, R.F.
13	1	Using Information to Actually Help People	Medium.com	https://medium.com/@bobstark/using-information-to-actually-help-people-f11d1e7347c7	1	2020-06-09	Stark, R.F.
18	1	Datagotchi Labs: Empowering People with Information	Datagotchi.net	https://datagotchi.net/2022/12/30/about/	1	2022-12-30	Stark, R.F.
8	1	Framing the Sociocultural Context to Aid Course of Action Generation for Counterinsurgency	Advances in Applied Human Modeling and Simulation	http://books.google.com/books?hl=en&lr=&id=l1BJ6XTBfo8C&oi=fnd&pg=PA436&dq=info:1pPkQ0m9b_sJ:scholar.google.com&ots=95dYYFCG-b&sig=CzF3IC4IPzWjbOD2FwlpSxXQ-68	9	2012-01-01	Farry, M., Stark, B., Mahoney, S., Carlson, E., & Koelle, D.
7	1	Mixed-Initiative Data Mining with Bayesian Networks	IEEE Conference on Cognitive Methods in Situation Awareness and Decision Support (CogSIMA)	https://www.dropbox.com/s/m6yarozba98kb4l/Stark-et-al-2012%20CogSIMA.pdf?dl=0	9	2012-03-01	Stark, R.F., Farry, M., & Pfautz, J.
3	1	Supporting tactical intelligence using collaborative environments and social networking	SPIE Defense, Security, and Sensing	https://www.spiedigitallibrary.org/conference-proceedings-of-spie/8758/87580E/Supporting-tactical-intelligence-using-collaborative-environments-and-social-networking/10.1117/12.2015997.short#_=_	9	2013-01-01	Wollocko, A.B., Farry, M.P., & Stark, R.F.
23	1	Why Startups Need Problem-Solution Fit	Medium.com	https://medium.com/@bobstark/why-startups-need-problem-solution-fit-57303a53f5d6	1	2024-02-15	Stark, R.F.
4	1	Visualizations and Interaction Methods for Resilient Submarine Decision Support	56th Annual Meetings of the Human Factors and Ergonomics Society (HFES)	https://www.dropbox.com/s/l8b10uglras1z1r/Stark-et-al-2012%20HFES.pdf?dl=0	9	2012-10-01	Stark, R.F., Woods, D.D., Farry, M., Morison, A., Thornton, W., & Wollocko, A.
27	1	Using Leverage to Make Demands from Employers	Datagotchi.net	https://datagotchi.net/2022/06/07/using-leverage-to-make-demands-from-employers/	1	2022-06-07	Stark, R.F.
10	1	Aiding the User Input to Video Games: Virtual Role Players with Speech and Gesture Recognition	MS Thesis, Pennsylvania State University	https://etda.libraries.psu.edu/paper/10686/6306	12	2010-05-01	Stark, R.F.
11	1	Reducing Risk in System Design through Human-Systems Integration	Ergonomics In Design	https://www.dropbox.com/s/uav23x1q9u1jvz6/Stark-Kokini-2010%20EID.pdf?dl=0	12	2010-04-01	Stark, R.F. & Kokini, C.
5	1	Visualizing Large Scale Patterns and Anomalies in Geospatial Data	VisWeek 2012	https://www.dropbox.com/s/l0o54erpoh051cs/Stark-et-al-2012%20VAST.pdf?dl=0	9	2012-10-01	Stark, R.F., Wollocko, A., Borys, M., Kierstead, M. & Farry, M.
9	1	Modeling Resilient Submarine Decision Making	21st Annual Conference on Behavior Representation in Modeling Simulation (BRiMS)	https://www.dropbox.com/scl/fi/drmc1lf5ga8gqlsd35x27/Stark-et-al-2012-BRIMS.pdf?rlkey=nqiqimhhg2cmocqfrfepe35tn&st=amj1opk0&dl=0	9	2012-01-01	Stark, R.F., Farry, M.P., Thornton, W.A., & Wollocko, A.B.
12	1	Interacting Naturally in Virtual Environments	2010 Interservice/Industry Training, Simulation and Education Conference (I/ITSEC)	https://www.dropbox.com/scl/fi/p9cocc7tow54buwlfnq1r/Diller-et-al-2010-IITSEC.pdf?rlkey=t2x6lhc6nzbfzi7w5mp3mncos&st=1q6uuv82&dl=0	10	2010-01-01	Diller, D., Stark, R.F., Krisler, B., Shapiro, R., & Moffitt, K.
28	1	My Solution to Using Leverage to Make Demands from Employers	Datagotchi.net	https://datagotchi.net/2022/06/17/my-solution-to-using-leverage-to-make-demands-from-employers/	1	2022-06-17	Stark, R.F.
29	1	Hiring in the Wake of the Pandemic	Datagotchi.net	https://datagotchi.net/2021/08/25/hiring-in-the-wake-of-the-pandemic/	1	2021-08-25	Stark, R.F.
30	1	My Solution to Hiring in the Wake of the Pandemic	Datagotchi.net	https://datagotchi.net/2021/08/30/my-solution-to-hiring-in-the-wake-of-the-pandemic/	1	2021-08-30	Stark, R.F.
26	1	Counteroffer: A Public Forum for Improved Candidate-Job Listing Fitness	Datagotchi.net	https://datagotchi.net/2024/06/22/counteroffer-proposal/	1	2024-06-22	Stark, R.F.
21	1	Inspect: A Multiplatform Social Network for Trustworthy News	Datagotchi.net	https://datagotchi.net/2024/06/21/inspect-proposal/	1	2024-06-21	Stark, R.F.
1	1	Incrementally Formalizing Graphical Models for Collaborative Operations Research	57th Annual Meetings of the Human Factors and Ergonomics Society (HFES)	https://www.dropbox.com/s/pa9ez2ka76sojku/Stark-et-al-2013%20HFES.pdf?dl=0	9	2013-01-01	Stark, R.F., Roth, E.M., & Farry, M.P.,
\.


--
-- Data for Name: questions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.questions (id, user_id, question, type, required) FROM stdin;
1	1	Which of my skills are most useful for the opportunity?	skills	t
3	1	Other details about the opportunity	textarea	f
2	1	What other skills are required/desired for the opportunity?	textarea	t
4	1	Is this opportunity part-time/contracting?	text	t
\.


--
-- Data for Name: tags; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tags (id, experience_id, value) FROM stdin;
1	1	Javascript
4	1	React
8	1	React Native
11	3	AngularJS
12	3	Javascript
13	3	Typescript
15	4	Product Strategy
17	4	User Stories
26	6	Product Strategy
27	1	Product Strategy
31	6	Javascript
33	6	AngularJS
43	1	User Stories
44	8	Javascript
46	8	PHP
47	8	Python
48	8	User Stories
51	9	User Stories
53	9	Java
54	9	Proposals
56	9	Bayesian Networks
57	9	Intelligent Agents
58	9	Machine Learning
59	9	Data Visualization
60	8	Data Visualization
61	6	Data Visualization
63	10	Data Science
65	10	Java
66	10	Matlab
67	10	R Statistical Environment
68	8	R Statistical Environment
69	10	Python
70	10	ASP.NET
71	10	C#.NET
72	10	Javascript
74	11	R Statistical Environment
75	11	Data Science
76	12	R Statistical Environment
77	12	Machine Learning
78	12	Java
81	9	Project Lead
84	3	Team Lead
86	13	Java
87	14	Team Lead
88	14	Java
89	15	PHP
90	15	FileMaker
92	10	Machine Learning
94	15	Javascript
95	16	Data Science
96	16	Machine Learning
97	11	Machine Learning
103	8	Data Science
106	16	SciKit-Learn
107	16	NumPy
108	16	Python
109	16	Pandas
110	16	iPython/Jupyter Notebook
113	6	Prototyping
115	8	Prototyping
116	9	Prototyping
117	10	Prototyping
118	11	Prototyping
119	12	Prototyping
120	13	Prototyping
121	14	Prototyping
122	2	Go
124	2	Typescript
136	7	Javascript
138	7	Objective-C
139	7	PHP
140	7	Product Analytics
142	7	User Stories
144	2	React
145	3	React
146	1	Typescript
147	1	Wireframing
148	2	Wireframing
149	3	Wireframing
150	4	Wireframing
152	9	Wireframing
153	3	Code Review
155	17	PHP
156	17	MySQL
157	17	VPS Administration
158	18	PHP
159	18	MySQL
161	18	Javascript
162	19	Javascript
163	19	PHP
166	19	Typescript
167	19	PostgreSQL
168	20	PHP
169	20	PostgreSQL
170	20	Javascript
171	20	Shoutcast Radio
172	1	HTML
173	1	CSS
28	6	Product Design
30	1	Product Design
52	9	Product Design
64	10	Product Design
102	4	Product Design
126	2	Product Design
143	7	Product Design
185	3	Product Design
32	6	D3.js
174	1	Cloud-Native Environment
175	1	Gradle Dependency Manager
176	1	Yarn Package Manager
177	1	Java
179	1	Microservices
180	1	Responsive Design
181	2	Microservices
182	3	Microservices
183	3	HTML
184	3	CSS
186	3	Yarn Package Manager
187	3	NPM Package Manager
188	3	Go
190	3	Public-Sector Modernization
45	8	D3.js
128	4	D3.js
160	18	Java
191	3	Design Collaboration
3	1	Node.js
14	3	Node.js
34	6	Node.js
123	2	Node.js
137	7	Node.js
178	1	Stakeholder Engagement
189	3	Stakeholder Engagement
16	4	Product Roadmapping
91	1	Product Roadmapping
24	6	User Research
25	1	User Research
49	8	User Research
50	9	User Research
73	10	User Research
93	14	User Research
101	4	User Research
127	4	AngularJS
129	4	Data Visualization
130	4	Javascript
131	4	Machine Learning
132	4	Product Analytics
133	4	Team Lead
154	4	Code Review
193	4	HTML
194	4	CSS
195	4	Cloud-Native Environment
196	4	NPM Package Manager
197	4	Java
199	4	Engineering Collaboration
201	4	Streaming Tools
202	4	Microservices
203	4	Event-Driven Architecture
204	16	Map-Based UIs
205	6	HTML
206	6	CSS
207	6	NPM Package Manager
209	6	Microservices
210	7	HTML
211	7	CSS
212	7	Responsive Design
213	7	Cloud-Native Environment
214	7	NPM Package Manager
216	7	Microservices
218	8	CSS
219	8	HTML
221	8	Cloud-Native Environment
222	8	Map-Based UIs
224	8	Microservices
225	9	Gradle Dependency Manager
226	9	Secret Clearance
227	9	Map-Based UIs
229	9	Public-Sector Modernization
231	9	Engineering Collaboration
232	9	Event-Driven Architecture
233	10	HTML
234	10	CSS
235	10	ASP/C#.NET
236	10	Gradle Dependency Manager
237	10	Map-Based UIs
239	10	Public-Sector Modernization
240	10	Event-Driven Architecture
241	12	STEM
242	12	UX Education
243	13	Team Lead
244	13	HTML
245	13	CSS
247	21	STEM
248	18	HTML
249	18	CSS
250	15	HTML
251	15	CSS
252	17	HTML
253	17	CSS
254	20	HTML
255	20	CSS
257	4	Front-End Engineering
258	1	Front-End Engineering
259	3	Front-End Engineering
260	6	Front-End Engineering
261	7	Front-End Engineering
262	10	Front-End Engineering
263	20	Front-End Engineering
264	17	Front-End Engineering
265	15	Front-End Engineering
266	18	Front-End Engineering
267	8	Front-End Engineering
268	8	Executive Engagement
270	7	Executive Engagement
200	4	Executive Engagement
192	3	Engineering Collaboration
230	9	Design Collaboration
271	7	Product Collaboration
272	4	Product Collaboration
273	8	Product Collaboration
274	10	Product Collaboration
275	9	Product Collaboration
276	15	Product Collaboration
279	4	Design Collaboration
280	6	Design Collaboration
281	7	Design Collaboration
282	8	Design Collaboration
285	7	Wireframing
286	3	Accessibility
287	9	Technical Documentation
288	10	Technical Documentation
289	3	Technical Documentation
290	1	Technical Documentation
291	3	E2E Testing
292	3	Unit Testing
293	1	Unit Testing
298	7	Engineering Collaboration
299	8	Engineering Collaboration
300	14	Engineering Collaboration
301	13	Engineering Collaboration
302	1	Back-End Engineering
303	3	Back-End Engineering
304	4	Back-End Engineering
305	6	Back-End Engineering
306	7	Back-End Engineering
307	8	Back-End Engineering
309	10	Back-End Engineering
310	20	Back-End Engineering
311	17	Back-End Engineering
312	18	Back-End Engineering
313	21	Computer Science
315	12	Management Science
316	12	Psychology
317	15	E-Commerce
318	1	Project Management
319	3	Project Management
320	4	Project Management
321	6	Project Management
322	7	Project Management
323	8	Project Management
324	9	Project Management
198	4	Stakeholder Engagement
220	8	Product Design
294	3	Product Analytics
296	6	Product Analytics
332	7	Prototyping
333	21	Prototyping
334	20	Prototyping
336	18	Prototyping
256	4	CSS Preprocessors
337	1	Technology Tradeoffs
338	6	Technology Tradeoffs
339	8	Technology Tradeoffs
340	10	Technology Tradeoffs
341	12	Technology Tradeoffs
342	20	Technology Tradeoffs
343	17	Technology Tradeoffs
344	18	Technology Tradeoffs
405	1	Market Research
409	4	Market Research
345	18	Cross-Browser Compatibility
346	17	Cross-Browser Compatibility
347	20	Cross-Browser Compatibility
348	3	Cross-Browser Compatibility
349	4	Cross-Browser Compatibility
350	7	Cross-Browser Compatibility
351	3	Startup Environment
352	4	Startup Environment
353	7	Startup Environment
354	8	Startup Environment
208	6	Stakeholder Engagement
215	7	Stakeholder Engagement
223	8	Stakeholder Engagement
228	9	Stakeholder Engagement
238	10	Stakeholder Engagement
246	14	Stakeholder Engagement
355	1	Product Management
356	4	Product Management
357	7	Product Management
358	8	Product Management
359	9	Product Management
362	3	Cross-Functional Collaboration
363	4	Cross-Functional Collaboration
364	6	Cross-Functional Collaboration
365	7	Cross-Functional Collaboration
366	8	Cross-Functional Collaboration
367	9	Cross-Functional Collaboration
368	10	Cross-Functional Collaboration
369	1	Data Analysis
370	4	Data Analysis
371	16	Data Analysis
372	6	Data Analysis
373	7	Data Analysis
374	8	Data Analysis
375	9	Data Analysis
376	10	Data Analysis
380	1	SQL
381	3	SQL
382	4	SQL
383	16	SQL
384	7	SQL
385	8	SQL
386	9	SQL
387	20	SQL
388	17	SQL
389	18	SQL
390	1	Spreadsheets
391	7	Spreadsheets
392	8	Spreadsheets
393	9	Spreadsheets
394	1	Product Development
395	3	Product Development
396	4	Product Development
397	6	Product Development
398	7	Product Development
399	8	Product Development
400	9	Product Development
401	10	Product Development
402	20	Product Development
403	18	Product Development
404	1	Data Visualization
412	6	Product Dashboards & Reports
413	7	Product Dashboards & Reports
417	1	Product Backlogs
418	3	Product Backlogs
419	4	Product Backlogs
420	7	Product Backlogs
421	8	Product Backlogs
422	1	Proposals
423	6	Company Operations
424	1	Company Operations
425	20	Company Operations
426	17	Company Operations
427	18	Company Operations
431	7	Product Strategy
432	8	Product Strategy
433	9	Product Strategy
436	1	Product Experiments
437	4	Product Experiments
438	7	Product Experiments
439	6	Product Experiments
440	8	Product Experiments
441	9	Product Experiments
330	3	Product Performance Optimization
331	4	Product Performance Optimization
410	8	Market Research
411	9	Market Research
443	4	Artificial Intelligence
444	16	Artificial Intelligence
445	9	Artificial Intelligence
446	10	Artificial Intelligence
447	12	Artificial Intelligence
448	21	Artificial Intelligence
454	21	Machine Learning
414	7	Product Roadmapping
415	8	Product Roadmapping
416	9	Product Roadmapping
455	3	Agile Methodology
456	4	Agile Methodology
457	1	Solution Design
458	3	Solution Design
459	4	Solution Design
460	7	Solution Design
461	8	Solution Design
462	1	Go-To-Market Strategizing
463	7	Go-To-Market Strategizing
464	8	Go-To-Market Strategizing
465	11	Artificial Intelligence
466	10	Generative AI
467	12	Generative AI
469	4	Generative AI
470	16	Generative AI
125	2	User Research
141	7	User Research
471	1	Product Launch
472	4	Product Launch
473	7	Product Launch
474	8	Product Launch
475	18	Product Management
476	20	Product Management
477	14	SQL
478	6	Product Management
480	1	Content Writing
481	4	Content Writing
482	7	Content Writing
483	10	Content Writing
484	9	Content Writing
485	17	Content Writing
486	12	Content Writing
487	21	Content Writing
488	1	Startup Environment
489	1	SaaS
490	4	SaaS
491	7	SaaS
492	8	SaaS
496	7	Market Research
497	20	Market Research
498	18	Market Research
499	22	Company Operations
500	22	Product Development
501	22	SQL
502	15	Product Development
503	13	Product Development
504	14	Product Development
\.


--
-- Data for Name: themes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.themes (id, user_id, name, tags) FROM stdin;
4	1	Material Bank	{HTML,CSS,React,"CSS Preprocessors","Front-End Engineering","Executive Engagement","Product Collaboration","Design Collaboration","QA Collaboration",Wireframing,"Responsive Design",Accessibility,"UX Design","Technical Documentation","E2E Testing",Node.js,"Web Analytics","Engineering Collaboration","Back-End Engineering","Computer Science",E-Commerce,"Project Management","Performance Optimization","Technology Tradeoffs","Cross-Browser Compatibility","Startup Environment"}
3	1	Raft	{HTML,CSS,React,Javascript,Typescript,D3.js,"UX Research","UX Design","Responsive Design","Cloud-Native Environment","Gradle Dependency Manager","NPM Package Manager","Yarn Package Manager","Secret Clearance","Map-Based UIs",Java,Python,Go,"Customer-Obsessed Mindset","Public-Sector Modernization",Microservices,"Streaming Tools",STEM,"UX Education"}
13	1	Product Management	{"Product Management","Project Management","Stakeholder Engagement","Data Analysis",SQL,Spreadsheets,"Product Development","Data Visualization","Market Research","Solution Design","User Research","Product Analytics","Product Roadmapping","Product Strategy","Product Experiments","Content Writing","Product Launch",Software-as-a-Service,"Product Collaboration","Design Collaboration","Engineering Collaboration"}
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, email, hashed_password, current_session, name, username, location, phone) FROM stdin;
1	bobness@gmail.com	2a9d119df47ff993b662a8ef36f9ea20	4c393d3e-288b-4155-a9fd-d77b58c49547	Robert Stark	bob.stark	Grand Rapids, MI	510-882-3319
\.


--
-- Name: experiences_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.experiences_id_seq', 22, true);


--
-- Name: facts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.facts_id_seq', 13, true);


--
-- Name: jobs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.jobs_id_seq', 15, true);


--
-- Name: messages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.messages_id_seq', 31, true);


--
-- Name: publications_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.publications_id_seq', 31, true);


--
-- Name: questions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.questions_id_seq', 4, true);


--
-- Name: tags_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tags_id_seq', 504, true);


--
-- Name: themes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.themes_id_seq', 13, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 1, true);


--
-- Name: experiences experiences_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.experiences
    ADD CONSTRAINT experiences_pkey PRIMARY KEY (id);


--
-- Name: facts facts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.facts
    ADD CONSTRAINT facts_pkey PRIMARY KEY (id);


--
-- Name: jobs jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.jobs
    ADD CONSTRAINT jobs_pkey PRIMARY KEY (id);


--
-- Name: messages messages_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT messages_pkey PRIMARY KEY (id);


--
-- Name: questions questions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.questions
    ADD CONSTRAINT questions_pkey PRIMARY KEY (id);


--
-- Name: tags tags_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tags
    ADD CONSTRAINT tags_pkey PRIMARY KEY (id);


--
-- Name: jobs u_user_id_email; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.jobs
    ADD CONSTRAINT u_user_id_email UNIQUE (user_id, email);


--
-- Name: users unique_email; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT unique_email UNIQUE (email);


--
-- Name: users unique_username; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT unique_username UNIQUE (username);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: ix_experiences_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_experiences_user_id ON public.experiences USING btree (user_id);


--
-- Name: ix_facts_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_facts_user_id ON public.facts USING btree (user_id);


--
-- Name: ix_jobs_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_jobs_user_id ON public.jobs USING btree (user_id);


--
-- Name: ix_messages_question_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_messages_question_id ON public.messages USING btree (question_id);


--
-- Name: ix_questions_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_questions_user_id ON public.questions USING btree (user_id);


--
-- Name: ix_users_email; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_users_email ON public.users USING btree (email);


--
-- Name: ix_users_username; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_users_username ON public.users USING btree (username);


--
-- Name: u_eid_value; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX u_eid_value ON public.tags USING btree (experience_id, value);


--
-- PostgreSQL database dump complete
--

