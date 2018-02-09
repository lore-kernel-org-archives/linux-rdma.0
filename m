From: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [RFC PATCH rdma-core] Check that public headers support -Wpedantic
Date: Fri, 9 Feb 2018 11:14:10 -0700
Message-ID: <20180209181410.GA15016@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>, Thomas Monjalon <thomasm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

We do require a C11 compiler, but can support -Wpedantic compilation, at
least on some headers. This actually catches a few mistakes,
like the 1<<31.

Signed-off-by: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 buildlib/check-build    |  6 +++---
 libibverbs/verbs.h      | 26 +++++++++++++++++++++-----
 providers/mlx4/mlx4dv.h |  6 +++---
 providers/mlx5/mlx5dv.h | 12 +++---------
 4 files changed, 30 insertions(+), 20 deletions(-)

Lets consider this a bit experimental for now.

This changes the public headers to be mostly pedantically correct as
far as C11 (but not C99). There are still uses of zero length arrays
in some rdma-cm headers, but the verbs and dv headers are clean.

The main issue is what Bart recently pointed out, that the use of an
enum constant beyond the range of 'int' is a (popular) compiler
extension, so they have to change to #define

check-build is updated so the CI will continuously validate this.

I also haven't carefully checked the _verbs_get_ctx_op at this point,
won't bother if we don't want to do this. That change is needed
because the result statement expression thing is also an extension.

I noticed this as some projects like DPDK are compiling with
-Wpedantic and have to make special provision for verbs.h

Jason

diff --git a/buildlib/check-build b/buildlib/check-build
index 766db7ae46259f..b8b678a743c1bc 100755
--- a/buildlib/check-build
+++ b/buildlib/check-build
@@ -213,10 +213,10 @@ def get_headers(incdir):
                 includes.add(os.path.join(root,I));
     return includes;
 
-def compile_test_headers(tmpd,incdir,includes):
+def compile_test_headers(tmpd,incdir,includes,xargs="-std=gnu11"):
     with open(os.path.join(tmpd,"build.ninja"),"wt") as F:
         print >> F,"rule comp";
-        print >> F," command = %s -Werror -c -I %s $in -o $out"%(args.CC,incdir);
+        print >> F," command = %s -Werror -c -I %s $in -o $out %s"%(args.CC,incdir,xargs);
         print >> F," description=Header check for $in";
         count = 0;
         for I in sorted(includes):
@@ -280,7 +280,7 @@ def test_installed_headers(args):
             with open(I,"w") as F:
                 print >> F,'#error "Private internal header"';
 
-        compile_test_headers(tmpd,incdir,includes);
+        compile_test_headers(tmpd,incdir,includes,xargs="-std=c11  -D_GNU_SOURCE -Wpedantic -Wno-zero-length-array");
 
 # -------------------------------------------------------------------------
 
diff --git a/libibverbs/verbs.h b/libibverbs/verbs.h
index 5325f8fe412276..e83acbc7dc8568 100644
--- a/libibverbs/verbs.h
+++ b/libibverbs/verbs.h
@@ -230,8 +230,8 @@ enum ibv_rx_hash_fields {
 	IBV_RX_HASH_DST_PORT_TCP	= 1 << 5,
 	IBV_RX_HASH_SRC_PORT_UDP	= 1 << 6,
 	IBV_RX_HASH_DST_PORT_UDP	= 1 << 7,
-	IBV_RX_HASH_INNER		= (1UL << 31),
 };
+#define IBV_RX_HASH_INNER (1UL << 31)
 
 struct ibv_rss_caps {
 	uint32_t supported_qpts;
@@ -1714,10 +1714,26 @@ static inline struct verbs_context *verbs_get_ctx(struct ibv_context *ctx)
 						 context));
 }
 
-#define verbs_get_ctx_op(ctx, op) ({ \
-	struct verbs_context *__vctx = verbs_get_ctx(ctx); \
-	(!__vctx || (__vctx->sz < sizeof(*__vctx) - offsetof(struct verbs_context, op)) || \
-	 !__vctx->op) ? NULL : __vctx; })
+static inline struct verbs_context *_verbs_get_ctx_op(struct ibv_context *ctx,
+						      size_t op_off)
+{
+	struct verbs_context *vctx = verbs_get_ctx(ctx);
+	void *op;
+	if (!vctx)
+		return NULL;
+
+	if (vctx->sz < sizeof(*vctx) - op_off)
+		return NULL;
+
+	op = *((void **)((uint8_t *)vctx) + op_off);
+	if (!op)
+		return NULL;
+
+	return vctx;
+}
+
+#define verbs_get_ctx_op(ctx, op)                                              \
+	_verbs_get_ctx_op(ctx, offsetof(struct verbs_context, op))
 
 /**
  * ibv_get_device_list - Get list of IB devices currently available
diff --git a/providers/mlx4/mlx4dv.h b/providers/mlx4/mlx4dv.h
index 5312a866b6e281..e8c2ce104e2acd 100644
--- a/providers/mlx4/mlx4dv.h
+++ b/providers/mlx4/mlx4dv.h
@@ -288,14 +288,14 @@ enum {
 };
 
 enum {
-	MLX4_WQE_BIND_TYPE_2		= (1UL<<31),
 	MLX4_WQE_BIND_ZERO_BASED	= (1<<30),
 };
+#define MLX4_WQE_BIND_TYPE_2 (1UL << 31)
 
 enum {
-	MLX4_INLINE_SEG		= 1UL << 31,
 	MLX4_INLINE_ALIGN	= 64,
 };
+#define MLX4_INLINE_SEG (1UL << 31)
 
 enum {
 	MLX4_INVALID_LKEY	= 0x100,
@@ -304,8 +304,8 @@ enum {
 enum {
 	MLX4_WQE_MW_REMOTE_READ   = 1 << 29,
 	MLX4_WQE_MW_REMOTE_WRITE  = 1 << 30,
-	MLX4_WQE_MW_ATOMIC        = 1UL << 31
 };
+#define MLX4_WQE_MW_ATOMIC (1UL << 31)
 
 struct mlx4_wqe_local_inval_seg {
 	uint64_t		reserved1;
diff --git a/providers/mlx5/mlx5dv.h b/providers/mlx5/mlx5dv.h
index f2f5a2563287e1..01c5fa946062f2 100644
--- a/providers/mlx5/mlx5dv.h
+++ b/providers/mlx5/mlx5dv.h
@@ -433,9 +433,7 @@ struct mlx5_cqe64 {
 	uint8_t		op_own;
 };
 
-enum {
-	MLX5_TMC_SUCCESS	= 0x80000000U,
-};
+#define MLX5_TMC_SUCCESS (1UL << 31)
 
 enum mlx5dv_cqe_comp_res_format {
 	MLX5DV_CQE_RES_FORMAT_HASH		= 1 << 0,
@@ -487,9 +485,7 @@ enum {
 	MLX5_INVALID_LKEY	= 0x100,
 };
 
-enum {
-	MLX5_EXTENDED_UD_AV	= 0x80000000,
-};
+#define MLX5_EXTENDED_UD_AV (1UL << 31)
 
 enum {
 	MLX5_WQE_CTRL_CQ_UPDATE	= 2 << 2,
@@ -503,9 +499,7 @@ enum {
 	MLX5_SEND_WQE_SHIFT	= 6,
 };
 
-enum {
-	MLX5_INLINE_SEG	= 0x80000000,
-};
+#define MLX5_INLINE_SEG (1UL << 31)
 
 enum {
 	MLX5_ETH_WQE_L3_CSUM = (1 << 6),
-- 
2.16.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
