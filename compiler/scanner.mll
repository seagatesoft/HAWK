{open Parser}

let digits = ['0' - '9']+
let signed_int = ['+' '-']? digits
let decimal = ['+' '-']? (digits '.' ['0'-'9']* | '.' digits) (['e' 'E'] signed_int)?

rule token = parse
	[' ' '\t' '\r' '\n'] {token lexbuf}
	| "/*"     { comment lexbuf }
	| '.' {PERIOD}
	| '[' {LBRACK} | ']' {RBRACK}
	| '{' {LBRACE} | '}' {RBRACE}
	| '(' {LPAREN} | ')' {RPAREN}
	| ';' {SEMI} | ':' {COLON}
	| ',' {COMMA}
  | "fun" {FUN}
	| "in" {IN}
	| "BEGIN" {BEGIN} | "END" {END}
	| "else" {ELSE} | "if" {IF}
	| "while" {WHILE} | "for" {FOR}
	| "this" {THIS}
	| "return" {RETURN}
	| '~' {TILDE}
	| '<' {LT} | '>' {GT} | "==" {EQ}
	| '+' {PLUS} | '-' {MINUS} | '*' {TIMES} | '/' {DIVIDES} | '=' {ASSIGN}
	| '#' {HASH}
	| '_' {UNDER} | '?' {QUEST} | '^' {CARROT} | '|' {VERT}
	| "[/" {LBRACK_FSLASH} | "/]" {FSLASH_RBRACK}
	| "[@" {LBRACK_AMP} | "@]" {AMP_RBRACK}
	| "*=" {TIMES_EQ} | "^=" {XOR_EQ} | "$=" {DOLLAR_EQ} | "~=" {TILDE_EQ}
	| ['a'-'z' 'A'-'Z']['a'-'z' 'A'-'Z' '0'-'9' '_']* as lxm { ID(lxm) }
	| digits as lxm {INT(int_of_string lxm)}
	| decimal as lxm {DOUBLE(float_of_string lxm)}
	| '\''[^ '\'']'\'' as lxm {CHAR(lxm.[0])}
	| '"' [^ '"']+ '"' as lxm {STRING(lxm)}
	| eof {EOF}

	and comment = parse
	  "*/" { token lexbuf }
	| _    { comment lexbuf }
