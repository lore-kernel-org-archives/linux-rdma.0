From: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH REPOST 1/2] RDMA/ocrdma: resolve L2 address when creating user AH
Date: Fri, 5 Sep 2014 19:22:12 +0530
Message-ID: <b24e758c-9542-4d29-bbae-cdc4a184e66c@CMEXHTCAS2.ad.emulex.com>
References: <1409925133-14794-1-git-send-email-devesh.sharma@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1409925133-14794-1-git-send-email-devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

In view of IP based GID, user space AH's must have
MAC and Vlan id resolved separately. Presently,
user AHs are broken for ocrdma.
This patch resolves l2 addresses while creating user AH.
and obtains the right DMAC and vlan-id before creating AH.

Signed-off-by: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma_ah.c |   41 ++++++++++++++++++++++--------
 1 files changed, 30 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_ah.c b/drivers/infiniband/hw/ocrdma/ocrdma_ah.c
index 40f8536..8d21e33 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_ah.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_ah.c
@@ -38,7 +38,7 @@
 #define OCRDMA_VID_PCP_SHIFT	0xD
 
 static inline int set_av_attr(struct ocrdma_dev *dev, struct ocrdma_ah *ah,
-				struct ib_ah_attr *attr, int pdid)
+			struct ib_ah_attr *attr, union ib_gid *sgid, int pdid)
 {
 	int status = 0;
 	u16 vlan_tag; bool vlan_enabled = false;
@@ -49,8 +49,7 @@ static inline int set_av_attr(struct ocrdma_dev *dev, struct ocrdma_ah *ah,
 	memset(&eth, 0, sizeof(eth));
 	memset(&grh, 0, sizeof(grh));
 
-	ah->sgid_index = attr->grh.sgid_index;
-
+	/* VLAN */
 	vlan_tag = attr->vlan_id;
 	if (!vlan_tag || (vlan_tag > 0xFFF))
 		vlan_tag = dev->pvid;
@@ -65,15 +64,14 @@ static inline int set_av_attr(struct ocrdma_dev *dev, struct ocrdma_ah *ah,
 		eth.eth_type = cpu_to_be16(OCRDMA_ROCE_ETH_TYPE);
 		eth_sz = sizeof(struct ocrdma_eth_basic);
 	}
+	/* MAC */
 	memcpy(&eth.smac[0], &dev->nic_info.mac_addr[0], ETH_ALEN);
-	memcpy(&eth.dmac[0], attr->dmac, ETH_ALEN);
 	status = ocrdma_resolve_dmac(dev, attr, &eth.dmac[0]);
 	if (status)
 		return status;
-	status = ocrdma_query_gid(&dev->ibdev, 1, attr->grh.sgid_index,
-			(union ib_gid *)&grh.sgid[0]);
-	if (status)
-		return status;
+	ah->sgid_index = attr->grh.sgid_index;
+	memcpy(&grh.sgid[0], sgid->raw, sizeof(union ib_gid));
+	memcpy(&grh.dgid[0], attr->grh.dgid.raw, sizeof(attr->grh.dgid.raw));
 
 	grh.tclass_flow = cpu_to_be32((6 << 28) |
 			(attr->grh.traffic_class << 24) |
@@ -81,8 +79,7 @@ static inline int set_av_attr(struct ocrdma_dev *dev, struct ocrdma_ah *ah,
 	/* 0x1b is next header value in GRH */
 	grh.pdid_hoplimit = cpu_to_be32((pdid << 16) |
 			(0x1b << 8) | attr->grh.hop_limit);
-
-	memcpy(&grh.dgid[0], attr->grh.dgid.raw, sizeof(attr->grh.dgid.raw));
+	/* Eth HDR */
 	memcpy(&ah->av->eth_hdr, &eth, eth_sz);
 	memcpy((u8 *)ah->av + eth_sz, &grh, sizeof(struct ocrdma_grh));
 	if (vlan_enabled)
@@ -98,6 +95,8 @@ struct ib_ah *ocrdma_create_ah(struct ib_pd *ibpd, struct ib_ah_attr *attr)
 	struct ocrdma_ah *ah;
 	struct ocrdma_pd *pd = get_ocrdma_pd(ibpd);
 	struct ocrdma_dev *dev = get_ocrdma_dev(ibpd->device);
+	union ib_gid sgid;
+	u8 zmac[ETH_ALEN];
 
 	if (!(attr->ah_flags & IB_AH_GRH))
 		return ERR_PTR(-EINVAL);
@@ -111,7 +110,27 @@ struct ib_ah *ocrdma_create_ah(struct ib_pd *ibpd, struct ib_ah_attr *attr)
 	status = ocrdma_alloc_av(dev, ah);
 	if (status)
 		goto av_err;
-	status = set_av_attr(dev, ah, attr, pd->id);
+
+	status = ocrdma_query_gid(&dev->ibdev, 1, attr->grh.sgid_index, &sgid);
+	if (status) {
+		pr_err("%s(): Failed to query sgid, status = %d\n",
+		       __func__, status);
+		goto av_conf_err;
+	}
+
+	memset(&zmac, 0, ETH_ALEN);
+	if (pd->uctx &&
+	    memcmp(attr->dmac, &zmac, ETH_ALEN)) {
+		status = rdma_addr_find_dmac_by_grh(&sgid, &attr->grh.dgid,
+						    attr->dmac, &attr->vlan_id);
+		if (status) {
+			pr_err("%s(): Failed to resolve dmac from gid. status = %d\n",
+			       __func__, status);
+			goto av_conf_err;
+		}
+	}
+
+	status = set_av_attr(dev, ah, attr, &sgid, pd->id);
 	if (status)
 		goto av_conf_err;
 
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
