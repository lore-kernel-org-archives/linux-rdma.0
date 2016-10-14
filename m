From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 2/2] Enable -Wmissing-prototypes
Date: Thu, 13 Oct 2016 22:10:11 -0600
Message-ID: <1476418211-6277-2-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1476418211-6277-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1476418211-6277-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: hch-jcswGhMUV9g@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is useful to detect functions which probably should be static.

One wrinkle is the use of .symver macros in verbs. These require
non-static definitions that cannot have the same name as the public
prototype. Locally disable the warning to deal with that.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 CMakeLists.txt                     | 1 +
 buildlib/FindLDSymVer.cmake        | 2 ++
 ibacm/src/acm_util.h               | 2 ++
 ibacm/src/acme.c                   | 7 ++-----
 ibacm/src/parse.c                  | 1 +
 libibverbs/compat-1_0.c            | 2 ++
 libibverbs/device.c                | 2 ++
 libibverbs/examples/devinfo.c      | 4 ++--
 libibverbs/examples/rc_pingpong.c  | 4 ++--
 libibverbs/examples/srq_pingpong.c | 2 +-
 libibverbs/examples/uc_pingpong.c  | 2 +-
 libibverbs/examples/ud_pingpong.c  | 2 +-
 libibverbs/verbs.c                 | 2 ++
 13 files changed, 21 insertions(+), 12 deletions(-)

diff --git a/CMakeLists.txt b/CMakeLists.txt
index 1fb634c43991..59533411006b 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -110,6 +110,7 @@ RDMA_EnableCStd()
 # FIXME: I wonder how many of the signed compares are bugs?
 RDMA_AddOptCFlag(CMAKE_C_FLAGS HAVE_C_WARNINGS
   "-Wall -Wextra -Wno-sign-compare -Wno-unused-parameter")
+RDMA_AddOptCFlag(CMAKE_C_FLAGS HAVE_C_WMISSING_PROTOTYPES "-Wmissing-prototypes")
 
 # At some point around 5.4 gcc fixed missing-field-initializers to ignore this
 # common idiom we use extensively. Since this is a useful warning for
