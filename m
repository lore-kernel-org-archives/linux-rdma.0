From: Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Subject: [PATCH] opensm/osm_trap_rcv.c: No need to check for sweep for trap
	145
Date: Thu, 17 Jun 2010 11:38:45 -0400
Message-ID: <20100617153845.GA7729@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


Trap 145 merely carries the SystemImageGUID (and indication that it changed)
so there is no need (to even check) for sweep

Signed-off-by: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
diff --git a/opensm/opensm/osm_trap_rcv.c b/opensm/opensm/osm_trap_rcv.c
index 500632c..71429c4 100644
--- a/opensm/opensm/osm_trap_rcv.c
+++ b/opensm/opensm/osm_trap_rcv.c
@@ -2,7 +2,7 @@
  * Copyright (c) 2004-2009 Voltaire, Inc. All rights reserved.
  * Copyright (c) 2002-2007 Mellanox Technologies LTD. All rights reserved.
  * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
- * Copyright (c) 2009 HNR Consulting. All rights reserved.
+ * Copyright (c) 2009,2010 HNR Consulting. All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
@@ -510,10 +510,12 @@ static void trap_rcv_process_request(IN osm_sm_t * sm,
 				"ERR 3812: No physical port found for "
 				"trap 144: \"node description update\"\n");
 		goto check_sweep;
-	} else if (cl_ntoh16(p_ntci->g_or_v.generic.trap_num) == 145)
+	} else if (cl_ntoh16(p_ntci->g_or_v.generic.trap_num) == 145) {
 		/* this assumes that trap 145 content is not broken? */
 		p_physp->p_node->node_info.sys_guid =
 			p_ntci->data_details.ntc_145.new_sys_guid;
+		goto check_report;
+	}
 
 check_sweep:
 	/* do a sweep if we received a trap */
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
