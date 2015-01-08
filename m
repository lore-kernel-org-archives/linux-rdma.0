From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH libibmad] fields.c: Print SwitchPortCongestionSetting:Threshold
 in decimal rather than hex
Date: Thu, 08 Jan 2015 12:04:10 -0500
Message-ID: <54AEB88A.90504@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Chu, Al" <chu11-i2BcT+NCU+M@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

for consistency with printing of SwitchCongestionSetting:Threshold

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/src/fields.c b/src/fields.c
index 33a6364..99f144d 100644
--- a/src/fields.c
+++ b/src/fields.c
@@ -870,7 +870,7 @@ static const ib_field_t ib_mad_f[] = {
 	 */
 	{BITSOFFS(0, 1), "Valid", mad_dump_uint},
 	{BITSOFFS(1, 1), "Control_Type", mad_dump_uint},
-	{BITSOFFS(4, 4), "Threshold", mad_dump_hex},
+	{BITSOFFS(4, 4), "Threshold", mad_dump_uint},
 	{BITSOFFS(8, 8), "Packet_Size", mad_dump_uint},
 	{BITSOFFS(16, 16), "Cong_Parm_Marking_Rate", mad_dump_uint},
 	{0, 0},			/* IB_CC_SWITCH_PORT_CONGESTION_SETTING_ELEMENT_LAST_F */
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
