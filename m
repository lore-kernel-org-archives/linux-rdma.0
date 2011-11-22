From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 1/5] opensm: Support allowing both full and limited members
 of same partition
Date: Tue, 22 Nov 2011 15:23:32 -0500
Message-ID: <4ECC04C4.4050401@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


New policy (allow_both_pkeys) added to indicate whether both full and
limited membership on the same partition is allowed or not.

In order to support allow_both_pkeys, the partition file syntax is
extended with "both" flag (in addition to "full" and "limited").

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 include/opensm/osm_pkey.h   |   11 ++++--
 include/opensm/osm_subnet.h |    1 +
 opensm/osm_pkey.c           |   25 ++++++++-----
 opensm/osm_pkey_mgr.c       |    6 +++-
 opensm/osm_port.c           |    3 +-
 opensm/osm_prtn.c           |   23 +++++++++---
 opensm/osm_prtn_config.c    |   80 +++++++++++++++++++++++++++++-------------
 opensm/osm_subnet.c         |    9 ++++-
 8 files changed, 110 insertions(+), 48 deletions(-)

diff --git a/include/opensm/osm_pkey.h b/include/opensm/osm_pkey.h
index 0d284de..d70f5d9 100644
--- a/include/opensm/osm_pkey.h
+++ b/include/opensm/osm_pkey.h
@@ -1,7 +1,7 @@
 /*
  * Copyright (c) 2010 Sun Microsystems, Inc. All rights reserved.
  * Copyright (c) 2004-2009 Voltaire, Inc. All rights reserved.
- * Copyright (c) 2002-2005 Mellanox Technologies LTD. All rights reserved.
+ * Copyright (c) 2002-2010 Mellanox Technologies LTD. All rights reserved.
  * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
  *
  * This software is available to you under a choice of one of two
@@ -472,10 +472,11 @@ osm_pkey_tbl_get_block_and_idx(IN osm_pkey_tbl_t * p_pkey_tbl,
 */
 ib_api_status_t
 osm_pkey_tbl_set(IN osm_pkey_tbl_t * p_pkey_tbl,
-		 IN uint16_t block, IN ib_pkey_table_t * p_tbl);
+		 IN uint16_t block, IN ib_pkey_table_t * p_tbl,
+		 IN boolean_t allow_both_pkeys);
 /*
 *  p_pkey_tbl
-*     [in] Pointer to osm_pkey_tbl_t object.
+*     [in] Pointer to osm_pkey_tbl_t object
 *
 *  block
 *     [in] The block number to set
@@ -483,6 +484,10 @@ osm_pkey_tbl_set(IN osm_pkey_tbl_t * p_pkey_tbl,
 *  p_tbl
 *     [in] The IB PKey block to copy to the object
 *
+*  allow_both_pkeys
+*     [in] Whether both full and limited membership on same partition
+*          are allowed
+*
 * RETURN VALUES
 *  IB_SUCCESS or IB_ERROR
 *
diff --git a/include/opensm/osm_subnet.h b/include/opensm/osm_subnet.h
index 83ef77e..50952fc 100644
--- a/include/opensm/osm_subnet.h
+++ b/include/opensm/osm_subnet.h
@@ -181,6 +181,7 @@ typedef struct osm_subn_opt {
 	unsigned long log_max_size;
 	char *partition_config_file;
 	boolean_t no_partition_enforcement;
+	boolean_t allow_both_pkeys;
 	boolean_t qos;
 	char *qos_policy_file;
 	boolean_t accum_log_file;
diff --git a/opensm/osm_pkey.c b/opensm/osm_pkey.c
index 885f28a..c7c89fd 100644
--- a/opensm/osm_pkey.c
+++ b/opensm/osm_pkey.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (c) 2004-2009 Voltaire, Inc. All rights reserved.
- * Copyright (c) 2002-2006,2008 Mellanox Technologies LTD. All rights reserved.
+ * Copyright (c) 2002-2010 Mellanox Technologies LTD. All rights reserved.
  * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
  *
  * This software is available to you under a choice of one of two
@@ -110,12 +110,13 @@ void osm_pkey_tbl_init_new_blocks(IN const osm_pkey_tbl_t * p_pkey_tbl)
 }
 
 ib_api_status_t osm_pkey_tbl_set(IN osm_pkey_tbl_t * p_pkey_tbl,
-				 IN uint16_t block, IN ib_pkey_table_t * p_tbl)
+				 IN uint16_t block, IN ib_pkey_table_t * p_tbl,
+				 IN boolean_t allow_both_pkeys)
 {
 	uint16_t b, i;
 	ib_pkey_table_t *p_pkey_block;
 	uint16_t *p_prev_pkey;
-	ib_net16_t pkey;
+	ib_net16_t pkey, pkey_base;
 
 	/* make sure the block is allocated */
 	if (cl_ptr_vector_get_size(&p_pkey_tbl->blocks) > block)
