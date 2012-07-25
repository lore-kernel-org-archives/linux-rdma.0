From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH][TRIVIAL] opensm/osm_trap_rcv.c: Remove vestigial comment
Date: Wed, 25 Jul 2012 06:40:14 -0400
Message-ID: <500FCD0E.5020608@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Hal Rosenstock <hal#@mellanox.com>
---
diff --git a/opensm/osm_trap_rcv.c b/opensm/osm_trap_rcv.c
index e90ad5e..b457712 100644
--- a/opensm/osm_trap_rcv.c
+++ b/opensm/osm_trap_rcv.c
@@ -553,7 +553,6 @@ check_sweep:
 		goto Exit;
 
 check_report:
-	/* Add a call to osm_report_notice */
 	/* We are going to report the notice - so need to fix the IssuerGID
 	   accordingly. See IBA 1.2 p.739 or IBA 1.1 p.653 for details. */
 	if (is_gsi) {
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
