From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH infiniband-diags] Add Connect-X5 device ID to device white
 lists
Date: Mon, 19 Dec 2016 16:24:34 -0500
Message-ID: <cb54fa49-84fb-3d2f-6431-e6b513b6fb46@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Connect-X5 is device ID 0x1017

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 libibnetdisc/src/ibnetdisc.c | 2 +-
 src/ibdiag_common.c          | 2 +-
 src/vendstat.c               | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/libibnetdisc/src/ibnetdisc.c b/libibnetdisc/src/ibnetdisc.c
index 7ba5c91..57fc33e 100644
--- a/libibnetdisc/src/ibnetdisc.c
+++ b/libibnetdisc/src/ibnetdisc.c
@@ -199,7 +199,7 @@ static int is_mlnx_ext_port_info_supported(ibnd_port_t * port)
 
 	if ((devid >= 0xc738 && devid <= 0xc73b) || devid == 0xcb20 || devid == 0xcf08 || devid == 0x1b02)
 		return 1;
-	if (devid >= 0x1003 && devid <= 0x1016)
+	if (devid >= 0x1003 && devid <= 0x1017)
 		return 1;
 	return 0;
 }
diff --git a/src/ibdiag_common.c b/src/ibdiag_common.c
index f74eed4..981f82d 100644
--- a/src/ibdiag_common.c
+++ b/src/ibdiag_common.c
@@ -532,7 +532,7 @@ int is_mlnx_ext_port_info_supported(uint32_t devid)
 	if (ibd_ibnetdisc_flags & IBND_CONFIG_MLX_EPI) {
 		if ((devid >= 0xc738 && devid <= 0xc73b) || devid == 0xcb20 || devid == 0xcf08 || devid == 0x1b02)
 			return 1;
-		if (devid >= 0x1003 && devid <= 0x1016)
+		if (devid >= 0x1003 && devid <= 0x1017)
 			return 1;
 	}
 	return 0;
diff --git a/src/vendstat.c b/src/vendstat.c
index 284ef93..7f88bf3 100644
--- a/src/vendstat.c
+++ b/src/vendstat.c
@@ -148,7 +148,7 @@ static uint16_t ext_fw_info_device[][2] = {
 	{0xcb20, 0xcb20},	/* Switch-IB */
 	{0xcf08, 0xcf08},	/* Switch-IB2 */
 	{0x01b3, 0x01b3},	/* IS-4 */
-	{0x1003, 0x1016},	/* Connect-X */
+	{0x1003, 0x1017},	/* Connect-X */
 	{0x1b02, 0x1b02},	/* Bull */
 	{0x0000, 0x0000}};
 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
