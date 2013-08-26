From: <bgottumukka-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 03/14] RDMA/ocrdma: Removed the mtu check based eth mtu.
Date: Mon, 26 Aug 2013 15:27:40 +0530
Message-ID: <88eb2e47-1abd-493a-b96a-72136ab33913@CMEXHTCAS1.ad.emulex.com>
References: <1377511071-16967-1-git-send-email-bgottumukka@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1377511071-16967-1-git-send-email-bgottumukka-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Naresh Gottumukkala <bgottumukkala-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Naresh Gottumukkala <bgottumukkala-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>

Also increase MAX AH to 512.

Signed-off-by: Naresh Gottumukkala <bgottumukkala-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c    | 6 ++----
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c | 2 +-
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
index af3c5f5..6a62b23 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
@@ -2102,8 +2102,6 @@ static int ocrdma_set_qp_params(struct ocrdma_qp *qp,
 				enum ib_qp_state old_qps)
 {
 	int status = 0;
-	struct net_device *netdev = qp->dev->nic_info.netdev;
-	int eth_mtu = iboe_get_mtu(netdev->mtu);
 
 	if (attr_mask & IB_QP_PKEY_INDEX) {
 		cmd->params.path_mtu_pkey_indx |= (attrs->pkey_index &
@@ -2140,8 +2138,8 @@ static int ocrdma_set_qp_params(struct ocrdma_qp *qp,
 		cmd->flags |= OCRDMA_QP_PARA_DST_QPN_VALID;
 	}
 	if (attr_mask & IB_QP_PATH_MTU) {
-		if (ib_mtu_enum_to_int(eth_mtu) <
-		    ib_mtu_enum_to_int(attrs->path_mtu)) {
+		if (attrs->path_mtu < IB_MTU_256 ||
+		    attrs->path_mtu > IB_MTU_4096) {
 			status = -EINVAL;
 			goto pmtu_err;
 		}
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
index d700946..cc88c6d 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
@@ -75,7 +75,7 @@ int ocrdma_query_device(struct ib_device *ibdev, struct ib_device_attr *attr)
 	attr->vendor_part_id = dev->nic_info.pdev->device;
 	attr->hw_ver = 0;
 	attr->max_qp = dev->attr.max_qp;
-	attr->max_ah = dev->attr.max_qp;
+	attr->max_ah = OCRDMA_MAX_AH;
 	attr->max_qp_wr = dev->attr.max_wqe;
 
 	attr->device_cap_flags = IB_DEVICE_CURR_QP_STATE_MOD |
-- 
1.8.2.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
