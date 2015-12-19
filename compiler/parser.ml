type token =
  | LPAREN
  | RPAREN
  | LBRACK
  | RBRACK
  | LBRACE
  | RBRACE
  | PLUS
  | MINUS
  | TIMES
  | DIVIDES
  | MOD
  | LT
  | GT
  | LEQ
  | GEQ
  | EQ
  | NEQ
  | AND
  | OR
  | PERIOD
  | ASSIGN
  | HASH
  | TILDE
  | COMMA
  | COLON
  | QUEST
  | CARROT
  | VERT
  | FUN
  | SEMI
  | LBRACK_AMP
  | AMP_RBRACK
  | LBRACK_FSLASH
  | FSLASH_RBRACK
  | EOF
  | STRING of (string)
  | REGEX_STRING of (string)
  | INT of (int)
  | DOUBLE of (float)
  | ID of (string)
  | CSSID of (string)
  | BEGIN
  | END
  | ELSE
  | IF
  | RETURN
  | THIS
  | WHILE
  | FOR
  | IN
  | TIMES_EQ
  | XOR_EQ
  | DOLLAR_EQ
  | TILDE_EQ

open Parsing;;
let _ = parse_error;;
# 3 "parser.mly"
 open Ast 
   open Util
# 63 "parser.ml"
let yytransl_const = [|
  257 (* LPAREN *);
  258 (* RPAREN *);
  259 (* LBRACK *);
  260 (* RBRACK *);
  261 (* LBRACE *);
  262 (* RBRACE *);
  263 (* PLUS *);
  264 (* MINUS *);
  265 (* TIMES *);
  266 (* DIVIDES *);
  267 (* MOD *);
  268 (* LT *);
  269 (* GT *);
  270 (* LEQ *);
  271 (* GEQ *);
  272 (* EQ *);
  273 (* NEQ *);
  274 (* AND *);
  275 (* OR *);
  276 (* PERIOD *);
  277 (* ASSIGN *);
  278 (* HASH *);
  279 (* TILDE *);
  280 (* COMMA *);
  281 (* COLON *);
  282 (* QUEST *);
  283 (* CARROT *);
  284 (* VERT *);
  285 (* FUN *);
  286 (* SEMI *);
  287 (* LBRACK_AMP *);
  288 (* AMP_RBRACK *);
  289 (* LBRACK_FSLASH *);
  290 (* FSLASH_RBRACK *);
    0 (* EOF *);
  297 (* BEGIN *);
  298 (* END *);
  299 (* ELSE *);
  300 (* IF *);
  301 (* RETURN *);
  302 (* THIS *);
  303 (* WHILE *);
  304 (* FOR *);
  305 (* IN *);
  306 (* TIMES_EQ *);
  307 (* XOR_EQ *);
  308 (* DOLLAR_EQ *);
  309 (* TILDE_EQ *);
    0|]

let yytransl_block = [|
  291 (* STRING *);
  292 (* REGEX_STRING *);
  293 (* INT *);
  294 (* DOUBLE *);
  295 (* ID *);
  296 (* CSSID *);
    0|]

let yylhs = "\255\255\
\001\000\002\000\004\000\003\000\003\000\006\000\005\000\005\000\
\008\000\008\000\008\000\008\000\008\000\008\000\008\000\008\000\
\008\000\010\000\010\000\009\000\009\000\009\000\009\000\009\000\
\009\000\009\000\009\000\009\000\009\000\009\000\009\000\009\000\
\009\000\009\000\009\000\009\000\009\000\009\000\009\000\009\000\
\009\000\014\000\014\000\015\000\015\000\013\000\013\000\013\000\
\013\000\012\000\012\000\016\000\016\000\017\000\018\000\018\000\
\019\000\020\000\020\000\011\000\021\000\021\000\021\000\007\000\
\007\000\024\000\024\000\024\000\024\000\024\000\024\000\024\000\
\024\000\023\000\023\000\026\000\026\000\026\000\026\000\025\000\
\025\000\022\000\022\000\022\000\022\000\022\000\027\000\027\000\
\028\000\028\000\030\000\030\000\029\000\029\000\032\000\032\000\
\031\000\031\000\031\000\031\000\031\000\031\000\031\000\031\000\
\000\000"

let yylen = "\002\000\
\004\000\004\000\004\000\000\000\002\000\004\000\000\000\002\000\
\002\000\003\000\003\000\005\000\007\000\005\000\007\000\002\000\
\001\000\001\000\001\000\001\000\001\000\003\000\003\000\003\000\
\003\000\003\000\003\000\003\000\003\000\003\000\003\000\003\000\
\003\000\003\000\003\000\004\000\003\000\002\000\004\000\003\000\
\002\000\001\000\003\000\003\000\004\000\001\000\001\000\001\000\
\001\000\001\000\001\000\002\000\003\000\003\000\001\000\003\000\
\003\000\001\000\001\000\007\000\000\000\001\000\003\000\003\000\
\003\000\001\000\001\000\003\000\003\000\002\000\002\000\002\000\
\003\000\001\000\002\000\001\000\003\000\002\000\003\000\001\000\
\002\000\001\000\003\000\003\000\003\000\002\000\001\000\001\000\
\001\000\002\000\001\000\001\000\001\000\002\000\001\000\001\000\
\002\000\002\000\003\000\005\000\005\000\005\000\005\000\005\000\
\002\000"

