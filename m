From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] opensm: Move per_mod_log_tbl array from subn to log structure
Date: Mon, 30 Jul 2012 10:57:44 +0300
Message-ID: <20120730075744.GK2590@calypso>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Having per_mod_log_tbl as part of subn structure is problematic because it means that
subn structure should be part of libopensm which is highly undesired, so moving
per_mod_log_tbl array from subn to log structure breaks that coupling.

Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 include/opensm/osm_log.h    | 65 +++++++++++++++++++++++++++++++++++++--------
 include/opensm/osm_subnet.h |  9 -------
 opensm/libopensm.map        |  2 ++
 opensm/osm_log.c            | 21 ++++++++++-----
 opensm/osm_opensm.c         |  1 -
 opensm/osm_subnet.c         |  4 +--
 6 files changed, 73 insertions(+), 29 deletions(-)

diff --git a/include/opensm/osm_log.h b/include/opensm/osm_log.h
index 535d35e..3247296 100644
--- a/include/opensm/osm_log.h
+++ b/include/opensm/osm_log.h
@@ -48,7 +48,6 @@
 #endif
 #include <complib/cl_spinlock.h>
 #include <opensm/osm_base.h>
-#include <opensm/osm_subnet.h>
 #include <iba/ib_types.h>
 #include <stdio.h>
 
@@ -99,10 +98,7 @@ BEGIN_C_DECLS
 * AUTHOR
 *
 *********/
-#ifndef OSM_LOG_LEVEL_T_DEFINED
-#define OSM_LOG_LEVEL_T_DEFINED
 typedef uint8_t osm_log_level_t;
-#endif
 
 #define OSM_LOG_NONE	0x00
 #define OSM_LOG_ERROR	0x01
@@ -139,7 +135,7 @@ typedef struct osm_log {
 	boolean_t daemon;
 	char *log_file_name;
 	char *log_prefix;
-	osm_subn_t *p_subn;
+	osm_log_level_t per_mod_log_tbl[256];
 } osm_log_t;
 /*********/
 
