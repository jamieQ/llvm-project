; RUN: llc -O0 -mtriple=spirv64-- %s -o - | FileCheck %s
; RUN: %if spirv-tools %{ llc -O0 -mtriple=spirv64-- %s -o - -filetype=obj | spirv-val %}

; RUN: llc -O0 -mtriple=spirv32-- %s -o - | FileCheck %s
; RUN: %if spirv-tools %{ llc -O0 -mtriple=spirv32-- %s -o - -filetype=obj | spirv-val %}

;; Check that 'load atomic' LLVM IR instructions are lowered.
;; NOTE: The current lowering is incorrect: 'load atomic' should produce
;; OpAtomicLoad but currently produces OpLoad, silently dropping the atomic
;; ordering. This test documents the broken behaviour so it can be fixed.

; CHECK-DAG: %[[#Int32:]] = OpTypeInt 32 0
; CHECK-DAG: %[[#Int64:]] = OpTypeInt 64 0

; CHECK-LABEL: OpFunction %[[#]]
; CHECK:       %[[#ptr:]] = OpFunctionParameter %[[#]]
; CHECK:       %[[#]] = OpLoad %[[#Int32]] %[[#ptr]] Aligned 4
; CHECK:       OpReturnValue

define i32 @load_i32_unordered(ptr addrspace(1) %ptr) {
  %val = load atomic i32, ptr addrspace(1) %ptr unordered, align 4
  ret i32 %val
}

; CHECK-LABEL: OpFunction %[[#]]
; CHECK:       %[[#ptr:]] = OpFunctionParameter %[[#]]
; CHECK:       %[[#]] = OpLoad %[[#Int32]] %[[#ptr]] Aligned 4
; CHECK:       OpReturnValue

define i32 @load_i32_monotonic(ptr addrspace(1) %ptr) {
  %val = load atomic i32, ptr addrspace(1) %ptr monotonic, align 4
  ret i32 %val
}

; CHECK-LABEL: OpFunction %[[#]]
; CHECK:       %[[#ptr:]] = OpFunctionParameter %[[#]]
; CHECK:       %[[#]] = OpLoad %[[#Int32]] %[[#ptr]] Aligned 4
; CHECK:       OpReturnValue

define i32 @load_i32_acquire(ptr addrspace(1) %ptr) {
  %val = load atomic i32, ptr addrspace(1) %ptr acquire, align 4
  ret i32 %val
}

; CHECK-LABEL: OpFunction %[[#]]
; CHECK:       %[[#ptr:]] = OpFunctionParameter %[[#]]
; CHECK:       %[[#]] = OpLoad %[[#Int32]] %[[#ptr]] Aligned 4
; CHECK:       OpReturnValue

define i32 @load_i32_seq_cst(ptr addrspace(1) %ptr) {
  %val = load atomic i32, ptr addrspace(1) %ptr seq_cst, align 4
  ret i32 %val
}

; CHECK-LABEL: OpFunction %[[#]]
; CHECK:       %[[#ptr:]] = OpFunctionParameter %[[#]]
; CHECK:       %[[#]] = OpLoad %[[#Int64]] %[[#ptr]] Aligned 8
; CHECK:       OpReturnValue

define i64 @load_i64_acquire(ptr addrspace(1) %ptr) {
  %val = load atomic i64, ptr addrspace(1) %ptr acquire, align 8
  ret i64 %val
}
