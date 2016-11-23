From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH infiniband-diags] ibdiag_common.c: Disambiguate link speed
 when QDR and could be FDR10
Date: Wed, 23 Nov 2016 11:47:59 -0500
Message-ID: <99b0d971-af69-1ad3-454f-6b6e4f47c892@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Rather than printing "Could be FDR10", print
"Found link at QDR but expected speed is FDR10" for this case.

Confusion is with words "Could be" since both
QDR and FDR10 are both 10.0 Gbps.

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 src/ibdiag_common.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/src/ibdiag_common.c b/src/ibdiag_common.c
index 2a1e971..fa9a294 100644
--- a/src/ibdiag_common.c
+++ b/src/ibdiag_common.c
@@ -814,8 +814,14 @@ check_ext_speed:
 
 check_fdr10_active:
 	if ((mad_get_field(port->ext_info, 0,
-			   IB_MLNX_EXT_PORT_LINK_SPEED_ACTIVE_F) & FDR10) == 0)
-		snprintf(speed_msg, msg_size, "Could be FDR10");
+			   IB_MLNX_EXT_PORT_LINK_SPEED_ACTIVE_F) & FDR10) == 0) {
+		/* Special case QDR to try to avoid confusion with FDR10 */
+		if (mad_get_field(port->info, 0, IB_PORT_LINK_SPEED_ACTIVE_F) == 4)
+			snprintf(speed_msg, msg_size,
+				 "Found link at QDR but expected speed is FDR10");
+		else
+			snprintf(speed_msg, msg_size, "Could be FDR10");
+	}
 }
 
 int vsnprint_field(char *buf, size_t n, enum MAD_FIELDS f, int spacing,
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
