From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH 2.6.37 04/11] RDMA/cxgb4: Ignore TERMINATE CQEs
Date: Fri, 10 Sep 2010 11:15:04 -0500
Message-ID: <20100910161503.6829.32566.stgit@build.ogc.int>
References: <20100910161442.6829.91594.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100910161442.6829.91594.stgit-T4OLL4TyM9aNDNWfRnPdfg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

T4 incorrectly inserts TERM CQEs into the CQ. Silently ignore them.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---

 drivers/infiniband/hw/cxgb4/cq.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/cq.c b/drivers/infiniband/hw/cxgb4/cq.c
index b3daf39..d902ed7 100644
--- a/drivers/infiniband/hw/cxgb4/cq.c
+++ b/drivers/infiniband/hw/cxgb4/cq.c
@@ -476,6 +476,11 @@ static int poll_cq(struct t4_wq *wq, struct t4_cq *cq, struct t4_cqe *cqe,
 		goto proc_cqe;
 	}
 
+	if (CQE_OPCODE(hw_cqe) == FW_RI_TERMINATE) {
+		ret = -EAGAIN;
+		goto skip_cqe;
+	}
+
 	/*
 	 * RECV completion.
 	 */
@@ -696,6 +701,7 @@ static int c4iw_poll_cq_one(struct c4iw_cq *chp, struct ib_wc *wc)
 		case T4_ERR_MSN_RANGE:
 		case T4_ERR_IRD_OVERFLOW:
 		case T4_ERR_OPCODE:
+		case T4_ERR_INTERNAL_ERR:
 			wc->status = IB_WC_FATAL_ERR;
 			break;
 		case T4_ERR_SWFLUSH:

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
