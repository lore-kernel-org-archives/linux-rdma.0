From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core 2/5] mlx5: Add direct verbs support for query clock info
Date: Wed, 17 Jan 2018 15:51:30 +0200
Message-ID: <1516197093-20699-3-git-send-email-yishaih@mellanox.com>
References: <1516197093-20699-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1516197093-20699-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ferasda-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Eitan Rabin <rabin-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Feras Daoud <ferasda-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Allow retrieving the current clock info with a direct verb.
This allows DV consumers to directly cache and control the safely copied
version of the clock data. A C11 atomic is used to ensure the copy of
the kernel data is done atomically.

A new mlx5dv attribute "max_clock_info_update_nsec" was added to
indicate the maximum period that the user can correctly use the cached
clock info, it can be retrieved by using the mlx5dv_query_device API.

Signed-off-by: Feras Daoud <ferasda-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Eitan Rabin <rabin-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 debian/ibverbs-providers.symbols           |  2 ++
 providers/mlx5/CMakeLists.txt              |  2 +-
 providers/mlx5/libmlx5.map                 |  5 ++++
 providers/mlx5/man/CMakeLists.txt          |  1 +
 providers/mlx5/man/mlx5dv_get_clock_info.3 | 37 +++++++++++++++++++++++++
 providers/mlx5/man/mlx5dv_query_device.3   |  2 +-
 providers/mlx5/mlx5-abi.h                  |  4 +++
 providers/mlx5/mlx5.c                      | 44 ++++++++++++++++++++++++++++++
 providers/mlx5/mlx5dv.h                    | 25 ++++++++++++++++-
 9 files changed, 119 insertions(+), 3 deletions(-)
 create mode 100644 providers/mlx5/man/mlx5dv_get_clock_info.3

diff --git a/debian/ibverbs-providers.symbols b/debian/ibverbs-providers.symbols
index b3adfe6..dc87c07 100644
--- a/debian/ibverbs-providers.symbols
+++ b/debian/ibverbs-providers.symbols
@@ -9,6 +9,7 @@ libmlx5.so.1 ibverbs-providers #MINVER#
  MLX5_1.1@MLX5_1.1 14
  MLX5_1.2@MLX5_1.2 15
  MLX5_1.3@MLX5_1.3 16
+ MLX5_1.4@MLX5_1.4 17
  mlx5dv_init_obj@MLX5_1.0 13
  mlx5dv_init_obj@MLX5_1.2 15
  mlx5dv_query_device@MLX5_1.0 13
@@ -16,3 +17,4 @@ libmlx5.so.1 ibverbs-providers #MINVER#
  mlx5dv_set_context_attr@MLX5_1.2 15
  mlx5dv_create_qp@MLX5_1.3 16
  mlx5dv_create_wq@MLX5_1.3 16
