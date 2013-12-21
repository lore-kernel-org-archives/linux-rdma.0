From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH v2 opensm] Add support for synchronizing in memory files with
 storage
Date: Sat, 21 Dec 2013 07:54:48 -0500
Message-ID: <52B58F98.7040804@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jim Mott <jim-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


OpenSM produces certain in memory files critical to high availability
operation. These include guid2lid, guid2mkey, and neighbors as well 
as the SA registration database (opensm-sa.dump).

These in memory files can be synchronized with storage immediately
rather than waiting for pdflush daemon to do this.

This is done based on new fsync_high_avail_files option which defaults to true.
In some embedded systems with flash based storage, this option might
be set to false as tradeoff not to unduly affect OpenSM operation due to
possible long delay.

Pointed-out-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org> in thread on
"[PATCH opensm] Implement atomic update operation for sa_db_file"
http://marc.info/?l=linux-rdma&m=138436562629008&w=2

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
Change since v1:
Added missing fflush call prior to fsync
Pointed-out-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>

diff --git a/include/opensm/osm_db.h b/include/opensm/osm_db.h
index 05332c0..e8860f3 100644
--- a/include/opensm/osm_db.h
+++ b/include/opensm/osm_db.h
@@ -288,7 +288,8 @@ int osm_db_clear(IN osm_db_domain_t * p_domain);
 *
 * SYNOPSIS
 */
-int osm_db_store(IN osm_db_domain_t * p_domain);
+int osm_db_store(IN osm_db_domain_t * p_domain,
+		 IN boolean_t fsync_high_avail_files);
 /*
 * PARAMETERS
 *
@@ -296,6 +297,10 @@ int osm_db_store(IN osm_db_domain_t * p_domain);
 *		[in] Pointer to the database domain object to restore from
 *		     persistent db
 *
+*	fsync_high_avail_files
+*		[in] Boolean that indicates whether or not to synchronize
+*		     in-memory high availability files with storage
+*
 * RETURN VALUES
 *	0 if successful 1 otherwize
 *
diff --git a/include/opensm/osm_subnet.h b/include/opensm/osm_subnet.h
index 19f2079..606c63e 100644
--- a/include/opensm/osm_subnet.h
+++ b/include/opensm/osm_subnet.h
@@ -328,6 +328,7 @@ typedef struct osm_subn_opt {
 	boolean_t babbling_port_policy;
 	boolean_t drop_event_subscriptions;
 	boolean_t use_optimized_slvl;
+	boolean_t fsync_high_avail_files;
 	osm_qos_options_t qos_options;
 	osm_qos_options_t qos_ca_options;
 	osm_qos_options_t qos_sw0_options;
@@ -604,6 +605,10 @@ typedef struct osm_subn_opt {
 *		Use optimized SLtoVLMappingTable programming if
 *		device indicates it supports this.
 *
+*	fsync_high_avail_files
+*		Synchronize high availability in memory files
+*		with storage.
+*
 *	perfmgr
 *		Enable or disable the performance manager
 *
diff --git a/opensm/osm_db_files.c b/opensm/osm_db_files.c
index cab7170..38ee9a9 100644
--- a/opensm/osm_db_files.c
+++ b/opensm/osm_db_files.c
@@ -48,6 +48,7 @@
 #include <errno.h>
 #include <stdlib.h>
 #include <string.h>
+#include <unistd.h>
 #include <opensm/osm_file_ids.h>
 #define FILE_ID OSM_FILE_DB_FILES_C
 #include <opensm/st.h>
@@ -461,12 +462,13 @@ static int dump_tbl_entry(st_data_t key, st_data_t val, st_data_t arg)
 	return ST_CONTINUE;
 }
 
-int osm_db_store(IN osm_db_domain_t * p_domain)
+int osm_db_store(IN osm_db_domain_t * p_domain,
+		 IN boolean_t fsync_high_avail_files)
 {
 	osm_log_t *p_log = p_domain->p_db->p_log;
 	osm_db_domain_imp_t *p_domain_imp;
 	FILE *p_file = NULL;
-	int status = 0;
+	int fd, status = 0;
 	char *p_tmp_file_name = NULL;
 
 	OSM_LOG_ENTER(p_log);
@@ -494,6 +496,26 @@ int osm_db_store(IN osm_db_domain_t * p_domain)
 	}
 
 	st_foreach(p_domain_imp->p_hash, dump_tbl_entry, (st_data_t) p_file);
+
+	if (fsync_high_avail_files) {
+		if (fflush(p_file) == 0) {
+			fd = fileno(p_file);
+			if (fd != -1) {
+				if (fsync(fd) == -1)
+					OSM_LOG(p_log, OSM_LOG_ERROR,
+						"ERR 6110: fsync() failed (%s) for %s\n",
+						strerror(errno),
+						p_domain_imp->file_name);
+			} else
+				OSM_LOG(p_log, OSM_LOG_ERROR, "ERR 6111: "
+					"fileno() failed for %s\n",
+					p_domain_imp->file_name);
+		} else
+			OSM_LOG(p_log, OSM_LOG_ERROR, "ERR 6112: "
+				"fflush() failed (%s) for %s\n",
+				strerror(errno), p_domain_imp->file_name);
+	}
+
 	fclose(p_file);
 
 	status = rename(p_tmp_file_name, p_domain_imp->file_name);
@@ -734,7 +756,7 @@ int main(int argc, char **argv)
 			printf("key = %s val = %s\n", p_key, p_val);
 		}
 	}
-	if (osm_db_store(p_dbd))
+	if (osm_db_store(p_dbd, FALSE))
 		printf("failed to store\n");
 
 	osm_db_destroy(&db);
diff --git a/opensm/osm_lid_mgr.c b/opensm/osm_lid_mgr.c
index f8a3739..3ba1a79 100644
--- a/opensm/osm_lid_mgr.c
+++ b/opensm/osm_lid_mgr.c
@@ -1233,7 +1233,7 @@ int osm_lid_mgr_process_subnet(IN osm_lid_mgr_t * p_mgr)
 	}			/* all ports */
 
 	/* store the guid to lid table in persistent db */
