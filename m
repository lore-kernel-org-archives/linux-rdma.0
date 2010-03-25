From: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] opensm: minor improvement SA DB restore flow
Date: Thu, 25 Mar 2010 17:42:20 +0200
Message-ID: <4BAB845C.7080100@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Sasha,

Minor improvement SA DB restore: check if it's not the first
time master sweep before entering the restore function, and
lose one unnecessary log message.

Signed-off-by: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
---
 opensm/opensm/osm_sa.c        |    8 +-------
 opensm/opensm/osm_state_mgr.c |   13 ++++++++-----
 2 files changed, 9 insertions(+), 12 deletions(-)

diff --git a/opensm/opensm/osm_sa.c b/opensm/opensm/osm_sa.c
index 3473e4c..ea87275 100644
--- a/opensm/opensm/osm_sa.c
+++ b/opensm/opensm/osm_sa.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (c) 2004-2009 Voltaire, Inc. All rights reserved.
- * Copyright (c) 2002-2009 Mellanox Technologies LTD. All rights reserved.
+ * Copyright (c) 2002-2010 Mellanox Technologies LTD. All rights reserved.
  * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
  * Copyright (c) 2008 Xsigo Systems Inc.  All rights reserved.
  *
@@ -907,12 +907,6 @@ int osm_sa_db_file_load(osm_opensm_t * p_osm)
 	unsigned rereg_clients = 0;
 	unsigned lineno;

-	if (!p_osm->subn.first_time_master_sweep) {
-		OSM_LOG(&p_osm->log, OSM_LOG_VERBOSE,
-			"Not first sweep - skip SA DB restore\n");
-		return 0;
-	}
-
 	file_name = p_osm->subn.opt.sa_db_file;
 	if (!file_name) {
 		OSM_LOG(&p_osm->log, OSM_LOG_VERBOSE,
diff --git a/opensm/opensm/osm_state_mgr.c b/opensm/opensm/osm_state_mgr.c
index e43463f..f3f004a 100644
--- a/opensm/opensm/osm_state_mgr.c
+++ b/opensm/opensm/osm_state_mgr.c
@@ -1,7 +1,7 @@
 /*
  * Copyright (c) 2009 Sun Microsystems, Inc. All rights reserved.
  * Copyright (c) 2004-2009 Voltaire, Inc. All rights reserved.
- * Copyright (c) 2002-2009 Mellanox Technologies LTD. All rights reserved.
+ * Copyright (c) 2002-2010 Mellanox Technologies LTD. All rights reserved.
  * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
  * Copyright (c) 2009 HNR Consulting. All rights reserved.
  *
@@ -1261,10 +1261,13 @@ repeat_discovery:

 	osm_qos_setup(sm->p_subn->p_osm);

-	/* try to restore SA DB (this should be before lid_mgr
-	   because we may want to disable clients reregistration
-	   when SA DB is restored) */
-	osm_sa_db_file_load(sm->p_subn->p_osm);
+	/*
+	 * If it's the first master sweep, try to restore SA DB
+	 * (this should be before lid_mgr because we may want to
+	 * disable clients reregistration when SA DB is restored)
+	 */
+	if (sm->p_subn->first_time_master_sweep)
+		osm_sa_db_file_load(sm->p_subn->p_osm);

 	if (wait_for_pending_transactions(&sm->p_subn->p_osm->stats))
 		return;
-- 
1.5.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
