open Sast

let rec type_to_str = function
  Int -> "int"
  | Double -> "double"
  | Table(value_type) as t -> (type_to_boxed_str t)
  | String -> "String"
	| Void -> "void"
	| EmptyTable -> "wtf" (*raise (Failure "EmptyTable should never be generated. semantics messed up") *)

and type_to_boxed_str = function
    Int -> "Integer"
    | Double -> "Double"
    | Table(value_type) -> "_HAWKTable<" ^ (type_to_boxed_str value_type) ^ ">"
    | t -> type_to_str t

let rec repeat str n =
	match str,n with
		|s,0 -> ""
		|s,1 -> s
		|s,n -> s ^ (repeat str (n-1))

let string_for_indent indent =
	repeat "\t" indent

let rec string_of_regex_set = function
  Ast.RegexStringSet(str) -> str
  | Ast.RegexRangeSet(str1, str2) -> str1 ^ "-" ^ str2
  | Ast.RegexComplementSet(set) -> "^" ^ (string_of_regex_set set)
  | Ast.RegexNestedSet(set) -> (string_of_regex_set_sequence set)

and string_of_regex_set_sequence seq =
	let all_together = String.concat "" (List.map string_of_regex_set seq) in
	"[" ^ all_together ^ "]"

let string_of_regex_op op =
	match op with
		| Ast.Or -> "|"
		| Ast.Optional -> "?"
		| Ast.KleenePlus -> "+"
		| Ast.KleeneTimes -> "*"

let rec string_of_regex regex = match regex with
  Ast.RegexString(str) -> str
  | Ast.RegexAnyChar -> "."
  | Ast.RegexNested(sequence) -> "(" ^ (string_of_regex_sequence sequence) ^ ")"
  | Ast.RegexSet(sequence) -> string_of_regex_set_sequence sequence
  | Ast.RegexUnOp(re,op) -> (string_of_regex re) ^ (string_of_regex_op op)
  | Ast.RegexBinOp(re1,op,re2) -> (string_of_regex re1) ^ (string_of_regex_op op) ^ (string_of_regex re1)

and string_of_regex_sequence seq = String.concat "" (List.map string_of_regex seq)

let string_of_property prop = match prop with
	|Ast.ClassMatch(s) -> "." ^ s
	|Ast.IdMatch(s) -> "#" ^s
	| Ast.AttributeExists(str) -> "[" ^ str ^ "]"
	| Ast.AttributeEquals(attr,str) -> "[" ^ attr ^ "=" ^ str ^ "]"
	| Ast.AttributeContains(attr,str) -> "[" ^ attr ^ "*=" ^ str ^ "]"
	| Ast.AttributeBeginsWith(attr,str) -> "[" ^ attr ^ "^=" ^ str ^ "]"
	| Ast.AttributeEndsWith(attr,str) -> "[" ^ attr ^ "$=" ^ str ^ "]"
	| Ast.AttributeWhitespaceContains(attr,str) -> "[" ^ attr ^ "~=" ^ str ^ "]"

let string_of_type_selector = function
	|Ast.Elt(str) -> str
	| Ast.Universal -> "*"
	| Ast.NoType -> ""

let string_of_simple_selector_seq (type_selector,props) =
	let prop_string = List.fold_left (fun acc prop -> acc ^ (string_of_property prop)) "" props in
	(string_of_type_selector type_selector) ^ prop_string

let string_of_combinator = function
	| Ast.DirectChild -> " "
	| Ast.Descendent -> ">"
	| Ast.DirectSibling -> "+"
	| Ast.AnySibling -> "~"

let rec string_of_css_selector css_selector = match css_selector with
	| Ast.SingleSelector(seq) -> (string_of_simple_selector_seq seq)
	| Ast.ChainedSelectors(selector,comb,seq) -> (string_of_css_selector selector) ^ (string_of_combinator comb) ^ (string_of_simple_selector_seq seq)

let string_of_op = function
	Ast.Plus ->  " + "
	| Ast.Minus ->  " - "
	| Ast.Times ->  " * "
	| Ast.Divides ->  " / "
  | Ast.Mod -> "%"
	| Ast.Equal ->  " == "
	| Ast.NotEqual ->  " != "
	| Ast.Less ->  " < "
	| Ast.LessEqual ->  " <= "
	| Ast.Greater ->  " > "
	| Ast.GreaterEqual ->  " >= "

