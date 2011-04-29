From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 6/13] opensm: Add multicast support for alias GUIDs
Date: Fri, 29 Apr 2011 09:27:34 -0400
Message-ID: <4DBABCC6.1060207@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>From 725f4c8b87bf134bcfe2605d221e7757217e5e30 Mon Sep 17 00:00:00 2001
From: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Date: Thu, 28 Apr 2011 23:52:51 +0300
Subject: [PATCH] opensm: Add multicast support for alias GUIDs

Add mcm_alias_port_tbl to osm_mgrp and use this for port GID/GUIDs.
Move scope_state, proxy_join, and port_gid from osm_mcm_port to
osm_mcm_alias_guid. This is the basis for SA queries. Still use
mcm_port_tbl for multicast routing.

In osm_drop_mgr::drop_mgr_remove_port, remove multicast ports sooner.
Rewrite osm_mgrp_delete_port to be based on mcm alias port table.
Change osm_mgrp_delete_port to take port rather than port guid as parameter.

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 include/opensm/osm_mcm_port.h   |  130 +++++++++++++++++++++-----
 include/opensm/osm_multicast.h  |   44 ++++++++-
 opensm/osm_drop_mgr.c           |   14 ++--
 opensm/osm_mcm_port.c           |   34 ++++++-
 opensm/osm_multicast.c          |  194 +++++++++++++++++++++++++++++++-------
 opensm/osm_sa.c                 |   12 +-
 opensm/osm_sa_mcmember_record.c |   74 ++++++++-------
 opensm/osm_sa_path_record.c     |    5 +-
 8 files changed, 386 insertions(+), 121 deletions(-)

diff --git a/include/opensm/osm_mcm_port.h b/include/opensm/osm_mcm_port.h
index 096f5f8..347e14a 100644
--- a/include/opensm/osm_mcm_port.h
+++ b/include/opensm/osm_mcm_port.h
@@ -1,6 +1,6 @@
 /*
  * Copyright (c) 2004-2009 Voltaire, Inc. All rights reserved.
- * Copyright (c) 2002-2005 Mellanox Technologies LTD. All rights reserved.
+ * Copyright (c) 2002-2010 Mellanox Technologies LTD. All rights reserved.
  * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
  *
  * This software is available to you under a choice of one of two
@@ -78,9 +78,6 @@ typedef struct osm_mcm_port {
 	cl_list_item_t list_item;
 	osm_port_t *port;
 	struct osm_mgrp *mgrp;
-	ib_gid_t port_gid;
-	uint8_t scope_state;
-	boolean_t proxy_join;
 } osm_mcm_port_t;
 /*
 * FIELDS
@@ -96,17 +93,6 @@ typedef struct osm_mcm_port {
 *	mgrp
 *		The pointer to multicast group where this port is member of
 *
-*	port_gid
-*		GID of the member port
-*
-*	scope_state
-*
-*	proxy_join
-*		If FALSE - Join was performed by the endport identified
-*		by PortGID. If TRUE - Join was performed on behalf of
-*		the endport identified by PortGID by another port within
-*		the same partition.
-*
 * SEE ALSO
 *	MCM Port Object
 *********/
