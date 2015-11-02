{open Parser}

%token TIMES_EQ XOR_EQ DOLLAR_EQ TILDE_EQ

rule token = parse
	[' ' '\t' '\r' '\n'] {token lexbuf}
	| '.' {PERIOD}
	| '[' {LBRACE} | ']' {RBRACE}
	| '&' {AMPERSAND}
	| '~' {TILDE}
	| '<' {LT} | '>' {GT}
	| '+' {PLUS} | '-' {MINUS} | '*' {TIMES} | '/' {DIV} | '=' {EQ}
	| '#' {HASH}
	| "[@" {LBRACE_AMP} | "@]" {AMP_RBRACE}
	| "*=" {TIMES_EQ} | "^=" {XOR_EQ} | "$=" {DOLLAR_EQ} | "~=" {TILDE_EQ}
	| ['a'-'z' 'A'-'Z']['a'-'z' 'A'-'Z' '0'-'9' '_']* as lxm { ID(lxm) }
	| '"' [^ '"']+ '"' as lxm { STRING(lxm) }
	| eof {EOF}