let yydefred = "\000\000\
\000\000\000\000\000\000\105\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\017\000\
\047\000\046\000\048\000\000\000\000\000\000\000\049\000\000\000\
\000\000\000\000\000\000\000\000\021\000\000\000\091\000\000\000\
\000\000\092\000\000\000\082\000\087\000\088\000\000\000\000\000\
\000\000\000\000\067\000\066\000\000\000\000\000\000\000\000\000\
\005\000\000\000\000\000\000\000\000\000\018\000\050\000\051\000\
\000\000\041\000\000\000\016\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\002\000\008\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\009\000\096\000\095\000\000\000\097\000\
\098\000\000\000\000\000\000\000\064\000\086\000\090\000\094\000\
\000\000\000\000\000\000\000\000\000\000\000\000\065\000\071\000\
\072\000\070\000\000\000\075\000\000\000\001\000\000\000\052\000\
\000\000\000\000\000\000\000\000\000\000\055\000\000\000\040\000\
\011\000\000\000\037\000\000\000\000\000\035\000\000\000\000\000\
\010\000\000\000\000\000\000\000\000\000\022\000\023\000\024\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\099\000\000\000\000\000\000\000\000\000\000\000\083\000\084\000\
\085\000\068\000\000\000\078\000\000\000\069\000\081\000\073\000\
\000\000\006\000\000\000\053\000\054\000\000\000\000\000\000\000\
\000\000\036\000\000\000\039\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\079\000\077\000\003\000\043\000\
\059\000\058\000\056\000\057\000\000\000\000\000\045\000\000\000\
\014\000\000\000\100\000\101\000\102\000\103\000\104\000\063\000\
\000\000\000\000\000\000\000\000\013\000\015\000\060\000"

let yydgoto = "\002\000\
\004\000\005\000\009\000\048\000\026\000\010\000\011\000\027\000\
\052\000\115\000\060\000\054\000\029\000\116\000\064\000\055\000\
\056\000\117\000\118\000\119\000\169\000\035\000\045\000\046\000\
\101\000\102\000\036\000\037\000\038\000\039\000\040\000\087\000"

let yysindex = "\019\000\
\010\255\000\000\051\255\000\000\048\255\103\255\002\255\099\255\
\052\255\048\255\085\255\126\255\103\255\008\255\056\255\000\000\
\000\000\000\000\000\000\088\255\097\255\126\255\000\000\109\255\
\112\255\130\255\103\255\227\000\000\000\243\254\000\000\243\254\
\243\254\000\000\179\255\000\000\000\000\000\000\098\255\098\255\
\099\255\001\255\000\000\000\000\111\255\022\255\147\255\153\000\
\000\000\103\255\138\255\035\001\154\255\000\000\000\000\000\000\
\156\255\000\000\165\255\000\000\091\255\126\255\126\255\153\255\
\126\255\140\255\126\255\146\255\000\000\000\000\008\255\008\255\
\008\255\008\255\008\255\008\255\008\255\008\255\008\255\008\255\
\008\255\008\255\008\255\000\000\000\000\000\000\009\255\000\000\
\000\000\002\255\002\255\002\255\000\000\000\000\000\000\000\000\
\188\255\001\255\001\255\183\255\189\255\001\255\000\000\000\000\
\000\000\000\000\099\255\000\000\103\255\000\000\197\255\000\000\
\000\000\000\000\170\255\200\255\012\255\000\000\182\255\000\000\
\000\000\169\255\000\000\207\255\206\255\000\000\126\255\210\255\
\000\000\211\255\167\255\149\255\149\255\000\000\000\000\000\000\
\172\255\172\255\172\255\172\255\240\000\240\000\048\001\061\001\
\000\000\184\255\185\255\186\255\187\255\190\255\000\000\000\000\
\000\000\000\000\213\255\000\000\193\255\000\000\000\000\000\000\
\220\255\000\000\126\255\000\000\000\000\134\255\126\255\203\255\
\226\255\000\000\232\255\000\000\103\255\103\255\194\255\248\255\
\251\255\254\255\015\000\016\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\169\255\245\255\000\000\234\255\
\000\000\020\000\000\000\000\000\000\000\000\000\000\000\000\000\
\103\255\103\255\103\255\247\255\000\000\000\000\000\000"

let yyrindex = "\000\000\
\000\000\000\000\000\000\000\000\214\255\018\000\000\000\000\000\
\000\000\214\255\000\000\000\000\018\000\000\000\000\000\000\000\
\000\000\000\000\000\000\255\255\000\000\000\000\000\000\000\000\
\000\000\000\000\018\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\191\255\192\255\
\000\000\000\000\000\000\000\000\000\000\015\255\000\000\000\000\
\000\000\018\000\000\000\203\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\024\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\151\255\000\000\021\000\000\000\000\000\
\000\000\000\000\000\000\000\000\018\000\000\000\000\000\000\000\
\252\000\016\001\004\255\000\000\000\000\000\000\000\000\000\000\
\000\000\025\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\043\000\062\000\000\000\000\000\000\000\
\081\000\100\000\119\000\138\000\157\000\176\000\195\000\184\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\042\000\
\000\000\000\000\230\255\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\025\000\000\000\000\000\077\255\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\018\000\000\000\000\000\000\000\000\000\000\000\000\000"

let yygindex = "\000\000\
\000\000\000\000\036\001\000\000\244\255\000\000\000\000\117\255\
\250\255\246\255\000\000\000\000\000\000\198\255\137\000\000\000\
\000\000\000\000\143\000\000\000\130\000\000\000\229\255\214\000\
\238\255\228\000\252\255\037\001\249\255\000\000\000\000\007\000"

