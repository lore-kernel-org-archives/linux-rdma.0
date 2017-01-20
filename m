From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v3 15/37] IB/cxgb3: Set dev.parent instead of dma_device
Date: Fri, 20 Jan 2017 13:04:15 -0800
Message-ID: <20170120210437.26389-16-bart.vanassche@sandisk.com>
References: <20170120210437.26389-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170120210437.26389-1-bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Steve Wise <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Prepare for removal of ib_device.dma_device.

Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Steve Wise <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
---
 drivers/infiniband/hw/cxgb3/iwch_provider.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/cxgb3/iwch_provider.c b/drivers/infiniband/hw/cxgb3/iwch_provider.c
index 9d5fe1853da4..8db71dcb4599 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_provider.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_provider.c
@@ -1401,7 +1401,7 @@ int iwch_register_device(struct iwch_dev *dev)
 	memcpy(dev->ibdev.node_desc, IWCH_NODE_DESC, sizeof(IWCH_NODE_DESC));
 	dev->ibdev.phys_port_cnt = dev->rdev.port_info.nports;
 	dev->ibdev.num_comp_vectors = 1;
-	dev->ibdev.dma_device = &(dev->rdev.rnic_info.pdev->dev);
+	dev->ibdev.dev.parent = &dev->rdev.rnic_info.pdev->dev;
 	dev->ibdev.query_device = iwch_query_device;
 	dev->ibdev.query_port = iwch_query_port;
 	dev->ibdev.query_pkey = iwch_query_pkey;
-- 
2.11.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
