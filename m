From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCHv2 2/13] opensm: Make SA assigned guids persistent across port
 down/up events
Date: Fri, 20 May 2011 15:49:55 -0400
Message-ID: <4DD6C5E3.5030106@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Infrastructure in osm_subnet.[h c] with actual changes in
opensm/osm_sa_guidinfo_record.c

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
Changes since v1:
In set_guidinfo when osm_assigned_guids_new fails, send SA error and return

 include/opensm/osm_subnet.h     |  110 ++++++++++++++++++++++++++++++++++++++-
 opensm/osm_sa_guidinfo_record.c |   40 +++++++++++++-
 opensm/osm_subnet.c             |   41 ++++++++++++++-
 3 files changed, 186 insertions(+), 5 deletions(-)

diff --git a/include/opensm/osm_subnet.h b/include/opensm/osm_subnet.h
index 914b9d4..5c19b19 100644
--- a/include/opensm/osm_subnet.h
+++ b/include/opensm/osm_subnet.h
@@ -1,6 +1,6 @@
 /*
  * Copyright (c) 2004-2009 Voltaire, Inc. All rights reserved.
- * Copyright (c) 2002-2010 Mellanox Technologies LTD. All rights reserved.
+ * Copyright (c) 2002-2011 Mellanox Technologies LTD. All rights reserved.
  * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
  * Copyright (c) 2008 Xsigo Systems Inc.  All rights reserved.
  * Copyright (c) 2009 System Fabric Works, Inc. All rights reserved.
@@ -527,6 +527,7 @@ typedef struct osm_subn {
 	cl_qmap_t node_guid_tbl;
 	cl_qmap_t port_guid_tbl;
 	cl_qmap_t alias_port_guid_tbl;
+	cl_qmap_t assigned_guids_tbl;
 	cl_qmap_t rtr_guid_tbl;
 	cl_qlist_t prefix_routes_list;
 	cl_qmap_t prtn_pkey_tbl;
@@ -693,6 +694,35 @@ typedef struct osm_subn {
 *	Subnet object
 *********/
 
+/****s* OpenSM: Subnet/osm_assigned_guids_t
+* NAME
+*	osm_assigned_guids_t
+*
+* DESCRIPTION
+*	SA assigned GUIDs structure.
+*
+* SYNOPSIS
+*/
+typedef struct osm_assigned_guids {
+	cl_map_item_t map_item;
+	ib_net64_t port_guid;
+	ib_net64_t assigned_guid[1];
+} osm_assigned_guids_t;
+/*
+* FIELDS
+*	map_item
+*		Linkage structure for cl_qmap.  MUST BE FIRST MEMBER!
+*
+*	port_guid
+*		Base port GUID.
+*
+*	assigned_guids
+*		Table of persistent SA assigned GUIDs.
+*
+* SEE ALSO
+*	Subnet object
+*********/
+
 /****f* OpenSM: Subnet/osm_subn_construct
 * NAME
 *	osm_subn_construct
@@ -1039,6 +1069,84 @@ struct osm_port *osm_get_port_by_alias_guid(IN osm_subn_t const *p_subn,
 *	osm_port_t
 *********/
 
