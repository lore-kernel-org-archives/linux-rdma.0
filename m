From: Line Holen <line.holen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2] opensm: Clean up event subscriptions if a port goes away
Date: Tue, 10 Sep 2013 03:50:12 -0700 (PDT)
Message-ID: <dbf27ce6-a17f-4913-acf2-accd2bdb1103@default>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Linux-Rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Event subscriptions needs to be cleaned up if a port goes away.
If the port comes online again later it may no longer want to
receive the events on the same QPN. If the "old" QPN is used for
something else the SM forwarding events may cause QKey violations.

This behavior is made configurable and it needs to be explicitly
enabled (default is off).

Signed-off-by: Line Holen <Line.Holen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

---

diff --git a/include/opensm/osm_inform.h b/include/opensm/osm_inform.h
index f737441..8cefc20 100644
--- a/include/opensm/osm_inform.h
+++ b/include/opensm/osm_inform.h
@@ -2,6 +2,7 @@
  * Copyright (c) 2004-2009 Voltaire, Inc. All rights reserved.
  * Copyright (c) 2002-2005 Mellanox Technologies LTD. All rights reserved.
  * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
+ * Copyright (c) 2013 Oracle and/or its affiliates. All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
@@ -200,6 +201,35 @@ void osm_infr_insert_to_db(IN osm_subn_t * p_subn, IN osm_log_t * p_log,
 void osm_infr_remove_from_db(IN osm_subn_t * p_subn, IN osm_log_t * p_log,
 			     IN osm_infr_t * p_infr);
 
+/****f* OpenSM: Inform Record/osm_infr_remove_subscriptions
+* NAME
+*	osm_infr_remove_subscriptions
+*
+* DESCRIPTION
+*	Remove all event subscriptions of a port
+*
+* SYNOPSIS
+*/
+ib_api_status_t
+osm_infr_remove_subscriptions(IN osm_subn_t * p_subn, IN osm_log_t * p_log,
+			      IN ib_net64_t port_guid);
+/*
+* PARAMETERS
+*	p_subn
+*		[in] Pointer to the subnet object
+*
+*	p_log
+*		[in] Pointer to the log object
+*
+*	port_guid
+*		[in] PortGUID of the subscriber that should be removed
+*
+* RETURN
+*	CL_SUCCESS if port_guid had any subscriptions being removed
+*	CL_NOT_FOUND if port_guid did not have any active subscriptions
+* SEE ALSO
+*********/
+
 /****f* OpenSM: Inform Record/osm_report_notice
 * NAME
 *	osm_report_notice
diff --git a/include/opensm/osm_subnet.h b/include/opensm/osm_subnet.h
index 463ffea..19f2079 100644
--- a/include/opensm/osm_subnet.h
+++ b/include/opensm/osm_subnet.h
@@ -5,6 +5,7 @@
  * Copyright (c) 2008 Xsigo Systems Inc.  All rights reserved.
  * Copyright (c) 2009 System Fabric Works, Inc. All rights reserved.
  * Copyright (c) 2009 HNR Consulting. All rights reserved.
+ * Copyright (c) 2013 Oracle and/or its affiliates. All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
@@ -325,6 +326,7 @@ typedef struct osm_subn_opt {
 	boolean_t daemon;
 	boolean_t sm_inactive;
 	boolean_t babbling_port_policy;
+	boolean_t drop_event_subscriptions;
 	boolean_t use_optimized_slvl;
 	osm_qos_options_t qos_options;
 	osm_qos_options_t qos_ca_options;
@@ -595,6 +597,9 @@ typedef struct osm_subn_opt {
 *	babbling_port_policy
 *		OpenSM will enforce its "babbling" port policy.
 *
+*	drop_event_subscriptions
+*		OpenSM will drop event subscriptions if the port goes away.
+*
 *	use_optimized_slvl
 *		Use optimized SLtoVLMappingTable programming if
 *		device indicates it supports this.
diff --git a/opensm/osm_drop_mgr.c b/opensm/osm_drop_mgr.c
index b309273..4276fe9 100644
--- a/opensm/osm_drop_mgr.c
+++ b/opensm/osm_drop_mgr.c
@@ -3,6 +3,7 @@
  * Copyright (c) 2002-2012 Mellanox Technologies LTD. All rights reserved.
  * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
  * Copyright (c) 2008 Xsigo Systems Inc.  All rights reserved.
+ * Copyright (c) 2013 Oracle and/or its affiliates. All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
@@ -276,6 +277,15 @@ static void drop_mgr_remove_port(osm_sm_t * sm, IN osm_port_t * p_port)
 
 	drop_mgr_clean_physp(sm, p_port->p_physp);
 
+	/* Delete event forwarding subscriptions */
+	if (sm->p_subn->opt.drop_event_subscriptions) {
+		if (osm_infr_remove_subscriptions(sm->p_subn, sm->p_log, port_guid)
+		    == CL_SUCCESS)
+			OSM_LOG(sm->p_log, OSM_LOG_DEBUG,
+			    "Removed event subscriptions for port 0x%016" PRIx64 "\n",
+			    cl_ntoh64(port_guid));
+	}
+
 	/* initialize the p_node - may need to get node_desc later */
 	p_node = p_port->p_node;
 
diff --git a/opensm/osm_inform.c b/opensm/osm_inform.c
index 804c414..716a124 100644
--- a/opensm/osm_inform.c
+++ b/opensm/osm_inform.c
@@ -282,6 +282,37 @@ void osm_infr_remove_from_db(IN osm_subn_t * p_subn, IN osm_log_t * p_log,
 	OSM_LOG_EXIT(p_log);
 }
 
+ib_api_status_t osm_infr_remove_subscriptions(IN osm_subn_t * p_subn,
+					      IN osm_log_t * p_log,
+					      IN ib_net64_t port_guid)
+{
+	cl_list_item_t *p_list_item;
+	osm_infr_t *p_infr;
+	ib_api_status_t status = CL_NOT_FOUND;
+
+	OSM_LOG_ENTER(p_log);
+
+	/* go over all inform info available at the subnet */
+	/* match to the given GID and delete subscriptions if match */
+	p_list_item = cl_qlist_head(&p_subn->sa_infr_list);
+	while (p_list_item != cl_qlist_end(&p_subn->sa_infr_list)) {
+
+		p_infr = (osm_infr_t *)p_list_item;
+		p_list_item = cl_qlist_next(p_list_item);
+
+		if (port_guid != p_infr->inform_record.subscriber_gid.unicast.interface_id)
+			continue;
+
+		/* Remove this event subscription */
+		osm_infr_remove_from_db(p_subn, p_log, p_infr);
+
+		status = CL_SUCCESS;
+	}
+
+	OSM_LOG_EXIT(p_log);
+	return (status);
+}
+
 /**********************************************************************
  * Send a report:
  * Given a target address to send to and the notice.
diff --git a/opensm/osm_subnet.c b/opensm/osm_subnet.c
index 0ad8ed6..9fc670b 100644
--- a/opensm/osm_subnet.c
+++ b/opensm/osm_subnet.c
@@ -776,6 +776,7 @@ static const opt_rec_t opt_tbl[] = {
 	{ "daemon", OPT_OFFSET(daemon), opts_parse_boolean, NULL, 0 },
 	{ "sm_inactive", OPT_OFFSET(sm_inactive), opts_parse_boolean, NULL, 1 },
 	{ "babbling_port_policy", OPT_OFFSET(babbling_port_policy), opts_parse_boolean, NULL, 1 },
+	{ "drop_event_subscriptions", OPT_OFFSET(drop_event_subscriptions), opts_parse_boolean, NULL, 1 },
 	{ "use_optimized_slvl", OPT_OFFSET(use_optimized_slvl), opts_parse_boolean, NULL, 1 },
 #ifdef ENABLE_OSM_PERF_MGR
 	{ "perfmgr", OPT_OFFSET(perfmgr), opts_parse_boolean, NULL, 0 },
@@ -1480,6 +1481,7 @@ void osm_subn_set_default_opt(IN osm_subn_opt_t * p_opt)
 	p_opt->daemon = FALSE;
 	p_opt->sm_inactive = FALSE;
 	p_opt->babbling_port_policy = FALSE;
+	p_opt->drop_event_subscriptions = FALSE;
 	p_opt->use_optimized_slvl = FALSE;
 #ifdef ENABLE_OSM_PERF_MGR
 	p_opt->perfmgr = FALSE;
@@ -2533,11 +2535,14 @@ int osm_subn_output_conf(FILE *out, IN osm_subn_opt_t * p_opts)
 		"sm_inactive %s\n\n"
 		"# Babbling Port Policy\n"
 		"babbling_port_policy %s\n\n"
+		"# Drop event subscriptions if the port goes away\n"
+		"drop_event_subscriptions %s\n\n"
 		"# Use Optimized SLtoVLMapping programming if supported by device\n"
 		"use_optimized_slvl %s\n\n",
 		p_opts->daemon ? "TRUE" : "FALSE",
 		p_opts->sm_inactive ? "TRUE" : "FALSE",
 		p_opts->babbling_port_policy ? "TRUE" : "FALSE",
+		p_opts->drop_event_subscriptions ? "TRUE" : "FALSE",
 		p_opts->use_optimized_slvl ? "TRUE" : "FALSE");
 
 #ifdef ENABLE_OSM_PERF_MGR
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
