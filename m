From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 1/3] IB mlx4: extend the number of device flags
Date: Wed, 10 Nov 2010 14:23:34 +0200
Message-ID: <20101110122334.GB12037@mtldesk30>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

As there are more device flags in mlx4 that now occupy two dwords, extend
cap->flags to 64 bits to contain them all.

Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
---
 drivers/net/mlx4/fw.c       |   10 +++++++---
 drivers/net/mlx4/fw.h       |    4 +++-
 include/linux/mlx4/device.h |    2 +-
 3 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/net/mlx4/fw.c b/drivers/net/mlx4/fw.c
index b68eee2..9e73f22 100644
--- a/drivers/net/mlx4/fw.c
+++ b/drivers/net/mlx4/fw.c
@@ -75,7 +75,7 @@ MODULE_PARM_DESC(enable_qos, "Enable Quality of Service support in the HCA (defa
 		}						      \
 	} while (0)
 
-static void dump_dev_cap_flags(struct mlx4_dev *dev, u32 flags)
+static void dump_dev_cap_flags(struct mlx4_dev *dev, u64 flags)
 {
 	static const char *fname[] = {
 		[ 0] = "RC transport",
@@ -105,7 +105,7 @@ static void dump_dev_cap_flags(struct mlx4_dev *dev, u32 flags)
 
 	mlx4_dbg(dev, "DEV_CAP flags:\n");
 	for (i = 0; i < ARRAY_SIZE(fname); ++i)
-		if (fname[i] && (flags & (1 << i)))
+		if (fname[i] && (flags & (1LL << i)))
 			mlx4_dbg(dev, "    %s\n", fname[i]);
 }
 
@@ -147,6 +147,7 @@ int mlx4_QUERY_DEV_CAP(struct mlx4_dev *dev, struct mlx4_dev_cap *dev_cap)
 	u16 stat_rate;
 	int err;
 	int i;
+	u32 tmp1, tmp2;
 
 #define QUERY_DEV_CAP_OUT_SIZE		       0x100
 #define QUERY_DEV_CAP_MAX_SRQ_SZ_OFFSET		0x10
@@ -180,6 +181,7 @@ int mlx4_QUERY_DEV_CAP(struct mlx4_dev *dev, struct mlx4_dev_cap *dev_cap)
 #define QUERY_DEV_CAP_MAX_GID_OFFSET		0x3b
 #define QUERY_DEV_CAP_RATE_SUPPORT_OFFSET	0x3c
 #define QUERY_DEV_CAP_MAX_PKEY_OFFSET		0x3f
+#define QUERY_DEV_CAP_EXT_FLAGS_OFFSET		0x40
 #define QUERY_DEV_CAP_UDP_RSS_OFFSET		0x42
 #define QUERY_DEV_CAP_ETH_UC_LOOPBACK_OFFSET	0x43
 #define QUERY_DEV_CAP_FLAGS_OFFSET		0x44
@@ -276,7 +278,9 @@ int mlx4_QUERY_DEV_CAP(struct mlx4_dev *dev, struct mlx4_dev_cap *dev_cap)
 	dev_cap->udp_rss = field & 0x1;
 	MLX4_GET(field, outbox, QUERY_DEV_CAP_ETH_UC_LOOPBACK_OFFSET);
 	dev_cap->loopback_support = field & 0x1;
-	MLX4_GET(dev_cap->flags, outbox, QUERY_DEV_CAP_FLAGS_OFFSET);
+	MLX4_GET(tmp1, outbox, QUERY_DEV_CAP_EXT_FLAGS_OFFSET);
+	MLX4_GET(tmp2, outbox, QUERY_DEV_CAP_FLAGS_OFFSET);
+	dev_cap->flags = tmp2 | (u64)tmp1 << 32;
 	MLX4_GET(field, outbox, QUERY_DEV_CAP_RSVD_UAR_OFFSET);
 	dev_cap->reserved_uars = field >> 4;
 	MLX4_GET(field, outbox, QUERY_DEV_CAP_UAR_SZ_OFFSET);
diff --git a/drivers/net/mlx4/fw.h b/drivers/net/mlx4/fw.h
index 65cc72e..f8de6b1 100644
--- a/drivers/net/mlx4/fw.h
+++ b/drivers/net/mlx4/fw.h
@@ -80,7 +80,7 @@ struct mlx4_dev_cap {
 	u16 stat_rate_support;
 	int udp_rss;
 	int loopback_support;
-	u32 flags;
+	u64 flags;
 	int reserved_uars;
 	int uar_size;
 	int min_page_sz;
@@ -113,6 +113,8 @@ struct mlx4_dev_cap {
 	u8  supported_port_types[MLX4_MAX_PORTS + 1];
 	u8  log_max_macs[MLX4_MAX_PORTS + 1];
 	u8  log_max_vlans[MLX4_MAX_PORTS + 1];
+	u32 max_basic_counters;
+	u32 max_ext_counters;
 };
 
 struct mlx4_adapter {
diff --git a/include/linux/mlx4/device.h b/include/linux/mlx4/device.h
index a7b15bc..de5971a 100644
--- a/include/linux/mlx4/device.h
+++ b/include/linux/mlx4/device.h
@@ -234,7 +234,7 @@ struct mlx4_caps {
 	int			mtt_entry_sz;
 	u32			max_msg_sz;
 	u32			page_size_cap;
-	u32			flags;
+	u64			flags;
 	u32			bmme_flags;
 	u32			reserved_lkey;
 	u16			stat_rate_support;
-- 
1.6.0.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
