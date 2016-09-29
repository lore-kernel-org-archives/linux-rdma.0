From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V1 rdma-core 2/5] ccan: Add CCAN min and max functionality
Date: Thu, 29 Sep 2016 14:10:59 +0300
Message-ID: <1475147462-803-3-git-send-email-yishaih@mellanox.com>
References: <1475147462-803-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1475147462-803-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Add CCAN min/max functionality and use it among the project.

In addition, turn on HAVE_BUILTIN_TYPES_COMPATIBLE_P and fix typing
mistakes for min/max usage.

Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 CMakeLists.txt                    |  1 +
 buildlib/config.h.in              | 10 ++++
 buildlib/publish_headers.cmake    | 18 ++++++--
 ccan/BSD-MIT                      | 17 +++++++
 ccan/CC0                          | 97 +++++++++++++++++++++++++++++++++++++++
 ccan/CMakeLists.txt               |  4 ++
 ccan/build_assert.h               | 40 ++++++++++++++++
 ccan/minmax.h                     | 65 ++++++++++++++++++++++++++
 ibacm/linux/osd.h                 |  5 +-
 ibacm/prov/acmp/src/acmp.c        |  2 +-
 libibverbs/examples/rc_pingpong.c | 12 ++---
 libmlx5/src/mlx5.h                | 15 +-----
 libmlx5/src/qp.c                  |  4 +-
 libmlx5/src/srq.c                 |  2 +-
 libmlx5/src/verbs.c               | 21 +++++----
 librdmacm/src/cma.h               |  5 +-
 librdmacm/src/rsocket.c           | 13 ++++--
 17 files changed, 279 insertions(+), 52 deletions(-)
 create mode 100644 ccan/BSD-MIT
 create mode 100644 ccan/CC0
 create mode 100644 ccan/CMakeLists.txt
 create mode 100644 ccan/build_assert.h
 create mode 100644 ccan/minmax.h

