From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH v2 opensm] osm_subnet.c: Enhance opensm conf file documentation
 for PerfMgr options
Date: Wed, 07 May 2014 14:10:37 -0400
Message-ID: <536A771D.20602@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Florent Parent <florent.parent-hUdP7zcY/u2zFPF/XzyFIQ@public.gmane.org>, "Susan Coulter (skc-YOWKrPYUwWM@public.gmane.org)" <skc-YOWKrPYUwWM@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
Change from version 1:
Formatted properly for posting to linux-rdma

diff --git a/opensm/osm_subnet.c b/opensm/osm_subnet.c
index f30d852..8ee62d9 100644
--- a/opensm/osm_subnet.c
+++ b/opensm/osm_subnet.c
@@ -2628,28 +2628,35 @@ int osm_subn_output_conf(FILE *out, IN osm_subn_opt_t * p_opts)
 	fprintf(out,
 		"#\n# Performance Manager Options\n#\n"
 		"# perfmgr enable\n"
+		"# PerfMgr is enabled if TRUE and disabled if FALSE (default FALSE)\n"
 		"perfmgr %s\n\n"
-		"# perfmgr redirection enable\n"
+		"# redirection enable\n"
+		"# Redirection supported if TRUE and not supported if FALSE (default TRUE)\n"
 		"perfmgr_redir %s\n\n"
-		"# sweep time in seconds\n"
+		"# sweep time in seconds (default %u seconds)\n"
 		"perfmgr_sweep_time_s %u\n\n"
-		"# Max outstanding queries\n"
+		"# Max outstanding queries (default %u)\n"
 		"perfmgr_max_outstanding_queries %u\n"
+		"# Ignore CAs on sweep (default FALSE)\n"
 		"perfmgr_ignore_cas %s\n\n"
-		"# Remove missing nodes from DB\n"
+		"# Remove missing nodes from DB (default TRUE)\n"
 		"perfmgr_rm_nodes %s\n\n"
-		"# Log error counters to opensm.log\n"
+		"# Log error counters to opensm.log (default TRUE)\n"
 		"perfmgr_log_errors %s\n\n"
 		"# Query PerfMgrGet(ClassPortInfo) for extended capabilities\n"
+		"# Extended capabilities include 64 bit extended counters and transmit wait support\n"
+		"# default FALSE\n"
 		"perfmgr_query_cpi %s\n\n"
-		"# Log xmit_wait errors\n"
+		"# Log xmit_wait errors (default FALSE)\n"
 		"perfmgr_xmit_wait_log %s\n\n"
 		"# If logging xmit_wait's; set threshold (default %u)\n"
 		"perfmgr_xmit_wait_threshold %u\n\n"
 		,
 		p_opts->perfmgr ? "TRUE" : "FALSE",
 		p_opts->perfmgr_redir ? "TRUE" : "FALSE",
+		OSM_PERFMGR_DEFAULT_SWEEP_TIME_S,
 		p_opts->perfmgr_sweep_time_s,
+		OSM_PERFMGR_DEFAULT_MAX_OUTSTANDING_QUERIES,
 		p_opts->perfmgr_max_outstanding_queries,
 		p_opts->perfmgr_ignore_cas ? "TRUE" : "FALSE",
 		p_opts->perfmgr_rm_nodes ? "TRUE" : "FALSE",
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
