From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCHv2 libibmad] fields.c: Print SwitchCongestionSetting threshold
 fields in hex rather than decimal
Date: Fri, 09 Jan 2015 06:06:10 -0500
Message-ID: <54AFB622.2010301@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Chu, Al" <chu11-i2BcT+NCU+M@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

for consistency with CC Annex which shows meaning of threshold fields in hex not decimal

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
Change since v1:
Change fields to hex rather than SwitchPortCongestionSetting:Threshold to be consistent with CC Annex

diff --git a/src/fields.c b/src/fields.c
index 33a6364..9965811 100644
--- a/src/fields.c
+++ b/src/fields.c
@@ -858,9 +858,9 @@ static const ib_field_t ib_mad_f[] = {
 	{0, 32, "Control_Map", mad_dump_hex},
 	{32, 256, "Victim_Mask", mad_dump_array},
 	{288, 256, "Credit_Mask", mad_dump_array},
-	{BITSOFFS(544, 4), "Threshold", mad_dump_uint},
+	{BITSOFFS(544, 4), "Threshold", mad_dump_hex},
 	{BITSOFFS(552, 8), "Packet_Size", mad_dump_uint},
-	{BITSOFFS(560, 4), "CS_Threshold", mad_dump_uint},
+	{BITSOFFS(560, 4), "CS_Threshold", mad_dump_hex},
 	{BITSOFFS(576, 16), "CS_ReturnDelay", mad_dump_hex}, /* TODO: CCT dump */
 	{BITSOFFS(592, 16), "Marking_Rate", mad_dump_uint},
 	{0, 0},			/* IB_CC_SWITCH_CONGESTION_SETTING_LAST_F */
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
