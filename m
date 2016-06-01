From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH libmlx5 7/7] Use configuration symbol for always in-line
Date: Wed,  1 Jun 2016 16:48:02 +0300
Message-ID: <1464788882-1876-8-git-send-email-yishaih@mellanox.com>
References: <1464788882-1876-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1464788882-1876-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

In order to be compiler agnostic, we add the required checks to the
autoconf script.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 Makefile.am                 |   1 +
 configure.ac                |   3 +
 m4/ax_gcc_func_attribute.m4 | 223 ++++++++++++++++++++++++++++++++++++++++++++
 src/cq.c                    |  24 ++---
 src/mlx5.h                  |   6 ++
 5 files changed, 245 insertions(+), 12 deletions(-)
 create mode 100644 m4/ax_gcc_func_attribute.m4

diff --git a/Makefile.am b/Makefile.am
index d44a4bc..39ca65d 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -1,4 +1,5 @@
 AM_CFLAGS = -g -Wall -D_GNU_SOURCE
+ACLOCAL_AMFLAGS = -I m4
 
 mlx5_version_script = @MLX5_VERSION_SCRIPT@
 
diff --git a/configure.ac b/configure.ac
index fca0b46..8ece649 100644
--- a/configure.ac
+++ b/configure.ac
@@ -6,6 +6,7 @@ AC_CONFIG_SRCDIR([src/mlx5.h])
 AC_CONFIG_AUX_DIR(config)
 AC_CONFIG_HEADER(config.h)
 AM_INIT_AUTOMAKE([foreign])
+AC_CONFIG_MACRO_DIR([m4])
 m4_ifdef([AM_SILENT_RULES], [AM_SILENT_RULES([yes])])
 
 AC_PROG_LIBTOOL
@@ -84,6 +85,8 @@ AC_CACHE_CHECK(whether ld accepts --version-script, ac_cv_version_script,
         ac_cv_version_script=no
     fi])
 
+AX_GCC_FUNC_ATTRIBUTE([always_inline])
+
 if test $ac_cv_version_script = yes; then
     MLX5_VERSION_SCRIPT='-Wl,--version-script=$(srcdir)/src/mlx5.map'
 else
