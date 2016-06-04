From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-rc 1/7] IB/core: Fix query port failure in RoCE
Date: Sat,  4 Jun 2016 15:15:18 +0300
Message-ID: <1465042524-25852-2-git-send-email-leon@kernel.org>
References: <1465042524-25852-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1465042524-25852-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Currently ib_query_port always attempts to to read the subnet prefix by
calling ib_query_gid(). For RoCE there is no subnet manager and no
subnet prefix. Fix this by querying GID[0] only for IB networks.

Fixes: fad61ad4e755 ('IB/core: Add subnet prefix to port info')
Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/core/device.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index 5516fb0..05e25a3 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -661,6 +661,9 @@ int ib_query_port(struct ib_device *device,
 	if (err || port_attr->subnet_prefix)
 		return err;
 
+	if (rdma_port_get_link_layer(device, port_num) != IB_LINK_LAYER_INFINIBAND)
+		return 0;
+
 	err = ib_query_gid(device, port_num, 0, &gid, NULL);
 	if (err)
 		return err;
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
