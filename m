From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 3/9] mlx4: extend cap flags to 64 bit
Date: Wed, 15 Jun 2011 17:41:42 +0300
Message-ID: <alpine.LRH.2.00.1106151741210.15844@ogerlitz.voltaire.com>
References: <alpine.LRH.2.00.1106151733410.15844@ogerlitz.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.LRH.2.00.1106151733410.15844-VYr5/9ddeaGSIdy2EShu12Xnswh1EIUO@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Towards adding another dword containing more device flags,
extend the device capabilities flags field from 32 to 64 bit.
Derived from patch by Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

---
 drivers/net/mlx4/fw.c       |    9 +++++----
 drivers/net/mlx4/fw.h       |    2 +-
 include/linux/mlx4/device.h |   34 +++++++++++++++++-----------------
 3 files changed, 23 insertions(+), 22 deletions(-)

Index: b/drivers/net/mlx4/fw.c
===================================================================
--- a/drivers/net/mlx4/fw.c
+++ b/drivers/net/mlx4/fw.c
@@ -75,7 +75,7 @@ MODULE_PARM_DESC(enable_qos, "Enable Qua
 		}						      \
 	} while (0)

-static void dump_dev_cap_flags(struct mlx4_dev *dev, u32 flags)
+static void dump_dev_cap_flags(struct mlx4_dev *dev, u64 flags)
 {
 	static const char *fname[] = {
 		[ 0] = "RC transport",
@@ -105,7 +105,7 @@ static void dump_dev_cap_flags(struct ml

 	mlx4_dbg(dev, "DEV_CAP flags:\n");
 	for (i = 0; i < ARRAY_SIZE(fname); ++i)
-		if (fname[i] && (flags & (1 << i)))
+		if (fname[i] && (flags & (1LL << i)))
 			mlx4_dbg(dev, "    %s\n", fname[i]);
 }

@@ -142,7 +142,7 @@ int mlx4_QUERY_DEV_CAP(struct mlx4_dev *
 	struct mlx4_cmd_mailbox *mailbox;
 	u32 *outbox;
 	u8 field;
-	u32 field32;
+	u32 field32, flags;
 	u16 size;
 	u16 stat_rate;
 	int err;
@@ -279,7 +279,8 @@ int mlx4_QUERY_DEV_CAP(struct mlx4_dev *
 	MLX4_GET(field, outbox, QUERY_DEV_CAP_ETH_UC_LOOPBACK_OFFSET);
 	dev_cap->loopback_support = field & 0x1;
 	dev_cap->wol = field & 0x40;
-	MLX4_GET(dev_cap->flags, outbox, QUERY_DEV_CAP_FLAGS_OFFSET);
+	MLX4_GET(flags, outbox, QUERY_DEV_CAP_FLAGS_OFFSET);
+	dev_cap->flags = flags;
 	MLX4_GET(field, outbox, QUERY_DEV_CAP_RSVD_UAR_OFFSET);
 	dev_cap->reserved_uars = field >> 4;
 	MLX4_GET(field, outbox, QUERY_DEV_CAP_UAR_SZ_OFFSET);
Index: b/drivers/net/mlx4/fw.h
===================================================================
--- a/drivers/net/mlx4/fw.h
+++ b/drivers/net/mlx4/fw.h
@@ -83,7 +83,7 @@ struct mlx4_dev_cap {
 	int vep_uc_steering;
 	int vep_mc_steering;
 	int wol;
-	u32 flags;
+	u64 flags;
 	int reserved_uars;
 	int uar_size;
 	int min_page_sz;
Index: b/include/linux/mlx4/device.h
===================================================================
--- a/include/linux/mlx4/device.h
+++ b/include/linux/mlx4/device.h
@@ -58,22 +58,22 @@ enum {
 };

 enum {
-	MLX4_DEV_CAP_FLAG_RC		= 1 <<  0,
-	MLX4_DEV_CAP_FLAG_UC		= 1 <<  1,
-	MLX4_DEV_CAP_FLAG_UD		= 1 <<  2,
-	MLX4_DEV_CAP_FLAG_SRQ		= 1 <<  6,
-	MLX4_DEV_CAP_FLAG_IPOIB_CSUM	= 1 <<  7,
-	MLX4_DEV_CAP_FLAG_BAD_PKEY_CNTR	= 1 <<  8,
-	MLX4_DEV_CAP_FLAG_BAD_QKEY_CNTR	= 1 <<  9,
-	MLX4_DEV_CAP_FLAG_DPDP		= 1 << 12,
-	MLX4_DEV_CAP_FLAG_BLH		= 1 << 15,
-	MLX4_DEV_CAP_FLAG_MEM_WINDOW	= 1 << 16,
-	MLX4_DEV_CAP_FLAG_APM		= 1 << 17,
-	MLX4_DEV_CAP_FLAG_ATOMIC	= 1 << 18,
-	MLX4_DEV_CAP_FLAG_RAW_MCAST	= 1 << 19,
-	MLX4_DEV_CAP_FLAG_UD_AV_PORT	= 1 << 20,
-	MLX4_DEV_CAP_FLAG_UD_MCAST	= 1 << 21,
-	MLX4_DEV_CAP_FLAG_IBOE		= 1 << 30
+	MLX4_DEV_CAP_FLAG_RC		= 1LL <<  0,
+	MLX4_DEV_CAP_FLAG_UC		= 1LL <<  1,
+	MLX4_DEV_CAP_FLAG_UD		= 1LL <<  2,
+	MLX4_DEV_CAP_FLAG_SRQ		= 1LL <<  6,
+	MLX4_DEV_CAP_FLAG_IPOIB_CSUM	= 1LL <<  7,
+	MLX4_DEV_CAP_FLAG_BAD_PKEY_CNTR	= 1LL <<  8,
+	MLX4_DEV_CAP_FLAG_BAD_QKEY_CNTR	= 1LL <<  9,
+	MLX4_DEV_CAP_FLAG_DPDP		= 1LL << 12,
+	MLX4_DEV_CAP_FLAG_BLH		= 1LL << 15,
+	MLX4_DEV_CAP_FLAG_MEM_WINDOW	= 1LL << 16,
+	MLX4_DEV_CAP_FLAG_APM		= 1LL << 17,
+	MLX4_DEV_CAP_FLAG_ATOMIC	= 1LL << 18,
+	MLX4_DEV_CAP_FLAG_RAW_MCAST	= 1LL << 19,
+	MLX4_DEV_CAP_FLAG_UD_AV_PORT	= 1LL << 20,
+	MLX4_DEV_CAP_FLAG_UD_MCAST	= 1LL << 21,
+	MLX4_DEV_CAP_FLAG_IBOE		= 1LL << 30
 };

 enum {
@@ -253,7 +253,7 @@ struct mlx4_caps {
 	int			mtt_entry_sz;
 	u32			max_msg_sz;
 	u32			page_size_cap;
-	u32			flags;
+	u64			flags;
 	u32			bmme_flags;
 	u32			reserved_lkey;
 	u16			stat_rate_support;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
