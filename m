From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH iproute2-next] rdma: Fix representation of PortInfo CapabilityMask
Date: Sun, 16 Sep 2018 20:28:13 +0300
Message-ID: <20180916172814.13022-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: David Ahern <dsahern@gmail.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, netdev <netdev@vger.kernel.org>, RDMA mailing list <linux-rdma@vger.kernel.org>, Stephen Hemminger <stephen@networkplumber.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

The port capability mask represents IBTA PortInfo specification,
but as it is written in description of kernel commit 2f944c0fbf58
("RDMA: Fix storage of PortInfo CapabilityMask in the kernel"),
the bit 26 was mistakenly overwritten.

The rdmatool followed it too and mislead users by presenting wrong
value. Since it never showed proper value, we update the whole
port_cap_mask to comply with IBTA and show real HW values.

Fixes: da990ab40a92 ("rdma: Add link object")
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 rdma/link.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/rdma/link.c b/rdma/link.c
index 7e914c87..7a6d4b7e 100644
--- a/rdma/link.c
+++ b/rdma/link.c
@@ -20,6 +20,7 @@ static int link_help(struct rd *rd)
 static const char *caps_to_str(uint32_t idx)
 {
 #define RDMA_PORT_FLAGS(x) \
+	x(RESERVED, 0) \
 	x(SM, 1) \
 	x(NOTICE, 2) \
 	x(TRAP, 3) \
@@ -32,7 +33,9 @@ static const char *caps_to_str(uint32_t idx)
 	x(SM_DISABLED, 10) \
 	x(SYS_IMAGE_GUID, 11) \
 	x(PKEY_SW_EXT_PORT_TRAP, 12) \
+	x(CABLE_INFO, 13) \
 	x(EXTENDED_SPEEDS, 14) \
+	x(CAP_MASK2, 15) \
 	x(CM, 16) \
 	x(SNMP_TUNNEL, 17) \
 	x(REINIT, 18) \
@@ -43,7 +46,12 @@ static const char *caps_to_str(uint32_t idx)
 	x(BOOT_MGMT, 23) \
 	x(LINK_LATENCY, 24) \
 	x(CLIENT_REG, 25) \
-	x(IP_BASED_GIDS, 26)
+	x(OTHER_LOCAL_CHANGES, 26) \
+	x(LINK_SPPED_WIDTH, 27) \
+	x(VENDOR_SPECIFIC_MADS, 28) \
+	x(MULT_PKER_TRAP, 29) \
+	x(MULT_FDB, 30) \
+	x(HIERARCHY_INFO, 31)
 
 	enum { RDMA_PORT_FLAGS(RDMA_BITMAP_ENUM) };
 
@@ -51,9 +59,7 @@ static const char *caps_to_str(uint32_t idx)
 		rdma_port_names[] = { RDMA_PORT_FLAGS(RDMA_BITMAP_NAMES) };
 	#undef RDMA_PORT_FLAGS
 
-	if (idx < ARRAY_SIZE(rdma_port_names) && rdma_port_names[idx])
-		return rdma_port_names[idx];
-	return "UNKNOWN";
+	return rdma_port_names[idx];
 }
 
 static void link_print_caps(struct rd *rd, struct nlattr **tb)
-- 
2.14.4
