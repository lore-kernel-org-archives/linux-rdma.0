From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core 05/10] verbs: Tag matching list manipulation interface
Date: Mon, 23 Oct 2017 16:17:56 +0300
Message-ID: <1508764681-4531-6-git-send-email-yishaih@mellanox.com>
References: <1508764681-4531-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1508764681-4531-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

This patch introduced a new verb named ibv_post_srq_ops() to supply an
API to perform SRQ enhanced operations like tag matching list
manipulations. Detailed description for the tag matching operations
was added into Documentation/tag_matching.md

Signed-off-by: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 Documentation/tag_matching.md     |  80 ++++++++++++++++++++++++++++++
 libibverbs/enum_strs.c            |   5 +-
 libibverbs/man/CMakeLists.txt     |   1 +
 libibverbs/man/ibv_post_srq_ops.3 | 100 ++++++++++++++++++++++++++++++++++++++
 libibverbs/verbs.h                |  58 ++++++++++++++++++++--
 5 files changed, 239 insertions(+), 5 deletions(-)
 create mode 100644 libibverbs/man/ibv_post_srq_ops.3

diff --git a/Documentation/tag_matching.md b/Documentation/tag_matching.md
index bf110d6..1e5a929 100644
--- a/Documentation/tag_matching.md
+++ b/Documentation/tag_matching.md
@@ -166,3 +166,83 @@ ownership of the QP's Send Queue is passed to the TM-SRQ, which uses it to
 initiate rendezvous RDMA-Reads. Receive completions are reported to the
 TM-SRQ's CQ.
 
+
+### Managing TM receive buffers
+
+Untagged (unexpected) buffers are posted using the standard
+**ibv_post_srq_recv**() Verb.
+
+Tagged buffers are manipulated by a new **ibv_post_srq_ops**() Verb:
+
+```h
+int ibv_post_srq_ops(struct ibv_srq *srq, struct ibv_ops_wr *wr,
+                     struct ibv_ops_wr **bad_wr);
+```
+```h
+struct ibv_ops_wr {
+	 uint64_t		 wr_id;    /* User defined WR ID */
+	 /* Pointer to next WR in list, NULL if last WR */
+	 struct ibv_ops_wr	*next;
+	 enum ibv_ops_wr_opcode  opcode;   /* From enum ibv_ops_wr_opcode */
+	 int			 flags;    /* From enum ibv_ops_flags */
+	 struct {
+		  /* Number of unexpected messages
+		   * handled by SW */
+		  uint32_t unexpected_cnt;
+		  /* Input parameter for the DEL opcode
+		   * and output parameter for the ADD opcode */
+		  uint32_t handle;
+		  struct {
+			  /* WR ID for TM_RECV */
+			  uint64_t		  recv_wr_id;
+			  struct ibv_sge	 *sg_list;
+			  int			  num_sge;
+			  uint64_t		  tag;
+			  uint64_t		  mask;
+		  } add;
+	 } tm;
+};
+```
+
+The following opcodes are defined:
+
+Opcode **IBV_WR_TAG_ADD** - add a tagged buffer entry to the tag matching list.
+The input consists of an SGE list, a tag, a mask (matching parameters), and the
+latest unexpected message count. A handle that uniquely identifies the entry is
+returned upon success.
+
+Opcode **IBV_WR_TAG_DEL** - delete a tag entry.
+The input is an entry handle returned from a previous **IBV_WR_TAG_ADD**
+operation, and the latest unexpected message count.
+
+Note that the operation may fail if the associated tag was consumed by an
+incoming message. In this case **IBV_WC_TM_ERR** status will be returned in WC.
+
+Opcode **IBV_WR_TAG_SYNC** - report the number of unexpected messages handled by
+the SW.
+The input comprises only the unexpected message count. To reduce explicit
+synchronization to a minimum, all completions indicate when synchronization is
+necessary by setting the **IBV_WC_TM_SYNC_REQ** flag.
+
+**ibv_post_srq_ops**() operations are non-signaled by default. To request an
+explicit completion for a given operation, the standard **IBV_OPS_SIGNALED**
+flag must be set. The number of outstanding tag-manipulation operations must
+not exceed the **max_ops** capability.
+
+While **wr_id** identifies the tag manipulation operation itself, the
+**recv_wr_id** field is used to identify the tagged buffer in receive
+completions.
+
+
+### TM completion processing
+
+There are 2 types of TM completions: tag-manipulation and receive completions.
+
+Tag-manipulation operations generate the following completion opcodes:
+* **IBV_WC_TM_ADD** - completion of a tag addition operation
+* **IBV_WC_TM_DEL** - completion of a tag removal operation
+* **IBV_WC_TM_SYNC** - completion of a synchronization operation
+
+These completions are complemented by the **IBV_WC_TM_SYNC_REQ** flag, which
+indicates whether further HW synchronization is needed.
+
diff --git a/libibverbs/enum_strs.c b/libibverbs/enum_strs.c
index b9d8e2b..93f2c56 100644
--- a/libibverbs/enum_strs.c
+++ b/libibverbs/enum_strs.c
@@ -121,10 +121,11 @@ const char *ibv_wc_status_str(enum ibv_wc_status status)
 		[IBV_WC_INV_EEC_STATE_ERR]	= "invalid EE context state",
 		[IBV_WC_FATAL_ERR]		= "fatal error",
 		[IBV_WC_RESP_TIMEOUT_ERR]	= "response timeout error",
