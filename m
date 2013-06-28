From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH ibacm] acme.c: Fix a couple of cosmetic issues with option
 file generation
Date: Fri, 28 Jun 2013 11:18:43 -0400
Message-ID: <51CDA953.5070301@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Add route_data_file and addr_data_file option names before full pathname to file

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/src/acme.c b/src/acme.c
index 1109b50..287fd32 100644
--- a/src/acme.c
+++ b/src/acme.c
@@ -261,7 +261,7 @@ static void gen_opts_temp(FILE *f)
 	fprintf(f, "# the ACM cache.  This option is only valid if route_preload\n");
 	fprintf(f, "# indicates that routing data should be read from a file.\n");
 	fprintf(f, "# Default is ACM_CONF_DIR/ibacm_route.data\n");
-	fprintf(f, "# /etc/rdma/ibacm_route.data\n");
+	fprintf(f, "# route data_file /etc/rdma/ibacm_route.data\n");
 	fprintf(f, "\n");
 	fprintf(f, "# addr_preload:\n");
 	fprintf(f, "# Specifies if the ACM address cache should be preloaded, or built on demand.\n");
@@ -277,7 +277,7 @@ static void gen_opts_temp(FILE *f)
 	fprintf(f, "# the ACM cache.  This option is only valid if addr_preload\n");
 	fprintf(f, "# indicates that address data should be read from a file.\n");
 	fprintf(f, "# Default is ACM_CONF_DIR/ibacm_hosts.data\n");
-	fprintf(f, "# /etc/rdma/ibacm_hosts.data\n");
+	fprintf(f, "# addr_data_file /etc/rdma/ibacm_hosts.data\n");
 	fprintf(f, "\n");
 }
 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
