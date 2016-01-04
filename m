From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V1 for-next 1/2] IB/core: Rename rdma_addr_find_dmac_by_grh
Date: Mon,  4 Jan 2016 10:49:53 +0200
Message-ID: <1451897394-24525-2-git-send-email-matanb@mellanox.com>
References: <1451897394-24525-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1451897394-24525-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Somnath Kotur <Somnath.Kotur-idTK6quXuVSLFuii7jzJGg@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

rdma_addr_find_dmac_by_grh resolves dmac, vlan_id and if_index and
downsteram patch will also add hop_limit as an output parameter,
thus we rename it to rdma_addr_find_l2_eth_by_grh.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/addr.c           |  7 ++++---
 drivers/infiniband/core/verbs.c          | 18 +++++++++---------
 drivers/infiniband/hw/ocrdma/ocrdma_ah.c |  6 +++---
 include/rdma/ib_addr.h                   |  5 +++--
 4 files changed, 19 insertions(+), 17 deletions(-)

diff --git a/drivers/infiniband/core/addr.c b/drivers/infiniband/core/addr.c
index 0b5f245..ce3c68e 100644
--- a/drivers/infiniband/core/addr.c
+++ b/drivers/infiniband/core/addr.c
@@ -540,8 +540,9 @@ static void resolve_cb(int status, struct sockaddr *src_addr,
 	complete(&((struct resolve_cb_context *)context)->comp);
 }
 
-int rdma_addr_find_dmac_by_grh(const union ib_gid *sgid, const union ib_gid *dgid,
-			       u8 *dmac, u16 *vlan_id, int *if_index)
+int rdma_addr_find_l2_eth_by_grh(const union ib_gid *sgid,
+				 const union ib_gid *dgid,
+				 u8 *dmac, u16 *vlan_id, int *if_index)
 {
 	int ret = 0;
 	struct rdma_dev_addr dev_addr;
@@ -583,7 +584,7 @@ int rdma_addr_find_dmac_by_grh(const union ib_gid *sgid, const union ib_gid *dgi
 	dev_put(dev);
 	return ret;
 }
-EXPORT_SYMBOL(rdma_addr_find_dmac_by_grh);
+EXPORT_SYMBOL(rdma_addr_find_l2_eth_by_grh);
 
 int rdma_addr_find_smac_by_sgid(union ib_gid *sgid, u8 *smac, u16 *vlan_id)
 {
diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 072b94d..66eb498 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -467,11 +467,11 @@ int ib_init_ah_from_wc(struct ib_device *device, u8 port_num,
 		if (!idev)
 			return -ENODEV;
 
-		ret = rdma_addr_find_dmac_by_grh(&dgid, &sgid,
-						 ah_attr->dmac,
-						 wc->wc_flags & IB_WC_WITH_VLAN ?
-						 NULL : &vlan_id,
-						 &if_index);
+		ret = rdma_addr_find_l2_eth_by_grh(&dgid, &sgid,
+						   ah_attr->dmac,
+						   wc->wc_flags & IB_WC_WITH_VLAN ?
+						   NULL : &vlan_id,
+						   &if_index);
 		if (ret) {
 			dev_put(idev);
 			return ret;
@@ -1158,10 +1158,10 @@ int ib_resolve_eth_dmac(struct ib_qp *qp,
 
 			ifindex = sgid_attr.ndev->ifindex;
 
-			ret = rdma_addr_find_dmac_by_grh(&sgid,
-							 &qp_attr->ah_attr.grh.dgid,
-							 qp_attr->ah_attr.dmac,
-							 NULL, &ifindex);
+			ret = rdma_addr_find_l2_eth_by_grh(&sgid,
+							   &qp_attr->ah_attr.grh.dgid,
+							   qp_attr->ah_attr.dmac,
+							   NULL, &ifindex);
 
 			dev_put(sgid_attr.ndev);
 		}
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_ah.c b/drivers/infiniband/hw/ocrdma/ocrdma_ah.c
index a343e03..850e0d1 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_ah.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_ah.c
@@ -152,9 +152,9 @@ struct ib_ah *ocrdma_create_ah(struct ib_pd *ibpd, struct ib_ah_attr *attr)
 	if ((pd->uctx) &&
 	    (!rdma_is_multicast_addr((struct in6_addr *)attr->grh.dgid.raw)) &&
 	    (!rdma_link_local_addr((struct in6_addr *)attr->grh.dgid.raw))) {
-		status = rdma_addr_find_dmac_by_grh(&sgid, &attr->grh.dgid,
-						    attr->dmac, &vlan_tag,
-						    &sgid_attr.ndev->ifindex);
+		status = rdma_addr_find_l2_eth_by_grh(&sgid, &attr->grh.dgid,
+						      attr->dmac, &vlan_tag,
+						      &sgid_attr.ndev->ifindex);
 		if (status) {
 			pr_err("%s(): Failed to resolve dmac from gid." 
 				"status = %d\n", __func__, status);
diff --git a/include/rdma/ib_addr.h b/include/rdma/ib_addr.h
index 87156dc..73fd088 100644
--- a/include/rdma/ib_addr.h
+++ b/include/rdma/ib_addr.h
@@ -130,8 +130,9 @@ int rdma_copy_addr(struct rdma_dev_addr *dev_addr, struct net_device *dev,
 int rdma_addr_size(struct sockaddr *addr);
 
 int rdma_addr_find_smac_by_sgid(union ib_gid *sgid, u8 *smac, u16 *vlan_id);
-int rdma_addr_find_dmac_by_grh(const union ib_gid *sgid, const union ib_gid *dgid,
-			       u8 *smac, u16 *vlan_id, int *if_index);
+int rdma_addr_find_l2_eth_by_grh(const union ib_gid *sgid,
+				 const union ib_gid *dgid,
+				 u8 *smac, u16 *vlan_id, int *if_index);
 
 static inline u16 ib_addr_get_pkey(struct rdma_dev_addr *dev_addr)
 {
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