-	osm_db_store(p_mgr->p_g2l);
+	osm_db_store(p_mgr->p_g2l, p_mgr->p_subn->opt.fsync_high_avail_files);
 
 	CL_PLOCK_RELEASE(p_mgr->p_lock);
 
diff --git a/opensm/osm_sa.c b/opensm/osm_sa.c
index 4b15d39..ea4a4d0 100644
--- a/opensm/osm_sa.c
+++ b/opensm/osm_sa.c
@@ -49,6 +49,7 @@
 #include <ctype.h>
 #include <errno.h>
 #include <stdlib.h>
+#include <unistd.h>
 #include <sys/types.h>
 #include <sys/stat.h>
 #include <complib/cl_qmap.h>
@@ -508,7 +509,7 @@ opensm_dump_to_file(osm_opensm_t * p_osm, const char *file_name,
 	char path[1024];
 	char path_tmp[1032];
 	FILE *file;
-	int status = 0;
+	int fd, status = 0;
 
 	snprintf(path, sizeof(path), "%s/%s",
 		 p_osm->subn.opt.dump_files_dir, file_name);
@@ -527,6 +528,23 @@ opensm_dump_to_file(osm_opensm_t * p_osm, const char *file_name,
 
 	dump_func(p_osm, file);
 
+	if (p_osm->subn.opt.fsync_high_avail_files) {
+		if (fflush(file) == 0) {
+			fd = fileno(file);
+			if (fd != -1) {
+				if (fsync(fd) == -1)
+					OSM_LOG(&p_osm->log, OSM_LOG_ERROR,
+						"ERR 4C08: fsync() failed (%s) for %s\n",
+						strerror(errno), path_tmp);
+			} else
+				OSM_LOG(&p_osm->log, OSM_LOG_ERROR, "ERR 4C09: "
+					"fileno() failed for %s\n", path_tmp);
+		} else
+			OSM_LOG(&p_osm->log, OSM_LOG_ERROR, "ERR 4C0A: "
+				"fflush() failed (%s) for %s\n",
+				strerror(errno), path_tmp);
+	}
+
 	fclose(file);
 
 	status = rename(path_tmp, path);
diff --git a/opensm/osm_state_mgr.c b/opensm/osm_state_mgr.c
index 10ae17a..85b233d 100644
--- a/opensm/osm_state_mgr.c
+++ b/opensm/osm_state_mgr.c
@@ -1493,8 +1493,9 @@ repeat_discovery:
 		osm_sm_signal(sm, OSM_SIGNAL_SWEEP);
 
 	/* Write a new copy of our persistent guid2mkey database */
-	osm_db_store(sm->p_subn->p_g2m);
-	osm_db_store(sm->p_subn->p_neighbor);
+	osm_db_store(sm->p_subn->p_g2m, sm->p_subn->opt.fsync_high_avail_files);
+	osm_db_store(sm->p_subn->p_neighbor,
+		     sm->p_subn->opt.fsync_high_avail_files);
 }
 
 static void do_process_mgrp_queue(osm_sm_t * sm)
diff --git a/opensm/osm_subnet.c b/opensm/osm_subnet.c
index f7b6942..b69b54e 100644
--- a/opensm/osm_subnet.c
+++ b/opensm/osm_subnet.c
@@ -778,6 +778,7 @@ static const opt_rec_t opt_tbl[] = {
 	{ "babbling_port_policy", OPT_OFFSET(babbling_port_policy), opts_parse_boolean, NULL, 1 },
 	{ "drop_event_subscriptions", OPT_OFFSET(drop_event_subscriptions), opts_parse_boolean, NULL, 1 },
 	{ "use_optimized_slvl", OPT_OFFSET(use_optimized_slvl), opts_parse_boolean, NULL, 1 },
+	{ "fsync_high_avail_files", OPT_OFFSET(fsync_high_avail_files), opts_parse_boolean, NULL, 1 },
 #ifdef ENABLE_OSM_PERF_MGR
 	{ "perfmgr", OPT_OFFSET(perfmgr), opts_parse_boolean, NULL, 0 },
 	{ "perfmgr_redir", OPT_OFFSET(perfmgr_redir), opts_parse_boolean, NULL, 0 },
@@ -1483,6 +1484,7 @@ void osm_subn_set_default_opt(IN osm_subn_opt_t * p_opt)
 	p_opt->babbling_port_policy = FALSE;
 	p_opt->drop_event_subscriptions = FALSE;
 	p_opt->use_optimized_slvl = FALSE;
+	p_opt->fsync_high_avail_files = TRUE;
 #ifdef ENABLE_OSM_PERF_MGR
 	p_opt->perfmgr = FALSE;
 	p_opt->perfmgr_redir = TRUE;
@@ -2538,12 +2540,15 @@ int osm_subn_output_conf(FILE *out, IN osm_subn_opt_t * p_opts)
 		"# Drop event subscriptions (InformInfo) if the port goes away\n"
 		"drop_event_subscriptions %s\n\n"
 		"# Use Optimized SLtoVLMapping programming if supported by device\n"
-		"use_optimized_slvl %s\n\n",
+		"use_optimized_slvl %s\n\n"
+		"# Sync in memory files used for high availability with storage\n"
+		"fsync_high_avail_files %s\n\n",
 		p_opts->daemon ? "TRUE" : "FALSE",
 		p_opts->sm_inactive ? "TRUE" : "FALSE",
 		p_opts->babbling_port_policy ? "TRUE" : "FALSE",
 		p_opts->drop_event_subscriptions ? "TRUE" : "FALSE",
-		p_opts->use_optimized_slvl ? "TRUE" : "FALSE");
+		p_opts->use_optimized_slvl ? "TRUE" : "FALSE",
+		p_opts->fsync_high_avail_files ? "TRUE" : "FALSE");
 
 #ifdef ENABLE_OSM_PERF_MGR
 	fprintf(out,
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
