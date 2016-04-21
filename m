From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] infiniband-diags: Add Switch-IB2 support to device white
 lists
Date: Thu, 21 Apr 2016 12:51:54 -0400
Message-ID: <5719052A.8060307@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Add Switch-IB2 device ID to infiniband-diags device white lists

Signed-off-by: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/libibnetdisc/src/ibnetdisc.c b/libibnetdisc/src/ibnetdisc.c
index 938a516..6ef7805 100644
--- a/libibnetdisc/src/ibnetdisc.c
+++ b/libibnetdisc/src/ibnetdisc.c
@@ -197,7 +197,7 @@
 {
 	uint16_t devid = (uint16_t) mad_get_field(port->node->info, 0, IB_NODE_DEVID_F);
 
-	if ((devid >= 0xc738 && devid <= 0xc73b) || devid == 0xcb20)
+	if ((devid >= 0xc738 && devid <= 0xc73b) || devid == 0xcb20 || devid == 0xcf08)
 		return 1;
 	if (devid >= 0x1003 && devid <= 0x1016)
 		return 1;
diff --git a/src/ibdiag_common.c b/src/ibdiag_common.c
index 623205a..df2349e 100644
--- a/src/ibdiag_common.c
+++ b/src/ibdiag_common.c
@@ -532,7 +532,7 @@
 int is_mlnx_ext_port_info_supported(uint32_t devid)
 {
 	if (ibd_ibnetdisc_flags & IBND_CONFIG_MLX_EPI) {
-		if ((devid >= 0xc738 && devid <= 0xc73b) || devid == 0xcb20)
+		if ((devid >= 0xc738 && devid <= 0xc73b) || devid == 0xcb20 || devid == 0xcf08)
 			return 1;
 		if (devid >= 0x1003 && devid <= 0x1016)
 			return 1;
diff --git a/src/vendstat.c b/src/vendstat.c
index baade3e..99e19fa 100644
--- a/src/vendstat.c
+++ b/src/vendstat.c
@@ -146,6 +146,7 @@
 	{0x0245, 0x0245},	/* Switch-X */
 	{0xc738, 0xc73b},	/* Switch-X */
 	{0xcb20, 0xcb20},	/* Switch-IB */
+	{0xcf08, 0xcf08},	/* Switch-IB2 */
 	{0x01b3, 0x01b3},	/* IS-4 */
 	{0x1003, 0x1016},	/* Connect-X */
 	{0x0000, 0x0000}};
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