let yytablesize = 590
let yytable = "\028\000\
\057\000\053\000\124\000\098\000\030\000\042\000\028\000\058\000\
\012\000\042\000\031\000\066\000\145\000\097\000\070\000\014\000\
\074\000\165\000\108\000\001\000\028\000\032\000\041\000\033\000\
\042\000\085\000\086\000\099\000\104\000\146\000\105\000\095\000\
\096\000\192\000\193\000\166\000\100\000\111\000\088\000\089\000\
\034\000\043\000\017\000\028\000\018\000\019\000\020\000\106\000\
\074\000\107\000\003\000\125\000\126\000\023\000\128\000\006\000\
\130\000\044\000\147\000\148\000\149\000\150\000\205\000\206\000\
\132\000\133\000\134\000\135\000\136\000\137\000\138\000\139\000\
\140\000\141\000\142\000\143\000\144\000\012\000\007\000\155\000\
\008\000\012\000\012\000\159\000\012\000\151\000\152\000\153\000\
\061\000\050\000\062\000\012\000\123\000\047\000\059\000\051\000\
\161\000\065\000\014\000\041\000\030\000\042\000\028\000\012\000\
\184\000\012\000\012\000\013\000\063\000\067\000\014\000\012\000\
\068\000\012\000\012\000\012\000\172\000\032\000\043\000\033\000\
\012\000\012\000\012\000\012\000\012\000\017\000\012\000\018\000\
\019\000\020\000\051\000\015\000\016\000\014\000\044\000\069\000\
\023\000\017\000\012\000\018\000\019\000\020\000\051\000\112\000\
\103\000\014\000\021\000\022\000\023\000\024\000\025\000\109\000\
\110\000\076\000\076\000\120\000\188\000\073\000\074\000\075\000\
\017\000\121\000\018\000\019\000\020\000\122\000\028\000\028\000\
\185\000\129\000\186\000\023\000\113\000\127\000\114\000\019\000\
\020\000\076\000\071\000\072\000\073\000\074\000\075\000\023\000\
\131\000\090\000\076\000\031\000\204\000\154\000\157\000\091\000\
\158\000\163\000\028\000\028\000\028\000\089\000\093\000\089\000\
\093\000\092\000\162\000\089\000\093\000\164\000\167\000\168\000\
\170\000\171\000\093\000\173\000\174\000\089\000\093\000\175\000\
\181\000\034\000\176\000\177\000\178\000\179\000\089\000\093\000\
\180\000\183\000\189\000\190\000\182\000\089\000\093\000\044\000\
\194\000\044\000\062\000\044\000\044\000\044\000\044\000\044\000\
\044\000\044\000\044\000\044\000\044\000\044\000\044\000\044\000\
\044\000\201\000\044\000\195\000\207\000\044\000\196\000\004\000\
\020\000\197\000\020\000\044\000\020\000\020\000\020\000\020\000\
\020\000\020\000\020\000\020\000\020\000\020\000\020\000\020\000\
\020\000\020\000\198\000\199\000\202\000\203\000\020\000\007\000\
\080\000\038\000\061\000\038\000\020\000\038\000\038\000\038\000\
\038\000\038\000\038\000\038\000\038\000\038\000\038\000\038\000\
\038\000\038\000\038\000\062\000\026\000\049\000\026\000\038\000\
\026\000\026\000\026\000\191\000\187\000\038\000\026\000\026\000\
\026\000\026\000\026\000\026\000\026\000\026\000\200\000\025\000\
\160\000\025\000\026\000\025\000\025\000\025\000\156\000\094\000\
\026\000\025\000\025\000\025\000\025\000\025\000\025\000\025\000\
\025\000\000\000\028\000\000\000\028\000\025\000\028\000\000\000\
\000\000\000\000\000\000\025\000\028\000\028\000\028\000\028\000\
\028\000\028\000\028\000\028\000\000\000\029\000\000\000\029\000\
\028\000\029\000\000\000\000\000\000\000\000\000\028\000\029\000\
\029\000\029\000\029\000\029\000\029\000\029\000\029\000\000\000\
\030\000\000\000\030\000\029\000\030\000\000\000\000\000\000\000\
\000\000\029\000\030\000\030\000\030\000\030\000\030\000\030\000\
\030\000\030\000\000\000\031\000\000\000\031\000\030\000\031\000\
\000\000\000\000\000\000\000\000\030\000\031\000\031\000\031\000\
\031\000\031\000\031\000\031\000\031\000\000\000\027\000\000\000\
\027\000\031\000\027\000\000\000\000\000\000\000\000\000\031\000\
\000\000\000\000\000\000\000\000\027\000\027\000\027\000\027\000\
\000\000\032\000\000\000\032\000\027\000\032\000\000\000\000\000\
\000\000\034\000\027\000\034\000\000\000\034\000\000\000\032\000\
\032\000\032\000\032\000\000\000\033\000\000\000\033\000\032\000\
\033\000\034\000\034\000\000\000\019\000\032\000\019\000\034\000\
\019\000\000\000\000\000\000\000\033\000\034\000\000\000\000\000\
\000\000\000\000\033\000\000\000\000\000\000\000\000\000\000\000\
\033\000\000\000\019\000\000\000\000\000\000\000\000\000\000\000\
\019\000\071\000\072\000\073\000\074\000\075\000\076\000\077\000\
\078\000\079\000\080\000\081\000\082\000\083\000\071\000\072\000\
\073\000\074\000\075\000\076\000\077\000\078\000\079\000\000\000\
\084\000\047\000\047\000\047\000\047\000\047\000\047\000\047\000\
\047\000\047\000\047\000\047\000\047\000\047\000\047\000\000\000\
\000\000\000\000\000\000\047\000\059\000\046\000\046\000\046\000\
\046\000\046\000\046\000\046\000\046\000\046\000\046\000\046\000\
\046\000\046\000\046\000\000\000\000\000\000\000\000\000\046\000\
\058\000\071\000\072\000\073\000\074\000\075\000\076\000\077\000\
\078\000\079\000\080\000\081\000\082\000\083\000\071\000\072\000\
\073\000\074\000\075\000\076\000\077\000\078\000\079\000\080\000\
\081\000\000\000\083\000\071\000\072\000\073\000\074\000\075\000\
\076\000\077\000\078\000\079\000\080\000\081\000"

