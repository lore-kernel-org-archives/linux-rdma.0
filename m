From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] opensm/osm_subnet.c: Miscellaneous minor fixes
Date: Thu, 07 Mar 2013 09:10:39 -0500
Message-ID: <51389FDF.80608@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Use strdup in a couple of places where strings were copied
Also, fix log message

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/opensm/osm_subnet.c b/opensm/osm_subnet.c
index 61a7cc3..f585a42 100644
--- a/opensm/osm_subnet.c
+++ b/opensm/osm_subnet.c
@@ -1497,7 +1497,7 @@ void osm_subn_set_default_opt(IN osm_subn_opt_t * p_opt)
 
 	p_opt->dump_files_dir = getenv("OSM_TMP_DIR");
 	if (!p_opt->dump_files_dir || !(*p_opt->dump_files_dir))
-		p_opt->dump_files_dir = OSM_DEFAULT_TMP_DIR;
+		p_opt->dump_files_dir = strdup(OSM_DEFAULT_TMP_DIR);
 	p_opt->dump_files_dir = strdup(p_opt->dump_files_dir);
 	p_opt->log_file = strdup(OSM_DEFAULT_LOG_FILE);
 	p_opt->log_max_size = 0;
@@ -1987,8 +1987,8 @@ int osm_subn_verify_config(IN osm_subn_opt_t * p_opts)
 		else {
 			log_report(" Invalid Cached Option Value:part_enforce = %s"
 	                           ", Using Default:%s\n",
-	                           p_opts->part_enforce = OSM_PARTITION_ENFORCE_BOTH);
-			p_opts->part_enforce = OSM_PARTITION_ENFORCE_BOTH;
+	                           p_opts->part_enforce, OSM_PARTITION_ENFORCE_BOTH);
+			strcpy(p_opts->part_enforce, OSM_PARTITION_ENFORCE_BOTH);
 			p_opts->part_enforce_enum = OSM_PARTITION_ENFORCE_TYPE_BOTH;
 		}
 	}
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
