From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 1/4] ib/mlx4: fix SL to 8021q priority-bits settings under
 IBoE
Date: Sun, 11 Dec 2011 16:40:05 +0200
Message-ID: <alpine.LRH.2.00.1112111639360.32736@ogerlitz.voltaire.com>
References: <alpine.LRH.2.00.1112111638020.32736@ogerlitz.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.LRH.2.00.1112111638020.32736-VYr5/9ddeaGSIdy2EShu12Xnswh1EIUO@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Under IBoE, SLs 0-7 are mapped to Ethernet 8021q user priority bits
(pbits) which are part of the VLAN tag, SLs 8-15 are reserved.

Under Ethernet, the ConnectX firmware treats (decode/encode) the four
bit SL field in various constructs such as QPC / UD WQE / CQE as PPP0
and not as 0PPP. This correlates well to the fact that within the
vlan tag the pbits are located in bits 15-13 and not 12-14.

The current code wasn't consistent around that area - the
encoding was correct for the IBoE QPC.path.schedule_queue field,
but was wrong for IBoE CQEs and when MLX header was built.

These inconsistencies resulted in wrong SL <--> wire 8021q bpits
mappings, which are fixed by using SL <--> PPP0 all around the place.

Signed-off-by: Oren Duer <oren-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/ah.c |    2 +-
 drivers/infiniband/hw/mlx4/cq.c |    6 +++++-
 drivers/infiniband/hw/mlx4/qp.c |    4 ++--
 3 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/ah.c b/drivers/infiniband/hw/mlx4/ah.c
index 4b8f9c4..a251bec 100644
--- a/drivers/infiniband/hw/mlx4/ah.c
+++ b/drivers/infiniband/hw/mlx4/ah.c
@@ -126,7 +126,7 @@ static struct ib_ah *create_iboe_ah(struct ib_pd *pd, struct ib_ah_attr *ah_attr
 		ah->av.ib.dlid = cpu_to_be16(0xc000);

 	memcpy(ah->av.eth.dgid, ah_attr->grh.dgid.raw, 16);
-	ah->av.eth.sl_tclass_flowlabel = cpu_to_be32(ah_attr->sl << 28);
+	ah->av.eth.sl_tclass_flowlabel = cpu_to_be32(ah_attr->sl << 29);

 	return &ah->ibah;
 }
diff --git a/drivers/infiniband/hw/mlx4/cq.c b/drivers/infiniband/hw/mlx4/cq.c
index e8df155..5ecf38d 100644
--- a/drivers/infiniband/hw/mlx4/cq.c
+++ b/drivers/infiniband/hw/mlx4/cq.c
@@ -715,13 +715,17 @@ repoll:
 		}

 		wc->slid	   = be16_to_cpu(cqe->rlid);
-		wc->sl		   = be16_to_cpu(cqe->sl_vid) >> 12;
 		g_mlpath_rqpn	   = be32_to_cpu(cqe->g_mlpath_rqpn);
 		wc->src_qp	   = g_mlpath_rqpn & 0xffffff;
 		wc->dlid_path_bits = (g_mlpath_rqpn >> 24) & 0x7f;
 		wc->wc_flags	  |= g_mlpath_rqpn & 0x80000000 ? IB_WC_GRH : 0;
 		wc->pkey_index     = be32_to_cpu(cqe->immed_rss_invalid) & 0x7f;
 		wc->csum_ok	   = mlx4_ib_ipoib_csum_ok(cqe->status, cqe->checksum);
+		if (rdma_port_get_link_layer(wc->qp->device,
+				(*cur_qp)->port) == IB_LINK_LAYER_ETHERNET)
+			wc->sl  = be16_to_cpu(cqe->sl_vid) >> 13;
+		else
+			wc->sl  = be16_to_cpu(cqe->sl_vid) >> 12;
 	}

 	return 0;
diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index a16f0c8..aa2aefa 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -962,7 +962,7 @@ static int mlx4_set_path(struct mlx4_ib_dev *dev, const struct ib_ah_attr *ah,

 	if (is_eth) {
 		path->sched_queue = MLX4_IB_DEFAULT_SCHED_QUEUE |
-			((port - 1) << 6) | ((ah->sl & 7) << 3) | ((ah->sl & 8) >> 1);
+			((port - 1) << 6) | ((ah->sl & 7) << 3);

 		if (!(ah->ah_flags & IB_AH_GRH))
 			return -1;
@@ -1437,7 +1437,7 @@ static int build_mlx_header(struct mlx4_ib_sqp *sqp, struct ib_send_wr *wr,
 			u16 pcp;

 			sqp->ud_header.vlan.type = cpu_to_be16(MLX4_IB_IBOE_ETHERTYPE);
-			pcp = (be32_to_cpu(ah->av.ib.sl_tclass_flowlabel) >> 27 & 3) << 13;
+			pcp = (be32_to_cpu(ah->av.ib.sl_tclass_flowlabel) >> 29) << 13;
 			sqp->ud_header.vlan.tag = cpu_to_be16(vlan | pcp);
 		}
 	} else {
-- 
1.6.5.5


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
