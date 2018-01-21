From: Alex Rosenbaum <rosenbaumalex-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH RFC] Extend verbs packet pacing QP rate limiting with burst info
Date: Sun, 21 Jan 2018 13:25:49 +0200
Message-ID: <CAFgAxU_m1jC7dtrE6OuijDCtJHPCZiXMxhiKdj4VAvf_MKEgQw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Allow user space verbs application finer grain control of QP send rate
limit by setting a max_burst_sz [bytes] and typical_pkt_sz [bytes].

Expose new ibv_modify_qp_rate_limit() user space verbs API with dedicated
attribute struct. Fail call if requested configuration is not supported
on QP or device.

The standard kernel modify qp command will be used to pass the new values
to be modified by the driver.

Signed-off-by: Alex Rosenbaum <alexr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

---
 libibverbs/man/ibv_modify_qp_rate_limit.3 | 65 +++++++++++++++++++++++++++++++
 libibverbs/verbs.h                        | 26 +++++++++++++
 2 files changed, 91 insertions(+)
 create mode 100644 libibverbs/man/ibv_modify_qp_rate_limit.3

diff --git a/libibverbs/man/ibv_modify_qp_rate_limit.3
b/libibverbs/man/ibv_modify_qp_rate_limit.3
new file mode 100644
index 0000000..232aaaf
--- /dev/null
+++ b/libibverbs/man/ibv_modify_qp_rate_limit.3
@@ -0,0 +1,65 @@
+.\" -*- nroff -*-
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See
COPYING.md
+.\"
+.TH IBV_MODIFY_QP_RATE_LIMIT 3 2018-01-09 libibverbs "Libibverbs
Programmer's Manual"
+.SH "NAME"
+ibv_modify_qp_rate_limit \- modify the send rate limits attributes of
a queue pair (QP)
+.SH "SYNOPSIS"
+.nf
+.B #include <infiniband/verbs.h>
+.sp
+.BI "int ibv_modify_qp_rate_limit(struct ibv_qp " "*qp" ", struct
ibv_qp_rate_limit_attr " "*attr");
+.fi
+.SH "DESCRIPTION"
+.B ibv_modify_qp_rate_limit()
+modifies the send rate limiting packet pacing attributes of QP
+.I qp
+with the attributes in
+.I attr\fR.
+The argument \fIattr\fR is an ibv_qp_rate_limit_attr struct, as
defined in <infiniband/verbs.h>.
+.PP
+The
+.I rate_limit
+defines the MAX send rate this QP will send at as long as the link in
not blocked and there are work requestes in send queue.
+.PP
+Finer control for shaping the rate limit of a QP is achieved by defining the
+.I max_burst_sz\fR,
+single burst max bytes size and the
+.I typical_pkt_sz\fR,
+typical packet bytes size. These allow the device to adjust the
inter-burst gap delay required to correctly shape the scheduling of
sends to the wire in order to reach for requested application
requirements.
+.PP
+Setting a value of 0 for
+.I max_burst_sz
+or
+.I typical_pkt_sz
+will use the devices defaults.
+.I typical_pkt_sz
+will default to the port's MTU value.
+.PP
+.nf
+struct ibv_qp_rate_limit_attr {
+.in +8
+uint32_t        rate_limit;     /* kbps */
+uint32_t        max_burst_sz;
+uint16_t        typical_pkt_sz;
+.in -8
+};
+.fi
+.PP
+.SH "RETURN VALUE"
+.B ibv_modify_qp_rate_limit()
+returns 0 on success, or the value of errno on failure (which
indicates the failure reason).
+.SH "ERRORS"
+.SS EINVAL
+Invalid arguments.
+.SS ENOSYS
+Function is not implemented for this device.
+.PP
+.SH "SEE ALSO"
+.BR ibv_create_qp (3),
+.BR ibv_destroy_qp (3),
+.BR ibv_modify_qp (3),
+.BR ibv_query_qp (3)
+.SH "AUTHORS"
+.TP
+Alex Rosenbaum <alexr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
diff --git a/libibverbs/verbs.h b/libibverbs/verbs.h
index 997597a..cb73576 100644
--- a/libibverbs/verbs.h
+++ b/libibverbs/verbs.h
@@ -966,6 +966,13 @@ struct ibv_qp_attr {
  uint32_t rate_limit;
 };

+struct ibv_qp_rate_limit_attr {
+ uint32_t rate_limit;  /* in kbps */
+ uint32_t max_burst_sz; /* total burst size in bytes */
+ uint16_t typical_pkt_sz; /* typical packet bytes send size */
+ uint32_t comp_mask;
+};
+
 enum ibv_wr_opcode {
  IBV_WR_RDMA_WRITE,
  IBV_WR_RDMA_WRITE_WITH_IMM,
@@ -1650,6 +1657,7 @@ struct ibv_values_ex {

 struct verbs_context {
  /*  "grows up" - new fields go here */
+ int (*modify_qp_rate_limit)(struct ibv_qp *qp, struct
ibv_qp_rate_limit_attr *attr);
  struct ibv_pd *(*alloc_parent_domain)(struct ibv_context *context,
        struct ibv_parent_domain_init_attr *attr);
  int (*dealloc_td)(struct ibv_td *td);
@@ -2314,6 +2322,24 @@ int ibv_modify_qp(struct ibv_qp *qp, struct
ibv_qp_attr *attr,
    int attr_mask);

 /**
+ * ibv_modify_qp_rate_limit - Modify a queue pair rate limit values
+ * @qp - QP object to modify
+ * @attr - Attributes to configure the rate limiting values of the QP
+ */
+static inline
+int ibv_modify_qp_rate_limit(struct ibv_qp *qp,
+      struct ibv_qp_rate_limit_attr *attr)
+{
+ struct verbs_context *vctx;
+
+ vctx = verbs_get_ctx_op(qp->context, modify_qp_rate_limit);
+ if (!vctx)
+ return ENOSYS;
+
+ return vctx->modify_qp_rate_limit(qp, attr);
+}
+
+/**
  * ibv_query_qp - Returns the attribute list and current values for the
  *   specified QP.
  * @qp: The QP to query.
-- 
1.8.3.1
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
