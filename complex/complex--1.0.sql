-- complain if script is sourced in psql, rather than via CREATE EXTENSION
\echo Use "CREATE EXTENSION complex" to load this file. \quit

/******************************************************************************
 * Input/Output
 ******************************************************************************/

CREATE OR REPLACE FUNCTION complex_in(cstring)
  RETURNS complex
  AS 'MODULE_PATHNAME'
  LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

CREATE OR REPLACE FUNCTION complex_out(complex)
  RETURNS cstring
  AS 'MODULE_PATHNAME'
  LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

CREATE OR REPLACE FUNCTION complex_recv(internal)
  RETURNS complex
  AS 'MODULE_PATHNAME'
  LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

CREATE OR REPLACE FUNCTION complex_send(complex)
  RETURNS bytea
  AS 'MODULE_PATHNAME'
  LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

CREATE TYPE complex (
  internallength = 16,
  input          = complex_in,
  output         = complex_out,
  receive        = complex_recv,
  send           = complex_send,
  alignment      = double
);

CREATE OR REPLACE FUNCTION complex(text)
  RETURNS complex
  AS 'MODULE_PATHNAME', 'complex_cast_from_text'
  LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

CREATE OR REPLACE FUNCTION text(complex)
  RETURNS text
  AS 'MODULE_PATHNAME', 'complex_cast_to_text'
  LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

CREATE CAST (text as complex) WITH FUNCTION complex(text) AS IMPLICIT;
CREATE CAST (complex as text) WITH FUNCTION text(complex);

/******************************************************************************
 * Constructor
 ******************************************************************************/

CREATE FUNCTION complex(double precision, double precision)
  RETURNS complex
  AS 'MODULE_PATHNAME', 'complex_constructor'
  LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

/*****************************************************************************
 * Accessing values
 *****************************************************************************/

CREATE FUNCTION re(complex)
  RETURNS double precision
  AS 'MODULE_PATHNAME', 'complex_re'
  LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

CREATE FUNCTION im(complex)
  RETURNS double precision
  AS 'MODULE_PATHNAME', 'complex_im'
  LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

-- This function returns the conjugate of a complex number

CREATE FUNCTION conjugate(complex)
  RETURNS complex
  AS 'MODULE_PATHNAME', 'complex_conj'
  LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

/******************************************************************************
 * Operators
 ******************************************************************************/

CREATE FUNCTION complex_eq(complex, complex)
  RETURNS boolean
  AS 'MODULE_PATHNAME', 'complex_eq'
  LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE FUNCTION complex_ne(complex, complex)
  RETURNS boolean
  AS 'MODULE_PATHNAME', 'complex_ne'
  LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE FUNCTION complex_left(complex, complex)
  RETURNS boolean
  AS 'MODULE_PATHNAME', 'complex_left'
  LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

-- This is the function for the strictly right '>>' operator

CREATE FUNCTION complex_right(complex, complex)
  RETURNS boolean
  AS 'MODULE_PATHNAME', 'complex_right'
  LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

CREATE FUNCTION complex_below(complex, complex)
  RETURNS boolean
  AS 'MODULE_PATHNAME', 'complex_below'
  LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

--This is the function for the strictly above '|>>' operator
CREATE FUNCTION complex_above(complex, complex)
  RETURNS boolean
  AS 'MODULE_PATHNAME', 'complex_above'
  LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

CREATE OPERATOR ~= (
  LEFTARG = complex, RIGHTARG = complex,
  PROCEDURE = complex_eq,
  COMMUTATOR = ~=, NEGATOR = <>
);
CREATE OPERATOR <> (
  LEFTARG = complex, RIGHTARG = complex,
  PROCEDURE = complex_ne,
  COMMUTATOR = <>, NEGATOR = ~=
);
CREATE OPERATOR << (
  LEFTARG = complex, RIGHTARG = complex,
  PROCEDURE = complex_left,
  COMMUTATOR = >>
);

--This is the strictly right '>>' operator

CREATE OPERATOR >> (
  LEFTARG = complex, RIGHTARG = complex,
  PROCEDURE = complex_right,
  COMMUTATOR = <<
);

CREATE OPERATOR <<| (
  LEFTARG = complex, RIGHTARG = complex,
  PROCEDURE = complex_below,
  COMMUTATOR = |>>
);

-- This is the strictly above '|>>' operator
CREATE OPERATOR |>> (
  LEFTARG = complex, RIGHTARG = complex,
  PROCEDURE = complex_below,
  COMMUTATOR = <<|
);

/******************************************************************************/

CREATE FUNCTION complex_add(complex, complex)
  RETURNS complex
  AS 'MODULE_PATHNAME', 'complex_add'
  LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

-- This is the function for the subtract '-' operator

CREATE FUNCTION complex_sub(complex,complex)
  RETURNS complex
  AS 'MODULE_PATHNAME', 'complex_sub'
  LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;


-- This is the function for the multiplication '*' operator
CREATE FUNCTION complex_mult(complex,complex)
  RETURNS complex
  AS 'MODULE_PATHNAME', 'complex_mult'
  LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;


CREATE FUNCTION complex_div(complex, complex)
  RETURNS complex
  AS 'MODULE_PATHNAME', 'complex_div'
  LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

CREATE OPERATOR + (
  LEFTARG = complex, RIGHTARG = complex,
  PROCEDURE = complex_add,
  COMMUTATOR = +
);

--This is the subtract '-' operator
CREATE OPERATOR - (
  LEFTARG = complex, RIGHTARG = complex,
  PROCEDURE = complex_sub
);


-- This is the multiplication '*' operator

CREATE OPERATOR * (
  LEFTARG = complex, RIGHTARG = complex,
  PROCEDURE = complex_mult
);

CREATE OPERATOR / (
  LEFTARG = complex, RIGHTARG = complex,
  PROCEDURE = complex_div
);

/******************************************************************************/

CREATE FUNCTION complex_dist(complex, complex)
  RETURNS double precision
  AS 'MODULE_PATHNAME', 'complex_dist'
  LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

CREATE OPERATOR <-> (
  LEFTARG = complex, RIGHTARG = complex,
  PROCEDURE = complex_dist,
  COMMUTATOR = <->
);

/******************************************************************************/