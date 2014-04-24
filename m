From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH 3.15-rc3--to=roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org 3/3] iw_cxgb4: only allow
	kernel db ringing for T4 devs
Date: Thu, 24 Apr 2014 14:31:02 -0500
Message-ID: <20140424193101.27784.74460.stgit@build.ogc.int>
References: <20140424193051.27784.22311.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140424193051.27784.22311.stgit-T4OLL4TyM9aNDNWfRnPdfg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The whole db drop avoidance stuff is for T4 only.  So we cannot allow
that to be enabled for T5 devices.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---

 drivers/infiniband/hw/cxgb4/qp.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/qp.c b/drivers/infiniband/hw/cxgb4/qp.c
index f18ef34..086f62f 100644
--- a/drivers/infiniband/hw/cxgb4/qp.c
+++ b/drivers/infiniband/hw/cxgb4/qp.c
@@ -1777,11 +1777,15 @@ int c4iw_ib_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 	/*
 	 * Use SQ_PSN and RQ_PSN to pass in IDX_INC values for
 	 * ringing the queue db when we're in DB_FULL mode.
+	 * Only allow this on T4 devices.
 	 */
 	attrs.sq_db_inc = attr->sq_psn;
 	attrs.rq_db_inc = attr->rq_psn;
 	mask |= (attr_mask & IB_QP_SQ_PSN) ? C4IW_QP_ATTR_SQ_DB : 0;
 	mask |= (attr_mask & IB_QP_RQ_PSN) ? C4IW_QP_ATTR_RQ_DB : 0;
+	if (is_t5(to_c4iw_qp(ibqp)->rhp->rdev.lldi.adapter_type) &&
+	    (mask & (C4IW_QP_ATTR_SQ_DB|C4IW_QP_ATTR_RQ_DB)))
+		return -EINVAL;
 
 	return c4iw_modify_qp(rhp, qhp, mask, &attrs, 0);
 }

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
