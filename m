From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core 1/4] verbs: Introduce driver QP type
Date: Thu,  4 Jan 2018 18:49:18 +0200
Message-ID: <1515084561-11374-2-git-send-email-yishaih@mellanox.com>
References: <1515084561-11374-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1515084561-11374-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Vendors can implement types of QPs that are not described in the
InfiniBand specification. Verbs layer doesn't know which services this
QP provides but it assumes that the hardware driver does. The new QP
type IBV_QPT_DRIVER should be used for this kind of QP. Any extra data
that describes this QP should be stored in a context in the hardware
driver that is associated with this QP.

Signed-off-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 libibverbs/man/ibv_create_qp.3    | 5 ++++-
 libibverbs/man/ibv_create_qp_ex.3 | 5 ++++-
 libibverbs/verbs.h                | 3 ++-
 3 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/libibverbs/man/ibv_create_qp.3 b/libibverbs/man/ibv_create_qp.3
index 78d7f43..1cdf247 100644
--- a/libibverbs/man/ibv_create_qp.3
+++ b/libibverbs/man/ibv_create_qp.3
@@ -29,7 +29,7 @@ struct ibv_cq          *send_cq;        /* CQ to be associated with the Send Que
 struct ibv_cq          *recv_cq;        /* CQ to be associated with the Receive Queue (RQ) */
 struct ibv_srq         *srq;            /* SRQ handle if QP is to be associated with an SRQ, otherwise NULL */
 struct ibv_qp_cap       cap;            /* QP capabilities */
-enum ibv_qp_type        qp_type;        /* QP Transport Service Type: IBV_QPT_RC, IBV_QPT_UC, IBV_QPT_UD or IBV_QPT_RAW_PACKET */
+enum ibv_qp_type        qp_type;        /* QP Transport Service Type: IBV_QPT_RC, IBV_QPT_UC, IBV_QPT_UD, IBV_QPT_RAW_PACKET or IBV_QPT_DRIVER */
 int                     sq_sig_all;     /* If set, each Work Request (WR) submitted to the SQ generates a completion entry */
 .in -8
 };
@@ -77,6 +77,9 @@ if the QP is to be associated with an SRQ.
 .PP
 .B ibv_destroy_qp()
 fails if the QP is attached to a multicast group.
+.PP
+.B IBV_QPT_DRIVER
+does not represent a specific service and is used for vendor specific QP logic.
 .SH "SEE ALSO"
 .BR ibv_alloc_pd (3),
 .BR ibv_modify_qp (3),
diff --git a/libibverbs/man/ibv_create_qp_ex.3 b/libibverbs/man/ibv_create_qp_ex.3
index bb2d1b6..3429a65 100644
--- a/libibverbs/man/ibv_create_qp_ex.3
+++ b/libibverbs/man/ibv_create_qp_ex.3
@@ -29,7 +29,7 @@ struct ibv_cq          *send_cq;        /* CQ to be associated with the Send Que
 struct ibv_cq          *recv_cq;        /* CQ to be associated with the Receive Queue (RQ) */
 struct ibv_srq         *srq;            /* SRQ handle if QP is to be associated with an SRQ, otherwise NULL */
 struct ibv_qp_cap       cap;            /* QP capabilities */
-enum ibv_qp_type        qp_type;        /* QP Transport Service Type: IBV_QPT_RC, IBV_QPT_UC, IBV_QPT_UD or IBV_QPT_RAW_PACKET */
+enum ibv_qp_type        qp_type;        /* QP Transport Service Type: IBV_QPT_RC, IBV_QPT_UC, IBV_QPT_UD, IBV_QPT_RAW_PACKET or IBV_QPT_DRIVER */
 int                     sq_sig_all;     /* If set, each Work Request (WR) submitted to the SQ generates a completion entry */
 uint32_t                comp_mask;	/* Identifies valid fields */
 struct ibv_pd          *pd;		/* PD to be associated with the QP */
@@ -120,6 +120,9 @@ The attribute source_qpn is supported only on UD QP, without flow steering RX sh
 .PP
 .B ibv_destroy_qp()
 fails if the QP is attached to a multicast group.
+.PP
+.B IBV_QPT_DRIVER
+does not represent a specific service and is used for vendor specific QP logic.
 .SH "SEE ALSO"
 .BR ibv_alloc_pd (3),
 .BR ibv_modify_qp (3),
diff --git a/libibverbs/verbs.h b/libibverbs/verbs.h
index 7b53a6f..d9317df 100644
--- a/libibverbs/verbs.h
+++ b/libibverbs/verbs.h
@@ -797,7 +797,8 @@ enum ibv_qp_type {
 	IBV_QPT_UD,
 	IBV_QPT_RAW_PACKET = 8,
 	IBV_QPT_XRC_SEND = 9,
-	IBV_QPT_XRC_RECV
+	IBV_QPT_XRC_RECV,
+	IBV_QPT_DRIVER = 0xff,
 };
 
 struct ibv_qp_cap {
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
