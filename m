From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v3 06/10] IB/mlx5: remove MTT access mode from umr flags helper function
Date: Thu,  7 Nov 2013 17:54:04 +0200
Message-ID: <1383839648-19000-7-git-send-email-sagig@mellanox.com>
References: <1383839648-19000-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1383839648-19000-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, nab-PEzghdH756F8UrSeD/g0lQ@public.gmane.org, oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

get_umr_flags helper function might be used for types
of access modes other than ACCESS_MODE_MTT, such as
ACCESS_MODE_KLM. so remove it from helper and caller
will add it's own access mode flag.

This commit does not add/change functionality.

issue: 333508
Change-Id: If4aca628d1ca88be93a2161e4a158363dcaa134b
Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/qp.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 15df91b..43f120a 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -1777,7 +1777,7 @@ static u8 get_umr_flags(int acc)
 	       (acc & IB_ACCESS_REMOTE_WRITE  ? MLX5_PERM_REMOTE_WRITE : 0) |
 	       (acc & IB_ACCESS_REMOTE_READ   ? MLX5_PERM_REMOTE_READ  : 0) |
 	       (acc & IB_ACCESS_LOCAL_WRITE   ? MLX5_PERM_LOCAL_WRITE  : 0) |
-		MLX5_PERM_LOCAL_READ | MLX5_PERM_UMR_EN | MLX5_ACCESS_MODE_MTT;
+		MLX5_PERM_LOCAL_READ | MLX5_PERM_UMR_EN;
 }
 
 static void set_mkey_segment(struct mlx5_mkey_seg *seg, struct ib_send_wr *wr,
@@ -1789,7 +1789,8 @@ static void set_mkey_segment(struct mlx5_mkey_seg *seg, struct ib_send_wr *wr,
 		return;
 	}
 
-	seg->flags = get_umr_flags(wr->wr.fast_reg.access_flags);
+	seg->flags = get_umr_flags(wr->wr.fast_reg.access_flags) |
+		     MLX5_ACCESS_MODE_MTT;
 	*writ = seg->flags & (MLX5_PERM_LOCAL_WRITE | IB_ACCESS_REMOTE_WRITE);
 	seg->qpn_mkey7_0 = cpu_to_be32((wr->wr.fast_reg.rkey & 0xff) | 0xffffff00);
 	seg->flags_pd = cpu_to_be32(MLX5_MKEY_REMOTE_INVAL);
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
