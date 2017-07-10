From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: [PATCH v7 for-4.13 2/7] mlx5e: don't assume anything on the irq affinity mappings of the device
Date: Mon, 10 Jul 2017 10:17:29 +0300
Message-ID: <1499671054-23899-3-git-send-email-sagi@grimberg.me>
References: <1499671054-23899-1-git-send-email-sagi@grimberg.me>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1499671054-23899-1-git-send-email-sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Saeed Mahameed <saeedm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

mlx5e currently assumes that irq affinity is really spread first
irq vectors across device home node cpus, with the new generic affinity
mappings this is no longer the case, hence mlxe should not rely on
this anymore.

Signed-off-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 7aaf21405c22..274edf1290ca 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -3736,18 +3736,8 @@ void mlx5e_build_default_indir_rqt(struct mlx5_core_dev *mdev,
 				   u32 *indirection_rqt, int len,
 				   int num_channels)
 {
-	int node = mdev->priv.numa_node;
-	int node_num_of_cores;
 	int i;
 
-	if (node == -1)
-		node = first_online_node;
-
-	node_num_of_cores = cpumask_weight(cpumask_of_node(node));
-
-	if (node_num_of_cores)
-		num_channels = min_t(int, num_channels, node_num_of_cores);
-
 	for (i = 0; i < len; i++)
 		indirection_rqt[i] = i % num_channels;
 }
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