-		[IBV_WC_GENERAL_ERR]		= "general error"
+		[IBV_WC_GENERAL_ERR]		= "general error",
+		[IBV_WC_TM_ERR]			= "TM error",
 	};
 
-	if (status < IBV_WC_SUCCESS || status > IBV_WC_GENERAL_ERR)
+	if (status < IBV_WC_SUCCESS || status > IBV_WC_TM_ERR)
 		return "unknown";
 
 	return wc_status_str[status];
diff --git a/libibverbs/man/CMakeLists.txt b/libibverbs/man/CMakeLists.txt
index 05313e5..e302d04 100644
--- a/libibverbs/man/CMakeLists.txt
+++ b/libibverbs/man/CMakeLists.txt
@@ -36,6 +36,7 @@ rdma_man_pages(
   ibv_poll_cq.3
   ibv_post_recv.3
   ibv_post_send.3
+  ibv_post_srq_ops.3
   ibv_post_srq_recv.3
   ibv_query_device.3
   ibv_query_device_ex.3
diff --git a/libibverbs/man/ibv_post_srq_ops.3 b/libibverbs/man/ibv_post_srq_ops.3
new file mode 100644
index 0000000..a948aa8
--- /dev/null
+++ b/libibverbs/man/ibv_post_srq_ops.3
@@ -0,0 +1,100 @@
+.\" -*- nroff -*-
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
+.\"
+.TH IBV_POST_SRQ_OPS 3 2017-03-26 libibverbs "Libibverbs Programmer's Manual"
+.SH "NAME"
+ibv_post_srq_ops \- perform on a special shared receive queue (SRQ)
+configuration manipulations
+.SH "SYNOPSIS"
+.nf
+.B #include <infiniband/verbs.h>
+.sp
+.BI "int ibv_post_srq_ops(struct ibv_srq " "*srq" ", struct ibv_ops_wr " "*wr" ,
+.BI "                     struct ibv_ops_wr " "**bad_wr" );
+.fi
+.SH "DESCRIPTION"
+The
+.B ibv_post_srq_ops()
+performs series of offload configuration manipulations on spacial types of SRQ
+.I srq\fR. Currenlty it is used to configure tag matching SRQ. Series of configuration
+operations defined by linked lists of struct ibv_ops_wr elements starting from
+.I wr.
+.PP
+.nf
+struct ibv_ops_wr {
+.in +8
+uint64_t                wr_id;   /* User defined WR ID */
+/* Pointer to next WR in list, NULL if last WR */
+struct ibv_ops_wr      *next;
+enum ibv_ops_wr_opcode  opcode;  /* From enum ibv_ops_wr_opcode */
+int                     flags;   /* From enum ibv_ops_flags */
+struct {
+.in +8
+/* Number of unexpected messages
+ * handled by SW */
+uint32_t unexpected_cnt;
+/* Input parameter for the DEL opcode
+ * and output parameter for the ADD opcode */
+uint32_t handle;
+struct {
+.in +8
+uint64_t                recv_wr_id;   /* User defined WR ID for TM_RECV */
+struct ibv_sge         *sg_list; /* Pointer to the s/g array */
+int                     num_sge; /* Size of the s/g array */
+uint64_t                tag;
+uint64_t                mask;    /* Incoming message considered matching if
+                                    TMH.tag & entry.mask == entry.tag */
+.in -8
+} add;
+.in -8
+} tm;
+.in -8
+};
+.fi
+.PP
+First part of struct ibv_ops_wr retains ibv_send_wr notion.
+Opcode defines operation to perform. Currently supported IBV_WR_TAG_ADD,
+IBV_WR_TAG_DEL and IBV_WR_TAG_SYNC values. See below for detailed
+description.
+.PP
+To allow reliable data delivery TM SRQ maintains special low level
+synchronization primitive - phase synchronization. Receive side message
+handling comprises two concurrent activities - posting tagged buffers by
+SW and receiving incoming messages by HW. This process considered
+coherent only if all unexpected messages received by HW is completely
+processed in SW. To pass to hardware number of processed unexpected
+messages unexpected_cnt field should be used and IBV_OPS_TM_SYNC flag
+should be set.
+.PP
+To request WC for tag list operations IBV_OPS_SIGNALED flags should be
+passed. In this case WC will be generated on TM SRQ's CQ, provided wr_id
+will identify WC.
+.PP
+Opcode IBV_WR_TAG_ADD used to add tag entry to tag matching list.
+Tag entry consists of SGE list, tag & mask (matching parameters),
+user specified opaque wr_id (passed via recv_wr_id field) and uniquely
+identified by handle (returned by driver).
+Size of tag matching list is limited by max_num_tags.
+SGE list size is limited by max_sge.
+.PP
+Opcode IBV_WR_TAG_DEL removes previously added tag entry.
+Field handle should be set to value returned by previously performed
+IBV_WR_TAG_ADD operation.
+Operation may fail due to concurrent tag consumption - in this case IBV_WC_TM_ERR
+status will be returned in WC.
+.PP
+Opcode IBV_WR_TAG_SYNC may be used if no changes to matching list
+required, just to updated unexpected messages counter.
+.PP
+IBV_WC_TM_SYNC_REQ flag returned in list operation WC shows that counter
+synchronization required. This flag also may be returned by unexpected receive WC,
+asking for IBV_WR_TAG_SYNC operation to keep TM coherence consistency.
+.SH "RETURN VALUE"
+.B ibv_post_srq_ops()
+returns 0 on success, or the value of errno on failure (which indicates the
+failure reason).
+.SH "SEE ALSO"
+.BR ibv_create_srq_ex (3),
+.SH "AUTHORS"
+.TP
+Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
diff --git a/libibverbs/verbs.h b/libibverbs/verbs.h
index a440861..66f8c95 100644
--- a/libibverbs/verbs.h
+++ b/libibverbs/verbs.h
@@ -427,7 +427,8 @@ enum ibv_wc_status {
 	IBV_WC_INV_EEC_STATE_ERR,
 	IBV_WC_FATAL_ERR,
 	IBV_WC_RESP_TIMEOUT_ERR,
-	IBV_WC_GENERAL_ERR
+	IBV_WC_GENERAL_ERR,
+	IBV_WC_TM_ERR,
 };
 const char *ibv_wc_status_str(enum ibv_wc_status status);
 
