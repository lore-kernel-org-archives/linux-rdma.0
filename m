From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-3.17 1/3] IB/iser: Fix RX/TX CQ resource leak on error flow
Date: Tue,  2 Sep 2014 15:57:08 +0300
Message-ID: <1409662630-28269-2-git-send-email-ogerlitz@mellanox.com>
References: <1409662630-28269-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1409662630-28269-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roi Dayan <roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Roi Dayan <roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

When failing to allocate TX CQ we already allocated RX CQ, so we need to make
sure we release it. Also, when failing to register notification to the RX CQ
we currently leak both RX and TX CQs of the current index, fix that too.

Signed-off-by: Roi Dayan <roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/iser/iser_verbs.c |   24 ++++++++++++++----------
 1 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
index 3ef167f..3bfec4b 100644
--- a/drivers/infiniband/ulp/iser/iser_verbs.c
+++ b/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -73,7 +73,7 @@ static int iser_create_device_ib_res(struct iser_device *device)
 {
 	struct iser_cq_desc *cq_desc;
 	struct ib_device_attr *dev_attr = &device->dev_attr;
-	int ret, i, j;
+	int ret, i;
 
 	ret = ib_query_device(device->ib_device, dev_attr);
 	if (ret) {
@@ -125,16 +125,20 @@ static int iser_create_device_ib_res(struct iser_device *device)
 					  iser_cq_event_callback,
 					  (void *)&cq_desc[i],
 					  ISER_MAX_RX_CQ_LEN, i);
-		if (IS_ERR(device->rx_cq[i]))
+		if (IS_ERR(device->rx_cq[i])) {
+			device->rx_cq[i] = NULL;
 			goto cq_err;
+		}
 
 		device->tx_cq[i] = ib_create_cq(device->ib_device,
 					  NULL, iser_cq_event_callback,
 					  (void *)&cq_desc[i],
 					  ISER_MAX_TX_CQ_LEN, i);
 
-		if (IS_ERR(device->tx_cq[i]))
+		if (IS_ERR(device->tx_cq[i])) {
+			device->tx_cq[i] = NULL;
 			goto cq_err;
+		}
 
 		if (ib_req_notify_cq(device->rx_cq[i], IB_CQ_NEXT_COMP))
 			goto cq_err;
@@ -160,14 +164,14 @@ static int iser_create_device_ib_res(struct iser_device *device)
 handler_err:
 	ib_dereg_mr(device->mr);
 dma_mr_err:
-	for (j = 0; j < device->cqs_used; j++)
-		tasklet_kill(&device->cq_tasklet[j]);
+	for (i = 0; i < device->cqs_used; i++)
+		tasklet_kill(&device->cq_tasklet[i]);
 cq_err:
-	for (j = 0; j < i; j++) {
-		if (device->tx_cq[j])
-			ib_destroy_cq(device->tx_cq[j]);
-		if (device->rx_cq[j])
-			ib_destroy_cq(device->rx_cq[j]);
+	for (i = 0; i < device->cqs_used; i++) {
+		if (device->tx_cq[i])
+			ib_destroy_cq(device->tx_cq[i]);
+		if (device->rx_cq[i])
+			ib_destroy_cq(device->rx_cq[i]);
 	}
 	ib_dealloc_pd(device->pd);
 pd_err:
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
