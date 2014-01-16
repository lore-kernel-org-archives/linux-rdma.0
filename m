From: Upinder Malhi <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 2/2] IB/usnic: Advertise usNIC devices as RDMA_NODE_USNIC_UDP
Date: Wed, 15 Jan 2014 17:02:37 -0800
Message-ID: <1389834157-16635-3-git-send-email-umalhi@cisco.com>
References: <1389834157-16635-1-git-send-email-umalhi@cisco.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1389834157-16635-1-git-send-email-umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: Upinder Malhi <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

usNIC default transport is UDP.  Hence, advertise
RDMA_NODE_USNIC_UDP by default for usNIC devices.

Signed-off-by: Upinder Malhi <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/usnic/usnic_ib_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/usnic/usnic_ib_main.c b/drivers/infiniband/hw/usnic/usnic_ib_main.c
index 7d2efd4..fb6d026 100644
--- a/drivers/infiniband/hw/usnic/usnic_ib_main.c
+++ b/drivers/infiniband/hw/usnic/usnic_ib_main.c
@@ -332,7 +332,7 @@ static void *usnic_ib_device_add(struct pci_dev *dev)
 	us_ibdev->pdev = dev;
 	us_ibdev->netdev = pci_get_drvdata(dev);
 	us_ibdev->ib_dev.owner = THIS_MODULE;
-	us_ibdev->ib_dev.node_type = RDMA_NODE_USNIC;
+	us_ibdev->ib_dev.node_type = RDMA_NODE_USNIC_UDP;
 	us_ibdev->ib_dev.phys_port_cnt = USNIC_IB_PORT_CNT;
 	us_ibdev->ib_dev.num_comp_vectors = USNIC_IB_NUM_COMP_VECTORS;
 	us_ibdev->ib_dev.dma_device = &dev->dev;
-- 
1.8.2.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