+ mlx5dv_get_clock_info@MLX5_1.4 17
diff --git a/providers/mlx5/CMakeLists.txt b/providers/mlx5/CMakeLists.txt
index 88a406d..a8db43d 100644
--- a/providers/mlx5/CMakeLists.txt
+++ b/providers/mlx5/CMakeLists.txt
@@ -11,7 +11,7 @@ if (MLX5_MW_DEBUG)
 endif()
 
 rdma_shared_provider(mlx5 libmlx5.map
-  1 1.3.${PACKAGE_VERSION}
+  1 1.4.${PACKAGE_VERSION}
   buf.c
   cq.c
   dbrec.c
diff --git a/providers/mlx5/libmlx5.map b/providers/mlx5/libmlx5.map
index f797822..01fb983 100644
--- a/providers/mlx5/libmlx5.map
+++ b/providers/mlx5/libmlx5.map
@@ -23,3 +23,8 @@ MLX5_1.3 {
 		mlx5dv_create_qp;
 		mlx5dv_create_wq;
 } MLX5_1.2;
+
+MLX5_1.4 {
+	global:
+		mlx5dv_get_clock_info;
+} MLX5_1.3;
diff --git a/providers/mlx5/man/CMakeLists.txt b/providers/mlx5/man/CMakeLists.txt
index bb1610b..6ce94a9 100644
--- a/providers/mlx5/man/CMakeLists.txt
+++ b/providers/mlx5/man/CMakeLists.txt
@@ -1,4 +1,5 @@
 rdma_man_pages(
+  mlx5dv_get_clock_info.3
   mlx5dv_init_obj.3
   mlx5dv_query_device.3
   mlx5dv.7
diff --git a/providers/mlx5/man/mlx5dv_get_clock_info.3 b/providers/mlx5/man/mlx5dv_get_clock_info.3
new file mode 100644
index 0000000..194a32e
--- /dev/null
+++ b/providers/mlx5/man/mlx5dv_get_clock_info.3
@@ -0,0 +1,37 @@
+.\" -*- nroff -*-
+.\" Licensed under the OpenIB.org (MIT) - See COPYING.md
+.\"
+.TH MLX5DV_GET_CLOCK_INFO 3 2017-11-08 1.0.0
+.SH "NAME"
+mlx5dv_get_clock_info \- Get device clock information
+.SH "SYNOPSIS"
+.nf
+.B #include <infiniband/mlx5dv.h>
+.sp
+.BI "int mlx5dv_get_clock_info(struct ibv_context *ctx_in,
+.BI "                          struct mlx5dv_clock_info *clock_info);
+.fi
+.SH "DESCRIPTION"
+Get the updated core
+.I clock_info
+from the device driver. This information will be used later to translate the
+completion timestamp from HCA core clock to nanoseconds. The values of the clock are
+updated from the driver's PTP clock, therefore, without a running PTP
+client on the machine, the wall clock conversion will not be accurate.
+.PP
+Pass the latest \fBstruct mlx5dv_clock_info\fR to \fBmlx5dv_ts_to_ns(3)\fR in order to translate
+the completion timestamp from HCA core clock to nanoseconds.
+.PP
+If the clock_info becomes too old then time conversion will return wrong conversion results.
+The user must ensure that  \fBmlx5dv_get_clock_info(3)\fR is called at least once every
+\fBmax_clock_info_update_nsec\fR as returned by the \fBmlx5dv_query_device(3)\fR function.
+.PP
+.fi
+.SH "RETURN VALUE"
+0 on success or the value of errno on failure (which indicates the failure reason).
+.SH "SEE ALSO"
+.BR mlx5dv (7),
+.BR mlx5dv_ts_to_ns (3)
+.SH "AUTHORS"
+.TP
+Feras Daoud <ferasda-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
diff --git a/providers/mlx5/man/mlx5dv_query_device.3 b/providers/mlx5/man/mlx5dv_query_device.3
index 0cffc2b..522b054 100644
--- a/providers/mlx5/man/mlx5dv_query_device.3
+++ b/providers/mlx5/man/mlx5dv_query_device.3
@@ -75,7 +75,7 @@ MLX5DV_CONTEXT_MASK_SWP                 = 1 << 1,
 MLX5DV_CONTEXT_MASK_STRIDING_RQ         = 1 << 2,
 MLX5DV_CONTEXT_MASK_TUNNEL_OFFLOADS     = 1 << 3,
 MLX5DV_CONTEXT_MASK_DYN_BFREGS          = 1 << 4,
-MLX5DV_CONTEXT_MASK_RESERVED            = 1 << 5,
+MLX5DV_CONTEXT_MASK_CLOCK_INFO_UPDATE   = 1 << 5,
 .in -8
 };
 
diff --git a/providers/mlx5/mlx5-abi.h b/providers/mlx5/mlx5-abi.h
index c5d323e..fb5ea0a 100644
--- a/providers/mlx5/mlx5-abi.h
+++ b/providers/mlx5/mlx5-abi.h
@@ -86,6 +86,10 @@ enum {
 	MLX5_IB_CLOCK_INFO_V1	= 0,
 };
 
+enum {
+	MLX5_IB_CLOCK_INFO_KERNEL_UPDATING = 1,
+};
+
 struct mlx5_ib_clock_info {
 	__u32 sig;
 	__u32 resv;
diff --git a/providers/mlx5/mlx5.c b/providers/mlx5/mlx5.c
index 28bb320..e71c8b0 100644
--- a/providers/mlx5/mlx5.c
+++ b/providers/mlx5/mlx5.c
@@ -673,6 +673,14 @@ int mlx5dv_query_device(struct ibv_context *ctx_in,
 		comp_mask_out |= MLX5DV_CONTEXT_MASK_DYN_BFREGS;
 	}
 
+	if (attrs_out->comp_mask & MLX5DV_CONTEXT_MASK_CLOCK_INFO_UPDATE) {
+		if (mctx->clock_info_page) {
+			attrs_out->max_clock_info_update_nsec =
+					mctx->clock_info_page->overflow_period;
+			comp_mask_out |= MLX5DV_CONTEXT_MASK_CLOCK_INFO_UPDATE;
+		}
+	}
+
 	attrs_out->comp_mask = comp_mask_out;
 
 	return 0;
@@ -868,6 +876,42 @@ int mlx5dv_set_context_attr(struct ibv_context *ibv_ctx,
 	return 0;
 }
 
+typedef _Atomic(uint32_t) atomic_uint32_t;
+
+int mlx5dv_get_clock_info(struct ibv_context *ctx_in,
+			  struct mlx5dv_clock_info *clock_info)
+{
+	struct mlx5_context *ctx = to_mctx(ctx_in);
+	const struct mlx5_ib_clock_info *ci = ctx->clock_info_page;
+	uint32_t retry, tmp_sig;
+	atomic_uint32_t *sig;
+
+	if (!ci)
+		return EINVAL;
+
+	sig = (atomic_uint32_t *)&ci->sig;
+
+	do {
+		retry = 10;
+repeat:
+		tmp_sig = atomic_load(sig);
+		if (unlikely(tmp_sig &
+			     MLX5_IB_CLOCK_INFO_KERNEL_UPDATING)) {
+			if (--retry)
+				goto repeat;
+			return EBUSY;
+		}
+		clock_info->nsec   = ci->nsec;
+		clock_info->last_cycles = ci->last_cycles;
+		clock_info->frac   = ci->frac;
+		clock_info->mult   = ci->mult;
+		clock_info->shift  = ci->shift;
+		clock_info->mask   = ci->mask;
+	} while (unlikely(tmp_sig != atomic_load(sig)));
+
+	return 0;
+}
+
 static void adjust_uar_info(struct mlx5_device *mdev,
 			    struct mlx5_context *context,
 			    struct mlx5_alloc_ucontext_resp resp)
diff --git a/providers/mlx5/mlx5dv.h b/providers/mlx5/mlx5dv.h
index 84c5099..2447517 100644
--- a/providers/mlx5/mlx5dv.h
+++ b/providers/mlx5/mlx5dv.h
@@ -63,7 +63,7 @@ enum mlx5dv_context_comp_mask {
 	MLX5DV_CONTEXT_MASK_STRIDING_RQ		= 1 << 2,
 	MLX5DV_CONTEXT_MASK_TUNNEL_OFFLOADS	= 1 << 3,
 	MLX5DV_CONTEXT_MASK_DYN_BFREGS		= 1 << 4,
-	MLX5DV_CONTEXT_MASK_RESERVED		= 1 << 5,
+	MLX5DV_CONTEXT_MASK_CLOCK_INFO_UPDATE	= 1 << 5,
 };
 
 struct mlx5dv_cqe_comp_caps {
@@ -102,6 +102,7 @@ struct mlx5dv_context {
 	struct mlx5dv_striding_rq_caps striding_rq_caps;
 	uint32_t	tunnel_offloads_caps;
 	uint32_t	max_dynamic_bfregs;
+	uint64_t	max_clock_info_update_nsec;
 };
 
 enum mlx5dv_context_flags {
@@ -788,4 +789,26 @@ struct mlx5dv_ctx_allocators {
 int mlx5dv_set_context_attr(struct ibv_context *context,
 		enum mlx5dv_set_ctx_attr_type type, void *attr);
 
+struct mlx5dv_clock_info {
+	uint64_t nsec;
+	uint64_t last_cycles;
+	uint64_t frac;
+	uint32_t mult;
+	uint32_t shift;
+	uint64_t mask;
+};
+
+/*
+ * Get mlx5 core clock info
+ *
+ * Output:
+ *      clock_info  - clock info to be filled
+ * Input:
+ *      context     - device context
+ *
+ * Return: 0 on success, or the value of errno on failure
+ */
+int mlx5dv_get_clock_info(struct ibv_context *context,
+			  struct mlx5dv_clock_info *clock_info);
+
 #endif /* _MLX5DV_H_ */
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
