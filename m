From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH infiniband-diags] vendstat.c: Add additional vendor IDs to
 ext_fw_info_device
Date: Tue, 13 Jan 2015 08:58:35 -0500
Message-ID: <54B5248B.5010803@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Add additional supported device IDs to ext_fw_info_device.
These IDs are ConnectX-4, some ConnectX-3s, and Switch-IB.
This affects is_ext_fw_info_supported which determine
which Mellanox specific vendor MADs are issued to a device.

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/src/vendstat.c b/src/vendstat.c
index f28ff02..7fc4a11 100644
--- a/src/vendstat.c
+++ b/src/vendstat.c
@@ -145,8 +145,9 @@ typedef struct {
 static uint16_t ext_fw_info_device[][2] = {
 	{0x0245, 0x0245},	/* Switch-X */
 	{0xc738, 0xc738},	/* Switch-X */
+	{0xcb84, 0xcb84},	/* Switch-IB */
 	{0x01b3, 0x01b3},	/* IS-4 */
-	{0x1003, 0x1011},	/* Connect-X */
+	{0x1003, 0x1016},	/* Connect-X */
 	{0x0000, 0x0000}};
 
 static int is_ext_fw_info_supported(uint16_t device_id) {
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