diff --git a/CMakeLists.txt b/CMakeLists.txt
index a829cd4..34a21d1 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -221,6 +221,7 @@ configure_file("${BUILDLIB}/config.h.in" "${BUILD_INCLUDE}/config.h" ESCAPE_QUOT
 
 #-------------------------
 # Sub-directories
+add_subdirectory(ccan)
 # Libraries
 add_subdirectory(libibumad/src)
 add_subdirectory(libibumad/man)
diff --git a/buildlib/config.h.in b/buildlib/config.h.in
index 984d51b..bca737b 100644
--- a/buildlib/config.h.in
+++ b/buildlib/config.h.in
@@ -1,9 +1,17 @@
+#ifndef CONFIG_H_IN
+#define CONFIG_H_IN
+
 // FIXME: Remove this, ibverbs is included so we don't need to detect
 #define HAVE_IBV_DOFORK_RANGE 1
 #define HAVE_IBV_DONTFORK_RANGE 1
 #define HAVE_IBV_REGISTER_DRIVER 1
 #define HAVE_IBV_READ_SYSFS_FILE 1
 
+#define HAVE_STATEMENT_EXPR 1
+#define HAVE_BUILTIN_TYPES_COMPATIBLE_P 1
+#define HAVE_TYPEOF 1
+#define HAVE_ISBLANK 1
+
 // FIXME: Remove this, we provide the netlink kernel headers ibacm needs
 #define HAVE_NETLINK 1
 
@@ -33,3 +41,5 @@
 #elif @NL_KIND@ == 0
 # define NRESOLVE_NEIGH 1
 #endif
+
+#endif
diff --git a/buildlib/publish_headers.cmake b/buildlib/publish_headers.cmake
index ccd2296..c1909d6 100644
--- a/buildlib/publish_headers.cmake
+++ b/buildlib/publish_headers.cmake
@@ -1,10 +1,9 @@
 # COPYRIGHT (c) 2016 Obsidian Research Corporation. See COPYING file
 
-# Copy headers from the source directory to the proper place in the
-# build/include directory
-function(PUBLISH_HEADERS DEST)
+# Same as publish_headers but does not install them during the install phase
+function(publish_internal_headers DEST)
   if(NOT ARGN)
-    message(SEND_ERROR "Error: PUBLISH_HEADERS called without any files")
+    message(SEND_ERROR "Error: publish_internal_headers called without any files")
     return()
   endif()
 
@@ -15,6 +14,17 @@ function(PUBLISH_HEADERS DEST)
     get_filename_component(FIL ${SFIL} NAME)
     execute_process(COMMAND "ln" "-Tsf"
       "${CMAKE_CURRENT_SOURCE_DIR}/${SFIL}" "${DDIR}/${FIL}")
+  endforeach()
+endfunction()
+
+# Copy headers from the source directory to the proper place in the
+# build/include directory. This also installs them into /usr/include/xx during
+# the install phase
+function(publish_headers DEST)
+  publish_internal_headers("${DEST}" ${ARGN})
+
+  foreach(SFIL ${ARGN})
+    get_filename_component(FIL ${SFIL} NAME)
     install(FILES "${SFIL}" DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}/${DEST}/" RENAME "${FIL}")
   endforeach()
 endfunction()
diff --git a/ccan/BSD-MIT b/ccan/BSD-MIT
new file mode 100644
index 0000000..89de354
--- /dev/null
+++ b/ccan/BSD-MIT
@@ -0,0 +1,17 @@
+Permission is hereby granted, free of charge, to any person obtaining a copy
+of this software and associated documentation files (the "Software"), to deal
+in the Software without restriction, including without limitation the rights
+to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
+copies of the Software, and to permit persons to whom the Software is
+furnished to do so, subject to the following conditions:
+
+The above copyright notice and this permission notice shall be included in
+all copies or substantial portions of the Software.
+
+THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
+AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
+LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
+OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
+THE SOFTWARE.
diff --git a/ccan/CC0 b/ccan/CC0
new file mode 100644
index 0000000..57f2f1b
--- /dev/null
+++ b/ccan/CC0
@@ -0,0 +1,97 @@
+Statement of Purpose
+
+The laws of most jurisdictions throughout the world automatically confer
+exclusive Copyright and Related Rights (defined below) upon the creator and
+subsequent owner(s) (each and all, an "owner") of an original work of
+authorship and/or a database (each, a "Work").
+
+Certain owners wish to permanently relinquish those rights to a Work for the
+purpose of contributing to a commons of creative, cultural and scientific works
+("Commons") that the public can reliably and without fear of later claims of
+infringement build upon, modify, incorporate in other works, reuse and
+redistribute as freely as possible in any form whatsoever and for any purposes,
+including without limitation commercial purposes. These owners may contribute
+to the Commons to promote the ideal of a free culture and the further
+production of creative, cultural and scientific works, or to gain reputation or
+greater distribution for their Work in part through the use and efforts of
+others.
+
+For these and/or other purposes and motivations, and without any expectation of
+additional consideration or compensation, the person associating CC0 with a
+Work (the "Affirmer"), to the extent that he or she is an owner of Copyright
+and Related Rights in the Work, voluntarily elects to apply CC0 to the Work and
+publicly distribute the Work under its terms, with knowledge of his or her
+Copyright and Related Rights in the Work and the meaning and intended legal
+effect of CC0 on those rights.
+
+1. Copyright and Related Rights. A Work made available under CC0 may be
+protected by copyright and related or neighboring rights ("Copyright and
+Related Rights"). Copyright and Related Rights include, but are not limited to,
+the following:
+
+    the right to reproduce, adapt, distribute, perform, display, communicate,
+and translate a Work; moral rights retained by the original author(s) and/or
+performer(s); publicity and privacy rights pertaining to a person's image or
+likeness depicted in a Work; rights protecting against unfair competition in
+regards to a Work, subject to the limitations in paragraph 4(a), below; rights
+protecting the extraction, dissemination, use and reuse of data in a Work;
+database rights (such as those arising under Directive 96/9/EC of the European
+Parliament and of the Council of 11 March 1996 on the legal protection of
+databases, and under any national implementation thereof, including any amended
+or successor version of such directive); and other similar, equivalent or
+corresponding rights throughout the world based on applicable law or treaty,
+and any national implementations thereof.
+
+2. Waiver. To the greatest extent permitted by, but not in contravention of,
+applicable law, Affirmer hereby overtly, fully, permanently, irrevocably and
+unconditionally waives, abandons, and surrenders all of Affirmer's Copyright
+and Related Rights and associated claims and causes of action, whether now
+known or unknown (including existing as well as future claims and causes of
+action), in the Work (i) in all territories worldwide, (ii) for the maximum
+duration provided by applicable law or treaty (including future time
+extensions), (iii) in any current or future medium and for any number of
+copies, and (iv) for any purpose whatsoever, including without limitation
+commercial, advertising or promotional purposes (the "Waiver"). Affirmer makes
+the Waiver for the benefit of each member of the public at large and to the
+detriment of Affirmer's heirs and successors, fully intending that such Waiver
+shall not be subject to revocation, rescission, cancellation, termination, or
+any other legal or equitable action to disrupt the quiet enjoyment of the Work
+by the public as contemplated by Affirmer's express Statement of Purpose.
+
+3. Public License Fallback. Should any part of the Waiver for any reason be
+judged legally invalid or ineffective under applicable law, then the Waiver
+shall be preserved to the maximum extent permitted taking into account
+Affirmer's express Statement of Purpose. In addition, to the extent the Waiver
+is so judged Affirmer hereby grants to each affected person a royalty-free, non
+transferable, non sublicensable, non exclusive, irrevocable and unconditional
+license to exercise Affirmer's Copyright and Related Rights in the Work (i) in
+all territories worldwide, (ii) for the maximum duration provided by applicable
+law or treaty (including future time extensions), (iii) in any current or
+future medium and for any number of copies, and (iv) for any purpose
+whatsoever, including without limitation commercial, advertising or promotional
+purposes (the "License"). The License shall be deemed effective as of the date
+CC0 was applied by Affirmer to the Work. Should any part of the License for any
+reason be judged legally invalid or ineffective under applicable law, such
+partial invalidity or ineffectiveness shall not invalidate the remainder of the
+License, and in such case Affirmer hereby affirms that he or she will not (i)
+exercise any of his or her remaining Copyright and Related Rights in the Work
+or (ii) assert any associated claims and causes of action with respect to the
+Work, in either case contrary to Affirmer's express Statement of Purpose.
+
+4. Limitations and Disclaimers.
+
+    No trademark or patent rights held by Affirmer are waived, abandoned,
+surrendered, licensed or otherwise affected by this document.  Affirmer offers
+the Work as-is and makes no representations or warranties of any kind
+concerning the Work, express, implied, statutory or otherwise, including
+without limitation warranties of title, merchantability, fitness for a
+particular purpose, non infringement, or the absence of latent or other
+defects, accuracy, or the present or absence of errors, whether or not
+discoverable, all to the greatest extent permissible under applicable law.
+Affirmer disclaims responsibility for clearing rights of other persons that may
+apply to the Work or any use thereof, including without limitation any person's
+Copyright and Related Rights in the Work. Further, Affirmer disclaims
+responsibility for obtaining any necessary consents, permissions or other
+rights required for any use of the Work.  Affirmer understands and acknowledges
+that Creative Commons is not a party to this document and has no duty or
+obligation with respect to this CC0 or use of the Work.
diff --git a/ccan/CMakeLists.txt b/ccan/CMakeLists.txt
new file mode 100644
index 0000000..dc74d80
--- /dev/null
+++ b/ccan/CMakeLists.txt
@@ -0,0 +1,4 @@
+publish_internal_headers(ccan
+  build_assert.h
+  minmax.h
+  )
diff --git a/ccan/build_assert.h b/ccan/build_assert.h
new file mode 100644
index 0000000..b9ecd84
--- /dev/null
+++ b/ccan/build_assert.h
@@ -0,0 +1,40 @@
+/* CC0 (Public domain) - see LICENSE file for details */
+#ifndef CCAN_BUILD_ASSERT_H
+#define CCAN_BUILD_ASSERT_H
+
+/**
+ * BUILD_ASSERT - assert a build-time dependency.
+ * @cond: the compile-time condition which must be true.
+ *
+ * Your compile will fail if the condition isn't true, or can't be evaluated
+ * by the compiler.  This can only be used within a function.
+ *
+ * Example:
+ *	#include <stddef.h>
+ *	...
+ *	static char *foo_to_char(struct foo *foo)
+ *	{
+ *		// This code needs string to be at start of foo.
+ *		BUILD_ASSERT(offsetof(struct foo, string) == 0);
+ *		return (char *)foo;
+ *	}
+ */
+#define BUILD_ASSERT(cond) \
+	do { (void) sizeof(char [1 - 2*!(cond)]); } while(0)
+
+/**
+ * BUILD_ASSERT_OR_ZERO - assert a build-time dependency, as an expression.
+ * @cond: the compile-time condition which must be true.
+ *
+ * Your compile will fail if the condition isn't true, or can't be evaluated
+ * by the compiler.  This can be used in an expression: its value is "0".
+ *
+ * Example:
+ *	#define foo_to_char(foo)					\
+ *		 ((char *)(foo)						\
+ *		  + BUILD_ASSERT_OR_ZERO(offsetof(struct foo, string) == 0))
+ */
+#define BUILD_ASSERT_OR_ZERO(cond) \
+	(sizeof(char [1 - 2*!(cond)]) - 1)
+
+#endif /* CCAN_BUILD_ASSERT_H */
diff --git a/ccan/minmax.h b/ccan/minmax.h
new file mode 100644
index 0000000..5642f65
--- /dev/null
+++ b/ccan/minmax.h
@@ -0,0 +1,65 @@
+/* CC0 (Public domain) - see LICENSE file for details */
+#ifndef CCAN_MINMAX_H
+#define CCAN_MINMAX_H
+
+#include "config.h"
+
+#include <ccan/build_assert.h>
+
+#if !HAVE_STATEMENT_EXPR || !HAVE_TYPEOF
+/*
+ * Without these, there's no way to avoid unsafe double evaluation of
+ * the arguments
+ */
+#error Sorry, minmax module requires statement expressions and typeof
+#endif
+
+#if HAVE_BUILTIN_TYPES_COMPATIBLE_P
+#define MINMAX_ASSERT_COMPATIBLE(a, b) \
+	BUILD_ASSERT(__builtin_types_compatible_p(a, b))
+#else
+#define MINMAX_ASSERT_COMPATIBLE(a, b) \
+	do { } while (0)
+#endif
+
+#define min(a, b) \
+	({ \
+		typeof(a) _a = (a); \
+		typeof(b) _b = (b); \
+		MINMAX_ASSERT_COMPATIBLE(typeof(_a), typeof(_b)); \
+		_a < _b ? _a : _b; \
+	})
+
+#define max(a, b) \
+	({ \
+		typeof(a) _a = (a); \
+		typeof(b) _b = (b); \
+		MINMAX_ASSERT_COMPATIBLE(typeof(_a), typeof(_b)); \
+		_a > _b ? _a : _b; \
+	})
+
+#define clamp(v, f, c)	(max(min((v), (c)), (f)))
+
+
+#define min_t(t, a, b) \
+	({ \
+		t _ta = (a); \
+		t _tb = (b); \
+		min(_ta, _tb); \
+	})
+#define max_t(t, a, b) \
+	({ \
+		t _ta = (a); \
+		t _tb = (b); \
+		max(_ta, _tb); \
+	})
+
+#define clamp_t(t, v, f, c) \
+	({ \
+		t _tv = (v); \
+		t _tf = (f); \
+		t _tc = (c); \
+		clamp(_tv, _tf, _tc); \
+	})
+
+#endif /* CCAN_MINMAX_H */
diff --git a/ibacm/linux/osd.h b/ibacm/linux/osd.h
index 0113d10..f03980f 100644
--- a/ibacm/linux/osd.h
+++ b/ibacm/linux/osd.h
@@ -46,6 +46,8 @@
 #include <sys/time.h>
 #include <netinet/in.h>
 
+#include <ccan/minmax.h>
+
 #define ACM_CONF_DIR  IBACM_CONFIG_PATH
 #define ACM_ADDR_FILE "ibacm_addr.cfg"
 #define ACM_OPTS_FILE "ibacm_opts.cfg"
@@ -53,9 +55,6 @@
 #define LIB_DESTRUCTOR __attribute__((destructor))
 #define CDECL_FUNC
 
-#define min(a, b) (a < b ? a : b)
-#define max(a, b) (a > b ? a : b)
-
 #if __BYTE_ORDER == __LITTLE_ENDIAN
 #define htonll(x) bswap_64(x)
 #else
diff --git a/ibacm/prov/acmp/src/acmp.c b/ibacm/prov/acmp/src/acmp.c
index a26ed83..75231bf 100644
--- a/ibacm/prov/acmp/src/acmp.c
+++ b/ibacm/prov/acmp/src/acmp.c
@@ -629,7 +629,7 @@ static int acmp_best_mc_index(struct acmp_ep *ep, struct acm_resolve_rec *rec)
 {
 	int i, index;
 
-	for (i = min(rec->gid_cnt, ACM_MAX_GID_COUNT) - 1; i >= 0; i--) {
+	for (i = min_t(int, rec->gid_cnt, ACM_MAX_GID_COUNT) - 1; i >= 0; i--) {
 		index = acmp_mc_index(ep, &rec->gid[i]);
 		if (index >= 0) {
 			return index;
diff --git a/libibverbs/examples/rc_pingpong.c b/libibverbs/examples/rc_pingpong.c
index 9676783..3bbf23d 100644
--- a/libibverbs/examples/rc_pingpong.c
+++ b/libibverbs/examples/rc_pingpong.c
@@ -49,13 +49,7 @@
 
 #include "pingpong.h"
 
-#ifndef max
-#define max(x, y) (((x) > (y)) ? (x) : (y))
-#endif
-
-#ifndef min
-#define min(x, y) (((x) < (y)) ? (x) : (y))
-#endif
+#include <ccan/minmax.h>
 
 enum {
 	PINGPONG_RECV_WRID = 1,
@@ -586,8 +580,8 @@ static int pp_post_send(struct pingpong_context *ctx)
 }
 
 struct ts_params {
-	unsigned int		 comp_recv_max_time_delta;
-	unsigned int		 comp_recv_min_time_delta;
+	uint64_t		 comp_recv_max_time_delta;
+	uint64_t		 comp_recv_min_time_delta;
 	uint64_t		 comp_recv_total_time_delta;
 	uint64_t		 comp_recv_prev_time;
 	int			 last_comp_with_ts;
diff --git a/libmlx5/src/mlx5.h b/libmlx5/src/mlx5.h
index dc90892..80c69a4 100644
--- a/libmlx5/src/mlx5.h
+++ b/libmlx5/src/mlx5.h
@@ -41,6 +41,7 @@
 #include "mlx5-abi.h"
 #include "list.h"
 #include "bitmap.h"
+#include <ccan/minmax.h>
 
 #ifdef __GNUC__
 #define likely(x)	__builtin_expect((x), 1)
@@ -91,20 +92,6 @@
 
 #endif
 
-#ifndef min
-#define min(a, b) \
-	({ typeof(a) _a = (a); \
-	   typeof(b) _b = (b); \
-	   _a < _b ? _a : _b; })
-#endif
-
-#ifndef max
-#define max(a, b) \
-	({ typeof(a) _a = (a); \
-	   typeof(b) _b = (b); \
-	   _a > _b ? _a : _b; })
-#endif
-
 #define HIDDEN		__attribute__((visibility("hidden")))
 
 #ifdef HAVE_FUNC_ATTRIBUTE_ALWAYS_INLINE
diff --git a/libmlx5/src/qp.c b/libmlx5/src/qp.c
index 1e1164c..9363fdd 100644
--- a/libmlx5/src/qp.c
+++ b/libmlx5/src/qp.c
@@ -82,7 +82,7 @@ static int copy_to_scat(struct mlx5_wqe_data_seg *scat, void *buf, int *size,
 		return IBV_WC_SUCCESS;
 
 	for (i = 0; i < max; ++i) {
-		copy = min(*size, ntohl(scat->byte_count));
+		copy = min_t(long, *size, ntohl(scat->byte_count));
 		memcpy((void *)(unsigned long)ntohll(scat->addr), buf, copy);
 		*size -= copy;
 		if (*size == 0)
@@ -364,7 +364,7 @@ static inline int copy_eth_inline_headers(struct ibv_qp *ibqp,
 					  struct mlx5_wqe_eth_seg *eseg,
 					  struct mlx5_sg_copy_ptr *sg_copy_ptr)
 {
-	int inl_hdr_size = MLX5_ETH_L2_INLINE_HEADER_SIZE;
+	uint32_t inl_hdr_size = MLX5_ETH_L2_INLINE_HEADER_SIZE;
 	int inl_hdr_copy_size = 0;
 	int j = 0;
 	FILE *fp = to_mctx(ibqp->context)->dbg_fp;
diff --git a/libmlx5/src/srq.c b/libmlx5/src/srq.c
index dbf53df..24979bf 100644
--- a/libmlx5/src/srq.c
+++ b/libmlx5/src/srq.c
@@ -61,7 +61,7 @@ int mlx5_copy_to_recv_srq(struct mlx5_srq *srq, int idx, void *buf, int size)
 	scat = (struct mlx5_wqe_data_seg *) (next + 1);
 
 	for (i = 0; i < max; ++i) {
-		copy = min(size, ntohl(scat->byte_count));
+		copy = min_t(long, size, ntohl(scat->byte_count));
 		memcpy((void *)(unsigned long)ntohll(scat->addr), buf, copy);
 		size -= copy;
 		if (size <= 0)
diff --git a/libmlx5/src/verbs.c b/libmlx5/src/verbs.c
index 52289ac..e7f4e31 100644
--- a/libmlx5/src/verbs.c
+++ b/libmlx5/src/verbs.c
@@ -728,10 +728,11 @@ int mlx5_destroy_srq(struct ibv_srq *srq)
 
 static int sq_overhead(enum ibv_qp_type	qp_type)
 {
-	int size = 0;
-	size_t mw_bind_size = sizeof(struct mlx5_wqe_umr_ctrl_seg) +
-			      sizeof(struct mlx5_wqe_mkey_context_seg) +
-			      max(sizeof(struct mlx5_wqe_umr_klm_seg), 64);
+	size_t size = 0;
+	size_t mw_bind_size =
+	    sizeof(struct mlx5_wqe_umr_ctrl_seg) +
+	    sizeof(struct mlx5_wqe_mkey_context_seg) +
+	    max_t(size_t, sizeof(struct mlx5_wqe_umr_klm_seg), 64);
 
 	switch (qp_type) {
 	case IBV_QPT_RC:
@@ -813,18 +814,18 @@ static int mlx5_calc_rcv_wqe(struct mlx5_context *ctx,
 			     struct ibv_qp_init_attr_ex *attr,
 			     struct mlx5_qp *qp)
 {
-	int size;
+	uint32_t size;
 	int num_scatter;
 
 	if (attr->srq)
 		return 0;
 
-	num_scatter = max(attr->cap.max_recv_sge, 1);
+	num_scatter = max_t(uint32_t, attr->cap.max_recv_sge, 1);
 	size = sizeof(struct mlx5_wqe_data_seg) * num_scatter;
 	if (qp->wq_sig)
 		size += sizeof(struct mlx5_rwqe_sig);
 
-	if (size < 0 || size > ctx->max_rq_desc_sz)
+	if (size > ctx->max_rq_desc_sz)
 		return -EINVAL;
 
 	size = mlx5_round_up_power_of_two(size);
@@ -885,16 +886,16 @@ static int mlx5_calc_rwq_size(struct mlx5_context *ctx,
 			      struct mlx5_rwq *rwq,
 			      struct ibv_wq_init_attr *attr)
 {
-	int wqe_size;
+	size_t wqe_size;
 	int wq_size;
-	int num_scatter;
+	uint32_t num_scatter;
 	int scat_spc;
 
 	if (!attr->max_wr)
 		return -EINVAL;
 
 	/* TBD: check caps for RQ */
-	num_scatter = max(attr->max_sge, 1);
+	num_scatter = max_t(uint32_t, attr->max_sge, 1);
 	wqe_size = sizeof(struct mlx5_wqe_data_seg) * num_scatter;
 
 	if (rwq->wq_sig)
diff --git a/librdmacm/src/cma.h b/librdmacm/src/cma.h
index e773591..68abe54 100644
--- a/librdmacm/src/cma.h
+++ b/librdmacm/src/cma.h
@@ -47,6 +47,8 @@
 #include <rdma/rdma_cma.h>
 #include <infiniband/ib.h>
 
+#include <ccan/minmax.h>
+
 #ifdef INCLUDE_VALGRIND
 #   include <valgrind/memcheck.h>
 #   ifndef VALGRIND_MAKE_MEM_DEFINED
@@ -68,9 +70,6 @@ static inline uint64_t htonll(uint64_t x) { return x; }
 static inline uint64_t ntohll(uint64_t x) { return x; }
 #endif
 
-#define max(a, b) ((a) > (b) ? a : b)
-#define min(a, b) ((a) < (b) ? a : b)
-
 /*
  * Fast synchronization for low contention locking.
  */
diff --git a/librdmacm/src/rsocket.c b/librdmacm/src/rsocket.c
index 818505f..0204f0d 100644
--- a/librdmacm/src/rsocket.c
+++ b/librdmacm/src/rsocket.c
@@ -3294,10 +3294,10 @@ static void rs_copy_addr(struct sockaddr *dst, struct sockaddr *src, socklen_t *
 	socklen_t size;
 
 	if (src->sa_family == AF_INET) {
-		size = min(*len, sizeof(struct sockaddr_in));
+		size = min_t(socklen_t, *len, sizeof(struct sockaddr_in));
 		*len = sizeof(struct sockaddr_in);
 	} else {
-		size = min(*len, sizeof(struct sockaddr_in6));
+		size = min_t(socklen_t, *len, sizeof(struct sockaddr_in6));
 		*len = sizeof(struct sockaddr_in6);
 	}
 	memcpy(dst, src, size);
@@ -3472,15 +3472,18 @@ int rsetsockopt(int socket, int level, int optname,
 
 		switch (optname) {
 		case RDMA_SQSIZE:
-			rs->sq_size = min((*(uint32_t *) optval), RS_QP_MAX_SIZE);
+			rs->sq_size = min_t(uint32_t, (*(uint32_t *)optval),
+					    RS_QP_MAX_SIZE);
 			ret = 0;
 			break;
 		case RDMA_RQSIZE:
-			rs->rq_size = min((*(uint32_t *) optval), RS_QP_MAX_SIZE);
+			rs->rq_size = min_t(uint32_t, (*(uint32_t *)optval),
+					    RS_QP_MAX_SIZE);
 			ret = 0;
 			break;
 		case RDMA_INLINE:
-			rs->sq_inline = min(*(uint32_t *) optval, RS_QP_MAX_SIZE);
+			rs->sq_inline = min_t(uint32_t, *(uint32_t *)optval,
+					      RS_QP_MAX_SIZE);
 			ret = 0;
 			break;
 		case RDMA_IOMAPSIZE:
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
