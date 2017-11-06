From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 10/11] IB/hfi1: Mask upper 16Bits of Extended LID
 prior to rvt_cq_entry
Date: Mon, 06 Nov 2017 06:39:22 -0800
Message-ID: <20171106143920.27539.6677.stgit@scvm10.sc.intel.com>
References: <20171106143510.27539.65950.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171106143510.27539.65950.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Pass only the lower 16Bits of an Extended LIDs to rvt_cq_entry
to avoid triggering a WARN_ON_ONCE during conversion there.
These upper 16Bits are okay to drop as they are obtained elsewhere.

Fixes: 62ede7779904 ("Add OPA extended LID support")
Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/rc.c  |    2 +-
 drivers/infiniband/hw/hfi1/ruc.c |    2 +-
 drivers/infiniband/hw/hfi1/uc.c  |    2 +-
 drivers/infiniband/hw/hfi1/ud.c  |    6 +++---
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/rc.c b/drivers/infiniband/hw/hfi1/rc.c
index 3f21b05..fd01a76 100644
--- a/drivers/infiniband/hw/hfi1/rc.c
+++ b/drivers/infiniband/hw/hfi1/rc.c
@@ -2219,7 +2219,7 @@ void hfi1_rc_rcv(struct hfi1_packet *packet)
 			wc.opcode = IB_WC_RECV;
 		wc.qp = &qp->ibqp;
 		wc.src_qp = qp->remote_qpn;
-		wc.slid = rdma_ah_get_dlid(&qp->remote_ah_attr);
+		wc.slid = rdma_ah_get_dlid(&qp->remote_ah_attr) & U16_MAX;
 		/*
 		 * It seems that IB mandates the presence of an SL in a
 		 * work completion only for the UD transport (see section
diff --git a/drivers/infiniband/hw/hfi1/ruc.c b/drivers/infiniband/hw/hfi1/ruc.c
index d450d4d..1a3ed6e 100644
--- a/drivers/infiniband/hw/hfi1/ruc.c
+++ b/drivers/infiniband/hw/hfi1/ruc.c
@@ -560,7 +560,7 @@ static void ruc_loopback(struct rvt_qp *sqp)
 	wc.byte_len = wqe->length;
 	wc.qp = &qp->ibqp;
 	wc.src_qp = qp->remote_qpn;
-	wc.slid = rdma_ah_get_dlid(&qp->remote_ah_attr);
+	wc.slid = rdma_ah_get_dlid(&qp->remote_ah_attr) & U16_MAX;
 	wc.sl = rdma_ah_get_sl(&qp->remote_ah_attr);
 	wc.port_num = 1;
 	/* Signal completion event if the solicited bit is set. */
diff --git a/drivers/infiniband/hw/hfi1/uc.c b/drivers/infiniband/hw/hfi1/uc.c
index fcd8186..1ee80a5 100644
--- a/drivers/infiniband/hw/hfi1/uc.c
+++ b/drivers/infiniband/hw/hfi1/uc.c
@@ -462,7 +462,7 @@ void hfi1_uc_rcv(struct hfi1_packet *packet)
 		wc.status = IB_WC_SUCCESS;
 		wc.qp = &qp->ibqp;
 		wc.src_qp = qp->remote_qpn;
-		wc.slid = rdma_ah_get_dlid(&qp->remote_ah_attr);
+		wc.slid = rdma_ah_get_dlid(&qp->remote_ah_attr) & U16_MAX;
 		/*
 		 * It seems that IB mandates the presence of an SL in a
 		 * work completion only for the UD transport (see section
diff --git a/drivers/infiniband/hw/hfi1/ud.c b/drivers/infiniband/hw/hfi1/ud.c
index 84c7dbe..5260b27 100644
--- a/drivers/infiniband/hw/hfi1/ud.c
+++ b/drivers/infiniband/hw/hfi1/ud.c
@@ -265,8 +265,8 @@ static void ud_loopback(struct rvt_qp *sqp, struct rvt_swqe *swqe)
 	} else {
 		wc.pkey_index = 0;
 	}
-	wc.slid = ppd->lid | (rdma_ah_get_path_bits(ah_attr) &
-				   ((1 << ppd->lmc) - 1));
+	wc.slid = (ppd->lid | (rdma_ah_get_path_bits(ah_attr) &
+				   ((1 << ppd->lmc) - 1))) & U16_MAX;
 	/* Check for loopback when the port lid is not set */
 	if (wc.slid == 0 && sqp->ibqp.qp_type == IB_QPT_GSI)
 		wc.slid = be16_to_cpu(IB_LID_PERMISSIVE);
@@ -1037,7 +1037,7 @@ void hfi1_ud_rcv(struct hfi1_packet *packet)
 	}
 	if (slid_is_permissive)
 		slid = be32_to_cpu(OPA_LID_PERMISSIVE);
-	wc.slid = slid;
+	wc.slid = slid & U16_MAX;
 	wc.sl = sl_from_sc;
 
 	/*

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
