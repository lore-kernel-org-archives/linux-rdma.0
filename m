From: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 13/14] RDMA/ocrdma: set vlan present bit for user AH
Date: Thu, 18 Dec 2014 14:13:07 +0530
Message-ID: <74a00d42-5bd8-408d-9059-11e0f327379b@CMEXHTCAS1.ad.emulex.com>
References: <1418892188-6623-1-git-send-email-devesh.sharma@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1418892188-6623-1-git-send-email-devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Mitesh Ahuja <mitesh.ahuja-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

For the AH that describs a VLAN interface details, vlan present bit
needs to be set during posting a WQE. This patch adds the code to
allow it happening.

Signed-off-by: Mitesh Ahuja <mitesh.ahuja-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma_ah.c    |   19 +++++++++++++------
 drivers/infiniband/hw/ocrdma/ocrdma_ah.h    |    6 ++++++
 drivers/infiniband/hw/ocrdma/ocrdma_sli.h   |    1 +
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c |    2 ++
 4 files changed, 22 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_ah.c b/drivers/infiniband/hw/ocrdma/ocrdma_ah.c
index b80b57b..d812904 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_ah.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_ah.c
@@ -40,10 +40,11 @@
 #define OCRDMA_VID_PCP_SHIFT	0xD
 
 static inline int set_av_attr(struct ocrdma_dev *dev, struct ocrdma_ah *ah,
-			struct ib_ah_attr *attr, union ib_gid *sgid, int pdid)
+			struct ib_ah_attr *attr, union ib_gid *sgid,
+			int pdid, bool *isvlan)
 {
 	int status = 0;
-	u16 vlan_tag; bool vlan_enabled = false;
+	u16 vlan_tag;
 	struct ocrdma_eth_vlan eth;
 	struct ocrdma_grh grh;
 	int eth_sz;
@@ -61,7 +62,7 @@ static inline int set_av_attr(struct ocrdma_dev *dev, struct ocrdma_ah *ah,
 		vlan_tag |= (dev->sl & 0x07) << OCRDMA_VID_PCP_SHIFT;
 		eth.vlan_tag = cpu_to_be16(vlan_tag);
 		eth_sz = sizeof(struct ocrdma_eth_vlan);
-		vlan_enabled = true;
+		*isvlan = true;
 	} else {
 		eth.eth_type = cpu_to_be16(OCRDMA_ROCE_ETH_TYPE);
 		eth_sz = sizeof(struct ocrdma_eth_basic);
@@ -84,7 +85,7 @@ static inline int set_av_attr(struct ocrdma_dev *dev, struct ocrdma_ah *ah,
 	/* Eth HDR */
 	memcpy(&ah->av->eth_hdr, &eth, eth_sz);
 	memcpy((u8 *)ah->av + eth_sz, &grh, sizeof(struct ocrdma_grh));
-	if (vlan_enabled)
+	if (*isvlan)
 		ah->av->valid |= OCRDMA_AV_VLAN_VALID;
 	ah->av->valid = cpu_to_le32(ah->av->valid);
 	return status;
@@ -93,6 +94,7 @@ static inline int set_av_attr(struct ocrdma_dev *dev, struct ocrdma_ah *ah,
 struct ib_ah *ocrdma_create_ah(struct ib_pd *ibpd, struct ib_ah_attr *attr)
 {
 	u32 *ahid_addr;
+	bool isvlan = false;
 	int status;
 	struct ocrdma_ah *ah;
 	struct ocrdma_pd *pd = get_ocrdma_pd(ibpd);
@@ -129,15 +131,20 @@ struct ib_ah *ocrdma_create_ah(struct ib_pd *ibpd, struct ib_ah_attr *attr)
 		}
 	}
 
-	status = set_av_attr(dev, ah, attr, &sgid, pd->id);
+	status = set_av_attr(dev, ah, attr, &sgid, pd->id, &isvlan);
 	if (status)
 		goto av_conf_err;
 
 	/* if pd is for the user process, pass the ah_id to user space */
 	if ((pd->uctx) && (pd->uctx->ah_tbl.va)) {
 		ahid_addr = pd->uctx->ah_tbl.va + attr->dlid;
-		*ahid_addr = ah->id;
+		*ahid_addr = 0;
+		*ahid_addr |= ah->id & OCRDMA_AH_ID_MASK;
+		if (isvlan)
+			*ahid_addr |= (OCRDMA_AH_VLAN_VALID_MASK <<
+				       OCRDMA_AH_VLAN_VALID_SHIFT);
 	}
+
 	return &ah->ibah;
 
 av_conf_err:
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_ah.h b/drivers/infiniband/hw/ocrdma/ocrdma_ah.h
index 8ac49e7..726a87c 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_ah.h
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_ah.h
@@ -28,6 +28,12 @@
 #ifndef __OCRDMA_AH_H__
 #define __OCRDMA_AH_H__
 
+enum {
+	OCRDMA_AH_ID_MASK		= 0x3FF,
+	OCRDMA_AH_VLAN_VALID_MASK	= 0x01,
+	OCRDMA_AH_VLAN_VALID_SHIFT	= 0x1F
+};
+
 struct ib_ah *ocrdma_create_ah(struct ib_pd *, struct ib_ah_attr *);
 int ocrdma_destroy_ah(struct ib_ah *);
 int ocrdma_query_ah(struct ib_ah *, struct ib_ah_attr *);
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_sli.h b/drivers/infiniband/hw/ocrdma/ocrdma_sli.h
index 801883a..243c87c 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_sli.h
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_sli.h
@@ -1734,6 +1734,7 @@ enum {
 	OCRDMA_FLAG_FENCE_R	= 0x8,
 	OCRDMA_FLAG_SOLICIT	= 0x10,
 	OCRDMA_FLAG_IMM		= 0x20,
+	OCRDMA_FLAG_AH_VLAN_PR  = 0x40,
 
 	/* Stag flags */
 	OCRDMA_LKEY_FLAG_LOCAL_WR	= 0x1,
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
index 27def39..5732a63 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
@@ -1937,6 +1937,8 @@ static void ocrdma_build_ud_hdr(struct ocrdma_qp *qp,
 	else
 		ud_hdr->qkey = wr->wr.ud.remote_qkey;
 	ud_hdr->rsvd_ahid = ah->id;
+	if (ah->av->valid & OCRDMA_AV_VLAN_VALID)
+		hdr->cw |= (OCRDMA_FLAG_AH_VLAN_PR << OCRDMA_WQE_FLAGS_SHIFT);
 }
 
 static void ocrdma_build_sges(struct ocrdma_hdr_wqe *hdr,
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
