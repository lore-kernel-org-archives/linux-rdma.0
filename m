From: Line Holen <line.holen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] osm_subnet.c Remove empty syslog message
Date: Tue, 14 May 2013 04:26:51 -0700 (PDT)
Message-ID: <c87e39c6-4911-4f23-869c-5c42815bcd86@default>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Line Holen <Line.Holen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

---

diff --git a/opensm/osm_subnet.c b/opensm/osm_subnet.c
index eaf4a47..bd68957 100644
--- a/opensm/osm_subnet.c
+++ b/opensm/osm_subnet.c
@@ -6,6 +6,7 @@
  * Copyright (c) 2009 System Fabric Works, Inc. All rights reserved.
  * Copyright (c) 2009 HNR Consulting. All rights reserved.
  * Copyright (c) 2009-2011 ZIH, TU Dresden, Federal Republic of Germany. All rights reserved.
+ * Copyright (c) 2013 Oracle and/or its affiliates. All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
@@ -2080,7 +2081,6 @@ int osm_subn_parse_conf_file(const char *file_name, osm_subn_opt_t * p_opts)
 	}
 
 	printf(" Reading Cached Option File: %s\n", file_name);
-	cl_log_event("OpenSM", CL_LOG_INFO, line, NULL, 0);
 
 	p_opts->config_file = file_name;
 	if (!p_opts->file_opts && !(p_opts->file_opts = malloc(sizeof(*p_opts)))) {
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
