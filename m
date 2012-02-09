From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] mlx4: enforce device max fmr maps in fmr alloc
Date: Thu, 9 Feb 2012 18:10:06 +0200
Message-ID: <20120209161006.GA28695@mtldesk30>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

ConnectX devices have a limit on the number of mappings that can be done on an
FMR before having to call sync_tpt. The current implementation does not handle
sync_tpt automatically, therefore we need to limit this when allocating an FMR.
This patch adds max_fmr_maps field to mlx4_caps and enforces this maximum value
on allocations.

Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/main.c         |    2 +-
 drivers/net/ethernet/mellanox/mlx4/main.c |    2 ++
 drivers/net/ethernet/mellanox/mlx4/mr.c   |    3 +++
 include/linux/mlx4/device.h               |    1 +
 4 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 7b445df..e152837 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -163,7 +163,7 @@ static int mlx4_ib_query_device(struct ib_device *ibdev,
 	props->max_mcast_qp_attach = dev->dev->caps.num_qp_per_mgm;
 	props->max_total_mcast_qp_attach = props->max_mcast_qp_attach *
 					   props->max_mcast_grp;
-	props->max_map_per_fmr = (1 << (32 - ilog2(dev->dev->caps.num_mpts))) - 1;
+	props->max_map_per_fmr = dev->dev->caps.max_fmr_maps;
 
 out:
 	kfree(in_mad);
diff --git a/drivers/net/ethernet/mellanox/mlx4/main.c b/drivers/net/ethernet/mellanox/mlx4/main.c
index 678558b..3e593ae 100644
--- a/drivers/net/ethernet/mellanox/mlx4/main.c
+++ b/drivers/net/ethernet/mellanox/mlx4/main.c
@@ -1131,6 +1131,8 @@ static int mlx4_init_hca(struct mlx4_dev *dev)
 			goto err_stop_fw;
 		}
 
+		dev->caps.max_fmr_maps = (1 << (32 - ilog2(dev->caps.num_mpts))) - 1;
+
 		init_hca.log_uar_sz = ilog2(dev->caps.num_uars);
 		init_hca.uar_page_sz = PAGE_SHIFT - 12;
 
diff --git a/drivers/net/ethernet/mellanox/mlx4/mr.c b/drivers/net/ethernet/mellanox/mlx4/mr.c
index 8deeef9..634f4a8 100644
--- a/drivers/net/ethernet/mellanox/mlx4/mr.c
+++ b/drivers/net/ethernet/mellanox/mlx4/mr.c
@@ -816,6 +816,9 @@ int mlx4_fmr_alloc(struct mlx4_dev *dev, u32 pd, u32 access, int max_pages,
 	u64 mtt_offset;
 	int err = -ENOMEM;
 
+	if (max_maps > dev->caps.max_fmr_maps)
+		return -EINVAL;
+
 	if (page_shift < (ffs(dev->caps.page_size_cap) - 1) || page_shift >= 32)
 		return -EINVAL;
 
diff --git a/include/linux/mlx4/device.h b/include/linux/mlx4/device.h
index aea6190..263d2ae 100644
--- a/include/linux/mlx4/device.h
+++ b/include/linux/mlx4/device.h
@@ -273,6 +273,7 @@ struct mlx4_caps {
 	int			num_comp_vectors;
 	int			comp_pool;
 	int			num_mpts;
+	int			max_fmr_maps;
 	int			num_mtts;
 	int			fmr_reserved_mtts;
 	int			reserved_mtts;
-- 
1.7.9

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
