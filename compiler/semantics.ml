open Sast

let is_table = function
	Table(_) | EmptyTable -> true
	| _ -> false
	
let rec type_to_str = function
  Int -> "int"
  | Double -> "double"
  | Table(value_type) as t -> "Table(" ^ (type_to_str value_type) ^ ")"
  | String -> "String"
	| Void -> "void"
	| EmptyTable -> "ET"
	| UnknownReturn -> "UR"

let get_binop_type t1 op t2 =
  match op with
  Ast.Plus -> (
	match t1, t2 with
	_, UnknownReturn | UnknownReturn,_ -> UnknownReturn
	|x, y when x = y && not (is_table x) ->  x
	| x, y when x = String || y = String ->  String
	| Int, Double -> Double
	| Double, Int -> Double
	| _ , _ -> raise (Failure("binary operation type mismatch"))
	)
  | _ -> (
	match t1, t2 with
	_, UnknownReturn | UnknownReturn,_ -> UnknownReturn
	|x, y when x = y && not (is_table x) && x != String ->  x
	| Int, Double ->  Double
	| Double, Int ->  Double
	| _ , _ -> raise (Failure("binary operation type mismatch or operation does not support these types"))
	)

type b_arg_types = BAny | BTable | BString | BInt

(*Built-in functions and their types*)
let built_in = [("_print_", [BAny], Int); ("_exists_", [BAny], Int);
                ("_length_", [BAny], Int); ("_keys_", [BTable], Table(String));
                ("_children_", [BTable], String); ("_inner_html_", [BTable], String);
                ("_charAt_", [BString; BInt], String); ("_stringEqual_", [BString; BString], Int);
				("_stringToInt_", [BString],Int) ]

let rec find_var_and_scope (scope : symbol_table) name = try
  (List.find (fun (s, _) -> s = name) scope.variables),scope with Not_found ->
  match scope.parent with
    Some(parent) -> find_var_and_scope parent name
    | _ -> raise Not_found

let rec is_empty_table_container = function
	EmptyTable -> true
	| Table(t) -> (is_empty_table_container t)
	| _ -> false

let rec find (scope : symbol_table) name =
	fst (find_var_and_scope scope name )

let assert_not_void typ err =
	if typ = Void then
		raise (Failure err)

let get_sig_return_type global_env func_sig =
	List.assoc func_sig global_env.func_signatures


let add_initial_func_signature global_env func_signature =
	ignore (global_env.func_signatures<- (func_signature,UnknownReturn)::(global_env.func_signatures))

let get_existing_func_sig global_env func_signature =
	try
		let entry = List.find (fun entry -> (fst entry) = func_signature) global_env.func_signatures in
		Some (func_signature,(snd entry))
	with Not_found -> None

(*
if a variable is of type t1, can it be assigned to a variable of type t2?
obviously if:

a=3
then you can do
a=10 (both are Int)

but also if:
a = {}
then
a = {{3}} is allowable too because EmptyTable can possibly match any table
(and vice versa)
*)
let rec can_assign t1 t2 =
	match t1,t2 with
		t1,t2 when t1=t2 -> true
		| EmptyTable, Table(t) -> true
		| Table(t), EmptyTable -> true
		| Table(s), Table(t) -> (can_assign s t)
		| _ -> false


(*Find a built in function by name  *)
let rec find_built_in name = try
  List.find (fun (s, t, r) -> s = name) built_in with Not_found -> raise Not_found

