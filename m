From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 15/21] IB/iser: Optimize completion polling
Date: Wed,  1 Oct 2014 14:02:11 +0300
Message-ID: <1412161337-25285-16-git-send-email-ogerlitz@mellanox.com>
References: <1412161337-25285-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1412161337-25285-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roi Dayan <roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ariel Nahum <arieln-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Poll in batch of 16. Since we don't want it on the
stack, keep under iser completion context (iser_comp).

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/iser/iscsi_iser.h |    4 ++++
 drivers/infiniband/ulp/iser/iser_verbs.c |   12 +++++++-----
 2 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.h b/drivers/infiniband/ulp/iser/iscsi_iser.h
index 4fcb256..6c3743b 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.h
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.h
@@ -145,6 +145,8 @@
 					ISER_MAX_TX_MISC_PDUS         + \
 					ISER_MAX_RX_MISC_PDUS)
 
+#define ISER_WC_BATCH_COUNT   16
+
 #define ISER_VER			0x10
 #define ISER_WSV			0x08
 #define ISER_RSV			0x04
@@ -273,6 +275,7 @@ struct iscsi_iser_task;
  *
  * @device:     pointer to device handle
  * @cq:         completion queue
+ * @wcs:        work completion array
  * @tasklet:    Tasklet handle
  * @active_qps: Number of active QPs attached
  *              to completion context
@@ -280,6 +283,7 @@ struct iscsi_iser_task;
 struct iser_comp {
 	struct iser_device      *device;
 	struct ib_cq		*cq;
+	struct ib_wc		 wcs[ISER_WC_BATCH_COUNT];
 	struct tasklet_struct	 tasklet;
 	int                      active_qps;
 };
diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
index 805a9bd..82bedbc 100644
--- a/drivers/infiniband/ulp/iser/iser_verbs.c
+++ b/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -1232,13 +1232,15 @@ static void iser_cq_tasklet_fn(unsigned long data)
 {
 	struct iser_comp *comp = (struct iser_comp *)data;
 	struct ib_cq *cq = comp->cq;
-	struct ib_wc wc;
-	int completed = 0;
+	struct ib_wc *const wcs = comp->wcs;
+	int i, n, completed = 0;
 
-	while (ib_poll_cq(cq, 1, &wc) == 1) {
-		iser_handle_wc(&wc);
+	while ((n = ib_poll_cq(cq, ARRAY_SIZE(comp->wcs), wcs)) > 0) {
+		for (i = 0; i < n; i++)
+			iser_handle_wc(&wcs[i]);
 
-		if (++completed >= iser_cq_poll_limit)
+		completed += n;
+		if (completed >= iser_cq_poll_limit)
 			break;
 	}
 
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
