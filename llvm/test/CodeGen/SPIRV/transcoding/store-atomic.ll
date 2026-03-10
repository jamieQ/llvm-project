; RUN: llc -O0 -mtriple=spirv64-- %s -o - | FileCheck %s
; RUN: %if spirv-tools %{ llc -O0 -mtriple=spirv64-- %s -o - -filetype=obj | spirv-val %}

; RUN: llc -O0 -mtriple=spirv32-- %s -o - | FileCheck %s
; RUN: %if spirv-tools %{ llc -O0 -mtriple=spirv32-- %s -o - -filetype=obj | spirv-val %}

;; Check that 'store atomic' LLVM IR instructions are lowered.
;; NOTE: The current lowering is incorrect: 'store atomic' should produce
;; OpAtomicStore but currently produces OpStore, silently dropping the atomic
;; ordering. This test documents the broken behaviour so it can be fixed.

; CHECK-DAG: %[[#Int32:]] = OpTypeInt 32 0
; CHECK-DAG: %[[#Int64:]] = OpTypeInt 64 0

; CHECK-LABEL: OpFunction %[[#]]
; CHECK:       %[[#ptr:]] = OpFunctionParameter %[[#]]
; CHECK:       %[[#val:]] = OpFunctionParameter %[[#Int32]]
; CHECK:       OpStore %[[#ptr]] %[[#val]] Aligned 4
; CHECK:       OpReturn

define void @store_i32_unordered(ptr addrspace(1) %ptr, i32 %val) {
  store atomic i32 %val, ptr addrspace(1) %ptr unordered, align 4
  ret void
}

; CHECK-LABEL: OpFunction %[[#]]
; CHECK:       %[[#ptr:]] = OpFunctionParameter %[[#]]
; CHECK:       %[[#val:]] = OpFunctionParameter %[[#Int32]]
; CHECK:       OpStore %[[#ptr]] %[[#val]] Aligned 4
; CHECK:       OpReturn

define void @store_i32_monotonic(ptr addrspace(1) %ptr, i32 %val) {
  store atomic i32 %val, ptr addrspace(1) %ptr monotonic, align 4
  ret void
}

; CHECK-LABEL: OpFunction %[[#]]
; CHECK:       %[[#ptr:]] = OpFunctionParameter %[[#]]
; CHECK:       %[[#val:]] = OpFunctionParameter %[[#Int32]]
; CHECK:       OpStore %[[#ptr]] %[[#val]] Aligned 4
; CHECK:       OpReturn

define void @store_i32_release(ptr addrspace(1) %ptr, i32 %val) {
  store atomic i32 %val, ptr addrspace(1) %ptr release, align 4
  ret void
}

; CHECK-LABEL: OpFunction %[[#]]
; CHECK:       %[[#ptr:]] = OpFunctionParameter %[[#]]
; CHECK:       %[[#val:]] = OpFunctionParameter %[[#Int32]]
; CHECK:       OpStore %[[#ptr]] %[[#val]] Aligned 4
; CHECK:       OpReturn

define void @store_i32_seq_cst(ptr addrspace(1) %ptr, i32 %val) {
  store atomic i32 %val, ptr addrspace(1) %ptr seq_cst, align 4
  ret void
}

; CHECK-LABEL: OpFunction %[[#]]
; CHECK:       %[[#ptr:]] = OpFunctionParameter %[[#]]
; CHECK:       %[[#val:]] = OpFunctionParameter %[[#Int64]]
; CHECK:       OpStore %[[#ptr]] %[[#val]] Aligned 8
; CHECK:       OpReturn

define void @store_i64_release(ptr addrspace(1) %ptr, i64 %val) {
  store atomic i64 %val, ptr addrspace(1) %ptr release, align 8
  ret void
}
