From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 2/4] RDMA/ocrdma: Make needlessly global functions/structs static
Date: Tue, 24 Apr 2012 16:49:43 -0700
Message-ID: <1335311385-11381-3-git-send-email-roland@kernel.org>
References: <1335311385-11381-1-git-send-email-roland@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1335311385-11381-1-git-send-email-roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Parav Pandit <parav.pandit-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>

Signed-off-by: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c   |   12 ++++++------
 drivers/infiniband/hw/ocrdma/ocrdma_main.c |    6 +++---
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
index 025c4a9..00a460e 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
@@ -159,7 +159,7 @@ enum ib_qp_state get_ibqp_state(enum ocrdma_qp_state qps)
 	return IB_QPS_ERR;
 }
 
-enum ocrdma_qp_state get_ocrdma_qp_state(enum ib_qp_state qps)
+static enum ocrdma_qp_state get_ocrdma_qp_state(enum ib_qp_state qps)
 {
 	switch (qps) {
 	case IB_QPS_RESET:
@@ -384,8 +384,8 @@ static void ocrdma_free_eq_vect_gen2(struct ocrdma_dev *dev)
 	dev->nic_info.msix.start_vector -= 1;
 }
 
-int ocrdma_mbx_delete_q(struct ocrdma_dev *dev, struct ocrdma_queue_info *q,
-			int queue_type)
+static int ocrdma_mbx_delete_q(struct ocrdma_dev *dev, struct ocrdma_queue_info *q,
+			       int queue_type)
 {
 	u8 opcode = 0;
 	int status;
@@ -516,9 +516,9 @@ static void ocrdma_destroy_qp_eqs(struct ocrdma_dev *dev)
 		ocrdma_destroy_eq(dev, &dev->qp_eq_tbl[i]);
 }
 
-int ocrdma_mbx_mq_cq_create(struct ocrdma_dev *dev,
-			    struct ocrdma_queue_info *cq,
-			    struct ocrdma_queue_info *eq)
+static int ocrdma_mbx_mq_cq_create(struct ocrdma_dev *dev,
+				   struct ocrdma_queue_info *cq,
+				   struct ocrdma_queue_info *eq)
 {
 	struct ocrdma_create_cq_cmd *cmd = dev->mbx_cmd;
 	struct ocrdma_create_cq_cmd_rsp *rsp = dev->mbx_cmd;
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_main.c b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
index 8aa3416..cee201e 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_main.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
@@ -58,7 +58,7 @@ static struct notifier_block ocrdma_inet6addr_notifier = {
 	.notifier_call = ocrdma_inet6addr_event
 };
 
-int ocrdma_get_instance(void)
+static int ocrdma_get_instance(void)
 {
 	int instance = 0;
 
@@ -265,7 +265,7 @@ static enum rdma_link_layer ocrdma_link_layer(struct ib_device *device,
 	return IB_LINK_LAYER_ETHERNET;
 }
 
-int ocrdma_register_device(struct ocrdma_dev *dev)
+static int ocrdma_register_device(struct ocrdma_dev *dev)
 {
 	strlcpy(dev->ibdev.name, "ocrdma%d", IB_DEVICE_NAME_MAX);
 	ocrdma_get_guid(dev, (u8 *)&dev->ibdev.node_guid);
@@ -528,7 +528,7 @@ static void ocrdma_event_handler(struct ocrdma_dev *dev, u32 event)
 	};
 }
 
-struct ocrdma_driver ocrdma_drv = {
+static struct ocrdma_driver ocrdma_drv = {
 	.name			= "ocrdma_driver",
 	.add			= ocrdma_add,
 	.remove			= ocrdma_remove,
-- 
1.7.9.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
