From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core 2/4] verbs: Add support for CQ moderation
Date: Mon, 30 Oct 2017 16:09:01 +0200
Message-ID: <1509372543-26603-3-git-send-email-yishaih@mellanox.com>
References: <1509372543-26603-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1509372543-26603-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

This patch introduces ibv_modify_cq verb to enable CQ moderation,
it can be extended in the future for other options by using the
attr_mask field.
By using ibv_modify_cq verb a user can moderate completion events
by specifying the number of completions that cause an event
and the timeout in micro seconds to cause the event even if
the number of completions was not reached.
To disable moderation feature, a user will reset
cq_count and cq_period to 0.

Signed-off-by: Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 libibverbs/cmd.c               | 24 +++++++++++++++++++++
 libibverbs/driver.h            |  4 ++++
 libibverbs/kern-abi.h          | 15 +++++++++++++
 libibverbs/libibverbs.map.in   |  1 +
 libibverbs/man/CMakeLists.txt  |  1 +
 libibverbs/man/ibv_modify_cq.3 | 48 ++++++++++++++++++++++++++++++++++++++++++
 libibverbs/verbs.h             | 25 ++++++++++++++++++++++
 7 files changed, 118 insertions(+)
 create mode 100644 libibverbs/man/ibv_modify_cq.3

diff --git a/libibverbs/cmd.c b/libibverbs/cmd.c
index b903ade..8a164b8 100644
--- a/libibverbs/cmd.c
+++ b/libibverbs/cmd.c
@@ -2130,3 +2130,27 @@ int ibv_cmd_destroy_rwq_ind_table(struct ibv_rwq_ind_table *rwq_ind_table)
 
 	return ret;
 }
+
+
+int ibv_cmd_modify_cq(struct ibv_cq *cq,
+		      struct ibv_modify_cq_attr *attr,
+		      struct ibv_modify_cq *cmd,
+		      size_t cmd_size)
+{
+
+	if (attr->attr_mask >= IBV_CQ_ATTR_RESERVED)
+		return EINVAL;
+
+	IBV_INIT_CMD_EX(cmd, cmd_size, MODIFY_CQ);
+
+	cmd->cq_handle = cq->handle;
+	cmd->attr_mask = attr->attr_mask;
+	cmd->attr.cq_count =  attr->moderate.cq_count;
+	cmd->attr.cq_period = attr->moderate.cq_period;
+	cmd->reserved = 0;
+
+	if (write(cq->context->cmd_fd, cmd, cmd_size) != cmd_size)
+		return errno;
+
+	return 0;
+}
diff --git a/libibverbs/driver.h b/libibverbs/driver.h
index a3cdbe1..e5673ba 100644
--- a/libibverbs/driver.h
+++ b/libibverbs/driver.h
@@ -286,6 +286,10 @@ int ibv_cmd_resize_cq(struct ibv_cq *cq, int cqe,
 		      struct ibv_resize_cq *cmd, size_t cmd_size,
 		      struct ibv_resize_cq_resp *resp, size_t resp_size);
 int ibv_cmd_destroy_cq(struct ibv_cq *cq);
