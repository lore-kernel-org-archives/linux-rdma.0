From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v2 2/2] iser-target: Remove explicit mlx4 work-around
Date: Wed, 28 Oct 2015 13:28:16 +0200
Message-ID: <1446031696-19022-3-git-send-email-sagig@mellanox.com>
References: <1446031696-19022-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1446031696-19022-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The driver now exposes sufficient limits so we can
avoid having mlx4 specific work-around.

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---
 drivers/infiniband/ulp/isert/ib_isert.c |   13 +++----------
 1 files changed, 3 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 96336a9..eb985f9 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -141,16 +141,9 @@ isert_create_qp(struct isert_conn *isert_conn,
 	attr.recv_cq = comp->cq;
 	attr.cap.max_send_wr = ISERT_QP_MAX_REQ_DTOS;
 	attr.cap.max_recv_wr = ISERT_QP_MAX_RECV_DTOS + 1;
-	/*
-	 * FIXME: Use devattr.max_sge - 2 for max_send_sge as
-	 * work-around for RDMA_READs with ConnectX-2.
-	 *
-	 * Also, still make sure to have at least two SGEs for
-	 * outgoing control PDU responses.
-	 */
-	attr.cap.max_send_sge = max(2, device->ib_device->max_sge - 2);
-	isert_conn->max_sge = attr.cap.max_send_sge;
-
+	attr.cap.max_send_sge = device->ib_device->max_sge;
+	isert_conn->max_sge = min(device->ib_device->max_sge,
+				  device->ib_device->max_sge_rd);
 	attr.cap.max_recv_sge = 1;
 	attr.sq_sig_type = IB_SIGNAL_REQ_WR;
 	attr.qp_type = IB_QPT_RC;
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