@@ -157,19 +158,23 @@ ib_api_status_t osm_pkey_tbl_set(IN osm_pkey_tbl_t * p_pkey_tbl,
 			if (ib_pkey_is_invalid(pkey))
 				continue;
 
+			if (allow_both_pkeys)
+				pkey_base = pkey;
+			else
+				pkey_base = ib_pkey_get_base(pkey);
+
 			/*
+			   If allow_both_pkeys is FALSE,
 			   ignore the PKey Full Member bit in the key but store
 			   the pointer to the table element as the map value
 			 */
-			p_prev_pkey =
-			    cl_map_get(&p_pkey_tbl->keys,
-				       ib_pkey_get_base(pkey));
+			p_prev_pkey = cl_map_get(&p_pkey_tbl->keys, pkey_base);
 
-			/* we only insert if no previous or it is not full member */
+			/* we only insert if no previous or it is not full member and allow_both_pkeys is FALSE */
 			if ((p_prev_pkey == NULL) ||
-			    (cl_ntoh16(*p_prev_pkey) < cl_ntoh16(pkey)))
-				cl_map_insert(&p_pkey_tbl->keys,
-					      ib_pkey_get_base(pkey),
+			    (allow_both_pkeys == FALSE &&
+			     cl_ntoh16(*p_prev_pkey) < cl_ntoh16(pkey)))
+				cl_map_insert(&p_pkey_tbl->keys, pkey_base,
 					      &(p_pkey_block->pkey_entry[i])
 				    );
 		}
diff --git a/opensm/osm_pkey_mgr.c b/opensm/osm_pkey_mgr.c
index 898a3b8..2fff373 100644
--- a/opensm/osm_pkey_mgr.c
+++ b/opensm/osm_pkey_mgr.c
@@ -104,7 +104,11 @@ pkey_mgr_process_physical_port(IN osm_log_t * p_log,
 		return;
 	}
 	p_pending->pkey = pkey;
