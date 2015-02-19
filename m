From: Somnath Kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 17/30] RDMA/ocrdma: changes to support user AH creation
Date: Fri, 20 Feb 2015 03:32:32 +0530
Message-ID: <c5d825cb-2fc5-42b4-9f64-0258fd677b26@CMEXHTCAS2.ad.emulex.com>
References: <1424383365-19337-1-git-send-email-somnath.kotur@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1424383365-19337-1-git-send-email-somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Somnath Kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>

To support user space AH this uses ahid field to convey
l3-type to user space library. The library is responsible
for decoding the l3-type out of ahid.

Signed-off-by: Somnath Kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma_ah.c |    5 +++++
 drivers/infiniband/hw/ocrdma/ocrdma_ah.h |    5 +++--
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_ah.c b/drivers/infiniband/hw/ocrdma/ocrdma_ah.c
index 70a885b..b42fa24 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_ah.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_ah.c
@@ -190,6 +190,11 @@ struct ib_ah *ocrdma_create_ah(struct ib_pd *ibpd, struct ib_ah_attr *attr)
 		ahid_addr = pd->uctx->ah_tbl.va + attr->dlid;
 		*ahid_addr = 0;
 		*ahid_addr |= ah->id & OCRDMA_AH_ID_MASK;
+		if (ocrdma_is_rocev2_supported(dev)) {
+			*ahid_addr |= ((u32)ah->hdr_type &
+				       OCRDMA_AH_L3_TYPE_MASK) <<
+				       OCRDMA_AH_L3_TYPE_SHIFT;
+		}
 		if (isvlan)
 			*ahid_addr |= (OCRDMA_AH_VLAN_VALID_MASK <<
 				       OCRDMA_AH_VLAN_VALID_SHIFT);
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_ah.h b/drivers/infiniband/hw/ocrdma/ocrdma_ah.h
index 726a87c..ed45ecd 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_ah.h
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_ah.h
@@ -31,9 +31,10 @@
 enum {
 	OCRDMA_AH_ID_MASK		= 0x3FF,
 	OCRDMA_AH_VLAN_VALID_MASK	= 0x01,
-	OCRDMA_AH_VLAN_VALID_SHIFT	= 0x1F
+	OCRDMA_AH_VLAN_VALID_SHIFT	= 0x1F,
+	OCRDMA_AH_L3_TYPE_MASK		= 0x03,
+	OCRDMA_AH_L3_TYPE_SHIFT		= 0x1D /* 29 bits */
 };
-
 struct ib_ah *ocrdma_create_ah(struct ib_pd *, struct ib_ah_attr *);
 int ocrdma_destroy_ah(struct ib_ah *);
 int ocrdma_query_ah(struct ib_ah *, struct ib_ah_attr *);
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
