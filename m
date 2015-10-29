From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 28/26] IB/ipath: Remove fast registration from the code
Date: Thu, 29 Oct 2015 17:33:32 +0200
Message-ID: <1446132812-20170-2-git-send-email-sagig@mellanox.com>
References: <1446132812-20170-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1446132812-20170-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The driver does not support it anyway, and the support
should be added to a generic layer shared by both hfi1,
qib and softroce drivers.

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/staging/rdma/ipath/ipath_verbs.c |    3 ---
 drivers/staging/rdma/ipath/ipath_verbs.h |    1 -
 2 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/rdma/ipath/ipath_verbs.c b/drivers/staging/rdma/ipath/ipath_verbs.c
index 15633ec..29e9179 100644
--- a/drivers/staging/rdma/ipath/ipath_verbs.c
+++ b/drivers/staging/rdma/ipath/ipath_verbs.c
@@ -399,9 +399,6 @@ static int ipath_post_one_send(struct ipath_qp *qp, struct ib_send_wr *wr)
 	if (qp->ibqp.qp_type != IB_QPT_UC &&
 	    qp->ibqp.qp_type != IB_QPT_RC)
 		memcpy(&wqe->ud_wr, ud_wr(wr), sizeof(wqe->ud_wr));
-	else if (wr->opcode == IB_WR_FAST_REG_MR)
-		memcpy(&wqe->fast_reg_wr, fast_reg_wr(wr),
-			sizeof(wqe->fast_reg_wr));
 	else if (wr->opcode == IB_WR_RDMA_WRITE_WITH_IMM ||
 		 wr->opcode == IB_WR_RDMA_WRITE ||
 		 wr->opcode == IB_WR_RDMA_READ)
diff --git a/drivers/staging/rdma/ipath/ipath_verbs.h b/drivers/staging/rdma/ipath/ipath_verbs.h
index ed102a2..0a90a56 100644
--- a/drivers/staging/rdma/ipath/ipath_verbs.h
+++ b/drivers/staging/rdma/ipath/ipath_verbs.h
@@ -280,7 +280,6 @@ struct ipath_swqe {
 	union {
 		struct ib_send_wr wr;   /* don't use wr.sg_list */
 		struct ib_ud_wr ud_wr;
-		struct ib_fast_reg_wr fast_reg_wr;
 		struct ib_rdma_wr rdma_wr;
 		struct ib_atomic_wr atomic_wr;
 	};
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
