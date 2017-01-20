From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v3 29/37] IB/rxe: Switch from dma_device to dev.parent
Date: Fri, 20 Jan 2017 13:04:29 -0800
Message-ID: <20170120210437.26389-30-bart.vanassche@sandisk.com>
References: <20170120210437.26389-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170120210437.26389-1-bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Prepare for removal of ib_device.dma_device.

Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/sw/rxe/rxe_verbs.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_verbs.c b/drivers/infiniband/sw/rxe/rxe_verbs.c
index beb7021ff18a..b707fc3bca2a 100644
--- a/drivers/infiniband/sw/rxe/rxe_verbs.c
+++ b/drivers/infiniband/sw/rxe/rxe_verbs.c
@@ -168,7 +168,7 @@ static int rxe_query_pkey(struct ib_device *device,
 	struct rxe_port *port;
 
 	if (unlikely(port_num != 1)) {
-		dev_warn(device->dma_device, "invalid port_num = %d\n",
+		dev_warn(device->dev.parent, "invalid port_num = %d\n",
 			 port_num);
 		goto err1;
 	}
@@ -176,7 +176,7 @@ static int rxe_query_pkey(struct ib_device *device,
 	port = &rxe->port;
 
 	if (unlikely(index >= port->attr.pkey_tbl_len)) {
-		dev_warn(device->dma_device, "invalid index = %d\n",
+		dev_warn(device->dev.parent, "invalid index = %d\n",
 			 index);
 		goto err1;
 	}
@@ -1234,7 +1234,7 @@ int rxe_register_device(struct rxe_dev *rxe)
 	dev->node_type = RDMA_NODE_IB_CA;
 	dev->phys_port_cnt = 1;
 	dev->num_comp_vectors = RXE_NUM_COMP_VECTORS;
-	dev->dma_device = rxe->ifc_ops->dma_device(rxe);
+	dev->dev.parent = rxe->ifc_ops->dma_device(rxe);
 	dev->local_dma_lkey = 0;
 	dev->node_guid = rxe->ifc_ops->node_guid(rxe);
 	dev->dma_ops = &rxe_dma_mapping_ops;
-- 
2.11.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
