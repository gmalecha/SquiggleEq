

Require Import list.
Require Import varInterface.
Require Import UsefulTypes.
Require Import Coq.Lists.List.
Import ListNotations.

Section PeanoVarInstance.
Context (VarCl :Type) {Hd : Deq VarCl}.

Notation VType := ((nat * VarCl)%type).

(*Instance DeqVType : Deq VType.
  unfold VType. eauto with typeclass_instances.
*)
(** insertion of a nat in a list of variables in an ordered way *)

Require Import Omega.
Require Import Coq.Sorting.Sorting.
Print VarType.

Variable defClass : VarCl.

Global Instance freshVarsPeano : FreshVars VType VarCl :=
fun (n:nat) (oc : option VarCl) (avoid original : list VType) =>
let c := match oc with | Some x => x | None => defClass end in
let maxn := maxl (map fst avoid) in
List.map (fun x => (x,c)) (seq (S maxn) n).

Global Instance varClassPeano : VarClass VType VarCl := snd.


Require Import LibTactics.
Require Import tactics.

Global Instance VarTypePeano : VarType VType VarCl.
  apply Build_VarType.
  intros.
  subst lf. unfold freshVarsPeano.
  autorewrite with list.
  split;[split|].
- apply NoDup_map_inv with (f:=fst). setoid_rewrite map_map.
  simpl. rewrite map_id. apply seq_NoDup.
- setoid_rewrite map_length. rewrite seq_length.
  split; [| refl].
  intros ? Hin. unfold freshVars in Hin.
  rewrite in_map_iff in Hin.
  setoid_rewrite in_seq in Hin.
  exrepnd. inverts Hin1.
  intros Hinc.
  apply (lin_lift _ _ fst) in Hinc.
  simpl in Hinc.
  apply maxl_prop in Hinc.
  omega.
- introv ? Hin. subst. unfold freshVars in Hin.
  apply in_map_iff in Hin.
  exrepnd. cpx.
Defined.

End PeanoVarInstance.
