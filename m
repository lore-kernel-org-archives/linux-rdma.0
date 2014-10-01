From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 12/21] IB/iser: Use internal polling budget to avoid possible live-lock
Date: Wed,  1 Oct 2014 14:02:08 +0300
Message-ID: <1412161337-25285-13-git-send-email-ogerlitz@mellanox.com>
References: <1412161337-25285-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1412161337-25285-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roi Dayan <roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ariel Nahum <arieln-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

We need a way to guarentee that we don't stay in soft-IRQ context
for too long. We might starve other pending CQ tasklets or worse
lock against application trying to issue IO on the running CPU.

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Roi Dayan <roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Ariel Nahum <arieln-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/iser/iser_verbs.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
index 94d1b46..e31ac57 100644
--- a/drivers/infiniband/ulp/iser/iser_verbs.c
+++ b/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -42,6 +42,8 @@
 #define ISER_MAX_RX_CQ_LEN	(ISER_QP_MAX_RECV_DTOS * ISCSI_ISER_MAX_CONN)
 #define ISER_MAX_TX_CQ_LEN	(ISER_QP_MAX_REQ_DTOS  * ISCSI_ISER_MAX_CONN)
 
+static int iser_cq_poll_limit = 512;
+
 static void iser_cq_tasklet_fn(unsigned long data);
 static void iser_cq_callback(struct ib_cq *cq, void *cq_context);
 static int iser_drain_tx_cq(struct iser_comp *comp);
@@ -1248,6 +1250,8 @@ static void iser_cq_tasklet_fn(unsigned long data)
 		completed_rx++;
 		if (!(completed_rx & 63))
 			completed_tx += iser_drain_tx_cq(comp);
+		if (completed_rx >= iser_cq_poll_limit)
+			break;
 	}
 	/* #warning "it is assumed here that arming CQ only once its empty" *
 	 * " would not cause interrupts to be missed"                       */
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
