From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 5/7] net/mlx4: add new cap flags field to track more capabilities
Date: Sun, 29 Apr 2012 17:04:25 +0300
Message-ID: <1335708267-30284-6-git-send-email-ogerlitz@mellanox.com>
References: <1335708267-30284-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1335708267-30284-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

This patch adds a 64 bits "flags2" features variable to export further features
of the hardware. The original "flags" field, tracks feature whose support bits are
advertized by the firmware in offsets 0x40 and 0x44 of the query device
capabilities command,  where flags2 would track features whose support bits are
scattered in various offsets. RSS support is the first feature to be exported
through it. RSS capabilities are located at offset 0x2e. The size of the RSS
indirection table is also given in this offset.

Signed-off-by: Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/net/ethernet/mellanox/mlx4/fw.c   |   29 +++++++++++++++++++++++++++++
 drivers/net/ethernet/mellanox/mlx4/fw.h   |    2 ++
 drivers/net/ethernet/mellanox/mlx4/main.c |    2 ++
 include/linux/mlx4/device.h               |    8 ++++++++
 4 files changed, 41 insertions(+), 0 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/fw.c b/drivers/net/ethernet/mellanox/mlx4/fw.c
index 2a02ba5..f7488df 100644
--- a/drivers/net/ethernet/mellanox/mlx4/fw.c
+++ b/drivers/net/ethernet/mellanox/mlx4/fw.c
@@ -118,6 +118,20 @@ static void dump_dev_cap_flags(struct mlx4_dev *dev, u64 flags)
 			mlx4_dbg(dev, "    %s\n", fname[i]);
 }
 
+static void dump_dev_cap_flags2(struct mlx4_dev *dev, u64 flags)
+{
+	static const char * const fname[] = {
+		[0] = "RSS support",
+		[1] = "RSS Toeplitz Hash Function support",
+		[2] = "RSS XOR Hash Function support"
+	};
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(fname); ++i)
+		if (fname[i] && (flags & (1LL << i)))
+			mlx4_dbg(dev, "    %s\n", fname[i]);
+}
+
 int mlx4_MOD_STAT_CFG(struct mlx4_dev *dev, struct mlx4_mod_stat_cfg *cfg)
 {
 	struct mlx4_cmd_mailbox *mailbox;
@@ -346,6 +360,7 @@ int mlx4_QUERY_DEV_CAP(struct mlx4_dev *dev, struct mlx4_dev_cap *dev_cap)
 #define QUERY_DEV_CAP_MAX_REQ_QP_OFFSET		0x29
 #define QUERY_DEV_CAP_MAX_RES_QP_OFFSET		0x2b
 #define QUERY_DEV_CAP_MAX_GSO_OFFSET		0x2d
+#define QUERY_DEV_CAP_RSS_OFFSET		0x2e
 #define QUERY_DEV_CAP_MAX_RDMA_OFFSET		0x2f
 #define QUERY_DEV_CAP_RSZ_SRQ_OFFSET		0x33
 #define QUERY_DEV_CAP_ACK_DELAY_OFFSET		0x35
@@ -390,6 +405,7 @@ int mlx4_QUERY_DEV_CAP(struct mlx4_dev *dev, struct mlx4_dev_cap *dev_cap)
 #define QUERY_DEV_CAP_RSVD_LKEY_OFFSET		0x98
 #define QUERY_DEV_CAP_MAX_ICM_SZ_OFFSET		0xa0
 
+	dev_cap->flags2 = 0;
 	mailbox = mlx4_alloc_cmd_mailbox(dev);
 	if (IS_ERR(mailbox))
 		return PTR_ERR(mailbox);
@@ -439,6 +455,17 @@ int mlx4_QUERY_DEV_CAP(struct mlx4_dev *dev, struct mlx4_dev_cap *dev_cap)
 	else
 		dev_cap->max_gso_sz = 1 << field;
 
+	MLX4_GET(field, outbox, QUERY_DEV_CAP_RSS_OFFSET);
+	if (field & 0x20)
+		dev_cap->flags2 |= MLX4_DEV_CAP_FLAG2_RSS_XOR;
+	if (field & 0x10)
+		dev_cap->flags2 |= MLX4_DEV_CAP_FLAG2_RSS_TOP;
+	field &= 0xf;
+	if (field) {
+		dev_cap->flags2 |= MLX4_DEV_CAP_FLAG2_RSS;
+		dev_cap->max_rss_tbl_sz = 1 << field;
+	} else
+		dev_cap->max_rss_tbl_sz = 0;
 	MLX4_GET(field, outbox, QUERY_DEV_CAP_MAX_RDMA_OFFSET);
 	dev_cap->max_rdma_global = 1 << (field & 0x3f);
 	MLX4_GET(field, outbox, QUERY_DEV_CAP_ACK_DELAY_OFFSET);
@@ -632,8 +659,10 @@ int mlx4_QUERY_DEV_CAP(struct mlx4_dev *dev, struct mlx4_dev_cap *dev_cap)
 		 dev_cap->max_rq_desc_sz, dev_cap->max_rq_sg);
 	mlx4_dbg(dev, "Max GSO size: %d\n", dev_cap->max_gso_sz);
 	mlx4_dbg(dev, "Max counters: %d\n", dev_cap->max_counters);
