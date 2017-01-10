From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 3/4] Provide cmake support to enable C11 stdatomic.h
Date: Tue, 10 Jan 2017 12:02:10 -0700
Message-ID: <1484074931-3847-4-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1484074931-3847-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1484074931-3847-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Turn on C11 support in the compiler, for newer compilers this brings
in the necessary semantics. This flag started working as of gcc 4.7
(released 2012)

gcc 4.7 and 4.8 do not have complete C11 support and requires compat for
stdatomic.h, use a ported FreeBSD header (courtesy of
https://gist.github.com/nhatminhle/5181506) to provide enough stdatomic.h
support on some older compilers.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 CMakeLists.txt                     |   7 +
 buildlib/RDMA_EnableCStd.cmake     |  11 +-
 buildlib/fixup-include/stdatomic.h | 369 +++++++++++++++++++++++++++++++++++++
 3 files changed, 382 insertions(+), 5 deletions(-)
 create mode 100644 buildlib/fixup-include/stdatomic.h

diff --git a/CMakeLists.txt b/CMakeLists.txt
index a8cc76d4a9f3c8..d06cb71d3edf03 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -203,6 +203,10 @@ CHECK_C_SOURCE_COMPILES("
   HAVE_FUNC_ATTRIBUTE_ALWAYS_INLINE
   FAIL_REGEX "warning")
 
+# Provide a shim if C11 stdatomic.h is not supported.
+CHECK_INCLUDE_FILE("stdatomic.h" HAVE_STDATOMIC)
+RDMA_DoFixup("${HAVE_STDATOMIC}" "stdatomic.h")
+
 # Enable development support features
 # Prune unneeded shared libraries during linking
 RDMA_AddOptLDFlag(CMAKE_EXE_LINKER_FLAGS SUPPORTS_AS_NEEDED "-Wl,--as-needed")
@@ -409,6 +413,9 @@ endif()
 if (NOT HAVE_COHERENT_DMA)
   message(STATUS " Architecture NOT able to do coherent DMA (check libibverbs/arch.h) some providers disabled!")
 endif()
+if (NOT HAVE_STDATOMIC)
+  message(STATUS " C11 stdatomic.h NOT available (old compiler)")
+endif()
 if (NOT HAVE_VALGRIND_MEMCHECK)
   message(STATUS " Valgrind memcheck.h NOT enabled")
 endif()
diff --git a/buildlib/RDMA_EnableCStd.cmake b/buildlib/RDMA_EnableCStd.cmake
index bcf3ea525c7307..abe613cb01486e 100644
--- a/buildlib/RDMA_EnableCStd.cmake
+++ b/buildlib/RDMA_EnableCStd.cmake
@@ -33,16 +33,17 @@ function(RDMA_AddOptCFlag TO_VAR CACHE_VAR FLAG)
   endif()
 endfunction()
 
-# Enable the minimum required gnu99 standard in the compiler.
+# Enable the minimum required gnu11 standard in the compiler
+# This was introduced in GCC 4.7
 function(RDMA_EnableCStd)
   if (CMAKE_VERSION VERSION_LESS "3.1")
     # Check for support of the usual flag
-    CHECK_C_COMPILER_FLAG("-std=gnu99" SUPPORTS_GNU99)
-    if (SUPPORTS_GNU99)
-      SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -std=gnu99" PARENT_SCOPE)
+    CHECK_C_COMPILER_FLAG("-std=gnu11" SUPPORTS_GNU11)
+    if (SUPPORTS_GNU11)
+      SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -std=gnu11" PARENT_SCOPE)
     endif()
   else()
     # Newer cmake can do this internally
-    set(CMAKE_C_STANDARD 99 PARENT_SCOPE)
+    set(CMAKE_C_STANDARD 11 PARENT_SCOPE)
   endif()
 endfunction()
diff --git a/buildlib/fixup-include/stdatomic.h b/buildlib/fixup-include/stdatomic.h
new file mode 100644
index 00000000000000..6af810f7fb3a26
--- /dev/null
+++ b/buildlib/fixup-include/stdatomic.h
@@ -0,0 +1,369 @@
+/*
+ * An implementation of C11 stdatomic.h directly borrowed from FreeBSD
+ * (original copyright follows), with minor modifications for
+ * portability to other systems. Works for recent Clang (that
+ * implement the feature c_atomic) and GCC 4.7+; includes
+ * compatibility for GCC below 4.7 but I wouldn't recommend it.
+ *
+ * Caveats and limitations:
+ * - Only the ``_Atomic parentheses'' notation is implemented, while
+ *   the ``_Atomic space'' one is not.
+ * - _Atomic types must be typedef'ed, or programs using them will
+ *   not type check correctly (incompatible anonymous structure
+ *   types).
+ * - Non-scalar _Atomic types would require runtime support for
+ *   runtime locking, which, as far as I know, is not currently
+ *   available on any system.
+ */
+
+/*-
+ * Copyright (c) 2011 Ed Schouten <ed-HZy0K5TPuP5AfugRpC6u6w@public.gmane.org>
+ *                    David Chisnall <theraven-HZy0K5TPuP5AfugRpC6u6w@public.gmane.org>
+ * All rights reserved.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ * 1. Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ * 2. Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in the
+ *    documentation and/or other materials provided with the distribution.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
+ * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
+ * ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
+ * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
+ * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
+ * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
+ * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
+ * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
+ * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
+ * SUCH DAMAGE.
+ *
+ * $FreeBSD: src/include/stdatomic.h,v 1.10.2.2 2012/05/30 19:21:54 theraven Exp $
+ */
+
+#ifndef _STDATOMIC_H_
+#define	_STDATOMIC_H_
+
+#include <stddef.h>
+#include <stdint.h>
+
+#if !defined(__has_feature)
+#define __has_feature(x) 0
+#endif
+#if !defined(__has_builtin)
+#define __has_builtin(x) 0
+#endif
+#if !defined(__GNUC_PREREQ__)
+#if defined(__GNUC__) && defined(__GNUC_MINOR__)
+#define __GNUC_PREREQ__(maj, min)					\
+	((__GNUC__ << 16) + __GNUC_MINOR__ >= ((maj) << 16) + (min))
+#else
+#define __GNUC_PREREQ__(maj, min) 0
+#endif
+#endif
+
+#if !defined(__CLANG_ATOMICS) && !defined(__GNUC_ATOMICS)
+#if __has_feature(c_atomic)
+#define	__CLANG_ATOMICS
+#elif __GNUC_PREREQ__(4, 7)
+#define	__GNUC_ATOMICS
+#elif !defined(__GNUC__)
+#error "stdatomic.h does not support your compiler"
+#endif
+#endif
+
+#if !defined(__CLANG_ATOMICS)
+#define	_Atomic(T)			struct { volatile __typeof__(T) __val; }
+#endif
+
+/*
+ * 7.17.2 Initialization.
+ */
+
+#if defined(__CLANG_ATOMICS)
+#define	ATOMIC_VAR_INIT(value)		(value)
+#define	atomic_init(obj, value)		__c11_atomic_init(obj, value)
+#else
+#define	ATOMIC_VAR_INIT(value)		{ .__val = (value) }
+#define	atomic_init(obj, value) do {					\
+	(obj)->__val = (value);						\
+} while (0)
+#endif
+
+/*
+ * Clang and recent GCC both provide predefined macros for the memory
+ * orderings.  If we are using a compiler that doesn't define them, use the
+ * clang values - these will be ignored in the fallback path.
+ */
+
+#ifndef __ATOMIC_RELAXED
+#define __ATOMIC_RELAXED		0
+#endif
+#ifndef __ATOMIC_CONSUME
+#define __ATOMIC_CONSUME		1
+#endif
+#ifndef __ATOMIC_ACQUIRE
+#define __ATOMIC_ACQUIRE		2
+#endif
+#ifndef __ATOMIC_RELEASE
+#define __ATOMIC_RELEASE		3
+#endif
+#ifndef __ATOMIC_ACQ_REL
+#define __ATOMIC_ACQ_REL		4
+#endif
+#ifndef __ATOMIC_SEQ_CST
+#define __ATOMIC_SEQ_CST		5
+#endif
+
+/*
+ * 7.17.3 Order and consistency.
+ *
+ * The memory_order_* constants that denote the barrier behaviour of the
+ * atomic operations.
+ */
+
+enum memory_order {
+	memory_order_relaxed = __ATOMIC_RELAXED,
+	memory_order_consume = __ATOMIC_CONSUME,
+	memory_order_acquire = __ATOMIC_ACQUIRE,
+	memory_order_release = __ATOMIC_RELEASE,
+	memory_order_acq_rel = __ATOMIC_ACQ_REL,
+	memory_order_seq_cst = __ATOMIC_SEQ_CST
+};
+
+typedef enum memory_order memory_order;
+
+/*
+ * 7.17.4 Fences.
+ */
+
+#ifdef __CLANG_ATOMICS
+#define	atomic_thread_fence(order)	__c11_atomic_thread_fence(order)
+#define	atomic_signal_fence(order)	__c11_atomic_signal_fence(order)
+#elif defined(__GNUC_ATOMICS)
+#define	atomic_thread_fence(order)	__atomic_thread_fence(order)
+#define	atomic_signal_fence(order)	__atomic_signal_fence(order)
+#else
+#define	atomic_thread_fence(order)	__sync_synchronize()
+#define	atomic_signal_fence(order)	__asm volatile ("" : : : "memory")
+#endif
+
+/*
+ * 7.17.5 Lock-free property.
+ */
+
+#if defined(__CLANG_ATOMICS)
+#define	atomic_is_lock_free(obj) \
+	__c11_atomic_is_lock_free(sizeof(obj))
+#elif defined(__GNUC_ATOMICS)
+#define	atomic_is_lock_free(obj) \
+	__atomic_is_lock_free(sizeof((obj)->__val))
+#else
+#define	atomic_is_lock_free(obj) \
+	(sizeof((obj)->__val) <= sizeof(void *))
+#endif
+
+/*
+ * 7.17.6 Atomic integer types.
+ */
+
+typedef _Atomic(_Bool)			atomic_bool;
+typedef _Atomic(char)			atomic_char;
+typedef _Atomic(signed char)		atomic_schar;
+typedef _Atomic(unsigned char)		atomic_uchar;
+typedef _Atomic(short)			atomic_short;
+typedef _Atomic(unsigned short)		atomic_ushort;
+typedef _Atomic(int)			atomic_int;
+typedef _Atomic(unsigned int)		atomic_uint;
+typedef _Atomic(long)			atomic_long;
+typedef _Atomic(unsigned long)		atomic_ulong;
+typedef _Atomic(long long)		atomic_llong;
+typedef _Atomic(unsigned long long)	atomic_ullong;
+#if 0
+typedef _Atomic(char16_t)		atomic_char16_t;
+typedef _Atomic(char32_t)		atomic_char32_t;
+#endif
+typedef _Atomic(wchar_t)		atomic_wchar_t;
+typedef _Atomic(int_least8_t)		atomic_int_least8_t;
+typedef _Atomic(uint_least8_t)		atomic_uint_least8_t;
+typedef _Atomic(int_least16_t)		atomic_int_least16_t;
+typedef _Atomic(uint_least16_t)		atomic_uint_least16_t;
+typedef _Atomic(int_least32_t)		atomic_int_least32_t;
+typedef _Atomic(uint_least32_t)		atomic_uint_least32_t;
+typedef _Atomic(int_least64_t)		atomic_int_least64_t;
+typedef _Atomic(uint_least64_t)		atomic_uint_least64_t;
+typedef _Atomic(int_fast8_t)		atomic_int_fast8_t;
+typedef _Atomic(uint_fast8_t)		atomic_uint_fast8_t;
+typedef _Atomic(int_fast16_t)		atomic_int_fast16_t;
+typedef _Atomic(uint_fast16_t)		atomic_uint_fast16_t;
+typedef _Atomic(int_fast32_t)		atomic_int_fast32_t;
+typedef _Atomic(uint_fast32_t)		atomic_uint_fast32_t;
+typedef _Atomic(int_fast64_t)		atomic_int_fast64_t;
+typedef _Atomic(uint_fast64_t)		atomic_uint_fast64_t;
+typedef _Atomic(intptr_t)		atomic_intptr_t;
+typedef _Atomic(uintptr_t)		atomic_uintptr_t;
+typedef _Atomic(size_t)			atomic_size_t;
+typedef _Atomic(ptrdiff_t)		atomic_ptrdiff_t;
+typedef _Atomic(intmax_t)		atomic_intmax_t;
+typedef _Atomic(uintmax_t)		atomic_uintmax_t;
+
+/*
+ * 7.17.7 Operations on atomic types.
+ */
+
+/*
+ * Compiler-specific operations.
+ */
+
+#if defined(__CLANG_ATOMICS)
+#define	atomic_compare_exchange_strong_explicit(object, expected,	\
+    desired, success, failure)						\
+	__c11_atomic_compare_exchange_strong(object, expected, desired,	\
+	    success, failure)
+#define	atomic_compare_exchange_weak_explicit(object, expected,		\
+    desired, success, failure)						\
+	__c11_atomic_compare_exchange_weak(object, expected, desired,	\
+	    success, failure)
+#define	atomic_exchange_explicit(object, desired, order)		\
+	__c11_atomic_exchange(object, desired, order)
+#define	atomic_fetch_add_explicit(object, operand, order)		\
+	__c11_atomic_fetch_add(object, operand, order)
+#define	atomic_fetch_and_explicit(object, operand, order)		\
+	__c11_atomic_fetch_and(object, operand, order)
+#define	atomic_fetch_or_explicit(object, operand, order)		\
+	__c11_atomic_fetch_or(object, operand, order)
+#define	atomic_fetch_sub_explicit(object, operand, order)		\
+	__c11_atomic_fetch_sub(object, operand, order)
+#define	atomic_fetch_xor_explicit(object, operand, order)		\
+	__c11_atomic_fetch_xor(object, operand, order)
+#define	atomic_load_explicit(object, order)				\
+	__c11_atomic_load(object, order)
+#define	atomic_store_explicit(object, desired, order)			\
+	__c11_atomic_store(object, desired, order)
+#elif defined(__GNUC_ATOMICS)
+#define	atomic_compare_exchange_strong_explicit(object, expected,	\
+    desired, success, failure)						\
+	__atomic_compare_exchange_n(&(object)->__val, expected,		\
+	    desired, 0, success, failure)
+#define	atomic_compare_exchange_weak_explicit(object, expected,		\
+    desired, success, failure)						\
+	__atomic_compare_exchange_n(&(object)->__val, expected,		\
+	    desired, 1, success, failure)
+#define	atomic_exchange_explicit(object, desired, order)		\
+	__atomic_exchange_n(&(object)->__val, desired, order)
+#define	atomic_fetch_add_explicit(object, operand, order)		\
+	__atomic_fetch_add(&(object)->__val, operand, order)
+#define	atomic_fetch_and_explicit(object, operand, order)		\
+	__atomic_fetch_and(&(object)->__val, operand, order)
+#define	atomic_fetch_or_explicit(object, operand, order)		\
+	__atomic_fetch_or(&(object)->__val, operand, order)
+#define	atomic_fetch_sub_explicit(object, operand, order)		\
+	__atomic_fetch_sub(&(object)->__val, operand, order)
+#define	atomic_fetch_xor_explicit(object, operand, order)		\
+	__atomic_fetch_xor(&(object)->__val, operand, order)
+#define	atomic_load_explicit(object, order)				\
+	__atomic_load_n(&(object)->__val, order)
+#define	atomic_store_explicit(object, desired, order)			\
+	__atomic_store_n(&(object)->__val, desired, order)
+#else
+#define	atomic_compare_exchange_strong_explicit(object, expected,	\
+    desired, success, failure) ({					\
+	__typeof__((object)->__val) __v;				\
+	_Bool __r;							\
+	__v = __sync_val_compare_and_swap(&(object)->__val,		\
+	    *(expected), desired);					\
+	__r = *(expected) == __v;					\
+	*(expected) = __v;						\
+	__r;								\
+})
+
+#define	atomic_compare_exchange_weak_explicit(object, expected,		\
+    desired, success, failure)						\
+	atomic_compare_exchange_strong_explicit(object, expected,	\
+		desired, success, failure)
+#if __has_builtin(__sync_swap)
+/* Clang provides a full-barrier atomic exchange - use it if available. */
+#define atomic_exchange_explicit(object, desired, order)		\
+	__sync_swap(&(object)->__val, desired)
+#else
+/*
+ * __sync_lock_test_and_set() is only an acquire barrier in theory (although in
+ * practice it is usually a full barrier) so we need an explicit barrier after
+ * it.
+ */
+#define	atomic_exchange_explicit(object, desired, order) ({		\
+	__typeof__((object)->__val) __v;				\
+	__v = __sync_lock_test_and_set(&(object)->__val, desired);	\
+	__sync_synchronize();						\
+	__v;								\
+})
+#endif
+#define	atomic_fetch_add_explicit(object, operand, order)		\
+	__sync_fetch_and_add(&(object)->__val, operand)
+#define	atomic_fetch_and_explicit(object, operand, order)		\
+	__sync_fetch_and_and(&(object)->__val, operand)
+#define	atomic_fetch_or_explicit(object, operand, order)		\
+	__sync_fetch_and_or(&(object)->__val, operand)
+#define	atomic_fetch_sub_explicit(object, operand, order)		\
+	__sync_fetch_and_sub(&(object)->__val, operand)
+#define	atomic_fetch_xor_explicit(object, operand, order)		\
+	__sync_fetch_and_xor(&(object)->__val, operand)
+#define	atomic_load_explicit(object, order)				\
+	__sync_fetch_and_add(&(object)->__val, 0)
+#define	atomic_store_explicit(object, desired, order) do {		\
+	__sync_synchronize();						\
+	(object)->__val = (desired);					\
+	__sync_synchronize();						\
+} while (0)
+#endif
+
+/*
+ * Convenience functions.
+ */
+
+#define	atomic_compare_exchange_strong(object, expected, desired)	\
+	atomic_compare_exchange_strong_explicit(object, expected,	\
+	    desired, memory_order_seq_cst, memory_order_seq_cst)
+#define	atomic_compare_exchange_weak(object, expected, desired)		\
+	atomic_compare_exchange_weak_explicit(object, expected,		\
+	    desired, memory_order_seq_cst, memory_order_seq_cst)
+#define	atomic_exchange(object, desired)				\
+	atomic_exchange_explicit(object, desired, memory_order_seq_cst)
+#define	atomic_fetch_add(object, operand)				\
+	atomic_fetch_add_explicit(object, operand, memory_order_seq_cst)
+#define	atomic_fetch_and(object, operand)				\
+	atomic_fetch_and_explicit(object, operand, memory_order_seq_cst)
+#define	atomic_fetch_or(object, operand)				\
+	atomic_fetch_or_explicit(object, operand, memory_order_seq_cst)
+#define	atomic_fetch_sub(object, operand)				\
+	atomic_fetch_sub_explicit(object, operand, memory_order_seq_cst)
+#define	atomic_fetch_xor(object, operand)				\
+	atomic_fetch_xor_explicit(object, operand, memory_order_seq_cst)
+#define	atomic_load(object)						\
+	atomic_load_explicit(object, memory_order_seq_cst)
+#define	atomic_store(object, desired)					\
+	atomic_store_explicit(object, desired, memory_order_seq_cst)
+
+/*
+ * 7.17.8 Atomic flag type and operations.
+ */
+
+typedef atomic_bool			atomic_flag;
+
+#define	ATOMIC_FLAG_INIT		ATOMIC_VAR_INIT(0)
+
+#define	atomic_flag_clear_explicit(object, order)			\
+	atomic_store_explicit(object, 0, order)
+#define	atomic_flag_test_and_set_explicit(object, order)		\
+	atomic_compare_exchange_strong_explicit(object, 0, 1, order, order)
+
+#define	atomic_flag_clear(object)					\
+	atomic_flag_clear_explicit(object, memory_order_seq_cst)
+#define	atomic_flag_test_and_set(object)				\
+	atomic_flag_test_and_set_explicit(object, memory_order_seq_cst)
+
+#endif /* !_STDATOMIC_H_ */
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