diff --git a/buildlib/FindLDSymVer.cmake b/buildlib/FindLDSymVer.cmake
index 7169b2c4db68..9d3c12dcef46 100644
--- a/buildlib/FindLDSymVer.cmake
+++ b/buildlib/FindLDSymVer.cmake
@@ -27,8 +27,10 @@ endif()
 
 # And matching source, this also checks that .symver asm works
 check_c_source_compiles("
+void ibv_get_device_list_1(void);
 void ibv_get_device_list_1(void){}
 asm(\".symver ibv_get_device_list_1, ibv_get_device_list@IBVERBS_1.1\");
+void ibv_get_device_list_0(void);
 void ibv_get_device_list_0(void){}
 asm(\".symver ibv_get_device_list_0, ibv_get_device_list@@IBVERBS_1.0\");
 
diff --git a/ibacm/src/acm_util.h b/ibacm/src/acm_util.h
index 2bcf28086c7b..5243f8a7e750 100644
--- a/ibacm/src/acm_util.h
+++ b/ibacm/src/acm_util.h
@@ -53,4 +53,6 @@ typedef void (*acm_if_iter_cb)(char *ifname, union ibv_gid *gid, uint16_t pkey,
 				char *ip_str, void *ctx);
 int acm_if_iter_sys(acm_if_iter_cb cb, void *ctx);
 
+char **parse(char *args, int *count);
+
 #endif /* ACM_IF_H */
diff --git a/ibacm/src/acme.c b/ibacm/src/acme.c
index 2bce0da4ec8a..6b5b2ecb7f8a 100644
--- a/ibacm/src/acme.c
+++ b/ibacm/src/acme.c
@@ -74,9 +74,6 @@ int verbose;
 struct ibv_context **verbs;
 int dev_cnt;
 
-extern int gen_addr_ip(FILE *f);
-extern char **parse(char *args, int *count);
-
 #define VPRINT(format, ...) do { if (verbose) printf(format, ## __VA_ARGS__ ); } while (0)
 
 static void show_usage(char *program)
@@ -958,7 +955,7 @@ static int query_svcs(void)
 	return ret;
 }
 
-char *opt_arg(int argc, char **argv)
+static char *opt_arg(int argc, char **argv)
 {
 	if (optarg)
 		return optarg;
@@ -969,7 +966,7 @@ char *opt_arg(int argc, char **argv)
 	return NULL;
 }
 
-void parse_perf_arg(char *arg)
+static void parse_perf_arg(char *arg)
 {
 	if (!strnicmp("col", arg, 3)) {
 		perf_query = PERF_QUERY_COL;
diff --git a/ibacm/src/parse.c b/ibacm/src/parse.c
index 83ce8439edac..52e66ab814e3 100644
--- a/ibacm/src/parse.c
+++ b/ibacm/src/parse.c
@@ -30,6 +30,7 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
+#include "acm_util.h"
 
 static char *expand(char *basename, char *args, int *str_cnt, int *str_size)
 {
diff --git a/libibverbs/compat-1_0.c b/libibverbs/compat-1_0.c
index b286fd73eb01..af852f9ff481 100644
--- a/libibverbs/compat-1_0.c
+++ b/libibverbs/compat-1_0.c
@@ -40,6 +40,8 @@
 
 #include "ibverbs.h"
 
+#pragma GCC diagnostic ignored "-Wmissing-prototypes"
+
 struct ibv_pd_1_0 {
 	struct ibv_context_1_0 *context;
 	uint32_t		handle;
diff --git a/libibverbs/device.c b/libibverbs/device.c
index b4864e3e384b..8950f2a3d711 100644
--- a/libibverbs/device.c
+++ b/libibverbs/device.c
@@ -47,6 +47,8 @@
 
 #include "ibverbs.h"
 
+#pragma GCC diagnostic ignored "-Wmissing-prototypes"
+
 static pthread_once_t device_list_once = PTHREAD_ONCE_INIT;
 static int num_devices;
 static struct ibv_device **device_list;
diff --git a/libibverbs/examples/devinfo.c b/libibverbs/examples/devinfo.c
index 5fd1affa455d..78e92b95c3ca 100644
--- a/libibverbs/examples/devinfo.c
+++ b/libibverbs/examples/devinfo.c
@@ -283,7 +283,7 @@ static void print_device_cap_flags(uint32_t dev_cap_flags)
 		       dev_cap_flags & unknown_flags);
 }
 
-void print_odp_trans_caps(uint32_t trans)
+static void print_odp_trans_caps(uint32_t trans)
 {
 	uint32_t unknown_transport_caps = ~(IBV_ODP_SUPPORT_SEND |
 					    IBV_ODP_SUPPORT_RECV |
@@ -310,7 +310,7 @@ void print_odp_trans_caps(uint32_t trans)
 	}
 }
 
-void print_odp_caps(const struct ibv_odp_caps *caps)
+static void print_odp_caps(const struct ibv_odp_caps *caps)
 {
 	uint64_t unknown_general_caps = ~(IBV_ODP_SUPPORT);
 
diff --git a/libibverbs/examples/rc_pingpong.c b/libibverbs/examples/rc_pingpong.c
index aca7bac4491b..7c70457183d9 100644
--- a/libibverbs/examples/rc_pingpong.c
+++ b/libibverbs/examples/rc_pingpong.c
@@ -78,7 +78,7 @@ struct pingpong_context {
 	uint64_t		 completion_timestamp_mask;
 };
 
-struct ibv_cq *pp_cq(struct pingpong_context *ctx)
+static struct ibv_cq *pp_cq(struct pingpong_context *ctx)
 {
 	return use_ts ? ibv_cq_ex_to_cq(ctx->cq_s.cq_ex) :
 		ctx->cq_s.cq;
@@ -496,7 +496,7 @@ clean_ctx:
 	return NULL;
 }
 
-int pp_close_ctx(struct pingpong_context *ctx)
+static int pp_close_ctx(struct pingpong_context *ctx)
 {
 	if (ibv_destroy_qp(ctx->qp)) {
 		fprintf(stderr, "Couldn't destroy QP\n");
diff --git a/libibverbs/examples/srq_pingpong.c b/libibverbs/examples/srq_pingpong.c
index 8f55d78e87d4..e2993bfdacbf 100644
--- a/libibverbs/examples/srq_pingpong.c
+++ b/libibverbs/examples/srq_pingpong.c
@@ -497,7 +497,7 @@ clean_ctx:
 	return NULL;
 }
 
-int pp_close_ctx(struct pingpong_context *ctx, int num_qp)
+static int pp_close_ctx(struct pingpong_context *ctx, int num_qp)
 {
 	int i;
 
diff --git a/libibverbs/examples/uc_pingpong.c b/libibverbs/examples/uc_pingpong.c
index b565bacaff2a..3220cccd633b 100644
--- a/libibverbs/examples/uc_pingpong.c
+++ b/libibverbs/examples/uc_pingpong.c
@@ -426,7 +426,7 @@ clean_ctx:
 	return NULL;
 }
 
-int pp_close_ctx(struct pingpong_context *ctx)
+static int pp_close_ctx(struct pingpong_context *ctx)
 {
 	if (ibv_destroy_qp(ctx->qp)) {
 		fprintf(stderr, "Couldn't destroy QP\n");
diff --git a/libibverbs/examples/ud_pingpong.c b/libibverbs/examples/ud_pingpong.c
index ddb68cf8624b..e6a419c4d588 100644
--- a/libibverbs/examples/ud_pingpong.c
+++ b/libibverbs/examples/ud_pingpong.c
@@ -438,7 +438,7 @@ clean_ctx:
 	return NULL;
 }
 
-int pp_close_ctx(struct pingpong_context *ctx)
+static int pp_close_ctx(struct pingpong_context *ctx)
 {
 	if (ibv_destroy_qp(ctx->qp)) {
 		fprintf(stderr, "Couldn't destroy QP\n");
diff --git a/libibverbs/verbs.c b/libibverbs/verbs.c
index b470ba043658..7c5b1dd501bb 100644
--- a/libibverbs/verbs.c
+++ b/libibverbs/verbs.c
@@ -130,6 +130,8 @@ enum ibv_rate mbps_to_ibv_rate(int mbps)
 	}
 }
 
+#pragma GCC diagnostic ignored "-Wmissing-prototypes"
+
 int __ibv_query_device(struct ibv_context *context,
 		       struct ibv_device_attr *device_attr)
 {
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
