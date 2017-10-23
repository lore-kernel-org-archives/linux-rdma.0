From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core 03/10] verbs: Introduce tag matching SRQ
Date: Mon, 23 Oct 2017 16:17:54 +0300
Message-ID: <1508764681-4531-4-git-send-email-yishaih@mellanox.com>
References: <1508764681-4531-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1508764681-4531-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Introducing tag matching SRQ (TM-SRQ), which retains basic semantic of
regular SRQ, reports completions to own CQ, and has additional tag
based message receiving mechanism.
Detailed description for the TM-SRQ usage was added into
Documentation/tag_matching.md

Signed-off-by: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 Documentation/tag_matching.md      | 22 ++++++++++++++++++++++
 libibverbs/cmd.c                   | 11 +++++++++++
 libibverbs/kern-abi.h              |  2 +-
 libibverbs/man/ibv_create_srq_ex.3 | 13 ++++++++++++-
 libibverbs/verbs.h                 | 12 ++++++++++--
 5 files changed, 56 insertions(+), 4 deletions(-)

diff --git a/Documentation/tag_matching.md b/Documentation/tag_matching.md
index 8e62440..bf110d6 100644
--- a/Documentation/tag_matching.md
+++ b/Documentation/tag_matching.md
@@ -144,3 +144,25 @@ following attributes:
 * **flags** - the following flags are currently defined:
     - IBV_TM_CAP_RC - Support tag matching on RC transport
 
+
+### TM-SRQ creation
+
+TM-SRQs are created by the ibv_create_srq_ex() Verb, which accepts the
+following new attributes:
+* **srq_type** - set to **IBV_SRQT_TM**
+* **comp_mask** - set the **IBV_SRQ_INIT_ATTR_TM** flag
+* **tm_cap** - TM properties for this TM-SRQ; defined as follows:
+
+```h
+struct ibv_tm_cap {
+	 uint32_t max_num_tags;   /* Matching list size */
+	 uint32_t max_ops;	  /* Number of outstanding TM operations */
+}
+```
+Similarly to XRC SRQs, a TM-SRQ has a dedicated CQ.
+
+RC QPs are associated with the TM-SRQ just like standard SRQs. However, the
+ownership of the QP's Send Queue is passed to the TM-SRQ, which uses it to
+initiate rendezvous RDMA-Reads. Receive completions are reported to the
+TM-SRQ's CQ.
+
diff --git a/libibverbs/cmd.c b/libibverbs/cmd.c
index 97351de..713a13c 100644
--- a/libibverbs/cmd.c
+++ b/libibverbs/cmd.c
@@ -720,6 +720,17 @@ int ibv_cmd_create_srq_ex(struct ibv_context *context,
 		vxrcd = container_of(attr_ex->xrcd, struct verbs_xrcd, xrcd);
 		cmd->xrcd_handle = vxrcd->handle;
 		cmd->cq_handle   = attr_ex->cq->handle;
+	} else if (attr_ex->comp_mask & IBV_SRQ_INIT_ATTR_TM) {
+		if (cmd->srq_type != IBV_SRQT_TM)
+			return EINVAL;
+		if (!(attr_ex->comp_mask & IBV_SRQ_INIT_ATTR_CQ) ||
+		    !attr_ex->tm_cap.max_num_tags)
+			return EINVAL;
+
+		cmd->cq_handle    = attr_ex->cq->handle;
+		cmd->max_num_tags = attr_ex->tm_cap.max_num_tags;
+	} else if (cmd->srq_type != IBV_SRQT_BASIC) {
+		return EINVAL;
 	}
 
 	if (write(context->cmd_fd, cmd, cmd_size) != cmd_size)
diff --git a/libibverbs/kern-abi.h b/libibverbs/kern-abi.h
index 5f3f28c..6a16566 100644
--- a/libibverbs/kern-abi.h
+++ b/libibverbs/kern-abi.h
@@ -1126,7 +1126,7 @@ struct ibv_create_xsrq {
 	__u32 max_wr;
 	__u32 max_sge;
 	__u32 srq_limit;
-	__u32 reserved;
+	__u32 max_num_tags;
 	__u32 xrcd_handle;
 	__u32 cq_handle;
 	__u64 driver_data[0];
diff --git a/libibverbs/man/ibv_create_srq_ex.3 b/libibverbs/man/ibv_create_srq_ex.3
index c031906..97529ae 100644
--- a/libibverbs/man/ibv_create_srq_ex.3
+++ b/libibverbs/man/ibv_create_srq_ex.3
@@ -26,10 +26,11 @@ struct ibv_srq_init_attr_ex {
 void                   *srq_context;    /* Associated context of the SRQ */
 struct ibv_srq_attr     attr;           /* SRQ attributes */
 uint32_t                comp_mask;      /* Identifies valid fields */
-enum ibv_srq_type       srq_type;       /* Basic / XRC */
+enum ibv_srq_type       srq_type;       /* Basic / XRC / tag matching */
 struct ibv_pd          *pd;             /* PD associated with the SRQ */
 struct ibv_xrcd        *xrcd;           /* XRC domain to associate with the SRQ */
 struct ibv_cq          *cq;             /* CQ to associate with the SRQ for XRC mode */
+struct ibv_tm_cap       tm_cap;         /* Tag matching attributes */
 .in -8
 };
 .sp
@@ -41,6 +42,16 @@ uint32_t                max_sge;        /* Requested max number of scatter eleme
 uint32_t                srq_limit;      /* The limit value of the SRQ */
 .in -8
 };
+.sp
+.nf
+struct ibv_tm_cap {
+.in +8
+uint32_t                max_num_tags;   /* Tag matching list size */
+uint32_t                max_ops;        /* Number of outstanding tag list operations */
+.in -8
+};
+.sp
+.nf
 .fi
 .PP
 The function
diff --git a/libibverbs/verbs.h b/libibverbs/verbs.h
index 2ef9132..a440861 100644
--- a/libibverbs/verbs.h
+++ b/libibverbs/verbs.h
@@ -673,7 +673,8 @@ struct ibv_srq_init_attr {
 
 enum ibv_srq_type {
 	IBV_SRQT_BASIC,
-	IBV_SRQT_XRC
+	IBV_SRQT_XRC,
+	IBV_SRQT_TM,
 };
 
 enum ibv_srq_init_attr_mask {
@@ -681,7 +682,13 @@ enum ibv_srq_init_attr_mask {
 	IBV_SRQ_INIT_ATTR_PD		= 1 << 1,
 	IBV_SRQ_INIT_ATTR_XRCD		= 1 << 2,
 	IBV_SRQ_INIT_ATTR_CQ		= 1 << 3,
-	IBV_SRQ_INIT_ATTR_RESERVED	= 1 << 4
+	IBV_SRQ_INIT_ATTR_TM		= 1 << 4,
+	IBV_SRQ_INIT_ATTR_RESERVED	= 1 << 5,
+};
+
+struct ibv_tm_cap {
+	uint32_t		max_num_tags;
+	uint32_t		max_ops;
 };
 
 struct ibv_srq_init_attr_ex {
@@ -693,6 +700,7 @@ struct ibv_srq_init_attr_ex {
 	struct ibv_pd	       *pd;
 	struct ibv_xrcd	       *xrcd;
 	struct ibv_cq	       *cq;
+	struct ibv_tm_cap	tm_cap;
 };
 
 enum ibv_wq_type {
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
