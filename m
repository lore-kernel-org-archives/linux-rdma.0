From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH v2] mlx4: properly mask MGM entry members count
Date: Tue, 16 Nov 2010 20:15:20 +0200
Message-ID: <20101116181520.GA29609@mtldesk30>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The members_count field size is 24 bits so mask it properly when reading it.

Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
---
Changes: Handle mlx4_multicast_detach too


 drivers/net/mlx4/mcg.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/mlx4/mcg.c b/drivers/net/mlx4/mcg.c
index c4f88b7..5a89631 100644
--- a/drivers/net/mlx4/mcg.c
+++ b/drivers/net/mlx4/mcg.c
@@ -187,7 +187,7 @@ int mlx4_multicast_attach(struct mlx4_dev *dev, struct mlx4_qp *qp, u8 gid[16],
 		memcpy(mgm->gid, gid, 16);
 	}
 
-	members_count = be32_to_cpu(mgm->members_count);
+	members_count = be32_to_cpu(mgm->members_count) & 0xffffff;
 	if (members_count == MLX4_QP_PER_MGM) {
 		mlx4_err(dev, "MGM at index %x is full.\n", index);
 		err = -ENOMEM;
@@ -270,7 +270,7 @@ int mlx4_multicast_detach(struct mlx4_dev *dev, struct mlx4_qp *qp, u8 gid[16])
 		goto out;
 	}
 
-	members_count = be32_to_cpu(mgm->members_count);
+	members_count = be32_to_cpu(mgm->members_count) & 0xffffff;
 	for (loc = -1, i = 0; i < members_count; ++i)
 		if ((be32_to_cpu(mgm->qp[i]) & MGM_QPN_MASK) == qp->qpn)
 			loc = i;
-- 
1.7.3.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
