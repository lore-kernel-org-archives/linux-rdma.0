From: Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH 6/8] opensm: Add neighboring link cache file
Date: Mon, 25 Jun 2012 17:55:02 -0700
Message-ID: <1340672104-18039-6-git-send-email-foraker1@llnl.gov>
References: <1340672058.5218.97.camel@auk75.llnl.gov>
 <1340672104-18039-1-git-send-email-foraker1@llnl.gov>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1340672104-18039-1-git-send-email-foraker1-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: weiny2-i2BcT+NCU+M@public.gmane.org, Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

At high mkey protection levels (ie, 2), an initializing OpenSM
may run into a chicken-and-egg problem, where it needs the guid
of a previously-configured HCA in order to determine what mkey to
use when requesting its guid in the NodeInfo SMP.  By caching
the guids/port numbers at either end of each link between restarts,
this problem is avoided.

Signed-off-by: Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>
---
 include/opensm/osm_db_pack.h |  185 ++++++++++++++++++++++++++++++++++++++++++
 include/opensm/osm_subnet.h  |    1 +
 opensm/osm_db_pack.c         |  103 +++++++++++++++++++++++
 opensm/osm_node_info_rcv.c   |   17 +++-
 opensm/osm_req.c             |   11 ++-
 opensm/osm_state_mgr.c       |    1 +
 opensm/osm_subnet.c          |  102 +++++++++++++++++++++++
 7 files changed, 418 insertions(+), 2 deletions(-)

diff --git a/include/opensm/osm_db_pack.h b/include/opensm/osm_db_pack.h
index 25644df..1ff2ff9 100644
--- a/include/opensm/osm_db_pack.h
+++ b/include/opensm/osm_db_pack.h
@@ -379,5 +379,190 @@ int osm_db_guid2mkey_delete(IN osm_db_domain_t * p_g2m, IN uint64_t guid);
 * osm_db_guid2mkey_get, osm_db_guid2mkey_set
 *********/
 
