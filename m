From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [rdma-next 3/8] RDMA/core: Provide node type flags
Date: Tue, 15 Aug 2017 12:14:26 +0300
Message-ID: <20170815091431.12822-4-leon@kernel.org>
References: <20170815091431.12822-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170815091431.12822-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Expose node types for the user space applications.

Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 include/rdma/ib_verbs.h  | 7 -------
 include/uapi/rdma/rdma.h | 7 +++++++
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index bfedcda04ef7..0aced267cc53 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -93,13 +93,6 @@ struct ib_gid_attr {
 	struct net_device	*ndev;
 };
 
-enum rdma_node_type {
-	/* IB values map to NodeInfo:NodeType. */
-	RDMA_NODE_IB_CA		= 1,
-	RDMA_NODE_RNIC		= 4,
-	RDMA_NODE_USNIC_UDP	= 6,
-};
-
 enum {
 	/* set the local administered indication */
 	IB_SA_WELL_KNOWN_GUID	= BIT_ULL(57) | 2,
diff --git a/include/uapi/rdma/rdma.h b/include/uapi/rdma/rdma.h
index dcdf61474118..75c1baad313b 100644
--- a/include/uapi/rdma/rdma.h
+++ b/include/uapi/rdma/rdma.h
@@ -103,4 +103,11 @@ enum rdma_dev_cap {
 	RDMA_DEV_RAW_SCATTER_FCS		= (1ULL << 34),
 	RDMA_DEV_RDMA_NETDEV_OPA_VNIC		= (1ULL << 35),
 };
+
+enum rdma_node_type {
+	/* IB values map to NodeInfo:NodeType. */
+	RDMA_NODE_IB_CA		= 1,
+	RDMA_NODE_RNIC		= 4,
+	RDMA_NODE_USNIC_UDP	= 6,
+};
 #endif /* _RDMA_H */
-- 
2.14.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
