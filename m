From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core 1/9] verbs: Introduce ibv_thread_domain and its related verbs
Date: Mon, 25 Dec 2017 15:56:53 +0200
Message-ID: <1514210221-10466-2-git-send-email-yishaih@mellanox.com>
References: <1514210221-10466-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1514210221-10466-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Alexr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The ibv_thread_domain is a user space object that can be used by an
application to group verbs objects together for the purpose of
optimizing the behavior of the driver in a multi-threaded environment.

The first use of this will be for mlx5 to group UAR registers in a way
that avoids needing locking on the post send path.

This patch introduces this object and its related verbs, more details
about the usage are described as part of the man page of this commit.

Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 libibverbs/man/CMakeLists.txt |  4 ++-
 libibverbs/man/ibv_alloc_td.3 | 61 +++++++++++++++++++++++++++++++++++++++++++
 libibverbs/verbs.h            | 41 +++++++++++++++++++++++++++++
 3 files changed, 105 insertions(+), 1 deletion(-)
 create mode 100644 libibverbs/man/ibv_alloc_td.3

diff --git a/libibverbs/man/CMakeLists.txt b/libibverbs/man/CMakeLists.txt
index 904bb11..f098311 100644
--- a/libibverbs/man/CMakeLists.txt
+++ b/libibverbs/man/CMakeLists.txt
@@ -1,6 +1,7 @@
 rdma_man_pages(
   ibv_alloc_mw.3
   ibv_alloc_pd.3
+  ibv_alloc_td.3
   ibv_asyncwatch.1
   ibv_attach_mcast.3
   ibv_bind_mw.3
@@ -62,6 +63,7 @@ rdma_man_pages(
 rdma_alias_man_pages(
   ibv_alloc_mw.3 ibv_dealloc_mw.3
   ibv_alloc_pd.3 ibv_dealloc_pd.3
+  ibv_alloc_td.3 ibv_dealloc_td.3
   ibv_attach_mcast.3 ibv_detach_mcast.3
   ibv_create_ah.3 ibv_destroy_ah.3
   ibv_create_ah_from_wc.3 ibv_init_ah_from_wc.3
@@ -82,4 +84,4 @@ rdma_alias_man_pages(
   ibv_rate_to_mbps.3 mbps_to_ibv_rate.3
   ibv_rate_to_mult.3 mult_to_ibv_rate.3
   ibv_reg_mr.3 ibv_dereg_mr.3
-  )
\ No newline at end of file
+  )
diff --git a/libibverbs/man/ibv_alloc_td.3 b/libibverbs/man/ibv_alloc_td.3
new file mode 100644
index 0000000..4c92016
--- /dev/null
+++ b/libibverbs/man/ibv_alloc_td.3
@@ -0,0 +1,61 @@
+.\" -*- nroff -*-
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
+.\"
+.TH IBV_ALLOC_TD 3 2017-11-06 libibverbs "Libibverbs Programmer's Manual"
+.SH "NAME"
+ibv_alloc_td(), ibv_dealloc_td() \- allocate and deallocate thread domain object
+.SH "SYNOPSIS"
+.nf
+.B #include <infiniband/verbs.h>
+.sp
+.BI "struct ibv_td *ibv_alloc_td(struct ibv_context " "*context" ,
+.BI "                            struct ibv_td_init_attr " "*init_attr" );
+.sp
+.BI "int ibv_dealloc_td(struct ibv_td " "*td");
+.fi
+.SH "DESCRIPTION"
+.B ibv_alloc_td()
+allocates a thread domain object for the RDMA device context
+.I context\fR.
+.sp
+The thread domain object defines how the verbs libraries and provider will use
+locks and additional hardware capabilities to achieve best performance for
+handling multi-thread or single-thread protection.  An application assigns
+verbs resources to a thread domain when it creates a verbs object.
+.sp
+If the
+.I
+ibv_td
+object is specified then any objects created under this thread domain will
+disable internal locking designed to protect against concurrent access to that
+object from multiple user threads. By default all verbs objects are safe for
+multi-threaded access, whether or not a thread domain is specified.
+.sp
+A
+.I struct ibv_td
+can be added to a parent domain via
+.B ibv_alloc_parent_domain()
+and then the parent domain can be used to create verbs objects.
+.sp
+.B ibv_dealloc_td()
+will deallocate the thread domain
+.I td\fR.
+All resources created with the
+.I td
+should be destroyed prior to deallocating the
+.I td\fR.
+.SH "RETURN VALUE"
+.B ibv_alloc_td()
+returns a pointer to the allocated struct
+.I ibv_td
+object, or NULL if the request fails (and sets errno to indicate the failure reason).
+.sp
+.B ibv_dealloc_td()
+returns 0 on success, or the value of errno on failure (which indicates the failure reason).
+.SH "SEE ALSO"
+.BR ibv_alloc_parent_domain (3),
+.SH "AUTHORS"
+.TP
+Alex Rosenbaum <alexr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
+.TP
+Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
diff --git a/libibverbs/verbs.h b/libibverbs/verbs.h
index 775bad5..9329151 100644
--- a/libibverbs/verbs.h
+++ b/libibverbs/verbs.h
@@ -540,6 +540,14 @@ struct ibv_pd {
 	uint32_t		handle;
 };
 
+struct ibv_td_init_attr {
+	uint32_t comp_mask;
+};
+
+struct ibv_td {
+	struct ibv_context     *context;
+};
+
 enum ibv_xrcd_init_attr_mask {
 	IBV_XRCD_INIT_ATTR_FD	    = 1 << 0,
 	IBV_XRCD_INIT_ATTR_OFLAGS   = 1 << 1,
@@ -1636,6 +1644,8 @@ struct ibv_values_ex {
 
 struct verbs_context {
 	/*  "grows up" - new fields go here */
+	int (*dealloc_td)(struct ibv_td *td);
+	struct ibv_td *(*alloc_td)(struct ibv_context *context, struct ibv_td_init_attr *init_attr);
 	int (*modify_cq)(struct ibv_cq *cq, struct ibv_modify_cq_attr *attr);
 	int (*post_srq_ops)(struct ibv_srq *srq,
 			    struct ibv_ops_wr *op,
@@ -2186,6 +2196,37 @@ ibv_create_qp_ex(struct ibv_context *context, struct ibv_qp_init_attr_ex *qp_ini
 }
 
 /**
+ * ibv_alloc_td - Allocate a thread domain
+ */
+static inline struct ibv_td *ibv_alloc_td(struct ibv_context *context,
+					  struct ibv_td_init_attr *init_attr)
+{
+	struct verbs_context *vctx;
+
+	vctx = verbs_get_ctx_op(context, alloc_td);
+	if (!vctx) {
+		errno = ENOSYS;
+		return NULL;
+	}
+
+	return vctx->alloc_td(context, init_attr);
+}
+
+/**
+ * ibv_dealloc_td - Free a thread domain
+ */
+static inline int ibv_dealloc_td(struct ibv_td *td)
+{
+	struct verbs_context *vctx;
+
+	vctx = verbs_get_ctx_op(td->context, dealloc_td);
+	if (!vctx)
+		return ENOSYS;
+
+	return vctx->dealloc_td(td);
+}
+
+/**
  * ibv_query_rt_values_ex - Get current real time @values of a device.
  * @values - in/out - defines the attributes we need to query/queried.
  * (Or's bits of enum ibv_values_mask on values->comp_mask field)
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
