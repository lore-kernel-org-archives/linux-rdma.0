From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH iproute2-rc] rdma: Fix broken 32-bit compilation
Date: Tue, 11 Dec 2018 20:14:28 +0200
Message-ID: <20181211181428.31094-1-leon@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: tephen Hemminger <stephen@networkplumber.org>, David Ahern <dsahern@gmail.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, netdev <netdev@vger.kernel.org>, RDMA mailing list <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Allow compilation of rdmatool on 32-bits platforms.

rdma
    CC       rdma.o
    CC       utils.o
    CC       dev.o
    CC       link.o
In file included from rdma.h:26:0,
                 from dev.c:12:
dev.c: In function 'dev_caps_tostr':
../include/utils.h:269:38: warning: left shift count >= width of type [-Wshift-count-overflow]
 #define BIT(nr)                 (1UL << (nr))
                                      ^
rdma.h:32:61: note: in expansion of macro 'BIT'
 #define RDMA_BITMAP_ENUM(name, bit_no) RDMA_BITMAP_##name = BIT(bit_no),
                                                             ^~~

Fixes: 40df8263a0f0 ("rdma: Add dev object")
Reported-by: Stephen Hemminger <stephen@networkplumber.org>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 rdma/dev.c | 44 +++++++++++++++++++++++++++++++-------------
 1 file changed, 31 insertions(+), 13 deletions(-)

diff --git a/rdma/dev.c b/rdma/dev.c
index 760b7fb3..60ff4b31 100644
--- a/rdma/dev.c
+++ b/rdma/dev.c
@@ -20,7 +20,7 @@ static int dev_help(struct rd *rd)

 static const char *dev_caps_to_str(uint32_t idx)
 {
-#define RDMA_DEV_FLAGS(x) \
+#define RDMA_DEV_FLAGS_LOW(x) \
 	x(RESIZE_MAX_WR, 0) \
 	x(BAD_PKEY_CNTR, 1) \
 	x(BAD_QKEY_CNTR, 2) \
@@ -50,21 +50,39 @@ static const char *dev_caps_to_str(uint32_t idx)
 	x(CROSS_CHANNEL, 27) \
 	x(MANAGED_FLOW_STEERING, 29) \
 	x(SIGNATURE_HANDOVER, 30) \
-	x(ON_DEMAND_PAGING, 31) \
-	x(SG_GAPS_REG, 32) \
-	x(VIRTUAL_FUNCTION, 33) \
-	x(RAW_SCATTER_FCS, 34) \
-	x(RDMA_NETDEV_OPA_VNIC, 35) \
-	x(PCI_WRITE_END_PADDING, 36)
-
-	enum { RDMA_DEV_FLAGS(RDMA_BITMAP_ENUM) };
+	x(ON_DEMAND_PAGING, 31)
+
+#define RDMA_DEV_FLAGS_HIGH(x) \
+	x(SG_GAPS_REG, 0) \
+	x(VIRTUAL_FUNCTION, 1) \
+	x(RAW_SCATTER_FCS, 2) \
+	x(RDMA_NETDEV_OPA_VNIC, 3) \
+	x(PCI_WRITE_END_PADDING, 4)
+
+	/*
+	 * Separation below is needed to allow compilation of rdmatool
+	 * on 32bits systems. On such systems, C-enum is limited to be
+	 * int and can't hold more than 32 bits.
+	 */
+	enum { RDMA_DEV_FLAGS_LOW(RDMA_BITMAP_ENUM) };
+	enum { RDMA_DEV_FLAGS_HIGH(RDMA_BITMAP_ENUM) };

 	static const char * const
-		rdma_dev_names[] = { RDMA_DEV_FLAGS(RDMA_BITMAP_NAMES) };
-	#undef RDMA_DEV_FLAGS
+		rdma_dev_names_low[] = { RDMA_DEV_FLAGS_LOW(RDMA_BITMAP_NAMES) };
+	static const char * const
+		rdma_dev_names_high[] = { RDMA_DEV_FLAGS_HIGH(RDMA_BITMAP_NAMES) };
+	uint32_t high_idx;
+	#undef RDMA_DEV_FLAGS_LOW
+	#undef RDMA_DEV_FLAGS_HIGH
+
+	if (idx < ARRAY_SIZE(rdma_dev_names_low) && rdma_dev_names_low[idx])
+		return rdma_dev_names_low[idx];
+
+	high_idx = idx - ARRAY_SIZE(rdma_dev_names_low);
+	if (high_idx <  ARRAY_SIZE(rdma_dev_names_high) &&
+	    rdma_dev_names_high[high_idx])
+		return rdma_dev_names_high[high_idx];

-	if (idx < ARRAY_SIZE(rdma_dev_names) && rdma_dev_names[idx])
-		return rdma_dev_names[idx];
 	return "UNKNOWN";
 }
