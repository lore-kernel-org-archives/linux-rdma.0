From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 3/6] IB/core: Add capability bit to tell whether per-WR P_Key change in GSI is supported
Date: Wed, 14 Oct 2015 11:29:45 +0300
Message-ID: <1444811388-22486-4-git-send-email-haggaie@mellanox.com>
References: <1444811388-22486-1-git-send-email-haggaie@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1444811388-22486-1-git-send-email-haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Mike Marciniszyn <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The IB specs do not require per work-request control over the P_Key used in
GMPs. Most drivers have implemented this feature, but some drivers such as
ipath and mlx5 do not support it.

Add a capability bit, and turn it on in drivers that lack support for
per-WR P_Key.

Cc: Mike Marciniszyn <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c        | 1 +
 drivers/staging/rdma/ipath/ipath_verbs.c | 1 +
 include/rdma/ib_verbs.h                  | 2 ++
 3 files changed, 4 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index f1ccd40beae9..2d35e0472215 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -1429,6 +1429,7 @@ static void *mlx5_ib_add(struct mlx5_core_dev *mdev)
 	dev->ib_dev.free_fast_reg_page_list  = mlx5_ib_free_fast_reg_page_list;
 	dev->ib_dev.check_mr_status	= mlx5_ib_check_mr_status;
 	dev->ib_dev.get_port_immutable  = mlx5_port_immutable;
+	dev->ib_dev.gsi_pkey_index_in_qp = 1;
 
 	mlx5_ib_internal_fill_odp_caps(dev);
 
diff --git a/drivers/staging/rdma/ipath/ipath_verbs.c b/drivers/staging/rdma/ipath/ipath_verbs.c
index ed2bbc2f7eae..2e13a82c1871 100644
--- a/drivers/staging/rdma/ipath/ipath_verbs.c
+++ b/drivers/staging/rdma/ipath/ipath_verbs.c
@@ -2202,6 +2202,7 @@ int ipath_register_ib_device(struct ipath_devdata *dd)
 	dev->mmap = ipath_mmap;
 	dev->dma_ops = &ipath_dma_mapping_ops;
 	dev->get_port_immutable = ipath_port_immutable;
+	dev->gsi_pkey_index_in_qp = 1;
 
 	snprintf(dev->node_desc, sizeof(dev->node_desc),
 		 IPATH_IDSTR " %s", init_utsname()->nodename);
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 7845fae6f2df..dc5cd93b3386 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1792,6 +1792,8 @@ struct ib_device {
 	__be64			     node_guid;
 	u32			     local_dma_lkey;
 	u16                          is_switch:1;
+	/* The device reads the pkey_index from the QP in GSI (QP1) QPs. */
+	u16			     gsi_pkey_index_in_qp:1;
 	u8                           node_type;
 	u8                           phys_port_cnt;
 
-- 
1.7.11.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