@@ -156,12 +152,12 @@ typedef struct osm_log {
  *
  * SYNOPSIS
  */
-osm_log_level_t osm_get_log_per_module(IN osm_subn_t * subn,
+osm_log_level_t osm_get_log_per_module(IN osm_log_t * p_log,
 				       IN const int file_id);
 /*
  * PARAMETERS
- *	subn
- *		[in] Pointer to an osm_subn_t object
+ *	p_log
+ *		[in] Pointer to a Log object to construct.
  *
  *	file_id
  *		[in] File ID for module
@@ -170,6 +166,55 @@ osm_log_level_t osm_get_log_per_module(IN osm_subn_t * subn,
  *	The log level from the per module logging structure for this file ID.
  *********/
 
+/****f* OpenSM: Log/osm_set_log_per_module
+ * NAME
+ *	osm_set_log_per_module
+ *
+ * DESCRIPTION
+ *	This sets log level for the given file ID in the per module log table.
+ *	NOTE: this code is not thread safe. Need to grab the lock before
+ *	calling it.
+ *
+ * SYNOPSIS
+ */
+void osm_set_log_per_module(IN osm_log_t * p_log, IN const int file_id,
+			    IN osm_log_level_t level);
+/*
+ * PARAMETERS
+ *	p_log
+ *		[in] Pointer to a Log object to construct.
+ *
+ *	file_id
+ *		[in] File ID for module
+ *
+ *	level
+ *		[in] Log level of the module
+ *
+ * RETURN VALUES
+ *	This function does not return a value.
+ *********/
+
+/****f* OpenSM: Log/osm_reset_log_per_module
+ * NAME
+ *	osm_reset_log_per_module
+ *
+ * DESCRIPTION
+ *	This resets log level for the entire per module log table.
+ *	NOTE: this code is not thread safe. Need to grab the lock before
+ *	calling it.
+ *
+ * SYNOPSIS
+ */
+void osm_reset_log_per_module(IN osm_log_t * p_log);
+/*
+ * PARAMETERS
+ *	p_log
+ *		[in] Pointer to a Log object to construct.
+ *
+ * RETURN VALUES
+ *	This function does not return a value.
+ *********/
+
 /****f* OpenSM: Log/osm_log_construct
 * NAME
 *	osm_log_construct
@@ -432,9 +477,7 @@ static inline boolean_t osm_log_is_active_v2(IN const osm_log_t * p_log,
 {
 	if ((p_log->level & level) != 0)
 		return 1;
-	if (!p_log->p_subn)
-		return 0;
-	if ((level & p_log->p_subn->per_mod_log_tbl[file_id]))
+	if ((level & p_log->per_mod_log_tbl[file_id]))
 		return 1;
 	return 0;
 }
diff --git a/include/opensm/osm_subnet.h b/include/opensm/osm_subnet.h
index 683204b..7f3d6e9 100644
--- a/include/opensm/osm_subnet.h
+++ b/include/opensm/osm_subnet.h
@@ -74,11 +74,6 @@ BEGIN_C_DECLS
 #define OSM_PARTITION_ENFORCE_OUT			"out"
 #define OSM_PARTITION_ENFORCE_OFF			"off"
 
-#ifndef OSM_LOG_LEVEL_T_DEFINED
-#define OSM_LOG_LEVEL_T_DEFINED
-typedef uint8_t osm_log_level_t;
-#endif
-
 typedef enum _osm_partition_enforce_type_enum {
 	OSM_PARTITION_ENFORCE_TYPE_BOTH,
 	OSM_PARTITION_ENFORCE_TYPE_IN,
@@ -604,7 +599,6 @@ typedef struct osm_subn {
 	unsigned need_update;
 	cl_fmap_t mgrp_mgid_tbl;
 	void *mboxes[IB_LID_MCAST_END_HO - IB_LID_MCAST_START_HO + 1];
-	osm_log_level_t per_mod_log_tbl[256];
 } osm_subn_t;
 /*
 * FIELDS
@@ -749,9 +743,6 @@ typedef struct osm_subn {
 *		Array of pointers to all Multicast MLID box objects in the
 *		subnet. Indexed by MLID offset from base MLID.
 *
-*	per_mod_log_tbl
-*		Array of log levels based on per module logging file ID.
-*
 * SEE ALSO
 *	Subnet object
 *********/
diff --git a/opensm/libopensm.map b/opensm/libopensm.map
index 1735488..e75d424 100644
--- a/opensm/libopensm.map
+++ b/opensm/libopensm.map
@@ -92,5 +92,7 @@ OPENSM_1.5 {
 		osm_log_msg_box_v2;
 		osm_log_is_active_v2;
 		osm_get_log_per_module;
+		osm_set_log_per_module;
+		osm_reset_log_per_module;
 	local: *;
 };
diff --git a/opensm/osm_log.c b/opensm/osm_log.c
index 94f0d03..2b7efe6 100644
--- a/opensm/osm_log.c
+++ b/opensm/osm_log.c
@@ -239,9 +239,7 @@ void osm_log_v2(IN osm_log_t * p_log, IN osm_log_level_t verbosity,
 
 	/* If this is a call to syslog - always print it */
 	if (!(verbosity & p_log->level)) {
-		if (!p_log->p_subn)
-			return;
-		if (!(verbosity & p_log->p_subn->per_mod_log_tbl[file_id]))
+		if (!(verbosity & p_log->per_mod_log_tbl[file_id]))
 			return;
 	}
 
@@ -472,7 +470,7 @@ ib_api_status_t osm_log_init_v2(IN osm_log_t * p_log, IN boolean_t flush,
 	p_log->max_size = max_size << 20; /* convert size in MB to bytes */
 	p_log->accum_log_file = accum_log_file;
 	p_log->log_file_name = (char *)log_file;
-	p_log->p_subn = NULL;
+	memset(p_log->per_mod_log_tbl, 0, sizeof(p_log->per_mod_log_tbl));
 
 	openlog("OpenSM", LOG_CONS | LOG_PID, LOG_USER);
 
@@ -498,8 +496,19 @@ ib_api_status_t osm_log_init(IN osm_log_t * p_log, IN boolean_t flush,
 			       accum_log_file);
 }
 
-osm_log_level_t osm_get_log_per_module(IN osm_subn_t * subn,
+osm_log_level_t osm_get_log_per_module(IN osm_log_t * p_log,
 				       IN const int file_id)
 {
-	return subn->per_mod_log_tbl[file_id];
+	return p_log->per_mod_log_tbl[file_id];
+}
+
+void osm_set_log_per_module(IN osm_log_t * p_log, IN const int file_id,
+			    IN osm_log_level_t level)
+{
+	p_log->per_mod_log_tbl[file_id] = level;
+}
+
+void osm_reset_log_per_module(IN osm_log_t * p_log)
+{
+	memset(p_log->per_mod_log_tbl, 0, sizeof(p_log->per_mod_log_tbl));
 }
diff --git a/opensm/osm_opensm.c b/opensm/osm_opensm.c
index 429108a..817d111 100644
--- a/opensm/osm_opensm.c
+++ b/opensm/osm_opensm.c
@@ -375,7 +375,6 @@ ib_api_status_t osm_opensm_init(IN osm_opensm_t * p_osm,
 	if (status != IB_SUCCESS)
 		return status;
 	p_osm->log.log_prefix = p_opt->log_prefix;
-	p_osm->log.p_subn = &p_osm->subn;
 
 	/* If there is a log level defined - add the OSM_VERSION to it */
 	osm_log_v2(&p_osm->log,
diff --git a/opensm/osm_subnet.c b/opensm/osm_subnet.c
index ccaa47c..c8c96d1 100644
--- a/opensm/osm_subnet.c
+++ b/opensm/osm_subnet.c
@@ -1201,7 +1201,7 @@ static ib_api_status_t insert_per_module_debug(IN osm_subn_t * p_subn,
 			"Module name %s not found\n", mod_name);
 		return IB_ERROR;
 	}
-	p_subn->per_mod_log_tbl[index] = level;
+	osm_set_log_per_module(&p_subn->p_osm->log, index, level);
 	return IB_SUCCESS;
 }
 
@@ -1213,7 +1213,7 @@ static ib_api_status_t parse_per_mod_logging_file(IN osm_subn_t * p_subn)
 	int line = 0;
 	int errors = 0;
 
-	memset(p_subn->per_mod_log_tbl, 0, sizeof(p_subn->per_mod_log_tbl));
+	osm_reset_log_per_module(log);
 
 	fp = fopen(p_subn->opt.per_module_logging_file, "r");
 	if (!fp) {
-- 
1.7.11.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
