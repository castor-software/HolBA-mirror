structure bslSyntax :> bslSyntax =
struct

  open HolKernel Parse boolLib bossLib;
  open Abbrev;

  local

  open bir_envSyntax;
  open bir_expSyntax;
  open bir_exp_immSyntax;
  open bir_exp_memSyntax;
  open bir_immSyntax;
  open bir_programSyntax;
  open bir_typing_expSyntax;
  open bir_valuesSyntax;

  val ERR = Feedback.mk_HOL_ERR "bslSyntax";
  val wrap_exn = Feedback.wrap_exn "bslSyntax";

  fun curry2 f = (fn a => fn b => f (a, b));
  fun curry3 f = (fn a => fn b => fn c => f (a, b, c));
  fun curry4 f = (fn a => fn b => fn c => fn d => f (a, b, c, d));

  fun uncurry2 f = (fn (a, b) => f a b);
  fun uncurry3 f = (fn (a, b, c) => f a b c);
  fun uncurry4 f = (fn (a, b, c, d) => f a b c d);

  fun app1th2 f a = (fn b => f a b)
  fun app2th2 f b = (fn a => f a b)
  fun app1th3 f a = (fn b => fn c => f a b c)
  fun app2th3 f b = (fn a => fn c => f a b c)
  fun app3th3 f c = (fn a => fn b => f a b c)
  fun app1th4 f a = (fn b => fn c => fn d => f a b c d)
  fun app2th4 f b = (fn a => fn c => fn d => f a b c d)
  fun app3th4 f c = (fn a => fn b => fn d => f a b c d)
  fun app4th4 f d = (fn a => fn b => fn c => f a b c d)

  in

  (****************************************************************************)
  (* Environment                                                              *)
  (****************************************************************************)

  (* Variales (BVar: bir_var_t) *)
  fun bvar name ty_tm = mk_BVar_string (name, ty_tm)
    handle e => raise wrap_exn "bvar" e

  fun bvarimm len_int name = mk_BVar_string (name, gen_mk_BType_Imm len_int)
    handle e => raise wrap_exn "bvarimm" e
  val bvarimm8 = bvarimm 8
  val bvarimm16 = bvarimm 16
  val bvarimm32 = bvarimm 32
  val bvarimm64 = bvarimm 64
  val bvarimm128 = bvarimm 128

  fun bvarmem (lty_int, rty_int) name =
    mk_BVar_string (name, mk_BType_Mem
      (bir_immtype_t_of_size lty_int, bir_immtype_t_of_size rty_int))
    handle e => raise wrap_exn "bvarmem" e
  val bvarmem8_8 = bvarmem (8, 8)
  val bvarmem16_8 = bvarmem (16, 8)
  val bvarmem32_8 = bvarmem (32, 8)
  val bvarmem64_8 = bvarmem (64, 8)
  val bvarmem128_8 = bvarmem (128, 8)
  val bvarmem8_16 = bvarmem (8, 16)
  val bvarmem16_16 = bvarmem (16, 16)
  val bvarmem32_16 = bvarmem (32, 16)
  val bvarmem64_16 = bvarmem (64, 16)
  val bvarmem128_16 = bvarmem (128, 16)
  val bvarmem8_32 = bvarmem (8, 32)
  val bvarmem16_32 = bvarmem (16, 32)
  val bvarmem32_32 = bvarmem (32, 32)
  val bvarmem64_32 = bvarmem (64, 32)
  val bvarmem128_32 = bvarmem (128, 32)
  val bvarmem8_64 = bvarmem (8, 64)
  val bvarmem16_64 = bvarmem (16, 64)
  val bvarmem32_64 = bvarmem (32, 64)
  val bvarmem64_64 = bvarmem (64, 64)
  val bvarmem128_64 = bvarmem (128, 64)
  val bvarmem8_128 = bvarmem (8, 128)
  val bvarmem16_128 = bvarmem (16, 128)
  val bvarmem32_128 = bvarmem (32, 128)
  val bvarmem64_128 = bvarmem (64, 128)
  val bvarmem128_128 = bvarmem (128, 128)

  (****************************************************************************)
  (* Program                                                                  *)
  (****************************************************************************)

  (* Labels (:bir_label_t) *)
  val blabel_str = mk_BL_Label_string
    handle e => raise wrap_exn "blabel_str" e
  val blabel_addrimm = mk_BL_Address
    handle e => raise wrap_exn "blabel_addrimm" e
  val blabel_addr = (blabel_addrimm o gen_mk_Imm)
    handle e => raise wrap_exn "blabel_addr" e
  val blabel_addrii = curry2 (mk_BL_Address o uncurry2 mk_Imm_of_int)
    handle e => raise wrap_exn "blabel_addrii" e
  val blabel_addr8 = blabel_addrii 8
  val blabel_addr16 = blabel_addrii 16
  val blabel_addr32 = blabel_addrii 32
  val blabel_addr64 = blabel_addrii 64
  val blabel_addr128 = blabel_addrii 128

  (* Label expressions (:bir_label_exp_t) *)
  val belabel = mk_BLE_Label
    handle e => raise wrap_exn "belabel" e
  val belabel_expr = mk_BLE_Exp
    handle e => raise wrap_exn "belabel_expr" e

  val belabel_str = belabel o blabel_str
  val belabel_addr = belabel o blabel_addr
  val belabel_addr8 = belabel o blabel_addr8
  val belabel_addr16 = belabel o blabel_addr16
  val belabel_addr32 = belabel o blabel_addr32
  val belabel_addr64 = belabel o blabel_addr64
  val belabel_addr128 = belabel o blabel_addr128
  fun belabel_addrii a b = belabel (blabel_addrii a b)
  val belabel_addrimm = belabel o blabel_addrimm

  (* Basic statements (:bir_stmt_basic_t) *)
  val bdeclare = mk_BStmt_Declare
    handle e => raise wrap_exn "bdeclare" e
  val bassign = mk_BStmt_Assign
    handle e => raise wrap_exn "bassign" e
  val bassert = mk_BStmt_Assert
    handle e => raise wrap_exn "bassert" e
  val bassume = mk_BStmt_Assume
    handle e => raise wrap_exn "bassume" e

  (* End statements (:bir_stmt_end_t) *)
  val bjmp = mk_BStmt_Jmp
    handle e => raise wrap_exn "bjmp" e
  val bcjmp = curry3 mk_BStmt_CJmp
    handle e => raise wrap_exn "bcjmp" e
  val bhalt = mk_BStmt_Halt
    handle e => raise wrap_exn "bhalt" e

  (* Statements (:bir_stmt_t) *)
  val bstmtb = mk_BStmtB
    handle e => raise wrap_exn "bstmtb" e
  val bstmte = mk_BStmtE
    handle e => raise wrap_exn "bstmte" e

  (* Blocks (:bir_block_t) *)
  fun bblock observe_ty (lbl_tm, stmts_list, end_stmt_tm) =
    mk_bir_block_list (observe_ty, lbl_tm, stmts_list, end_stmt_tm)
    handle e => raise wrap_exn "bblock" e
  fun bblocks observe_ty blocks =
    mk_BirProgram_list (observe_ty, (List.map (bblock observe_ty) blocks))
    handle e => raise wrap_exn "bblocks" e

  (* Programs (:bir_program_t) *)
  val bprog = mk_BirProgram
    handle e => raise wrap_exn "bprog" e
  fun bprog_list obs_ty bl_list =
    (curry2 mk_BirProgram_list)
      obs_ty (List.map (uncurry3 ((curry4 mk_bir_block_list) obs_ty)) bl_list)
    handle e => raise wrap_exn "bprog_list" e

  (****************************************************************************)
  (* Expressions: bir_exp_t                                                   *)
  (****************************************************************************)

  (* Constants (BExp_Const: bir_exp_t) *)
  fun bconstimm bir_imm = mk_BExp_Const bir_imm
    handle e => raise wrap_exn "bconstimm" e
  val bconst = (bconstimm o gen_mk_Imm)
    handle e => raise wrap_exn "bconst" e
  val bconstii = curry2 (mk_BExp_Const o uncurry2 mk_Imm_of_int)
    handle e => raise wrap_exn "bconstii" e
  val bconst8 = bconstii 8
  val bconst16 = bconstii 16
  val bconst32 = bconstii 32
  val bconst64 = bconstii 64
  val bconst128 = bconstii 128

  (* Den (BExp_Den: bir_exp_t) *)
  val bden = mk_BExp_Den
    handle e => raise wrap_exn "bden" e

  (* Casts (BExp_Cast: bir_exp_t) *)
  (* Nothing for the moment *)

  (* Unary expressions (BExp_UnaryExp: bir_exp_t) *)
  val bunexp = curry2 mk_BExp_UnaryExp
    handle e => raise wrap_exn "bunexp" e
  val bchsign = bunexp BIExp_ChangeSign_tm
  val bnot = bunexp BIExp_Not_tm
  val bclz = bunexp BIExp_CLZ_tm
  val bcls = bunexp BIExp_CLS_tm

  (* Binary expressions (BExp_BinExp: bir_exp_t) *)
  fun bbinexp bop (lhs, rhs) = mk_BExp_BinExp (bop, lhs, rhs)
    handle e => raise wrap_exn "bbinexp" e
  val band = bbinexp BIExp_And_tm
  val bor = bbinexp BIExp_Or_tm
  val bxor = bbinexp BIExp_Xor_tm
  val bplus = bbinexp BIExp_Plus_tm
  val bminus = bbinexp BIExp_Minus_tm
  val bmult = bbinexp BIExp_Mult_tm
  val bdiv = bbinexp BIExp_Div_tm
  val bsdiv = bbinexp BIExp_SignedDiv_tm
  val bmod = bbinexp BIExp_Mod_tm
  val bsmod = bbinexp BIExp_SignedMod_tm
  val blshift = bbinexp BIExp_LeftShift_tm
  val brshift = bbinexp BIExp_RightShift_tm
  val bsrshift = bbinexp BIExp_SignedRightShift_tm

  local
    fun bbinexpl_ bop [] = raise ERR "bbinexpl" "need at least 1 term"
      | bbinexpl_ bop (fst::tms) =
        List.foldl (fn (lhs, rhs) => bbinexp bop (rhs, lhs)) fst tms
  in
    val bbinexpl = bbinexpl_
      handle e => raise wrap_exn "bbinexpl" e
  end
  val bandl = bbinexpl BIExp_And_tm
  val borl = bbinexpl BIExp_Or_tm
  val bxorl = bbinexpl BIExp_Xor_tm
  val bplusl = bbinexpl BIExp_Plus_tm
  val bminusl = bbinexpl BIExp_Minus_tm
  val bmultl = bbinexpl BIExp_Mult_tm
  val bdivl = bbinexpl BIExp_Div_tm
  val bsdivl = bbinexpl BIExp_SignedDiv_tm
  val bmodl = bbinexpl BIExp_Mod_tm
  val bsmodl = bbinexpl BIExp_SignedMod_tm
  val blshiftl = bbinexpl BIExp_LeftShift_tm
  val brshiftl = bbinexpl BIExp_RightShift_tm
  val bsrshiftl = bbinexpl BIExp_SignedRightShift_tm

  (* Binary predicates (BExp_BinPred: bir_exp_t) *)
  fun bbinpred bpred (lhs, rhs) = mk_BExp_BinPred (bpred, lhs, rhs)
    handle e => raise wrap_exn "bbinpred" e
  val beq = bbinpred BIExp_Equal_tm
  val bneq = bbinpred BIExp_NotEqual_tm
  val blt = bbinpred BIExp_LessThan_tm
  val bslt = bbinpred BIExp_SignedLessThan_tm
  val ble = bbinpred BIExp_LessOrEqual_tm
  val bsle = bbinpred BIExp_SignedLessOrEqual_tm

  local
    fun bbinpredl_ bpred [] = raise ERR "bbinpredl" "need at least 1 term"
      | bbinpredl_ bpred (fst::tms) =
        List.foldl (fn (lhs, rhs) => bbinexp bpred (rhs, lhs)) fst tms
  in
    val bbinpredl = bbinpredl_
      handle e => raise wrap_exn "bbinpredl" e
  end
  val beql = bbinpredl BIExp_Equal_tm
  val bneql = bbinpredl BIExp_NotEqual_tm
  val bltl = bbinpredl BIExp_LessThan_tm
  val bsltl = bbinpredl BIExp_SignedLessThan_tm
  val blel = bbinpredl BIExp_LessOrEqual_tm
  val bslel = bbinpredl BIExp_SignedLessOrEqual_tm

  (* Memory equality (BExp_MemEq: bir_exp_t) *)
  val bmemeq = curry2 mk_BExp_MemEq
    handle e => raise wrap_exn "bmemeq" e

  (* Conditionals (BExp_IfThenElse: bir_exp_t) *)
  val bite = curry3 mk_BExp_IfThenElse
    handle e => raise wrap_exn "bite" e
  fun bcases [] = raise ERR "bcases" "need at least 1 term"
    | bcases [(cond_tm, tm)] = tm
    | bcases ((cond_tm, tm)::tl) = bite cond_tm tm (bcases tl)
    handle e => raise wrap_exn "bcases" e

  (* Memory loads (BExp_Load: bir_exp_t) *)
  val bload = curry4 mk_BExp_Load
    handle e => raise wrap_exn "bload" e
  fun bloadi a b c d = bload a b c (gen_mk_BType_Imm d)
    handle e => raise wrap_exn "bloadi" e
  val bload8 = app4th4 bloadi 8
  val bload16 = app4th4 bloadi 16
  val bload32 = app4th4 bloadi 32
  val bload64 = app4th4 bloadi 64
  val bload128 = app4th4 bloadi 128

  val bload_le = app3th4 bload BEnd_LittleEndian_tm
  val bloadi_le = app3th3 bloadi BEnd_LittleEndian_tm
  val bload8_le = app3th3 bload8 BEnd_LittleEndian_tm
  val bload16_le = app3th3 bload16 BEnd_LittleEndian_tm
  val bload32_le = app3th3 bload32 BEnd_LittleEndian_tm
  val bload64_le = app3th3 bload64 BEnd_LittleEndian_tm
  val bload128_le = app3th3 bload128 BEnd_LittleEndian_tm

  val bload_be = app3th4 bload BEnd_BigEndian_tm
  val bloadi_be = app3th3 bloadi BEnd_BigEndian_tm
  val bload8_be = app3th3 bload8 BEnd_BigEndian_tm
  val bload16_be = app3th3 bload16 BEnd_BigEndian_tm
  val bload32_be = app3th3 bload32 BEnd_BigEndian_tm
  val bload64_be = app3th3 bload64 BEnd_BigEndian_tm
  val bload128_be = app3th3 bload128 BEnd_BigEndian_tm

  val bload_ne = app3th4 bload BEnd_NoEndian_tm
  val bloadi_ne = app3th3 bloadi BEnd_NoEndian_tm
  val bload8_ne = app3th3 bload8 BEnd_NoEndian_tm

  (* Memory stores (BExp_Store: bir_exp_t) *)
  val bstore = curry4 mk_BExp_Store
    handle e => raise wrap_exn "bstore" e
  val bstore_le = app3th4 bstore BEnd_LittleEndian_tm
  val bstore_be = app3th4 bstore BEnd_BigEndian_tm
  val bstore_ne = app3th4 bstore BEnd_NoEndian_tm

  (****************************************************************************)
  (* Term <-> BSL                                                             *)
  (****************************************************************************)

  (* Program definition (:thm) *)
  local
    fun define name tm = Define [QUOTE (name ^ " = "), ANTIQUOTE tm]
  in

    (*fun bdefprog name blocks_tm = define name (bprog blocks_tm)*)
      (*handle e => raise wrap_exn "bdefprog" e*)
    fun bdefprog_list ty name block_list = define name (bprog_list ty block_list)
      handle e => raise wrap_exn "bdefprog_list" e

  end (* local: Program definition *)

  end (* local *)

end (* struct *)