(*Update a variable type of a variable within a given symbol table,
going up parent links until matching variable is found
This function has side effects*)
let rec update_variable_type sym_t var_id new_type =
	try
		let _ = (find sym_t var_id) in (* this will raise exception if variable doesn't exist *)
		let new_variable_list =
			List.map (fun (v_id,typ) -> if v_id=var_id then (v_id,new_type) else (v_id,typ)) sym_t.variables
		in
		ignore (sym_t.variables <- new_variable_list)
	with Not_found ->
		match sym_t.parent with
			None -> raise (Failure "Couldn't find variable to update")
			| Some(parent) -> update_variable_type parent var_id new_type


(* Eliminate links for updating table types between two variables
this function has side effects
 *)
let remove_update_table_link table_id sym_tab link_id link_scope =
	(* match on value equality for link id and reference equality for link scope *)
	let keep_entry (t_id,update_link) =
		not (t_id=table_id && update_link.id=link_id && update_link.assign_scope == link_scope)
	in
	sym_tab.update_table_links<- List.filter keep_entry sym_tab.update_table_links

let remove_mutual_update_table_links table_id sym_tab link_id link_scope =
	remove_update_table_link table_id sym_tab link_id link_scope;
	remove_update_table_link link_id link_scope table_id sym_tab

let add_update_table_link table_id sym_tab link_id link_scope nesting =
	let new_update_link = {id=link_id;assign_scope=link_scope;nesting=nesting} in
	sym_tab.update_table_links <- (table_id,new_update_link)::sym_tab.update_table_links

(* imagine:
t = { {} }
s = t[0]

s is linked to t with nesting level 1
t is linked to s with nesting level -1

if you do:
t[0][0] = 3, then t goes from Table(EmptyTable) to Table(Table(Int)), and s should go from EmptyTable to Table(Int)

if you do:
s[0] = 3, the end result should be the same
*)
let add_mutual_update_table_link table_id sym_tab link_id link_scope nesting =
	remove_mutual_update_table_links table_id sym_tab link_id link_scope;
	add_update_table_link table_id sym_tab link_id link_scope nesting;
	add_update_table_link link_id link_scope table_id sym_tab (-nesting)


(*nest or unnest a type with additional tables
e.g.
apply_nesting Int 1 = Table(Int)
apply_nesting Table(Table(Int)) -1 = Table(Int)
*)
let rec apply_nesting = function
	t, 0 -> t
	| t, n when n>0 -> Table (apply_nesting (t,n-1))
	| Table(t),n when n<0 -> (apply_nesting (t,n+1))
	| _ -> raise (Failure "Attempting to unnest non-table.")


let is_identifier_expr = function
	| Id(_) -> true
	| TableAccess(_) -> true
	| Assign(_) -> true
	| TableAssign(_) -> true
	| _ -> false

(* return the identifier and nesting level for
identifier based expressions

None for non-identifier based expressions
 *)
let get_identifier_expr_info = function
	Id(id) -> Some (id,0)
	| TableAccess(id,ind_list) -> Some (id,(List.length ind_list))
	| Assign(id,_) -> Some (id,0)
	| TableAssign(id,ind_list,_) -> Some (id, (List.length ind_list))
	| _ -> None

let get_var_type_promise scope id =
	let promise () =
		let (_,t) = (find scope id) in
		t
	in
	promise

let get_id_based_expr_promise id scope nesting expr =
	let promise () =
		let (_,t) = (find scope id) in
		expr, (apply_nesting (t,(-nesting)))
	in
	promise
(*
imagine:
t = {3:{},10:{}}
if we later find out the type of t to be Table(Table(Int)) or something even more nested, then we can now determine the
types of the nested empty tables in this table literal
*)
let rec retype_empty_table_literal table_literal new_table_type =
	match table_literal with
		| [] -> []
		| (key, (old_e, old_t))::tail ->
			let inner_t = apply_nesting (new_table_type,-1) in
			let new_e = (match old_e with
				|TableLiteral(tl) -> TableLiteral (retype_empty_table_literal tl inner_t)
				| _ -> old_e)
			in
			(key, (new_e,inner_t))::(retype_empty_table_literal tail new_table_type)

let get_table_literal_promise assigner tl =
	let promise () =
		let (_,new_t) = (find assigner.assign_scope assigner.id ) in
		let nested_t = apply_nesting (new_t,(-assigner.nesting)) in
		let new_tl = retype_empty_table_literal tl nested_t in
		TableLiteral(new_tl),nested_t
	in promise

(*
Return a promise which will return
a SAST expression given our current knowledge of symbol tables
Once the semantics stage has completed this promise will give us our best
possible understanding of an expression

These promises are used anytime an l-value or potential l-value is involved. This includes:

1. assignment
2. table assignment
3. return statements

Uncertainty arises from:

1. Empty table literals (EmptyTable)
2. Recursive calls  (UnknownReturn)

But can always be resolved when syntactic analysis is over
*)
let rec get_expression_promise assigner global_env assignee_e assignee_type assignee_scope =
	let is_et = (is_empty_table_container assignee_type) in
	let id_info = get_identifier_expr_info assignee_e in
	let noop_promise = (fun () -> assignee_e,assignee_type) in
	let checked_promise promise = 
		(fun () ->
			match assigner with
				| _ when (not global_env.finished) -> (promise ())
				| None -> (promise ())
				| Some(assgn) when global_env.finished ->
					let (_,assgn_t) = (find assgn.assign_scope assgn.id) in
					let assgn_t = apply_nesting (assgn_t,-assgn.nesting) in
					let (_,new_t) as result = (promise ()) in
					if assgn_t<>new_t then
						raise 
						(Failure ("Trying to assign variable " ^ assgn.id ^ 
						" of type " ^ (type_to_str assgn_t) ^ " with incompatible type " ^ (type_to_str new_t)))
					else
						result
		)
	in
	let promise = (match assignee_e with
		Binop(e1,op,e2) ->
			let (e1_e,e1_type) = e1 in
			let (e2_e,e2_type) = e2 in
			let e1_promise = get_expression_promise None global_env e1_e e1_type assignee_scope in
			let e2_promise = get_expression_promise None global_env e2_e e2_type assignee_scope in
			( fun () ->
				let (e1_e,e1_type) as e1 = (e1_promise ()) in
				let (e2_e,e2_type) as e2 = (e2_promise ()) in
				Binop(e1,op,e2), (get_binop_type e1_type op e2_type)
			)
		| Uminus(e1) ->
			let (e1_e,e1_type) = e1 in
			let e1_promise = get_expression_promise None global_env e1_e e1_type assignee_scope in
			( fun () ->
				let (e1_e,e1_type) as e1 = (e1_promise ()) in
				Uminus(e1), e1_type
			)

		|CallStub(signature,_) ->
			(fun () ->
				let return_t = get_sig_return_type global_env signature in
				assignee_e,return_t )
		| _ when (not is_et) ->
			(* If we're not dealing with an empty table, the expression and type should not change *)
			noop_promise
		| _ when id_info <> None ->
			(match id_info with
				(*TODO: use assignee_scope instead *)
				Some(id,nesting) -> get_id_based_expr_promise id assignee_scope nesting assignee_e
				| None -> raise (Failure "We shouldn't be here")
			)
		| TableLiteral(tl) ->
			(
			match assigner with
				(* At this point we're out of luck, but since its a truly empty table with no references
				to non-empties, it shouldn't matter *)
				None -> noop_promise
				| Some (assigner) -> get_table_literal_promise assigner tl
			)
		| Call(fdecl,_) -> (fun () -> assignee_e, (fdecl.return_type_promise ()) )
		| _  -> raise (Failure "This type of expression should not yield an empty table.")
	)
	in checked_promise promise
(*  Consider a statement like
a = {}
this should be deferred... we don't know how to construct 'a' until we know it's type

however, once we have:
"a[0] = 3", or "a = {5}" or "b=a; b[3] = 3;"

We can make fully informed assignment because we know the type of a

this promise will return the correct type of expressions of this sort,
assuming the symbol table has been filled out properly
*)
let get_assignment_expression_promise assigner global_env assignee_e assignee_type =
	get_expression_promise (Some assigner) global_env assignee_e assignee_type assigner.assign_scope


(* Update the type of a table variable within a given symbol scope
Need to ensure that table update links are respected *)
let rec update_table_type sym_tab table_id new_type =
	(* update all table links in depth first search style *)
	let rec update_linked_table_types table_id sym_tab new_type visited =
		(*First do the neccesary mutation and update our variable type *)
		update_variable_type sym_tab table_id new_type;
		let already_visited t_id sym_tab visited =
			List.exists (fun (t,s) -> t=t_id && s==sym_tab) visited
		in
		let visited = (table_id,sym_tab)::visited in
		let neighbors = List.map snd (List.filter (fun (t_id,_) -> table_id=t_id) sym_tab.update_table_links) in
		let unvisited_neighbors = List.filter (fun n -> not (already_visited n.id n.assign_scope visited)) neighbors in
		let new_neighbor_types = List.map (fun n-> apply_nesting (new_type,n.nesting)) unvisited_neighbors in
		let folder = (fun visited (neighb,neighb_t) -> update_linked_table_types neighb.id neighb.assign_scope neighb_t visited) in
		List.fold_left folder visited (List.combine unvisited_neighbors new_neighbor_types)

	in
	let (_, table_sym_tab) = find_var_and_scope sym_tab table_id in
	ignore (update_linked_table_types table_id table_sym_tab new_type [])


(*Find all return types of a statement
if a block, recursively search through sub-statements *)
let rec find_all_return_types = function
	Return(promise) -> [(snd (promise () ))]
	| Block(sl,_) -> List.concat (List.map find_all_return_types sl)
	| If(_,s1,s2) ->
		(* For if *)
		(find_all_return_types s1) @ (find_all_return_types s2)
	| While(_, stmt) -> (find_all_return_types stmt)
	| For(_,_,stmt) -> (find_all_return_types stmt)
	| _ -> []

(*Find the return type of a statement
if a block, recursively search through sub-statements and
mache sure return types are consistent*)
let find_return_type func_body =
	let all_return_types = find_all_return_types func_body in
	match all_return_types with
		[] -> Void
		| type_list ->
			if (Util.all_the_same type_list) then
				(List.hd type_list)
			else
				raise (Failure "Inconsistent return types in user defined function.")


(*Find all return types of a statement
if a block, recursively search through sub-statements *)
let rec is_guaranteed_if_return valid = function
	If(_,Return(_),Return(_)) -> true
	| If(_,Return(_),Block(sl,_))  -> is_guaranteed_block_return valid sl
	| If(_,Block (sl,_), Return(_)) -> is_guaranteed_block_return valid sl
	| If(_,Return(_),If(a,b,c)) -> is_guaranteed_if_return valid (If(a,b,c))
	| If(_,If(a,b,c) ,Return(_)) -> is_guaranteed_if_return valid (If(a,b,c))
	| If(_,If (a,b,c),If (d,e,f)) -> is_guaranteed_if_return valid (If(a,b,c)) && is_guaranteed_if_return valid (If(d,e,f))
	| If(_,Block (sl,_),Block (sl',_)) -> is_guaranteed_block_return valid sl && is_guaranteed_block_return valid sl'
	| If(_,If(a,b,c),Block (sl,_)) -> is_guaranteed_if_return valid (If(a,b,c)) && is_guaranteed_block_return valid sl
	| If(_,Block (sl,_),If(a,b,c)) -> is_guaranteed_if_return valid (If(a,b,c)) && is_guaranteed_block_return valid sl
	| If(_,_,_) -> false
and is_guaranteed_block_return valid = function
	[] -> valid
	| hd::tl ->
		match hd with
			Return(_) -> (match tl with
						 [] -> true
						 | _ -> raise (Failure "Unreachable code"))
			| If (a,b,c) ->
				let valid_if = is_guaranteed_if_return valid (If(a,b,c)) in
				if valid_if then (match tl with
								  [] -> true
								| _ -> raise (Failure "Uncreachable code"))
				else is_guaranteed_block_return valid tl
			| Block(sl, _) ->
				let valid_block = (is_guaranteed_block_return valid sl) in
				if valid_block then (match tl with
									 [] -> true
									| _ -> raise (Failure "Uncreachable code"))
				else is_guaranteed_block_return valid tl
			| _ -> is_guaranteed_block_return valid tl


(*
Just as with assignment, we may not know the return type of a function in advance due to empty tables.
Assuming scope is available, this function will give you the proper return type

force_concrete = do we tolerate UnknownReturn types for this promise?
*)
let get_return_type_promise_checked func_body env force_concrete =
	let stmt_list = match func_body with Block(sl, _) -> sl in
	let all_return_type_promises = !(env.returns) in
	let get_return_type () =
		let all_return_types = List.map (fun f -> f () ) all_return_type_promises in
		match all_return_types with
			[] -> Void
			| type_list ->
				let search_list = if force_concrete then
									type_list
								else
									List.filter (fun typ -> typ<>UnknownReturn ) type_list
				in
				if (Util.all_the_same search_list) then
					if (is_guaranteed_block_return false stmt_list) then
						(List.hd search_list)
					else raise (Failure "No valid return statements")
				else
					raise (Failure "Inconsistent return types in user defined function.")
	in get_return_type

let get_return_type_promise func_body env =
	get_return_type_promise_checked func_body env true

let get_return_type func_body env =
	let promise = get_return_type_promise_checked func_body env false in
	(promise ())



let valid_table_index_type = function
	Int | String -> true
	| _ -> false

(*Get the value type of a table type going n_indices levels of nesting
e.g. if table_t = Table(int) and n_indices=1 then return Some int
if table_t = Table(Table(Table(string))) and n_indices=2, return Some Table(string)
if table_t is not a table, return none *)
let rec get_table_access_type table_t n_indices =
	match table_t,n_indices with
		Table(val_type), 1 -> Some val_type
		| Table(val_type), n ->
			(match (get_table_access_type val_type (n-1)) with
				None -> None
				| x -> x)
		| _ -> None


(* Used to tie the types of empty table variables for type inference
when performing assignment or passing arguments into a function
var_id = variable name
var_nesting = nesting of var_id variable relative to assignee.
	For instance, if we have t = s[1][4] then nesting is 2
sym_t = symbol table that var_id resides in
asignee = expression being assigned to var_id
lookup_scope = scope to search for names in assignee
	When doing type inference through function calls, this will not be the same as sym_t,
	whose bodies do not have access to names used in passed in parameters
*)
let create_linkage_if_applicable var_id var_nesting sym_t assignee lookup_scope =

	let other_info = match assignee with
		Id(other_id) ->
			let ((_,other_type), other_scope) = find_var_and_scope lookup_scope other_id in
			Some (other_id,other_type,other_scope, -var_nesting)
		| TableAccess(other_id, indices) ->
			let ((_,outer_type), other_scope) = find_var_and_scope lookup_scope other_id in
			let other_nesting = List.length indices in
			let other_type = (apply_nesting (outer_type,-(other_nesting))) in
			Some (other_id,other_type,other_scope,other_nesting-var_nesting)
		| _ -> None
	in match other_info with
		| Some(other_id,other_type,other_scope,other_nesting) when (is_empty_table_container other_type) ->
			add_mutual_update_table_link var_id sym_t other_id other_scope other_nesting
		| _ -> ()

(* All variables same as above *)
let create_assignment_linkage_if_applicable var_id var_nesting sym_t assignee =
	(*The lookup scope is the same as the variable we're assigning to *)
	create_linkage_if_applicable var_id var_nesting sym_t assignee sym_t

(* add func_decl to the global environment
   IF there is not already a function with the same name
   and same number of parameters (where all the parameters have the same type)
*)
let add_func_to_global_env global_env func_decl =
	(*the unique signature of a function *)
	let func_decl_id fd =
		let param_types = List.map snd fd.params in
		(fd.fname, param_types)
	in
	let new_id = func_decl_id func_decl in
	let existing_ids = List.map func_decl_id global_env.funcs in
	if List.mem new_id existing_ids then
		()
	else
		ignore (global_env.funcs <- func_decl::(global_env.funcs))

let add_func_sig_to_global_env global_env func_signature return_type =
	let rec replace_func_sig = function
		[] -> []
		| (other_sig,_)::tl when other_sig=func_signature ->
			(other_sig,return_type)::(replace_func_sig tl)
		| hd::tl -> hd::(replace_func_sig tl)
	in
	ignore (global_env.func_signatures <- (replace_func_sig global_env.func_signatures))

(*
let func_signature_exists global_env func_signature =
	let same_function_name =
		List.filter (fun func_sig -> ((fst func_sig) = (fst func_signature)))  global_env.func_signatures
	in
	let same_signature_types = List.filter (fun func_sig -> (snd func_sig) = (snd func_signature)) same_function_name
	in
	(match same_signature_types with
		[] -> false
		| _ -> true)

let add_func_signature_to_global_env global_env func_signature =
	ignore (global_env.func_signatures <- (func_signature::(global_env.func_signatures)))
*)


(*
Convert an AST expression to an SAST expression!
*)
let rec check_expr env global_env = function
  Ast.TableLiteral(tl) -> check_table_literal env global_env tl
  | Ast.Literal(l) ->(
    match l with
     Ast.IntLiteral(v) -> Literal(l), Int
     | Ast.StringLiteral(v) -> Literal(l), String
     | Ast.DoubleLiteral(v) -> Literal(l), Double
     | Ast.This -> if env.is_pattern then Literal(l), Table(String) else raise (Failure("This is a reserved word and is not defined in this context."))
     )
  | Ast.Id(v) ->
    let vdecl = try
      find env.scope v
    with Not_found ->
      raise (Failure("undeclared identifier " ^ v)) in
    let (v, typ) = vdecl in
    Id(v), typ
  | Ast.TableAssign(table_id, index_list, e) -> (*TODO: MAKE THIS SHIT MORE LIKE ASSIGN WITH TABLE LINX AND SHIT *)
	let nesting = (List.length index_list) in
	let assignee_env = match e with
		Call(_) -> {env with return_assigner=(Some {id=table_id;assign_scope=env.scope;nesting=nesting}) }
		| _ -> env
	in
	let (assignee_e, assignee_type) as assignee = check_expr env global_env e in
	assert_not_void assignee_type "Can't assign void to a table (or anything for that matter).";
	let indices_sast = check_table_indices env global_env index_list in
	let (_,table_t) = try
      find env.scope table_id
    with Not_found ->
      raise (Failure("undeclared table identifier " ^ table_id)) in
	let assign_info = {id=table_id;assign_scope=env.scope;nesting=nesting} in
	let expr_promise = get_assignment_expression_promise assign_info global_env assignee_e assignee_type in
	(* Most nested part of *)
	let final_table_t = apply_nesting (table_t,-(nesting - 1)) in
	let rec update_empty_table_container_type old_table_t new_type =
		match old_table_t with
			Table(t) -> (Table (update_empty_table_container_type t new_type))
			| EmptyTable -> Table(new_type)
			| t -> t
	in
	(*let new_table_type = (update_empty_table_container_type table_t assignee_type) in*)
	let new_table_type = apply_nesting (assignee_type,nesting) in
	update_table_type env.scope table_id new_table_type;
	(match table_t with
		Table(_) | EmptyTable ->
			let vdecl = match final_table_t with
				EmptyTable -> (* Going from a nested empty table to a different level of nesting, update *)
					TableAssign (table_id, indices_sast,expr_promise),assignee_type
				|Table(val_type) ->
					if (can_assign val_type assignee_type) then (*  val_type=assignee_type then *)
						TableAssign (table_id,indices_sast,expr_promise),assignee_type
					else
						raise (Failure "Trying to assign value to table with incompatible type.")
				| _ -> raise (Failure "check_expr TableAssign: Shouldn't be here. ")
			in
			(if (is_table assignee_type) then
				create_assignment_linkage_if_applicable table_id nesting env.scope assignee_e
			);
			vdecl

		| _ -> raise (Failure "Cannot do table assignment for a non-table"))
  | Ast.Assign(v, assignee) ->
	let assign_info = {id=v;assign_scope=env.scope;nesting=0} in
	let assignee_env = match assignee with
		Call(_) -> {env with return_assigner= (Some assign_info) }
		| _ -> env
	in
    let (assignee_e, assignee_type) as assignee = check_expr assignee_env global_env assignee in
	let expr_promise = get_assignment_expression_promise assign_info global_env assignee_e assignee_type in
	assert_not_void assignee_type "Can't assign void to a variable.";
    let (new_e,new_type) as vdecl =
	try (*Reassigning a variable to a different type is okay because assigment = declaration*)
      let (_,prev_typ) = find env.scope v in (*Add it in the symbol table if its a different type*)
      if (not (can_assign prev_typ assignee_type)) then
		raise (Failure ("identifier type cannot be assigned to previously declared type " ^ v))
      else
		Assign (v, expr_promise), assignee_type
    with Not_found -> (*Declaring/Defining a new variable*)
      let decl = (v, assignee_type) in env.scope.variables <- (decl :: env.scope.variables) ;
      VAssign (v, expr_promise), assignee_type
	in
	(if (is_table new_type) then
		create_assignment_linkage_if_applicable v 0 env.scope assignee_e;
		update_table_type env.scope v new_type);
	vdecl
  | Ast.Binop(e1, op, e2) ->
    let e1 = check_expr env global_env e1
    and e2 = check_expr env global_env e2 in

    let _, t1 = e1
    and _, t2 = e2 in
    (*Operators come in*)
	let return_type = get_binop_type t1 op t2 in
	Binop(e1,op,e2),return_type
  | Ast.Uminus(e) ->
    let (e, typ) = check_expr env global_env e in
    (*Check for int or double*)
    if typ != Int && typ != Double && typ != UnknownReturn then raise (Failure("unary minus operation does not support this type")) ;
    Uminus((e, typ)), typ
  | Ast.Call(v, el) ->
	let func_decl =
		try Some (List.assoc v env.func_decls)
		with Not_found -> None
	in
	(
	match func_decl with
		(* Function declaration found among user functions*)
		Some(func_decl) ->
			let el_typed = List.map (fun e -> (check_expr env global_env e)) el in
			let (arg_exprs,arg_types) = List.split el_typed in
			let func_signature = (v, arg_types) in

			(* See if the function signature eixsts *)
			(
			match get_existing_func_sig global_env func_signature with
				Some(signature, t) -> CallStub (signature, el_typed), t
				| None ->

				(* Add function signature before proceeding *)
				add_initial_func_signature global_env func_signature;

				let typed_args = List.combine func_decl.params arg_types in
				let func_env = {env with scope = {parent = None; variables = typed_args; update_table_links = []};
								returns = ref [];
								} in
				let link_argument (arg,assignee) =
					create_linkage_if_applicable arg 0 func_env.scope assignee env.scope
				in
				(*Make sure that if any empty tables are passed in, proper type inference is done with them *)
				List.iter link_argument (List.combine func_decl.params arg_exprs);
				let func_body = check_stmt func_env global_env (Ast.Block func_decl.body) in
				let return_type_promise = get_return_type_promise func_body func_env in (*func_env.scope func_body in*)
				(*TODO: find some way to link this with assignment as well *)
				let initial_return_type = get_return_type func_body func_env in
				(
				match func_body with
					Block(stmt_list,_) ->
						let func_body_list = stmt_list in
						let arg_type_promises = List.map (get_var_type_promise func_env.scope) func_decl.params in
						let params = List.combine func_decl.params arg_type_promises in
						let func_decl_typed = { fname = v; params = params;
												body = func_body_list;
												return_type_promise = return_type_promise } in
						add_func_to_global_env global_env func_decl_typed;
						add_func_sig_to_global_env global_env func_signature initial_return_type;
						let typed_func_call = Call(func_decl_typed, el_typed), initial_return_type in
						typed_func_call
					| _ -> raise (Failure "Function body must be a Block.")
				)
			)
		(* No user function with this name defined. Check built-ins *)
		| None ->
			let el = List.map (fun e -> (check_expr env global_env e)) el in
			let (built_in_name, built_in_typs, return_typ) = find_built_in v in
			let check = try
				if (List.length el) = (List.length built_in_typs) then
				  List.map2 (fun (_, typ) j -> match typ, j with
					String, BString -> true
					| Table(_), BTable -> true
					| Int, BInt -> true
					| _, BAny -> true
					| _,_ -> raise (Failure("Parameter types do not match for function with name " ^ v))
				  ) el built_in_typs
				else
				  raise (Failure("Length of parameter lists do not match for function with name " ^ v))
			with Not_found -> raise (Failure("Function with name " ^ v ^ " is not defined in any space.")) in
			  BCall(v, el), return_typ
	)
  | Ast.TableAccess(table_id,index_exprs) ->
	(*First, get table variable if it exists *)
	let (_,table_t) = try
      find env.scope table_id
    with Not_found ->
      raise (Failure("undeclared identifier " ^ table_id)) in
	(*next ensure that its a table*)
	if (is_table table_t) then
		let indices_sast = check_table_indices env global_env index_exprs in
		let nesting = (List.length index_exprs) in
		let final_table_t = apply_nesting (table_t,-(nesting)) in
		TableAccess (table_id,indices_sast),final_table_t
	else
		raise (Failure ("Attempting to index non-table"))
	| Ast.ThisAccess(expr) ->
		let ind_expr = check_expr env global_env expr in
		ThisAccess(ind_expr), String
and check_table_indices env global_env index_expr_lst =
	let index_sast = (List.map (check_expr env global_env) index_expr_lst) in
	let index_types = (List.map snd index_sast) in
	if not (List.for_all valid_table_index_type index_types) then
		raise (Failure("All table indices must be string or int expressions"))
	else
		index_sast
and check_table_literal env global_env tl =
	let get_unique_elt lst =
		if (Util.all_the_same lst) && (List.length lst)>0 then
			(List.hd lst)
		else
			raise (Failure("Array literal values must be the same types"))
	in
	let check_keys_exprs env global_env keys exprs =
		let values_sast = (List.map (check_expr env global_env) exprs) in
		let value_type = (get_unique_elt (List.map snd values_sast)) in
		(TableLiteral (List.combine keys values_sast)), (Table value_type)
	in
	match tl with
		Ast.EmptyTable -> (TableLiteral []),EmptyTable
		| Ast.ArrayLiteral(exprs) ->
			let keys = List.map (fun i -> (Ast.IntKey i)) (Util.range 0 (List.length exprs ))  in
			check_keys_exprs env global_env keys exprs
		| Ast.KeyValueLiteral(kv_list) ->
			let keys = (List.map fst kv_list) in
			let exprs = (List.map snd kv_list) in
			check_keys_exprs env global_env keys exprs

and check_stmt env global_env = function
  Ast.Block(sl) ->
    let scopeT = { parent = Some(env.scope); variables = []; update_table_links=[] } in
    let envT = { env with scope = scopeT} in
    let sl = List.map (fun s -> (check_stmt envT global_env s)) sl in envT.scope.variables <- List.rev scopeT.variables;
    Block (sl, envT)
  | Ast.Expr(e) ->
  		(match e with
  		Assign(_) | TableAssign(_) | Call(_) -> Expr(check_expr env global_env e)
  		| _ -> raise (Failure("Expression is not statement in Java")))
  | Ast.Empty -> Empty
  | Ast.Func(f) ->(
    try (*Test to see if user is trying to overwrite built-in function*)
      ignore(find_built_in f.Ast.fname) ;
      raise (Failure("function is overwrites built-in function " ^ f.Ast.fname))
    with Not_found -> (*valid function*)
	  (*We handle func generation elsewhere so can make this a no-op *)
      Block([], env )
    )
  | Ast.Return(e) ->
	let (return_e,return_t) as return_expr = check_expr env global_env e in
	let expr_promise = match env.return_assigner with
		None ->
			get_expression_promise None global_env return_e return_t env.scope
		| Some(assigner) as assgn ->
			create_linkage_if_applicable assigner.id assigner.nesting assigner.assign_scope return_e env.scope;
			get_expression_promise assgn global_env return_e return_t env.scope
	in
	let return_type_promise = fun () -> (snd (expr_promise ())) in
	env.returns:= return_type_promise::!(env.returns);
	Return(expr_promise)
  | Ast.If(e, s1, s2) ->
    let (e, typ) = check_expr env global_env e in
    if typ != Int && typ != Double then raise (Failure("If statement does not support this type")) ;
    If((e, typ), check_stmt env global_env s1, check_stmt env global_env s2)
  | Ast.While(e, s) ->
    let (e, typ) = check_expr env global_env e in
    if typ != Int && typ != Double then raise (Failure("unary minus operation does not support this type")) ;
    While((e, typ), check_stmt env global_env s)
  | Ast.For(key_id, table_id, stmt) ->
	let scopeT = { parent = Some(env.scope); variables = [(key_id,String)]; update_table_links=[] } in
	let envT = { env with scope = scopeT} in
	let stmt = check_stmt envT global_env stmt in
	let (_,table_t) = try
      find env.scope table_id
    with Not_found ->
      raise (Failure("Undeclared table identifier in for statement:" ^ table_id))
	in
	if is_table table_t then
		For(key_id,table_id,stmt)
	else
		raise (Failure("Cannot do for statement on non-table " ^ table_id))
	| Ast.ForThis(key_id, stmt) ->
		let scopeT = { parent = Some(env.scope); variables = [(key_id,String)]; update_table_links=[] } in
		let envT = { env with scope = scopeT} in
		let stmt = check_stmt envT global_env stmt in
		ForThis(key_id,stmt)

let check_pattern env global_env a = check_stmt env global_env a

let get_func_decls_stmt stmt =
	let rec get_func_decls_stmt_unchecked stmt=
		match stmt with
			Ast.Block(stmt_list) -> List.concat (List.map get_func_decls_stmt_unchecked stmt_list)
			| Ast.Func(fdecl) -> [fdecl.fname,fdecl]
			| _ -> []
	in
	let func_decls = get_func_decls_stmt_unchecked stmt in
	(*Make sure that there are no duplicates*)
	let names = List.map fst func_decls in
	if (Util.have_duplicates String.compare names) then
		raise (Failure "Duplicate function names declared!")
	else
		func_decls


let check_program p =
	let func_decls = get_func_decls_stmt p.Ast.begin_stmt in
    let init_scope = {
      parent = None;
      variables = [];
	  update_table_links = []} in
    let init_env = { scope = init_scope;
					return = None;
					func_decls = func_decls;
					is_pattern = false;
					return_assigner = None;
					returns = ref [] } in
    let global_env = { funcs = []; func_signatures = []; finished=false} in
	let (begin_block, env) = match check_stmt init_env global_env p.Ast.begin_stmt with
								Block(begin_block, env) -> begin_block, env
								| _ -> raise (Failure("begin is not a block")) in
  let env = {env with is_pattern = true} in
 	let pattern_actions = List.map (fun (pattern, action) -> pattern, (check_pattern env global_env action)) p.Ast.pattern_actions in
  let env = {env with is_pattern = false} in
  let (end_block, env) = match check_stmt env global_env p.Ast.end_stmt with
								Block(end_block, env) -> end_block, env
								| _ -> raise (Failure("end is not a block")) in
	global_env.finished<-true;
	{concrete_funcs = global_env.funcs;
	begin_stmt = Block(begin_block, env);
	pattern_actions = pattern_actions;
	end_stmt = Block(end_block, env);}
