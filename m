From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH libibverbs 3/4] add RAW Packet QP type
Date: Tue, 17 Jan 2012 13:41:03 +0200
Message-ID: <alpine.LRH.2.00.1201171340380.26871@ogerlitz.voltaire.com>
References: <alpine.LRH.2.00.1201171330540.24946@ogerlitz.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.LRH.2.00.1201171330540.24946-VYr5/9ddeaGSIdy2EShu12Xnswh1EIUO@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Applications that use this qp type should build the whole packet,
including link level headers when sending. On the receive side, the
HW isn't expected to strip any headers. Only processes with the NET_RAW
capability may open such qp. The name raw packet was selected to
resemble the similarity to AF_PACKET / SOL_RAW sockets.

Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 include/infiniband/verbs.h |    3 ++-
 man/ibv_create_qp.3        |    2 +-
 man/ibv_modify_qp.3        |   10 ++++++++++
 3 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/include/infiniband/verbs.h b/include/infiniband/verbs.h
index 6acfc81..8ed8a66 100644
--- a/include/infiniband/verbs.h
+++ b/include/infiniband/verbs.h
@@ -399,7 +399,8 @@ struct ibv_srq_init_attr {
 enum ibv_qp_type {
 	IBV_QPT_RC = 2,
 	IBV_QPT_UC,
-	IBV_QPT_UD
+	IBV_QPT_UD,
+	IBV_QPT_RAW_PACKET = 8
 };

 struct ibv_qp_cap {
diff --git a/man/ibv_create_qp.3 b/man/ibv_create_qp.3
index 5301ad8..7feeab2 100644
--- a/man/ibv_create_qp.3
+++ b/man/ibv_create_qp.3
@@ -28,7 +28,7 @@ struct ibv_cq          *send_cq;        /* CQ to be associated with the Send Que
 struct ibv_cq          *recv_cq;        /* CQ to be associated with the Receive Queue (RQ) */
 struct ibv_srq         *srq;            /* SRQ handle if QP is to be associated with an SRQ, otherwise NULL */
 struct ibv_qp_cap       cap;            /* QP capabilities */
-enum ibv_qp_type        qp_type;        /* QP Transport Service Type: IBV_QPT_RC, IBV_QPT_UC, or IBV_QPT_UD */
+enum ibv_qp_type        qp_type;        /* QP Transport Service Type: IBV_QPT_RC, IBV_QPT_UC, IBV_QPT_UD or IBV_QPT_RAW_PACKET */
 int                     sq_sig_all;     /* If set, each Work Request (WR) submitted to the SQ generates a completion entry */
 .in -8
 };
diff --git a/man/ibv_modify_qp.3 b/man/ibv_modify_qp.3
index 9eabcdf..cb3faaa 100644
--- a/man/ibv_modify_qp.3
+++ b/man/ibv_modify_qp.3
@@ -159,6 +159,16 @@ RTR  \fB          IBV_QP_STATE, IBV_QP_AV, IBV_QP_PATH_MTU, \fR
 RTS  \fB          IBV_QP_STATE, IBV_QP_SQ_PSN, IBV_QP_MAX_QP_RD_ATOMIC, \fR
      \fB          IBV_QP_RETRY_CNT, IBV_QP_RNR_RETRY, IBV_QP_TIMEOUT \fR
 .fi
+.PP
+.nf
+For QP Transport Service Type \fB IBV_QPT_RAW_PACKET\fR:
+.sp
+Next state     Required attributes
+\-\-\-\-\-\-\-\-\-\-     \-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-
+Init \fB          IBV_QP_STATE, IBV_QP_PORT\fR
+RTR  \fB          IBV_QP_STATE\fR
+RTS  \fB          IBV_QP_STATE\fR
+.fi
 .SH "SEE ALSO"
 .BR ibv_create_qp (3),
 .BR ibv_destroy_qp (3),
-- 
1.7.1



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