+/****f* OpenSM: DB-Pack/osm_db_neighbor_init
+* NAME
+*	osm_db_neighbor_init
+*
+* DESCRIPTION
+*	Initialize a domain for the neighbors table
+*
+* SYNOPSIS
+*/
+static inline osm_db_domain_t *osm_db_neighbor_init(IN osm_db_t * p_db)
+{
+	return (osm_db_domain_init(p_db, "neighbors"));
+}
+
+/*
+* PARAMETERS
+*	p_db
+*		[in] Pointer to the database object to construct
+*
+* RETURN VALUES
+*	The pointer to the new allocated domain object or NULL.
+*
+* NOTE: DB domains are destroyed by the osm_db_destroy
+*
+* SEE ALSO
+*	Database, osm_db_init, osm_db_destroy
+*********/
+
+/****f* OpenSM: DB-Pack/osm_db_neighbor_elem
+* NAME
+*	osm_db_neighbor_elem
+*
+* DESCRIPTION
+*	Initialize a domain for the neighbor table
+*
+* SYNOPSIS
+*/
+typedef struct osm_db_neighbor_elem {
+	cl_list_item_t item;
+	uint64_t guid;
+	uint8_t portnum;
+} osm_db_neighbor_elem_t;
+/*
+* FIELDS
+*	item
+*		required for list manipulations
+*
+*  guid
+*  portnum
+*
+************/
+
+/****f* OpenSM: DB-Pack/osm_db_neighbor_guids
+* NAME
+*	osm_db_neighbor_guids
+*
+* DESCRIPTION
+*	Provides back a list of neighbor elements.
+*
+* SYNOPSIS
+*/
+int osm_db_neighbor_guids(IN osm_db_domain_t * p_neighbor,
+			  OUT cl_qlist_t * p_guid_list);
+/*
+* PARAMETERS
+*	p_neighbor
+*		[in] Pointer to the neighbor domain
+*
+*  p_guid_list
+*     [out] A quick list of neighbor elements of type osm_db_neighbor_elem_t
+*
+* RETURN VALUES
+*	0 if successful
+*
+* NOTE: the output qlist should be initialized and each item freed
+*       by the caller, then destroyed.
+*
+* SEE ALSO
+* osm_db_neighbor_init, osm_db_neighbor_guids, osm_db_neighbor_get
+* osm_db_neighbor_set, osm_db_neighbor_delete
+*********/
+
+/****f* OpenSM: DB-Pack/osm_db_neighbor_get
+* NAME
+*	osm_db_neighbor_get
+*
+* DESCRIPTION
+*	Get a neighbor's guid by given guid/port.
+*
+* SYNOPSIS
+*/
+int osm_db_neighbor_get(IN osm_db_domain_t * p_neighbor, IN uint64_t guid1,
+			IN uint8_t port1, OUT uint64_t * p_guid2,
+			OUT uint8_t * p_port2);
+/*
+* PARAMETERS
+*	p_neighbor
+*		[in] Pointer to the neighbor domain
+*
+*  guid1
+*     [in] The guid to look for
+*
+*  port1
+*     [in] The port to look for
+*
+*  p_guid2
+*     [out] Pointer to the resulting guid of the neighboring port.
+*
+*  p_port2
+*     [out] Pointer to the resulting port of the neighboring port.
+*
+* RETURN VALUES
+*	0 if successful. The lid will be set to 0 if not found.
+*
+* SEE ALSO
+* osm_db_neighbor_init, osm_db_neighbor_guids
+* osm_db_neighbor_set, osm_db_neighbor_delete
+*********/
+
+/****f* OpenSM: DB-Pack/osm_db_neighbor_set
+* NAME
+*	osm_db_neighbor_set
+*
+* DESCRIPTION
+*	Set up a relationship between two ports
+*
+* SYNOPSIS
+*/
+int osm_db_neighbor_set(IN osm_db_domain_t * p_neighbor, IN uint64_t guid1,
+			IN uint8_t port1, IN uint64_t guid2, IN uint8_t port2);
+/*
+* PARAMETERS
+*	p_neighbor
+*		[in] Pointer to the neighbor domain
+*
+*  guid1
+*     [in] The first guid in the relationship
+*
+*  port1
+*     [in] The first port in the relationship
+*
+*  guid2
+*     [in] The second guid in the relationship
+*
+*  port2
+*     [in] The second port in the relationship
+*
+* RETURN VALUES
+*	0 if successful
+*
+* SEE ALSO
+* osm_db_neighbor_init, osm_db_neighbor_guids
+* osm_db_neighbor_get, osm_db_neighbor_delete
+*********/
+
+/****f* OpenSM: DB-Pack/osm_db_neighbor_delete
+* NAME
+*	osm_db_neighbor_delete
+*
+* DESCRIPTION
+*	Delete the relationship between two ports
+*
+* SYNOPSIS
+*/
+int osm_db_neighbor_delete(IN osm_db_domain_t * p_neighbor,
+			   IN uint64_t guid, IN uint8_t port);
+/*
+* PARAMETERS
+*	p_neighbor
+*		[in] Pointer to the neighbor domain
+*
+*  guid
+*     [in] The guid to look for
+*
+*  port
+*     [in] The port to look for
+*
+* RETURN VALUES
+*	0 if successful otherwise 1
+*
+* SEE ALSO
+* osm_db_neighbor_init, osm_db_neighbor_guids
+* osm_db_neighbor_get, osm_db_neighbor_set
+*********/
+
 END_C_DECLS
 #endif				/* _OSM_DB_PACK_H_ */
