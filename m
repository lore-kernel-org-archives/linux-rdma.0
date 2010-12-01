From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] mlx4: Fix vlan insertion order
Date: Wed, 01 Dec 2010 11:10:22 -0800
Message-ID: <ada7hftnwbl.fsf@cisco.com>
References: <20101117133943.GA10589@mtldesk30>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101117133943.GA10589@mtldesk30> (Eli Cohen's message of "Wed,
	17 Nov 2010 15:39:43 +0200")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

I think we actually want the vlan control bits set before the wmb()
there.  I applied the following patch:

 drivers/infiniband/hw/mlx4/qp.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index 9a7794a..2001f20 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -1816,6 +1816,11 @@ int mlx4_ib_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 		ctrl->fence_size = (wr->send_flags & IB_SEND_FENCE ?
 				    MLX4_WQE_CTRL_FENCE : 0) | size;
 
+		if (be16_to_cpu(vlan) < 0x1000) {
+			ctrl->ins_vlan = 1 << 6;
+			ctrl->vlan_tag = vlan;
+		}
+
 		/*
 		 * Make sure descriptor is fully written before
 		 * setting ownership bit (because HW can start
@@ -1831,11 +1836,6 @@ int mlx4_ib_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 		ctrl->owner_opcode = mlx4_ib_opcode[wr->opcode] |
 			(ind & qp->sq.wqe_cnt ? cpu_to_be32(1 << 31) : 0) | blh;
 
-		if (be16_to_cpu(vlan) < 0x1000) {
-			ctrl->ins_vlan = 1 << 6;
-			ctrl->vlan_tag = vlan;
-		}
-
 		stamp = ind + qp->sq_spare_wqes;
 		ind += DIV_ROUND_UP(size * 16, 1U << qp->sq.wqe_shift);
 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