+int ibv_cmd_modify_cq(struct ibv_cq *cq,
+		      struct ibv_modify_cq_attr *attr,
+		      struct ibv_modify_cq *cmd,
+		      size_t cmd_size);
 
 int ibv_cmd_create_srq(struct ibv_pd *pd,
 		       struct ibv_srq *srq, struct ibv_srq_init_attr *attr,
diff --git a/libibverbs/kern-abi.h b/libibverbs/kern-abi.h
index a80d2e6..f53e22f 100644
--- a/libibverbs/kern-abi.h
+++ b/libibverbs/kern-abi.h
@@ -124,6 +124,7 @@ enum {
 	IB_USER_VERBS_CMD_DESTROY_WQ,
 	IB_USER_VERBS_CMD_CREATE_RWQ_IND_TBL,
 	IB_USER_VERBS_CMD_DESTROY_RWQ_IND_TBL,
+	IB_USER_VERBS_CMD_MODIFY_CQ,
 };
 
 /*
@@ -1251,6 +1252,7 @@ enum {
 	IB_USER_VERBS_CMD_CREATE_RWQ_IND_TBL_V2 = -1,
 	IB_USER_VERBS_CMD_DESTROY_RWQ_IND_TBL_V2 = -1,
 	IB_USER_VERBS_CMD_MODIFY_QP_EX_V2 = -1,
+	IB_USER_VERBS_CMD_MODIFY_CQ_V2 = -1,
 };
 
 struct ibv_modify_srq_v3 {
@@ -1353,4 +1355,17 @@ struct ibv_destroy_rwq_ind_table {
 	__u32 ind_tbl_handle;
 };
 
+struct ibv_kern_modify_cq_attr {
+	__u16 cq_count;
+	__u16 cq_period;
+};
+
+struct ibv_modify_cq {
+	struct ex_hdr hdr;
+	__u32 cq_handle;
+	__u32 attr_mask;
+	struct ibv_kern_modify_cq_attr attr;
+	__u32 reserved;
+};
+
 #endif /* KERN_ABI_H */
diff --git a/libibverbs/libibverbs.map.in b/libibverbs/libibverbs.map.in
index 39d9d05..d65f06c 100644
--- a/libibverbs/libibverbs.map.in
+++ b/libibverbs/libibverbs.map.in
@@ -139,4 +139,5 @@ IBVERBS_PRIVATE_@IBVERBS_PABI_VERSION@ {
 		ibv_register_driver;
 		verbs_register_driver_@IBVERBS_PABI_VERSION@;
 		verbs_init_cq;
+		ibv_cmd_modify_cq;
 };
diff --git a/libibverbs/man/CMakeLists.txt b/libibverbs/man/CMakeLists.txt
index e302d04..904bb11 100644
--- a/libibverbs/man/CMakeLists.txt
+++ b/libibverbs/man/CMakeLists.txt
@@ -9,6 +9,7 @@ rdma_man_pages(
   ibv_create_comp_channel.3
   ibv_create_cq.3
   ibv_create_cq_ex.3
+  ibv_modify_cq.3
   ibv_create_flow.3
   ibv_create_qp.3
   ibv_create_qp_ex.3
diff --git a/libibverbs/man/ibv_modify_cq.3 b/libibverbs/man/ibv_modify_cq.3
new file mode 100644
index 0000000..d15d2cd
--- /dev/null
+++ b/libibverbs/man/ibv_modify_cq.3
@@ -0,0 +1,48 @@
+.\" -*- nroff -*-
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
+.\"
+.TH IBV_MODIFY_CQ 3 2017-10-20 libibverbs "Libibverbs Programmer's Manual"
+.SH "NAME"
+ibv_modify_cq \- modify a completion queue (CQ)
+.SH "SYNOPSIS"
+.nf
+.B #include <infiniband/verbs.h>
+.sp
+.BI "int ibv_modify_cq(struct ibv_cq " *cq ", struct ibv_modify_cq_attr "*cq_attr ");
+.sp
+.fi
+.SH "DESCRIPTION"
+.B ibv_modify_cq()
+modify a CQ
+.I cq\fR.
+The argument
+.I cq_attr
+is an ibv_modify_cq_attr struct, as defined in <infiniband/verbs.h>.
+.PP
+.nf
+struct ibv_moderate_cq {
+.in +8
+uint16_t cq_count;  /* number of completions per event */
+uint16_t cq_period; /* in micro seconds */
+.in -8
+};
+
+struct ibv_modify_cq_attr {
+.in +8
+	uint32_t attr_mask;
+	struct ibv_moderate_cq moderate;
+.in -8
+};
+.fi
+.PP
+The function
+.B ibv_modify_cq()
+will modify the CQ, based on the given
+.I cq_attr\fB\fR->attr_mask
+.SH "RETURN VALUE"
+returns 0 on success, or the value of errno on failure (which indicates the failure reason).
+.SH "SEE ALSO"
+.BR ibv_create_cq (3)
+.SH "AUTHORS"
+.TP
+Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
diff --git a/libibverbs/verbs.h b/libibverbs/verbs.h
index dbc95cb..0e177e2 100644
--- a/libibverbs/verbs.h
+++ b/libibverbs/verbs.h
@@ -1210,6 +1210,21 @@ static inline struct ibv_cq *ibv_cq_ex_to_cq(struct ibv_cq_ex *cq)
 	return (struct ibv_cq *)cq;
 }
 
+enum ibv_cq_attr_mask {
+	IBV_CQ_ATTR_MODERATE = 1 << 0,
+	IBV_CQ_ATTR_RESERVED = 1 << 1,
+};
+
+struct ibv_moderate_cq {
+	uint16_t cq_count;
+	uint16_t cq_period; /* in micro seconds */
+};
+
+struct ibv_modify_cq_attr {
+	uint32_t attr_mask;
+	struct ibv_moderate_cq moderate;
+};
+
 static inline int ibv_start_poll(struct ibv_cq_ex *cq,
 				    struct ibv_poll_cq_attr *attr)
 {
@@ -1636,6 +1651,7 @@ enum verbs_context_mask {
 
 struct verbs_context {
 	/*  "grows up" - new fields go here */
+	int (*modify_cq)(struct ibv_cq *cq, struct ibv_modify_cq_attr *attr);
 	int (*post_srq_ops)(struct ibv_srq *srq,
 			    struct ibv_ops_wr *op,
 			    struct ibv_ops_wr **bad_op);
@@ -2047,6 +2063,15 @@ static inline int ibv_req_notify_cq(struct ibv_cq *cq, int solicited_only)
 	return cq->context->ops.req_notify_cq(cq, solicited_only);
 }
 
+static inline int ibv_modify_cq(struct ibv_cq *cq, struct ibv_modify_cq_attr *attr)
+{
+	struct verbs_context *vctx = verbs_get_ctx_op(cq->context, modify_cq);
+
+	if (!vctx)
+		return ENOSYS;
+
+	return vctx->modify_cq(cq, attr);
+}
 /**
  * ibv_create_srq - Creates a SRQ associated with the specified protection
  *   domain.
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
