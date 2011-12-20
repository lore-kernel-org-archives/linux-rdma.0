From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH][TRIVIAL] opensm/osmeventplugin/src/osmeventplugin.c: Output
 LIDs in decimal
Date: Tue, 20 Dec 2011 15:08:50 -0500
Message-ID: <4EF0EB52.8070206@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


rather than in hex

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/osmeventplugin/src/osmeventplugin.c b/osmeventplugin/src/osmeventplugin.c
index 9caf184..e4e51a0 100644
--- a/osmeventplugin/src/osmeventplugin.c
+++ b/osmeventplugin/src/osmeventplugin.c
@@ -141,13 +141,13 @@ static void handle_trap_event(_log_events_t *log, ib_mad_notice_attr_t *p_ntc)
 {
 	if (ib_notice_is_generic(p_ntc)) {
 		fprintf(log->log_file,
-			"Generic trap type %d; event %d; from LID 0x%x\n",
+			"Generic trap type %d; event %d; from LID %u\n",
 			ib_notice_get_type(p_ntc),
 			cl_ntoh16(p_ntc->g_or_v.generic.trap_num),
 			cl_ntoh16(p_ntc->issuer_lid));
 	} else {
 		fprintf(log->log_file,
-			"Vendor trap type %d; from LID 0x%x\n",
+			"Vendor trap type %d; from LID %u\n",
 			ib_notice_get_type(p_ntc),
 			cl_ntoh16(p_ntc->issuer_lid));
 	}
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
