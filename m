From: Line Holen <line.holen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] osm_console_io.c Memory leak when closing console
Date: Thu, 30 May 2013 07:38:56 -0700 (PDT)
Message-ID: <66f50a5a-e3dc-452c-ae73-9b07e2c12b3e@default>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Use fclose() rather than close() to avoid memory leaks.
Also lowered the loglevel of a couple of log messages.

Signed-off-by: Line Holen <Line.Holen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

---

diff --git a/opensm/osm_console_io.c b/opensm/osm_console_io.c
index 18bd5ef..dfc903f 100644
--- a/opensm/osm_console_io.c
+++ b/opensm/osm_console_io.c
@@ -1,6 +1,7 @@
 /*
  * Copyright (c) 2005-2009 Voltaire, Inc. All rights reserved.
  * Copyright (c) 2008 HNR Consulting. All rights reserved.
+ * Copyright (c) 2013 Oracle and/or its affiliates. All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
@@ -107,10 +108,10 @@ int cio_close(osm_console_t * p_oct, osm_log_t * p_log)
 {
 	int rtnval = -1;
 	if (p_oct && p_oct->in_fd > 0) {
-		OSM_LOG(p_log, OSM_LOG_INFO,
+		OSM_LOG(p_log, OSM_LOG_VERBOSE,
 			"Console connection closed: %s (%s)\n",
 			p_oct->client_hn, p_oct->client_ip);
-		rtnval = close(p_oct->in_fd);
+		rtnval = fclose(p_oct->in);
 		p_oct->in_fd = -1;
 		p_oct->out_fd = -1;
 		p_oct->in = NULL;
@@ -138,9 +139,10 @@ int cio_open(osm_console_t * p_oct, int new_fd, osm_log_t * p_log)
 			cio_close(p_oct, p_log);
 		else {
 			OSM_LOG(p_log, OSM_LOG_INFO,
-				"Console connection aborted: %s (%s)\n",
+				"Console connection aborted: %s (%s) - "
+				"already in use\n",
 				p_oct->client_hn, p_oct->client_ip);
-			close(new_fd);
+			fclose(file);
 			free(p_line);
 			return -1;
 		}
@@ -151,7 +153,7 @@ int cio_open(osm_console_t * p_oct, int new_fd, osm_log_t * p_log)
 	p_oct->in = fdopen(p_oct->in_fd, "w+");
 	p_oct->out = p_oct->in;
 	osm_console_prompt(p_oct->out);
-	OSM_LOG(p_log, OSM_LOG_INFO, "Console connection accepted: %s (%s)\n",
+	OSM_LOG(p_log, OSM_LOG_VERBOSE, "Console connection accepted: %s (%s)\n",
 		p_oct->client_hn, p_oct->client_ip);
 
 	return (p_oct->in == NULL) ? -1 : 0;
@@ -224,7 +226,7 @@ int osm_console_init(osm_subn_opt_t * opt, osm_console_t * p_oct, osm_log_t * p_
 		}
 		if (listen(p_oct->socket, 1) < 0) {
 			OSM_LOG(p_log, OSM_LOG_ERROR,
-				"ERR 4B03: Failed to listen on socket: %s\n",
+				"ERR 4B03: Failed to listen on console socket: %s\n",
 				strerror(errno));
 			return -1;
 		}
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
