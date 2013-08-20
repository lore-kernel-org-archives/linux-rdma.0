From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH opensm] osm_subnet.c: Fix memory leak caused by commit dc0760cb8088fbe079e19682570a884ba01e94ff
Date: Tue, 20 Aug 2013 09:00:54 -0400
Message-ID: <52136886.7090905@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

double strdup for p_opt->dump_files_dir is causing memory leak

Signed-off-by: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/opensm/osm_subnet.c b/opensm/osm_subnet.c
index 7ab1671..4b5ef38 100644
--- a/opensm/osm_subnet.c
+++ b/opensm/osm_subnet.c
@@ -1498,7 +1498,7 @@ void osm_subn_set_default_opt(IN osm_subn_opt_t *
p_opt)
  	p_opt->dump_files_dir = getenv("OSM_TMP_DIR");
 	if (!p_opt->dump_files_dir || !(*p_opt->dump_files_dir))
-		p_opt->dump_files_dir = strdup(OSM_DEFAULT_TMP_DIR);
+		p_opt->dump_files_dir = (char *) OSM_DEFAULT_TMP_DIR;
 	p_opt->dump_files_dir = strdup(p_opt->dump_files_dir);
 	p_opt->log_file = strdup(OSM_DEFAULT_LOG_FILE);
 	p_opt->log_max_size = 0;
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
