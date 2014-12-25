From: Somnath Kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 5/6] RDMA/ocrdma: changes to support user AH creation
Date: Thu, 25 Dec 2014 06:30:07 +0530
Message-ID: <0ad8bb8e-0cad-4c59-a539-343fdac6a33a@CMEXHTCAS2.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Somnath Kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>

To support user space AH this uses ahid field to convey
l3-type to user space library. The library is responsible
for decoding the l3-type out of ahid.

Signed-off-by: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Somnath Kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma_ah.c |    5 +++++
 drivers/infiniband/hw/ocrdma/ocrdma_ah.h |    4 +++-
 2 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_ah.c b/drivers/infiniband/hw/ocrdma/ocrdma_ah.c
index 803476b..5b326dd 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_ah.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_ah.c
@@ -200,6 +200,11 @@ struct ib_ah *ocrdma_create_ah(struct ib_pd *ibpd, struct ib_ah_attr *attr)
 		if (isvlan)
 			*ahid_addr |= (OCRDMA_AH_VLAN_VALID_MASK <<
 				       OCRDMA_AH_VLAN_VALID_SHIFT);
+		if (dev->attr.roce_flags & OCRDMA_L3_TYPE_IPV4 ||
+		    dev->attr.roce_flags & OCRDMA_L3_TYPE_IPV6)
+			*ahid_addr |= ((u32)ah->hdr_type &
+				       OCRDMA_AH_L3_TYPE_MASK) <<
+				       OCRDMA_AH_L3_TYPE_SHIFT;
 	}
 
 	return &ah->ibah;
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_ah.h b/drivers/infiniband/hw/ocrdma/ocrdma_ah.h
index 726a87c..59d9277 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_ah.h
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_ah.h
@@ -31,7 +31,9 @@
 enum {
 	OCRDMA_AH_ID_MASK		= 0x3FF,
 	OCRDMA_AH_VLAN_VALID_MASK	= 0x01,
-	OCRDMA_AH_VLAN_VALID_SHIFT	= 0x1F
+	OCRDMA_AH_VLAN_VALID_SHIFT	= 0x1F,
+	OCRDMA_AH_L3_TYPE_MASK		= 0x03,
+	OCRDMA_AH_L3_TYPE_SHIFT		= 0x1D /* 29 bits */
 };
 
 struct ib_ah *ocrdma_create_ah(struct ib_pd *, struct ib_ah_attr *);
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
