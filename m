From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [rdma-next 08/22] RDMA/core: Delete BUG() from unreachable flow
Date: Fri, 11 Aug 2017 13:49:49 +0300
Message-ID: <20170811105003.7661-9-leon@kernel.org>
References: <20170811105003.7661-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170811105003.7661-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Remove call to BUG() in case wrong node_type was provided.
This flow is unreachable, because node_types are supplied
from specific enum.

Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/verbs.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 21fef6b6d4f3..0d359a482b13 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -180,17 +180,13 @@ EXPORT_SYMBOL(ib_rate_to_mbps);
 __attribute_const__ enum rdma_transport_type
 rdma_node_get_transport(enum rdma_node_type node_type)
 {
-	switch (node_type) {
-	case RDMA_NODE_IB_CA:
+	if (node_type == RDMA_NODE_IB_CA)
 		return RDMA_TRANSPORT_IB;
-	case RDMA_NODE_RNIC:
+
+	if (node_type == RDMA_NODE_RNIC)
 		return RDMA_TRANSPORT_IWARP;
-	case RDMA_NODE_USNIC_UDP:
-		return RDMA_TRANSPORT_USNIC_UDP;
-	default:
-		BUG();
-		return 0;
-	}
+
+	return RDMA_TRANSPORT_USNIC_UDP;
 }
 EXPORT_SYMBOL(rdma_node_get_transport);
 
-- 
2.14.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