@@ -121,8 +107,7 @@ typedef struct osm_mcm_port {
 *
 * SYNOPSIS
 */
-osm_mcm_port_t *osm_mcm_port_new(IN osm_port_t * port, IN struct osm_mgrp *mgrp,
-				 IN ib_member_rec_t *mcmr, IN boolean_t proxy);
+osm_mcm_port_t *osm_mcm_port_new(IN osm_port_t * port, IN struct osm_mgrp *mgrp);
 /*
 * PARAMETERS
 *	port
@@ -131,12 +116,6 @@ osm_mcm_port_t *osm_mcm_port_new(IN osm_port_t * port, IN struct osm_mgrp *mgrp,
 *	mgrp
 *		[in] Pointer to multicast group where this port is joined
 *
-*	mcmr
-*		[in] Pointer to MCMember record of the join request
-*
-*	proxy
-*		[in] proxy_join state analyzed from the request
-*
 * RETURN VALUES
 *	Pointer to the allocated and initialized MCM Port object.
 *
@@ -171,5 +150,110 @@ void osm_mcm_port_delete(IN osm_mcm_port_t * p_mcm);
 *	MCM Port Object, osm_mcm_port_new
 *********/
 
+/****s* OpenSM: MCM Port Object/osm_mcm_alias_guid_t
+* NAME
+*	osm_mcm_alias_guid_t
+*
+* DESCRIPTION
+*	This object represents an alias guid for a mcm port.
+*
+*	The osm_mcm_alias_guid_t object should be treated as opaque and should
+*	be manipulated only through the provided functions.
+*
+* SYNOPSIS
+*/
+typedef struct osm_mcm_alias_guid {
+	cl_map_item_t map_item;
+	ib_net64_t alias_guid;
+	osm_mcm_port_t *p_base_mcm_port;
+	ib_gid_t port_gid;
+	uint8_t scope_state;
+	boolean_t proxy_join;
+} osm_mcm_alias_guid_t;
+/*
+* FIELDS
+*	map_item
+*		Linkage structure for cl_qmap.  MUST BE FIRST MEMBER!
+*
+*	alias_guid
+*		Alias GUID for port obtained from SM GUIDInfo attribute
+*
+*	p_base_mcm_port
+*		Pointer to osm_mcm_port_t for base port GUID
+*
+*	port_gid
+*		GID of the member port
+*
+*	scope_state
+*
+*	proxy_join
+*		If FALSE - Join was performed by the endport identified
+*		by PortGID. If TRUE - Join was performed on behalf of
+*		the endport identified by PortGID by another port within
+*		the same partition.
+*
+* SEE ALSO
+*	MCM Port, Physical Port, Physical Port Table
+*/
+
+/****f* OpenSM: MCM Port Object/osm_mcm_alias_guid_new
+* NAME
+*	osm_mcm_alias_guid_new
+*
+* DESCRIPTION
+*	This function allocates and initializes an mcm alias guid object.
+*
+* SYNOPSIS
+*/
+osm_mcm_alias_guid_t *osm_mcm_alias_guid_new(IN osm_mcm_port_t *p_base_mcm_port,
+					     IN ib_member_rec_t *mcmr,
+					     IN boolean_t proxy);
+/*
+* PARAMETERS
+*	p_base_mcm_port
+*		[in] Pointer to the mcm port for this base GUID
+*
+*	mcmr
+*		[in] Pointer to MCMember record of the join request
+*
+*	proxy
+*		[in] proxy_join state analyzed from the request
+*
+* RETURN VALUE
+*	Pointer to the initialized mcm alias guid object.
+*
+* NOTES
+*	Allows calling other mcm alias guid methods.
+*
+* SEE ALSO
+*       MCM Port Object
+*********/
+
+/****f* OpenSM: MCM Port Object/osm_mcm_alias_guid_delete
+* NAME
+*	osm_mcm_alias_guid_delete
+*
+* DESCRIPTION
+*	This function destroys and deallocates an mcm alias guid object.
+*
+* SYNOPSIS
+*/
+void osm_mcm_alias_guid_delete(IN OUT osm_mcm_alias_guid_t ** pp_mcm_alias_guid);
+/*
+* PARAMETERS
+*	pp_mcm_alias_guid
+*		[in][out] Pointer to a pointer to an mcm alias guid object to
+*		delete. On return, this pointer is NULL.
+*
+* RETURN VALUE
+*	This function does not return a value.
+*
+* NOTES
+*	Performs any necessary cleanup of the specified mcm alias guid object.
+*
+* SEE ALSO
+*	MCM Port Object
+*********/
+
 END_C_DECLS
 #endif				/* _OSM_MCM_PORT_H_ */
diff --git a/include/opensm/osm_multicast.h b/include/opensm/osm_multicast.h
index d8d484c..6fa3408 100644
--- a/include/opensm/osm_multicast.h
+++ b/include/opensm/osm_multicast.h
@@ -1,6 +1,6 @@
 /*
  * Copyright (c) 2004-2009 Voltaire, Inc. All rights reserved.
- * Copyright (c) 2002-2005 Mellanox Technologies LTD. All rights reserved.
+ * Copyright (c) 2002-2010 Mellanox Technologies LTD. All rights reserved.
  * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
  *
  * This software is available to you under a choice of one of two
@@ -101,6 +101,7 @@ typedef struct osm_mgrp {
 	cl_list_item_t list_item;
 	ib_net16_t mlid;
 	cl_qmap_t mcm_port_tbl;
+	cl_qmap_t mcm_alias_port_tbl;
 	ib_member_rec_t mcmember_rec;
 	boolean_t well_known;
 	unsigned full_members;
@@ -121,6 +122,11 @@ typedef struct osm_mgrp {
 *		Table (sorted by port GUID) of osm_mcm_port_t objects
 *		representing the member ports of this multicast group.
 *
+*	mcm_alias_port_tbl
+*		Table (sorted by port alias GUID) of osm_mcm_port_t
+*		objects representing the member ports of this multicast
+*		group.
+*
 *	mcmember_rec
 *		Holds the parameters of the Multicast Group.
 *
@@ -380,6 +386,33 @@ osm_mcm_port_t *osm_mgrp_get_mcm_port(IN const osm_mgrp_t * p_mgrp,
 * SEE ALSO
 *********/
 
+/****f* OpenSM: Multicast Group/osm_mgrp_get_mcm_alias_guid
+* NAME
+*	osm_mgrp_get_mcm_alias_guid
+*
+* DESCRIPTION
+*	Finds an mcm alias GUID in the multicast group based on an alias GUID.
+*
+* SYNOPSIS
+*/
+osm_mcm_alias_guid_t *osm_mgrp_get_mcm_alias_guid(IN const osm_mgrp_t * p_mgrp,
+						  IN ib_net64_t port_guid);
+/*
+* PARAMETERS
+*	p_mgrp
+*		[in] Pointer to an osm_mgrp_t object.
+*
+*	port_guid
+*		[in] Alias port guid.
+*
+* RETURN VALUES
+*	Pointer to the mcm alias GUID object when present or NULL otherwise.
+*
+* NOTES
+*
+* SEE ALSO
+*********/
+
 /****f* OpenSM: Multicast Group/osm_mgrp_delete_port
 * NAME
 *	osm_mgrp_delete_port
@@ -390,7 +423,7 @@ osm_mcm_port_t *osm_mgrp_get_mcm_port(IN const osm_mgrp_t * p_mgrp,
 * SYNOPSIS
 */
 void osm_mgrp_delete_port(IN osm_subn_t * subn, IN osm_log_t * log,
-			  IN osm_mgrp_t * mgrp, IN ib_net64_t port_guid);
+			  IN osm_mgrp_t * mgrp, IN osm_port_t * port);
 /*
 * PARAMETERS
 *
@@ -403,8 +436,8 @@ void osm_mgrp_delete_port(IN osm_subn_t * subn, IN osm_log_t * log,
 *	mgrp
 *		[in] Pointer to an osm_mgrp_t object.
 *
-*	port_guid
-*		[in] Port guid of the departing port.
+*	port
+*		[in] Pointer to an osm_port_t object for the the departing port.
 *
 * RETURN VALUES
 *	None.
@@ -415,7 +448,8 @@ void osm_mgrp_delete_port(IN osm_subn_t * subn, IN osm_log_t * log,
 *********/
 
 void osm_mgrp_remove_port(osm_subn_t * subn, osm_log_t * log, osm_mgrp_t * mgrp,
-			  osm_mcm_port_t * mcm_port, ib_member_rec_t * mcmr);
+			  osm_mcm_alias_guid_t * mcm_alias_guid,
+			  ib_member_rec_t * mcmr);
 void osm_mgrp_cleanup(osm_subn_t * subn, osm_mgrp_t * mpgr);
 void osm_mgrp_box_delete(osm_mgrp_box_t *mbox);
 
diff --git a/opensm/osm_drop_mgr.c b/opensm/osm_drop_mgr.c
index 10b51e2..9dba310 100644
--- a/opensm/osm_drop_mgr.c
+++ b/opensm/osm_drop_mgr.c
@@ -209,6 +209,13 @@ static void drop_mgr_remove_port(osm_sm_t * sm, IN osm_port_t * p_port)
 			ib_get_err_str(status));
 	}
 
