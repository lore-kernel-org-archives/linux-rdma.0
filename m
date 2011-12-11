From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH libmlx4 4/4] fix SL to 8021q priority-bits settings under
 IBoE
Date: Sun, 11 Dec 2011 16:45:40 +0200
Message-ID: <alpine.LRH.2.00.1112111645190.3850@ogerlitz.voltaire.com>
References: <alpine.LRH.2.00.1112111638020.32736@ogerlitz.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.LRH.2.00.1112111638020.32736-VYr5/9ddeaGSIdy2EShu12Xnswh1EIUO@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Under IBoE, SLs 0-7 are mapped to Ethernet 8021q user priority bits
(pbits) which are part of the VLAN tag, SLs 8-15 are reserved.

Under Ethernet, the ConnectX firmware treats (decode/encode) the four
bit SL field in various constructs such as QPC / UD WQE / CQE as PPP0
and not as 0PPP. This correlates well to the fact that within the
vlan tag the pbits are located in bits 15-13 and not 12-14.

The current code was buggy around that - the encoding into the
address handle was wrong which resulted in wrong priority-bits
for datagram WQE, and decoding from the CQE was wrong, which
resulted in wrong input into AH build-up from CQE such as
done by consumers of ibv_init_ah_from_wc

This is fixed by using PPP0 where relevant, a related
fix is provided to the kernel mlx4 driver.

Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 src/cq.c    |    5 ++++-
 src/verbs.c |    5 +++--
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/src/cq.c b/src/cq.c
index 14f2f4d..628c65b 100644
--- a/src/cq.c
+++ b/src/cq.c
@@ -317,12 +317,15 @@ static int mlx4_poll_one(struct mlx4_cq *cq,
 		}

 		wc->slid	   = ntohs(cqe->rlid);
-		wc->sl		   = ntohs(cqe->sl_vid) >> 12;
 		g_mlpath_rqpn	   = ntohl(cqe->g_mlpath_rqpn);
 		wc->src_qp	   = g_mlpath_rqpn & 0xffffff;
 		wc->dlid_path_bits = (g_mlpath_rqpn >> 24) & 0x7f;
 		wc->wc_flags	  |= g_mlpath_rqpn & 0x80000000 ? IBV_WC_GRH : 0;
 		wc->pkey_index     = ntohl(cqe->immed_rss_invalid) & 0x7f;
+		if ((*cur_qp)->link_layer == IBV_LINK_LAYER_ETHERNET)
+			wc->sl	   = ntohs(cqe->sl_vid) >> 13;
+		else
+			wc->sl	   = ntohs(cqe->sl_vid) >> 12;
 	}

 	return CQ_OK;
diff --git a/src/verbs.c b/src/verbs.c
index 3c8dbaf..7ccb0f1 100644
--- a/src/verbs.c
+++ b/src/verbs.c
@@ -677,13 +677,14 @@ struct ibv_ah *mlx4_create_ah(struct ibv_pd *pd, struct ibv_ah_attr *attr)
 	if (port_attr.link_layer != IBV_LINK_LAYER_ETHERNET) {
 		ah->av.g_slid = attr->src_path_bits;
 		ah->av.dlid   = htons(attr->dlid);
-	}
+		ah->av.sl_tclass_flowlabel = htonl(attr->sl << 28);
+	} else
+		ah->av.sl_tclass_flowlabel = htonl(attr->sl << 29);

 	if (attr->static_rate) {
 		ah->av.stat_rate = attr->static_rate + MLX4_STAT_RATE_OFFSET;
 		/* XXX check rate cap? */
 	}
-	ah->av.sl_tclass_flowlabel = htonl(attr->sl << 28);
 	if (attr->is_global) {
 		ah->av.g_slid   |= 0x80;
 		ah->av.gid_index = attr->grh.sgid_index;
-- 
1.7.1


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