@@ -445,7 +446,11 @@ enum ibv_wc_opcode {
  * receive by testing (opcode & IBV_WC_RECV).
  */
 	IBV_WC_RECV			= 1 << 7,
-	IBV_WC_RECV_RDMA_WITH_IMM
+	IBV_WC_RECV_RDMA_WITH_IMM,
+
+	IBV_WC_TM_ADD,
+	IBV_WC_TM_DEL,
+	IBV_WC_TM_SYNC,
 };
 
 enum {
@@ -486,7 +491,8 @@ enum ibv_wc_flags {
 	IBV_WC_GRH		= 1 << 0,
 	IBV_WC_WITH_IMM		= 1 << 1,
 	IBV_WC_IP_CSUM_OK	= 1 << IBV_WC_IP_CSUM_OK_SHIFT,
-	IBV_WC_WITH_INV         = 1 << 3
+	IBV_WC_WITH_INV		= 1 << 3,
+	IBV_WC_TM_SYNC_REQ	= 1 << 4,
 };
 
 struct ibv_wc {
@@ -1027,6 +1033,35 @@ struct ibv_recv_wr {
 	int			num_sge;
 };
 
+enum ibv_ops_wr_opcode {
+	IBV_WR_TAG_ADD,
+	IBV_WR_TAG_DEL,
+	IBV_WR_TAG_SYNC,
+};
+
+enum ibv_ops_flags {
+	IBV_OPS_SIGNALED = 1 << 0,
+	IBV_OPS_TM_SYNC  = 1 << 1,
+};
+
+struct ibv_ops_wr {
+	uint64_t				wr_id;
+	struct ibv_ops_wr		       *next;
+	enum ibv_ops_wr_opcode			opcode;
+	int					flags;
+	struct {
+		uint32_t			unexpected_cnt;
+		uint32_t			handle;
+		struct {
+			uint64_t		recv_wr_id;
+			struct ibv_sge	       *sg_list;
+			int			num_sge;
+			uint64_t		tag;
+			uint64_t		mask;
+		} add;
+	} tm;
+};
+
 struct ibv_mw_bind {
 	uint64_t		wr_id;
 	int			send_flags;
@@ -1572,6 +1607,9 @@ enum verbs_context_mask {
 
 struct verbs_context {
 	/*  "grows up" - new fields go here */
+	int (*post_srq_ops)(struct ibv_srq *srq,
+			    struct ibv_ops_wr *op,
+			    struct ibv_ops_wr **bad_op);
 	int (*destroy_rwq_ind_table)(struct ibv_rwq_ind_table *rwq_ind_table);
 	struct ibv_rwq_ind_table *(*create_rwq_ind_table)(struct ibv_context *context,
 							  struct ibv_rwq_ind_table_init_attr *init_attr);
@@ -2070,6 +2108,20 @@ static inline int ibv_post_srq_recv(struct ibv_srq *srq,
 	return srq->context->ops.post_srq_recv(srq, recv_wr, bad_recv_wr);
 }
 
+static inline int ibv_post_srq_ops(struct ibv_srq *srq,
+				   struct ibv_ops_wr *op,
+				   struct ibv_ops_wr **bad_op)
+{
+	struct verbs_context *vctx;
+
+	vctx = verbs_get_ctx_op(srq->context, post_srq_ops);
+	if (!vctx) {
+		*bad_op = op;
+		return ENOSYS;
+	}
+	return vctx->post_srq_ops(srq, op, bad_op);
+}
+
 /**
  * ibv_create_qp - Create a queue pair.
  */
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
