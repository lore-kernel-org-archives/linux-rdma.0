From: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 2/7] IB/qib: decode path mtu optimization
Date: Fri, 23 Sep 2011 13:16:34 -0400
Message-ID: <20110923171634.14542.2853.stgit@kop-dev-sles11-04.qlogic.org>
References: <20110923171623.14542.78747.stgit@kop-dev-sles11-04.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110923171623.14542.78747.stgit-hIFRcJ1SNwcXGO8/Qfapyjg/wwJxntczYPYVAmT7z5s@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Store both the encoded and decoded mtu in the qp structure as a minor
optimization UC/RC receive routines.

Signed-off-by: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_qp.c    |    4 +++-
 drivers/infiniband/hw/qib/qib_rc.c    |    6 +++---
 drivers/infiniband/hw/qib/qib_uc.c    |    4 ++--
 drivers/infiniband/hw/qib/qib_verbs.h |    1 +
 4 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_qp.c b/drivers/infiniband/hw/qib/qib_qp.c
index e16751f..9d094f9 100644
--- a/drivers/infiniband/hw/qib/qib_qp.c
+++ b/drivers/infiniband/hw/qib/qib_qp.c
@@ -765,8 +765,10 @@ int qib_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 		}
 	}
 
-	if (attr_mask & IB_QP_PATH_MTU)
+	if (attr_mask & IB_QP_PATH_MTU) {
 		qp->path_mtu = pmtu;
+		qp->pmtu = ib_mtu_enum_to_int(pmtu);
+	}
 
 	if (attr_mask & IB_QP_RETRY_CNT) {
 		qp->s_retry_cnt = attr->retry_cnt;
diff --git a/drivers/infiniband/hw/qib/qib_rc.c b/drivers/infiniband/hw/qib/qib_rc.c
index 5c1c49b..5d77cb8 100644
--- a/drivers/infiniband/hw/qib/qib_rc.c
+++ b/drivers/infiniband/hw/qib/qib_rc.c
@@ -239,7 +239,7 @@ int qib_make_rc_req(struct qib_qp *qp)
 	u32 len;
 	u32 bth0;
 	u32 bth2;
-	u32 pmtu = ib_mtu_enum_to_int(qp->path_mtu);
+	u32 pmtu = qp->pmtu;
 	char newreq;
 	unsigned long flags;
 	int ret = 0;
@@ -1732,7 +1732,7 @@ static int qib_rc_rcv_error(struct qib_other_headers *ohdr,
 		 * same request.
 		 */
 		offset = ((psn - e->psn) & QIB_PSN_MASK) *
-			ib_mtu_enum_to_int(qp->path_mtu);
+			qp->pmtu;
 		len = be32_to_cpu(reth->length);
 		if (unlikely(offset + len != e->rdma_sge.sge_length))
 			goto unlock_done;
@@ -1876,7 +1876,7 @@ void qib_rc_rcv(struct qib_ctxtdata *rcd, struct qib_ib_header *hdr,
 	u32 psn;
 	u32 pad;
 	struct ib_wc wc;
-	u32 pmtu = ib_mtu_enum_to_int(qp->path_mtu);
+	u32 pmtu = qp->pmtu;
 	int diff;
 	struct ib_reth *reth;
 	unsigned long flags;
diff --git a/drivers/infiniband/hw/qib/qib_uc.c b/drivers/infiniband/hw/qib/qib_uc.c
index d31f33a..9a4630f 100644
--- a/drivers/infiniband/hw/qib/qib_uc.c
+++ b/drivers/infiniband/hw/qib/qib_uc.c
@@ -51,7 +51,7 @@ int qib_make_uc_req(struct qib_qp *qp)
 	u32 hwords;
 	u32 bth0;
 	u32 len;
-	u32 pmtu = ib_mtu_enum_to_int(qp->path_mtu);
+	u32 pmtu = qp->pmtu;
 	int ret = 0;
 
 	spin_lock_irqsave(&qp->s_lock, flags);
@@ -249,7 +249,7 @@ void qib_uc_rcv(struct qib_ibport *ibp, struct qib_ib_header *hdr,
 	u32 psn;
 	u32 pad;
 	struct ib_wc wc;
-	u32 pmtu = ib_mtu_enum_to_int(qp->path_mtu);
+	u32 pmtu = qp->pmtu;
 	struct ib_reth *reth;
 	int ret;
 
diff --git a/drivers/infiniband/hw/qib/qib_verbs.h b/drivers/infiniband/hw/qib/qib_verbs.h
index 95e5b47..ec3711f 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.h
+++ b/drivers/infiniband/hw/qib/qib_verbs.h
@@ -485,6 +485,7 @@ struct qib_qp {
 	u8 alt_timeout;         /* Alternate path timeout for this QP */
 	u8 port_num;
 	enum ib_mtu path_mtu;
+	u32 pmtu;		/* decoded from path_mtu */
 	u32 remote_qpn;
 	u32 qkey;               /* QKEY for this QP (for UD or RD) */
 	u32 s_size;             /* send work queue size */

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