let yycheck = "\006\000\
\013\000\012\000\061\000\003\001\003\001\002\001\013\000\014\000\
\001\001\006\001\009\001\022\000\004\001\041\000\027\000\008\001\
\002\001\006\001\046\000\001\000\027\000\020\001\001\001\022\001\
\003\001\039\001\040\001\027\001\007\001\021\001\009\001\039\000\
\040\000\173\000\174\000\024\001\036\001\050\000\032\000\033\000\
\039\001\020\001\035\001\050\000\037\001\038\001\039\001\026\001\
\034\001\028\001\041\001\062\000\063\000\046\001\065\000\005\001\
\067\000\036\001\050\001\051\001\052\001\053\001\202\000\203\000\
\071\000\072\000\073\000\074\000\075\000\076\000\077\000\078\000\
\079\000\080\000\081\000\082\000\083\000\001\001\031\001\098\000\
\033\001\005\001\006\001\102\000\008\001\090\000\091\000\092\000\
\001\001\005\001\003\001\001\001\002\001\042\001\039\001\005\001\
\109\000\001\001\008\001\001\001\003\001\003\001\109\000\001\001\
\163\000\029\001\030\001\005\001\021\001\001\001\008\001\035\001\
\001\001\037\001\038\001\039\001\127\000\020\001\020\001\022\001\
\044\001\045\001\046\001\047\001\048\001\035\001\001\001\037\001\
\038\001\039\001\005\001\029\001\030\001\008\001\036\001\006\001\
\046\001\035\001\001\001\037\001\038\001\039\001\005\001\006\001\
\034\001\008\001\044\001\045\001\046\001\047\001\048\001\005\001\
\000\000\003\001\004\001\002\001\167\000\009\001\010\001\011\001\
\035\001\006\001\037\001\038\001\039\001\001\001\173\000\174\000\
\035\001\030\001\037\001\046\001\035\001\021\001\037\001\038\001\
\039\001\027\001\007\001\008\001\009\001\010\001\011\001\046\001\
\039\001\007\001\036\001\009\001\201\000\002\001\008\001\013\001\
\004\001\024\001\201\000\202\000\203\000\007\001\007\001\009\001\
\009\001\023\001\006\001\013\001\013\001\006\001\025\001\039\001\
\002\001\004\001\032\001\002\001\002\001\023\001\023\001\049\001\
\004\001\039\001\035\001\035\001\035\001\035\001\032\001\032\001\
\035\001\006\001\024\001\002\001\036\001\039\001\039\001\002\001\
\039\001\004\001\003\001\006\001\007\001\008\001\009\001\010\001\
\011\001\012\001\013\001\014\001\015\001\016\001\017\001\018\001\
\019\001\005\001\021\001\004\001\006\001\024\001\004\001\042\001\
\002\001\004\001\004\001\030\001\006\001\007\001\008\001\009\001\
\010\001\011\001\012\001\013\001\014\001\015\001\016\001\017\001\
\018\001\019\001\004\001\004\001\043\001\002\001\024\001\006\001\
\004\001\002\001\002\001\004\001\030\001\006\001\007\001\008\001\
\009\001\010\001\011\001\012\001\013\001\014\001\015\001\016\001\
\017\001\018\001\019\001\002\001\002\001\010\000\004\001\024\001\
\006\001\007\001\008\001\171\000\166\000\030\001\012\001\013\001\
\014\001\015\001\016\001\017\001\018\001\019\001\189\000\002\001\
\107\000\004\001\024\001\006\001\007\001\008\001\099\000\035\000\
\030\001\012\001\013\001\014\001\015\001\016\001\017\001\018\001\
\019\001\255\255\002\001\255\255\004\001\024\001\006\001\255\255\
\255\255\255\255\255\255\030\001\012\001\013\001\014\001\015\001\
\016\001\017\001\018\001\019\001\255\255\002\001\255\255\004\001\
\024\001\006\001\255\255\255\255\255\255\255\255\030\001\012\001\
\013\001\014\001\015\001\016\001\017\001\018\001\019\001\255\255\
\002\001\255\255\004\001\024\001\006\001\255\255\255\255\255\255\
\255\255\030\001\012\001\013\001\014\001\015\001\016\001\017\001\
\018\001\019\001\255\255\002\001\255\255\004\001\024\001\006\001\
\255\255\255\255\255\255\255\255\030\001\012\001\013\001\014\001\
\015\001\016\001\017\001\018\001\019\001\255\255\002\001\255\255\
\004\001\024\001\006\001\255\255\255\255\255\255\255\255\030\001\
\255\255\255\255\255\255\255\255\016\001\017\001\018\001\019\001\
\255\255\002\001\255\255\004\001\024\001\006\001\255\255\255\255\
\255\255\002\001\030\001\004\001\255\255\006\001\255\255\016\001\
\017\001\018\001\019\001\255\255\002\001\255\255\004\001\024\001\
\006\001\018\001\019\001\255\255\002\001\030\001\004\001\024\001\
\006\001\255\255\255\255\255\255\018\001\030\001\255\255\255\255\
\255\255\255\255\024\001\255\255\255\255\255\255\255\255\255\255\
\030\001\255\255\024\001\255\255\255\255\255\255\255\255\255\255\
\030\001\007\001\008\001\009\001\010\001\011\001\012\001\013\001\
\014\001\015\001\016\001\017\001\018\001\019\001\007\001\008\001\
\009\001\010\001\011\001\012\001\013\001\014\001\015\001\255\255\
\030\001\006\001\007\001\008\001\009\001\010\001\011\001\012\001\
\013\001\014\001\015\001\016\001\017\001\018\001\019\001\255\255\
\255\255\255\255\255\255\024\001\025\001\006\001\007\001\008\001\
\009\001\010\001\011\001\012\001\013\001\014\001\015\001\016\001\
\017\001\018\001\019\001\255\255\255\255\255\255\255\255\024\001\
\025\001\007\001\008\001\009\001\010\001\011\001\012\001\013\001\
\014\001\015\001\016\001\017\001\018\001\019\001\007\001\008\001\
\009\001\010\001\011\001\012\001\013\001\014\001\015\001\016\001\
\017\001\255\255\019\001\007\001\008\001\009\001\010\001\011\001\
\012\001\013\001\014\001\015\001\016\001\017\001"

