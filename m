From: Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Subject: [PATCH 4/4] RDMA/ocrdma: Support user AH creation for RoCE-v2
Date: Thu, 28 Jan 2016 08:59:59 -0500
Message-ID: <1453989599-21307-5-git-send-email-devesh.sharma@avagotech.com>
References: <1453989599-21307-1-git-send-email-devesh.sharma@avagotech.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1453989599-21307-1-git-send-email-devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, Somnath Kotur <somnath.kotur-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch adds support to create RoCE-v2 compatible AH. It uses ahid
field to tell network-header-type to user space library. The library
has to decode network-header-type from ahid field.

Signed-off-by: Somnath Kotur <somnath.kotur-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Signed-off-by: Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma_ah.c | 5 +++++
 drivers/infiniband/hw/ocrdma/ocrdma_ah.h | 5 +++--
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_ah.c b/drivers/infiniband/hw/ocrdma/ocrdma_ah.c
index 4aed1db..e3c4f17 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_ah.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_ah.c
@@ -218,6 +218,11 @@ struct ib_ah *ocrdma_create_ah(struct ib_pd *ibpd, struct ib_ah_attr *attr)
 		ahid_addr = pd->uctx->ah_tbl.va + attr->dlid;
 		*ahid_addr = 0;
 		*ahid_addr |= ah->id & OCRDMA_AH_ID_MASK;
+		if (ocrdma_is_udp_encap_supported(dev)) {
+			*ahid_addr |= ((u32)ah->hdr_type &
+				       OCRDMA_AH_L3_TYPE_MASK) <<
+				       OCRDMA_AH_L3_TYPE_SHIFT;
+		}
 		if (isvlan)
 			*ahid_addr |= (OCRDMA_AH_VLAN_VALID_MASK <<
 				       OCRDMA_AH_VLAN_VALID_SHIFT);
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_ah.h b/drivers/infiniband/hw/ocrdma/ocrdma_ah.h
index 04a30ae..3856dd4 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_ah.h
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_ah.h
@@ -46,9 +46,10 @@
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
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