+	mlx4_dbg(dev, "Max RSS Table size: %d\n", dev_cap->max_rss_tbl_sz);
 
 	dump_dev_cap_flags(dev, dev_cap->flags);
+	dump_dev_cap_flags2(dev, dev_cap->flags2);
 
 out:
 	mlx4_free_cmd_mailbox(dev, mailbox);
diff --git a/drivers/net/ethernet/mellanox/mlx4/fw.h b/drivers/net/ethernet/mellanox/mlx4/fw.h
index e1a5fa5..64c0399 100644
--- a/drivers/net/ethernet/mellanox/mlx4/fw.h
+++ b/drivers/net/ethernet/mellanox/mlx4/fw.h
@@ -79,6 +79,7 @@ struct mlx4_dev_cap {
 	u64 trans_code[MLX4_MAX_PORTS + 1];
 	u16 stat_rate_support;
 	u64 flags;
+	u64 flags2;
 	int reserved_uars;
 	int uar_size;
 	int min_page_sz;
@@ -110,6 +111,7 @@ struct mlx4_dev_cap {
 	u32 reserved_lkey;
 	u64 max_icm_sz;
 	int max_gso_sz;
+	int max_rss_tbl_sz;
 	u8  supported_port_types[MLX4_MAX_PORTS + 1];
 	u8  suggested_type[MLX4_MAX_PORTS + 1];
 	u8  default_sense[MLX4_MAX_PORTS + 1];
diff --git a/drivers/net/ethernet/mellanox/mlx4/main.c b/drivers/net/ethernet/mellanox/mlx4/main.c
index 8bb05b4..cc68f17 100644
--- a/drivers/net/ethernet/mellanox/mlx4/main.c
+++ b/drivers/net/ethernet/mellanox/mlx4/main.c
@@ -272,10 +272,12 @@ static int mlx4_dev_cap(struct mlx4_dev *dev, struct mlx4_dev_cap *dev_cap)
 	dev->caps.max_msg_sz         = dev_cap->max_msg_sz;
 	dev->caps.page_size_cap	     = ~(u32) (dev_cap->min_page_sz - 1);
 	dev->caps.flags		     = dev_cap->flags;
+	dev->caps.flags2		     = dev_cap->flags2;
 	dev->caps.bmme_flags	     = dev_cap->bmme_flags;
 	dev->caps.reserved_lkey	     = dev_cap->reserved_lkey;
 	dev->caps.stat_rate_support  = dev_cap->stat_rate_support;
 	dev->caps.max_gso_sz	     = dev_cap->max_gso_sz;
+	dev->caps.max_rss_tbl_sz	 = dev_cap->max_rss_tbl_sz;
 
 	/* Sense port always allowed on supported devices for ConnectX1 and 2 */
 	if (dev->pdev->device != 0x1003)
diff --git a/include/linux/mlx4/device.h b/include/linux/mlx4/device.h
index 834c96c..7f5e8d5 100644
--- a/include/linux/mlx4/device.h
+++ b/include/linux/mlx4/device.h
@@ -98,6 +98,12 @@ enum {
 	MLX4_DEV_CAP_FLAG_SENSE_SUPPORT	= 1LL << 55
 };
 
+enum {
+	MLX4_DEV_CAP_FLAG2_RSS			= 1LL <<  0,
+	MLX4_DEV_CAP_FLAG2_RSS_TOP		= 1LL <<  1,
+	MLX4_DEV_CAP_FLAG2_RSS_XOR		= 1LL <<  2
+};
+
 #define MLX4_ATTR_EXTENDED_PORT_INFO	cpu_to_be16(0xff90)
 
 enum {
@@ -292,11 +298,13 @@ struct mlx4_caps {
 	u32			max_msg_sz;
 	u32			page_size_cap;
 	u64			flags;
+	u64			flags2;
 	u32			bmme_flags;
 	u32			reserved_lkey;
 	u16			stat_rate_support;
 	u8			port_width_cap[MLX4_MAX_PORTS + 1];
 	int			max_gso_sz;
+	int			max_rss_tbl_sz;
 	int                     reserved_qps_cnt[MLX4_NUM_QP_REGION];
 	int			reserved_qps;
 	int                     reserved_qps_base[MLX4_NUM_QP_REGION];
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