+/****f* OpenSM: Port/osm_assigned_guids_new
+* NAME
+*	osm_assigned_guids_new
+*
+* DESCRIPTION
+*	This function allocates and initializes an assigned guids object.
+*
+* SYNOPSIS
+*/
+osm_assigned_guids_t *osm_assigned_guids_new(IN const ib_net64_t port_guid,
+					     IN const uint32_t num_guids);
+/*
+* PARAMETERS
+*       port_guid
+*               [in] Base port GUID in network order
+*
+* RETURN VALUE
+*       Pointer to the initialized assigned alias guid object.
+*
+* SEE ALSO
+*	Subnet object, osm_assigned_guids_t, osm_assigned_guids_delete,
+*	osm_get_assigned_guids_by_guid
+*********/
+
+/****f* OpenSM: Port/osm_assigned_guids_delete
+* NAME
+*	osm_assigned_guids_delete
+*
+* DESCRIPTION
+*	This function destroys and deallocates an assigned guids object.
+*
+* SYNOPSIS
+*/
+void osm_assigned_guids_delete(IN OUT osm_assigned_guids_t ** pp_assigned_guids);
+/*
+* PARAMETERS
+*       pp_assigned_guids
+*		[in][out] Pointer to a pointer to an assigned guids object to delete.
+*		On return, this pointer is NULL.
+*
+* RETURN VALUE
+*	This function does not return a value.
+*
+* NOTES
+*	Performs any necessary cleanup of the specified assigned guids object.
+*
+* SEE ALSO
+*	Subnet object, osm_assigned_guids_new, osm_get_assigned_guids_by_guid
+*********/
+
+/****f* OpenSM: Subnet/osm_get_assigned_guids_by_guid
+* NAME
+*	osm_get_assigned_guids_by_guid
+*
+* DESCRIPTION
+*	This looks for the given port guid and returns a pointer
+*	to the guid table of SA assigned alias guids for that port.
+*
+* SYNOPSIS
+*/
+osm_assigned_guids_t *osm_get_assigned_guids_by_guid(IN osm_subn_t const *p_subn,
+						     IN ib_net64_t port_guid);
+/*
+* PARAMETERS
+*	p_subn
+*		[in] Pointer to an osm_subn_t object
+*
+*	port_guid
+*		[in] The base port guid in network order
+*
+* RETURN VALUES
+*	The osm_assigned_guids structure pointer if found. NULL otherwise.
+*
+* SEE ALSO
+*	Subnet object, osm_assigned_guids_new, osm_assigned_guids_delete,
+*	osm_assigned_guids_t
+*********/
+
 /****f* OpenSM: Port/osm_get_port_by_lid
 * NAME
 *	osm_get_port_by_lid
diff --git a/opensm/osm_sa_guidinfo_record.c b/opensm/osm_sa_guidinfo_record.c
index 484633f..039040b 100644
--- a/opensm/osm_sa_guidinfo_record.c
+++ b/opensm/osm_sa_guidinfo_record.c
@@ -467,15 +467,15 @@ static void set_guidinfo(IN osm_sa_t *sa, IN osm_madw_t *p_madw,
 	int i, j, dirty = 0;
 	ib_sa_mad_t *p_sa_mad;
 	ib_guidinfo_record_t *p_rcvd_rec;
+	osm_assigned_guids_t *p_assigned_guids = 0;
 	osm_alias_guid_t *p_alias_guid, *p_alias_guid_check;
 	cl_map_item_t *p_item;
 	ib_net64_t set_alias_guid, del_alias_guid, assigned_guid;
 	uint8_t set_mask;
 
+	max_block = (p_port->p_physp->port_info.guid_cap + GUID_TABLE_MAX_ENTRIES - 1) /
+		     GUID_TABLE_MAX_ENTRIES;
 	if (!p_port->p_physp->p_guids) {
-		max_block = (p_port->p_physp->port_info.guid_cap + GUID_TABLE_MAX_ENTRIES - 1) /
-			     GUID_TABLE_MAX_ENTRIES;
-
 		p_port->p_physp->p_guids = calloc(max_block * GUID_TABLE_MAX_ENTRIES,
 						  sizeof(ib_net64_t));
 		if (!p_port->p_physp->p_guids) {
@@ -524,6 +524,18 @@ static void set_guidinfo(IN osm_sa_t *sa, IN osm_madw_t *p_madw,
 				p_rcvd_rec->guid_info.guid[i % 8] = set_alias_guid;				
 				continue;
 			}
+			/* Is there a persistent SA assigned guid for this index ? */
+			if (!p_assigned_guids)
+				p_assigned_guids =
+				    osm_get_assigned_guids_by_guid(sa->p_subn,
+								   p_port->p_physp->port_guid);
+			if (p_assigned_guids) {
+				set_alias_guid = p_assigned_guids->assigned_guid[i];
+				if (set_alias_guid) {
+					p_rcvd_rec->guid_info.guid[i % 8] = set_alias_guid;
+					goto add_alias_guid;
+				}
+			}
 		}
 		if (!set_alias_guid) {
 			for (j = 0; j < 1000; j++) {
@@ -540,6 +552,27 @@ static void set_guidinfo(IN osm_sa_t *sa, IN osm_madw_t *p_madw,
 				if (p_item == cl_qmap_end(&sa->sm->p_subn->alias_port_guid_tbl)) {
 					set_alias_guid = assigned_guid;
 					p_rcvd_rec->guid_info.guid[i % 8] = assigned_guid;
+					if (!p_assigned_guids) {
+						p_assigned_guids = osm_assigned_guids_new(p_port->p_physp->port_guid,
+											  max_block * GUID_TABLE_MAX_ENTRIES);
+						if (p_assigned_guids) {
+							cl_qmap_insert(&(sa->p_subn->assigned_guids_tbl),
+								       p_assigned_guids->port_guid,
+								       &p_assigned_guids->map_item);
+						} else {
+							OSM_LOG(sa->p_log,
+								OSM_LOG_ERROR,
+								"ERR 510D: osm_assigned_guids_new failed port GUID 0x%" PRIx64 " index %d\n",
+								cl_ntoh64(p_port->p_physp->port_guid), i);
+							osm_sa_send_error(sa, p_madw,
+									  IB_SA_MAD_STATUS_NO_RESOURCES);
+							return;
+						}
+					}
+					if (p_assigned_guids)
+{
+						p_assigned_guids->assigned_guid[i] = assigned_guid;
+}
 					break;
 				}
 			}
@@ -552,6 +585,7 @@ static void set_guidinfo(IN osm_sa_t *sa, IN osm_madw_t *p_madw,
 			}
 		}
 
+add_alias_guid:
 		/* allocate alias guid and add to alias guid table */
 		p_alias_guid = osm_alias_guid_new(set_alias_guid, p_port);
 		if (!p_alias_guid) {
diff --git a/opensm/osm_subnet.c b/opensm/osm_subnet.c
index 34eaf29..32b5e1e 100644
--- a/opensm/osm_subnet.c
+++ b/opensm/osm_subnet.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (c) 2004-2009 Voltaire, Inc. All rights reserved.
- * Copyright (c) 2002-2010 Mellanox Technologies LTD. All rights reserved.
+ * Copyright (c) 2002-2011 Mellanox Technologies LTD. All rights reserved.
  * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
  * Copyright (c) 2008 Xsigo Systems Inc.  All rights reserved.
  * Copyright (c) 2009 System Fabric Works, Inc. All rights reserved.
@@ -420,6 +420,7 @@ void osm_subn_construct(IN osm_subn_t * p_subn)
 	cl_qmap_init(&p_subn->node_guid_tbl);
 	cl_qmap_init(&p_subn->port_guid_tbl);
 	cl_qmap_init(&p_subn->alias_port_guid_tbl);
+	cl_qmap_init(&p_subn->assigned_guids_tbl);
 	cl_qmap_init(&p_subn->sm_guid_tbl);
 	cl_qlist_init(&p_subn->sa_sr_list);
 	cl_qlist_init(&p_subn->sa_infr_list);
@@ -433,6 +434,7 @@ void osm_subn_destroy(IN osm_subn_t * p_subn)
 {
 	int i;
 	osm_node_t *p_node, *p_next_node;
+	osm_assigned_guids_t *p_assigned_guids, *p_next_assigned_guids;
 	osm_alias_guid_t *p_alias_guid, *p_next_alias_guid;
 	osm_port_t *p_port, *p_next_port;
 	osm_switch_t *p_sw, *p_next_sw;
@@ -450,6 +452,14 @@ void osm_subn_destroy(IN osm_subn_t * p_subn)
 		osm_node_delete(&p_node);
 	}
 
+	p_next_assigned_guids = (osm_assigned_guids_t *) cl_qmap_head(&p_subn->assigned_guids_tbl);
+	while (p_next_assigned_guids !=
+	       (osm_assigned_guids_t *) cl_qmap_end(&p_subn->assigned_guids_tbl)) {
+		p_assigned_guids = p_next_assigned_guids;
+		p_next_assigned_guids = (osm_assigned_guids_t *) cl_qmap_next(&p_assigned_guids->map_item);
+		osm_assigned_guids_delete(&p_assigned_guids);
+	}
+
 	p_next_alias_guid = (osm_alias_guid_t *) cl_qmap_head(&p_subn->alias_port_guid_tbl);
 	while (p_next_alias_guid !=
 	       (osm_alias_guid_t *) cl_qmap_end(&p_subn->alias_port_guid_tbl)) {
@@ -652,6 +662,35 @@ osm_port_t *osm_get_port_by_alias_guid(IN osm_subn_t const *p_subn,
 	return p_alias_guid->p_base_port;
 }
 
+osm_assigned_guids_t *osm_assigned_guids_new(IN const ib_net64_t port_guid,
+					     IN const uint32_t num_guids)
+{
+	osm_assigned_guids_t *p_assigned_guids;
+
+	p_assigned_guids = calloc(1, sizeof(*p_assigned_guids) +
+				     sizeof(ib_net64_t) * (num_guids - 1));
+	if (p_assigned_guids)
+		p_assigned_guids->port_guid = port_guid;
+	return p_assigned_guids;
+}
+
+void osm_assigned_guids_delete(IN OUT osm_assigned_guids_t ** pp_assigned_guids)
+{
+	free(*pp_assigned_guids);
+	*pp_assigned_guids = NULL;
+}
+
+osm_assigned_guids_t *osm_get_assigned_guids_by_guid(IN osm_subn_t const *p_subn,
+						     IN ib_net64_t port_guid)
+{
+	osm_assigned_guids_t *p_assigned_guids;
+
+	p_assigned_guids = (osm_assigned_guids_t *) cl_qmap_get(&(p_subn->assigned_guids_tbl), port_guid);
+	if (p_assigned_guids == (osm_assigned_guids_t *) cl_qmap_end(&(p_subn->assigned_guids_tbl)))
+		return NULL;
+	return p_assigned_guids;
+}
+
 osm_port_t *osm_get_port_by_lid_ho(IN osm_subn_t const * subn, IN uint16_t lid)
 {
 	if (lid < cl_ptr_vector_get_size(&subn->port_lid_tbl))
-- 
1.5.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
