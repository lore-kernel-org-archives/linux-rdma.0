From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH][TRIVIAL] infiniband-diags/vendstat.c: Commentary change
Date: Thu, 12 Jul 2012 06:35:13 -0400
Message-ID: <4FFEA861.2060500@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Add device names to go along with device IDs

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/src/vendstat.c b/src/vendstat.c
index 1c493fa..8535792 100644
--- a/src/vendstat.c
+++ b/src/vendstat.c
@@ -142,10 +142,10 @@ typedef struct {
 } is4_config_counter_groups_t;
 
 static uint16_t ext_fw_info_device[][2] = {
-	{0x0245, 0x0245},
-	{0xc738, 0xc738},
-	{0x01b3, 0x01b3},
-	{0x1003, 0x1011},
+	{0x0245, 0x0245},	/* Switch-X */
+	{0xc738, 0xc738},	/* Switch-X */
+	{0x01b3, 0x01b3},	/* IS-4 */
+	{0x1003, 0x1011},	/* Connect-X */
 	{0x0000, 0x0000}};
 
 static int is_ext_fw_info_supported(uint16_t device_id) {
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