let yynames_const = "\
  LPAREN\000\
  RPAREN\000\
  LBRACK\000\
  RBRACK\000\
  LBRACE\000\
  RBRACE\000\
  PLUS\000\
  MINUS\000\
  TIMES\000\
  DIVIDES\000\
  MOD\000\
  LT\000\
  GT\000\
  LEQ\000\
  GEQ\000\
  EQ\000\
  NEQ\000\
  AND\000\
  OR\000\
  PERIOD\000\
  ASSIGN\000\
  HASH\000\
  TILDE\000\
  COMMA\000\
  COLON\000\
  QUEST\000\
  CARROT\000\
  VERT\000\
  FUN\000\
  SEMI\000\
  LBRACK_AMP\000\
  AMP_RBRACK\000\
  LBRACK_FSLASH\000\
  FSLASH_RBRACK\000\
  EOF\000\
  BEGIN\000\
  END\000\
  ELSE\000\
  IF\000\
  RETURN\000\
  THIS\000\
  WHILE\000\
  FOR\000\
  IN\000\
  TIMES_EQ\000\
  XOR_EQ\000\
  DOLLAR_EQ\000\
  TILDE_EQ\000\
  "

let yynames_block = "\
  STRING\000\
  REGEX_STRING\000\
  INT\000\
  DOUBLE\000\
  ID\000\
  CSSID\000\
  "

