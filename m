From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 05/10] net/mlx4_core: Enable memory windows in {INIT,QUERY}_HCA
Date: Wed,  6 Feb 2013 18:19:11 +0200
Message-ID: <1360167556-20756-6-git-send-email-ogerlitz@mellanox.com>
References: <1360167556-20756-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1360167556-20756-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, shanim-xlywION9k29BDgjK7y7TUQ@public.gmane.org, Shani Michaeli <shanim-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Shani Michaeli <shanim-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Add memory windows related code to INIT_HCA and QUERY_HCA

Signed-off-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Shani Michaeli <shanim-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/net/ethernet/mellanox/mlx4/fw.c   |    3 +++
 drivers/net/ethernet/mellanox/mlx4/fw.h   |    1 +
 drivers/net/ethernet/mellanox/mlx4/main.c |    4 ++++
 drivers/net/ethernet/mellanox/mlx4/mlx4.h |    2 ++
 4 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/fw.c b/drivers/net/ethernet/mellanox/mlx4/fw.c
index a389612..d136b36 100644
--- a/drivers/net/ethernet/mellanox/mlx4/fw.c
+++ b/drivers/net/ethernet/mellanox/mlx4/fw.c
@@ -1207,6 +1207,7 @@ int mlx4_INIT_HCA(struct mlx4_dev *dev, struct mlx4_init_hca_param *param)
 #define  INIT_HCA_FS_IB_NUM_ADDRS_OFFSET  (INIT_HCA_FS_PARAM_OFFSET + 0x26)
 #define INIT_HCA_TPT_OFFSET		 0x0f0
 #define	 INIT_HCA_DMPT_BASE_OFFSET	 (INIT_HCA_TPT_OFFSET + 0x00)
+#define  INIT_HCA_TPT_MW_OFFSET		 (INIT_HCA_TPT_OFFSET + 0x08)
 #define	 INIT_HCA_LOG_MPT_SZ_OFFSET	 (INIT_HCA_TPT_OFFSET + 0x0b)
 #define	 INIT_HCA_MTT_BASE_OFFSET	 (INIT_HCA_TPT_OFFSET + 0x10)
 #define	 INIT_HCA_CMPT_BASE_OFFSET	 (INIT_HCA_TPT_OFFSET + 0x18)
@@ -1323,6 +1324,7 @@ int mlx4_INIT_HCA(struct mlx4_dev *dev, struct mlx4_init_hca_param *param)
 	/* TPT attributes */
 
 	MLX4_PUT(inbox, param->dmpt_base,  INIT_HCA_DMPT_BASE_OFFSET);
+	MLX4_PUT(inbox, param->mw_enabled, INIT_HCA_TPT_MW_OFFSET);
 	MLX4_PUT(inbox, param->log_mpt_sz, INIT_HCA_LOG_MPT_SZ_OFFSET);
 	MLX4_PUT(inbox, param->mtt_base,   INIT_HCA_MTT_BASE_OFFSET);
 	MLX4_PUT(inbox, param->cmpt_base,  INIT_HCA_CMPT_BASE_OFFSET);
@@ -1419,6 +1421,7 @@ int mlx4_QUERY_HCA(struct mlx4_dev *dev,
 	/* TPT attributes */
 
 	MLX4_GET(param->dmpt_base,  outbox, INIT_HCA_DMPT_BASE_OFFSET);
+	MLX4_GET(param->mw_enabled, outbox, INIT_HCA_TPT_MW_OFFSET);
 	MLX4_GET(param->log_mpt_sz, outbox, INIT_HCA_LOG_MPT_SZ_OFFSET);
 	MLX4_GET(param->mtt_base,   outbox, INIT_HCA_MTT_BASE_OFFSET);
 	MLX4_GET(param->cmpt_base,  outbox, INIT_HCA_CMPT_BASE_OFFSET);
diff --git a/drivers/net/ethernet/mellanox/mlx4/fw.h b/drivers/net/ethernet/mellanox/mlx4/fw.h
index dbf2f69..9f1a25c 100644
--- a/drivers/net/ethernet/mellanox/mlx4/fw.h
+++ b/drivers/net/ethernet/mellanox/mlx4/fw.h
@@ -170,6 +170,7 @@ struct mlx4_init_hca_param {
 	u8  log_mc_table_sz;
 	u8  log_mpt_sz;
 	u8  log_uar_sz;
+	u8  mw_enabled;  /* Enable memory windows */
 	u8  uar_page_sz; /* log pg sz in 4k chunks */
 	u8  fs_hash_enable_bits;
 	u8  steering_mode; /* for QUERY_HCA */
diff --git a/drivers/net/ethernet/mellanox/mlx4/main.c b/drivers/net/ethernet/mellanox/mlx4/main.c
index 9a84c75..2a4dda0 100644
--- a/drivers/net/ethernet/mellanox/mlx4/main.c
+++ b/drivers/net/ethernet/mellanox/mlx4/main.c
@@ -1447,6 +1447,10 @@ static int mlx4_init_hca(struct mlx4_dev *dev)
 
 		init_hca.log_uar_sz = ilog2(dev->caps.num_uars);
 		init_hca.uar_page_sz = PAGE_SHIFT - 12;
+		init_hca.mw_enabled = 0;
+		if (dev->caps.flags & MLX4_DEV_CAP_FLAG_MEM_WINDOW ||
+		    dev->caps.bmme_flags & MLX4_BMME_FLAG_TYPE_2_WIN)
+			init_hca.mw_enabled = INIT_HCA_TPT_MW_ENABLE;
 
 		err = mlx4_init_icm(dev, &dev_cap, &init_hca, icm_size);
 		if (err)
diff --git a/drivers/net/ethernet/mellanox/mlx4/mlx4.h b/drivers/net/ethernet/mellanox/mlx4/mlx4.h
index 539212b..8b75d5e 100644
--- a/drivers/net/ethernet/mellanox/mlx4/mlx4.h
+++ b/drivers/net/ethernet/mellanox/mlx4/mlx4.h
@@ -60,6 +60,8 @@
 #define MLX4_FS_MGM_LOG_ENTRY_SIZE	7
 #define MLX4_FS_NUM_MCG			(1 << 17)
 
+#define INIT_HCA_TPT_MW_ENABLE          (1 << 7)
+
 enum {
 	MLX4_FS_L2_HASH = 0,
 	MLX4_FS_L2_L3_L4_HASH,
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