diff --git a/include/opensm/osm_subnet.h b/include/opensm/osm_subnet.h
index 8e96314..b4deb15 100644
--- a/include/opensm/osm_subnet.h
+++ b/include/opensm/osm_subnet.h
@@ -589,6 +589,7 @@ typedef struct osm_subn {
 	unsigned need_update;
 	cl_fmap_t mgrp_mgid_tbl;
 	osm_db_domain_t *p_g2m;
+	osm_db_domain_t *p_neighbor;
 	void *mboxes[IB_LID_MCAST_END_HO - IB_LID_MCAST_START_HO + 1];
 } osm_subn_t;
 /*
diff --git a/opensm/osm_db_pack.c b/opensm/osm_db_pack.c
index 3fea4a2..b4907c1 100644
--- a/opensm/osm_db_pack.c
+++ b/opensm/osm_db_pack.c
@@ -93,6 +93,37 @@ static inline uint64_t unpack_mkey(char *p_mkey_str)
 	return strtoull(p_mkey_str, NULL, 0);
 }
 
+static inline void pack_neighbor(uint64_t guid, uint8_t portnum, char *p_str)
+{
+	sprintf(p_str, "0x%016" PRIx64 ":%u", guid, portnum);
+}
+
+static inline int unpack_neighbor(char *p_str, uint64_t *guid,
+				  uint8_t *portnum)
+{
+	char tmp_str[24];
+	char *p_num, *p_next;
+	unsigned long tmp_port;
+
+	strncpy(tmp_str, p_str, 23);
+	tmp_str[23] = '\0';
+	p_num = strtok_r(tmp_str, ":", &p_next);
+	if (!p_num)
+		return 1;
+	if (guid)
+		*guid = strtoull(p_num, NULL, 0);
+
+	p_num = strtok_r(NULL, ":", &p_next);
+	if (!p_num)
+		return 1;
+	if (portnum) {
+		tmp_port = strtoul(p_num, NULL, 0);
+		CL_ASSERT(tmp_port < 0x100);
+		*portnum = (uint8_t) tmp_port;
+	}
+
+	return 0;
+}
 
 int osm_db_guid2lid_guids(IN osm_db_domain_t * p_g2l,
 			  OUT cl_qlist_t * p_guid_list)
@@ -222,3 +253,75 @@ int osm_db_guid2mkey_delete(IN osm_db_domain_t * p_g2m, IN uint64_t guid)
 	pack_guid(guid, guid_str);
 	return osm_db_delete(p_g2m, guid_str);
 }
+
+int osm_db_neighbor_guids(IN osm_db_domain_t * p_neighbor,
+			  OUT cl_qlist_t * p_neighbor_list)
+{
+	char *p_key;
+	cl_list_t keys;
+	osm_db_neighbor_elem_t *p_neighbor_elem;
+
+	cl_list_construct(&keys);
+	cl_list_init(&keys, 10);
+
+	if (osm_db_keys(p_neighbor, &keys))
+		return 1;
+
+	while ((p_key = cl_list_remove_head(&keys)) != NULL) {
+		p_neighbor_elem =
+		    (osm_db_neighbor_elem_t *) malloc(sizeof(osm_db_neighbor_elem_t));
+		CL_ASSERT(p_neighbor_elem != NULL);
+
+		unpack_neighbor(p_key, &p_neighbor_elem->guid,
+				&p_neighbor_elem->portnum);
+		cl_qlist_insert_head(p_neighbor_list, &p_neighbor_elem->item);
+	}
+
+	cl_list_destroy(&keys);
+	return 0;
+}
+
+int osm_db_neighbor_get(IN osm_db_domain_t * p_neighbor, IN uint64_t guid1,
+			IN uint8_t portnum1, OUT uint64_t * p_guid2,
+			OUT uint8_t * p_portnum2)
+{
+	char neighbor_str[24];
+	char *p_other_str;
+	uint64_t temp_guid;
+	uint8_t temp_portnum;
+
+	pack_neighbor(guid1, portnum1, neighbor_str);
+	p_other_str = osm_db_lookup(p_neighbor, neighbor_str);
+	if (!p_other_str)
+		return 1;
+	if (unpack_neighbor(p_other_str, &temp_guid, &temp_portnum))
+		return 1;
+
+	if (p_guid2)
+		*p_guid2 = temp_guid;
+	if (p_portnum2)
+		*p_portnum2 = temp_portnum;
+
+	return 0;
+}
+
+int osm_db_neighbor_set(IN osm_db_domain_t * p_neighbor, IN uint64_t guid1,
+			IN uint8_t portnum1, IN uint64_t guid2,
+			IN uint8_t portnum2)
+{
+	char n1_str[24], n2_str[24];
+
+	pack_neighbor(guid1, portnum1, n1_str);
+	pack_neighbor(guid2, portnum2, n2_str);
+
+	return osm_db_update(p_neighbor, n1_str, n2_str);
+}
+
+int osm_db_neighbor_delete(IN osm_db_domain_t * p_neighbor, IN uint64_t guid,
+			   IN uint8_t portnum)
+{
+	char n_str[24];
+
+	pack_neighbor(guid, portnum, n_str);
+	return osm_db_delete(p_neighbor, n_str);
+}
diff --git a/opensm/osm_node_info_rcv.c b/opensm/osm_node_info_rcv.c
index 7d2675f..50df519 100644
--- a/opensm/osm_node_info_rcv.c
+++ b/opensm/osm_node_info_rcv.c
@@ -61,6 +61,7 @@
 #include <opensm/osm_msgdef.h>
 #include <opensm/osm_opensm.h>
 #include <opensm/osm_ucast_mgr.h>
+#include <opensm/osm_db_pack.h>
 
 static void report_duplicated_guid(IN osm_sm_t * sm, osm_physp_t * p_physp,
 				   osm_node_t * p_neighbor_node,
@@ -132,7 +133,7 @@ static void ni_rcv_set_links(IN osm_sm_t * sm, osm_node_t * p_node,
 			     const osm_ni_context_t * p_ni_context)
 {
 	osm_node_t *p_neighbor_node;
-	osm_physp_t *p_physp;
+	osm_physp_t *p_physp, *p_remote_physp;
 
 	OSM_LOG_ENTER(sm->p_log);
 
@@ -243,6 +244,20 @@ static void ni_rcv_set_links(IN osm_sm_t * sm, osm_node_t * p_node,
 	osm_node_link(p_node, port_num, p_neighbor_node,
 		      p_ni_context->port_num);
 
+	p_physp = osm_node_get_physp_ptr(p_node, port_num);
+	p_remote_physp = osm_node_get_physp_ptr(p_neighbor_node,
+						p_ni_context->port_num);
+	osm_db_neighbor_set(sm->p_subn->p_neighbor,
+			    cl_ntoh64(osm_physp_get_port_guid(p_physp)),
+			    port_num,
+			    cl_ntoh64(osm_physp_get_port_guid(p_remote_physp)),
+			    p_ni_context->port_num);
+	osm_db_neighbor_set(sm->p_subn->p_neighbor,
+			    cl_ntoh64(osm_physp_get_port_guid(p_remote_physp)),
+			    p_ni_context->port_num,
+			    cl_ntoh64(osm_physp_get_port_guid(p_physp)),
+			    port_num);		
+
 _exit:
 	OSM_LOG_EXIT(sm->p_log);
 }
diff --git a/opensm/osm_req.c b/opensm/osm_req.c
index ee13517..5fe378e 100644
--- a/opensm/osm_req.c
+++ b/opensm/osm_req.c
@@ -100,7 +100,7 @@ static ib_net64_t req_determine_mkey(IN osm_sm_t * sm,
 	}
 
 	/* At this point, p_physp points at the outgoing physp on the
-	   last hop, or NULL if we don't know it.
+   	   last hop, or NULL if we don't know it.
 	*/
 	if (!p_physp) {
 		OSM_LOG(sm->p_log, OSM_LOG_ERROR,
@@ -115,6 +115,15 @@ static ib_net64_t req_determine_mkey(IN osm_sm_t * sm,
 		goto Remote_Guid;
 	}
 
+	OSM_LOG(sm->p_log, OSM_LOG_DEBUG, "Target port guid unknown, "
+		"using persistent DB\n");
+	if (!osm_db_neighbor_get(sm->p_subn->p_neighbor,
+			 	cl_ntoh64(p_physp->port_guid),
+			 	p_physp->port_num,
+			 	&dest_port_guid, NULL)) {
+		dest_port_guid = cl_hton64(dest_port_guid);
+	}
+
 Remote_Guid:
 	if (dest_port_guid) {
 		if (!osm_db_guid2mkey_get(sm->p_subn->p_g2m,
diff --git a/opensm/osm_state_mgr.c b/opensm/osm_state_mgr.c
index 4d5da46..e44715e 100644
--- a/opensm/osm_state_mgr.c
+++ b/opensm/osm_state_mgr.c
@@ -1456,6 +1456,7 @@ repeat_discovery:
 
 	/* Write a new copy of our persistent guid2mkey database */
 	osm_db_store(sm->p_subn->p_g2m);
+	osm_db_store(sm->p_subn->p_neighbor);
 }
 
 static void do_process_mgrp_queue(osm_sm_t * sm)
diff --git a/opensm/osm_subnet.c b/opensm/osm_subnet.c
index 4f5272f..bb69a66 100644
--- a/opensm/osm_subnet.c
+++ b/opensm/osm_subnet.c
@@ -471,6 +471,79 @@ Exit:
 	OSM_LOG_EXIT(&(p_subn->p_osm->log));
 }
 
+static void subn_validate_neighbor(osm_subn_t *p_subn)
+{
+	cl_qlist_t entries;
+	osm_db_neighbor_elem_t *p_item;
+	boolean_t valid_entry;
+	uint64_t guid;
+	uint8_t port;
+
+	OSM_LOG_ENTER(&(p_subn->p_osm->log));
+	cl_qlist_init(&entries);
+
+	if (osm_db_neighbor_guids(p_subn->p_neighbor, &entries)) {
+		OSM_LOG(&(p_subn->p_osm->log), OSM_LOG_ERROR, "ERR 7512: "
+			"could not get neighbor entry list\n");
+		goto Exit;
+	}
+
+	while ((p_item = (osm_db_neighbor_elem_t *) cl_qlist_remove_head(&entries))
+	       != (osm_db_neighbor_elem_t *) cl_qlist_end(&entries)) {
+		valid_entry = TRUE;
+
+		OSM_LOG(&(p_subn->p_osm->log), OSM_LOG_DEBUG,
+			"Validating neighbor for 0x%016" PRIx64 ", port %d\n",
+			p_item->guid, p_item->portnum);
+		if (p_item->guid == 0) {
+			OSM_LOG(&(p_subn->p_osm->log), OSM_LOG_ERROR,
+				"ERR 7513: found invalid zero guid\n");
+			valid_entry = FALSE;
+		} else if (p_item->portnum == 0) {
+			OSM_LOG(&(p_subn->p_osm->log), OSM_LOG_ERROR,
+				"ERR 7514: found invalid zero port\n");
+			valid_entry = FALSE;
+		} else if (osm_db_neighbor_get(p_subn->p_neighbor,
+					       p_item->guid, p_item->portnum,
+					       &guid, &port)) {
+			OSM_LOG(&(p_subn->p_osm->log), OSM_LOG_ERROR,
+				"ERR 7515: could not find neighbor for "
+				"guid: 0x%016" PRIx64 "\n", p_item->guid);
+			valid_entry = FALSE;
+		} else if (guid == 0) {
+			OSM_LOG(&(p_subn->p_osm->log), OSM_LOG_ERROR,
+				"ERR 7516: found invalid neighbor "
+				"zero guid");
+			valid_entry = FALSE;
+		} else if (port == 0) {
+			OSM_LOG(&(p_subn->p_osm->log), OSM_LOG_ERROR,
+				"ERR 7517: found invalid neighbor "
+				"zero port\n");
+			valid_entry = FALSE;
+		} else if (osm_db_neighbor_get(p_subn->p_neighbor,
+					       guid, port, &guid, &port) ||
+                           guid != p_item->guid || port != p_item->portnum) {
+			OSM_LOG(&(p_subn->p_osm->log), OSM_LOG_ERROR,
+				"ERR 7518: neighbor does not point "
+				"back at us\n");
+			valid_entry = FALSE;
+		}
+
+		if (valid_entry == FALSE) {
+			if (osm_db_neighbor_delete(p_subn->p_neighbor,
+						   p_item->guid,
+						   p_item->portnum))
+                                OSM_LOG(&(p_subn->p_osm->log), OSM_LOG_ERROR,
+                                        "ERR 7519: failed to delete entry for "
+                                        "guid:0x%016" PRIx64 " port:%u\n",
+                                        p_item->guid, p_item->portnum);
+		}
+	}
+
+Exit:
+	OSM_LOG_EXIT(&(p_subn->p_osm->log));
+}
+
 void osm_subn_construct(IN osm_subn_t * p_subn)
 {
 	memset(p_subn, 0, sizeof(*p_subn));
@@ -706,6 +779,35 @@ ib_api_status_t osm_subn_init(IN osm_subn_t * p_subn, IN osm_opensm_t * p_osm,
 
 	subn_validate_g2m(p_subn);
 
+	/* Initialize the neighbor database */
+	p_subn->p_neighbor = osm_db_domain_init(&(p_osm->db), "neighbors");
+	if (!p_subn->p_neighbor) {
+		OSM_LOG(&(p_osm->log), OSM_LOG_ERROR, "ERR 7520: Error "
+			"initializing neighbor link persistent database\n");
+		return IB_ERROR;
+	}
+
+	if (osm_db_restore(p_subn->p_neighbor)) {
+#ifndef __WIN__
+		/*
+		 * When Windows is BSODing, it might corrupt files that
+		 * were previously opened for writing, even if the files
+		 * are closed, so we might see corrupted neighbors file.
+		 */
+		if (p_subn->opt.exit_on_fatal) {
+			osm_log(&(p_osm->log), OSM_LOG_SYS, 
+				"FATAL: Error restoring neighbor link "
+				"persistent database\n");
+			return IB_ERROR;
+		} else
+#endif
+			OSM_LOG(&(p_osm->log), OSM_LOG_ERROR,
+				"ERR 7521: Error restoring neighbor link "
+				"persistent database\n");
+	}
+
+	subn_validate_neighbor(p_subn);
+
 	return IB_SUCCESS;
 }
 
-- 
1.7.9.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
