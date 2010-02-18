From: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Subject: [PATCHv8 1/2] libmlx4: Add IBoE support
Date: Thu, 18 Feb 2010 19:25:21 +0200
Message-ID: <20100218172521.GQ12286@mtls03>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, ewg <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Modify libmlx4 to support IBoE. The change involves retrieving the ethernet
layer 2 address of a port based on its GID and source index through a new
system call, ibv_cmd_eth_l2_addr(), and embedding the layer 2 information in
the address vector representation of mlx4.

Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
---
 src/mlx4.h  |    4 ++++
 src/qp.c    |    8 +++++++-
 src/verbs.c |   34 ++++++++++++++++++++++++++++++++++
 src/wqe.h   |    6 ++++--
 4 files changed, 49 insertions(+), 3 deletions(-)

diff --git a/src/mlx4.h b/src/mlx4.h
index 4445998..4b12456 100644
--- a/src/mlx4.h
+++ b/src/mlx4.h
@@ -236,11 +236,15 @@ struct mlx4_av {
 	uint8_t				hop_limit;
 	uint32_t			sl_tclass_flowlabel;
 	uint8_t				dgid[16];
+	uint8_t				mac[8];
 };
 
 struct mlx4_ah {
 	struct ibv_ah			ibv_ah;
 	struct mlx4_av			av;
+	uint16_t			vlan;
+	uint8_t				mac[6];
+	uint8_t				tagged;
 };
 
 static inline unsigned long align(unsigned long val, unsigned long align)
diff --git a/src/qp.c b/src/qp.c
index d194ae3..fa70889 100644
--- a/src/qp.c
+++ b/src/qp.c
@@ -143,6 +143,8 @@ static void set_datagram_seg(struct mlx4_wqe_datagram_seg *dseg,
 	memcpy(dseg->av, &to_mah(wr->wr.ud.ah)->av, sizeof (struct mlx4_av));
 	dseg->dqpn = htonl(wr->wr.ud.remote_qpn);
 	dseg->qkey = htonl(wr->wr.ud.remote_qkey);
+	dseg->vlan = htons(to_mah(wr->wr.ud.ah)->vlan);
+	memcpy(dseg->mac, to_mah(wr->wr.ud.ah)->mac, 6);
 }
 
 static void __set_data_seg(struct mlx4_wqe_data_seg *dseg, struct ibv_sge *sg)
@@ -281,6 +283,10 @@ int mlx4_post_send(struct ibv_qp *ibqp, struct ibv_send_wr *wr,
 			set_datagram_seg(wqe, wr);
 			wqe  += sizeof (struct mlx4_wqe_datagram_seg);
 			size += sizeof (struct mlx4_wqe_datagram_seg) / 16;
+			if (to_mah(wr->wr.ud.ah)->tagged) {
+				ctrl->ins_vlan = 1 << 6;
+				ctrl->vlan_tag = htons(to_mah(wr->wr.ud.ah)->vlan);
+			}
 			break;
 
 		default:
@@ -393,7 +399,7 @@ out:
 
 	if (nreq == 1 && inl && size > 1 && size < ctx->bf_buf_size / 16) {
 		ctrl->owner_opcode |= htonl((qp->sq.head & 0xffff) << 8);
-		*(uint32_t *) ctrl->reserved |= qp->doorbell_qpn;
+		*(uint32_t *) (&ctrl->vlan_tag) |= qp->doorbell_qpn;
 		/*
 		 * Make sure that descriptor is written to memory
 		 * before writing to BlueFlame page.
diff --git a/src/verbs.c b/src/verbs.c
index 1ac1362..48731a7 100644
--- a/src/verbs.c
+++ b/src/verbs.c
@@ -614,9 +614,21 @@ int mlx4_destroy_qp(struct ibv_qp *ibqp)
 	return 0;
 }
 
+static int mcast_mac(uint8_t *mac)
+{
+	int i;
+	uint8_t val = 0xff;
+
+	for (i = 0; i < 6; ++i)
+		val &= mac[i];
+
+	return val == 0xff;
+}
+
 struct ibv_ah *mlx4_create_ah(struct ibv_pd *pd, struct ibv_ah_attr *attr)
 {
 	struct mlx4_ah *ah;
+	struct ibv_port_attr port_attr;
 
 	ah = malloc(sizeof *ah);
 	if (!ah)
@@ -642,7 +654,29 @@ struct ibv_ah *mlx4_create_ah(struct ibv_pd *pd, struct ibv_ah_attr *attr)
 		memcpy(ah->av.dgid, attr->grh.dgid.raw, 16);
 	}
 
+	if (ibv_query_port(pd->context, attr->port_num, &port_attr))
+		goto err;
+
+	if (port_attr.link_layer == IBV_LINK_LAYER_ETHERNET) {
+		if (ibv_cmd_get_eth_l2_addr(pd, attr->port_num,
+					    (const union ibv_gid *)ah->av.dgid,
+					    attr->grh.sgid_index,
+					    ah->mac, &ah->vlan, &ah->tagged))
+			goto err;
+
+		if (mcast_mac(ah->mac))
+			ah->av.dlid = htons(0xc000);
+		if (ah->tagged) {
+			ah->av.port_pd |= htonl(1 << 29);
+			ah->vlan |= (attr->sl & 7) << 13;
+		}
+	}
+
+
 	return &ah->ibv_ah;
+err:
+	free(ah);
+	return NULL;
 }
 
 int mlx4_destroy_ah(struct ibv_ah *ah)
diff --git a/src/wqe.h b/src/wqe.h
index 6f7f309..1e6159c 100644
--- a/src/wqe.h
+++ b/src/wqe.h
@@ -54,7 +54,8 @@ enum {
 
 struct mlx4_wqe_ctrl_seg {
 	uint32_t		owner_opcode;
-	uint8_t			reserved[3];
+	uint16_t		vlan_tag;
+	uint8_t			ins_vlan;
 	uint8_t			fence_size;
 	/*
 	 * High 24 bits are SRC remote buffer; low 8 bits are flags:
@@ -78,7 +79,8 @@ struct mlx4_wqe_datagram_seg {
 	uint32_t		av[8];
 	uint32_t		dqpn;
 	uint32_t		qkey;
-	uint32_t		reserved[2];
+	uint16_t		vlan;
+	uint8_t			mac[6];
 };
 
 struct mlx4_wqe_data_seg {
-- 
1.7.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
