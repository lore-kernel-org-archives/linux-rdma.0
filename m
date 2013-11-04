From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH librdmacm] Makefile.am: Add missing riostream man page to
 man_MANS
Date: Mon, 04 Nov 2013 07:56:08 -0500
Message-ID: <52779968.8090902@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/Makefile.am b/Makefile.am
index 4e3dee7..bf72134 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -125,6 +125,7 @@ man_MANS = \
 	man/rdma_client.1 \
 	man/rdma_xserver.1 \
 	man/rdma_xclient.1 \
+	man/riostream.1 \
 	man/rstream.1 \
 	man/rcopy.1 \
 	man/rdma_cm.7 \
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
