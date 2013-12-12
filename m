From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V6 for-next 5/7] IB/ocrdma: Handle Ethernet L2 parameters for IP based GID addressing
Date: Thu, 12 Dec 2013 18:03:15 +0200
Message-ID: <1386864197-10591-6-git-send-email-ogerlitz@mellanox.com>
References: <1386864197-10591-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1386864197-10591-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Naresh Gottumukkala <bgottumukkala-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

This patch is similar in spirit to the "IB/mlx4: Handle Ethernet L2 parameters for
IP based GID addressing". It handles the fact that IP based RoCE gids
don't store Ethernet L2 parameters, MAC and VLAN.

When building an address handle, instead of parsing the dgid to
get the MAC and VLAN, take them from the address handle attributes.

Cc: Naresh Gottumukkala <bgottumukkala-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma.h    |   12 ++++++++++++
 drivers/infiniband/hw/ocrdma/ocrdma_ah.c |    5 +++--
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c |   21 ++-------------------
 drivers/infiniband/hw/ocrdma/ocrdma_hw.h |    1 -
 4 files changed, 17 insertions(+), 22 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma.h b/drivers/infiniband/hw/ocrdma/ocrdma.h
index 294dd27..7c001b9 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma.h
+++ b/drivers/infiniband/hw/ocrdma/ocrdma.h
@@ -423,5 +423,17 @@ static inline int is_cqe_wr_imm(struct ocrdma_cqe *cqe)
 		OCRDMA_CQE_WRITE_IMM) ? 1 : 0;
 }
 
+static inline int ocrdma_resolve_dmac(struct ocrdma_dev *dev,
+		struct ib_ah_attr *ah_attr, u8 *mac_addr)
+{
+	struct in6_addr in6;
+
+	memcpy(&in6, ah_attr->grh.dgid.raw, sizeof(in6));
+	if (rdma_is_multicast_addr(&in6))
+		rdma_get_mcast_mac(&in6, mac_addr);
+	else
+		memcpy(mac_addr, ah_attr->dmac, ETH_ALEN);
+	return 0;
+}
 
 #endif
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_ah.c b/drivers/infiniband/hw/ocrdma/ocrdma_ah.c
index ee499d9..bbb7962 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_ah.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_ah.c
@@ -49,7 +49,7 @@ static inline int set_av_attr(struct ocrdma_dev *dev, struct ocrdma_ah *ah,
 
 	ah->sgid_index = attr->grh.sgid_index;
 
-	vlan_tag = rdma_get_vlan_id(&attr->grh.dgid);
+	vlan_tag = attr->vlan_id;
 	if (!vlan_tag || (vlan_tag > 0xFFF))
 		vlan_tag = dev->pvid;
 	if (vlan_tag && (vlan_tag < 0x1000)) {
@@ -64,7 +64,8 @@ static inline int set_av_attr(struct ocrdma_dev *dev, struct ocrdma_ah *ah,
 		eth_sz = sizeof(struct ocrdma_eth_basic);
 	}
 	memcpy(&eth.smac[0], &dev->nic_info.mac_addr[0], ETH_ALEN);
-	status = ocrdma_resolve_dgid(dev, &attr->grh.dgid, &eth.dmac[0]);
+	memcpy(&eth.dmac[0], attr->dmac, ETH_ALEN);
+	status = ocrdma_resolve_dmac(dev, attr, &eth.dmac[0]);
 	if (status)
 		return status;
 	status = ocrdma_query_gid(&dev->ibdev, 1, attr->grh.sgid_index,
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
index 56bf32f..1664d64 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
@@ -2076,23 +2076,6 @@ mbx_err:
 	return status;
 }
 
-int ocrdma_resolve_dgid(struct ocrdma_dev *dev, union ib_gid *dgid,
-			u8 *mac_addr)
-{
-	struct in6_addr in6;
-
-	memcpy(&in6, dgid, sizeof in6);
-	if (rdma_is_multicast_addr(&in6)) {
-		rdma_get_mcast_mac(&in6, mac_addr);
-	} else if (rdma_link_local_addr(&in6)) {
-		rdma_get_ll_mac(&in6, mac_addr);
-	} else {
-		pr_err("%s() fail to resolve mac_addr.\n", __func__);
-		return -EINVAL;
-	}
-	return 0;
-}
-
 static int ocrdma_set_av_params(struct ocrdma_qp *qp,
 				struct ocrdma_modify_qp *cmd,
 				struct ib_qp_attr *attrs)
@@ -2126,14 +2109,14 @@ static int ocrdma_set_av_params(struct ocrdma_qp *qp,
 
 	qp->sgid_idx = ah_attr->grh.sgid_index;
 	memcpy(&cmd->params.sgid[0], &sgid.raw[0], sizeof(cmd->params.sgid));
-	ocrdma_resolve_dgid(qp->dev, &ah_attr->grh.dgid, &mac_addr[0]);
+	ocrdma_resolve_dmac(qp->dev, ah_attr, &mac_addr[0]);
 	cmd->params.dmac_b0_to_b3 = mac_addr[0] | (mac_addr[1] << 8) |
 				(mac_addr[2] << 16) | (mac_addr[3] << 24);
 	/* convert them to LE format. */
 	ocrdma_cpu_to_le32(&cmd->params.dgid[0], sizeof(cmd->params.dgid));
 	ocrdma_cpu_to_le32(&cmd->params.sgid[0], sizeof(cmd->params.sgid));
 	cmd->params.vlan_dmac_b4_to_b5 = mac_addr[4] | (mac_addr[5] << 8);
-	vlan_id = rdma_get_vlan_id(&sgid);
+	vlan_id = ah_attr->vlan_id;
 	if (vlan_id && (vlan_id < 0x1000)) {
 		cmd->params.vlan_dmac_b4_to_b5 |=
 		    vlan_id << OCRDMA_QP_PARAMS_VLAN_SHIFT;
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_hw.h b/drivers/infiniband/hw/ocrdma/ocrdma_hw.h
index f2a89d4..82fe332 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_hw.h
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_hw.h
@@ -94,7 +94,6 @@ void ocrdma_ring_cq_db(struct ocrdma_dev *, u16 cq_id, bool armed,
 int ocrdma_mbx_get_link_speed(struct ocrdma_dev *dev, u8 *lnk_speed);
 int ocrdma_query_config(struct ocrdma_dev *,
 			struct ocrdma_mbx_query_config *config);
-int ocrdma_resolve_dgid(struct ocrdma_dev *, union ib_gid *dgid, u8 *mac_addr);
 
 int ocrdma_mbx_alloc_pd(struct ocrdma_dev *, struct ocrdma_pd *);
 int ocrdma_mbx_dealloc_pd(struct ocrdma_dev *, struct ocrdma_pd *);
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
