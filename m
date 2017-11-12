From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH RFC rdma-core 1/5] verbs: Introduce thread domain and its related verbs
Date: Sun, 12 Nov 2017 23:41:39 +0200
Message-ID: <1510522903-6838-2-git-send-email-yishaih@mellanox.com>
References: <1510522903-6838-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1510522903-6838-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Alexr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The ibv_thread_domain is a user space object that can be used by an
application to mark that few verbs resources will be used from single
thread.

As a result the driver can share some hardware resources for those
resources and can drop few locks when it accesses them.

This patch introduces this object and its related verbs, more details about
the expected usage are described as part of the man page of this commit.

Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 libibverbs/man/ibv_alloc_td.3 | 52 +++++++++++++++++++++++++++++++++++++++++++
 libibverbs/verbs.h            | 35 +++++++++++++++++++++++++++++
 2 files changed, 87 insertions(+)
 create mode 100755 libibverbs/man/ibv_alloc_td.3

diff --git a/libibverbs/man/ibv_alloc_td.3 b/libibverbs/man/ibv_alloc_td.3
new file mode 100755
index 0000000..8fc2eef
--- /dev/null
+++ b/libibverbs/man/ibv_alloc_td.3
@@ -0,0 +1,52 @@
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
+.BI "struct ibv_td *ibv_alloc_td(struct ibv_context " "*context");
+.sp
+.BI "int ibv_dealloc_td(struct ibv_td " "*td");
+.fi
+.SH "DESCRIPTION"
+.B ibv_alloc_td()
+allocates a thread domain object for the RDMA device context
+.I context\fR.
+.sp
+The thread domain object defines how the verbs libraries will use locks and additional HW mapping to achieve best performance for handling multi-thread or single-thread protection.
+An application defines the serialization thread accesses scope by choosing which thread domain object will be used when creating verbs resources.
+.sp
+All verbs resources created with a unique thread domain object should be accessed in a serialized sequence by no more than single thread at a time.
+.sp
+Using verbs resources without a thread domain object means application can't commit to any threading access serialization model and the verbs library has to provide full thread safe access.
+.sp
+A
+.I struct ibv_td
+can be added to a parent domain via
+.B ibv_alloc_parent_domain()\fR.
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
+object, or NULL if the request fails (and sets errno to indicates the failure reason).
+.sp
+.B ibv_dealloc_td()
+returns 0 on success, or the value of errno on failure (which indicates the failure reason).
+.SH "SEE ALSO"
+.BR ibv_alloc_parent_domain (3),
+.SH "AUTHORS"
+.TP
+Alex Rosenbaum <rosenbaumalex-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
+
diff --git a/libibverbs/verbs.h b/libibverbs/verbs.h
index 6465aa9..c6c536f 100644
--- a/libibverbs/verbs.h
+++ b/libibverbs/verbs.h
@@ -549,6 +549,10 @@ struct ibv_pd {
 	uint32_t		handle;
 };
 
+struct ibv_td {
+	struct ibv_context     *context;
+};
+
 enum ibv_xrcd_init_attr_mask {
 	IBV_XRCD_INIT_ATTR_FD	    = 1 << 0,
 	IBV_XRCD_INIT_ATTR_OFLAGS   = 1 << 1,
@@ -1637,6 +1641,8 @@ enum verbs_context_mask {
 
 struct verbs_context {
 	/*  "grows up" - new fields go here */
+	int (*dealloc_td)(struct ibv_td *td);
+	struct ibv_td *(*alloc_td)(struct ibv_context *context);
 	int (*post_srq_ops)(struct ibv_srq *srq,
 			    struct ibv_ops_wr *op,
 			    struct ibv_ops_wr **bad_op);
@@ -2177,6 +2183,35 @@ ibv_create_qp_ex(struct ibv_context *context, struct ibv_qp_init_attr_ex *qp_ini
 }
 
 /**
+ * ibv_alloc_td - Allocate a thread domain
+ */
+static inline struct ibv_td *ibv_alloc_td(struct ibv_context *context)
+{
+	struct verbs_context *vctx;
+
+	vctx = verbs_get_ctx_op(context, alloc_td);
+	if (!vctx) {
+		errno = ENOSYS;
+		return NULL;
+	}
+	return vctx->alloc_td(context);
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