+	while (!cl_is_qlist_empty(&p_port->mcm_list)) {
+		mcm_port = cl_item_obj(cl_qlist_head(&p_port->mcm_list),
+				       mcm_port, list_item);
+		osm_mgrp_delete_port(sm->p_subn, sm->p_log, mcm_port->mgrp,
+				     p_port);
+	}
+
 	p_alias_guid_tbl = &sm->p_subn->alias_port_guid_tbl;
 	p_alias_guid_check = (osm_alias_guid_t *) cl_qmap_head(p_alias_guid_tbl);
 	while (p_alias_guid_check != (osm_alias_guid_t *) cl_qmap_end(p_alias_guid_tbl)) {
@@ -249,13 +256,6 @@ static void drop_mgr_remove_port(osm_sm_t * sm, IN osm_port_t * p_port)
 
 	drop_mgr_clean_physp(sm, p_port->p_physp);
 
-	while (!cl_is_qlist_empty(&p_port->mcm_list)) {
-		mcm_port = cl_item_obj(cl_qlist_head(&p_port->mcm_list),
-				       mcm_port, list_item);
-		osm_mgrp_delete_port(sm->p_subn, sm->p_log, mcm_port->mgrp,
-				     p_port->guid);
-	}
-
 	/* initialize the p_node - may need to get node_desc later */
 	p_node = p_port->p_node;
 
diff --git a/opensm/osm_mcm_port.c b/opensm/osm_mcm_port.c
index ace1d07..2b08a6d 100644
--- a/opensm/osm_mcm_port.c
+++ b/opensm/osm_mcm_port.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (c) 2004-2009 Voltaire, Inc. All rights reserved.
- * Copyright (c) 2002-2005 Mellanox Technologies LTD. All rights reserved.
+ * Copyright (c) 2002-2010 Mellanox Technologies LTD. All rights reserved.
  * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
  *
  * This software is available to you under a choice of one of two
@@ -49,8 +49,7 @@
 #include <opensm/osm_mcm_port.h>
 #include <opensm/osm_multicast.h>
 
-osm_mcm_port_t *osm_mcm_port_new(IN osm_port_t *port, IN osm_mgrp_t *mgrp,
-				 IN ib_member_rec_t *mcmr, IN boolean_t proxy)
+osm_mcm_port_t *osm_mcm_port_new(IN osm_port_t *port, IN osm_mgrp_t *mgrp)
 {
 	osm_mcm_port_t *p_mcm;
 
@@ -59,9 +58,6 @@ osm_mcm_port_t *osm_mcm_port_new(IN osm_port_t *port, IN osm_mgrp_t *mgrp,
 		memset(p_mcm, 0, sizeof(*p_mcm));
 		p_mcm->port = port;
 		p_mcm->mgrp = mgrp;
-		p_mcm->port_gid = mcmr->port_gid;
-		p_mcm->scope_state = mcmr->scope_state;
-		p_mcm->proxy_join = proxy;
 	}
 
 	return p_mcm;
@@ -70,5 +66,31 @@ osm_mcm_port_t *osm_mcm_port_new(IN osm_port_t *port, IN osm_mgrp_t *mgrp,
 void osm_mcm_port_delete(IN osm_mcm_port_t * p_mcm)
 {
 	CL_ASSERT(p_mcm);
+
 	free(p_mcm);
 }
+
+osm_mcm_alias_guid_t *osm_mcm_alias_guid_new(IN osm_mcm_port_t *p_base_mcm_port,
+					     IN ib_member_rec_t *mcmr,
+					     IN boolean_t proxy)
+{
+	osm_mcm_alias_guid_t *p_mcm_alias_guid;
+
+	p_mcm_alias_guid = calloc(1, sizeof(*p_mcm_alias_guid));
+	if (p_mcm_alias_guid) {
+		p_mcm_alias_guid->alias_guid = mcmr->port_gid.unicast.interface_id;
+		p_mcm_alias_guid->p_base_mcm_port = p_base_mcm_port;
+		p_mcm_alias_guid->port_gid.unicast.prefix = mcmr->port_gid.unicast.prefix;
+		p_mcm_alias_guid->port_gid.unicast.interface_id = mcmr->port_gid.unicast.interface_id;
+		p_mcm_alias_guid->scope_state = mcmr->scope_state;
+		p_mcm_alias_guid->proxy_join = proxy;
+	}
+
+	return p_mcm_alias_guid;
+}
+
+void osm_mcm_alias_guid_delete(IN OUT osm_mcm_alias_guid_t ** pp_mcm_alias_guid)
+{
+	free(*pp_mcm_alias_guid);
+	*pp_mcm_alias_guid = NULL;
+}
diff --git a/opensm/osm_multicast.c b/opensm/osm_multicast.c
index 4ff93f2..c539bb2 100644
--- a/opensm/osm_multicast.c
+++ b/opensm/osm_multicast.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (c) 2004-2009 Voltaire, Inc. All rights reserved.
- * Copyright (c) 2002-2006,2008 Mellanox Technologies LTD. All rights reserved.
+ * Copyright (c) 2002-2011 Mellanox Technologies LTD. All rights reserved.
  * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
  *
  * This software is available to you under a choice of one of two
@@ -72,10 +72,21 @@ void mgrp_box_delete(osm_mgrp_box_t *mbox)
 
 void mgrp_delete(IN osm_mgrp_t * p_mgrp)
 {
+	osm_mcm_alias_guid_t *p_mcm_alias_guid, *p_next_mcm_alias_guid;
 	osm_mcm_port_t *p_mcm_port, *p_next_mcm_port;
 
 	CL_ASSERT(p_mgrp);
 
+	p_next_mcm_alias_guid =
+	    (osm_mcm_alias_guid_t *) cl_qmap_head(&p_mgrp->mcm_alias_port_tbl);
+	while (p_next_mcm_alias_guid !=
+	       (osm_mcm_alias_guid_t *) cl_qmap_end(&p_mgrp->mcm_alias_port_tbl)) {
+		p_mcm_alias_guid = p_next_mcm_alias_guid;
+		p_next_mcm_alias_guid =
+		    (osm_mcm_alias_guid_t *) cl_qmap_next(&p_mcm_alias_guid->map_item);
+		osm_mcm_alias_guid_delete(&p_mcm_alias_guid);
+        }
+
 	p_next_mcm_port =
 	    (osm_mcm_port_t *) cl_qmap_head(&p_mgrp->mcm_port_tbl);
 	while (p_next_mcm_port !=
@@ -113,6 +124,7 @@ osm_mgrp_t *osm_mgrp_new(IN osm_subn_t * subn, IN ib_net16_t mlid,
 
 	memset(p_mgrp, 0, sizeof(*p_mgrp));
 	cl_qmap_init(&p_mgrp->mcm_port_tbl);
+	cl_qmap_init(&p_mgrp->mcm_alias_port_tbl);
 	p_mgrp->mlid = mlid;
 	p_mgrp->mcmember_rec = *mcmr;
 
@@ -134,11 +146,18 @@ osm_mgrp_t *osm_mgrp_new(IN osm_subn_t * subn, IN ib_net16_t mlid,
 void osm_mgrp_cleanup(osm_subn_t * subn, osm_mgrp_t * mgrp)
 {
 	osm_mgrp_box_t *mbox;
+	osm_mcm_alias_guid_t *mcm_alias_guid;
 	osm_mcm_port_t *mcm_port;
 
 	if (mgrp->full_members)
 		return;
 
+	while (cl_qmap_count(&mgrp->mcm_alias_port_tbl)) {
+		mcm_alias_guid = (osm_mcm_alias_guid_t *) cl_qmap_head(&mgrp->mcm_alias_port_tbl);
+		cl_qmap_remove_item(&mgrp->mcm_alias_port_tbl, &mcm_alias_guid->map_item);
+		osm_mcm_alias_guid_delete(&mcm_alias_guid);
+	}
+
 	while (cl_qmap_count(&mgrp->mcm_port_tbl)) {
 		mcm_port = (osm_mcm_port_t *) cl_qmap_head(&mgrp->mcm_port_tbl);
 		cl_qmap_remove_item(&mgrp->mcm_port_tbl, &mcm_port->map_item);
@@ -188,28 +207,93 @@ static void mgrp_send_notice(osm_subn_t * subn, osm_log_t * log,
 			ib_get_err_str(status));
 }
 
+static boolean_t is_qmap_empty_for_port(IN const cl_qmap_t * const p_map,
+					IN const osm_port_t *port)
+{
+	size_t count = 0;
+	cl_map_item_t *item;
+	osm_mcm_alias_guid_t *mcm_alias_guid;
+
+        for (item = cl_qmap_head(p_map); item != cl_qmap_end(p_map);
+	     item = cl_qmap_next(item)) {
+		mcm_alias_guid = (osm_mcm_alias_guid_t *) item;
+		if (mcm_alias_guid->p_base_mcm_port->port == port) {
+			count++;
+			break;
+		}
+	}
+
+	return (count == 0);
+}
+
+static boolean_t is_qmap_empty_for_mcm_port(IN const cl_qmap_t * const p_map,
+					    IN const osm_mcm_port_t *mcm_port)
+{
+	size_t count = 0;
+	cl_map_item_t *item;
+	osm_mcm_alias_guid_t *mcm_alias_guid;
+
+	for (item = cl_qmap_head(p_map); item != cl_qmap_end(p_map);
+	     item = cl_qmap_next(item)) {
+		mcm_alias_guid = (osm_mcm_alias_guid_t *) item;
+		if (mcm_alias_guid->p_base_mcm_port == mcm_port) {
+			count++;
+			break;
+		}
+	}
+
+	return (count == 0);
+}
+static osm_mcm_alias_guid_t *insert_alias_guid(IN osm_mgrp_t * mgrp,
+					       IN osm_mcm_alias_guid_t * p_mcm_alias_guid)
+{
+	osm_mcm_alias_guid_t *p_mcm_alias_guid_check;
+
+	/* insert into mcm alias guid table */
+	p_mcm_alias_guid_check =
+		(osm_mcm_alias_guid_t *) cl_qmap_insert(&mgrp->mcm_alias_port_tbl,
+							p_mcm_alias_guid->alias_guid,
+							&p_mcm_alias_guid->map_item);
+	if (p_mcm_alias_guid_check != (osm_mcm_alias_guid_t *) &p_mcm_alias_guid->map_item) {
+		/* alias GUID is a duplicate */
+		osm_mcm_alias_guid_delete(&p_mcm_alias_guid);
+		return p_mcm_alias_guid_check;
+	}
+	return NULL;
+}
+
 osm_mcm_port_t *osm_mgrp_add_port(IN osm_subn_t * subn, osm_log_t * log,
 				  IN osm_mgrp_t * mgrp, osm_port_t *port,
 				  IN ib_member_rec_t *mcmr, IN boolean_t proxy)
 {
 	osm_mcm_port_t *mcm_port;
+	osm_mcm_alias_guid_t *p_mcm_alias_guid, *p_mcm_alias_guid_check;
 	cl_map_item_t *prev_item;
 	uint8_t prev_join_state = 0, join_state = mcmr->scope_state;
 	uint8_t prev_scope;
 
 	if (osm_log_is_active(log, OSM_LOG_VERBOSE)) {
 		char gid_str[INET6_ADDRSTRLEN];
-		OSM_LOG(log, OSM_LOG_VERBOSE, "Port 0x%016" PRIx64 " joining "
-			"MC group %s (mlid 0x%x)\n", cl_ntoh64(port->guid),
+		OSM_LOG(log, OSM_LOG_VERBOSE, "GUID 0x%016" PRIx64
+			" Port 0x%016" PRIx64 " joining "
+			"MC group %s (mlid 0x%x)\n",
+			cl_ntoh64(mcmr->port_gid.unicast.interface_id),
+			cl_ntoh64(port->guid),
 			inet_ntop(AF_INET6, mgrp->mcmember_rec.mgid.raw,
 				  gid_str, sizeof(gid_str)),
 			cl_ntoh16(mgrp->mlid));
 	}
 
-	mcm_port = osm_mcm_port_new(port, mgrp, mcmr, proxy);
+	mcm_port = osm_mcm_port_new(port, mgrp);
 	if (!mcm_port)
 		return NULL;
 
+	p_mcm_alias_guid = osm_mcm_alias_guid_new(mcm_port, mcmr, proxy);
+	if (!p_mcm_alias_guid) {
+		osm_mcm_port_delete(mcm_port);
+		return NULL;
+	}
+
 	/*
 	   prev_item = cl_qmap_insert(...)
 	   Pointer to the item in the map with the specified key.  If insertion
@@ -220,23 +304,28 @@ osm_mcm_port_t *osm_mgrp_add_port(IN osm_subn_t * subn, osm_log_t * log,
 	prev_item = cl_qmap_insert(&mgrp->mcm_port_tbl, port->guid,
 				   &mcm_port->map_item);
 
-	/* if already exists - revert the insertion and only update join state */
-	if (prev_item != &mcm_port->map_item) {
+	if (prev_item != &mcm_port->map_item) {	/* mcm port already exists */
 		osm_mcm_port_delete(mcm_port);
 		mcm_port = (osm_mcm_port_t *) prev_item;
 
-		ib_member_get_scope_state(mcm_port->scope_state, &prev_scope,
-					  &prev_join_state);
-		mcm_port->scope_state =
-		    ib_member_set_scope_state(prev_scope,
-					      prev_join_state | join_state);
+		p_mcm_alias_guid->p_base_mcm_port = (osm_mcm_port_t *) prev_item;
+		p_mcm_alias_guid_check = insert_alias_guid(mgrp, p_mcm_alias_guid);
+		if (p_mcm_alias_guid_check) {	/* alias GUID already exists */
+			p_mcm_alias_guid = p_mcm_alias_guid_check;
+			ib_member_get_scope_state(p_mcm_alias_guid->scope_state,
+						  &prev_scope, &prev_join_state);
+			p_mcm_alias_guid->scope_state =
+			    ib_member_set_scope_state(prev_scope,
+						      prev_join_state | join_state);
+		}
 	} else {
+		insert_alias_guid(mgrp, p_mcm_alias_guid);
 		cl_qlist_insert_tail(&port->mcm_list, &mcm_port->list_item);
 		osm_sm_reroute_mlid(&subn->p_osm->sm, mgrp->mlid);
 	}
 
 	/* o15.0.1.11: copy the join state */
-	mcmr->scope_state = mcm_port->scope_state;
+	mcmr->scope_state = p_mcm_alias_guid->scope_state;
 
 	if ((join_state & IB_JOIN_STATE_FULL) &&
 	    !(prev_join_state & IB_JOIN_STATE_FULL) &&
@@ -248,7 +337,8 @@ osm_mcm_port_t *osm_mgrp_add_port(IN osm_subn_t * subn, osm_log_t * log,
 }
 
 void osm_mgrp_remove_port(osm_subn_t * subn, osm_log_t * log, osm_mgrp_t * mgrp,
-			  osm_mcm_port_t * mcm_port, ib_member_rec_t *mcmr)
+			  osm_mcm_alias_guid_t * mcm_alias_guid,
+			  ib_member_rec_t *mcmr)
 {
 	uint8_t join_state = mcmr->scope_state & 0xf;
 	uint8_t port_join_state, new_join_state;
@@ -258,36 +348,53 @@ void osm_mgrp_remove_port(osm_subn_t * subn, osm_log_t * log, osm_mgrp_t * mgrp,
 	 * JoinState and the request JoinState and they must be
 	 * opposite to leave - otherwise just update it
 	 */
-	port_join_state = mcm_port->scope_state & 0x0F;
+	port_join_state = mcm_alias_guid->scope_state & 0x0F;
 	new_join_state = port_join_state & ~join_state;
 
 	if (osm_log_is_active(log, OSM_LOG_VERBOSE)) {
 		char gid_str[INET6_ADDRSTRLEN];
 		OSM_LOG(log, OSM_LOG_VERBOSE,
-			"Port 0x%" PRIx64 " leaving MC group %s (mlid 0x%x)\n",
-			cl_ntoh64(mcm_port->port->guid),
+			"GUID 0x%" PRIx64 " Port 0x%" PRIx64
+			" leaving MC group %s (mlid 0x%x)\n",
+			cl_ntoh64(mcm_alias_guid->alias_guid),
+			cl_ntoh64(mcm_alias_guid->p_base_mcm_port->port->guid),
 			inet_ntop(AF_INET6, mgrp->mcmember_rec.mgid.raw,
 				  gid_str, sizeof(gid_str)),
 			cl_ntoh16(mgrp->mlid));
 	}
 
-	if (new_join_state) {
-		mcm_port->scope_state =
-		    new_join_state | (mcm_port->scope_state & 0xf0);
+	if (new_join_state & IB_JOIN_STATE_FULL ||
+	    (new_join_state &&
+	     (mgrp->full_members > (port_join_state & IB_JOIN_STATE_FULL) ? 1 : 0))) {
+		mcm_alias_guid->scope_state =
+		    new_join_state | (mcm_alias_guid->scope_state & 0xf0);
 		OSM_LOG(log, OSM_LOG_DEBUG,
-			"updating port 0x%" PRIx64 " JoinState 0x%x -> 0x%x\n",
-			cl_ntoh64(mcm_port->port->guid),
+			"updating GUID 0x%" PRIx64 " port 0x%" PRIx64
+			" JoinState 0x%x -> 0x%x\n",
+			cl_ntoh64(mcm_alias_guid->alias_guid),
+			cl_ntoh64(mcm_alias_guid->p_base_mcm_port->port->guid),
 			port_join_state, new_join_state);
-		mcmr->scope_state = mcm_port->scope_state;
+		mcmr->scope_state = mcm_alias_guid->scope_state;
 	} else {
-		mcmr->scope_state = mcm_port->scope_state;
-		OSM_LOG(log, OSM_LOG_DEBUG, "removing port 0x%" PRIx64 "\n",
-			cl_ntoh64(mcm_port->port->guid));
-		cl_qmap_remove_item(&mgrp->mcm_port_tbl, &mcm_port->map_item);
-		cl_qlist_remove_item(&mcm_port->port->mcm_list,
-				     &mcm_port->list_item);
-		osm_mcm_port_delete(mcm_port);
-		osm_sm_reroute_mlid(&subn->p_osm->sm, mgrp->mlid);
+		mcmr->scope_state = mcm_alias_guid->scope_state & 0xf0;
+		OSM_LOG(log, OSM_LOG_DEBUG, "removing alias GUID 0x%" PRIx64 "\n",
+			cl_ntoh64(mcm_alias_guid->alias_guid));
+		cl_qmap_remove_item(&mgrp->mcm_alias_port_tbl,
+				    &mcm_alias_guid->map_item);		
+		if (is_qmap_empty_for_port(&mgrp->mcm_alias_port_tbl,
+					   mcm_alias_guid->p_base_mcm_port->port)) { /* last alias in mcast group for this port */
+			OSM_LOG(log, OSM_LOG_DEBUG, "removing port 0x%" PRIx64 "\n",
+				cl_ntoh64(mcm_alias_guid->p_base_mcm_port->port->guid));
+			cl_qmap_remove_item(&mgrp->mcm_port_tbl,
+					    &mcm_alias_guid->p_base_mcm_port->map_item);
+			cl_qlist_remove_item(&mcm_alias_guid->p_base_mcm_port->port->mcm_list,
+					     &mcm_alias_guid->p_base_mcm_port->list_item);
+			if (is_qmap_empty_for_mcm_port(&mgrp->mcm_alias_port_tbl,
+						       mcm_alias_guid->p_base_mcm_port)) /* last alias in mcast group for this mcm port */
+				osm_mcm_port_delete(mcm_alias_guid->p_base_mcm_port);
+			osm_sm_reroute_mlid(&subn->p_osm->sm, mgrp->mlid);
+		}
+		osm_mcm_alias_guid_delete(&mcm_alias_guid);
 	}
 
 	/* no more full members so the group will be deleted after re-route
@@ -303,15 +410,20 @@ void osm_mgrp_remove_port(osm_subn_t * subn, osm_log_t * log, osm_mgrp_t * mgrp,
 }
 
 void osm_mgrp_delete_port(osm_subn_t * subn, osm_log_t * log, osm_mgrp_t * mgrp,
-			  ib_net64_t port_guid)
+			  osm_port_t * port)
 {
+	osm_mcm_alias_guid_t *mcm_alias_guid, *next_mcm_alias_guid;
 	ib_member_rec_t mcmrec;
-	cl_map_item_t *item = cl_qmap_get(&mgrp->mcm_port_tbl, port_guid);
 
-	if (item != cl_qmap_end(&mgrp->mcm_port_tbl)) {
-		mcmrec.scope_state = 0xf;
-		osm_mgrp_remove_port(subn, log, mgrp, (osm_mcm_port_t *) item,
-				     &mcmrec);
+	next_mcm_alias_guid = (osm_mcm_alias_guid_t *) cl_qmap_head(&mgrp->mcm_alias_port_tbl);
+	while (next_mcm_alias_guid != (osm_mcm_alias_guid_t *) cl_qmap_end(&mgrp->mcm_alias_port_tbl)) {
+		mcm_alias_guid = next_mcm_alias_guid;
+		next_mcm_alias_guid = (osm_mcm_alias_guid_t *) cl_qmap_next(&next_mcm_alias_guid->map_item);
+		if (mcm_alias_guid->p_base_mcm_port->port == port) {
+			mcmrec.scope_state = 0xf;
+			osm_mgrp_remove_port(subn, log, mgrp, mcm_alias_guid,
+					     &mcmrec);
+		}
 	}
 }
 
@@ -323,3 +435,13 @@ osm_mcm_port_t *osm_mgrp_get_mcm_port(IN const osm_mgrp_t * p_mgrp,
 		return (osm_mcm_port_t *) item;
 	return NULL;
 }
+
+osm_mcm_alias_guid_t *osm_mgrp_get_mcm_alias_guid(IN const osm_mgrp_t * p_mgrp,
+						  IN ib_net64_t port_guid)
+{
+	cl_map_item_t *item = cl_qmap_get(&p_mgrp->mcm_alias_port_tbl,
+					  port_guid);
+	if (item != cl_qmap_end(&p_mgrp->mcm_alias_port_tbl))
+		return (osm_mcm_alias_guid_t *) item;
+	return NULL;
+}
diff --git a/opensm/osm_sa.c b/opensm/osm_sa.c
index 0142b59..6b033fd 100644
--- a/opensm/osm_sa.c
+++ b/opensm/osm_sa.c
@@ -532,14 +532,14 @@ opensm_dump_to_file(osm_opensm_t * p_osm, const char *file_name,
 static void mcast_mgr_dump_one_port(cl_map_item_t * p_map_item, void *cxt)
 {
 	FILE *file = ((struct opensm_dump_context *)cxt)->file;
-	osm_mcm_port_t *p_mcm_port = (osm_mcm_port_t *) p_map_item;
+	osm_mcm_alias_guid_t *p_mcm_alias_guid = (osm_mcm_alias_guid_t *) p_map_item;
 
 	fprintf(file, "mcm_port: "
 		"port_gid=0x%016" PRIx64 ":0x%016" PRIx64 " "
 		"scope_state=0x%02x proxy_join=0x%x" "\n\n",
-		cl_ntoh64(p_mcm_port->port_gid.unicast.prefix),
-		cl_ntoh64(p_mcm_port->port_gid.unicast.interface_id),
-		p_mcm_port->scope_state, p_mcm_port->proxy_join);
+		cl_ntoh64(p_mcm_alias_guid->port_gid.unicast.prefix),
+		cl_ntoh64(p_mcm_alias_guid->port_gid.unicast.interface_id),
+		p_mcm_alias_guid->scope_state, p_mcm_alias_guid->proxy_join);
 }
 
 static void sa_dump_one_mgrp(osm_mgrp_t *p_mgrp, void *cxt)
@@ -574,7 +574,7 @@ static void sa_dump_one_mgrp(osm_mgrp_t *p_mgrp, void *cxt)
 	dump_context.p_osm = p_osm;
 	dump_context.file = file;
 
-	cl_qmap_apply_func(&p_mgrp->mcm_port_tbl,
+	cl_qmap_apply_func(&p_mgrp->mcm_alias_port_tbl,
 			   mcast_mgr_dump_one_port, &dump_context);
 }
 
@@ -1113,7 +1113,7 @@ int osm_sa_db_file_load(osm_opensm_t * p_osm)
 			proxy = val;
 
 			guid = mcmr.port_gid.unicast.interface_id;
-			port = osm_get_port_by_guid(&p_osm->subn, guid);
+			port = osm_get_port_by_alias_guid(&p_osm->subn, guid);
 			if (port &&
 			    cl_qmap_get(&p_mgrp->mcm_port_tbl, guid) ==
 			    cl_qmap_end(&p_mgrp->mcm_port_tbl) &&
diff --git a/opensm/osm_sa_mcmember_record.c b/opensm/osm_sa_mcmember_record.c
index 0f79e69..b3d9538 100644
--- a/opensm/osm_sa_mcmember_record.c
+++ b/opensm/osm_sa_mcmember_record.c
@@ -367,7 +367,7 @@ static boolean_t validate_port_caps(osm_log_t * p_log,
 static boolean_t validate_modify(IN osm_sa_t * sa, IN osm_mgrp_t * p_mgrp,
 				 IN osm_mad_addr_t * p_mad_addr,
 				 IN ib_member_rec_t * p_recvd_mcmember_rec,
-				 OUT osm_mcm_port_t ** pp_mcm_port)
+				 OUT osm_mcm_alias_guid_t ** pp_mcm_alias_guid)
 {
 	ib_net64_t portguid;
 	ib_gid_t request_gid;
@@ -376,10 +376,10 @@ static boolean_t validate_modify(IN osm_sa_t * sa, IN osm_mgrp_t * p_mgrp,
 
 	portguid = p_recvd_mcmember_rec->port_gid.unicast.interface_id;
 
-	*pp_mcm_port = osm_mgrp_get_mcm_port(p_mgrp, portguid);
+	*pp_mcm_alias_guid = osm_mgrp_get_mcm_alias_guid(p_mgrp, portguid);
 
 	/* o15-0.2.1: If this is a new port being added - nothing to check */
-	if (!*pp_mcm_port) {
+	if (!*pp_mcm_alias_guid) {
 		OSM_LOG(sa->p_log, OSM_LOG_DEBUG,
 			"This is a new port in the MC group\n");
 		return TRUE;
@@ -387,7 +387,7 @@ static boolean_t validate_modify(IN osm_sa_t * sa, IN osm_mgrp_t * p_mgrp,
 
 	/* We validate the request according the the proxy_join.
 	   Check if the proxy_join is set or not */
-	if ((*pp_mcm_port)->proxy_join == FALSE) {
+	if ((*pp_mcm_alias_guid)->proxy_join == FALSE) {
 		/* The proxy_join is not set. Modifying can by done only
 		   if the requester GID == PortGID */
 		res = osm_get_gid_by_mad_addr(sa->p_log, sa->p_subn, p_mad_addr,
@@ -398,13 +398,14 @@ static boolean_t validate_modify(IN osm_sa_t * sa, IN osm_mgrp_t * p_mgrp,
 			return FALSE;
 		}
 
-		if (memcmp(&(*pp_mcm_port)->port_gid, &request_gid,
-			   sizeof(ib_gid_t))) {
+		if ((*pp_mcm_alias_guid)->p_base_mcm_port->port->guid !=
+		    request_gid.unicast.interface_id ||
+		    (*pp_mcm_alias_guid)->port_gid.unicast.prefix !=
+		    request_gid.unicast.prefix) {
 			OSM_LOG(sa->p_log, OSM_LOG_DEBUG,
 				"No ProxyJoin but different ports: stored:"
 				"0x%016" PRIx64 " request:0x%016" PRIx64 "\n",
-				cl_ntoh64((*pp_mcm_port)->port_gid.unicast.
-					  interface_id),
+				cl_ntoh64((*pp_mcm_alias_guid)->p_base_mcm_port->port->guid),
 				cl_ntoh64(request_gid.unicast.interface_id));
 			return FALSE;
 		}
@@ -453,16 +454,16 @@ static boolean_t validate_modify(IN osm_sa_t * sa, IN osm_mgrp_t * p_mgrp,
 static boolean_t validate_delete(IN osm_sa_t * sa, IN osm_mgrp_t * p_mgrp,
 				 IN osm_mad_addr_t * p_mad_addr,
 				 IN ib_member_rec_t * p_recvd_mcmember_rec,
-				 OUT osm_mcm_port_t ** pp_mcm_port)
+				 OUT osm_mcm_alias_guid_t ** pp_mcm_alias_guid)
 {
 	ib_net64_t portguid;
 
 	portguid = p_recvd_mcmember_rec->port_gid.unicast.interface_id;
 
-	*pp_mcm_port = osm_mgrp_get_mcm_port(p_mgrp, portguid);
+	*pp_mcm_alias_guid = osm_mgrp_get_mcm_alias_guid(p_mgrp, portguid);
 
 	/* 1 */
-	if (!*pp_mcm_port) {
+	if (!*pp_mcm_alias_guid) {
 		OSM_LOG(sa->p_log, OSM_LOG_DEBUG,
 			"Failed to find the port in the MC group\n");
 		return FALSE;
@@ -470,7 +471,7 @@ static boolean_t validate_delete(IN osm_sa_t * sa, IN osm_mgrp_t * p_mgrp,
 
 	/* 2 */
 	if (!(p_recvd_mcmember_rec->scope_state & 0x0F &
-	      (*pp_mcm_port)->scope_state)) {
+	      (*pp_mcm_alias_guid)->scope_state)) {
 		OSM_LOG(sa->p_log, OSM_LOG_DEBUG,
 			"Could not find any matching bits in the stored "
 			"and requested JoinStates\n");
@@ -479,20 +480,20 @@ static boolean_t validate_delete(IN osm_sa_t * sa, IN osm_mgrp_t * p_mgrp,
 
 	/* 3 */
 	if (((p_recvd_mcmember_rec->scope_state & 0x0F) |
-	     (0x0F & (*pp_mcm_port)->scope_state)) !=
-	    (0x0F & (*pp_mcm_port)->scope_state)) {
+	     (0x0F & (*pp_mcm_alias_guid)->scope_state)) !=
+	    (0x0F & (*pp_mcm_alias_guid)->scope_state)) {
 		OSM_LOG(sa->p_log, OSM_LOG_DEBUG,
 			"Some bits in the request JoinState (0x%X) are not "
 			"set in the stored port (0x%X)\n",
 			(p_recvd_mcmember_rec->scope_state & 0x0F),
-			(0x0F & (*pp_mcm_port)->scope_state));
+			(0x0F & (*pp_mcm_alias_guid)->scope_state));
 		return FALSE;
 	}
 
 	/* 4 */
 	/* Validate according the the proxy_join (o15-0.1.2) */
 	if (validate_modify(sa, p_mgrp, p_mad_addr, p_recvd_mcmember_rec,
-			    pp_mcm_port) == FALSE) {
+			    pp_mcm_alias_guid) == FALSE) {
 		OSM_LOG(sa->p_log, OSM_LOG_DEBUG,
 			"proxy_join validation failure\n");
 		return FALSE;
@@ -894,7 +895,7 @@ static void mcmr_rcv_leave_mgrp(IN osm_sa_t * sa, IN osm_madw_t * p_madw)
 	ib_member_rec_t *p_recvd_mcmember_rec;
 	ib_member_rec_t mcmember_rec;
 	ib_net64_t portguid;
-	osm_mcm_port_t *p_mcm_port;
+	osm_mcm_alias_guid_t *p_mcm_alias_guid;
 
 	OSM_LOG_ENTER(sa->p_log);
 
@@ -926,7 +927,7 @@ static void mcmr_rcv_leave_mgrp(IN osm_sa_t * sa, IN osm_madw_t * p_madw)
 
 	/* check validity of the delete request o15-0.1.14 */
 	if (!validate_delete(sa, p_mgrp, osm_madw_get_mad_addr_ptr(p_madw),
-			     p_recvd_mcmember_rec, &p_mcm_port)) {
+			     p_recvd_mcmember_rec, &p_mcm_alias_guid)) {
 		char gid_str[INET6_ADDRSTRLEN];
 		char gid_str2[INET6_ADDRSTRLEN];
 		CL_PLOCK_RELEASE(sa->p_lock);
@@ -942,7 +943,7 @@ static void mcmr_rcv_leave_mgrp(IN osm_sa_t * sa, IN osm_madw_t * p_madw)
 	}
 
 	/* remove port and/or update join state */
-	osm_mgrp_remove_port(sa->p_subn, sa->p_log, p_mgrp, p_mcm_port,
+	osm_mgrp_remove_port(sa->p_subn, sa->p_log, p_mgrp, p_mcm_alias_guid,
 			     &mcmember_rec);
 	CL_PLOCK_RELEASE(sa->p_lock);
 
@@ -963,6 +964,7 @@ static void mcmr_rcv_join_mgrp(IN osm_sa_t * sa, IN osm_madw_t * p_madw)
 	ib_member_rec_t *p_recvd_mcmember_rec;
 	ib_member_rec_t mcmember_rec;
 	osm_mcm_port_t *p_mcmr_port;
+	osm_mcm_alias_guid_t *p_mcm_alias_guid;
 	ib_net64_t portguid;
 	osm_port_t *p_port;
 	osm_physp_t *p_physp;
@@ -988,7 +990,7 @@ static void mcmr_rcv_join_mgrp(IN osm_sa_t * sa, IN osm_madw_t * p_madw)
 	CL_PLOCK_EXCL_ACQUIRE(sa->p_lock);
 
 	/* make sure the requested port guid is known to the SM */
-	p_port = osm_get_port_by_guid(sa->p_subn, portguid);
+	p_port = osm_get_port_by_alias_guid(sa->p_subn, portguid);
 	if (!p_port) {
 		CL_PLOCK_RELEASE(sa->p_lock);
 		OSM_LOG(sa->p_log, OSM_LOG_DEBUG,
@@ -1019,7 +1021,7 @@ static void mcmr_rcv_join_mgrp(IN osm_sa_t * sa, IN osm_madw_t * p_madw)
 		goto Exit;
 	}
 
-	if (p_sa_mad->comp_mask & IB_MCR_COMPMASK_PKEY &&
+	if ((p_sa_mad->comp_mask & IB_MCR_COMPMASK_PKEY) &&
 	    ib_pkey_is_invalid(p_recvd_mcmember_rec->pkey)) {
 		CL_PLOCK_RELEASE(sa->p_lock);
 		OSM_LOG(sa->p_log, OSM_LOG_VERBOSE,
@@ -1134,7 +1136,7 @@ static void mcmr_rcv_join_mgrp(IN osm_sa_t * sa, IN osm_madw_t * p_madw)
 	 */
 	if (!is_new_group &&
 	    !validate_modify(sa, p_mgrp, osm_madw_get_mad_addr_ptr(p_madw),
-			     p_recvd_mcmember_rec, &p_mcmr_port)) {
+			     p_recvd_mcmember_rec, &p_mcm_alias_guid)) {
 		CL_PLOCK_RELEASE(sa->p_lock);
 		OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 1B13: "
 			"validate_modify failed from port 0x%016" PRIx64
@@ -1214,7 +1216,7 @@ static void mcmr_by_comp_mask(osm_sa_t * sa, const ib_member_rec_t * p_rcvd_rec,
 {
 	/* since we might change scope_state */
 	ib_member_rec_t match_rec;
-	osm_mcm_port_t *p_mcm_port;
+	osm_mcm_alias_guid_t *p_mcm_alias_guid;
 	ib_net64_t portguid = p_rcvd_rec->port_gid.unicast.interface_id;
 	/* will be used for group or port info */
 	uint8_t scope_state;
@@ -1294,12 +1296,13 @@ static void mcmr_by_comp_mask(osm_sa_t * sa, const ib_member_rec_t * p_rcvd_rec,
 	/* so did we get the PortGUID mask */
 	if (IB_MCR_COMPMASK_PORT_GID & comp_mask) {
 		/* try to find this port */
-		p_mcm_port = osm_mgrp_get_mcm_port(p_mgrp, portguid);
-		if (!p_mcm_port) /* port not in group */
+		p_mcm_alias_guid = osm_mgrp_get_mcm_alias_guid(p_mgrp, portguid);
+		if (!p_mcm_alias_guid) /* port not in group */
 			goto Exit;
-		scope_state = p_mcm_port->scope_state;
-		memcpy(&port_gid, &(p_mcm_port->port_gid), sizeof(ib_gid_t));
-		proxy_join = p_mcm_port->proxy_join;
+		scope_state = p_mcm_alias_guid->scope_state;
+		memcpy(&port_gid, &(p_mcm_alias_guid->port_gid),
+		       sizeof(ib_gid_t));
+		proxy_join = p_mcm_alias_guid->proxy_join;
 	} else /* point to the group information */
 		scope_state = p_mgrp->mcmember_rec.scope_state;
 
@@ -1316,17 +1319,18 @@ static void mcmr_by_comp_mask(osm_sa_t * sa, const ib_member_rec_t * p_rcvd_rec,
 			"Trusted req is TRUE and no specific port defined\n");
 
 		/* return all the ports that match in this MC group */
-		p_item = cl_qmap_head(&(p_mgrp->mcm_port_tbl));
-		while (p_item != cl_qmap_end(&(p_mgrp->mcm_port_tbl))) {
-			p_mcm_port = (osm_mcm_port_t *) p_item;
+		p_item = cl_qmap_head(&(p_mgrp->mcm_alias_port_tbl));
+		while (p_item != cl_qmap_end(&(p_mgrp->mcm_alias_port_tbl))) {
+			p_mcm_alias_guid = (osm_mcm_alias_guid_t *) p_item;
 
 			if ((scope_state_mask & p_rcvd_rec->scope_state) ==
-			    (scope_state_mask & p_mcm_port->scope_state)) {
+			    (scope_state_mask & p_mcm_alias_guid->scope_state)) {
 				/* add to the list */
 				match_rec = p_mgrp->mcmember_rec;
-				match_rec.scope_state = p_mcm_port->scope_state;
+				match_rec.scope_state = p_mcm_alias_guid->scope_state;
 				memcpy(&match_rec.port_gid,
-				       &p_mcm_port->port_gid, sizeof(ib_gid_t));
+				       &p_mcm_alias_guid->port_gid,
+				       sizeof(ib_gid_t));
 				OSM_LOG(sa->p_log, OSM_LOG_DEBUG,
 					"Record of port_gid: %s"
 					" in multicast_lid: 0x%X is returned\n",
@@ -1336,7 +1340,7 @@ static void mcmr_by_comp_mask(osm_sa_t * sa, const ib_member_rec_t * p_rcvd_rec,
 					cl_ntoh16(p_mgrp->mlid));
 
 				match_rec.proxy_join =
-				    (uint8_t) (p_mcm_port->proxy_join);
+				    (uint8_t) (p_mcm_alias_guid->proxy_join);
 
 				mcmr_rcv_new_mcmr(sa, &match_rec, list);
 			}
diff --git a/opensm/osm_sa_path_record.c b/opensm/osm_sa_path_record.c
index 3ebaa4f..bf0f5e3 100644
--- a/opensm/osm_sa_path_record.c
+++ b/opensm/osm_sa_path_record.c
@@ -1496,9 +1496,8 @@ static ib_api_status_t pr_match_mgrp_attributes(IN osm_sa_t * sa,
 
 	/* If SGID and/or SLID specified, should validate as member of MC group */
 	if (comp_mask & IB_PR_COMPMASK_SGID) {
-		port = osm_get_port_by_guid(sa->p_subn,
-					    p_pr->sgid.unicast.interface_id);
-		if (!port || !osm_mgrp_get_mcm_port(p_mgrp, port->guid))
+		if (!osm_mgrp_get_mcm_alias_guid(p_mgrp,
+						 p_pr->sgid.unicast.interface_id))
 			goto Exit;
 	}
 
-- 
1.5.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
