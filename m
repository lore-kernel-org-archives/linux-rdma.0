From: Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Subject: [PATCH] opensm/osm_mcast_mgr.c: Only route MLIDs with more than 1
	member
Date: Fri, 5 Feb 2010 08:20:13 -0500
Message-ID: <20100205132013.GA30528@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


rather than just more than 0 members. There is no need to route MLIDs with
only 1 member as single member case is handled locally. MLIDs only need
routing when 2 or more members.

Signed-off-by: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
diff --git a/opensm/opensm/osm_mcast_mgr.c b/opensm/opensm/osm_mcast_mgr.c
index 322635d..e42070d 100644
--- a/opensm/opensm/osm_mcast_mgr.c
+++ b/opensm/opensm/osm_mcast_mgr.c
@@ -4,6 +4,7 @@
  * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
  * Copyright (c) 2008 Xsigo Systems Inc.  All rights reserved.
  * Copyright (c) 2009 Sun Microsystems, Inc. All rights reserved.
+ * Copyright (c) 2010 HNR Consulting. All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
@@ -746,10 +747,10 @@ static ib_api_status_t mcast_mgr_build_spanning_tree(osm_sm_t * sm,
 	}
 
 	num_ports = cl_qlist_count(&port_list);
-	if (num_ports == 0) {
+	if (num_ports < 2) {
 		OSM_LOG(sm->p_log, OSM_LOG_VERBOSE,
-			"MLID 0x%X has no members - nothing to do\n",
-			mbox->mlid);
+			"MLID 0x%X has %u members - nothing to do\n",
+			mbox->mlid, num_ports);
 		goto Exit;
 	}
 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
