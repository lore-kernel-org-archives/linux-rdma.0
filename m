From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] IPoIB: set dev_id field of IPoIB net_device
Date: Mon, 20 Sep 2010 09:05:06 +0200
Message-ID: <20100920070506.GA12453@mtldesk30>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Use the net device's dev_id field to encode the port number of the pci device.
This can be used to to associate a net device with the pci device's port. The
encoding is: dev_id = port - 1.

Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib_main.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index b4b2257..30d2333 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -1240,6 +1240,7 @@ static struct net_device *ipoib_add_port(const char *format,
 		goto alloc_mem_failed;
 
 	SET_NETDEV_DEV(priv->dev, hca->dma_device);
+	priv->dev->dev_id = port - 1;
 
 	if (!ib_query_port(hca, port, &attr))
 		priv->max_ib_mtu = ib_mtu_enum_to_int(attr.max_mtu);
-- 
1.7.2.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
