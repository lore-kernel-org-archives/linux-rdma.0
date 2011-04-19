From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] opensm: Fix some OSM_SIGNAL and OSM_SM_SIGNAL numbering
Date: Tue, 19 Apr 2011 15:05:12 -0400
Message-ID: <4DADDCE8.1090801@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/include/opensm/osm_base.h b/include/opensm/osm_base.h
index 3735610..07e971d 100644
--- a/include/opensm/osm_base.h
+++ b/include/opensm/osm_base.h
@@ -1,6 +1,6 @@
 /*
  * Copyright (c) 2004-2009 Voltaire, Inc. All rights reserved.
- * Copyright (c) 2002-2009 Mellanox Technologies LTD. All rights reserved.
+ * Copyright (c) 2002-2011 Mellanox Technologies LTD. All rights reserved.
  * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
  * Copyright (c) 2009 Sun Microsystems, Inc. All rights reserved.
  *
@@ -836,7 +836,7 @@ typedef enum _osm_thread_state {
 #define OSM_SIGNAL_SWEEP			1
 #define OSM_SIGNAL_IDLE_TIME_PROCESS_REQUEST	2
 #define OSM_SIGNAL_PERFMGR_SWEEP		3
-#define OSM_SIGNAL_MAX				3
+#define OSM_SIGNAL_MAX				4
 
 typedef unsigned int osm_signal_t;
 /***********/
diff --git a/opensm/osm_helper.c b/opensm/osm_helper.c
index 2a77b00..0b0580a 100644
--- a/opensm/osm_helper.c
+++ b/opensm/osm_helper.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (c) 2004-2009 Voltaire, Inc. All rights reserved.
- * Copyright (c) 2002-2010 Mellanox Technologies LTD. All rights reserved.
+ * Copyright (c) 2002-2011 Mellanox Technologies LTD. All rights reserved.
  * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
  * Copyright (c) 2009 HNR Consulting. All rights reserved.
  * Copyright (c) 2009 Sun Microsystems, Inc. All rights reserved.
@@ -2014,9 +2014,8 @@ static const char *sm_signal_str[] = {
 	"OSM_SIGNAL_NONE",	/* 0 */
 	"OSM_SIGNAL_SWEEP",	/* 1 */
 	"OSM_SIGNAL_IDLE_TIME_PROCESS_REQUEST",	/* 2 */
-	"OSM_SIGNAL_EXIT_STBY",	/* 3 */
-	"OSM_SIGNAL_PERFMGR_SWEEP",	/* 4 */
-	"UNKNOWN SIGNAL!!"	/* 5 */
+	"OSM_SIGNAL_PERFMGR_SWEEP",	/* 3 */
+	"UNKNOWN SIGNAL!!"	/* 4 */
 };
 
 const char *osm_get_sm_signal_str(IN osm_signal_t signal)
@@ -2250,17 +2249,17 @@ const char *osm_get_lsa_str(IN uint8_t lsa)
 
 static const char *sm_mgr_signal_str[] = {
 	"OSM_SM_SIGNAL_NONE",	/* 0 */
-	"OSM_SM_SIGNAL_DISCOVERY_COMPLETED",	/* 2 */
-	"OSM_SM_SIGNAL_POLLING_TIMEOUT",	/* 3 */
-	"OSM_SM_SIGNAL_DISCOVER",	/* 4 */
-	"OSM_SM_SIGNAL_DISABLE",	/* 5 */
-	"OSM_SM_SIGNAL_HANDOVER",	/* 6 */
-	"OSM_SM_SIGNAL_HANDOVER_SENT",	/* 7 */
-	"OSM_SM_SIGNAL_ACKNOWLEDGE",	/* 8 */
-	"OSM_SM_SIGNAL_STANDBY",	/* 9 */
-	"OSM_SM_SIGNAL_MASTER_OR_HIGHER_SM_DETECTED",	/* 10 */
-	"OSM_SM_SIGNAL_WAIT_FOR_HANDOVER",	/* 11 */
-	"UNKNOWN STATE!!"	/* 12 */
+	"OSM_SM_SIGNAL_DISCOVERY_COMPLETED",	/* 1 */
+	"OSM_SM_SIGNAL_POLLING_TIMEOUT",	/* 2 */
+	"OSM_SM_SIGNAL_DISCOVER",	/* 3 */
+	"OSM_SM_SIGNAL_DISABLE",	/* 4 */
+	"OSM_SM_SIGNAL_HANDOVER",	/* 5 */
+	"OSM_SM_SIGNAL_HANDOVER_SENT",	/* 6 */
+	"OSM_SM_SIGNAL_ACKNOWLEDGE",	/* 7 */
+	"OSM_SM_SIGNAL_STANDBY",	/* 8 */
+	"OSM_SM_SIGNAL_MASTER_OR_HIGHER_SM_DETECTED",	/* 9 */
+	"OSM_SM_SIGNAL_WAIT_FOR_HANDOVER",	/* 10 */
+	"UNKNOWN STATE!!"	/* 11 */
 };
 
 const char *osm_get_sm_mgr_signal_str(IN osm_sm_signal_t signal)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
