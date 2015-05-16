From: Selvin Xavier <selvin.xavier-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Subject: [PATCH for-4.1 07/11] RDMA/ocrdma: Fix dmac resolution for link local address
Date: Sat, 16 May 2015 13:21:45 +0530
Message-ID: <1431762709-20740-8-git-send-email-selvin.xavier@avagotech.com>
References: <1431762709-20740-1-git-send-email-selvin.xavier@avagotech.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1431762709-20740-1-git-send-email-selvin.xavier-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Mitesh Ahuja <mitesh.ahuja-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>

rdma_addr_find_dmac_by_grh fails to resolve dmac for link local address.
Use rdma_get_ll_mac to resolve the link local address.

Signed-off-by: Padmanabh Ratnakar <padmanabh.ratnakar-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Signed-off-by: Mitesh Ahuja <mitesh.ahuja-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Signed-off-by: Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Signed-off-by: Selvin Xavier <selvin.xavier-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma.h    | 2 ++
 drivers/infiniband/hw/ocrdma/ocrdma_ah.c | 4 +++-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma.h b/drivers/infiniband/hw/ocrdma/ocrdma.h
index c9780d9..ee9e335 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma.h
+++ b/drivers/infiniband/hw/ocrdma/ocrdma.h
@@ -515,6 +515,8 @@ static inline int ocrdma_resolve_dmac(struct ocrdma_dev *dev,
 	memcpy(&in6, ah_attr->grh.dgid.raw, sizeof(in6));
 	if (rdma_is_multicast_addr(&in6))
 		rdma_get_mcast_mac(&in6, mac_addr);
+	else if (rdma_link_local_addr(&in6))
+		rdma_get_ll_mac(&in6, mac_addr);
 	else
 		memcpy(mac_addr, ah_attr->dmac, ETH_ALEN);
 	return 0;
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_ah.c b/drivers/infiniband/hw/ocrdma/ocrdma_ah.c
index 2a5993b..f5a5ea836 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_ah.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_ah.c
@@ -127,7 +127,9 @@ struct ib_ah *ocrdma_create_ah(struct ib_pd *ibpd, struct ib_ah_attr *attr)
 		goto av_conf_err;
 	}
 
-	if (pd->uctx) {
+	if ((pd->uctx) &&
+	    (!rdma_is_multicast_addr((struct in6_addr *)attr->grh.dgid.raw)) &&
+	    (!rdma_link_local_addr((struct in6_addr *)attr->grh.dgid.raw))) {
 		status = rdma_addr_find_dmac_by_grh(&sgid, &attr->grh.dgid,
                                         attr->dmac, &attr->vlan_id);
 		if (status) {
-- 
2.2.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
