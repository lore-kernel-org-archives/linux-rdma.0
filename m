From: Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Subject: [PATCH] opensm/osm_vl_arb_rcv.c: Dump table after validating block
	number
Date: Mon, 4 Jan 2010 14:15:30 -0500
Message-ID: <20100104191530.GA21463@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


rather than before so don't access "invalid" memory

Signed-off-by: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
diff --git a/opensm/opensm/osm_vl_arb_rcv.c b/opensm/opensm/osm_vl_arb_rcv.c
index bc15a55..823a9ca 100644
--- a/opensm/opensm/osm_vl_arb_rcv.c
+++ b/opensm/opensm/osm_vl_arb_rcv.c
@@ -2,6 +2,7 @@
  * Copyright (c) 2004-2009 Voltaire, Inc. All rights reserved.
  * Copyright (c) 2002-2005 Mellanox Technologies LTD. All rights reserved.
  * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
+ * Copyright (c) 2010 HNR Consulting. All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
@@ -134,15 +135,14 @@ void osm_vla_rcv_process(IN void *context, IN void *data)
 		goto Exit;
 	}
 
-	osm_dump_vl_arb_table(sm->p_log,
-			      port_guid, block_num,
-			      port_num, p_vla_tbl, OSM_LOG_DEBUG);
-
 	if ((block_num < 1) || (block_num > 4)) {
 		OSM_LOG(sm->p_log, OSM_LOG_ERROR,
 			"Got invalid block number 0x%X\n", block_num);
 		goto Exit;
 	}
+
+	osm_dump_vl_arb_table(sm->p_log, port_guid, block_num, port_num,
+			      p_vla_tbl, OSM_LOG_DEBUG);
 	osm_physp_set_vla_tbl(p_physp, p_vla_tbl, block_num);
 
 Exit:
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