-	p_orig_pkey = cl_map_get(&p_pkey_tbl->keys, ib_pkey_get_base(pkey));
+	if (sm->p_subn->opt.allow_both_pkeys)
+		p_orig_pkey = cl_map_get(&p_pkey_tbl->keys, pkey);
+	else
+		p_orig_pkey = cl_map_get(&p_pkey_tbl->keys,
+					 ib_pkey_get_base(pkey));
 	if (!p_orig_pkey) {
 		p_pending->is_new = TRUE;
 		cl_qlist_insert_tail(&p_pkey_tbl->pending,
diff --git a/opensm/osm_port.c b/opensm/osm_port.c
index 9c94719..b8e4988 100644
--- a/opensm/osm_port.c
+++ b/opensm/osm_port.c
@@ -633,7 +633,8 @@ void osm_physp_set_pkey_tbl(IN osm_log_t * p_log, IN const osm_subn_t * p_subn,
 		return;
 	}
 
-	osm_pkey_tbl_set(&p_physp->pkeys, block_num, p_pkey_tbl);
+	osm_pkey_tbl_set(&p_physp->pkeys, block_num, p_pkey_tbl,
+			 p_subn->opt.allow_both_pkeys);
 }
 
 osm_alias_guid_t *osm_alias_guid_new(IN const ib_net64_t alias_guid,
diff --git a/opensm/osm_prtn.c b/opensm/osm_prtn.c
index 3fd4fc0..5598fd4 100644
--- a/opensm/osm_prtn.c
+++ b/opensm/osm_prtn.c
@@ -1,5 +1,6 @@
 /*
  * Copyright (c) 2006-2009 Voltaire, Inc. All rights reserved.
+ * Copyright (c) 2010 Mellanox Technologies LTD. All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
@@ -117,14 +118,24 @@ ib_api_status_t osm_prtn_add_port(osm_log_t * p_log, osm_subn_t * p_subn,
 		return status;
 	}
 
-	if (cl_map_remove(&p->part_guid_tbl, guid) ||
-	    cl_map_remove(&p->full_guid_tbl, guid))
-		OSM_LOG(p_log, OSM_LOG_VERBOSE, "port 0x%" PRIx64 " already "
-			"in partition \'%s\' (0x%04x). Will overwrite\n",
-			cl_ntoh64(guid), p->name, cl_ntoh16(p->pkey));
-
 	p_tbl = (full == TRUE) ? &p->full_guid_tbl : &p->part_guid_tbl;
 
+	if (p_subn->opt.allow_both_pkeys) {
+		if (cl_map_remove(p_tbl, guid))
+			OSM_LOG(p_log, OSM_LOG_ERROR, "port 0x%" PRIx64
+				" already in partition \'%s\' (0x%04x) full %d."
+				" Will overwrite\n",
+				cl_ntoh64(guid), p->name, cl_ntoh16(p->pkey),
+				full);
+	} else {
+		if (cl_map_remove(&p->part_guid_tbl, guid) ||
+		    cl_map_remove(&p->full_guid_tbl, guid))
+			OSM_LOG(p_log, OSM_LOG_VERBOSE, "port 0x%" PRIx64
+				" already in partition \'%s\' (0x%04x)."
+				" Will overwrite\n",
+				cl_ntoh64(guid), p->name, cl_ntoh16(p->pkey));
+	}
+
 	if (cl_map_insert(p_tbl, guid, p_physp) == NULL)
 		return IB_INSUFFICIENT_MEMORY;
 
diff --git a/opensm/osm_prtn_config.c b/opensm/osm_prtn_config.c
index 0d02597..4c4c3a5 100644
--- a/opensm/osm_prtn_config.c
+++ b/opensm/osm_prtn_config.c
@@ -1,5 +1,6 @@
 /*
  * Copyright (c) 2006-2008 Voltaire, Inc. All rights reserved.
+ * Copyright (c) 2010 Mellanox Technologies LTD. All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
@@ -52,12 +53,18 @@
 #include <opensm/osm_subnet.h>
 #include <opensm/osm_log.h>
 
+typedef enum {
+	LIMITED,
+	FULL,
+	BOTH
+} membership_t;
+
 struct part_conf {
 	osm_log_t *p_log;
 	osm_subn_t *p_subn;
 	osm_prtn_t *p_prtn;
 	unsigned is_ipoib, mtu, rate, sl, scope_mask;
-	boolean_t full;
+	membership_t membership;
 };
 
 extern osm_prtn_t *osm_prtn_make_new(osm_log_t * p_log, osm_subn_t * p_subn,
@@ -171,13 +178,20 @@ static int partition_add_flag(unsigned lineno, struct part_conf *conf,
 			conf->sl = sl;
 	} else if (!strncmp(flag, "defmember", len)) {
 		if (!val || (strncmp(val, "limited", strlen(val))
+			     && strncmp(val, "both", strlen(val))
 			     && strncmp(val, "full", strlen(val))))
 			OSM_LOG(conf->p_log, OSM_LOG_VERBOSE,
 				"PARSE WARN: line %d: "
-				"flag \'defmember\' requires valid value (limited or full)"
+				"flag \'defmember\' requires valid value (limited or full or both)"
 				" - skipped\n", lineno);
-		else
-			conf->full = strncmp(val, "full", strlen(val)) == 0;
+		else {
+			if (!strncmp(val, "full", strlen(val)))
+				conf->membership = FULL;
+			else if (!strncmp(val, "both", strlen(val)))
+				conf->membership = BOTH;
+			else
+				conf->membership = LIMITED;
+		}
 	} else {
 		OSM_LOG(conf->p_log, OSM_LOG_VERBOSE,
 			"PARSE WARN: line %d: "
@@ -187,22 +201,36 @@ static int partition_add_flag(unsigned lineno, struct part_conf *conf,
 	return 0;
 }
 
+static int partition_add_all(struct part_conf *conf, osm_prtn_t * p,
+			     unsigned type, membership_t membership)
+{
+	if (membership != LIMITED &&
+	    osm_prtn_add_all(conf->p_log, conf->p_subn, p, type, TRUE) != IB_SUCCESS)
+		return -1;
+	if (membership != FULL &&
+	    osm_prtn_add_all(conf->p_log, conf->p_subn, p, type, FALSE) != IB_SUCCESS)
+		return -1;
+	return 0;
+}
+
 static int partition_add_port(unsigned lineno, struct part_conf *conf,
 			      char *name, char *flag)
 {
 	osm_prtn_t *p = conf->p_prtn;
 	ib_net64_t guid;
-	boolean_t full = conf->full;
+	membership_t membership = conf->membership;
 
 	if (!name || !*name || !strncmp(name, "NONE", strlen(name)))
 		return 0;
 
 	if (flag) {
 		/* reset default membership to limited */
-		full = FALSE;
+		membership = LIMITED;
 		if (!strncmp(flag, "full", strlen(flag)))
-			full = TRUE;
-		else if (strncmp(flag, "limited", strlen(flag))) {
+			membership = FULL;
+		else if (!strncmp(flag, "both", strlen(flag)))
+			membership = BOTH;
+		else if (!strncmp(flag, "limited", strlen(flag))) {
 			OSM_LOG(conf->p_log, OSM_LOG_VERBOSE,
 				"PARSE WARN: line %d: "
 				"unrecognized port flag \'%s\'."
@@ -210,19 +238,17 @@ static int partition_add_port(unsigned lineno, struct part_conf *conf,
 		}
 	}
 
-	if (!strncmp(name, "ALL", strlen(name))) {
-		return osm_prtn_add_all(conf->p_log, conf->p_subn, p,
-					0, full) == IB_SUCCESS ? 0 : -1;
-	} else if (!strncmp(name, "ALL_CAS", strlen(name))) {
-		return osm_prtn_add_all(conf->p_log, conf->p_subn, p,
-					IB_NODE_TYPE_CA, full) == IB_SUCCESS ? 0 : -1;
-	} else if (!strncmp(name, "ALL_SWITCHES", strlen(name))) {
-		return osm_prtn_add_all(conf->p_log, conf->p_subn, p,
-					IB_NODE_TYPE_SWITCH, full) == IB_SUCCESS ? 0 : -1;
-	} else if (!strncmp(name, "ALL_ROUTERS", strlen(name))) {
-		return osm_prtn_add_all(conf->p_log, conf->p_subn, p,
-					IB_NODE_TYPE_ROUTER, full) == IB_SUCCESS ? 0 : -1;
-	} else if (!strncmp(name, "SELF", strlen(name))) {
+	if (!strncmp(name, "ALL", strlen(name)))
+		return partition_add_all(conf, p, 0, membership);
+	else if (!strncmp(name, "ALL_CAS", strlen(name)))
+		return partition_add_all(conf, p, IB_NODE_TYPE_CA, membership);
+	else if (!strncmp(name, "ALL_SWITCHES", strlen(name)))
+		return partition_add_all(conf, p, IB_NODE_TYPE_SWITCH,
+					 membership);
+	else if (!strncmp(name, "ALL_ROUTERS", strlen(name)))
+		return partition_add_all(conf, p, IB_NODE_TYPE_ROUTER,
+					 membership);
+	else if (!strncmp(name, "SELF", strlen(name))) {
 		guid = cl_ntoh64(conf->p_subn->sm_port_guid);
 	} else {
 		char *end;
@@ -231,10 +257,14 @@ static int partition_add_port(unsigned lineno, struct part_conf *conf,
 			return -1;
 	}
 
-	if (osm_prtn_add_port(conf->p_log, conf->p_subn, p,
-			      cl_hton64(guid), full) != IB_SUCCESS)
+	if (membership != LIMITED &&
+	    osm_prtn_add_port(conf->p_log, conf->p_subn, p,
+			      cl_hton64(guid), TRUE) != IB_SUCCESS)
+		return -1;
+	if (membership != FULL &&
+	    osm_prtn_add_port(conf->p_log, conf->p_subn, p,
+			      cl_hton64(guid), FALSE) != IB_SUCCESS)
 		return -1;
-
 	return 0;
 }
 
@@ -299,7 +329,7 @@ static struct part_conf *new_part_conf(osm_log_t * p_log, osm_subn_t * p_subn)
 	conf->p_prtn = NULL;
 	conf->is_ipoib = 0;
 	conf->sl = OSM_DEFAULT_SL;
-	conf->full = FALSE;
+	conf->membership = LIMITED;
 	return conf;
 }
 
diff --git a/opensm/osm_subnet.c b/opensm/osm_subnet.c
index 2e94aa1..a15eafd 100644
--- a/opensm/osm_subnet.c
+++ b/opensm/osm_subnet.c
@@ -340,6 +340,7 @@ static const opt_rec_t opt_tbl[] = {
 	{ "accum_log_file", OPT_OFFSET(accum_log_file), opts_parse_boolean, opts_setup_accum_log_file, 1 },
 	{ "partition_config_file", OPT_OFFSET(partition_config_file), opts_parse_charp, NULL, 0 },
 	{ "no_partition_enforcement", OPT_OFFSET(no_partition_enforcement), opts_parse_boolean, NULL, 1 },
+	{ "allow_both_pkeys", OPT_OFFSET(allow_both_pkeys), opts_parse_boolean, NULL, 1 },
 	{ "qos", OPT_OFFSET(qos), opts_parse_boolean, NULL, 1 },
 	{ "qos_policy_file", OPT_OFFSET(qos_policy_file), opts_parse_charp, NULL, 0 },
 	{ "dump_files_dir", OPT_OFFSET(dump_files_dir), opts_parse_charp, NULL, 0 },
@@ -755,6 +756,7 @@ void osm_subn_set_default_opt(IN osm_subn_opt_t * p_opt)
 	p_opt->log_max_size = 0;
 	p_opt->partition_config_file = strdup(OSM_DEFAULT_PARTITION_CONFIG_FILE);
 	p_opt->no_partition_enforcement = FALSE;
+	p_opt->allow_both_pkeys = FALSE;
 	p_opt->qos = FALSE;
 	p_opt->qos_policy_file = strdup(OSM_DEFAULT_QOS_POLICY_FILE);
 	p_opt->accum_log_file = TRUE;
@@ -1360,9 +1362,12 @@ int osm_subn_output_conf(FILE *out, IN osm_subn_opt_t * p_opts)
 		"# Partition configuration file to be used\n"
 		"partition_config_file %s\n\n"
 		"# Disable partition enforcement by switches\n"
-		"no_partition_enforcement %s\n\n",
+		"no_partition_enforcement %s\n\n"
+		"# Allow both full and limited membership on the same partition\n"
+		"allow_both_pkeys %s\n\n",
 		p_opts->partition_config_file,
-		p_opts->no_partition_enforcement ? "TRUE" : "FALSE");
+		p_opts->no_partition_enforcement ? "TRUE" : "FALSE",
+		p_opts->allow_both_pkeys ? "TRUE" : "FALSE");
 
 	fprintf(out,
 		"#\n# SWEEP OPTIONS\n#\n"
-- 
1.7.6.1


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