diff --git a/m4/ax_gcc_func_attribute.m4 b/m4/ax_gcc_func_attribute.m4
new file mode 100644
index 0000000..c788ca9
--- /dev/null
+++ b/m4/ax_gcc_func_attribute.m4
@@ -0,0 +1,223 @@
+# ===========================================================================
+#   http://www.gnu.org/software/autoconf-archive/ax_gcc_func_attribute.html
+# ===========================================================================
+#
+# SYNOPSIS
+#
+#   AX_GCC_FUNC_ATTRIBUTE(ATTRIBUTE)
+#
+# DESCRIPTION
+#
+#   This macro checks if the compiler supports one of GCC's function
+#   attributes; many other compilers also provide function attributes with
+#   the same syntax. Compiler warnings are used to detect supported
+#   attributes as unsupported ones are ignored by default so quieting
+#   warnings when using this macro will yield false positives.
+#
+#   The ATTRIBUTE parameter holds the name of the attribute to be checked.
+#
+#   If ATTRIBUTE is supported define HAVE_FUNC_ATTRIBUTE_<ATTRIBUTE>.
+#
+#   The macro caches its result in the ax_cv_have_func_attribute_<attribute>
+#   variable.
+#
+#   The macro currently supports the following function attributes:
+#
+#    alias
+#    aligned
+#    alloc_size
+#    always_inline
+#    artificial
+#    cold
+#    const
+#    constructor
+#    constructor_priority for constructor attribute with priority
+#    deprecated
+#    destructor
+#    dllexport
+#    dllimport
+#    error
+#    externally_visible
+#    flatten
+#    format
+#    format_arg
+#    gnu_inline
+#    hot
+#    ifunc
+#    leaf
+#    malloc
+#    noclone
+#    noinline
+#    nonnull
+#    noreturn
+#    nothrow
+#    optimize
+#    pure
+#    unused
+#    used
+#    visibility
+#    warning
+#    warn_unused_result
+#    weak
+#    weakref
+#
+#   Unsuppored function attributes will be tested with a prototype returning
+#   an int and not accepting any arguments and the result of the check might
+#   be wrong or meaningless so use with care.
+#
+# LICENSE
+#
+#   Copyright (c) 2013 Gabriele Svelto <gabriele.svelto-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
+#
+#   Copying and distribution of this file, with or without modification, are
+#   permitted in any medium without royalty provided the copyright notice
+#   and this notice are preserved.  This file is offered as-is, without any
+#   warranty.
+
+#serial 3
+
+AC_DEFUN([AX_GCC_FUNC_ATTRIBUTE], [
+    AS_VAR_PUSHDEF([ac_var], [ax_cv_have_func_attribute_$1])
+
+    AC_CACHE_CHECK([for __attribute__(($1))], [ac_var], [
+        AC_LINK_IFELSE([AC_LANG_PROGRAM([
+            m4_case([$1],
+                [alias], [
+                    int foo( void ) { return 0; }
+                    int bar( void ) __attribute__(($1("foo")));
+                ],
+                [aligned], [
+                    int foo( void ) __attribute__(($1(32)));
+                ],
+                [alloc_size], [
+                    void *foo(int a) __attribute__(($1(1)));
+                ],
+                [always_inline], [
+                    inline __attribute__(($1)) int foo( void ) { return 0; }
+                ],
+                [artificial], [
+                    inline __attribute__(($1)) int foo( void ) { return 0; }
+                ],
+                [cold], [
+                    int foo( void ) __attribute__(($1));
+                ],
+                [const], [
+                    int foo( void ) __attribute__(($1));
+                ],
+                [constructor_priority], [
+                    int foo( void ) __attribute__((__constructor__(65535/2)));
+                ],
+                [constructor], [
+                    int foo( void ) __attribute__(($1));
+                ],
+                [deprecated], [
+                    int foo( void ) __attribute__(($1("")));
+                ],
+                [destructor], [
+                    int foo( void ) __attribute__(($1));
+                ],
+                [dllexport], [
+                    __attribute__(($1)) int foo( void ) { return 0; }
+                ],
+                [dllimport], [
+                    int foo( void ) __attribute__(($1));
+                ],
+                [error], [
+                    int foo( void ) __attribute__(($1("")));
+                ],
+                [externally_visible], [
+                    int foo( void ) __attribute__(($1));
+                ],
+                [flatten], [
+                    int foo( void ) __attribute__(($1));
+                ],
+                [format], [
+                    int foo(const char *p, ...) __attribute__(($1(printf, 1, 2)));
+                ],
+                [format_arg], [
+                    char *foo(const char *p) __attribute__(($1(1)));
+                ],
+                [gnu_inline], [
+                    inline __attribute__(($1)) int foo( void ) { return 0; }
+                ],
+                [hot], [
+                    int foo( void ) __attribute__(($1));
+                ],
+                [ifunc], [
+                    int my_foo( void ) { return 0; }
+                    static int (*resolve_foo(void))(void) { return my_foo; }
+                    int foo( void ) __attribute__(($1("resolve_foo")));
+                ],
+                [leaf], [
+                    __attribute__(($1)) int foo( void ) { return 0; }
+                ],
+                [malloc], [
+                    void *foo( void ) __attribute__(($1));
+                ],
+                [noclone], [
+                    int foo( void ) __attribute__(($1));
+                ],
+                [noinline], [
+                    __attribute__(($1)) int foo( void ) { return 0; }
+                ],
+                [nonnull], [
+                    int foo(char *p) __attribute__(($1(1)));
+                ],
+                [noreturn], [
+                    void foo( void ) __attribute__(($1));
+                ],
+                [nothrow], [
+                    int foo( void ) __attribute__(($1));
+                ],
+                [optimize], [
+                    __attribute__(($1(3))) int foo( void ) { return 0; }
+                ],
+                [pure], [
+                    int foo( void ) __attribute__(($1));
+                ],
+                [unused], [
+                    int foo( void ) __attribute__(($1));
+                ],
+                [used], [
+                    int foo( void ) __attribute__(($1));
+                ],
+                [visibility], [
+                    int foo_def( void ) __attribute__(($1("default")));
+                    int foo_hid( void ) __attribute__(($1("hidden")));
+                    int foo_int( void ) __attribute__(($1("internal")));
+                    int foo_pro( void ) __attribute__(($1("protected")));
+                ],
+                [warning], [
+                    int foo( void ) __attribute__(($1("")));
+                ],
+                [warn_unused_result], [
+                    int foo( void ) __attribute__(($1));
+                ],
+                [weak], [
+                    int foo( void ) __attribute__(($1));
+                ],
+                [weakref], [
+                    static int foo( void ) { return 0; }
+                    static int bar( void ) __attribute__(($1("foo")));
+                ],
+                [
+                 m4_warn([syntax], [Unsupported attribute $1, the test may fail])
+                 int foo( void ) __attribute__(($1));
+                ]
+            )], [])
+            ],
+            dnl GCC doesn't exit with an error if an unknown attribute is
+            dnl provided but only outputs a warning, so accept the attribute
+            dnl only if no warning were issued.
+            [AS_IF([test -s conftest.err],
+                [AS_VAR_SET([ac_var], [no])],
+                [AS_VAR_SET([ac_var], [yes])])],
+            [AS_VAR_SET([ac_var], [no])])
+    ])
+
+    AS_IF([test yes = AS_VAR_GET([ac_var])],
+        [AC_DEFINE_UNQUOTED(AS_TR_CPP(HAVE_FUNC_ATTRIBUTE_$1), 1,
+            [Define to 1 if the system has the `$1' function attribute])], [])
+
+    AS_VAR_POPDEF([ac_var])
+])
diff --git a/src/cq.c b/src/cq.c
index de91f07..be66cfd 100644
--- a/src/cq.c
+++ b/src/cq.c
@@ -436,7 +436,7 @@ static void mlx5_get_cycles(uint64_t *cycles)
 static inline struct mlx5_qp *get_req_context(struct mlx5_context *mctx,
 					      struct mlx5_resource **cur_rsc,
 					      uint32_t rsn, int cqe_ver)
-					      __attribute__((always_inline));
+					      ALWAYS_INLINE;
 static inline struct mlx5_qp *get_req_context(struct mlx5_context *mctx,
 					      struct mlx5_resource **cur_rsc,
 					      uint32_t rsn, int cqe_ver)
@@ -452,7 +452,7 @@ static inline int get_resp_ctx_v1(struct mlx5_context *mctx,
 				  struct mlx5_resource **cur_rsc,
 				  struct mlx5_srq **cur_srq,
 				  uint32_t uidx, uint8_t *is_srq)
-				  __attribute__((always_inline));
+				  ALWAYS_INLINE;
 static inline int get_resp_ctx_v1(struct mlx5_context *mctx,
 				  struct mlx5_resource **cur_rsc,
 				  struct mlx5_srq **cur_srq,
@@ -488,7 +488,7 @@ static inline int get_resp_ctx_v1(struct mlx5_context *mctx,
 static inline int get_qp_ctx(struct mlx5_context *mctx,
 			     struct mlx5_resource **cur_rsc,
 			     uint32_t qpn)
-			       __attribute__((always_inline));
+			     ALWAYS_INLINE;
 static inline int get_qp_ctx(struct mlx5_context *mctx,
 			     struct mlx5_resource **cur_rsc,
 			     uint32_t qpn)
@@ -510,7 +510,7 @@ static inline int get_qp_ctx(struct mlx5_context *mctx,
 static inline int get_srq_ctx(struct mlx5_context *mctx,
 			      struct mlx5_srq **cur_srq,
 			      uint32_t srqn_uidx)
-			      __attribute__((always_inline));
+			      ALWAYS_INLINE;
 static inline int get_srq_ctx(struct mlx5_context *mctx,
 			      struct mlx5_srq **cur_srq,
 			      uint32_t srqn)
@@ -553,7 +553,7 @@ static inline int get_cur_rsc(struct mlx5_context *mctx,
 static inline int mlx5_get_next_cqe(struct mlx5_cq *cq,
 				    struct mlx5_cqe64 **pcqe64,
 				    void **pcqe)
-				    __attribute__((always_inline));
+				    ALWAYS_INLINE;
 static inline int mlx5_get_next_cqe(struct mlx5_cq *cq,
 				    struct mlx5_cqe64 **pcqe64,
 				    void **pcqe)
@@ -602,7 +602,7 @@ static inline int mlx5_parse_cqe(struct mlx5_cq *cq,
 				 struct mlx5_srq **cur_srq,
 				 struct ibv_wc *wc,
 				 int cqe_ver, int lazy)
-				 __attribute__((always_inline));
+				 ALWAYS_INLINE;
 static inline int mlx5_parse_cqe(struct mlx5_cq *cq,
 				 struct mlx5_cqe64 *cqe64,
 				 void *cqe,
@@ -754,7 +754,7 @@ static inline int mlx5_parse_cqe(struct mlx5_cq *cq,
 static inline int mlx5_parse_lazy_cqe(struct mlx5_cq *cq,
 				      struct mlx5_cqe64 *cqe64,
 				      void *cqe, int cqe_ver)
-				      __attribute__((always_inline));
+				      ALWAYS_INLINE;
 static inline int mlx5_parse_lazy_cqe(struct mlx5_cq *cq,
 				      struct mlx5_cqe64 *cqe64,
 				      void *cqe, int cqe_ver)
@@ -766,7 +766,7 @@ static inline int mlx5_poll_one(struct mlx5_cq *cq,
 				struct mlx5_resource **cur_rsc,
 				struct mlx5_srq **cur_srq,
 				struct ibv_wc *wc, int cqe_ver)
-				__attribute__((always_inline));
+				ALWAYS_INLINE;
 static inline int mlx5_poll_one(struct mlx5_cq *cq,
 				struct mlx5_resource **cur_rsc,
 				struct mlx5_srq **cur_srq,
@@ -785,7 +785,7 @@ static inline int mlx5_poll_one(struct mlx5_cq *cq,
 
 static inline int poll_cq(struct ibv_cq *ibcq, int ne,
 		      struct ibv_wc *wc, int cqe_ver)
-		      __attribute__((always_inline));
+		      ALWAYS_INLINE;
 static inline int poll_cq(struct ibv_cq *ibcq, int ne,
 		      struct ibv_wc *wc, int cqe_ver)
 {
@@ -848,7 +848,7 @@ enum  polling_mode {
 
 static inline void mlx5_end_poll(struct ibv_cq_ex *ibcq,
 				 int lock, enum polling_mode stall)
-				 __attribute__((always_inline));
+				 ALWAYS_INLINE;
 static inline void mlx5_end_poll(struct ibv_cq_ex *ibcq,
 				 int lock, enum polling_mode stall)
 {
@@ -884,7 +884,7 @@ static inline void mlx5_end_poll(struct ibv_cq_ex *ibcq,
 
 static inline int mlx5_start_poll(struct ibv_cq_ex *ibcq, struct ibv_poll_cq_attr *attr,
 				  int lock, enum polling_mode stall, int cqe_version)
-				  __attribute__((always_inline));
+				  ALWAYS_INLINE;
 static inline int mlx5_start_poll(struct ibv_cq_ex *ibcq, struct ibv_poll_cq_attr *attr,
 				  int lock, enum polling_mode stall, int cqe_version)
 {
@@ -952,7 +952,7 @@ static inline int mlx5_start_poll(struct ibv_cq_ex *ibcq, struct ibv_poll_cq_att
 
 static inline int mlx5_next_poll(struct ibv_cq_ex *ibcq,
 				 enum polling_mode stall, int cqe_version)
-				 __attribute__((always_inline));
+				 ALWAYS_INLINE;
 static inline int mlx5_next_poll(struct ibv_cq_ex *ibcq,
 				 enum polling_mode stall,
 				 int cqe_version)
diff --git a/src/mlx5.h b/src/mlx5.h
index 78357d3..124c8fe 100644
--- a/src/mlx5.h
+++ b/src/mlx5.h
@@ -107,6 +107,12 @@
 
 #define HIDDEN		__attribute__((visibility("hidden")))
 
+#ifdef HAVE_FUNC_ATTRIBUTE_ALWAYS_INLINE
+#define ALWAYS_INLINE __attribute__((always_inline))
+#else
+#define ALWAYS_INLINE
+#endif
+
 #define PFX		"mlx5: "
 
 
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
