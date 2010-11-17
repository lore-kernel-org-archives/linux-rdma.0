From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] mlx4: Fix vlan insertion order
Date: Wed, 17 Nov 2010 15:39:43 +0200
Message-ID: <20101117133943.GA10589@mtldesk30>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

We must update the control segment before marking it as valid.

Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/qp.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index ec2c9bb..3d0c6d7 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -1953,14 +1953,14 @@ int mlx4_ib_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 			goto out;
 		}
 
-		ctrl->owner_opcode = mlx4_ib_opcode[wr->opcode] |
-			(ind & qp->sq.wqe_cnt ? cpu_to_be32(1 << 31) : 0) | blh;
-
 		if (be16_to_cpu(vlan) < 0x1000) {
 			ctrl->ins_vlan = 1 << 6;
 			ctrl->vlan_tag = vlan;
 		}
 
+		ctrl->owner_opcode = mlx4_ib_opcode[wr->opcode] |
+			(ind & qp->sq.wqe_cnt ? cpu_to_be32(1 << 31) : 0) | blh;
+
 		stamp = ind + qp->sq_spare_wqes;
 		ind += DIV_ROUND_UP(size * 16, 1U << qp->sq.wqe_shift);
 
-- 
1.7.3.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
