From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 2/5] ib/mlx4: remove setting of vlan in IBoE WQEs control
 segment
Date: Mon, 10 Oct 2011 10:54:42 +0200
Message-ID: <alpine.LRH.2.00.1110101054110.11243@ogerlitz.voltaire.com>
References: <alpine.LRH.2.00.1110101047420.10901@ogerlitz.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.LRH.2.00.1110101047420.10901-VYr5/9ddeaGSIdy2EShu12Xnswh1EIUO@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

There's no need to set the vlan related fields in an IBoE send WQE
control segment. This b/c the vlan to be used by a UD QP is specified
through the the datagram segment, and with GSI (CM) QP, all the headers
down to the 8021q and mac ones are built by the software anyway.

Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/qp.c |   11 ++---------
 1 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index 3a91d9d..819b1a5 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -1547,14 +1547,13 @@ static void set_masked_atomic_seg(struct mlx4_wqe_masked_atomic_seg *aseg,
 }

 static void set_datagram_seg(struct mlx4_wqe_datagram_seg *dseg,
-			     struct ib_send_wr *wr, __be16 *vlan)
+			     struct ib_send_wr *wr)
 {
 	memcpy(dseg->av, &to_mah(wr->wr.ud.ah)->av, sizeof (struct mlx4_av));
 	dseg->dqpn = cpu_to_be32(wr->wr.ud.remote_qpn);
 	dseg->qkey = cpu_to_be32(wr->wr.ud.remote_qkey);
 	dseg->vlan = to_mah(wr->wr.ud.ah)->av.eth.vlan;
 	memcpy(dseg->mac, to_mah(wr->wr.ud.ah)->av.eth.mac, 6);
-	*vlan = dseg->vlan;
 }

 static void set_mlx_icrc_seg(void *dseg)
@@ -1657,7 +1656,6 @@ int mlx4_ib_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 	__be32 uninitialized_var(lso_hdr_sz);
 	__be32 blh;
 	int i;
-	__be16 vlan = cpu_to_be16(0xffff);

 	spin_lock_irqsave(&qp->sq.lock, flags);

@@ -1761,7 +1759,7 @@ int mlx4_ib_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 			break;

 		case IB_QPT_UD:
-			set_datagram_seg(wqe, wr, &vlan);
+			set_datagram_seg(wqe, wr);
 			wqe  += sizeof (struct mlx4_wqe_datagram_seg);
 			size += sizeof (struct mlx4_wqe_datagram_seg) / 16;

@@ -1824,11 +1822,6 @@ int mlx4_ib_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 		ctrl->fence_size = (wr->send_flags & IB_SEND_FENCE ?
 				    MLX4_WQE_CTRL_FENCE : 0) | size;

-		if (be16_to_cpu(vlan) < 0x1000) {
-			ctrl->ins_vlan = 1 << 6;
-			ctrl->vlan_tag = vlan;
-		}
-
 		/*
 		 * Make sure descriptor is fully written before
 		 * setting ownership bit (because HW can start
-- 
1.7.4.1


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
