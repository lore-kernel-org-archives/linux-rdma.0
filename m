From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [rdma-rc 05/14] RDMA/core: Refactor get link layer wrapper
Date: Mon, 31 Jul 2017 10:09:15 +0300
Message-ID: <20170731070924.7193-6-leon@kernel.org>
References: <20170731070924.7193-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170731070924.7193-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The return values from rdma_node_get_transport() are strict
and IB_LINK_LAYER_UNSPECIFIED is unreachable in this flow.

Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/verbs.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 2db8cd7b95f1..1a30c5048ff8 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -192,18 +192,15 @@ EXPORT_SYMBOL(rdma_node_get_transport);

 enum rdma_link_layer rdma_port_get_link_layer(struct ib_device *device, u8 port_num)
 {
+	enum rdma_transport_type lt;
 	if (device->get_link_layer)
 		return device->get_link_layer(device, port_num);

-	switch (rdma_node_get_transport(device->node_type)) {
-	case RDMA_TRANSPORT_IB:
+	lt = rdma_node_get_transport(device->node_type);
+	if (lt == RDMA_TRANSPORT_IB)
 		return IB_LINK_LAYER_INFINIBAND;
-	case RDMA_TRANSPORT_IWARP:
-	case RDMA_TRANSPORT_USNIC_UDP:
-		return IB_LINK_LAYER_ETHERNET;
-	default:
-		return IB_LINK_LAYER_UNSPECIFIED;
-	}
+
+	return IB_LINK_LAYER_ETHERNET;
 }
 EXPORT_SYMBOL(rdma_port_get_link_layer);

--
2.13.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
