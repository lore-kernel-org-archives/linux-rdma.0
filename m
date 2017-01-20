From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v3 16/37] IB/cxgb4: Set dev.parent instead of dma_device
Date: Fri, 20 Jan 2017 13:04:16 -0800
Message-ID: <20170120210437.26389-17-bart.vanassche@sandisk.com>
References: <20170120210437.26389-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170120210437.26389-1-bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Hariprasad S <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Prepare for removal of ib_device.dma_device.

Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Hariprasad S <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/provider.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/cxgb4/provider.c b/drivers/infiniband/hw/cxgb4/provider.c
index 49b51b7e0fd7..6daf6d95e620 100644
--- a/drivers/infiniband/hw/cxgb4/provider.c
+++ b/drivers/infiniband/hw/cxgb4/provider.c
@@ -569,7 +569,7 @@ int c4iw_register_device(struct c4iw_dev *dev)
 	memcpy(dev->ibdev.node_desc, C4IW_NODE_DESC, sizeof(C4IW_NODE_DESC));
 	dev->ibdev.phys_port_cnt = dev->rdev.lldi.nports;
 	dev->ibdev.num_comp_vectors =  dev->rdev.lldi.nciq;
-	dev->ibdev.dma_device = &(dev->rdev.lldi.pdev->dev);
+	dev->ibdev.dev.parent = &dev->rdev.lldi.pdev->dev;
 	dev->ibdev.query_device = c4iw_query_device;
 	dev->ibdev.query_port = c4iw_query_port;
 	dev->ibdev.query_pkey = c4iw_query_pkey;
-- 
2.11.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
