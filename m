From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH iproute2-next] rdma: Add print of link CapabilityMask2 flags
Date: Sun, 23 Dec 2018 13:24:19 +0200
Message-ID: <20181223112419.29157-1-leon@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: David Ahern <dsahern@gmail.com>
Cc: Michael Guralnik <michaelgur@mellanox.com>, netdev <netdev@vger.kernel.org>, RDMA mailing list <linux-rdma@vger.kernel.org>, Stephen Hemminger <stephen@networkplumber.org>, Leon Romanovsky <leonro@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

From: Michael Guralnik <michaelgur@mellanox.com>

CapabilityMask2 is defined in IBTA spec as a member of PortInfo.
Add translation to string of new CapabilityMask2 expansion of link caps.

The flags are concatenated to current caps print as seen in this example
printing EXT_INFO flag:

root@server-22 $ rdma -d link
1/1: mlx5_0/1: subnet_prefix fe80:0000:0000:0000 lid 2 sm_lid 2 lmc 0
	state ACTIVE physical_state LINK_UP
caps: <SM, TRAP, SL_MAP, SYS_IMAGE_GUID, CABLE_INFO, EXTENDED_SPEEDS,
	CAP_MASK2, CM, DEVICE_MGMT, VENDOR_CLASS, CAP_MASK_NOTICE,
	CLIENT_REG, OTHER_LOCAL_CHANGES, MULT_PKER_TRAP, EXT_INFO>

Signed-off-by: Michael Guralnik <michaelgur@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 rdma/link.c | 36 +++++++++++++++++++++++++++++++-----
 1 file changed, 31 insertions(+), 5 deletions(-)

diff --git a/rdma/link.c b/rdma/link.c
index 7a6d4b7e..c064be62 100644
--- a/rdma/link.c
+++ b/rdma/link.c
@@ -19,7 +19,7 @@ static int link_help(struct rd *rd)

 static const char *caps_to_str(uint32_t idx)
 {
-#define RDMA_PORT_FLAGS(x) \
+#define RDMA_PORT_FLAGS_LOW(x) \
 	x(RESERVED, 0) \
 	x(SM, 1) \
 	x(NOTICE, 2) \
@@ -53,13 +53,39 @@ static const char *caps_to_str(uint32_t idx)
 	x(MULT_FDB, 30) \
 	x(HIERARCHY_INFO, 31)

-	enum { RDMA_PORT_FLAGS(RDMA_BITMAP_ENUM) };
+#define RDMA_PORT_FLAGS_HIGH(x) \
+	x(SET_NODE_DESC, 0) \
+	x(EXT_INFO, 1) \
+	x(VIRT, 2) \
+	x(SWITCH_POR_STATE_TABLE, 3) \
+	x(LINK_WIDTH_2X, 4) \
+	x(LINK_SPEED_HDR, 5)
+
+	/*
+	 * Separation below is needed to allow compilation of rdmatool
+	 * on 32bits systems. On such systems, C-enum is limited to be
+	 * int and can't hold more than 32 bits.
+	 */
+	enum { RDMA_PORT_FLAGS_LOW(RDMA_BITMAP_ENUM) };
+	enum { RDMA_PORT_FLAGS_HIGH(RDMA_BITMAP_ENUM) };

 	static const char * const
-		rdma_port_names[] = { RDMA_PORT_FLAGS(RDMA_BITMAP_NAMES) };
-	#undef RDMA_PORT_FLAGS
+		rdma_port_names_low[] = { RDMA_PORT_FLAGS_LOW(RDMA_BITMAP_NAMES) };
+	static const char * const
+		rdma_port_names_high[] = { RDMA_PORT_FLAGS_HIGH(RDMA_BITMAP_NAMES) };
+	uint32_t high_idx;
+	#undef RDMA_PORT_FLAGS_LOW
+	#undef RDMA_PORT_FLAGS_HIGH
+
+	if (idx < ARRAY_SIZE(rdma_port_names_low) && rdma_port_names_low[idx])
+		return rdma_port_names_low[idx];

-	return rdma_port_names[idx];
+	high_idx = idx - ARRAY_SIZE(rdma_port_names_low);
+	if (high_idx < ARRAY_SIZE(rdma_port_names_high) &&
+	    rdma_port_names_high[high_idx])
+		return rdma_port_names_high[high_idx];
+
+	return "UNKNOWN";
 }

 static void link_print_caps(struct rd *rd, struct nlattr **tb)