let yyact = [|
  (fun _ -> failwith "parser")
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 3 : 'begin_stmt) in
    let _2 = (Parsing.peek_val __caml_parser_env 2 : 'pattern_action_list) in
    let _3 = (Parsing.peek_val __caml_parser_env 1 : 'end_stmt) in
    Obj.repr(
# 52 "parser.mly"
                                             ( {begin_stmt = _1;
													pattern_actions = _2;
													end_stmt = _3} )
# 476 "parser.ml"
               : Ast.program))
; (fun __caml_parser_env ->
    let _3 = (Parsing.peek_val __caml_parser_env 1 : 'stmt_list) in
    Obj.repr(
# 57 "parser.mly"
                               (Block(_3))
# 483 "parser.ml"
               : 'begin_stmt))
; (fun __caml_parser_env ->
    let _3 = (Parsing.peek_val __caml_parser_env 1 : 'stmt_list) in
    Obj.repr(
# 59 "parser.mly"
                             (Block(_3))
# 490 "parser.ml"
               : 'end_stmt))
; (fun __caml_parser_env ->
    Obj.repr(
# 62 "parser.mly"
       ([])
# 496 "parser.ml"
               : 'pattern_action_list))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : 'pattern_action) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'pattern_action_list) in
    Obj.repr(
# 63 "parser.mly"
                                      (_1 :: _2)
# 504 "parser.ml"
               : 'pattern_action_list))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 3 : 'pattern) in
    let _3 = (Parsing.peek_val __caml_parser_env 1 : 'stmt_list) in
    Obj.repr(
# 66 "parser.mly"
                                 ( (_1,Block(_3)) )
# 512 "parser.ml"
               : 'pattern_action))
; (fun __caml_parser_env ->
    Obj.repr(
# 73 "parser.mly"
       ([])
# 518 "parser.ml"
               : 'stmt_list))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : 'stmt) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'stmt_list) in
    Obj.repr(
# 74 "parser.mly"
                  (_1 :: _2)
# 526 "parser.ml"
               : 'stmt_list))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : 'expr_no_brace) in
    Obj.repr(
# 77 "parser.mly"
                    (Expr(_1))
# 533 "parser.ml"
               : 'stmt))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : 'expr) in
    Obj.repr(
# 78 "parser.mly"
                    (Return(_2))
# 540 "parser.ml"
               : 'stmt))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : 'stmt_list) in
    Obj.repr(
# 79 "parser.mly"
                           (Block(_2))
# 547 "parser.ml"
               : 'stmt))
; (fun __caml_parser_env ->
    let _3 = (Parsing.peek_val __caml_parser_env 2 : 'expr) in
    let _5 = (Parsing.peek_val __caml_parser_env 0 : 'stmt) in
    Obj.repr(
# 80 "parser.mly"
                                           ( If(_3,_5, Block([])))
# 555 "parser.ml"
               : 'stmt))
; (fun __caml_parser_env ->
    let _3 = (Parsing.peek_val __caml_parser_env 4 : 'expr) in
    let _5 = (Parsing.peek_val __caml_parser_env 2 : 'stmt) in
    let _7 = (Parsing.peek_val __caml_parser_env 0 : 'stmt) in
    Obj.repr(
# 81 "parser.mly"
                                        ( If(_3,_5,_7) )
# 564 "parser.ml"
               : 'stmt))
; (fun __caml_parser_env ->
    let _3 = (Parsing.peek_val __caml_parser_env 2 : 'expr) in
    let _5 = (Parsing.peek_val __caml_parser_env 0 : 'stmt) in
    Obj.repr(
# 82 "parser.mly"
                                 ( While(_3,_5) )
# 572 "parser.ml"
               : 'stmt))
; (fun __caml_parser_env ->
    let _3 = (Parsing.peek_val __caml_parser_env 4 : string) in
    let _5 = (Parsing.peek_val __caml_parser_env 2 : string) in
    let _7 = (Parsing.peek_val __caml_parser_env 0 : 'stmt) in
    Obj.repr(
# 83 "parser.mly"
                                   ( For(_3,_5,_7) )
# 581 "parser.ml"
               : 'stmt))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'func_decl) in
    Obj.repr(
# 84 "parser.mly"
                 (Func(_2))
# 588 "parser.ml"
               : 'stmt))
; (fun __caml_parser_env ->
    Obj.repr(
# 85 "parser.mly"
        (Empty)
# 594 "parser.ml"
               : 'stmt))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'table_literal) in
    Obj.repr(
# 88 "parser.mly"
                  (TableLiteral(_1))
# 601 "parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'expr_no_brace) in
    Obj.repr(
# 90 "parser.mly"
                    (_1)
# 608 "parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 93 "parser.mly"
       (Id(_1))
# 615 "parser.ml"
               : 'expr_no_brace))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'literal) in
    Obj.repr(
# 94 "parser.mly"
           (Literal(_1))
# 622 "parser.ml"
               : 'expr_no_brace))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'expr_no_brace) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'expr_no_brace) in
    Obj.repr(
# 95 "parser.mly"
                                     (Binop(_1,Times,_3))
# 630 "parser.ml"
               : 'expr_no_brace))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'expr_no_brace) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'expr_no_brace) in
    Obj.repr(
# 96 "parser.mly"
                                       (Binop(_1,Divides,_3))
# 638 "parser.ml"
               : 'expr_no_brace))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'expr_no_brace) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'expr_no_brace) in
    Obj.repr(
# 97 "parser.mly"
                                   (Binop(_1,Mod,_3))
# 646 "parser.ml"
               : 'expr_no_brace))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'expr_no_brace) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'expr_no_brace) in
    Obj.repr(
# 98 "parser.mly"
                                     (Binop(_1,Minus,_3))
# 654 "parser.ml"
               : 'expr_no_brace))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'expr_no_brace) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'expr_no_brace) in
    Obj.repr(
# 99 "parser.mly"
                                    (Binop(_1,Plus,_3))
# 662 "parser.ml"
               : 'expr_no_brace))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'expr_no_brace) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'expr_no_brace) in
    Obj.repr(
# 100 "parser.mly"
                                  (Binop(_1,Equal,_3))
# 670 "parser.ml"
               : 'expr_no_brace))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'expr_no_brace) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'expr_no_brace) in
    Obj.repr(
# 101 "parser.mly"
                                  (Binop(_1,Less,_3))
# 678 "parser.ml"
               : 'expr_no_brace))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'expr_no_brace) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'expr_no_brace) in
    Obj.repr(
# 102 "parser.mly"
                                  (Binop(_1,Greater,_3))
# 686 "parser.ml"
               : 'expr_no_brace))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'expr_no_brace) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'expr_no_brace) in
    Obj.repr(
# 103 "parser.mly"
                                   (Binop(_1,LessEqual,_3))
# 694 "parser.ml"
               : 'expr_no_brace))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'expr_no_brace) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'expr_no_brace) in
    Obj.repr(
# 104 "parser.mly"
                                   (Binop(_1,GreaterEqual,_3))
# 702 "parser.ml"
               : 'expr_no_brace))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'expr_no_brace) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'expr_no_brace) in
    Obj.repr(
# 105 "parser.mly"
                                   (Binop(_1,NotEqual,_3))
# 710 "parser.ml"
               : 'expr_no_brace))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'expr_no_brace) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'expr_no_brace) in
    Obj.repr(
# 106 "parser.mly"
                                   (Binop(_1,BAnd,_3))
# 718 "parser.ml"
               : 'expr_no_brace))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'expr_no_brace) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'expr_no_brace) in
    Obj.repr(
# 107 "parser.mly"
                                  (Binop(_1,BOr,_3))
# 726 "parser.ml"
               : 'expr_no_brace))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : string) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 108 "parser.mly"
                  (Assign(_1,_3))
# 734 "parser.ml"
               : 'expr_no_brace))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 3 : string) in
    let _3 = (Parsing.peek_val __caml_parser_env 1 : 'expr_list) in
    Obj.repr(
# 109 "parser.mly"
                              (Call(_1,_3))
# 742 "parser.ml"
               : 'expr_no_brace))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : string) in
    Obj.repr(
# 110 "parser.mly"
                     (Call(_1,[]))
# 749 "parser.ml"
               : 'expr_no_brace))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : string) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'bracket_expr_list) in
    Obj.repr(
# 111 "parser.mly"
                        (TableAccess(_1,_2))
# 757 "parser.ml"
               : 'expr_no_brace))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 3 : string) in
    let _2 = (Parsing.peek_val __caml_parser_env 2 : 'bracket_expr_list) in
    let _4 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 112 "parser.mly"
                                    (TableAssign(_1,_2,_4))
# 766 "parser.ml"
               : 'expr_no_brace))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : 'expr) in
    Obj.repr(
# 113 "parser.mly"
                         (_2)
# 773 "parser.ml"
               : 'expr_no_brace))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'expr_no_brace) in
    Obj.repr(
# 114 "parser.mly"
                                       (Uminus(_2))
# 780 "parser.ml"
               : 'expr_no_brace))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 117 "parser.mly"
        ( [_1] )
# 787 "parser.ml"
               : 'expr_list))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'expr_list) in
    Obj.repr(
# 118 "parser.mly"
                         ( _1 :: _3 )
# 795 "parser.ml"
               : 'expr_list))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : 'expr) in
    Obj.repr(
# 121 "parser.mly"
                      ([_2])
# 802 "parser.ml"
               : 'bracket_expr_list))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 2 : 'expr) in
    let _4 = (Parsing.peek_val __caml_parser_env 0 : 'bracket_expr_list) in
    Obj.repr(
# 122 "parser.mly"
                                        ( _2 :: _4)
# 810 "parser.ml"
               : 'bracket_expr_list))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : int) in
    Obj.repr(
# 125 "parser.mly"
     (IntLiteral(_1))
# 817 "parser.ml"
               : 'literal))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 126 "parser.mly"
         (StringLiteral(_1))
# 824 "parser.ml"
               : 'literal))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : float) in
    Obj.repr(
# 127 "parser.mly"
         (DoubleLiteral(_1))
# 831 "parser.ml"
               : 'literal))
; (fun __caml_parser_env ->
    Obj.repr(
# 128 "parser.mly"
        (This)
# 837 "parser.ml"
               : 'literal))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'array_literal) in
    Obj.repr(
# 131 "parser.mly"
               (_1)
# 844 "parser.ml"
               : 'table_literal))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'keyvalue_literal) in
    Obj.repr(
# 132 "parser.mly"
                   (KeyValueLiteral(_1))
# 851 "parser.ml"
               : 'table_literal))
; (fun __caml_parser_env ->
    Obj.repr(
# 135 "parser.mly"
                  ( EmptyTable )
# 857 "parser.ml"
               : 'array_literal))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : 'expr_list) in
    Obj.repr(
# 136 "parser.mly"
                          (ArrayLiteral(_2))
# 864 "parser.ml"
               : 'array_literal))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : 'keyvalue_list) in
    Obj.repr(
# 139 "parser.mly"
                             (_2)
# 871 "parser.ml"
               : 'keyvalue_literal))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'keyvalue) in
    Obj.repr(
# 142 "parser.mly"
          ( [_1] )
# 878 "parser.ml"
               : 'keyvalue_list))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'keyvalue_list) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'keyvalue) in
    Obj.repr(
# 143 "parser.mly"
                               ( _3 :: _1)
# 886 "parser.ml"
               : 'keyvalue_list))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'key) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 146 "parser.mly"
                 ( (_1,_3) )
# 894 "parser.ml"
               : 'keyvalue))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : int) in
    Obj.repr(
# 149 "parser.mly"
        (IntKey(_1))
# 901 "parser.ml"
               : 'key))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 150 "parser.mly"
            (StringKey(_1))
# 908 "parser.ml"
               : 'key))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 6 : string) in
    let _3 = (Parsing.peek_val __caml_parser_env 4 : 'params_list) in
    let _6 = (Parsing.peek_val __caml_parser_env 1 : 'stmt_list) in
    Obj.repr(
# 153 "parser.mly"
                                                      ( {fname=_1;
															params=_3;
															body=_6;
														})
# 920 "parser.ml"
               : 'func_decl))
; (fun __caml_parser_env ->
    Obj.repr(
# 159 "parser.mly"
       ( [] )
# 926 "parser.ml"
               : 'params_list))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 160 "parser.mly"
      ( [_1] )
# 933 "parser.ml"
               : 'params_list))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : string) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'params_list) in
    Obj.repr(
# 161 "parser.mly"
                        (_1::_3)
# 941 "parser.ml"
               : 'params_list))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : 'css_selector) in
    Obj.repr(
# 164 "parser.mly"
                                    (CssPattern(_2))
# 948 "parser.ml"
               : 'pattern))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : 'regex_sequence) in
    Obj.repr(
# 165 "parser.mly"
                                              (RegexPattern(_2))
# 955 "parser.ml"
               : 'pattern))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 172 "parser.mly"
              (RegexString(_1))
# 962 "parser.ml"
               : 'regex))
; (fun __caml_parser_env ->
    Obj.repr(
# 173 "parser.mly"
          (RegexAnyChar)
# 968 "parser.ml"
               : 'regex))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : 'regex_sequence) in
    Obj.repr(
# 174 "parser.mly"
                                (RegexNested(_2))
# 975 "parser.ml"
               : 'regex))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : 'regex_set_sequence) in
    Obj.repr(
# 175 "parser.mly"
                                    (RegexSet(_2))
# 982 "parser.ml"
               : 'regex))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : 'regex) in
    Obj.repr(
# 176 "parser.mly"
               (RegexUnOp(_1,Optional))
# 989 "parser.ml"
               : 'regex))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : 'regex) in
    Obj.repr(
# 177 "parser.mly"
              (RegexUnOp(_1,KleenePlus))
# 996 "parser.ml"
               : 'regex))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : 'regex) in
    Obj.repr(
# 178 "parser.mly"
               (RegexUnOp(_1,KleeneTimes))
# 1003 "parser.ml"
               : 'regex))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'regex) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'regex) in
    Obj.repr(
# 179 "parser.mly"
                    (RegexBinOp(_1,Or,_3))
# 1011 "parser.ml"
               : 'regex))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'regex) in
    Obj.repr(
# 182 "parser.mly"
       ([_1])
# 1018 "parser.ml"
               : 'regex_sequence))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : 'regex) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'regex_sequence) in
    Obj.repr(
# 183 "parser.mly"
                        (_1 :: _2)
# 1026 "parser.ml"
               : 'regex_sequence))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 186 "parser.mly"
              (RegexStringSet(_1))
# 1033 "parser.ml"
               : 'regex_set))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : string) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 187 "parser.mly"
                                  (RegexRangeSet(_1,_3))
# 1041 "parser.ml"
               : 'regex_set))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'regex_set) in
    Obj.repr(
# 188 "parser.mly"
                    (RegexComplementSet(_2))
# 1048 "parser.ml"
               : 'regex_set))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : 'regex_set_sequence) in
    Obj.repr(
# 189 "parser.mly"
                                    (RegexNestedSet(_2))
# 1055 "parser.ml"
               : 'regex_set))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'regex_set) in
    Obj.repr(
# 192 "parser.mly"
           ([_1])
# 1062 "parser.ml"
               : 'regex_set_sequence))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : 'regex_set) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'regex_set_sequence) in
    Obj.repr(
# 193 "parser.mly"
                                (_1 :: _2)
# 1070 "parser.ml"
               : 'regex_set_sequence))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'simple_selector_seq) in
    Obj.repr(
# 199 "parser.mly"
                     (SingleSelector(_1))
# 1077 "parser.ml"
               : 'css_selector))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'css_selector) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'simple_selector_seq) in
    Obj.repr(
# 200 "parser.mly"
                                         (ChainedSelectors(_1,DirectSibling,_3))
# 1085 "parser.ml"
               : 'css_selector))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'css_selector) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'simple_selector_seq) in
    Obj.repr(
# 201 "parser.mly"
                                       (ChainedSelectors(_1,Descendent,_3))
# 1093 "parser.ml"
               : 'css_selector))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'css_selector) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'simple_selector_seq) in
    Obj.repr(
# 202 "parser.mly"
                                          (ChainedSelectors(_1,AnySibling,_3))
# 1101 "parser.ml"
               : 'css_selector))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : 'css_selector) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'typed_simple_selector_seq) in
    Obj.repr(
# 203 "parser.mly"
                                          (ChainedSelectors(_1,DirectChild,_2))
# 1109 "parser.ml"
               : 'css_selector))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'typed_simple_selector_seq) in
    Obj.repr(
# 206 "parser.mly"
                           (_1)
# 1116 "parser.ml"
               : 'simple_selector_seq))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'property_selector_list) in
    Obj.repr(
# 207 "parser.mly"
                          ((NoType,_1))
# 1123 "parser.ml"
               : 'simple_selector_seq))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'type_selector) in
    Obj.repr(
# 210 "parser.mly"
               ((_1,[]))
# 1130 "parser.ml"
               : 'typed_simple_selector_seq))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : 'type_selector) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'property_selector_list) in
    Obj.repr(
# 211 "parser.mly"
                                        ((_1,_2))
# 1138 "parser.ml"
               : 'typed_simple_selector_seq))
; (fun __caml_parser_env ->
    Obj.repr(
# 214 "parser.mly"
       (Universal)
# 1144 "parser.ml"
               : 'type_selector))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 215 "parser.mly"
     (Elt(_1))
# 1151 "parser.ml"
               : 'type_selector))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'property_selector) in
    Obj.repr(
# 218 "parser.mly"
                   ( [_1])
# 1158 "parser.ml"
               : 'property_selector_list))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : 'property_selector) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'property_selector_list) in
    Obj.repr(
# 219 "parser.mly"
                                            ( _1::_2)
# 1166 "parser.ml"
               : 'property_selector_list))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 222 "parser.mly"
       (_1)
# 1173 "parser.ml"
               : 'css_id))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 223 "parser.mly"
      (_1)
# 1180 "parser.ml"
               : 'css_id))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'css_id) in
    Obj.repr(
# 226 "parser.mly"
               (ClassMatch(_2))
# 1187 "parser.ml"
               : 'property_selector))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'css_id) in
    Obj.repr(
# 227 "parser.mly"
               (IdMatch(_2))
# 1194 "parser.ml"
               : 'property_selector))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : 'css_id) in
    Obj.repr(
# 228 "parser.mly"
                        (AttributeExists(_2))
# 1201 "parser.ml"
               : 'property_selector))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 3 : 'css_id) in
    let _4 = (Parsing.peek_val __caml_parser_env 1 : string) in
    Obj.repr(
# 229 "parser.mly"
                                      (AttributeEquals(_2,_4))
# 1209 "parser.ml"
               : 'property_selector))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 3 : 'css_id) in
    let _4 = (Parsing.peek_val __caml_parser_env 1 : string) in
    Obj.repr(
# 230 "parser.mly"
                                        (AttributeContains(_2,_4))
# 1217 "parser.ml"
               : 'property_selector))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 3 : 'css_id) in
    let _4 = (Parsing.peek_val __caml_parser_env 1 : string) in
    Obj.repr(
# 231 "parser.mly"
                                      (AttributeBeginsWith(_2,_4))
# 1225 "parser.ml"
               : 'property_selector))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 3 : 'css_id) in
    let _4 = (Parsing.peek_val __caml_parser_env 1 : string) in
    Obj.repr(
# 232 "parser.mly"
                                         (AttributeEndsWith(_2,_4))
# 1233 "parser.ml"
               : 'property_selector))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 3 : 'css_id) in
    let _4 = (Parsing.peek_val __caml_parser_env 1 : string) in
    Obj.repr(
# 233 "parser.mly"
                                        (AttributeWhitespaceContains(_2,_4))
# 1241 "parser.ml"
               : 'property_selector))
(* Entry program *)
; (fun __caml_parser_env -> raise (Parsing.YYexit (Parsing.peek_val __caml_parser_env 0)))
|]
let yytables =
  { Parsing.actions=yyact;
    Parsing.transl_const=yytransl_const;
    Parsing.transl_block=yytransl_block;
    Parsing.lhs=yylhs;
    Parsing.len=yylen;
    Parsing.defred=yydefred;
    Parsing.dgoto=yydgoto;
    Parsing.sindex=yysindex;
    Parsing.rindex=yyrindex;
    Parsing.gindex=yygindex;
    Parsing.tablesize=yytablesize;
    Parsing.table=yytable;
    Parsing.check=yycheck;
    Parsing.error_function=parse_error;
    Parsing.names_const=yynames_const;
    Parsing.names_block=yynames_block }
let program (lexfun : Lexing.lexbuf -> token) (lexbuf : Lexing.lexbuf) =
   (Parsing.yyparse yytables 1 lexfun lexbuf : Ast.program)
