From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH opensm] osm_console_io.c: Handle another write-strings issue
Date: Thu, 11 Apr 2013 10:19:27 -0400
Message-ID: <5166C66F.6040508@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

hosts_ctl declaration is:
int hosts_ctl(daemon, client_name, client_addr, client_user);
char *daemon;
char *client_name;
char *client_addr;
char *client_user;

This should have been part of previous commit 664494a8157684f2f277fb457556a7c27feae0af 
"Fix issues causing const warnings for strings"

Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/opensm/osm_console_io.c b/opensm/osm_console_io.c
index 167562c..18bd5ef 100644
--- a/opensm/osm_console_io.c
+++ b/opensm/osm_console_io.c
@@ -164,8 +164,8 @@ int is_authorized(osm_console_t * p_oct)
 {
 	/* allowed to use the console? */
 	p_oct->authorized = !is_remote(p_oct->client_type) ||
-	    hosts_ctl(OSM_DAEMON_NAME, p_oct->client_hn, p_oct->client_ip,
-		      "STRING_UNKNOWN");
+	    hosts_ctl((char *)OSM_DAEMON_NAME, p_oct->client_hn, p_oct->client_ip,
+		      (char *)"STRING_UNKNOWN");
 	return p_oct->authorized;
 }
 #endif
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