let string_of_key_literal = function
	Ast.IntKey(key) -> string_of_int key
	| Ast.StringKey(key) -> key


(*TODO: these don't need to all be mutually recursive*)
let rec string_of_table_literal kv_list table_t =
	let string_of_kv = function
		| Ast.IntKey(i), expr -> ".setIntIndexChained(" ^ (string_of_int i) ^ "," ^ (string_of_expr expr) ^ ")"
		| Ast.StringKey(s), expr -> ".setStringIndexChained(" ^ s ^ "," ^ (string_of_expr expr) ^ ")"
	in
	let kv_part = String.concat "" (List.map string_of_kv kv_list) in
	"(new " ^ (type_to_str (Table (table_t))) ^ "())" ^ kv_part
and
string_of_literal = function
	Ast.IntLiteral(x), _ -> string_of_int x
	| Ast.StringLiteral(str), _ -> str
	| Ast.DoubleLiteral(dbl), _ -> string_of_float dbl
	| Ast.This, _-> "This"
and string_of_expr_list = function
	[] -> ""
	| [hd] -> string_of_expr hd
	| hd::tl -> (string_of_expr hd) ^ ", " ^ string_of_expr_list tl
and string_of_get_index_expr = function
	ind_e,Int as e -> ".getIntIndex(" ^ (string_of_expr e) ^ ")"
	| ind_e,String as e -> ".getStringIndex(" ^ (string_of_expr e) ^ ")"
	| _ -> raise (Failure "This type of table indexing should not happen. Semantic stage must have failed.")
and string_of_set_index_expr ind value =
	string_of_set_index_expr_with_value_str ind (string_of_expr value)
and string_of_set_index_expr_with_value_str ind value_str =
	let inner = ((string_of_expr ind) ^ "," ^ value_str) in
	match ind with
		(_,Int) -> ".setIntIndex(" ^ inner ^ ")"
		| (_,String)  -> ".setStringIndex(" ^ inner ^ ")"
		| _ -> raise (Failure "This type of table indexing should not happen. Semantic stage must have failed.")
and
	string_of_assignment_rhs expr t mode =
	(match mode with
		| DeferredTableLiteral(_,_,tl) ->
			let new_tl = Semantics.retype_empty_table_literal tl t in
			string_of_expr (TableLiteral(new_tl),t)
		| DeferredCreation(_,_) -> "new " ^ (type_to_str t) ^ "()"
		| _ -> (string_of_expr expr)

	)
and
string_of_expr = function
	Id(id), _ -> id
	| Literal(lit), t -> string_of_literal (lit,t)
	| TableLiteral(kv_list), Table(val_type) -> string_of_table_literal kv_list val_type
	| VAssign(id, expr, assign_mode), t ->
		let typ = Semantics.get_assignment_type assign_mode t in
		(type_to_str typ) ^ " " ^ id ^ " = " ^ (string_of_assignment_rhs expr typ assign_mode) (*(string_of_expr expr) *)
	| Assign(id, expr, assign_mode), t ->
		let typ = Semantics.get_assignment_type assign_mode t in
		id ^ " = " ^ (string_of_assignment_rhs expr typ assign_mode) (* (string_of_expr expr) *)
	| Binop(expr1, op, expr2), _ -> (string_of_expr expr1) ^ (string_of_op op) ^ (string_of_expr expr2)
	| Uminus(expr), _ -> "-" ^ (string_of_expr expr)
	| Call(id, expr_list), _ -> id ^ "(" ^ string_of_expr_list expr_list ^ ")"
	| TableAccess(table_id, ind_list), _ ->
		table_id ^ (String.concat "" (List.map string_of_get_index_expr ind_list))
	| TableAssign(table_id,ind_list,assignee, assign_mode), t ->
		let nesting_level = (List.length ind_list) in
		let nestings = (Util.range 1 (nesting_level+1)) in
		let enum_ind_list = (List.combine ind_list nestings) in
		let value_str = (match assign_mode with
			| DeferredCreation(_,_) ->
				let table_t = Semantics.get_assignment_type assign_mode t in
				let nested_table_t = Semantics.apply_nesting (table_t,-nesting_level) in
				let type_str = (type_to_str nested_table_t)  in
				"new " ^ type_str ^ "()"
			| _ ->
				(string_of_expr assignee)
			)
		in 		
		(*
		a[1][2][3] = 4 gets an inner table, which gets an inner table, which then sets index 3 to 4
		*)
		let ind_to_string (ind_expr,nesting) =
			match ind_expr,nesting with
				ind_e,n when n=nesting_level -> string_of_set_index_expr_with_value_str ind_e value_str
				|ind_e,_ -> string_of_get_index_expr ind_e
		in
		table_id ^ (String.concat "" (List.map ind_to_string enum_ind_list))
		
	| _ -> raise (Failure "We shouldn't be here.")
and string_of_func_decl func_decl  =
	let param_names = (List.map fst func_decl.params) in
	func_decl.fname ^ "(" ^ (String.concat "," param_names) ^ ")" ^ (string_of_stmt_list func_decl.body 0)
and
string_of_stmt_list stmt_list nested = match stmt_list with
	[] -> ""
	| hd::tl -> (string_of_stmt hd nested) ^ "\n" ^ (string_of_stmt_list tl nested)
and string_of_stmt stmt nested = match stmt with
	Block(stmt_list, _) -> "{\n" ^ (string_of_stmt_list stmt_list nested) ^ "\n" ^ (string_for_indent (nested - 1)) ^ "}"
	| Expr(expr) -> (string_for_indent nested) ^ (string_of_expr expr) ^ ";"
	| Func(func_decl) -> ""
	| Return(expr) -> (string_for_indent nested) ^ "return " ^ (string_of_expr expr) ^ ";"
	| If(expr, stmt1, stmt2) -> (string_for_indent nested) ^ "if(_checkIf(" ^ (string_of_expr expr) ^ "))" ^ (string_of_stmt stmt1 nested) ^ "else" ^ (string_of_stmt stmt2 nested)
	| While(expr, stmt) -> (string_for_indent nested) ^ "while(" ^ (string_of_expr expr) ^ ")" ^ (string_of_stmt stmt (nested + 1))
	| For(key_id, table_id, stmt) -> 
		(string_for_indent nested) ^ "for(String " ^ key_id ^ " : " ^ table_id ^ ".getKeys())" ^ (string_of_stmt stmt nested)

let string_of_begin_end block nested= match block with
  Block(stmt_list, _) -> string_of_stmt_list stmt_list nested
  | _ -> ""

let string_of_pattern pat = match pat with
		Ast.CssPattern(css_selector) -> "for(String _this : _cssMatcher._match(\"" ^ (string_of_css_selector css_selector) ^"\"))"
		| Ast.RegexPattern(regex_seq) -> "for(String _this : _regexMatcher._match(\""^string_of_regex_sequence regex_seq^"\"))"

let string_of_pattern_action nested (pattern,action) =
	(string_of_pattern pattern) ^ (string_of_stmt action nested)

let string_of_file file nested =
  let file_string = ref "" in
  let ic = open_in file in
    try
      while true; do
        file_string :=  !file_string ^ (string_for_indent nested) ^ (input_line ic) ^ "\n";
      done; !file_string
    with End_of_file ->
      close_in ic;
  !file_string

 let string_of_typed_param param =
 	(type_to_str (snd param)) ^ " " ^ (fst param)

 let string_of_user_func nested func_decl =
 	(string_for_indent nested) ^ "public static " ^ (type_to_str func_decl.return_type)
 	^ " " ^ func_decl.fname ^ "(" ^ String.concat "," (List.map string_of_typed_param func_decl.params) ^ ")"
 	^ "{\n" ^  (string_of_stmt_list func_decl.body (nested + 1)) ^  "\n" ^ (string_for_indent nested) ^ "}"

 let string_of_user_funcs func_decls nested =
 	String.concat "\n\n" (List.map (string_of_user_func nested) func_decls)

let string_of_program prog =
  (string_of_file "Imports.java" 0)
	^  "public class Program {\n"
	^ (string_for_indent 1) ^ "public static void main(String[] _args){" ^ "\n"
  ^  (string_of_file "Setup.java" 2)
	^ (string_of_begin_end prog.begin_stmt 2)
	^ (String.concat "\n" (List.map (string_of_pattern_action 2) prog.pattern_actions)) ^"\n"
	^ (string_of_begin_end prog.end_stmt 2) ^ "\n" ^ (string_for_indent 1) ^ "}\n"
  ^ (string_of_file "BuiltIn.java" 1)
  ^ (string_of_user_funcs prog.concrete_funcs 1) ^ "\n"
  ^ "}"
