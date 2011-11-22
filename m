From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH][TRIVIAL] opensm/osm_subnet.c: Trivial optimization to code
 flow in subn_verify_sl2vl
Date: Tue, 22 Nov 2011 14:03:00 -0500
Message-ID: <4ECBF1E4.3060105@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/opensm/osm_subnet.c b/opensm/osm_subnet.c
index 554a950..e57bc92 100644
--- a/opensm/osm_subnet.c
+++ b/opensm/osm_subnet.c
@@ -1077,8 +1077,7 @@ static void subn_verify_sl2vl(char **sl2vl, const char *prefix)
 	if (count < 16)
 		log_report(" Warning: Cached Option %s_sl2vl: < 16 VLs "
 			   "listed\n", prefix);
-
-	if (count > 16)
+	else if (count > 16)
 		log_report(" Warning: Cached Option %s_sl2vl: > 16 listed: "
 			   "excess VLs will be dropped\n", prefix);
 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
