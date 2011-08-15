From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] libibmad/dump.c: Add IsOptionalIPDSupported into mad_dump_portcapmask
Date: Mon, 15 Aug 2011 16:23:12 -0400
Message-ID: <4E498030.9020109@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/src/dump.c b/src/dump.c
index 29fb742..b0388dd 100644
--- a/src/dump.c
+++ b/src/dump.c
@@ -542,6 +542,8 @@ void mad_dump_portcapmask(char *buf, int bufsz, void *val, int valsz)
 		s += sprintf(s, "\t\t\t\tIsNoticeSupported\n");
 	if (mask & (1 << 3))
 		s += sprintf(s, "\t\t\t\tIsTrapSupported\n");
+	if (mask & (1 << 4))
+		s += sprintf(s, "\t\t\t\tIsOptionalIPDSupported\n");
 	if (mask & (1 << 5))
 		s += sprintf(s, "\t\t\t\tIsAutomaticMigrationSupported\n");
 	if (mask & (1 << 6))
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
