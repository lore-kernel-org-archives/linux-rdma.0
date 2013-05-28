From: Line Holen <line.holen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] Segfault in osm_mgrp_delete_port()
Date: Tue, 28 May 2013 04:20:54 -0700 (PDT)
Message-ID: <051b06cb-edf4-4b84-9030-1a1108d5fe25@default>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Segfaults can occur in osm_mgrp_delete_port() if the last
full member of a MCG is removed while other non-full members
still exist.

Signed-off-by: Line Holen <Line.Holen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

---

diff --git a/include/opensm/osm_multicast.h b/include/opensm/osm_multicast.h
index 11d789b..e192a72 100644
--- a/include/opensm/osm_multicast.h
+++ b/include/opensm/osm_multicast.h
@@ -2,6 +2,7 @@
  * Copyright (c) 2004-2009 Voltaire, Inc. All rights reserved.
  * Copyright (c) 2002-2012 Mellanox Technologies LTD. All rights reserved.
  * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
+ * Copyright (c) 2013 Oracle and/or its affiliates. All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
@@ -447,7 +448,7 @@ void osm_mgrp_delete_port(IN osm_subn_t * subn, IN osm_log_t * log,
 * SEE ALSO
 *********/
 
-void osm_mgrp_remove_port(osm_subn_t * subn, osm_log_t * log, osm_mgrp_t * mgrp,
+boolean_t osm_mgrp_remove_port(osm_subn_t * subn, osm_log_t * log, osm_mgrp_t * mgrp,
 			  osm_mcm_alias_guid_t * mcm_alias_guid,
 			  ib_member_rec_t * mcmr);
 void osm_mgrp_cleanup(osm_subn_t * subn, osm_mgrp_t * mpgr);
diff --git a/opensm/osm_multicast.c b/opensm/osm_multicast.c
index c43d58d..eb93c55 100644
--- a/opensm/osm_multicast.c
+++ b/opensm/osm_multicast.c
@@ -2,6 +2,7 @@
  * Copyright (c) 2004-2009 Voltaire, Inc. All rights reserved.
  * Copyright (c) 2002-2012 Mellanox Technologies LTD. All rights reserved.
  * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
+ * Copyright (c) 2013 Oracle and/or its affiliates. All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
@@ -338,12 +339,13 @@ osm_mcm_port_t *osm_mgrp_add_port(IN osm_subn_t * subn, osm_log_t * log,
 	return mcm_port;
 }
 
-void osm_mgrp_remove_port(osm_subn_t * subn, osm_log_t * log, osm_mgrp_t * mgrp,
+boolean_t osm_mgrp_remove_port(osm_subn_t * subn, osm_log_t * log, osm_mgrp_t * mgrp,
 			  osm_mcm_alias_guid_t * mcm_alias_guid,
 			  ib_member_rec_t *mcmr)
 {
 	uint8_t join_state = mcmr->scope_state & 0xf;
 	uint8_t port_join_state, new_join_state;
+	boolean_t mgrp_deleted = FALSE;
 
 	/*
 	 * according to the same o15-0.1.14 we get the stored
@@ -406,9 +408,12 @@ void osm_mgrp_remove_port(osm_subn_t * subn, osm_log_t * log, osm_mgrp_t * mgrp,
 	    --mgrp->full_members == 0) {
 		mgrp_send_notice(subn, log, mgrp, 67);
 		osm_mgrp_cleanup(subn, mgrp);
+		mgrp_deleted = TRUE;
 	}
 
 	subn->p_osm->sa.dirty = TRUE;
+
+	return (mgrp_deleted);
 }
 
 void osm_mgrp_delete_port(osm_subn_t * subn, osm_log_t * log, osm_mgrp_t * mgrp,
@@ -416,14 +421,16 @@ void osm_mgrp_delete_port(osm_subn_t * subn, osm_log_t * log, osm_mgrp_t * mgrp,
 {
 	osm_mcm_alias_guid_t *mcm_alias_guid, *next_mcm_alias_guid;
 	ib_member_rec_t mcmrec;
+	boolean_t mgrp_deleted = FALSE;
 
 	next_mcm_alias_guid = (osm_mcm_alias_guid_t *) cl_qmap_head(&mgrp->mcm_alias_port_tbl);
-	while (next_mcm_alias_guid != (osm_mcm_alias_guid_t *) cl_qmap_end(&mgrp->mcm_alias_port_tbl)) {
+	while (next_mcm_alias_guid != (osm_mcm_alias_guid_t *) cl_qmap_end(&mgrp->mcm_alias_port_tbl) &&
+	      !mgrp_deleted) {
 		mcm_alias_guid = next_mcm_alias_guid;
 		next_mcm_alias_guid = (osm_mcm_alias_guid_t *) cl_qmap_next(&next_mcm_alias_guid->map_item);
 		if (mcm_alias_guid->p_base_mcm_port->port == port) {
 			mcmrec.scope_state = 0xf;
-			osm_mgrp_remove_port(subn, log, mgrp, mcm_alias_guid,
+			mgrp_deleted = osm_mgrp_remove_port(subn, log, mgrp, mcm_alias_guid,
 					     &mcmrec);
 		}
 	}
diff --git a/opensm/osm_sa_mcmember_record.c b/opensm/osm_sa_mcmember_record.c
index 242fcde..4d4070f 100644
--- a/opensm/osm_sa_mcmember_record.c
+++ b/opensm/osm_sa_mcmember_record.c
@@ -3,6 +3,7 @@
  * Copyright (c) 2002-2011 Mellanox Technologies LTD. All rights reserved.
  * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
  * Copyright (c) 2008 Xsigo Systems Inc.  All rights reserved.
+ * Copyright (c) 2013 Oracle and/or its affiliates. All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
@@ -979,7 +980,7 @@ static void mcmr_rcv_leave_mgrp(IN osm_sa_t * sa, IN osm_madw_t * p_madw)
 	}
 
 	/* remove port and/or update join state */
-	osm_mgrp_remove_port(sa->p_subn, sa->p_log, p_mgrp, p_mcm_alias_guid,
+	(void) osm_mgrp_remove_port(sa->p_subn, sa->p_log, p_mgrp, p_mcm_alias_guid,
 			     &mcmember_rec);
 	CL_PLOCK_RELEASE(sa->p_lock);
 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
